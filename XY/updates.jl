using Random

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