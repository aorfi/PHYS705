using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2

L_values = [4,8]
for L in L_values
    T_values = range(1,4, length=50)
    name = "Data/Ising/L"*string(L)
    bin_av_T = load_object(name) 
    num_bins = length(bin_av_T[1,:,1])
    bins_discard = 4
    e_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[1,bins_discard+1:end,:], dims=1)
    e2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[2,bins_discard+1:end,:], dims=1)
    m_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[3,bins_discard+1:end,:], dims=1)
    m2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[4,bins_discard+1:end,:], dims=1)

    cv_T = []
    for (i,T) in pairs(T_values)
        e_av = e_av_T[i]
        e2_av = e2_av_T[i]
        cv = (e2_av - e_av^2)/T^2
        append!(cv_T,cv)
    end
    plt.scatter(T_values,cv_T, label = "L = "*string(L))
    plt.plot(T_values,cv_T)
end

plt.legend()
plt.show()