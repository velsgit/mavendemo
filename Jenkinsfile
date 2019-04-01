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
                    sh "sed 's!will!appcom!g' pom.xml" 
                    //sh "login="(aws ecr get-login --no-include-email --region us-east-2)" | sed 's/https:\/\// /'"
                    //sh "eval $login"
                    //sh "eval ${(aws ecr get-login --no include-email --region us-east-2)}"
                    sh("eval \$(aws ecr get-login --no-include-email --region us-east-2 | sed 's|https://||') > demo.sh")
                    sh" chmod 777 ./demo.sh"
                    sh" ./demo.sh"
                    docker.build("$IMAGE",".")
                    sh "docker tag demo:latest 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                    sh "docker push 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"

                }
            }
        }
  }
 }
