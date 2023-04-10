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
    e_av_T = 1/(num_bins)*sum(bin_av_T[1,:,:], dims=1)
    e2_av_T = 1/(num_bins)*sum(bin_av_T[2,:,:], dims=1)
    cv_T = []
    for (i,T) in pairs(T_values)
        e_av = e_av_T[i]
        e2_av = e2_av_T[i]
        cv = (e2_av - e_av^2)/(N*T^2)
        append!(cv_T,cv)
    end
    plt.scatter(T_values,cv_T, label = "L = "*string(L))
    plt.plot(T_values,cv_T)
end
plt.xlabel("T")
plt.ylabel(L"$C_v$")
plt.legend()
plt.show()