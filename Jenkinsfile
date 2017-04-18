node('master') {
	properties([pipelineTriggers([cron('H 22 * * *')])])
	stage 'Cloning Repo'
		git credentialsId: 'ghsignin', url: 'https://github.com/BlueBikeSolutions/github-issues-csv'
		checkout scm
		echo "\u2600 BUILD_URL=${env.BUILD_URL}"
		def workspace = pwd()
		echo "\u2600 workspace=${workspace}"
    	stage 'Running Issues Extractor Script'
		withCredentials([usernamePassword(credentialsId: 'ghsignin', passwordVariable: 'ghpass', usernameVariable: 'ghuser')]) {
		sh 'cp .env.example .env'
		sh 'sed -i "s/GITHUB_USER=.*/GITHUB_USER=${ghuser}/" .env'
		sh 'sed -i "s/GITHUB_PASSWORD=.*/GITHUB_PASSWORD=${ghpass}/" .env'
		sh 'sed -i "s#GITHUB_REPO=.*#GITHUB_REPO=${ghrepo}#g" .env'
		sh 'cat .env'
		sh 'docker-compose -H $DOCKER_HOST_HOST down --remove-orphans -v'
		sh 'docker-compose -H $DOCKER_HOST_HOST -p master up --build --force-recreate'
		sh 'docker -H $DOCKER_HOST_HOST cp master_gh2csv_1:/opt/github-issues-csv/issues.csv .'
	stage 'Archiving issues.csv'
		archiveArtifacts artifacts: 'issues.csv'
	stage 'Emailing Issues File'
		emailext attachmentsPattern: '**/issues.csv', body: 'Attached is the start-of-day issues file', subject: 'LSE development issues export', to: 'redcrosslse@bluebike.com.au'
		}
}
