using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2


# L_values = [4,6,8,10]
# for L in L_values
#     T_values = range(2,3, length=100)
#     name = "Data/Ising/T2-3L"*string(L)
#     bin_av_T = load_object(name) 
#     num_bins = length(bin_av_T[1,:,1])
#     bins_discard = 6
#     e_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[1,bins_discard+1:end,:], dims=1)
#     e2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[2,bins_discard+1:end,:], dims=1)
#     m_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[3,bins_discard+1:end,:], dims=1)
#     m2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[4,bins_discard+1:end,:], dims=1)
    
#     χ_T = []
#     for (i,T) in pairs(T_values)
#         m_av = m_av_T[i]
#         m2_av = m2_av_T[i]
#         χ = (m2_av - m_av^2)/(N*T)
#         append!(χ_T ,χ)
#     end
#     plt.scatter(T_values,χ_T, label = "Wolff L = "*string(L))
#     plt.plot(T_values,χ_T)
# end
# plt.xlabel("T")
# plt.ylabel(L"$\chi$")
# plt.legend()
# plt.show()


γ  = 7/4
ν = 1
Tc = 2/log(1+sqrt(2))
L_values = [10,16,20,24,32]
for L in L_values
    N=L^2
    T_values = range(1,4, length=100)
    name = "Data/Ising/L"*string(L)
    bin_av_T = load_object(name) 
    num_bins = length(bin_av_T[1,:,1])
    bins_discard = 6
    e_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[1,bins_discard+1:end,:], dims=1)
    e2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[2,bins_discard+1:end,:], dims=1)
    m_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[3,bins_discard+1:end,:], dims=1)
    m2_av_T = 1/(num_bins-bins_discard)*sum(bin_av_T[4,bins_discard+1:end,:], dims=1)
    
    χ_T = []
    for (i,T) in pairs(T_values)
        m_av = m_av_T[i]
        m2_av = m2_av_T[i]
        χ = (m2_av - m_av^2)/(N*T)
        append!(χ_T ,χ)
    end
    t = [(T-Tc)/Tc for T in T_values]
    plt.scatter(T_values,χ_T, label = "Wolff L = "*string(L))
    # plt.scatter(t*L^(1/ν),χ_T*L^(-γ/ν), label = "Wolff L = "*string(L))
    # plt.plot(T_values,χ_T)
end
plt.xlabel("T")
plt.ylabel(L"$\chi$")
plt.axvline(Tc)
plt.legend()
plt.show()