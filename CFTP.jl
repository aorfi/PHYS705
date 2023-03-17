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




num_runs = 1
T_values = range(1,4, length=100)
L_values = [32]
obs = zeros(4,length(T_values))
for L in L_values
    N = L^2
    neigh = get_neighbours(L)
    for (j,T) in pairs(T_values)
        println("current T ", T)
        e_av, e2_av, m_av, m2_av = 0,0,0,0
        for i in (1:num_runs)
            spins, collision = CFTP_step(L,neigh,T)
            e, e2, m, m2,config  = config_info(L, spins, neigh)
            e_av += e/num_runs 
            e2_av += e2/num_runs 
            m_av += m/num_runs 
            m2_av += m2/num_runs 
        end
        obs[:,j] = [e_av, e2_av, m_av, m2_av]
    end
    name = "Data/Ising/CFTPL"*string(L)
    save_object(name, obs)
end

L_values = [16,32]
for L in L_values
    N = L^2
    T_values = range(1,4, length=100)
    name = "Data/Ising/CFTPL"*string(L)
    obs = load_object(name) 
    plt.scatter(T_values,obs[3,:]/N, label = "L = "*string(L))
    # plt.plot(T_values,e_av_T)
end
plt.xlabel("T")
plt.ylabel("|M|/N")
Tc = 2/log(1+sqrt(2))
plt.axvline(Tc)
plt.legend()
plt.show()