node {
    stage('Checkout') {
        git 'https://github.com/poluz86/spring-petclinic.git' 
    }
    stage('Compile') {
        timeout(time:5, unit:'MINUTES'){
            sh 'mvn clean compile'
        }
    }
    stage('Unit Test'){
        echo "cd /"
        echo "mvn clean test"
    }
}