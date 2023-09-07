




rule summarise_average_fst_values:
  input:
    files=ALLWINSFS
  output:
    "results/{mode}/summarized/all-pw-fsts.tsv"
  log:
    "results/logs/summarise_fst_values/{mode}/log.txt"
  benchmark:
    "results/benchmarks/summarise_fst_values/{mode}/benchmark.txt"
  shell:
    " (echo \"file\tunwtd_lame_fst\tfst\"; for i in {input.files}; do awk -v file=$i "
    " 'BEGIN {{OFS = \"\t\";}} NF>0 {{print file, $0}}' $i; done; ) > {output} 2>{log} "



# this just catenates the sliding window estimates from
# multiple chromosomes, for each 
rule summarise_sliding_window_fst_values:
  input:
    files=CHROMWINSLIDE
  output:
    "results/{mode}/summarized/sliding_window_fst/{p1}--x--{p2}--size-{window_size}--step-{window_step}.tsv"
  log:
    "results/logs/summarise_sliding_window_fst_values/{mode}/{p1}--x--{p2}--size-{window_size}--step-{window_step}.log"
  shell:
    "cat {input.files} | awk '                  "
    "  BEGIN {{OFS=\"\t\"}}                     "
    "  /^region/ {{if(NR==1) print; else next}} "
    "  {{print}} ' > {output} 2> {log}          "
