using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2

Tc = 2/log(1+sqrt(2))
L_values = [8,10,16,20,24,32]
for L in L_values
    N= L^2
    T_values = range(2,3, length=100)
    name = "Data/Ising/L"*string(L)
    bin_av_T = load_object(name) 
    num_bins = length(bin_av_T[1,:,1])
    bins_discard = 6
    e_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[1,bins_discard+1:end,:], dims=1)
    e2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[2,bins_discard+1:end,:], dims=1)
    m_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[3,bins_discard+1:end,:], dims=1)
    m2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[4,bins_discard+1:end,:], dims=1)

    cv_T = []
    for (i,T) in pairs(T_values)
        e_av = e_av_T[i]
        e2_av = e2_av_T[i]
        cv = (e2_av - e_av^2)/(N*T^2)
        append!(cv_T,cv)
    end
    plt.scatter(T_values,cv_T, label = "Wolff L = "*string(L))
    plt.plot(T_values,cv_T)
end
plt.xlabel("T")
plt.ylabel(L"$C_v$")
plt.axvline(Tc)
plt.legend()
plt.show()