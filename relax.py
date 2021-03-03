import pyjulip

from ase.io import read, write
from ase.optimize import LBFGS
import time

calc = pyjulip.ACE("./HfNiTi_B3_N3_15_d1.0_a0.02_r1.4.json")

al = read("./test_configs.xyz", ":")

E = []
V = []

for at in al:
    at.set_calculator(calc)
    dyn = LBFGS(at)
    dyn.run(fmax=0.05)
    E.append(at.get_potential_energy()/len(at))
    V.append(at.get_volume()/len(at))