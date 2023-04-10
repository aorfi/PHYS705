using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings


include("../lattice.jl")


function xy_energy(L::Int, spins_angles, neighbours)
    N=L^2
    energy = 0 
    for i in (1:N)
        current_spin = spins_angles[i]
        neigh_down = neighbours[i,2]
        neigh_right = neighbours[i,3]
        energy += -1*cos(current_spin - spins_angles[neigh_down])
        energy += -1*cos(current_spin - spins_angles[neigh_right])
    end
    return energy
end


function random_update(L::Int,neighbours, spins_angles,T)
    energy_current = xy_energy(L,spins_angles,neighbours)
    proposed_spins_angles = random_angles(L)
    energy_proposed = xy_energy(L,proposed_spins_angles,neighbours)
    prob_acc = exp((energy_current - energy_proposed)/T)
    if rand() < prob_acc
        spins_angles = proposed_spins_angles
    end
    return spins_angles
end

L= 2
# β = 0.1
T = 0.5
N = L^2
neigh = get_neighbours(L)
# spins_angles = zeros(N)
# println(spins_angles)
# println(xy_energy(L,spins_angles,neigh))
spins_angles = random_angles(L)
println(spins_angles)
display(xy_energy(L,spins_angles,neigh))
for i in (1:100)
    global spins_angles = random_update(L,neigh, spins_angles,T)
    println(xy_energy(L,spins_angles,neigh))
end