pipeline{
  agent any 
  stages{
      stage('Sonarqube Analysis') {
        environment {
           scannerHome = tool 'SonarQube Scanner'
        }
        steps {
          withSonarQubeEnv('Sonar_server') {
             sh 'mvn sonar:sonar'               
          }
        }
      }
  }
 }
