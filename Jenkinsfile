pipeline{
  agent any 
  stages{
      stage('Sonarqube Analysis') {
        environment {
           scannerHome = tool 'SonarQubeScanner'
        }
        steps {
          withSonarQubeEnv('sonarqube') {
             sh "${scannerHome}/bin/sonar-scanner"
          }
        }
      }
  }
 }
