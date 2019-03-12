pipeline{
  agent any 
  stages{
      stage('Sonarqube Analysis') {
        environment {
           scannerHome = tool 'SonarQube Scanner'
        }
        steps {
          withSonarQubeEnv('Sonar_server') {
             sh 'mvn sonar:sonar' +
             '-Dsonar.projectKey = javapipe' +
             '-Dsonar.Name = javadeclarativepipe' +
             '-Dsonar.login = keshav' +
             '-Dsonar.password = Keshav@123' 
          }
        }
      }
  }
 }
