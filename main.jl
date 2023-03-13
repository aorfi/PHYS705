using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings


include("lattice.jl")
include("MH.jl")
include("Wolff.jl")



L= 16
β = 1
T = 1/β
N = L^2
neigh = get_neighbours(L)

spins_MH = random_config(L)
spins_Wolff = random_config(L)
e_MH = []
e_Wolff = []
num_steps = 10^3
for i in (1:num_steps)
    global spins_MH = MH_step(L,neigh, spins_MH, MH_prob(T))
    m_i,e_i = config_info(L, spins_MH, neigh)
    global spins_Wolff = Wolff_step(spins_Wolff,T)
    append!(e_MH,e_i/N)
    m_i,e_i = config_info(L, spins_Wolff, neigh)
    append!(e_Wolff,e_i/N)
end
plt.plot((1:num_steps),e_MH, label="MH")
plt.plot((1:num_steps),e_Wolff, label = "Wolff")
plt.legend()
plt.show()