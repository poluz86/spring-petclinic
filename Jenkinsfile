pipeline {
	agent any

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
                sh 'mvn test -ff'
    			junit '**/target/surefire-reports/TEST-*.xml'
    		}
    	}
    	stage('SonarQube') {
    		steps {
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