process RUN_SYLENS {

    tag "$reads"
    label 'process_single'

    container='docker.io/evagunawan/sylens'

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
        sylens $reads > sylens_log.txt
        """
    
    

    // """
    // cat <<-END_VERSIONS > versions.yml
    // "${task.process}"
        // sylens:: $VERSION
    // END_VERSIONS
    // """
}