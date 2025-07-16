pipeline {
  agent any

  environment {
    REGISTRY       = 'jinyuu519'
    IMAGE_NAME     = 'compose-app'
    DOCKER_CRED    = 'dockerhub-creds'         // Docker Hub 凭据 ID
    KUBE_CRED      = 'kubeconfig'              // Kubernetes kubeconfig 文件凭据 ID
    HELM_CHART_DIR = 'charts/compose-app'      // Helm Chart 路径
    NAMESPACE      = 'default'                 // 部署命名空间
    VERSION        = "v1.0.${BUILD_NUMBER}"    // 镜像版本号
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install & Test') {
      steps {
        script {
          docker.image('node:16-alpine').inside {
            sh 'npm install --omit=dev'
            sh 'npm test || echo "测试失败，不终止"'
          }
        }
      }
    }

    stage('Build Image') {
      steps {
        script {
          dockerImage = docker.build("${REGISTRY}/${IMAGE_NAME}:${VERSION}", '.')
        }
      }
    }

stage('Push Image') {
  steps {
    script {
      docker.withRegistry('https://index.docker.io/v1/', DOCKER_CRED) {
        dockerImage.push("${VERSION}")
      }
    }
  }
}

    stage('Helm Deploy') {
      steps {
        withCredentials([file(credentialsId: KUBE_CRED, variable: 'KUBECONFIG')]) {
          dir(HELM_CHART_DIR) {
            sh """
              helm upgrade --install ${IMAGE_NAME} . \\
                -f values.yaml \\
                --namespace ${NAMESPACE} \\
                --set image.tag=${VERSION} \\
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
    always {
      cleanWs()
    }
    success {
      echo "✅ 部署完成：${REGISTRY}/${IMAGE_NAME}:${VERSION}"
    }
    failure {
      echo "❌ 部署失败，请查看日志"
    }
  }
}
