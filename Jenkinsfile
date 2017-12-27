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
                sh 'grep "git checkout" ../../jobs/$JOB_NAME/builds/$BUILD_NUMBER/log | head -1 | sed \'s/ git checkout -f //g\' | cut -c 3-10 > hash.txt' 
                script{
                    hash = readFile('hash.txt').trim()                 
                    sh 'mvn clean compile'
                }
                echo "${hash}"
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
                    //sh 'mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=ada1d856bbb16e3f855e86a76069af9aa360f3ed' 
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.4.0.905:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=82166ae8f4327f442a649669db82071a767d18fa'
                    echo 'http://localhost:9000/dashboard/index/org.springframework.samples:spring-petclinic'
                }
    		}
    	}
    	stage('Promote') {
    		steps {
                script {
                    if(currentBuild.result == null){ 
                        echo "${hash}"
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