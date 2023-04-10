using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings


include("../lattice.jl")
include("configs_info.jl")
include("updates.jl")



L= 16
# β = 0.1
T = 10
N = L^2
neigh = get_neighbours(L)
spins_angles = random_angles(L)
e = xy_energy(L,spins_angles,neigh)
e_rand = []
acceptance_rand = []

num_steps = 10^6
@time begin
for i in (1:num_steps)
    angles, e_current, accepted = random_update(L,neigh, spins_angles,T,e)
    global e = e_current
    global spins_angles = angles
    append!(e_rand, e/N)
    append!(acceptance_rand, accepted)
end
end
acceptance_rate = sum(acceptance_rand)/num_steps
println("Acceptance Rate ", acceptance_rate)
plt.plot((1:num_steps),e_rand, label="Random")
plt.legend()
plt.show()