pipeline {
	agent any

    triggers {
        pollSCM 'H/5 * * * *'
    }

    options {
        disableConcurrentBuilds()
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
        lock('myResource'){
            stage('Unit Test') {
                steps {
                    sh 'mvn test'
                }
                post {
                    always {
                        junit '**/target/surefire-reports/TEST-*.xml'
                        publishHTML target: [
                            allowMissing: false,
                            alwaysLinkToLastBuild: false,
                            keepAll: true,
                            reportDir: 'target/site/jacoco-ut',
                            reportFiles: 'index.html',
                            reportName: 'Junit Coverage'
                        ]
                    }
                }
            }
            stage('SonarQube') {
                steps {
                    timeout(time:5, unit:'MINUTES') {
                        sh 'mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=8f1d8a52e382119af681b879462d60cb7c54920d'
                        //sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.4.0.905:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=82166ae8f4327f442a649669db82071a767d18fa'
                        echo 'http://localhost:9000/dashboard/index/org.springframework.samples:spring-petclinic'
                    }
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