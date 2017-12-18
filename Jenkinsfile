node {
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