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

# This script checks that every Go file is formatted with `gofmt -s`.
#
# Usage:
#   scripts/lint-gofmt.sh

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

find_files() {
  find . -not \( \
    \( \
    -wholename './.git' \
    -o -wholename './_output' \
    -o -wholename './release' \
    -o -wholename './target' \
    -o -wholename '*/third_party/*' \
    -o -wholename '*/vendor/*' \
    -o -wholename '*/testdata/*' \
    -o -wholename '*/bindata.go' \
    \) -prune \
    \) -name '*.go'
}

gofmt="$(go env GOROOT)/bin/gofmt"
if [[ ! -x "${gofmt}" ]]; then
  a2t::log::error "Failed to find $gofmt"
  exit 1
fi

diff=$(find_files | xargs --no-run-if-empty "${gofmt}" -d -s 2>&1) || true
if [[ -n "${diff}" ]]; then
  a2t::log::warn "${diff}" "Run ./scripts/update-gofmt.sh" >&2
  exit 1
fi
