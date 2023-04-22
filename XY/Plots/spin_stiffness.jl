using PythonCall
plt = pyimport("matplotlib.pyplot")
using Interpolations
using LaTeXStrings
using JLD2
using LsqFit
# L_values = [20,24,28,32]
# T_values = range(0,3, length=100)
# num_steps_Wolff = 10^4
# bin_size_Wolff = 1
# num_bins_Wolff = Int(num_steps_Wolff/bin_size_Wolff)
# for L in L_values
#     N= L^2
#     name = "Data/XY/Wolff_av_L"*string(L)
#     bin_av_T_Wolff = load_object(name) 
#     Hx_av_T = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[3,:,:], dims=1)
#     Ix_av_T = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[4,:,:], dims=1)
#     ρx_T_Wolff = []
#     for (i,T) in pairs(T_values)
#         Hx_av = Hx_av_T[i]
#         Ix_av = Ix_av_T[i]
#         ρx = Hx_av/N - (1/T)*Ix_av/N
#         append!(ρx_T_Wolff,ρx)
#     end
#     plt.scatter(T_values, ρx_T_Wolff, label = "L = "*string(L))
# end
# plt.plot(T_values, (2/π)*T_values, color = "black")
# Tc = 0.8933
# plt.vlines(x = Tc, ymin=0,ymax=(2/π)*Tc, linestyle = "dotted", color = "black")
# plt.xlabel("T")
# plt.ylabel(L"$\rho_x$")
# plt.ylim(0,1.05)
# plt.xlim(0,1.5)
# plt.legend()
# plt.grid()
# name = "Figures/XY/spin_stiffness.png"
# plt.savefig(name)
# plt.show()


L_values = [8,16,20,24,28,32]
Tkt_L = []
num_steps_Wolff = 10^4
bin_size_Wolff = 1
num_bins_Wolff = Int(num_steps_Wolff/bin_size_Wolff)
for L in L_values
    N= L^2
    T_values = range(0,3, length=100)
    name = "Data/XY/Wolff_av_L"*string(L)
    bin_av_T_Wolff = load_object(name) 
    Hx_av_T = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[3,:,:], dims=1)
    Ix_av_T = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[4,:,:], dims=1)
    ρx_T_Wolff = zeros(length(T_values))
    for (i,T) in pairs(T_values)
        Hx_av = Hx_av_T[i]
        Ix_av = Ix_av_T[i]
        ρx = Hx_av/N - (1/T)*Ix_av/N
        # append!(ρx_T_Wolff,ρx)
        ρx_T_Wolff[i] = ρx
    end
    T_values = T_values[29:33]
    ρx_T_Wolff = ρx_T_Wolff[29:33]
    # itp = CubicSplineInterpolation(T_values, ρx_T_Wolff, extrapolation_bc=Line())
    # x = range(0.5,1.1, length=1000)
    # plt.plot(x,itp(x))

    @. model(x, p) = p[1] + p[2]*x
    p0 = [0.5, 0.5]
    fit = curve_fit(model, T_values, ρx_T_Wolff, p0)
    params = fit.param
    x = range(0.5,1.1, length=1000)
    plt.plot(x, model(x,params), alpha = 0.5)
    Tkt = params[1]/(-params[2]+2/pi)
    append!(Tkt_L,Tkt)
    plt.scatter(T_values, ρx_T_Wolff, label = "L = "*string(L))
end
T_values = range(0,3, length=100)
plt.plot(T_values, (2/π)*T_values, color = "black")
Tc = 0.8933
plt.vlines(x = Tc, ymin=0,ymax=(2/π)*Tc, linestyle = "dotted", color = "black")
plt.xlabel("T")
plt.ylabel(L"$\rho_x$")
plt.ylim(0.2,0.8)
plt.xlim(0.8,1)
plt.legend()
plt.grid()
name = "Figures/XY/Tkt-linearFits.png"
plt.savefig(name)
plt.show()


# x_values = zeros(length(Tkt_L))
# for (i,L) in pairs(L_values)
#     x_values[i] = 1/(log(L)^2)
# end
# plt.scatter(x_values, Tkt_L)
# @. model(x, p) = p[1] + p[2]*x
# p0 = [0.5, 0.5]
# fit = curve_fit(model, x_values, Tkt_L, p0)
# params = fit.param
# m = round(params[2], digits=3)
# b = round(params[1], digits=3)
# x = range(x_values[1],x_values[end], length=1000)
# plt.plot(x, model(x,params), linestyle = "dashed",label = string(m)*"x+"*string(b))
# plt.xlabel(L"1/ln(N)^2")
# plt.ylabel(L"$T_{KT}(L)$")
# plt.legend()
# plt.grid()
# name = "Figures/XY/Tkt.png"
# plt.savefig(name)
# plt.show()