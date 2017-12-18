node {
    stage('Checkout') {
        git 'https://github.com/poluz86/spring-petclinic.git' 
    }
    stage('Compile') {
        timeout(time:20, unit:'MINUTES'){
            sh 'mvn -X -U clean package'
        }
    }
    stage('Unit Test'){
        junit '**/target/surefire-reports/TEST-*.xml'
    }
}