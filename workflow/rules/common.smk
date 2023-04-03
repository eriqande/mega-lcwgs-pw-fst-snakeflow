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


chroms = pd.read_table(config["chroms"], dtype=str).set_index(
    ["chrom"], drop=False
)

chrom_list=chroms.chrom.tolist()

def get_bams_in_pop(wc):
  b=bams.loc[(bams["group"] == wc.grp)]
  return b.path.tolist()


# we do this with a function so that EVENTUALLY if the chunk is __ALL for example
# we can do something different
def get_chunk(wc):
  return "-r " + wc.chunk

# here are some lists that hold all the output files

# we first expand by chroms:
CHROMFS=expand("results/{mode}/{chunk}/fst/{{p1}}--x--{{p2}}.txt", mode=["BY_CHROM"], chunk=chrom_list)

ALLPW=expand(
  CHROMFS,
  zip,
  p1=pwcomps.pop1.tolist(),
  p2=pwcomps.pop2.tolist()
  )
