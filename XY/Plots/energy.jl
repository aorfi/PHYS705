using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2


L_values = [4]
num_steps = 10^6
bin_size = 50
num_bins = Int(num_steps/bin_size)
for L in L_values
    N = L^2
    T_values = range(0,4, length=100)
    name = "Data/XY/av_L"*string(L)
    bin_av_T = load_object(name) 
    e_av_T = 1/(num_bins)*sum(bin_av_T[1,:,:], dims=1)
    println(e_av_T)
    plt.scatter(T_values,reshape(e_av_T,(length(T_values)))/N, label = "L = "*string(L))
    # plt.plot(T_values,e_av_T)
end
plt.xlabel("T")
plt.ylabel("E/N")
# Tc = 2/log(1+sqrt(2))
# plt.axvline(Tc)
plt.legend()
plt.show()