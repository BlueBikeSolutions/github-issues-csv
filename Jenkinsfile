node('master') {
	stage 'Cloning Repo'
	    git credentialsId: 'ghsignin', url: 'https://github.com/BlueBikeSolutions/github-issues-csv'
	    checkout scm
	    echo "\u2600 BUILD_URL=${env.BUILD_URL}"
            def workspace = pwd()
            echo "\u2600 workspace=${workspace}"
    stage 'Running Issues Extractor Script'
		withCredentials([usernamePassword(credentialsId: 'ghsignin', passwordVariable: 'ghpass', usernameVariable: 'ghuser')]) {
		sh 'docker-compose -H $DOCKER_HOST_HOST down --remove-orphans -v'
		sh 'docker-compose -H $DOCKER_HOST_HOST up -d --force-recreate --build'
		}
}
