using IPFitting
using HMD
using JuLIP
using ACE

al = IPFitting.Data.read_xyz("./HAL_it1-10.xyz", energy_key="energy", force_key="forces", virial_key="virial")
al_test = IPFitting.Data.read_xyz("./HfNiTi_TEST_DB.xyz", energy_key="energy", force_key="forces", virial_key="virial")

R = minimum(IPFitting.Aux.rdf(al, 4.0))

r0 = rnn(:Ti)

N=3
deg_site=8
deg_pair=3

Bpair = pair_basis(species = [:Hf, :Ti, :Ni], #defining the 2B basis, deg_pair = 3 works well
                r0 = r0, 		      #best to keep this specified like this, only perhaps change the rcut
                maxdeg = deg_pair,
                rcut = 7.0,
                pcut = 1,
                pin = 0)

Bsite = rpi_basis(species = [:Hf, :Ti, :Ni],
      N = N,                       # correlation order = body-order - 1
      maxdeg = deg_site,           # polynomial degree
      r0 = r0,                     # estimate for NN distance
      rin = R, rcut = 6.0,         # domain for radial basis (cf documentation)
      pin = 2)                     # require smooth inner cutoff

B = JuLIP.MLIPs.IPSuperBasis([Bpair, Bsite]);

weights = Dict(
    "default" => Dict("E" => 30.0, "F" => 1.0 , "V" => 0.1 ),
  )

Vref = OneBody(Dict("Hf" => -5.58093, "Ni" => -0.09784, "Ti" => -1.28072))

n_comms = 30 #committee members
iterations = 1 #doing one iteration
added_configs = 10 #adding 10 configs every iteration

HMD.HAL.HAL_E(al, al_test, B, n_comms, iterations, added_configs, weights, Vref)
