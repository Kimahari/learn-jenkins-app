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
        stage('install') {
            agent {
                docker {
                    image 'node:22-alpine'
                    args '-p 3000:3000'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "Running inside Node 22 container"
                    echo "Installing dependencies..."
                    npm install
                '''
            }
        }
        stage('build') {
            agent {
                docker {
                    image 'node:22-alpine'
                    args '-p 3000:3000'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "Running inside Node 22 container"
                    echo "Building the project..."
                    npm run build
                '''
            }
        }
    }
}