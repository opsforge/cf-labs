# cf-labs

A quick lab project to simulate the open source Cloud Foundry installation trough concourse into AWS.

Fully chained and automated pipeline with Concourse 4 support:
![pipeline overview in concourse](https://raw.githubusercontent.com/opsforge/cf-labs/master/docs/img/pipeline.png)

Stratos console auto-deployed:
![stratos console](https://raw.githubusercontent.com/opsforge/cf-labs/master/docs/img/stratos.png)

## How-To

Use a concourse 4 for this.

clone the project and `cd` into the folder.

use the fly CLI to log in (use this address only if using ANViL):
```
fly -t CONCOURSE-LOCAL login -c http://concourse:8003 -u concourse -p Standard1
fly -t CONCOURSE-LOCAL sync
```

Run the following commands to generate the ssh keys and bucket ID:
```
if [[ ! -f ./cflabs.pem ]] ; then ; ssh-keygen -f ./cflabs.pem -N '' ; fi ;
if [[ ! -f ./tfuid ]] ; then ; cat /proc/sys/kernel/random/uuid > ./tfuid.tmp ; fi ;
```

Run the following fly command once you have logged in to concourse 4 with fly:

```
fly -t CONCOURSE-LOCAL \
    sp \
    -n \
    -p awslab -c pipelines/awslab/pipeline.yml \
    -l pipelines/awslab/params.yml \
    -v aws_tf_access_key="YOUR_ACCESS_KEY_HERE" \
    -v aws_tf_secret_key="YOUR_SECRET_KEY_HERE" \
    -v ec2_instance_key="$(cat ./cflabs.pem.pub)" \
    -v s3_bucket="terraform-$(cat ./tfuid.tmp)" \
    -v ec2_private_key="$(cat ./cflabs.pem)"
```

## Install

Once the pipeline is imported and unpaused, you can launch it with the `bootstrap-terraform-state` job. Select the job in the GUI and press the + sign in the upper right corner.
If this step has completed start the `pave-bosh-lite` job. This should lead the install through to the very end where you will presented with login details to CF by the output of the `cf-lite-setup` and the `cf-ui-deploy` jobs.
