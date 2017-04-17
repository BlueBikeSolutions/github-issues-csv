node('master') {
	stage 'Cloning Repo'
	    git credentialsId: 'ghsignin', url: 'https://github.com/BlueBikeSolutions/github-issues-csv'
	    checkout scm
	    echo "\u2600 BUILD_URL=${env.BUILD_URL}"
            def workspace = pwd()
            echo "\u2600 workspace=${workspace}"
    stage 'Running Issues Extractor Script'
		withCredentials([usernamePassword(credentialsId: 'ghsignin', passwordVariable: 'ghpass', usernameVariable: 'ghuser')]) {
	    	sh 'docker run -H $DOCKER_HOST_HOST --name gh2csv_script -v ${PWD}/issues:/opt/issues gh2csv python main.py -u {ghuser} -p {ghpass} -r {ghrepo} --no-quick >> /opt/issues/issues_{env.BUILD_NUMBER}.csv'
		}
}
