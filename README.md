# cf-labs

A quick lab project to simulate the open source Cloud Foundry installation trough concourse into AWS.

## How-To

Use a concourse 4 for this.

clone the project and `cd` into the folder.

Run the following command to generate an ssh keypair for this project: `ssh-keygen` and then for filename type in `./cflabs.pem`

`cat ./cflabs.pem.pub` - copy the returned value of this command and paste it into the command later on.

`cat /proc/sys/kernel/random/uuid` - add the value of this to your fly command as the bucket suffix to avoid a name clash with an existing s3 bucket.

Run the following fly command once you have logged in to concourse 4 with fly:

```
fly -t CONCOURSE_ALIAS \
    sp \
    -n \
    -p awslab -c pipelines/awslab/pipeline.yml \
    -l pipelines/awslab/params.yml \
    -v aws_tf_access_key="YOUR_ACCESS_KEY_HERE" \
    -v aws_tf_secret_key="YOUR_SECRET_KEY_HERE" \
    -v ec2_instance_key="PASTE_THE_CAT_VALUE_HERE" \
    -v s3_bucket="terraform-UUID_HERE"
```

## Install

Once the pipeline is imported and unpaused, you can launch it with the `bootstrap-terraform-state` job. Select the job in the GUI and press the + sign in the upper right corner.
If this step has completed start the `pave-bosh-lite` job. This should lead the install through to the very end where you will presented with login details to CF by the output of the `cf-lite-setup` and the `cf-ui-deploy` jobs.
