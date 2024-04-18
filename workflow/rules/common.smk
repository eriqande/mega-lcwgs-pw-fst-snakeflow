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

allpops=list(set(pwcomps.pop1.tolist() + pwcomps.pop2.tolist()))

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
CHROMWINSFS=expand("results/{mode}/{chunk}/winsfs_fst/{{p1}}--x--{{p2}}.txt", mode=["BY_CHROM"], chunk=chrom_list)

# these are all the slidiging window estimates for a particular step and window size and p1 and p2
CHROMWINSLIDE=expand("results/{mode}/{chunk}/fst_sliding_windows/size-{{window_size}}/step-{{window_step}}/{{p1}}--x--{{p2}}.txt", mode=["BY_CHROM"], chunk=chrom_list)
SUMMWINSLIDE=expand(
  "results/BY_CHROM/summarized/sliding_window_fst/{p1}--x--{p2}--size-{{window_size}}--step-{{window_step}}.tsv",
  zip,
  p1=pwcomps.pop1.tolist(),
  p2=pwcomps.pop2.tolist()
  )


ALLPW=expand(
  CHROMFS,
  zip,
  p1=pwcomps.pop1.tolist(),
  p2=pwcomps.pop2.tolist()
  )
  
ALLWINSFS=expand(
  CHROMWINSFS,
  zip,
  p1=pwcomps.pop1.tolist(),
  p2=pwcomps.pop2.tolist()
  )

ALLSLIDEWINDOWS=expand(SUMMWINSLIDE,
  zip,
  window_size = config["params"]["fst_window_size"],
  window_step = config["params"]["fst_window_step"]
  )

# here, we define outputs for our "edification" 1-D SFS rules
ALL_1D_REAL=expand("results/{mode}/one_d_realSFS/{chunk}---{p1}.ml", mode=["BY_CHROM"], chunk=chrom_list, p1=allpops)
ALL_1D_WIN=expand("results/{mode}/one_d_winsfs/{chunk}---{p1}.ml", mode=["BY_CHROM"], chunk=chrom_list, p1=allpops)
