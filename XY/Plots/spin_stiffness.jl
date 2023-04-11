using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2

# L_values = [4,8]
# num_steps = 10^6
# bin_size = 50
# num_bins = Int(num_steps/bin_size)
# for L in L_values
#     N= L^2
#     name = "Data/XY/av_L"*string(L)
#     bin_av_T = load_object(name) 
#     Hx_av_T = 1/(num_bins)*sum(bin_av_T[3,:,:], dims=1)
#     Ix_av_T = 1/(num_bins)*sum(bin_av_T[4,:,:], dims=1)
#     ρx_T = []
#     for (i,T) in pairs(T_values)
#         Hx_av = Hx_av_T[i]
#         Ix_av = Ix_av_T[i]
#         ρx = Hx_av - (1/T)*Ix_av
#         append!(ρx_T,ρx)
#     end
#     plt.scatter(T_values, ρx_T, label = "L = "*string(L))
# end


L_values = [4,8,16]
T_values = range(0,3, length=100)
num_steps_Wolff = 10^4
bin_size_Wolff = 1
num_bins_Wolff = Int(num_steps_Wolff/bin_size_Wolff)
for L in L_values
    N= L^2
    name = "Data/XY/Wolff_av_L"*string(L)
    bin_av_T_Wolff = load_object(name) 
    Hx_av_T = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[3,:,:], dims=1)
    Ix_av_T = 1/(num_bins_Wolff)*sum(bin_av_T_Wolff[4,:,:], dims=1)
    ρx_T_Wolff = []
    for (i,T) in pairs(T_values)
        Hx_av = Hx_av_T[i]
        Ix_av = Ix_av_T[i]
        ρx = Hx_av/N - (1/T)*Ix_av/N
        append!(ρx_T_Wolff,ρx)
    end
    plt.scatter(T_values, ρx_T_Wolff, label = "Wolff L = "*string(L))
end
plt.plot(T_values, (2/π)*T_values, color = "black")
Tc = 0.8933
plt.vlines(x = Tc, ymin=0,ymax=(2/π)*Tc, linestyle = "dotted", color = "black")
plt.xlabel("T")
plt.ylabel(L"$\rho_x$")
plt.ylim(0,1.05)
plt.xlim(0,2)
plt.legend()
plt.show()