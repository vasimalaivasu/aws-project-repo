pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "<dockerhub-username>/java-demo-app"
        DOCKER_TAG   = "latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: '<YOUR-GITHUB-REPO-URL>'
            }
        }

        stage('Build with Maven') {
            steps {
                dir('java-app') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('java-app') {
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE:$DOCKER_TAG
                    '''
                }
            }
        }
    }
}
