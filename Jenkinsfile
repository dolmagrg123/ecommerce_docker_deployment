pipeline {
  agent any

  environment {
    DOCKER_CREDS_USR = credentials('DOCKER_CREDS_USR')
    DOCKER_CREDS_PSW = credentials('DOCKER_CREDS_PSW')
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
  }

  stages {
    stage('Build') {
      agent any
      steps {
        sh '''#!/bin/bash
        echo "Building"
        python3.9 -m venv venv
        source venv/bin/activate
        pip install -r backend/requirements.txt
        '''
      }
    }

    stage('Test') {
      agent any
      steps {
        dir('backend') {
            sh '''#!/bin/bash
            python3.9 -m venv venv
            source venv/bin/activate
            pip install -r requirements.txt
            pip install pytest-django

          ''' 
            // export DJANGO_SETTINGS_MODULE=my_project.settings
            // python3.9 manage.py makemigrations
            // python3.9 manage.py migrate
            // pytest account/tests.py --verbose --junit-xml test-reports/results.xml
        }

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
        sh 'echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin'
        
        // Build and push backend
        sh '''
          docker build -t ${DOCKER_CREDS_USR}/ecommercebackend:latest -f Dockerfile.backend .
          docker push ${DOCKER_CREDS_USR}/ecommercebackend:latest
        '''
        
        // Build and push frontend
        sh '''
          docker build -t ${DOCKER_CREDS_USR}/ecommercefrontend:latest -f Dockerfile.frontend .
          docker push ${DOCKER_CREDS_USR}/ecommercefrontend:latest
        '''
      }
    }


    stage('Apply') {
      agent { label 'build-node' }
      steps {
        dir('Terraform') {
          sh '''
            echo "Current working directory:"
            pwd
            terraform init
            terraform destroy -auto-approve \
              -var="dockerhub_username=${DOCKER_CREDS_USR}" \
              -var="dockerhub_password=${DOCKER_CREDS_PSW}"

          '''
        }
      }
    }
    // Add a Cleanup Stage Here
    stage('post stage') {
      agent { label 'build-node' } // Specify your preferred agent here
      steps {
        sh '''
          docker logout
          docker system prune -f
        '''
      }
    }
    }

    // stage('Destroy') {
    //   agent { label 'build-node' }
    //   steps {
    //     dir('Terraform') {
    //       sh ''' 
    //         terraform destroy -auto-approve \
    //           -var="dockerhub_username=${DOCKER_CREDS_USR}" \
    //           -var="dockerhub_password=${DOCKER_CREDS_PSW}"
    //       '''
    //     }
    //   }
    // }
  

  }




