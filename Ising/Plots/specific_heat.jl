using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2

# Tc = 2/log(1+sqrt(2))
# L_values = [8,10,16,20,24,32]
# for L in L_values
#     N= L^2
#     T_values = range(2,3, length=100)
#     name = "Data/Ising/L"*string(L)
#     bin_av_T = load_object(name) 
#     num_bins = length(bin_av_T[1,:,1])
#     bins_discard = 6
#     e_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[1,bins_discard+1:end,:], dims=1)
#     e2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[2,bins_discard+1:end,:], dims=1)
#     m_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[3,bins_discard+1:end,:], dims=1)
#     m2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[4,bins_discard+1:end,:], dims=1)

#     cv_T = []
#     for (i,T) in pairs(T_values)
#         e_av = e_av_T[i]
#         e2_av = e2_av_T[i]
#         cv = (e2_av - e_av^2)/(N*T^2)
#         append!(cv_T,cv)
#     end
#     plt.scatter(T_values,cv_T, label = "L = "*string(L))
#     plt.plot(T_values,cv_T)
# end
# plt.xlabel("T")
# plt.ylabel(L"$C_v$")
# plt.axvline(Tc)
# plt.legend()
# plt.show()


Tc = 2/log(1+sqrt(2))
L_values = [24]
num_steps= 10^4
bin_size = 1
num_bins = Int(num_steps/bin_size)
T_values = range(2,3, length=100)
max_point = 0
max_index = 1
for L in L_values
    N=L^2
    name = "Data/Ising/T2-3L"*string(L)
    bin_av_T = load_object(name) 

    e_av_T = 1/(num_bins)*sum(bin_av_T[1,:,:], dims=1)
    e2_av_T = 1/(num_bins)*sum(bin_av_T[2,:,:], dims=1)
    m_av_T = 1/(num_bins)*sum(bin_av_T[3,:,:], dims=1)
    m2_av_T = 1/(num_bins)*sum(bin_av_T[4,:,:], dims=1)
    
    cv_T = []
    for (i,T) in pairs(T_values)
        e_av = e_av_T[i]
        e2_av = e2_av_T[i]
        cv = (e2_av - e_av^2)/(N*T^2)
        append!(cv_T,cv)
    end
    plt.scatter(T_values,cv_T, label = "L = "*string(L))
    global max_point, max_index = findmax(cv_T)
end

Tc_est = round(T_values[max_index], digits=2)
plt.grid()
# plt.axvline(Tc, linestyle = "dotted", color = "black")
plt.axvline(T_values[max_index],color="black", label = "T = "*string(Tc_est))
plt.xlabel("T")
plt.ylabel(L"$C_v$")
plt.legend()
name = "Figures/Ising/Cv_T.png"
plt.savefig(name)
plt.show()



# Tc = 2/log(1+sqrt(2))
# L_values = [16,32]
# num_runs = 100
# T_values = range(2,3, length=100)
# for L in L_values
#     N=L^2
#     neigh = get_neighbours(L)
#     name = "Data/Ising/T2-3CFTPL"*string(L)
#     obs = load_object(name) 
#     println(size(obs))
#     e_av_T = []
#     e2_av_T = []
#     for (j,T) in pairs(T_values)
#         e_av, e2_av, m_av, m2_av = 0,0,0,0
#         for i in (1:num_runs)
#             spins = obs[:,i,j]
#             e, e2, m, m2, config = config_info(L, spins, neigh)
#             e_av += 1/num_runs*e
#             e2_av += 1/num_runs*e2
#             m_av += 1/num_runs*m
#             m2_av += 1/num_runs*m2
#         end
#         append!(e_av_T,e_av)
#         append!(e2_av_T,e2_av)
#     end 

#     cv_T = []
#     for (i,T) in pairs(T_values)
#         e_av = e_av_T[i]
#         e2_av = e2_av_T[i]
#         cv = (e2_av - e_av^2)/(N*T^2)
#         append!(cv_T,cv)
#     end
#     plt.scatter(T_values,cv_T, label = "L = "*string(L))
# end
# plt.xlabel("T")
# plt.ylabel(L"$C_v$")
# plt.axvline(Tc)
# plt.legend()
# plt.show()