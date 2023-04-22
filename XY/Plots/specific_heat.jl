using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2

# L_values = [4,8]
# T_values = range(0,4, length=100)
# num_steps = 10^6
# bin_size = 50
# num_bins = Int(num_steps/bin_size)

# for L in L_values
#     N= L^2
#     name = "Data/XY/av_L"*string(L)
#     bin_av_T = load_object(name) 
#     e_av_T = 1/(num_bins)*sum(bin_av_T[1,:,:], dims=1)
#     e2_av_T = 1/(num_bins)*sum(bin_av_T[2,:,:], dims=1)
#     cv_T = []
#     for (i,T) in pairs(T_values)
#         e_av = e_av_T[i]
#         e2_av = e2_av_T[i]
#         cv = (e2_av - e_av^2)/(N*T^2)
#         append!(cv_T,cv)
#     end
#     plt.scatter(T_values,cv_T, label = "Random L = "*string(L))
# end

L_values = [16,24,32]
T_values = range(0,3, length=100)
num_steps_Wolff = 10^4
bin_size_Wolff = 1
num_bins_Wolff = Int(num_steps_Wolff/bin_size_Wolff)
for L in L_values
    N= L^2
    name = "Data/XY/Wolff_av_L"*string(L)
    bin_av_T_Wolff = load_object(name) 
    e_av_T_Wolff = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[1,:,:], dims=1)
    e2_av_T_Wolff = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[2,:,:], dims=1)
    cv_T_Wolff = []
    for (i,T) in pairs(T_values)
        e_av = e_av_T_Wolff[i]
        e2_av = e2_av_T_Wolff[i]
        cv = (e2_av - e_av^2)/(N*T^2)
        append!(cv_T_Wolff,cv)
    end
    plt.scatter(T_values,cv_T_Wolff, label = "L = "*string(L))
end
Tc = 0.8933
plt.axvline(Tc, linestyle = "dotted", color = "black", label = L"$T_c$")
plt.xlabel("T")
plt.ylabel(L"$C_v/N$")
plt.legend()
plt.grid()
name = "Figures/XY/Cv_T.png"
plt.savefig(name)
plt.show()