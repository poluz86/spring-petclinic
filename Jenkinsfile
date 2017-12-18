
node {
    stage('Checkout') {
        git 'https://github.com/poluz86/spring-petclinic.git' 
    }
    stage('Compile') {
        timeout(time:8, unit:'MINUTES'){
            sh 'mvn -X -U clean compile'
        }
    }
    stage('Unit Test') {
        try{
            sh 'mvn test -ff'
            sh 'ls target/surefire-reports/'
            //junit '**/target/surefire-reports/TEST-*.xml'
            //sh 'pwsh UnitTestMining.ps1'
        }catch(Exception e){
            println e.getMessage()
            currentBuild.result = 'FAILED'
        }
    }
    stage('Fingerprint') {
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
    }
}