pipeline {
    agent any

    stages {
        // this is a comment

        /*
            this is a block comment
        */
        
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
                    npm ci
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
        stage('E2E-Test') {
            agent {
                docker {
                    image 'mcr.microsoft.com/playwright:v1.45.1-jammy'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "Running inside Node playwright container"
                    echo "Testing the project..."
                    node_modules/.bin/serve -s build &
                    sleep 10
                    npx playwright test
                '''
            }
        }
    }

    post {
        always {
            echo 'This will always run'
            junit 'test-results/**/*.xml'
        }
    }
}
