using Random
# Random.seed!(1234)
include("../lattice.jl")

function HM_update_prob(T)
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
    prob_acc = MH_update_prob(T)
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
    if rand() < prob 
        spins[flipped_index] = 1
    else
        spins[flipped_index] = -1
    end 
    return spins
end

function glauber_step(L::Int,neighbours, spins, T, rand_spin , rand_num )
    # This is for CPTP where you need to keep track of the random numbers
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

function Wolff_step(spins,T,N,neigh)
    prob = 1-exp(-2/T)
    cluster = []
    spins_to_check = []
    initial_spin = rand(1:N)
    append!(cluster, initial_spin)
    append!(spins_to_check, initial_spin)
    while !isempty(spins_to_check) 
        # check all neighbours of spins_to_check
        spin_being_checked = spins_to_check[1]
        value = spins[spin_being_checked]
        all_neighbours = neigh[spin_being_checked ,:]
        neigh_not_in_cluster = setdiff(all_neighbours,cluster)
        for i in neigh_not_in_cluster
            if spins[i] == value
                # add neighbouring spins to cluster with prob if have same sign 
                if rand() < prob
                    append!(cluster, i)
                    append!(spins_to_check, i)
                end
            end
        end
        #remove the one we just checked
        popfirst!(spins_to_check)
    end
    for i in cluster
        spins[i] = -1*spins[i]
    end
    return spins
end

function CFTP_step(L,neighbours,T)
    N=L^2
    num_steps = 10^8
    fixed_rands = rand(Float64, num_steps)
    fixed_rand_spin = rand(1:N, num_steps)
    spins_top = ones(Int32,N)
    spins_bottom = -1*ones(Int32,N)
    collision = 0 
    for i in (1:num_steps)
        current_rand = fixed_rands[i]
        current_rand_spin = fixed_rand_spin[i]
        spins_top = glauber_step(L, neighbours, spins_top,T,current_rand_spin,current_rand)
        spins_bottom = glauber_step(L, neighbours, spins_bottom,T,current_rand_spin,current_rand)
        if spins_top  ==  spins_bottom
            println("they are the same on iteration ", i)
            collision = i
            break
        end
    end
    return spins_top, collision
end




