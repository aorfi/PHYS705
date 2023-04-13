using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings


include("../../lattice.jl")
include("../configs_info.jl")
include("../updates.jl")



L= 16
N = L^2
neigh = get_neighbours(L)

spins_MH_1 = random_config(L)
spins_MH_3 = random_config(L)
spins_MH_c = random_config(L)
e_MH_1 = []
e_MH_3 = []
e_MH_c = []



num_steps = 10^5
for i in (1:num_steps)
    global spins_MH_1 = MH_step(L,neigh, spins_MH_1, 1)
    e1, e2, m, m2, config = config_info(L, spins_MH_1, neigh)
    append!(e_MH_1,e1/N)
    global spins_MH_3 = MH_step(L,neigh, spins_MH_3, 1/3)
    e3, e2, m, m2, config = config_info(L, spins_MH_3, neigh)
    append!(e_MH_3,e3/N)
    global spins_MH_c = MH_step(L,neigh, spins_MH_c, 2)
    ec, e2, m, m2, config = config_info(L, spins_MH_c, neigh)
    append!(e_MH_c,ec/N)

end
plt.plot((1:num_steps),e_MH_c, label=L"$\beta = 1/2$")
plt.plot((1:num_steps),e_MH_1, label=L"$\beta = 1$")
plt.plot((1:num_steps),e_MH_3, label=L"$\beta = 3$")

plt.ylabel(L"$\langle E\rangle /N$")
plt.xlabel(L"$t$")
# plt.title(L"Estimated Energy with MCMC Iteration $L=16$")
plt.legend()
plt.grid()
name = "Figures/Ising/energy_iteration.png"
plt.savefig(name)
plt.show()

