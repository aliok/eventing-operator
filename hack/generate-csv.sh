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

# This script builds all the YAMLs that Knative eventing operator publishes.
# It may be varied between different branches, of what it does, but the
# following usage must be observed:
#
# generate-yamls.sh  <repo-root-dir> <generated-yaml-list>
#     repo-root-dir         the root directory of the repository.
#     generated-yaml-list   an output file that will contain the list of all
#                           YAML files. The first file listed must be our
#                           manifest that contains all images to be tagged.

operator-sdk olm-catalog gen-csv            \
  --csv-config    hack/csv-config.yaml      \
  --from-version  0.10.1                    \
  --csv-version   0.10.2                    \
  --operator-name knative-eventing-operator \
  --update-crds                             \
  --csv-channel   alpha                     \
  --default-channel


# Bug1: operator-name in csv-config.yaml is ignored, needed to pass --operator-name param
  # filed https://github.com/operator-framework/operator-sdk/issues/2266
# FIXED: # Bug2: even with workaround from #1, package.yaml generation is using the wrong place
  # fixed with o-sdk 0.12

# Improvement1: Bump feature
  - Unless `--from-version` is passed explicitly, find out latest version in deploy/olm-catalog (very hard doing semver sort with bash. e.g. 1.10.0 < 1.3.0)
    - Use https://github.com/coreos/go-semver for semver sort
  - Use `--from-version` as that version
  - Semver patch bump `--from-version` and use `--csv-version` as that, unless `--csv-version` is passed explicitly

  # Filed: https://github.com/operator-framework/operator-sdk/issues/2267

# Improvement2:
  - Same as #1, but don't auto bump. Require --csv-version!

Do we need containerImage in CSV? If yes, we need to upgrade that one manually!
