#!/usr/bin/env bash

# Copyright 2019 The Knative Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script generates the CSV(ClusterServiceVersion) YAML that is
# necessary for publishing the operator to OperatorHub.
# It may be varied between different branches, of what it does, but the
# following usage must be observed:
#
# You should only run it with a new release.
#
# The wrapped call to operator-sdk will go and generated the CSV file by
# reading the CRDs, roles and the operator deployment.
# Previous version of the CSV will be used as a basis for the metadata
# that's not changed very often such as project description, website etc.
#
# operator-sdk call will also update the knative-eventing-operator.package.yaml
# file and change the latest version reference in there.
#
# See more info in README.md

# find the latest version from nested directories in deploy/olm-catalog/knative-eventing-operator
LATEST_VERSION=$(find deploy/olm-catalog/knative-eventing-operator/* -maxdepth 1 -type d -exec basename {} \; | sort -V | tail -1)

# read the current/next version from version/version.go
CURRENT_VERSION=$(awk '/Version =/{print $NF}' version/version.go | awk '{gsub(/"/, "", $1); print $1}')

WORKS:

GO111MODULE="on" operator-sdk generate csv            \
  --include       "config/operator.yaml,config/role.yaml,config/300-eventing-v1alpha1-knativeeventing-crd.yaml,config/role_binding.yaml,config/service_account.yaml" \
  --from-version  "0.11.0"       \
  --csv-version   "0.12.0"       \
  --operator-name knative-eventing-operator \
  --csv-channel   alpha                     \
  --default-channel                         \
  --update-crds                             \
  --verbose


==================


GO111MODULE="on" operator-sdk generate csv            \
  --include       "config/operator.yaml,config/role.yaml,config/300-eventing-v1alpha1-knativeeventing-crd.yaml,config/role_binding.yaml,config/service_account.yaml" \
  --from-version  "0.11.0"       \
  --csv-version   "0.12.0"       \
  --operator-name knative-eventing-operator \
  --update-crds                             \
  --csv-channel   alpha                     \
  --default-channel                         \
  --verbose

GO111MODULE="on" operator-sdk generate csv            \
  --include       "config/operator.yaml,config/role.yaml,config/300-eventing-v1alpha1-knativeeventing-crd.yaml,config/role_binding.yaml,config/service_account.yaml" \
  --from-version  "0.11.0"       \
  --csv-version   "0.12.0"       \
  --operator-name knative-eventing-operator \
  --csv-channel   alpha                     \
  --default-channel                         \
  --update-crds                             \
  --verbose

TODO: outputdir

operator-sdk olm-catalog gen-csv            \
  --csv-config    hack/csv-config.yaml      \
  --from-version  "${LATEST_VERSION}"       \
  --csv-version   "${CURRENT_VERSION}"      \
  --operator-name knative-eventing-operator \
  --update-crds                             \
  --csv-channel   alpha                     \
  --default-channel

operator-sdk generate csv            \
  --from-version  "0.11.0"       \
  --csv-version   "0.12.0"       \
  --operator-name knative-eventing-operator \
  --csv-channel   alpha                     \
  --default-channel                         \
  --update-crds                             \
  --verbose


# --operator-name knative-eventing-operator param is not needed after https://github.com/operator-framework/operator-sdk/pull/2297
# is released

# Bug1: operator-name in csv-config.yaml is ignored, needed to pass --operator-name param
  # filed https://github.com/operator-framework/operator-sdk/issues/2266
# FIXED: # Bug2: even with workaround from #1, package.yaml generation is using the wrong place
  # fixed with o-sdk 0.12

# Question: do we need containerImage in CSV? If yes, we need to upgrade that one manually!


Error: required flag(s) "csv-version" not set
Usage:
  operator-sdk generate csv [flags]

Flags:
      --csv-channel string      Channel the CSV should be registered under in the package manifest
      --csv-version string      Semantic version of the CSV
      --default-channel         Use the channel passed to --csv-channel as the package manifests' default channel. Only valid when --csv-channel is set
      --from-version string     Semantic version of an existing CSV to use as a base
  -h, --help                    help for csv
      --inputs stringToString   Key value input paths used in CSV generation.
                                Use this to set custom paths for operator manifests and API type definitions
                                E.g: --inputs deploy=config/production,apis=pkg/myapp/apis
                                Supported input keys:
                                        - deploy=<project-relative path to root directory for operator manifests (Deployment, RBAC, CRDs)>
                                        - apis=<project-relative path to root directory for API type defintions>
                                 (default [deploy=deploy,apis=pkg/apis])
      --operator-name string    Operator name to use while generating CSV
      --output-dir string       Base directory to output generated CSV. The resulting CSV bundle directorywill be "<output-dir>/olm-catalog/<operator-name>/<csv-version>" (default "deploy")
      --update-crds             Update CRD manifests in deploy/{operator-name}/{csv-version} the using latest API's

Global Flags:
      --verbose   Enable verbose logging


### LATEST COMMAND
GO111MODULE="on" operator-sdk generate csv            \
  --inputs        "deploy=config,apis=pkg/apis" \
  --from-version  "0.11.0"       \
  --csv-version   "0.12.0"       \
  --operator-name knative-eventing-operator \
  --csv-channel   alpha                     \
  --default-channel                         \
  --update-crds                             \
  --verbose
