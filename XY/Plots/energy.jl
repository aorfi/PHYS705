using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2


# L_values = [4,8]
# num_steps = 10^6
# bin_size = 50
# num_bins = Int(num_steps/bin_size)
# for L in L_values
#     N = L^2
#     T_values = range(0,4, length=100)
#     name = "Data/XY/av_L"*string(L)
#     bin_av_T = load_object(name) 
#     e_av_T = 1/(num_bins)*sum(bin_av_T[1,:,:], dims=1)
#     plt.scatter(T_values,reshape(e_av_T,(length(T_values)))/N, label = "Random L = "*string(L))
# end


num_discard = 500
num_steps = 10^4
bin_size = 1
num_bins = Int(num_steps/bin_size)
L_values = [16,24,32]
T_values = range(0,4, length=100)
for L in L_values
    N = L^2
    name = "Data/XY/Wolff_av_L"*string(L)
    bin_av_T_Wolff = load_object(name) 
    e_av_T_Wolff = 1/(num_bins)*sum(bin_av_T_Wolff[1,:,:], dims=1)
    plt.scatter(T_values,reshape(e_av_T_Wolff,(length(T_values)))/N, label = "L = "*string(L))
end
Tc = 0.8933
plt.axvline(Tc, linestyle = "dotted", color = "black", label = L"$T_c$")
plt.xlabel("T")
plt.ylabel(L"$\langle E\rangle /N$")
plt.legend()
plt.grid()
name = "Figures/XY/energy_T.png"
plt.savefig(name)
plt.show()