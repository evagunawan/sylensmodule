process RUN_SYLENS {

    tag "$reads"
    label 'process_single'

    container='docker.io/evagunawan/sylens'

    input:
        tuple val(meta), path(reads)

    output:
        path("*_downsampled_*")  , emit: downsampled
        path("sylens_log_${reads[0]}.txt")   , emit: log

    when:
        task.ext.when == null || task.ext.when

    script:
    
        def args = task.ext.args ?:''

        """
        sylens $reads ${params.subsample} ${params.percentage} ${params.filetype} ${params.compression} ${params.outputFormat} ${params.seed} ${params.outputType} &> sylens_log_${reads[0]}.txt       """

}