process RUN_SYLENS {
//Add a parameter and use detect to figure out if one input or two
// sample name path read1 path read2
// use nf-core test data set for sample sheets!
    tag "$reads"
    label 'process_single'

    container='docker.io/evagunawan/sylens'

    input:
        tuple val(meta), path(reads)

    output:
        path("*_downsampled_*")  , emit: downsampled
        path("sylens_log.txt")   , emit: log

    when:
        task.ext.when == null || task.ext.when

    script:
    
        def args = task.ext.args ?:''

        """
        sylens $reads ${params.subsample} ${params.percentage} ${params.filetype} ${params.compression} ${params.outputtype} ${params.seed} > sylens_log.txt
        """

    // """
    // cat <<-END_VERSIONS > versions.yml
    // "${task.process}"
        // sylens:: $VERSION
    // END_VERSIONS
    // """
}