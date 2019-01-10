# cf-labs

A quick lab project to simulate the open source Cloud Foundry installation trough concourse into AWS.

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

### post-trusty fixes (after July 2018)

At this point it's unclear whether it's due to the cf-deployments or the xenial base distro, but the `diego-api` components fail to start if all deployment manifests are left on latest. In addtion, stratos versions higher than `2.0.0` fail to start on pre-July CF. As a result to this, the following hotfix needs to be executed through fly (required addtions are in the pipeline).

Only run this once the `fly sp` command has been executed in the previous step as it depends on the resources from that.
```
fly -t CONCOURSE-LOCAL check-resource --resource awslab/cf-deployment --from ref:4f8f07389a640c52db4f0aca47db7e44d01a0f17
fly -t CONCOURSE-LOCAL check-resource --resource awslab/stratos --from ref:e52e4588fea773591e0306c481831a7934a07606
```

Investigation is ongoing into why this is happening and what can be done to fix it. In the meantime this makes the stack and pipeline functional, albeit on lower than current version.


## Install

Once the pipeline is imported and unpaused, you can launch it with the `bootstrap-terraform-state` job. Select the job in the GUI and press the + sign in the upper right corner.
If this step has completed start the `pave-bosh-lite` job. This should lead the install through to the very end where you will presented with login details to CF by the output of the `cf-lite-setup` and the `cf-ui-deploy` jobs.
