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
                sh 'mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=ada1d856bbb16e3f855e86a76069af9aa360f3ed'
                echo 'http://localhost:9000/dashboard/index/org.springframework.samples:spring-petclinic'
    		}
    	}
    	stage('Promote') {
    		steps {
                script {
                    if(currentBuild.result == null){ 
                        sh 'mvn package'
                    }else{
                        echo currentBuild.result
                        echo 'THERE WERE ISSUES ON THIS BUILD'
                    }
                }
    		}
    	}
   }
}