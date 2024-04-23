pipeline {
    agent any

    environment {
        REPOSITORY = 'https://github.com/JCzyszczon/assignment_one.git'
        CREDENTIALS = 'db3a7844-4b1f-488c-b77f-eea9ffdf1c43'
        BRANCH = 'master'
        DOCKERHUB_CREDENTIALS = credentials('767a3e7d-821c-4e40-b740-8f4725be8d37')
    }
    
    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Collect') {
            steps {
                git branch: "${BRANCH}", credentialsId: "${CREDENTIALS}", url: "${REPOSITORY}"
            }
        }
        
        stage('Build') 
        {
            steps 
            {
                script 
                {
                    try 
                    {
                        docker.build("devops_lab3", "-f Dockerfile .")
                    } 
                    catch (Exception e) 
                    {
                        currentBuild.result = 'FAILURE'
                        error "There was an error while building this image: ${e.message}"
                    }
                }
            }
        }
        
        stage('Test') 
        {
            steps 
            {
                script 
                {
                    try 
                    {
                        docker.build("devops_test", "-f Dockerfile2 .")
                    } 
                    catch (Exception e) 
                    {
                        currentBuild.result = 'FAILURE'
                        error "There was an error while testing this image: ${e.message}"
                    }
                }
            }
        }
        
        stage('Deploy') 
        {
            agent any
            steps 
            {
                script 
                {
                    try 
                    {
                        sh "docker rm -f devops_lab3 || true"
                        docker.image("devops_lab3").run("-d --name devops_lab3")
                        sh "docker save devops_lab3 -o devops_lab3_${env.BUILD_NUMBER}.tar"
                        archiveArtifacts artifacts: "devops_lab3_${env.BUILD_NUMBER}.tar", onlyIfSuccessful: true
                        stash includes: "devops_lab3_${env.BUILD_NUMBER}.tar", name: "devops_lab3_${env.BUILD_NUMBER}"
                    } 
                    catch (Exception e) 
                    {
                        currentBuild.result = 'FAILURE'
                        error "There was an error while deploying: ${e.message}"
                    }
                }
            }
        }
        stage('Publish') {
            steps {
                sh '''
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                BUILD_NUMBER=''' + env.BUILD_NUMBER + '''
                docker tag devops_lab3:latest jczyszczon/devops_lab3:latest
                docker push jczyszczon/devops_lab3:latest
                docker logout
                '''
            }
        }
    }
}
