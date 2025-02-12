pipeline {
    agent any
    tools {
        git 'Default'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Invoke Lambda') {
            steps {
                script {
                    sh 'aws lambda invoke --function-name myLambdaFunction --payload file://payload.json result.json'
                }
            }
        }
    }
}
