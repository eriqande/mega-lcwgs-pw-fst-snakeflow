import os
import warnings
import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version
# from snakemake.io import expand 


bams = pd.read_table(config["bams"], dtype=str).set_index(
    ["sample"], drop=False
)


pwcomps = pd.read_table(config["pwcomps"], dtype=str).set_index(
    ["pop1", "pop2"], drop=False
)



def get_bams_in_pop(wc):
  b=bams.loc[(bams["group"] == wc.grp)]
  return b.path.tolist()



# here are some lists that hold all the output files
ALLPW=expand(
  "results/fst/{p1}--x--{p2}.txt",
  zip,
  p1=pwcomps.pop1.tolist(),
  p2=pwcomps.pop2.tolist()
  )
