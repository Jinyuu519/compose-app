pipeline {
  agent any

  environment {
    REGISTRY_CREDENTIALS = 'dockerhub-credentials'
    IMAGE_NAME = 'jinyuu519/compose-app'
    IMAGE_TAG  = '1.0-${env.BUILD_NUMBER}'
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/youruser/compose-app.git', branch: 'main'
      }
    }

    stage('Test') {
      steps {
        sh 'npm install'
        sh 'npm test'
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
          credentialsId: "${env.REGISTRY_CREDENTIALS}",
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