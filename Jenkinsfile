#!/usr/bin/env groovy


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
            println new File('pom.xml').exists()
            sh 'mvn test -ff'
    }
    stage('Fingerprint') {
        echo 'archiving'
        //archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
    }
}