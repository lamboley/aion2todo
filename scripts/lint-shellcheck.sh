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

# This script lints each shell script with `shellcheck`.
#
# Usage:
#   scripts/lint-shellcheck.sh

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

SHELLCHECK_IMAGE="docker.io/koalaman/shellcheck:latest"

# Find all shell scripts excluding:
#   - Anything git-ignored
#   - ./.git/*
scripts_to_check=()
while IFS=$'\n' read -r script;
    do git check-ignore -q "$script" || scripts_to_check+=("$script");
done < <(find . -name "*.sh" -not -path "./.git/*")

if [[ "${#scripts_to_check[@]}" -eq 0 ]]; then
    a2t::log::error "No shell scripts found to lint"
    exit 1
fi

SHELLCHECK_OPTIONS=(
    "--external-sources"
    "--color=auto"
)

ret=0
docker run --rm -v "${A2TROOT}:${A2TROOT}" -w "${A2TROOT}" --security-opt label=disable \
    "${SHELLCHECK_IMAGE}" "${SHELLCHECK_OPTIONS[@]}" \
    "${scripts_to_check[@]}" >&2 || ret=$?

if [[ $ret -ne 0 ]]; then
    a2t::log::error 'Shellcheck has failed'
    exit 1
fi
