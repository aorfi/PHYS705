using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2
using LsqFit


# γ  = 1.74
# ν = 1.0
# Tc = 2/log(1+sqrt(2))
# L_values = [16,24,32,40]
# num_steps= 10^4
# bin_size = 1
# num_bins = Int(num_steps/bin_size)
# T_values = range(2,3, length=100)
# for L in L_values
#     N=L^2
#     name = "Data/Ising/T2-3L"*string(L)
#     bin_av_T = load_object(name) 

#     e_av_T = 1/(num_bins)*sum(bin_av_T[1,:,:], dims=1)
#     e2_av_T = 1/(num_bins)*sum(bin_av_T[2,:,:], dims=1)
#     m_av_T = 1/(num_bins)*sum(bin_av_T[3,:,:], dims=1)
#     m2_av_T = 1/(num_bins)*sum(bin_av_T[4,:,:], dims=1)
    
#     χ_T = []
#     for (i,T) in pairs(T_values)
#         m_av = m_av_T[i]
#         m2_av = m2_av_T[i]
#         χ = (m2_av - m_av^2)/(N*T)
#         append!(χ_T ,χ)
#     end
#     t = [(T-Tc)/Tc for T in T_values]
#     # plt.scatter(T_values,χ_T, label = "Wolff L = "*string(L))
#     plt.scatter(t*L^(1/ν),χ_T*L^(-γ/ν), label = "Wolff L = "*string(L))
#     # plt.plot(T_values,χ_T)
# end


# plt.legend()
# plt.grid()
# plt.axvline(0, linestyle = "dotted", color = "black")
# plt.xlabel(L"$tL^{1/\nu}$")
# plt.ylabel(L"$\chi L^{-\gamma/\nu}$")
# # plt.ylim(0,1.05)
# plt.xlim(-1,1)
# # name = "Figures/Ising/chi_T_scaled.png"
# # plt.savefig(name)
# plt.show()



γ  = 1.82
ν = 1.03
Tc = 2/log(1+sqrt(2))
L_values = [16,24,32,40]
num_steps= 10^4
bin_size = 1
num_bins = Int(num_steps/bin_size)
T_values = range(2,3, length=100)
for L in L_values
    N=L^2
    name = "Data/Ising/T2-3L"*string(L)
    bin_av_T = load_object(name) 

    e_av_T = 1/(num_bins)*sum(bin_av_T[1,:,:], dims=1)
    e2_av_T = 1/(num_bins)*sum(bin_av_T[2,:,:], dims=1)
    m_av_T = 1/(num_bins)*sum(bin_av_T[3,:,:], dims=1)
    m2_av_T = 1/(num_bins)*sum(bin_av_T[4,:,:], dims=1)
    
    χ_T = []
    for (i,T) in pairs(T_values)
        m_av = m_av_T[i]
        m2_av = m2_av_T[i]
        χ = (m2_av - m_av^2)/(N*T)
        append!(χ_T ,χ)
    end
    χ_T = χ_T[25:30]
    t = [(T-Tc)/Tc for T in T_values][25:30]


    @. model(x, p) = p[1] + p[2]*(x)
    p0 = [0.5, 0.5]
    fit = curve_fit(model, t*L^(1/ν), χ_T*L^(-γ/ν), p0)
    params = fit.param
    x = range(-0.6,0.45, length=1000)
    plt.plot(x,model(x,params))

    
    # plt.scatter(T_values,χ_T, label = "Wolff L = "*string(L))
    plt.scatter(t*L^(1/ν),χ_T*L^(-γ/ν), label = "Wolff L = "*string(L))
    # plt.plot(T_values,χ_T)
end


plt.legend()
plt.grid()
plt.axvline(0, linestyle = "dotted", color = "black")
plt.xlabel(L"$tL^{1/\nu}$")
plt.ylabel(L"$\chi L^{-\gamma/\nu}$")
# plt.ylim(0,1.05)
# plt.xlim(-1,1)
name = "Figures/Ising/chi_T_scaled_linearlized.png"
plt.savefig(name)
plt.show()