using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2

L_values = [4]
num_steps = 10^6
bin_size = 50
num_bins = Int(num_steps/bin_size)
for L in L_values
    N= L^2
    name = "Data/XY/av_L"*string(L)
    bin_av_T = load_object(name) 
    Hx_av_T = 1/(num_bins)*sum(bin_av_T[3,:,:], dims=1)
    Ix_av_T = 1/(num_bins)*sum(bin_av_T[4,:,:], dims=1)
    ρx_T = []
    for (i,T) in pairs(T_values)
        Hx_av = Hx_av_T[i]
        Ix_av = Ix_av_T[i]
        ρx = Hx_av - (1/T)*Ix_av
        append!(ρx_T,ρx)
    end
    plt.scatter(T_values, ρx_T, label = "L = "*string(L))
    # plt.plot(T_values,ρx_T)
end
plt.xlabel("T")
plt.ylabel(L"$\rho_x$")
plt.legend()
plt.show()