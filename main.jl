using Random
using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
# Random.seed!(1234)

function get_neighbours(L::Int) # 2D sqaure lattice with PBC
    num_spins = L^2
    neighbours = Array{Int}(undef,num_spins,4)
    for spin in (1:num_spins)
        y_pos = div(spin-1,L)
        x_pos = mod(spin-1,L)
        neighbours[spin,1]=mod(y_pos+(L-1),L)*L+x_pos+1 # up
        neighbours[spin,2]=mod(y_pos+1,L)*L+x_pos+1 # down
        neighbours[spin,3]=mod(spin,L)+1+y_pos*L # right
        neighbours[spin,4]=mod(spin-1+(L-1),L)+1+y_pos*L # left
    end
    return neighbours
end

function MH_prob(β)
    prob_acc = Array{Float64}(undef,5)
    for (i,spin_sum) in pairs(-4:2:4)
        prob_acc[i] = exp(-2*spin_sum*β)
    end 
    return prob_acc
end

function MH_step(L::Int,neighbours, spins, prob_acc)
    num_spins = L^2
    flipped_index = rand(1:num_spins)
    spin_up = spins[neighbours[flipped_index,1]]
    spin_down = spins[neighbours[flipped_index,2]]
    spin_right = spins[neighbours[flipped_index,3]]
    spin_left = spins[neighbours[flipped_index,4]]
    spin_sum = spin_up + spin_down + spin_right + spin_left
    prob_acc_index = spins[flipped_index]*div(spin_sum,2)+3 
    if rand() < prob_acc[prob_acc_index]
        spins[flipped_index] = -spins[flipped_index]
    end
    return spins
end

function random_config(L::Int)
    num_spins = L^2
    spins = Array{Int32}(undef,num_spins)
    for i in (1:num_spins) 
        spins[i]=rand(-1:2:1)
    end
    return spins
end

function config_info(L::Int, spins, neighbours)
    num_spins = L^2
    energy_i = 0
    for i in (1:num_spins)
        neigh_down = neighbours[i,2]
        neigh_right = neighbours[i,3]
        energy_i += -1*spins[i]*(spins[neigh_down]+spins[neigh_right])
    end
    m_i = sum(spins)
    return m_i, energy_i
end


L= 16
β = 10
N = L^2
neigh = get_neighbours(L)
# display(neigh)



spins = random_config(L)
e = []
e_sum = 0 
e_avg = []
num_runs = 100000
for i in (1:num_runs)
    global spins = MH_step(L,neigh, spins, MH_prob(β))
    # display(reshape(spins,(L,L)))
    m_i,e_i = config_info(L, spins, neigh)
    append!(e,e_i/N)
    global e_sum += e_i/N
    append!(e_avg, e_sum/i)
end
plt.plot((1:num_runs)[100:end],e[100:end])
plt.plot((1:num_runs)[100:end],e_avg[100:end])

plt.show()