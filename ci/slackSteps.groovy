def success(environment, slack_channel) {
    slackSend channel: slack_channel,
              color: 'good',
              message: "The ${environment} pipeline <${BUILD_URL}|${currentBuild.fullDisplayName}> succeeded :shipitparrot:"
}

def aborted(environment, slack_channel) {
    slackSend channel:  slack_channel,
                        color: 'warning',
                        message: "The ${environment} pipeline <${BUILD_URL}|${currentBuild.fullDisplayName}> aborted :deal-with-it-parrot:"
}

def unstable(environment, slack_channel) {
    slackSend channel:  slack_channel,
                        color: 'warning',
                        message: "The ${environment} pipeline <${BUILD_URL}|${currentBuild.fullDisplayName}> is unstable :fire:"
}

def failure(environment, slack_channel) {
    slackSend channel:  slack_channel,
                        color: 'danger',
                        message: "The ${environment} pipeline <${BUILD_URL}|${currentBuild.fullDisplayName}> has failed :sob:"
}

return this
