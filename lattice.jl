
function get_neighbours(L::Int) # 2D sqaure lattice with PBC
    num_spins = L^2
    neighbours = Array{Int}(undef,num_spins,4)
    for spin in (1:num_spins)
        y_pos = div(spin-1,L)
        x_pos = mod(spin-1,L)
        neighbours[spin,1]=mod(y_pos+(L-1),L)*L+x_pos+1 # up
        neighbours[spin,2]=mod(y_pos+1,L)*L+x_pos+1 # down
        neighbours[spin,3]=mod(spin,L)+1+y_pos*L # right
        neighbours[spin,4]=mod(spin-1+(L-1),L)+1+y_pos*L # left
    end
    return neighbours
end

function random_config(L::Int)
    num_spins = L^2
    spins = Array{Int32}(undef,num_spins)
    for i in (1:num_spins) 
        spins[i]=rand(-1:2:1)
    end
    return spins
end

function config_info(L::Int, spins, neighbours)
    N = L^2
    energy_i = 0
    for i in (1:N)
        neigh_down = neighbours[i,2]
        neigh_right = neighbours[i,3]
        energy_i += -1*spins[i]*(spins[neigh_down]+spins[neigh_right])
    end
    m_i = sum(spins)
    return energy_i, (energy_i)^2, abs(m_i), (m_i)^2 
end
