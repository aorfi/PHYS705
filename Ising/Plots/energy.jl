using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2


L_values = [32]
for L in L_values
    N = L^2
    T_values = range(1,4, length=100)
    name = "Data/Ising/L"*string(L)
    bin_av_T = load_object(name) 
    num_bins = length(bin_av_T[1,:,1])
    bins_discard = 6
    e_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[1,bins_discard+1:end,:], dims=1)
    e2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[2,bins_discard+1:end,:], dims=1)
    m_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[3,bins_discard+1:end,:], dims=1)
    m2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[4,bins_discard+1:end,:], dims=1)
    plt.scatter(T_values,reshape(e_av_T,(length(T_values)))/N, label = "L = "*string(L))
    # plt.plot(T_values,e_av_T)
end
plt.xlabel("T")
plt.ylabel(L"$\langle E\rangle /N$")
Tc = 2/log(1+sqrt(2))
plt.axvline(Tc, linestyle = "dotted", color = "black")
# plt.legend()
plt.grid()
name = "Figures/Ising/energy_T.png"
plt.savefig(name)
plt.show()

