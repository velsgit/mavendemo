
pipeline{
  agent any
  stages{
      //stage('build project')
      //{
        //steps
        //{
          //script
          //{            
            //def NUM= ${BUILD_NUMBER}-1
            //echo "Value is ${NUM}this"
            //sh "mvn clean install"
          //}
        //}
      //}
      stage('Docker Push')
        {
            steps
            {
                script
                {
                     NUM1= BUILD_NUMBER.toInteger()
                     echo "Hello $NUM1"
                     Val= '1'.toInteger()
                     echo "H $Val"
                     NUM2= (NUM1)-(Val)
                     //echo "num $NUM"  
                     //sh "Value= $BUILD_NUMBER"
                     //sh "Num =1"
                     //sh "num1="$(($Value-$Num))""
                      echo "Hi $NUM2"
                    //sh "sed 's!will!appcom!g' pom.xml" 
                    //sh "login = sudo aws ecr get-login --no-include-email --region us-east-2"
                    //sh "eval $login"
                    //sh "eval ${(aws ecr get-login --no include-email --region us-east-2)}"
                    //sh("eval \$(aws ecr get-login --no-include-email --region us-east-2 | sed 's|https://||') > demo.sh")
                    //sh" chmod 777 ./demo.sh"
                    //sh" ./demo.sh"                    
                    
                    //sh "docker tag demo:latest 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                    //sh "docker push 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                    docker.withRegistry("https://630578467060.dkr.ecr.us-east-2.amazonaws.com/demo", "ecr:us-east-2:4e98734b-6e1b-4025-9b36-9886838b99ce") {
                    //withDockerRegistry(credentialsId: 'ecr:us-east-2:4e98734b-6e1b-4025-9b36-9886838b99ce', url: 'https://630578467060.dkr.ecr.us-east-2.amazonaws.com/demo') {
                       //docker.build("demo:$BUILD_NUMBER",".")
                       def customImage=docker.build("demo:$BUILD_NUMBER")
                       //sh "docker tag demo:latest 630578467060.dkr.ecr.us-east-2.amazonaws.com/demo:$BUILD_NUMBER"
                       //echo "$customImage"
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
                //env.WORKSPACE = pwd()
                 
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
                //REVISION_STRING= Integer.toString("$REVISION")
                echo "revision $REVISION"
                if("$SERVICES" == "")               
                {
                 echo "entered existing service"
                 DESIRED_COUNT=sh (script:"aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount",returnStdout: true)
                 //DESIRED_COUNT= sh """#!/bin/bash
                 //                    aws ecs describe-services --services $SERVICE_NAME --cluster $CLUSTER --region us-east-2 | grep 'desiredCount' | awk '{print $2}' |  cut -f1 -d',' | head -n 1
                 //                 """                                    
                 //def JSONResponse = sh (script:"aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION}",returnStdout: true)
                 //def json = new JsonSlurper().parseText(JSONResponse)
                 //def DESRIRED_COUNT = json.'services[].desiredCount'
                 echo "desrire${DESIRED_COUNT}value"
                 if("$DESIRED_COUNT" == 0)
                    DESIRED_COUNT="1"
                 sh "aws ecs update-service --cluster ${CLUSTER} --service ${SERVICE_NAME} --region ${REGION} --task-definition ${FAMILY}:${REVISION}"
                  
                 //cmd = '''aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${FAMILY}:"${REVISION}" --desired-count "${DESIRED_COUNT}" '''
                 //echo "$cmd"
                 //sh "$cmd" 
                 //sh (script:"aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount")
                }
                else
                {
                  echo "entered new service"
                  sh "aws ecs describe-clusters --cluster ${CLUSTER} --region ${REGION}"
                  sh "aws ecs create-service --service-name sample --desired-count 0 --task-definition ${FAMILY} --cluster ${CLUSTER} --region ${REGION}"
                }
                 
             } 
           }
        }
         
  }
 }
