pipeline {
    agent any
    
    triggers {
        pollSCM('* * * * *')  // Poll every minute for changes
    }
    
    stages {
        stage('Clone') {
            steps {
                slackSend channel: '#your-channel', message: "🚀 STARTED: Pipeline started for commit ${env.GIT_COMMIT}"
                checkout scm
                sh 'echo "Repository cloned successfully"'
                sh 'ls -la'
            }
        }
        
        stage('Build') {
            steps {
                slackSend channel: '#your-channel', message: "🔨 BUILD: Building Docker image..."
                sh '''
                  export DOCKER_CONFIG=""
                  docker build -t static-image:${BUILD_NUMBER} .
                  docker tag static-image:${BUILD_NUMBER} static-image:latest
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                slackSend channel: '#your-channel', message: "🚀 DEPLOY: Deploying container..."
                sh '''
                  docker stop static-app || true
                  docker rm static-app || true
                  docker run -d --name static-app -p 8080:80 static-image:latest
                '''
                slackSend channel: '#your-channel', message: "✅ SUCCESS: Deployment complete! Access at: http://localhost:8080"
            }
        }
    }
    
    post {
        failure {
            slackSend channel: '#your-channel', message: "❌ FAILED: Build ${env.BUILD_URL}"
        }
    }
}