

# these are analogous rules, but for a route that
# uses winsfs
rule calc_2dsfs_winsfs:
  input:
    saf1="results/{mode}/{chunk}/saf/{p1}.saf.idx",
    saf2="results/{mode}/{chunk}/saf/{p2}.saf.idx",
  output:
    sfs="results/{mode}/{chunk}/winsfs/{p1}--x--{p2}.ml"
  params:
    ws=config["params"]["winsfs"],
    chunk_opt=get_chunk
  threads: 1
  log:
    "results/logs/calc_2dsfs_winsfs/{mode}/{chunk}/{p1}--x--{p2}.txt"
  benchmark:
    "results/benchmarks/calc_2dsfs_winsfs/{mode}/{chunk}/{p1}--x--{p2}.txt"
  shell:
    " winsfs -t {threads} {params.ws} {input.saf1} {input.saf2} > {output.sfs} 2>{log}"


rule fold_winsfs:
  input:
    sfs="results/{mode}/{chunk}/winsfs/{p1}--x--{p2}.ml"
  output:
    sfs="results/{mode}/{chunk}/winsfs_folded/{p1}--x--{p2}.ml"
  log:
    "results/logs/fold_winsfs/{mode}/{chunk}/{p1}--x--{p2}.txt"
  threads: 1
  shell:
    " winsfs view --fold {input.sfs} | awk '!/^#/ {{print}}' > {output.sfs} 2> {log} "

rule calc_fst_binaries_winsfs:
  input:
    saf1="results/{mode}/{chunk}/saf/{p1}.saf.idx",
    saf2="results/{mode}/{chunk}/saf/{p2}.saf.idx",
    sfs="results/{mode}/{chunk}/winsfs_folded/{p1}--x--{p2}.ml",
  params:
    rs=config["params"]["realSFS"],
    chunk_opt=get_chunk
  output:
    "results/{mode}/{chunk}/winsfs_fst_bin/{p1}--x--{p2}.fst.idx"
  threads: 1
  conda:
    "../envs/angsd.yaml"
  log:
    "results/logs/calc_fst_binaries_winsfs/{mode}/{chunk}/{p1}--x--{p2}.txt"
  benchmark:
    "results/benchmarks/calc_fst_binaries_winsfs/{mode}/{chunk}/{p1}--x--{p2}.txt"
  shell:
    " PREFIX=$(echo {output} | sed 's/\.fst\.idx$//g;');                             "
    " realSFS fst index -cores {threads} {params.rs} {params.chunk_opt} {input.saf1} {input.saf2} -sfs {input.sfs} -fstout $PREFIX > {log} 2>&1  "



rule extract_fst_values_winsfs:
  input:
    "results/{mode}/{chunk}/winsfs_fst_bin/{p1}--x--{p2}.fst.idx"
  output:
    "results/{mode}/{chunk}/winsfs_fst/{p1}--x--{p2}.txt"
  conda:
    "../envs/angsd.yaml"
  log:
    "results/logs/extract_fst_values_winsfs/{mode}/{chunk}/{p1}--x--{p2}.txt"
  benchmark:
    "results/benchmarks/extract_fst_values_winsfs/{mode}/{chunk}/{p1}--x--{p2}.txt"
  shell:
    "realSFS fst stats {input} > {output} 2>{log} "
    



rule sliding_window_fst_winsfs:
  input:
    "results/{mode}/{chunk}/winsfs_fst_bin/{p1}--x--{p2}.fst.idx"
  output:
    "results/{mode}/{chunk}/fst_sliding_windows/size-{window_size}/step-{window_step}/{p1}--x--{p2}.txt"
  conda:
    "../envs/angsd.yaml"
  params:
    wsize = "{window_size}",
    wstep = "{window_step}"
  log:
    "results/logs/sliding_window_fst_winsfs/{mode}/{chunk}/size-{window_size}/step-{window_step}/{p1}--x--{p2}.txt"
  benchmark:
    "results/benchmarks/sliding_window_fst_winsfs/{mode}/{chunk}/size-{window_size}/step-{window_step}/{p1}--x--{p2}.txt"
  shell:
    "realSFS fst stats2  {input} -win {params.wsize} -step {params.wstep} > {output} 2>{log} "













