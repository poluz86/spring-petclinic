pipeline {
	agent any

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
                    echo "$env.PATH"
		    		echo "$env.GROOVY_HOME"
                    sh 'groovy sample.groovy'
                    echo "mvn clean compile"
   				}
	    	}
	    }
    	stage('Unit Test') {
    		steps {
                script {
                    try {
                        sh 'mvn test -ff'
                    }catch(Exception ex) {
                        echo "Caught: ${ex}"
                        currentBuild.result = 'UNSTABLE'
                        return
                    }finally {
                        junit '**/target/surefire-reports/TEST-*.xml'
                    }
                }
    		}
    	}

    	stage('SonarQube') {
    		steps {
                script {
                    if(currentBuild.result == 'UNSTABLE'){ 
                        echo "PIPELINE INESTABLE"
                        currentBuild.result = 'ABORTED'
                        return
                    }
                }

    			echo "sonar projectKey"
    			echo "Cyclomatic Complexity mining"
    			echo "Technical Debt mining"
    		}
    	}
    	stage('Promote') {
    		steps {
    			sh 'mvn package'
    		}
    	}
   }
}