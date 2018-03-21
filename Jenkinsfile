def containerDB = "serviceapidb"
def containerConfig = "config"
def containerService = "api"

@NonCPS
def verifyOwasp(path) {
    def xml = new XmlSlurper().parse(path)
    xml.site.alerts.each {
        if(it.alertitem.riskdesc.text().contains('High')) {
            return 1
        }
    }

    return 0
}

@NonCPS
def verifyApiTest(path) {
    def apiXML = new XmlSlurper().parse(path)
    def total = 0
    def failed = 0
    def allowed = 0.1
    apiXML.testsuite.testcase.each {
        total++
        if(it.text().contains('Failed')) {
            failed++
        }
    }

    def result = ((failed*100)/total)/100
    println '-------total-------'
    println total

    println '-------failed------'
    println failed
    
    if(result > allowed) {
        return 1
    } else {
        return 0
    }
}

@NonCPS
def verifySmokeTest(path) {
    def smokeXML = new XmlSlurper().parse(path)
    def flag = 0 
    smokeXML.testsuite.testcase.each {
        if(it.text().contains('Failed')) {
            flag = 1
        }
    }

    if(flag == 1) {
        return 1
    }

    return 0
}

@NonCPS
def getCommitMessages() {
    def commitMessages = ""
    currentBuild.changeSets.each {
        set -> set.each {
            entry ->    def commitID = "${entry.commitId}".substring(0, 8)
                        commitMessages += "  ${commitID} by ${entry.author}: ${entry.msg} \n"
        }
    }

    if(commitMessages.length() > 0) {
        commitMessages = "Commits involved: \n" + commitMessages 
    }

    return commitMessages
}

@NonCPS
def getSlackMentions() {
    def authors = []
    def mentions = ""
    def translator = [:]

    translator['Vincent Hwang'] = "<@U70K4PMS4>"
    translator['Luong Dinh'] = "<@U5BFZDGQ3>"
    translator['Shalini Rekulapally'] = "<@U8H3Y4GUD>"
    translator['jesusalayoavila'] = "<@U2TG6D2GL>"
    translator['max.macalupu'] = "<@U8W6RLKG8>"
    translator['Ricardo Jauregui'] = "<@U6WJRS7B3>"
    translator['paolo.quintero'] = "<@U8A83ELPP>"
    translator['Paolo Quintero'] = "<@U8A83ELPP>"
    translator['Jim Hickey'] = "<@U56PLBQF4>"

    currentBuild.changeSets.each {
        set -> set.each {
            entry -> authors << "${entry.author.fullName}"
        }
    }

    authors = authors.unique()
    if(authors.size() == 0){
        return "<@U8A83ELPP>"
    }

    for(a in authors) {
        mentions += translator["$a"] + " "
    }

    return mentions.trim()
}

def stopContainers(option, service, config, db) {
    node('docker.hq.builder') {
        if(option == 1) {
            sh "docker stop ${db}" 
            sh "docker rm ${db}" 
            sh 'docker network rm serviceapi-network'
        }
        if(option == 2) {
            sh "docker stop ${db}" 
            sh "docker rm ${db}" 
            sh "docker stop ${config}" 
            sh "docker rm ${config}" 
            sh 'docker network rm serviceapi-network'
        }
        if(option == 3) {
            sh "docker stop ${db}" 
            sh "docker rm ${db}" 
            sh "docker stop ${config}" 
            sh "docker rm ${config}" 
            sh "docker stop ${service}" 
            sh "docker rm ${service}" 
            sh 'docker network rm serviceapi-network'
        }

    }
}

def stopContainers(service, config, db) {
    node('docker.hq.builder') {
        sh "docker stop ${service}"
        sh "docker stop ${config}"
        sh "docker stop ${db}"
        sh "docker rm ${service}"
        sh "docker rm ${config}"
        sh "docker rm ${db}"
        sh 'docker network rm serviceapi-network'
    }
}

node {
    String cron_string = BRANCH_NAME == "master" ? "@midnight" : ""
    def containerStarted = 0
    def channel = BRANCH_NAME == "CDelivery" ? "#test-notification" : "#service-api-pipelines"
    def mention = "<@U8A83ELPP>"
    def commitMessages = ""
    def slackTitle = BRANCH_NAME == "master" ? "Master Pipeline" : "Feature Pipeline"
    def lockDeploy = 'deploy'
    def lockUnitTest = 'unit'

    properties(
        [
            [
                $class: 'BuildDiscarderProperty',
                strategy: [$class: 'LogRotator', numToKeepStr: '10']
            ],
            pipelineTriggers(
                [
                    cron(cron_string),
                    pollSCM('H/2 * * * *')
                ]
            )
        ]
    )    

    stage('Checkout') {
        git poll: true, branch: BRANCH_NAME, url: 'https://github.com/poluz86/spring-petclinic.git'

        echo 'df'
    }

    stage('Compile') {
        echo 'dsf'
    }

   lock("${lockUnitTest}") {
        stage('Unit Test') {
            echo 'unit'
        }
   }

    stage('Code Analysis') {
        echo 'a'
    }

    stage('Packaging') {
        echo 'a'
    }

    lock("${lockDeploy}") {
        stage('Testing Deploy') {
            echo 'ss'
        }

        stage('Smoke Test') {
            echo 's'
        }

        stage('Api Test') {
            echo 'd'
        }

        stage('Performance Test') {
            echo 'c'
        }

        stage('CleanUp Environment') {
            echo 'b'
        }
    }

    stage('Promote') {
        echo 'a'
    }
}