using Random
using Distributions

function random_update(L::Int,neighbours, spins_angles,T,energy_current)
    proposed_spins_angles = random_angles(L)
    energy_proposed = xy_energy(L,proposed_spins_angles,neighbours)
    prob_acc = exp((energy_current - energy_proposed)/T)
    accepted = 0
    if rand() < prob_acc
        new_spins_angles = proposed_spins_angles
        energy_current = energy_proposed
        accepted = 1
    else
        new_spins_angles = spins_angles
    end
    return new_spins_angles, energy_current, accepted
end

function Wolff_step(L::Int,neighbours, spins_angles,T)
    # angle defining flipping axis 
    N = L^2
    α = rand(Uniform(0,2*pi))
    cluster = []
    spins_to_check = []
    initial_spin = rand(1:N)
    append!(cluster, initial_spin)
    append!(spins_to_check, initial_spin)
    while !isempty(spins_to_check) 
        # check all neighbours of spins_to_check
        spin_being_checked = spins_to_check[1]
        θ = spins_angles[spin_being_checked]
        all_neighbours = neighbours[spin_being_checked ,:]
        neigh_not_in_cluster = setdiff(all_neighbours,cluster)
        for i in neigh_not_in_cluster
            θ_neigh = spins_angles[i]
            prob = 1-exp(min(0,-(2/T)*cos(θ-α)*cos(θ_neigh-α)))
            # println((2/T)*cos(θ-α)*cos(θ_neigh-α))
            # println(prob)
            if rand() < prob
                append!(cluster, i)
                append!(spins_to_check, i)
            end

        end
        #remove the one we just checked
        popfirst!(spins_to_check)
    end
    for i in cluster
        spins_angles[i] = mod((π +2*α - spins_angles[i]),2*π)
    end
    return spins_angles
end

