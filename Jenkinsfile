pipeline {
    agent any

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')
    }


     environment {
         AWS_ACCESS_KEY_ID  = credentials('AWS_ACCESS_KEY_ID')
         AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
   
    stages {
        stage('Plan') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
        
            steps {
                
                sh 'terraform init -input=false'
                sh 'terraform workspace select ${environment} || terraform workspace new ${environment}'

                sh "terraform plan -input=false -out tfplan "
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }
           
                
            

           steps {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                
                sh "terraform apply -input=false tfplan"
            }
        }

        stage('Additional') {
            
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                
                sh """ 
                #!bin/bash
                terraform output kubeconfig > /var/lib/jenkins/workspace/eks-cluster/configuration
                sed -i '1d' configuration
                sed -i '\$d' configuration
                cd /var/lib/jenkins/workspace/eks-cluster
                chmod 777 configuration
                sudo mv configuration /home/ec2-user/.kube/config
                pwd
                sudo bash /home/ec2-user/commands.sh"""
            }
        }
        
        stage('Destroy') {
           
            when {
                equals expected: true, actual: params.destroy
            }
        
        steps {
             
           sh "terraform destroy --auto-approve"
        }
    }

  }
}
