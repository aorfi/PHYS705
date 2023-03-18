using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2

include("lattice.jl")
include("local_updates.jl")


function CFTP_step(L,neighbours,T)
    N=L^2
    num_steps = 10^8
    fixed_rands = rand(Float64, num_steps)
    fixed_rand_spin = rand(1:N, num_steps)
    spins_top = ones(Int32,N)
    spins_bottom = -1*ones(Int32,N)
    collision = 0 
    for i in (1:num_steps)
        current_rand = fixed_rands[i]
        current_rand_spin = fixed_rand_spin[i]
        spins_top = glauber_step(L, neighbours, spins_top,T,current_rand_spin,current_rand)
        spins_bottom = glauber_step(L, neighbours, spins_bottom,T,current_rand_spin,current_rand)
        if spins_top  ==  spins_bottom
            println("they are the same on iteration ", i)
            collision = i
            break
        end
    end
    return spins_top, collision
end




# num_runs = 10
# T_values = range(2,3, length=50)
# L_values = [16]

# for L in L_values
#     N = L^2
#     obs = zeros(N,num_runs,length(T_values))
#     neigh = get_neighbours(L)
#     for (j,T) in pairs(T_values)
#         println("current T ", T)
#         for i in (1:num_runs)
#             println("iteration ", i)
#             spins, collision = CFTP_step(L,neigh,T)
#             obs[:,i,j] = spins
#         end
#     end
#     name = "Data/Ising/T2-3CFTPL"*string(L)
#     save_object(name, obs)
# end




L_values = [16]
num_runs = 2
for L in L_values
    N = L^2
    neigh = get_neighbours(L)
    T_values = range(2,3, length=50)
    name = "Data/Ising/T2-3CFTPL"*string(L)
    obs = load_object(name) 
    m_av_T = []
    for (j,T) in pairs(T_values)
        e_av, e2_av, m_av, m2_av = 0,0,0,0
        for i in (1:num_runs)
            spins = obs[:,i,j]
            e, e2, m, m2, config = config_info(L, spins, neigh)
            e_av += 1/num_runs*e
            e2_av += 1/num_runs*e2
            m_av += 1/num_runs*m
            m2_av += 1/num_runs*m2
        end
        append!(m_av_T,m_av)
    end
    plt.scatter(T_values,m_av_T/N, label = "L = "*string(L))
    # plt.plot(T_values,e_av_T)
end
plt.xlabel("T")
plt.ylabel("|M|/N")
Tc = 2/log(1+sqrt(2))
plt.axvline(Tc)
plt.legend()
plt.show()