pipeline {
	agent any

    triggers {
        pollSCM 'H/5 * * * *'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr:'5'))
    }

    environment {
        GROOVY_HOME = '/home/paolo/.sdkman/candidates/groovy/current'
        PATH = "$PATH:/home/paolo/.sdkman/candidates/groovy/current/bin"
    }

	stages {
	    stage('Compile') {
			steps {
	    		timeout(time: 1, unit:'MINUTES'){
                    sh 'pwd'
                    echo "BUILDNUMBER: $BUILD_NUMBER"
                    echo "JOBNAME: $JOB_NAME"
                    sh 'ls ../../jobs/Commit_Phase/builds/79/'
                    //sh "cat ../../jobs/$JOB_NAME/builds/$BUILD_NUMBER/log | head -n 20"                   
                    sh 'groovy sample.groovy'
                    sh 'mvn clean compile'
   				}
	    	}
	    }
    	stage('Unit Test') {
    		steps {
                script {
                    try {
                        sh 'mvn test'
                    }catch(Exception ex) {
                        //echo "Caught: ${ex}"
                        currentBuild.result = 'UNSTABLE'
                    }finally {
                        junit '**/target/surefire-reports/TEST-*.xml'
                    }
                }
    		}
    	}
    	stage('SonarQube') {
    		steps {
                timeout(time:5, unit:'MINUTES') {
                    sh 'mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=ada1d856bbb16e3f855e86a76069af9aa360f3ed'
                    echo 'http://localhost:9000/dashboard/index/org.springframework.samples:spring-petclinic'
                }
    		}
    	}
    	stage('Promote') {
    		steps {
                script {
                    if(currentBuild.result == null){ 
                        sh 'mvn package'
                        archiveArtifacts artifacts: 'target/*.jar'
                    }else{
                        echo 'THERE WERE ISSUES ON THIS BUILD'
                    }
                }
    		}
    	}
   }
}