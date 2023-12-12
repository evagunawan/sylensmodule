#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.query = "$PWD/*.fastq.gz"
params.inputformat = ''
params.subsample = ''
params.percentage = ''
params.compression = ''
params.outputformat = ''
params.seed = ''
params.outdir = 'results/'


def helpMessage() {
    log.info """
        Usage: Subsampler for FASTQ file(s) [-h] [-s SUBSAMPLE] [-f {fastq,fastq-solexa}] [--seed SEED] [-o {fastq,fastq-solexa}] [-c] [-p] Read1 [Read2]
    
        Enter in FASTQ file(s) and down sample based on a user supplied integer. If no user input is added the entire file is sampled and output as chosen filetype.
    
        Positional arguments:
          Read1                 Add R1/Single-end/Interleaved FASTQ file here. I.E. filename.fastq
          Read2                 Add additional FASTQ file here if paired-end. I.E. R2.fastq
    
        Optional arguments:
          -h, --help            show this help message and exit
          -s SUBSAMPLE, --subsample SUBSAMPLE
                                Enter an integer which will be the total number of down sampling of FASTQ files occuring. Leave blank if no subsampling is desired and file
                                conversion is needed. I.E. --subsample 10000.
          -f {fastq,fastq-solexa}, --filetype {fastq,fastq-solexa}
                                Add what type of fastq file is being input. fastq/fastq-sanger-> uses ASCII offset of 33 whereas fastq-solexa-> uses ASCII of 64. I.E -f
                                fastq-solexa
          --seed SEED           Enter the seed number if you would like to reproduce previous results. I.E. --seed 1691696502
          -o {fastq,fastq-solexa}, --output {fastq,fastq-solexa}
                                Add what type of fastq file is desired at output. I.E --output fastq-solexa
          -c, --compress        Compress fastq file into fastq.gz file on output. I.E. -c
          -p, --percentage      With the -p flag, subsampling is done as a percentage of reads instead of an indicated number of reads. Percentage of reads should be an
                                integer between 1-100. I.E. -p -s 15
    
        Additional information and a README.md can be found at https://github.com/evagunawan/SYLENS
        """
}

if (params.help) {
    helpMessage()
    exit 0
}

process RUN_SYLENS {

    tag "$meta.id"
    label 'process_single'

    container='sylens:latest'

    publishDir "results/"

    input:
        tuple val(meta), path(reads)

    output:
        path "*_downsampled_*"  , emit: downsampled
        path "sylens_log.txt"   , emit: log

    when:
        task.ext.when == null || task.ext.when

    script:
    
        def args = task.ext.args ?:"${meta.id}"

        """
        sylens $reads $params.subsample $params.inputformat $params.percentage $params.compression $params.outputformat $params.seed > sylens_log.txt
        """
    
    

    // """
    // cat <<-END_VERSIONS > versions.yml
    // "${task.process}"
        // sylens:: $VERSION
    // END_VERSIONS
    // """
}

workflow {

    Channel
        fromPath("$meta", checkIfExists: true)
        .into { query_ch}

    RUN_SYLENS(params.query)

}