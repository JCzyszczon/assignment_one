pipeline {
    agent any

    environment {
        REPOSITORY = 'https://github.com/JCzyszczon/assignment_one.git'
        CREDENTIALS = 'db3a7844-4b1f-488c-b77f-eea9ffdf1c43'
        BRANCH = 'master'
    }

    trigger {
	pollSCM('* * * * *')
    }

    stages {
        stage('Start') {
            steps {
                git branch: "${BRANCH}", credentialsId: "${CREDENTIALS}", url: "${REPOSITORY}"
            }
        }

        stage('Build') {
            steps {
                echo "Build start"
                sh '''
                docker build -t devops_lab3 --build-arg PA_TOKEN=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 -f ./Dockerfile .
                '''
                echo "Build end"
            }
        }

        stage("Test") {
            steps {
                echo "Test start"
                sh '''
                docker build -t devops_test -f ./Dockerfile2 .
                '''
                echo "Test end"
            }
        }

        stage("Finish") {
            steps {
                echo "Finish"
                sh '''
                docker run devops_test
                '''
            }
        }
    }
}