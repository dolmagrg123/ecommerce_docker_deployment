pipeline {
  agent any

  environment {
    DOCKER_CREDS = credentials('docker-hub-credentials')
    DOCKER_USERNAME = "${DOCKER_CREDS_USR}"
    DOCKER_PASSWORD = "${DOCKER_CREDS_PSW}"
  }

  stages {
    stage('Build') {
      agent any
      steps {
        sh '''#!/bin/bash
        echo "Building"
        git clone https://github.com/dolmagrg123/ecommerce_docker_deployment.git
        python3.9 -m venv venv
        source venv/bin/activate
        cd ecommerce_docker_deployment/backend
        git pull
        pip install -r requirements.txt
        '''
      }
    }

    stage('Test') {
      agent any
      steps {
        sh '''#!/bin/bash
        source venv/bin/activate
        pip install pytest-django
        python backend/manage.py makemigrations
        python backend/manage.py migrate
        pytest backend/account/tests.py --verbose --junit-xml test-reports/results.xml
        ''' 
      }
    }

    stage('Cleanup') {
      agent { label 'build-node' }
      steps {
        sh '''
          docker system prune -f
          git clean -ffdx -e "*.tfstate*" -e ".terraform/*"
        '''
      }
    }

    stage('Build & Push Images') {
      agent { label 'build-node' }
      steps {
        sh 'echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin'
        
        // Build and push backend
        sh '''
          docker build -t ecommercebackend:${BUILD_NUMBER} -f Dockerfile.backend .
          docker push ecommercebackend:${BUILD_NUMBER}
        '''
        
        // Build and push frontend
        sh '''
          docker build -t ecommercefrontend:${BUILD_NUMBER} -f Dockerfile.frontend .
          docker push ecommercefrontend:${BUILD_NUMBER}
        '''
      }
    }

    stage('Infrastructure') {
      agent { label 'build-node' }
      steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                         string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')
                         ]) {
        dir('Terraform') {
          sh '''
            terraform init
            terraform apply -auto-approve \
              -var="dockerhub_username=${DOCKER_USERNAME}" \
              -var="dockerhub_password=${DOCKER_PASSWORD}"
          '''
        }
      }
    }
    }

    // stage('Destroy') {
    //   agent { label 'build-node' }
    //   steps {
    //     dir('Terraform') {
    //       sh ''' 
    //         terraform destroy -auto-approve \
    //           -var="dockerhub_username=${DOCKER_USERNAME}" \
    //           -var="dockerhub_password=${DOCKER_PASSWORD}"
    //       '''
    //     }
    //   }
    // }
  }

  post {
    always {
      agent { label 'build-node' }
      steps {
        sh '''
          docker logout
          docker system prune -f
        '''
      }
    }
  }
}
