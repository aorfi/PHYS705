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

L_values = [4,8,16]
T_values = range(0,4, length=100)
for L in L_values
    N = L^2
    name = "Data/XY/Wolff_av_L"*string(L)
    bin_av_T_Wolff = load_object(name) 
    e_av_T_Wolff = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[1,:,:], dims=1)
    plt.scatter(T_values,reshape(e_av_T_Wolff,(length(T_values)))/N, label = "Wolff L = "*string(L))
end
plt.xlabel("T")
plt.ylabel("E/N")
plt.legend()
plt.show()