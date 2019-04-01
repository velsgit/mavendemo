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
                    sh'sed 's!/!/efs/appcom!g' docker-entrypoint-temp.sh > docker-entrypoint.sh'
                    docker.build("$IMAGE",".")
                }
            }
        }
  }
 }
