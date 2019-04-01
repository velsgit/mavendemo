pipeline{
  agent any
  environment 
    {
        REGION = 'us-east-2'        
        VERSION = 'latest'
        PROJECT = 'tap_sample'
        IMAGE = 'demo'
        ECRURL = '630578467060.dkr.ecr.us-east-2.amazonaws.com/demo'
        ECRCRED = 'ecr:eu-central-1:tap_ecr'
    }
  stages{
      stage('Docker build')
        {
            steps
            {
                script
                {
                    // Build the docker image using a Dockerfile
                    sh "temp=aws --version"
                    sh "echo "temp""                 
                    sh "sed 's!will!appcom!g' pom.xml"                    
                    sh("eval \$(aws ecr get-login --no-include-email | sed 's|https://||')")
                    docker.build("$IMAGE",".")
                }
            }
        }
  }
 }
