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

# This script formats every Go file with `gofmt -s -w`.
#
# Usage:
#   scripts/update-gofmt.sh

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

function git_find() {
    git ls-files -cmo --exclude-standard \
        ':!:vendor/*'        `# catches vendor/...` \
        ':!:*/vendor/*'      `# catches any subdir/vendor/...` \
        ':!:third_party/*'   `# catches third_party/...` \
        ':!:*/third_party/*' `# catches third_party/...` \
        ':!:*/testdata/*'    `# catches any subdir/testdata/...` \
        ':(glob)**/*.go' \
        "$@"
}

gofmt="$(go env GOROOT)/bin/gofmt"
if [[ ! -x "${gofmt}" ]]; then
    a2t::log::error "Failed to find $gofmt"
    exit 1
fi

git_find -z | xargs -0 --no-run-if-empty "${gofmt}" -s -w
