pipeline {
    agent any

    stages {
        stage('w/o docker') {
            steps {
                sh '''
                    echo "Without docker"
                    ls -la
                    touch container-no.txt
                '''
            }
        }
        stage('with docker') {
            agent {
                docker {
                    image 'node:22'
                    args '-p 3000:3000'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "Running inside Node 22 container"
                    node --version
                    npm --version
                '''
            }
        }
    }
}
