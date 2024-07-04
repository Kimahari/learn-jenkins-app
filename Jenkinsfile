pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = '2a01736a-dcb2-4feb-b364-55e639aa0b9d'
        NETLIFY_AUTH_TOKEN = credentials('NETLIFY_SITE_SECRET')
    }

    stages {
        stage('Install') {
            agent {
                docker {
                    image 'node:22-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    bname=$(echo origin/main | sed 's/origin\\///')
                    echo $bname
                    echo "Running $bname inside Node 22 container"
                    echo "Installing dependencies..."
                    npm ci
                '''
            }
        }
        stage('Build and Test in Parallel') {
            parallel {
                stage('Build and E2E') {
                    stages {
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
                            post {
                                always {
                                    archiveArtifacts artifacts: 'build/**', followSymlinks: false
                                }
                            }
                        }
                        stage('Build_Docker') {
                            steps {
                                sh '''
                                    bname=$(echo origin/main | sed 's/origin\\///')
                                    echo "Running $bname inside Node 22 container"
                                    echo "Building Docker the project..."
                                    docker build -t learning-jenkins-app:$bname .
                                '''
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
                            post {
                                always {
                                    junit 'playwright.results.xml'
                                }
                            }
                        }
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
                    post {
                        always {
                            junit 'jest-results/**/*.xml'
                        }
                    }
                }
            }
        }
        stage('Deploy Netlify') {
            agent {
                docker {
                    image 'node:22-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "Running inside Node 22 container..."
                    echo "Publishing to Netlify..."
                    node_modules/.bin/netlify --version
                    node_modules/.bin/netlify status
                    node_modules/.bin/netlify deploy --dir=build --prod --json > deploy-output.json
                '''
            }
            script{
                env.DEPLOY_URL = sh(script:"node_modules/.bin/node-jq -r '.deploy_url' deploy-output.json", returnStdout: true)
            }
            post {
                always {
                    echo 'Done deploying to ${env.DEPLOY_URL}'
                    junit 'jest-results/**/*.xml'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
