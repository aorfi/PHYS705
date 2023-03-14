using JLD2

include("lattice.jl")
include("MH.jl")
include("Wolff.jl")


num_steps = 10^5
bin_size = 200
num_bins = Int(num_steps/bin_size)
println("Number of bins ", num_bins)
T_values = range(1,4, length=50)
bin_av_T = zeros(4,num_bins,length(T_values))


L_values = [8]

for L in L_values
    N = L^2
    neigh = get_neighbours(L)
    for (j,T) in pairs(T_values)
        println("current T ", T)
        bin_av = zeros(4,num_bins)
        spins_Wolff = random_config(L)
        info_in_bin = zeros(bin_size, 4)
        for i in (1:num_steps)
            spins_Wolff = Wolff_step(spins_Wolff,T,N,neigh)
            e, e2, m, m2  = config_info(L, spins_Wolff, neigh)
            info_in_bin[i%bin_size+1,:] = [e, e2, m, m2]
            if i%bin_size == 0 
                e_av = 1/(bin_size)*sum(info_in_bin[:,1])
                e2_av = 1/(bin_size)*sum(info_in_bin[:,2])
                m_av = 1/(bin_size)*sum(info_in_bin[:,3])
                m2_av = 1/(bin_size)*sum(info_in_bin[:,4])
                bin_av[:,Int(i/bin_size)] = [e_av, e2_av, m_av, m2_av]
                info_in_bin = zeros(bin_size, 4)
            end
        end
        bin_av_T[:,:,j] = bin_av 
    end
    name = "Data/Ising/L"*string(L)
    save_object(name, bin_av_T)
end
