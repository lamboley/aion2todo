# Copyright (c) 2026 Lucas Lamboley. All rights reserved.
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

##@ Update

.PHONY: update-go
update-go: ## Run `go mod tidy` and gofmt.
	scripts/update-gofmt.sh
	scripts/update-gomod.sh

.PHONY: update
update: update-go ## Run all update scripts.

##@ Lint

.PHONY: lint-sh
lint-sh: ## Run shellcheck.
	scripts/lint-shellcheck.sh

.PHONY: lint-go
lint-go: ## Run all go lint scripts.
	scripts/lint-gomod.sh
	scripts/lint-gofmt.sh
	scripts/lint-golangci-lint.sh

.PHONY: lint
lint: lint-sh lint-go ## Run all lint scripts.

##@ Helpers

.PHONY: clean
clean: ## Clean up build and test artifacts.
	scripts/clean.sh

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
