using Random
# Random.seed!(1234)

function MH_prob(T)
    β = 1/T
    prob_acc = Array{Float64}(undef,5)
    for (i,spin_sum) in pairs(-4:2:4)
        prob_acc[i] = exp(-2*spin_sum*β)
    end 
    return prob_acc
end

function MH_step(L::Int,neighbours, spins, prob_acc)
    num_spins = L^2
    flipped_index = rand(1:num_spins)
    spin_up = spins[neighbours[flipped_index,1]]
    spin_down = spins[neighbours[flipped_index,2]]
    spin_right = spins[neighbours[flipped_index,3]]
    spin_left = spins[neighbours[flipped_index,4]]
    spin_sum = spin_up + spin_down + spin_right + spin_left
    prob_acc_index = spins[flipped_index]*div(spin_sum,2)+3 
    if rand() < prob_acc[prob_acc_index]
        spins[flipped_index] = -spins[flipped_index]
    end
    return spins
end