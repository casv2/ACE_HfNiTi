using IPFitting, ACE, LinearAlgebra
using JuLIP.MLIPs: combine, SumIP
using JuLIP.Utils

N=3
deg_site=12
deg_pair=3

dB = LsqDB("./HfNiTi_B$(deg_pair)_N$(N)_$(deg_site)")

weights = Dict(
    "default" => Dict("E" => 30.0, "F" => 1.0 , "V" => 0.1 ),
  )

#SIMPLE RRQR regularisation

for a in [1e-5, 5e-6, 1e-6]
      Vref = OneBody(Dict("Hf" => -5.58093, "Ni" => -0.09784, "Ti" => -1.28072))

      shipIP, lsqinfo = lsqfit(dB, solver=(:rrqr, a), weights = weights, Vref = Vref, asmerrs = true);
      rmse_table(lsqinfo["errors"])
      save_dict("./HfNiTi_B$(deg_pair)_N$(N)_$(deg_site)_rrqr_$(a).json", Dict("IP" => write_dict(shipIP), "info" => lsqinfo))
      
      @show norm(lsqinfo["c"])
end

#ELASTIC NET REGULARISATION (need dev branch of IPFitting for this)

for damp in [10.0, 5.0, 2.0, 1.0]
      Vref = OneBody(Dict("Hf" => -5.58093, "Ni" => -0.09784, "Ti" => -1.28072))

      rscal = 1.4
      alpha = 0.01 #5e-2 #7.5e-6

      shipIP, lsqinfo = lsqfit(dB, solver=(:elastic_net_itlsq, (alpha, damp, rscal, 1e-6, identity)), weights = weights, Vref = Vref, asmerrs = true);
      rmse_table(lsqinfo["errors"])
      save_dict("./HfNiTi_B$(deg_pair)_N$(N)_$(deg_site)_d$(damp)_a$(alpha)_r$(rscal).json", Dict("IP" => write_dict(shipIP), "info" => lsqinfo))

      @show norm(lsqinfo["c"])
end
