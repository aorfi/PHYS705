using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings


include("../lattice.jl")
include("configs_info.jl")
include("updates.jl")



L= 16
# β = 0.1
T=1
N = L^2
neigh = get_neighbours(L)

spins_MH = random_config(L)
spins_glaub = random_config(L)
spins_Wolff = random_config(L)
e_MH = []
e_glaub = []
e_Wolff = []


num_steps = 10^6
for i in (1:num_steps)
    global spins_MH = MH_step(L,neigh, spins_MH, T)
    e, e2, m, m2, config = config_info(L, spins_MH, neigh)
    append!(e_MH,e/N)
    # global spins_glaub = glauber_step(L,neigh, spins_glaub,T)
    # e, e2, m, m2, config = config_info(L, spins_glaub, neigh)
    # append!(e_glaub,e/N)
    # global spins_Wolff = Wolff_step(spins_Wolff,T,N,neigh)
    # e, e2, m, m2, config  = config_info(L, spins_Wolff, neigh)
    # append!(e_Wolff,m)
end
plt.plot((1:num_steps),e_MH, label="HM")
# plt.plot((1:num_steps),e_glaub, label="Glauber")
# plt.plot((1:num_steps),e_Wolff, label = "Wolff")
plt.legend()
plt.show()
# num_discard = 100
# m_av = 1/(num_steps-num_discard)*sum(e_Wolff[num_discard:end])
# println(m_av)

