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
			sh '''
        cp .env.example .env
        sed -i "s/GITHUB_USER=.*/GITHUB_USER=${ghuser}/" .env
        sed -i "s/GITHUB_PASSWORD=.*/GITHUB_PASSWORD=${ghpass}/" .env
        sed -i "s#GITHUB_REPO=.*#GITHUB_REPO=${ghrepo}#g" .env
        cat .env
        pwd; ls -la
        ls -la $(pwd)/docker-compose.yml
        which docker-compose
        docker-compose -f $(pwd)/docker-compose.yml -p githubissuescsv down --remove-orphans -v
        docker-compose -f $(pwd)/docker-compose.yml -p githubissuescsv up --build --force-recreate
        docker cp githubissuescsv_gh2csv_1:/opt/github-issues-csv/issues.csv .
      '''
		}
	stage 'Archiving issues.csv'
		archiveArtifacts artifacts: 'issues.csv'
	stage 'Emailing Issues File'
		emailext attachmentsPattern: '**/issues.csv', body: 'Attached is the start-of-day issues file', subject: 'LSE development issues export', to: 'redcrosslse@bluebike.com.au'
	stage 'Uploading Issues File to S3'
		withAWS(credentials:'s3bbsarchiver') {
    			awsIdentity()
			s3Upload(file:'issues.csv', bucket:'bbsarchive', path:'/lse/issues.csv')
		}
}
