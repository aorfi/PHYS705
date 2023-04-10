using Distributions

function random_angles(L::Int)
    num_spins = L^2
    spins = rand(Uniform(0,2*pi), num_spins)
    return spins
end

function config_info(L::Int, spins_angles, neighbours)
    N = L^2
    energy_i = 0
    for i in (1:N)
        neigh_down = neighbours[i,2]
        neigh_right = neighbours[i,3]
        energy_i += -1*spins[i]*(spins[neigh_down]+spins[neigh_right])
    end
    m_i = sum(spins)
    binary = (spins .+1 )/2
    # config = parse(Int, join(string.(Int.(binary))); base=2)
    config = sum(binary)
    return energy_i, (energy_i)^2, abs(m_i), (m_i)^2, config
end