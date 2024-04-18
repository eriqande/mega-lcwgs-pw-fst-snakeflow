



rule one_d_realSFS:
  input:
    saf="results/{mode}/{chunk}/saf/{p1}.saf.idx"
  output:
    sfs="results/{mode}/one_d_realSFS/{chunk}---{p1}.ml"
  params:
    chunk_opt=get_chunk
  threads: 1
  conda:
    "../envs/angsd.yaml"
  log:
    "results/logs/one_d_realSFS/{mode}/{chunk}/{p1}.txt"
  benchmark:
    "results/benchmarks/one_d_realSFS/{mode}/{chunk}/{p1}.txt"
  shell:
    " realSFS -cores {threads} {input.saf} > {output.sfs} 2>{log} "







rule one_d_winsfs:
  input:
    saf="results/{mode}/{chunk}/saf/{p1}.saf.idx"
  output:
    sfs="results/{mode}/one_d_winsfs/{chunk}---{p1}.ml"
  params:
    chunk_opt=get_chunk
  threads: 1
  log:
    "results/logs/one_d_winsfs/{mode}/{chunk}/{p1}.txt"
  benchmark:
    "results/benchmarks/one_d_winsfs/{mode}/{chunk}/{p1}.txt"
  shell:
    " winsfs -t {threads} {input.saf} > {output.sfs} 2>{log} "



rule dest_edify_1d:
  input:
    ALL_1D_REAL + ALL_1D_WIN
