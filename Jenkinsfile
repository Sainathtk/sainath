pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'               // AWS region for resources
        S3_BUCKET = '467.devops.candidate.exam' // S3 bucket for Terraform state
        TF_BACKEND_KEY = 'sainathkulsange' // Replace with your first and last name
        GITHUB_REPO = 'https://github.com/Sainathtk/sainath.git' // Replace with your repo URL
        LAMBDA_API_URL = 'https://bc1yy8dzsg.execute-api.ap-south-1.amazonaws.com/v1/data'
        X_SIEMENS_AUTH = 'test' // Security header for API
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo "Cloning the repository from GitHub"
                git url: "${GITHUB_REPO}", branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform"
                script {
                    sh 'terraform init -backend-config="bucket=${S3_BUCKET}" -backend-config="key=${TF_BACKEND_KEY}" -backend-config="region=${AWS_REGION}"'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                echo "Validating Terraform configuration"
                script {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Running Terraform Plan"
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform configuration"
                script {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Invoke Lambda') {
            steps {
                echo "Invoking Lambda function"
                script {
                    // Retrieve Private Subnet ID from Terraform output
                    def subnetId = sh(script: "terraform output -raw private_subnet_id", returnStdout: true).trim()

                    // Prepare payload for the API call
                    def payload = """{
                        "subnet_id": "${subnetId}",
                        "name": "sainath kulsange",
                        "email": "sainathkulsange60@gmail.com"
                    }"""

                    // Invoke the API endpoint using curl
                    sh """
                        curl -X POST ${LAMBDA_API_URL} \
                        -H "Content-Type: application/json" \
                        -H "X-Siemens-Auth: ${X_SIEMENS_AUTH}" \
                        -d '${payload}'
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
            // You can include steps to send an email or notifications here
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
