

rule calc_1dsfs_realSFS:
  input:
    saf="results/{mode}/{chunk}/saf/{p1}.saf.idx"
  output:
    sfs="results/{mode}/{chunk}/1dsfs_realsfs/{p1}.ml"
  params:
    rs=config["params"]["realSFS"],
    chunk_opt=get_chunk
  threads: 4
  conda:
    "../envs/angsd.yaml"
  log:
    "results/logs/calc_1dsfs_realSFS/{mode}/{chunk}/{p1}.txt"
  benchmark:
    "results/benchmarks/calc_1dsfs_realSFS/{mode}/{chunk}/{p1}.txt"
  shell:
    " realSFS -cores {threads} {params.rs} {params.chunk_opt} {input.saf} > {output.sfs} 2> {log}"
    

rule calc_persite_thetas:
  input:
    saf="results/{mode}/{chunk}/saf/{p1}.saf.idx",
    sfs="results/{mode}/{chunk}/1dsfs_realsfs/{p1}.ml"
  output:
    multiext("results/{mode}/{chunk}/persite_thetas/{p1}", ".thetas.gz", ".thetas.idx")
  params:
    chunk_opt=get_chunk
  threads: 1
  conda:
    "../envs/angsd.yaml"
  log:
    "results/logs/calc_persite_thetas/{mode}/{chunk}/{p1}.txt"
  benchmark:
    "results/benchmarks/calc_persite_thetas/{mode}/{chunk}/{p1}.txt"
  shell:
    " (OUTDIR={output[0]} && OUTDIR=${{OUTDIR/.thetas.gz/}} && "
    " realSFS saf2theta -P {threads} {params.chunk_opt} {input.saf} -sfs {input.sfs} -outname $OUTDIR) > {log} 2>&1 "



rule calc_tajimas_d:
  input:
    thetas="results/{mode}/{chunk}/persite_thetas/{p1}.thetas.idx"
  output:
    pest="results/{mode}/{chunk}/tajimas_d/{p1}.thetas.pestPG"
  threads: 1
  conda:
    "../envs/angsd.yaml"
  log:
    "results/logs/calc_tajimas_d/{mode}/{chunk}/{p1}.txt"
  benchmark:
    "results/benchmarks/calc_tajimas_d/{mode}/{chunk}/{p1}.txt"
  shell:
    " (OUTDIR={output} && OUTDIR=${{OUTDIR/.pestPG/}} &&"
    " thetaStat do_stat {input.thetas} -outnames $OUTDIR) > {log} 2>&1 "



rule calc_d_sliding_window:
  input:
    thetas="results/{mode}/{chunk}/persite_thetas/{p1}.thetas.idx"
  output:
    thetawin="results/{mode}/{chunk}/d_sliding_windows/size-{window_size}/step-{window_step}/{p1}.thetasWindow.pestPG"
  params:
    wsize=config["params"]["theta_window_size"],
    wstep=config["params"]["theta_window_step"]
  conda:
    "../envs/angsd.yaml"
  log:
    "results/logs/calc_d_sliding_window/{mode}/{chunk}/size-{window_size}/step-{window_step}/{p1}.txt"
  benchmark:
    "results/benchmarks/calc_d_sliding_window/{mode}/{chunk}/size-{{window_size}}/step-{{window_step}}/{p1}.txt"
  shell:
    " (OUTDIR={output} && OUTDIR=${{OUTDIR/.pestPG/}} &&"
    " thetaStat do_stat {input.thetas} -win {params.wsize} -step {params.wstep} -outnames $OUTDIR) > {log} 2>&1 "



rule summarise_avg_theta_values:
  input:
    files=ALLTHETA
  output:
    "results/{mode}/summarized/all-thetas.tsv"
  log:
    "results/logs/summarise_avg_theta_values/{mode}/log.txt"
  shell:
    "(echo \"file\tregion\tChr\tmidPos\ttW\ttP\ttF\ttH\ttL\tTajima\tfuf\tfud\tfayh\tzeng\tnSites\"; for i in {input.files}; do awk -v file=$i "
    " 'BEGIN {{OFS = \"\t\";}} NF>0 {{print file, $0}}' $i; done; ) > {output} 2>{log}; "
    " sed -i '/#(indexStart,indexStop)(firstPos_withData,lastPos_withData)(WinStart,WinStop)/d' {output} "
    

rule summarise_sliding_window_theta_values:
  input:
    files=CHROMPT
  output:
    "results/{mode}/summarized/sliding_window_theta/{p1}--size-{window_size}--step-{window_step}.tsv"
  log:
    "results/logs/summarise_sliding_window_theta_values/{mode}/{p1}--size-{window_size}--step-{window_step}.txt"
  shell:
    "((echo \"region\tChr\tmidPos\ttW\ttP\ttF\ttH\ttL\tTajima\tfuf\tfud\tfayh\tzeng\tnSites\"; cat {input.files}) > {output}; "
    " sed -i '/#(indexStart,indexStop)(firstPos_withData,lastPos_withData)(WinStart,WinStop)/d' {output}) > {log} 2>&1 "
  