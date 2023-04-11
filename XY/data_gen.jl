using JLD2

include("../lattice.jl")
include("configs_info.jl")
include("updates.jl")


# num_discard = 10^5
# num_steps = 10^6
# bin_size = 50
# num_bins = Int(num_steps/bin_size)
# println("Number of bins ", num_bins)
# T_values = range(0,3, length=100)
# bin_av_T = zeros(4,num_bins,length(T_values))
# acceptace_rate = []

# L_values = [8]

# for L in L_values
#     N = L^2
#     neigh = get_neighbours(L)
#     for (l,T) in pairs(T_values)
#         println("current T ", T)
#         bin_av = zeros(4,num_bins)
#         spins_angles = random_angles(L)
#         e = xy_energy(L,spins_angles,neigh)
#         info_in_bin = zeros(bin_size,4)
#         acceptace_rate_T = 0
#         for i in (1:num_discard+num_steps)
#             spins_angles, e, accepted = random_update(L,neigh, spins_angles,T,e)
#             acceptace_rate_T += accepted
#             if i>num_discard
#                 j = i-num_discard
#                 H_i = H_x(L,spins_angles,neigh)
#                 I_i = I_x(L,spins_angles,neigh)
#                 info_in_bin[j%bin_size+1,:] = [e,e^2,H_i,I_i]
#                 if j%bin_size == 0 
#                     e_av = 1/(bin_size)*sum(info_in_bin[:,1])
#                     e2_av = 1/(bin_size)*sum(info_in_bin[:,2])
#                     Hx_av = 1/(bin_size)*sum(info_in_bin[:,3])
#                     Ix_av = 1/(bin_size)*sum(info_in_bin[:,4])
#                     bin_av[:,Int(j/bin_size)] = [e_av,e2_av,Hx_av,Ix_av]
#                     info_in_bin = zeros(bin_size, 4)
#                 end
#             end
#         end
#         append!(acceptace_rate,acceptace_rate_T/(num_discard+num_steps))
#         bin_av_T[:,:,l] = bin_av 
#     end
#     name = "Data/XY/av_L"*string(L)
#     save_object(name, bin_av_T)
#     name = "Data/XY/av_acc_L"*string(L)
#     save_object(name, acceptace_rate)
# end


num_discard = 500
num_steps = 10^4
bin_size = 1
num_bins = Int(num_steps/bin_size)
println("Number of bins ", num_bins)
T_values = range(0,3, length=100)
bin_av_T = zeros(4,num_bins,length(T_values))


L_values = [20]

for L in L_values
    N = L^2
    neigh = get_neighbours(L)
    for (l,T) in pairs(T_values)
        println("current T ", T)
        bin_av = zeros(4,num_bins)
        spins_angles = random_angles(L)
        e = xy_energy(L,spins_angles,neigh)
        info_in_bin = zeros(bin_size,4)
        for i in (1:num_discard+num_steps)
            spins_angles = Wolff_step(L,neigh,spins_angles,T)
            e =  xy_energy(L, spins_angles, neigh)
            if i>num_discard
                j = i-num_discard
                H_i = H_x(L,spins_angles,neigh)
                I_i = I_x(L,spins_angles,neigh)
                info_in_bin[j%bin_size+1,:] = [e,e^2,H_i,I_i]
                if j%bin_size == 0 
                    e_av = 1/(bin_size)*sum(info_in_bin[:,1])
                    e2_av = 1/(bin_size)*sum(info_in_bin[:,2])
                    Hx_av = 1/(bin_size)*sum(info_in_bin[:,3])
                    Ix_av = 1/(bin_size)*sum(info_in_bin[:,4])
                    bin_av[:,Int(j/bin_size)] = [e_av,e2_av,Hx_av,Ix_av]
                    info_in_bin = zeros(bin_size, 4)
                end
            end
        end
        bin_av_T[:,:,l] = bin_av 
    end
    name = "Data/XY/Wolff_av_L"*string(L)
    save_object(name, bin_av_T)
end
