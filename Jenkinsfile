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
                                export check=$(helm list | grep "my-release")
                                if [[  -z $check ]]
                                then
                                    helm install my-release ./my-chart/ --values ./my-chart/dev-values.yaml --set image.tag=${BUILD_NUMBER}
                                else
                                    helm upgrade my-release ./my-chart/ --values ./my-chart/dev-values.yaml --set image.tag=${BUILD_NUMBER}

                            '''
                        }
                    }
                }
            }
        }
    }
}
