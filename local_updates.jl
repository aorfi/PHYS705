using Random
# Random.seed!(1234)

function update_prob(T)
    β = 1/T
    prob_acc = Array{Float64}(undef,5)
    for (i,spin_sum) in pairs(-4:2:4)
        prob_acc[i] = exp(-2*spin_sum*β)
    end 
    return prob_acc
end

function MH_step(L::Int,neighbours, spins,T)
    num_spins = L^2
    flipped_index = rand(1:num_spins)
    spin_up = spins[neighbours[flipped_index,1]]
    spin_down = spins[neighbours[flipped_index,2]]
    spin_right = spins[neighbours[flipped_index,3]]
    spin_left = spins[neighbours[flipped_index,4]]
    spin_sum = spin_up + spin_down + spin_right + spin_left
    prob_acc = update_prob(T)
    prob_acc_index = spins[flipped_index]*div(spin_sum,2)+3 
    if rand() < prob_acc[prob_acc_index]
        spins[flipped_index] = -spins[flipped_index]
    end
    return spins
end

function glauber_step(L::Int,neighbours, spins, T)
    num_spins = L^2
    flipped_index = rand(1:num_spins)
    spin_up = spins[neighbours[flipped_index,1]]
    spin_down = spins[neighbours[flipped_index,2]]
    spin_right = spins[neighbours[flipped_index,3]]
    spin_left = spins[neighbours[flipped_index,4]]
    spin_sum = spin_up + spin_down + spin_right + spin_left
    prob = 1/(1+exp(-2*spin_sum/T))
    # prob_acc = update_prob(T)
    # prob_acc_index = spins[flipped_index]*div(spin_sum,2)+3 
    if rand() < prob #prob_acc[prob_acc_index]/(1+prob_acc[prob_acc_index])
        spins[flipped_index] = 1
    else
        spins[flipped_index] = -1
    end 
    return spins
end


function glauber_step(L::Int,neighbours, spins, T, rand_spin , rand_num )
    num_spins = L^2
    flipped_index = rand_spin
    spin_up = spins[neighbours[flipped_index,1]]
    spin_down = spins[neighbours[flipped_index,2]]
    spin_right = spins[neighbours[flipped_index,3]]
    spin_left = spins[neighbours[flipped_index,4]]
    spin_sum = spin_up + spin_down + spin_right + spin_left
    prob = 1/(1+exp(-2*spin_sum/T))
    if rand_num < prob 
        spins[flipped_index] = 1
    else
        spins[flipped_index] = -1
    end 
    return spins
end
