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
                    //sh("eval \$(aws ecr get-login --no-include-email --region us-east-2 | sed 's|https://||') > demo.sh")
                    //sh" chmod 777 ./demo.sh"
                    //sh" ./demo.sh"                    
                    
                    //sh "docker tag demo:latest 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                    //sh "docker push 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                    docker.withRegistry("https://630578467060.dkr.ecr.us-east-2.amazonaws.com/demo", "ecr:us-east-2:4e98734b-6e1b-4025-9b36-9886838b99ce") {
                       //docker.build("demo:$BUILD_NUMBER",".")
                       def customImage = docker.build("demo:$BUILD_NUMBER")
                       //sh "docker tag demo:latest 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
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
              FAMILY="linux"
              NAME="samtaskdefinition"
              SERVICE_NAME="sampleservice"
           }
           steps
           {
             script
             {               
                def REPOSITORY_URI= sh (script:"aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | sed 's/\"/ /g' ",returnStdout: true).trim()
                def IMAGE_URI= sh ("${REPOSITORY_URI}:${BUILD_NUMBER}")
                echo "hi $IMAGE_URI"
                sh "sed -i -e '/image/ s/630578467060 .*/ $IMAGE_URI/' taskdef.json > ${NAME}-v_${BUILD_NUMBER}.json"
                sh "aws ecs register-task-definition  --family ${FAMILY} --region ${REGION} --network-mode bridge --cli-input-json file://${WORKSPACE}/${NAME}-v_${BUILD_NUMBER}.json"
                def SERVICES=sh (script:"aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .failures[]")
                //def task=sh (script:"aws ecs register-task-definition --family ${FAMILY} --network-mode bridge --region ${REGION} --container-definitions "[{"name":"app-up-pvt","hostname":"app-up-pvt","portMappings":[{"hostPort":8989,"protocol":"tcp","containerPort":80}],"cpu":128,"memoryReservation":512,"image":"630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER","essential":true}]")
                //def task =sh (script:"aws ecs register-task-definition --family linux --network-mode bridge --region us-east-2 --container-definitions "[{\"portMappings\":[{\"hostPort\":8989,\"protocol\":\"tcp\",\"containerPort\":80}],\"cpu\":128,\"memoryReservation\":512,\"image\":\"630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:196\",\"essential\":true,\"hostname\":\"app-dev-pvt\",\"name\":\"app-dev-pvt\"}]""
                def REVISION=sh (script:"aws ecs describe-task-definition --task-definition ${NAME} --region ${REGION} | jq .taskDefinition.revision")
             } 
           }
        }     
  }
 }
