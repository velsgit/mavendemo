import groovy.json.JsonSlurper
pipeline{  
  agent any
  stages{
      stage('build project')
      {
        steps
        {         
          sh "sudo mvn clean install"          
        }
      }
      stage('Sonarqube Analysis'){
        environment {
           scannerHome = tool 'SonarQube Runner'
        }
        steps {
          withSonarQubeEnv('SonarQube Scanner') {
             sh 'sudo mvn sonar:sonar'               
          }
        }
      }
      
         
  }
 }
