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
        try{
            junit '**/target/surefire-reports/TEST-*.xml'
            //read xml report to validate 
            //results = new XmlSlurper().parse("RockAndRoll.xml")
            new File("**/target/surefire-reports/").eachFileMatch(~/.*.xml/){
                file -> println file.getName()
            }
        }catch(Exception){
            currentBuild.result = 'FAILED'
        }
        
    }
}