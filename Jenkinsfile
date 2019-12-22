pipeline {
  agent any
  parameters {
    string(name: 'access_key', description: 'Enter Aws access_key')
    password(name: 'secret_key', description: 'Enter AWS Secret key')
    text(name: 'region', defaultValue: 'us-east-1', description: 'Enter the AWS Region')
  }
  stages {
    stage('validate'){
      steps {
        sh 'terraform init'
        sh 'terraform validate'
      }
    }
    stage('plan'){
      steps {
        sh "terraform plan -out=test-plan -var=\"access_key=${params.access_key}\" -var=\"secret_key=${params.secret_key}\" -var=\"region=${params.region}\""
      }
    }
    stage('Approval'){
      input {
        message "shall we Proceed with terraform apply?"
                ok "Yes"
      }
      steps {
        sh "terraform apply -auto-approve -var=\"access_key=${params.access_key}\" -var=\"secret_key=${params.secret_key}\" -var=\"region=${params.region}\""
      }
    }
  }
}
