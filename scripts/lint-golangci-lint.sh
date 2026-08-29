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

# This script lints the Go code with `golangci-lint`.
#
# Usage:
#   scripts/lint-golangci-lint.sh

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

ret=0
GOLANGCI_LINT="github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.11.4"
out=$(go run "${GOLANGCI_LINT}" run ./... 2>&1) || ret=$?

if [[ $ret -ne 0 ]]; then
  echo "${out}" >&2
  a2t::log::error 'Golangci-lint has failed.'
  exit 1
fi
