




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


