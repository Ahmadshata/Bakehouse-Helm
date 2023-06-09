pipeline {
    agent { label 'myagent' }
    stages {
        stage('build') {
            steps {
                echo 'build'
                script{
                    if (BRANCH_NAME == "dev" || BRANCH_NAME == "test" || BRANCH_NAME == "preprod") {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh '''
                                docker login -u ${USERNAME} -p ${PASSWORD}
                                docker build -t ahmadesmailshata/bakehouseiti:v${BUILD_NUMBER} .
                                docker push ahmadesmailshata/bakehouseiti:v${BUILD_NUMBER}
                                echo ${BUILD_NUMBER} > ../build.txt
                            '''
                        }
                    }
                    else {
                        echo "user choosed ${BRANCH_NAME}"
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                echo 'deploy'
                script {
                    if (BRANCH_NAME == "release") {
                        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                            sh '''
                                export BUILD_NUMBER=$(cat ../build.txt)
                                mv Deployment/deploy.yaml Deployment/deploy.yaml.tmp
                                cat Deployment/deploy.yaml.tmp | envsubst > Deployment/deploy.yaml
                                rm -f Deployment/deploy.yaml.tmp
                                kubectl apply -f Deployment --kubeconfig ${KUBECONFIG} -n ${BRANCH_NAME}
                            '''
                        }
                    }
                }
            }
        }
    }
}
