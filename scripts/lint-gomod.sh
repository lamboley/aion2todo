#!/usr/bin/env bash

# Copyright (c) 2026 Lucas Lamboley.
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

# This script checks that `go.mod` and `go.sum` are tidy.
#
# Usage:
#   scripts/lint-gomod.sh

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

ret=0
out=$(go mod tidy -diff 2>&1) || ret=$?

if [[ $ret -ne 0 ]]; then
  echo "${out}" >&2
  a2t::log::error 'Go modules are not tidy. Run scripts/update-gomod.sh'
  exit 1
fi
