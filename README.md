# ACE_HfNiTi

JULIA:

Make sure to have `IPFitting, ACE` installed! This should be as simple as

`] registry add https://github.com/JuliaMolSim/MolSim.git` \\
`] add IPFitting, ACE, JuLIP, ASE`

Otherwise you can do

`git clone https://github.com/casv2/ACE_env`
`cp ACE_env/Project.toml ~/.julia/environments/v1.5/`

from Julia REPL

`] resolve`
`] dev IPFitting`

And go to

`cd ~/.julia/dev/IPFitting`
`git checkout dev`
`git pull`

PYTHON:

We need `pyjulip` to work, please install julia package for python

`pip install julia`
from python REPL: `import julia; julia.install()`

PyJulip installation
`git clone https://github.com/casv2/pyjulip.git`
`cd pyjulip`
`python setup.py install`

Then we can use our ACE models as an ASE calculator

`import pyjulip`
`calculator = pyjulip.ACE("$(ACE_FILENAME).json")`

