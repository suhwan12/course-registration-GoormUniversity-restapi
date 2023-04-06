pipeline{
    agent{
        kubernetes{
yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: gradle
    image: gradle:8.0.2-jdk11
    command: ['sleep']
    args: ['infinity']
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ['sleep']
    args: ['infinity']
    volumeMounts:
    - name: registry-credentials
      mountPath: /kaniko/.docker
  volumes: 
  - name: registry-credentials
    secret:
      secretName: regcred  
      items:
      - key: .dockerconfigjson
        path: config.json

'''
      }
    }

    stages{
        stage('checkout'){
          steps{
            container('gradle'){
              git branch: 'main', url: 'https://github.com/suhwan12/course-registration-GoormUniversity-restapi.git'
              }
            }
    	}
    	stage('install gradlew'){
    	    steps{
    	      container('gradle'){
    	        sh 'gradle wrapper --gradle-version 8.0.2'
    	        }
    	    }
    	}
    
        stage('gradle build project'){
            steps{
              container('gradle'){
                sh './gradlew build'
                }
             }
        }
        stage('Build & Tag dokcer image'){
            steps{
                container('kaniko'){
                    sh "executor --dockerfile=Dockerfile \
                    --context=dir://${env.WORKSPACE} \
                    --destination=suhwan11/backend:latest \
                    --destination=suhwan11/backend:${env.BUILD_NUMBER}"
                    
                }
            }
        }
        stage('Update K8s to New Backend Deployment'){
            steps{
                container('gradle'){
                    git branch: 'main' , url:'https://github.com/suhwan12/finalproject-argocd.git'
                    sh 'sed -i "s/image:.*/image: suhwan11\\/backend:${BUILD_NUMBER}/g" back-deployment.yaml'
                    sh 'git config --global user.name suhwan12'
                    sh 'git config --global user.email xman0120@naver.com'
                    sh 'git config --global --add safe.directory /home/jenkins/agent/workspace/Backend-pipeline'
                    sh 'git add back-deployment.yaml'
                    sh 'git commit -m "Jenkins Build Number - ${BUILD_NUMBER}"'
                    withCredentials([gitUsernamePassword(credentialsId: 'github-credentials', gitToolName: 'Default')]) {
                        sh 'git push origin main'
                    }
                }
            }
        }
    }
}
