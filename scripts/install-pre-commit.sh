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

# This script installs pre-commit and registers the repository hooks.
#
# Usage:
#   scripts/install-pre-commit.sh

set -euo pipefail

A2TROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)"
source "${A2TROOT}/scripts/lib/init.sh"

cd "${A2TROOT}"

function verify_system() {
  if ! command -v uv >/dev/null 2>&1; then
    a2t::log::fatal "uv is required, run scripts/install-uv.sh first"
  fi
}

function install_pre_commit() {
  a2t::log::info "Installing pre-commit"
  uv tool install pre-commit
}

function setup_hooks() {
  a2t::log::info "Registering git hooks"
  pre-commit install
  pre-commit run --all-files
}

verify_system
install_pre_commit
setup_hooks
