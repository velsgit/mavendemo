import groovy.json.JsonSlurper
pipeline{  
  agent any
  stages{
      stage('build project')
      {
        steps
        {         
          sh "mvn clean install"          
        }
      }
      stage('Sonarqube Analysis'){
        environment {
           scannerHome = tool 'SonarQube Runner'
        }
        steps {
          withSonarQubeEnv('SonarQube Scanner') {
             sh 'mvn sonar:sonar'               
          }
        }
      }
      
         
  }
 }
