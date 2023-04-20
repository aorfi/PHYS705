using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings


include("../../lattice.jl")
include("../configs_info.jl")
include("../updates.jl")



# L= 16
# N = L^2
# neigh = get_neighbours(L)

# spins_MH_1 = random_config(L)
# spins_MH_3 = random_config(L)
# # spins_MH_c = random_config(L)
# e_MH_1 = []
# e_MH_3 = []
# e_av_MH_1 = []
# e_av_MH_3 = []
# e_av_1 = 0
# e_av_3 = 0



# num_steps = 10^6
# for i in (1:num_steps)
#     global spins_MH_1 = MH_step(L,neigh, spins_MH_1, 1)
#     e1, e2, m, m2, config = config_info(L, spins_MH_1, neigh)
#     global e_av_1 += e1/(N)
#     append!(e_MH_1,e1/N)
#     append!(e_av_MH_1,e_av_1/i)
#     global spins_MH_3 = MH_step(L,neigh, spins_MH_3, 1/3)
#     e3, e2, m, m2, config = config_info(L, spins_MH_3, neigh)
#     global e_av_3 += e3/(N)
#     append!(e_MH_3,e3/N)
#     append!(e_av_MH_3,e_av_3/i)
# end
# plt.plot((1:num_steps),e_MH_1, label=L"$ E/N$ $\beta = 1$", color ="tab:blue", alpha = 0.6)
# plt.plot((1:num_steps),e_av_MH_1, label=L"$\langle E\rangle /N$ $\beta = 1$", color ="tab:blue")
# plt.plot((1:num_steps),e_MH_3, label=L"$E/N$ $\beta = 3$", color ="tab:red", alpha = 0.6)
# plt.plot((1:num_steps),e_av_MH_3, label=L"$\langle E\rangle /N$ $\beta = 3$",  color ="tab:red")

# plt.ylabel(L"$E/N$")
# plt.xlabel(L"$t_{MCMC}$")
# # plt.title(L"Estimated Energy with MCMC Iteration $L=16$")
# plt.legend()
# plt.grid()
# plt.xscale("log")
# name = "Figures/Ising/energy_iteration.png"
# plt.savefig(name)
# plt.show()







L= 16
N = L^2
neigh = get_neighbours(L)

spins_MH_1 = random_config(L)
spins_MH_3 = random_config(L)
# spins_MH_c = random_config(L)
e_MH_1 = []
e_MH_3 = []
e_av_MH_1 = []
e_av_MH_3 = []
e_av_1 = 0
e_av_3 = 0

num_steps = 300
for i in (1:num_steps)
    global spins_MH_1 = Wolff_step( spins_MH_1, 1,N, neigh)
    e1, e2, m, m2, config = config_info(L, spins_MH_1, neigh)
    global e_av_1 += e1/(N)
    append!(e_MH_1,e1/N)
    append!(e_av_MH_1,e_av_1/i)
    global spins_MH_3 = Wolff_step( spins_MH_3, 1/3,N, neigh)
    e3, e2, m, m2, config = config_info(L, spins_MH_3, neigh)
    global e_av_3 += e3/(N)
    append!(e_MH_3,e3/N)
    append!(e_av_MH_3,e_av_3/i)
end

plt.plot((1:num_steps),e_MH_1, label=L"$ E/N$ $\beta = 1$", color ="tab:blue", alpha = 0.6)
plt.plot((1:num_steps),e_av_MH_1, label=L"$\langle E\rangle /N$ $\beta = 1$", color ="tab:blue")
plt.plot((1:num_steps),e_MH_3, label=L"$E/N$ $\beta = 3$", color ="tab:red", alpha = 0.6)
plt.plot((1:num_steps),e_av_MH_3, label=L"$\langle E\rangle /N$ $\beta = 3$",  color ="tab:red")

plt.ylabel(L"$E/N$")
plt.xlabel(L"$t_{MCMC}$")
# plt.title(L"Estimated Energy with MCMC Iteration $L=16$")
plt.legend()
plt.grid()
plt.xscale("log")
name = "Figures/Ising/energy_iteration_Wolff.png"
plt.savefig(name)
plt.show()