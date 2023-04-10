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


