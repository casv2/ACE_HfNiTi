using IPFitting, ACE

al = IPFitting.Data.read_xyz(@__DIR__() * "/HfNiTi_DB.xyz", energy_key="energy", force_key="forces", virial_key="virial");

R = minimum(IPFitting.Aux.rdf(al, 4.0))

r0 = rnn(:Ti)

N=3
deg_site=12
deg_pair=3

Bsite = rpi_basis(species = [:Hf, :Ti, :Ni],
      N = N,                       # correlation order = body-order - 1
      maxdeg = deg_site,            # polynomial degree
      r0 = r0,                      # estimate for NN distance
      rin = R, rcut = 6.0,   # domain for radial basis (cf documentation)
      pin = 2)                     # require smooth inner cutoff

Bpair = pair_basis(species = [:Hf, :Ti, :Ni],
      r0 = r0,
      maxdeg = deg_pair,
      rcut = 8.0,
      #rin = 0.70 * r0,
      pcut = 1,
      pin = 0)   # pin = 0 means no inner cutoff

B = JuLIP.MLIPs.IPSuperBasis([Bpair, Bsite]);

dB = LsqDB("./HfNiTi_B$(deg_pair)_N$(N)_$(deg_site)", B, al)
