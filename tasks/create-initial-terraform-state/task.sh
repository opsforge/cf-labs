#!/bin/bash

set -eu

# Copyright 2017-Present Pivotal Software, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## VERIFY AND ENSURE BUCKET EXISTS
aws s3 ls ${S3_BUCKET_TERRAFORM} --region ${REGION} || \
  ( \
     aws s3 mb s3://${S3_BUCKET_TERRAFORM} --region ${REGION} && \
     aws s3api put-bucket-versioning --bucket ${S3_BUCKET_TERRAFORM} --versioning-configuration Status=Enabled --region ${REGION} \
  )

files=$(aws s3 ls "${S3_BUCKET_TERRAFORM}/" --region ${REGION})

set +e
echo $files | grep '.tfstate'
if [ "$?" -gt "0" ]; then
  echo "{\"version\": 3}" > terraform.tfstate
  aws s3 cp terraform.tfstate "s3://${S3_BUCKET_TERRAFORM}/terraform.tfstate" --region ${REGION}
  set +x
  if [ "$?" -gt "0" ]; then
    echo "Failed to upload empty tfstate file"
    exit 1
  fi
else
  echo "terraform.tfstate file found, skipping"
  exit 0
fi

set +e
echo $files | grep 'creds.yml'
if [ "$?" -gt "0" ]; then
  echo "---" > creds.yml
  aws s3 cp creds.yml "s3://${S3_BUCKET_TERRAFORM}/creds.yml" --region ${REGION}
  set +x
  if [ "$?" -gt "0" ]; then
    echo "Failed to upload empty creds.yml file"
    exit 1
  fi
else
  echo "creds.yml file found, skipping"
  exit 0
fi

set +e
echo $files | grep 'state.json'
if [ "$?" -gt "0" ]; then
  echo "---" > creds.yml
  aws s3 cp state.json "s3://${S3_BUCKET_TERRAFORM}/state.json" --region ${REGION}
  set +x
  if [ "$?" -gt "0" ]; then
    echo "Failed to upload empty state.json file"
    exit 1
  fi
else
  echo "state.json file found, skipping"
  exit 0
fi
