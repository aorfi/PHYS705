using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings
using JLD2


L_values = [4,8]
for L in L_values
    N = L^2
    T_values = range(0,4, length=100)
    name = "Data/XY/av_acc_L"*string(L)
    acceptace_rate = load_object(name) 
    plt.scatter(T_values,acceptace_rate, label = "L = "*string(L))
    # plt.plot(T_values,e_av_T)
end
plt.xlabel("T")
plt.ylabel("Acceptance Rate")
# Tc = 2/log(1+sqrt(2))
# plt.axvline(Tc)
plt.legend()
plt.show()