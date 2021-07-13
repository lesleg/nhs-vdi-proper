# vdi

## Deployment process

When a merge request has been approved and merged, the branch will be deployed to the `dev` account.

### Testing changes on dev

If you wish to use dev for testing changes on your branch, you can opt to deploy your changes to dev using the repo pipelines

1. Make sure nobody else is using the `dev` account for testing, and ensure that no merge requests are merged while you are testing.
1. Open an MR for your changes.
1. Go to the gitlab pipelines page, and hit `Run Pipeline`.
1. Select your branch from the dropdown
1. In the variables section, enter `TEST_MR_DEPLOYMENT_ON_DEV` as the key and `true` as the value
1. This will start your pipeline, but you will need to manually trigger the job for each terraform layer using the start buttons
