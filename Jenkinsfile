pipeline{
  agent any 
  stages{
      stage('Sonarqube Analysis') {
        environment {
           scannerHome = tool 'SonarQube Scanner'
        }
        steps {
          withSonarQubeEnv('Sonar_server') {
             sh 'mvn clean package sonar:sonar' +
             '-sonar.projectKey = javapipe' +
             '-sonar.Name = javadeclarativepipe' +
             '-sonar.login = keshav' +
             '-sonar.password = Keshav@123' 
          }
        }
      }
  }
 }
