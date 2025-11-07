pipeline {
    agent any
    
    triggers {
        pollSCM('* * * * *')
    }
    
    stages {
        stage('Clone') {
            steps {
                script {
                    try {
                        slackSend channel: '#lab_jenkind_l3', message: "🚀 STARTED: Pipeline started"
                    } catch (Exception e) {
                        echo "Slack notification failed: ${e.message}"
                    }
                }
                echo "Repository cloned successfully"
            }
        }
        
        stage('Build') {
            steps {
                script {
                    try {
                        slackSend channel: '#lab_jenkind_l3', message: "🔨 BUILD: Building Docker image..."
                    } catch (Exception e) {
                        echo "Slack notification failed: ${e.message}"
                    }
                }
                sh '''
                  echo "Building Docker image..."
                  # Disable Docker credential helper
                  /usr/local/bin/docker --version
                  DOCKER_CONFIG="" /usr/local/bin/docker build -t static-image:${BUILD_NUMBER} .
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    try {
                        slackSend channel: '#lab_jenkind_l3', message: "🚀 DEPLOY: Deploying container..."
                    } catch (Exception e) {
                        echo "Slack notification failed: ${e.message}"
                    }
                }
                sh '''
                  DOCKER_CONFIG="" /usr/local/bin/docker stop static-app || true
                  DOCKER_CONFIG="" /usr/local/bin/docker rm static-app || true
                  DOCKER_CONFIG="" /usr/local/bin/docker run -d --name static-app -p 8080:80 static-image:${BUILD_NUMBER}
                  echo "✅ Deployment complete! Access: http://localhost:8080"
                '''
                script {
                    try {
                        slackSend channel: '#lab_jenkind_l3', message: "✅ SUCCESS: Deployment complete! Access: http://localhost:8080"
                    } catch (Exception e) {
                        echo "Slack notification failed: ${e.message}"
                    }
                }
            }
        }
    }
}