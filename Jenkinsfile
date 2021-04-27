pipeline {
    options {
        disableConcurrentBuilds()
        timeout(time: 2, unit: 'HOURS')
    }
    parameters {
        string(name: 'DEFAULT_BRANCH', defaultValue: 'master', description: 'Default branch so you can overwrite the conditions')
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Which environment to build?')
        string(name: 'SLACK_CHANNEL', defaultValue: '#nhsd-dps-vdi-eng', description: 'Which Slack Channel should alerts go to?')
        booleanParam(name: 'RUN_TERRAFORM_DEPLOYMENT', defaultValue: true, description: 'Should the terraform deployment be ran?')

    }
    agent {
        node {
            label 'dpsa-' + params.ENVIRONMENT
        }
    }
    stages {
        stage('Terraform validations') {
            steps {
                sh "make fmt-check"
                sh "TF_LAYER=1_network make terraform-validate"
            }
        }
        stage('VDI deployment') {
            when {
                branch (params.DEFAULT_BRANCH)
                expression {return params.RUN_TERRAFORM_DEPLOYMENT}
            }
            steps {
                echo "Deploying the 1_network layer"
                sh "TF_LAYER=1_network make plan"
                sh "TF_LAYER=1_network TF_AUTO_APPROVE=true make deploy"
            }
        }
    }
    post {
        success {
            script {
                def slackSteps = load 'ci/slackSteps.groovy'

                slackSteps.success(params.ENVIRONMENT, params.SLACK_CHANNEL)
            }
        }
        aborted {
            script {
                def slackSteps = load 'ci/slackSteps.groovy'

                slackSteps.aborted(params.ENVIRONMENT, params.SLACK_CHANNEL)
            }
        }
        unstable {
            script {
                def slackSteps = load 'ci/slackSteps.groovy'

                slackSteps.unstable(params.ENVIRONMENT, params.SLACK_CHANNEL)
            }
        }
        failure {
            script {
                def slackSteps = load 'ci/slackSteps.groovy'

                slackSteps.failure(params.ENVIRONMENT, params.SLACK_CHANNEL)
            }
        }
    }
}
