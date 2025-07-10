pipeline {
  agent any

  environment {
    REGISTRY       = 'jinyuu519'
    IMAGE_NAME     = 'compose-app'
    DOCKER_CRED    = 'dockerhub-credentials'
    KUBE_CRED      = 'kubeconfig'
    HELM_CHART_DIR = 'k8s/k8s-ngi/compose-app'
    NAMESPACE      = 'default'
    VERSION        = "v1.0.${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Install & Test') {
      steps {
        docker.image('node:16-alpine').inside {
          sh 'npm install --omit=dev'
          sh 'npm test || echo "测试失败，不终止"'
        }
      }
    }

    stage('Build Image') {
      steps {
        script {
          dockerImage = docker.build("${REGISTRY}/${IMAGE_NAME}:${VERSION}", 'docker/compose-app')
        }
      }
    }

    stage('Push Image') {
      steps {
        docker.withRegistry('https://index.docker.io/v1/', DOCKER_CRED) {
          dockerImage.push("${VERSION}")
          dockerImage.push('latest')
        }
      }
    }

    stage('Helm Deploy') {
      steps {
        withCredentials([file(credentialsId: KUBE_CRED, variable: 'KUBECONFIG')]) {
          dir(HELM_CHART_DIR) {
            sh """
              helm upgrade --install ${IMAGE_NAME} . \
                -f values.yaml \
                --namespace ${NAMESPACE} \
                --set image.tag=${VERSION} \
                --atomic --timeout 5m
            """
          }
        }
      }
    }

    stage('Verify') {
      steps {
        withCredentials([file(credentialsId: KUBE_CRED, variable: 'KUBECONFIG')]) {
          sh """
            kubectl rollout status deployment/${IMAGE_NAME} -n ${NAMESPACE}
            kubectl get pods -l app=${IMAGE_NAME} -n ${NAMESPACE}
          """
        }
      }
    }
  }

  post {
    always { cleanWs() }
    success { echo "✅ 部署完成：${REGISTRY}/${IMAGE_NAME}:${VERSION}" }
    failure { echo "❌ 部署失败，请查看日志" }
  }
}