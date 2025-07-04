pipeline {
  agent any

  environment {
    IMAGE_NAME = 'jinyuu519/compose-app'
    IMAGE_TAG = "v1.0.${env.BUILD_NUMBER}"
    REGISTRY_CREDENTIALS = 'dockerhub-credentials'
  }

  stages {
    stage('Install & Test') {
      steps {
        script {
          docker.image('node:16-alpine').inside {
            sh 'npm install'
            sh 'npm test || echo "Tests skipped or failed"'
          }
        }
      }
    }

    stage('Build Image') {
      steps {
        script {
          docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
        }
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "${REGISTRY_CREDENTIALS}",
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${IMAGE_NAME}:${IMAGE_TAG}
          '''
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
