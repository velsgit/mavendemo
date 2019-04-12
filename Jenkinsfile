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
      stage('Docker Push')
        {
            steps
            {
                script
                {
                                                    
                    sh "sed 's!will!appcom!g' pom.xml" 
                    //sh "login="(aws ecr get-login --no-include-email --region us-east-2)" | sed 's/https:\/\// /'"
                    //sh "eval $login"
                    //sh "eval ${(aws ecr get-login --no include-email --region us-east-2)}"
                    //sh("eval \$(aws ecr get-login --no-include-email --region us-east-2 | sed 's|https://||') > demo.sh")
                    //sh" chmod 777 ./demo.sh"
                    //sh" ./demo.sh"                    
                    
                    //sh "docker tag demo:latest 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                    //sh "docker push 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                    docker.withRegistry("https://630578467060.dkr.ecr.us-east-2.amazonaws.com/demo", "ecr:us-east-2:4e98734b-6e1b-4025-9b36-9886838b99ce") {
                       //docker.build("demo:$BUILD_NUMBER",".")
                       def customImage = docker.build("demo:$BUILD_NUMBER")
                       //sh "docker tag demo:latest 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                       echo "$customImage"
                       //docker.image("demo").push()
                       customImage.push()
                    }
                    
                } 
            }
            
        }
        stage('Deploy Ecr')
        {
           environment {
              
              REGION="us-east-2"
              REPOSITORY_NAME="demo"
              CLUSTER="samplecluster"
              FAMILY="app-up-pvt"
              NAME="app-up-pvt"
              SERVICE_NAME="sampleservice"
           }
           steps
           {
             script
             {               
                REPOSITORY_URI= sh (script:"aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | sed 's/\"//g' ",returnStdout: true).trim()
                echo"repo $REPOSITORY_URI"
                //IMAGE_UR=sh(script:"$REPOSITORY_URI:${BUILD_NUMBER}")
                IMAGE_UR =REPOSITORY_URI+":"+BUILD_NUMBER
                echo "image $IMAGE_UR"
                sh "sed -e 's!630578467060.dkr.ecr.us-east-2.amazonaws.com/demo!$IMAGE_UR!g' taskdef.json > ${NAME}-v_${BUILD_NUMBER}.json"
                sh "aws ecs register-task-definition  --family ${FAMILY} --region ${REGION} --network-mode bridge --cli-input-json file://${WORKSPACE}/${NAME}-v_${BUILD_NUMBER}.json"
                //aws ecs register-task-definition  --family linux --region us-east-2 --network-mode bridge --cli-input-json file://taskdef.json
                SERVICES=sh (script:"aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]",returnStdout: true)
                echo "service $SERVICES"
                REVISION=sh (script:"aws ecs describe-task-definition --task-definition ${NAME} --region ${REGION} | jq .taskDefinition.revision",returnStdout: true)
                echo "revision $REVISION"
                if("$SERVICES" == "")               
                {
                 echo "entered existing service"
                 DESIRED_COUNT=sh (script:"aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount",returnStdout: true)
                 echo "desrire $DESIRED_COUNT"
                 //if("$DESIRED_COUNT" == 0)
                   // DESIRED_COUNT="1"
                 cmd = '''aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT}'''
                 echo "$cmd"
                 sh "$cmd" 
                 sh "aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount"
               }
                 
                 
             } 
           }
        }     
  }
 }
