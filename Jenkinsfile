
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
            //sh 'pwsh UnitTestMining.ps1'
        }catch(Exception e){
            currentBuild.result = 'UNSTABLE'
        }finally{
            sh 'ls target/surefire-reports/'
            junit '**/target/surefire-reports/TEST-*.xml'
        }
    }
    stage('Fingerprint') {
        echo 'archiving'
        //archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
    }
}