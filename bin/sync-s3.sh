#!/usr/bin/env bash
aws s3 cp --recursive --acl=public-read provisioning/ s3://yourcom-infra/
