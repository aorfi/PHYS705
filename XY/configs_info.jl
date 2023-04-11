using Distributions

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

function random_angles(L::Int)
    num_spins = L^2
    spins = rand(Uniform(0,2*pi), num_spins)
    return spins
end

function H_x(L::Int, spins_angles, neighbours)
    N = L^2
    energy = 0 
    for i in (1:N)
        current_spin = spins_angles[i]
        neigh_right = neighbours[i,3]
        energy += cos(current_spin - spins_angles[neigh_right])
    end
    return energy
end

function I_x(L::Int, spins_angles, neighbours)
    N = L^2
    energy = 0 
    for i in (1:N)
        current_spin = spins_angles[i]
        neigh_right = neighbours[i,3]
        energy += sin(current_spin - spins_angles[neigh_right])
    end
    return (energy)^2
end

# L= 16
# # β = 0.1
# T = 10
# N = L^2
# neigh = get_neighbours(L)
# spins_angles = random_angles(L)
# println(spins_angles)
# println(H_x(L,spins_angles,neigh))
# println(I_x(L,spins_angles,neigh))