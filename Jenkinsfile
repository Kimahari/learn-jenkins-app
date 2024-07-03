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
        stage('Install') {
            agent {
                docker {
                    image 'node:22-alpine'
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
        stage('Build and Test in Parallel') {
            parallel {
                stage('Build') {
                    agent {
                        docker {
                            image 'node:22-alpine'
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
                stage('Test') {
                    agent {
                        docker {
                            image 'node:22-alpine'
                            reuseNode true
                        }
                    }
                    steps {
                        sh '''
                            echo "Running inside Node 22 container"
                            echo "Testing the project..."
                            npm run test
                        '''
                    }
                }
            }
        }
    }
}
