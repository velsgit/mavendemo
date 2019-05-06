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
  post {  
         always {  
             echo 'This will always run'  
         }  
         success {  
             echo 'This will run only if successful'  
         }  
         failure {  
             mail bcc: '', body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", charset: 'UTF-8', from: 'vels.dev@gmail.com', mimeType: 'text/html', subject: "ERROR CI: Project name -> ${env.JOB_NAME}", to: "vels.dev@gmail.com";  
         }  
         unstable {  
             echo 'This will run only if the run was marked as unstable'  
         }  
         changed {  
             echo 'This will run only if the state of the Pipeline has changed'  
             echo 'For example, if the Pipeline was previously failing but is now successful'  
         }  
     }        
  
 }
