include("lattice.jl")


function Wolff_step(spins,T)
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




