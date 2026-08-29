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

function a2t::util::download_from_github() {
  [ $# -eq 2 ] ||
    a2t::log::fatal 'download_from_github needs exactly 2 arguments'

  curl --proto '=https' --tlsv1.2 -LsSf -o "${1}" "${2}" ||
    a2t::log::fatal "Failed to download ${2}"
}

# Create a temp dir that'll be deleted at the end of this bash session.
#
# Vars set:
#   A2T_TEMP
function a2t::util::ensure-temp-dir() {
  if [[ -z "${A2T_TEMP-}" ]]; then
    A2T_TEMP=$(mktemp -d 2>/dev/null || mktemp -d -t aion2todo.XXXXXX)
    trap 'rm -rf "${A2T_TEMP}"' EXIT
  fi
}
