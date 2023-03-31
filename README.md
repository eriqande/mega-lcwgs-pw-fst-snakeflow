
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mega-lcwgs-pw-fst-snakeflow

<!-- badges: start -->
<!-- badges: end -->

This is a simple Snakemake workflow for calculating pairwise Fsts (and
related quantities, eventually, I suppose) from BAM files using ANGSD.

Note that the `mega` in the name doesn’t refer to anything that I think
is “millions-esque” about this project. It is simply one of the
workflows we use in the **M**olecular **E**cology and **G**enetic
**A**nalysis (MEGA) Team at NOAA’s Southwest Fisheries Science,
Fisheries Ecology Division.

Setting up this workflow for yourself is pretty easy:

1.  You have to put appropriate values in the config file for your own
    data set
2.  You need a `bams.tsv` file that gives that paths to the BAM files
    and tells what group (population) each such sample/bam belongs to.
    **Spaces are not allowed in the bam file paths.**
3.  You need a `pwcomps.tsv` that lists the pairwise comparisons from
    the groups in `bams.tsv` that you wish to calculate pairwise Fsts
    for.

This workflow comes with a small set of data and config files for
testing in the `.test` directory. This is a good place to go to see
examples of the `config` files, etc. I print them out below here, too:

**.test/config/config.yaml**

``` yaml
bams: ".test/config/bams.tsv"
pwcomps: ".test/config/pwcomps.tsv"
```

**.test/config/bams.tsv**

``` yaml
sample  path    group
s001    .test/data/bams/s001.bam    grpA
s002    .test/data/bams/s002.bam    grpA
s003    .test/data/bams/s003.bam    grpB
s004    .test/data/bams/s004.bam    grpB
s005    .test/data/bams/s005.bam    grpB
s006    .test/data/bams/s006.bam    grpC
s007    .test/data/bams/s007.bam    grpC
```

**.test/config/pwcomps.tsv**

``` yaml
pop1    pop2
grpA    grpB
grpA    grpC
grpB    grpC
```
