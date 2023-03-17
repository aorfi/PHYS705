using PythonCall
plt = pyimport("matplotlib.pyplot")
using LaTeXStrings


include("lattice.jl")
include("local_updates.jl")
include("Wolff.jl")



L= 8
# β = 1
T = 4
N = L^2
neigh = get_neighbours(L)

spins_MH = random_config(L)
spins_glaub = random_config(L)
spins_Wolff = random_config(L)
e_MH = []
e_glaub = []
e_Wolff = []
num_steps = 10^4
for i in (1:num_steps)
    global spins_MH = MH_step(L,neigh, spins_MH, T)
    e, e2, m, m2, config = config_info(L, spins_MH, neigh)
    append!(e_MH,config)
    global spins_glaub = glauber_step(L,neigh, spins_glaub,T)
    e, e2, m, m2, config = config_info(L, spins_glaub, neigh)
    append!(e_glaub,config)
    # global spins_Wolff = Wolff_step(spins_Wolff,T,N,neigh)
    # e, e2, m, m2, config  = config_info(L, spins_Wolff, neigh,h)
    # append!(e_Wolff,m)
end
plt.plot((1:num_steps),e_MH, label="MH")
plt.plot((1:num_steps),e_glaub, label="Glauber")
# plt.plot((1:num_steps),e_Wolff, label = "Wolff")
plt.legend()
plt.show()
num_discard = 100
m_av = 1/(num_steps-num_discard)*sum(e_Wolff[num_discard:end])
println(m_av)


# L_values = [4,8,16]
# for L in L_values
#     N = L^2
#     neigh = get_neighbours(L)
#     T_values = range(1,4, length=50)
#     num_steps = 10^3
#     num_discard = 100
#     cv_T = []
#     for T in T_values
#         println("working on T = ", T)
#         global spins_Wolff = random_config(L)
#         println("N = ",size(spins_Wolff))
#         e_Wolff = []
#         e2_Wolff = []
#         for i in (1:num_steps)
#             spins_Wolff = Wolff_step(spins_Wolff,T,N,neigh)
#             e, e2, m, m2  = config_info(L, spins_Wolff, neigh)
#             append!(e_Wolff,e)
#             append!(e2_Wolff,e2)
#         end
#         e2_av = 1/(num_steps-num_discard)*sum(e2_Wolff[num_discard:end])
#         e_av = 1/(num_steps-num_discard)*sum(e_Wolff[num_discard:end])
#         cv = (e2_av - e_av^2)/T^2
#         append!(cv_T,cv )
#     end
#     # name = "Data/Ising/"*string(num_values)*"N"*string(N)*"beta"*string(beta)
#     # save_object(name, gap_all)
#     plt.scatter(T_values,cv_T, label = "L = "*string(L))
#     plt.plot(T_values,cv_T)
# end
# plt.legend()
# plt.show()