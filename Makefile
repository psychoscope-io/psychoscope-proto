.PHONY: gen lint breaking check precommit hooks

gen:
	buf generate

lint:
	buf lint
	buf format -d --exit-code

# Compara contra a ultima tag publicada (ex.: make breaking AGAINST=.git#tag=v0.1.0)
AGAINST ?= .git#branch=main
breaking:
	buf breaking --against '$(AGAINST)'

check: lint gen
	git diff --exit-code gen/
	cd rust && cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo deny check
	git ls-files -z '*.sh' '.githooks/*' | xargs -0 shellcheck
	actionlint

# Verificacoes rapidas, usadas pelo hook pre-commit.
precommit:
	buf lint
	buf format -d --exit-code

# Ativa os hooks versionados em .githooks (commit-msg, pre-commit, pre-push).
hooks:
	git config core.hooksPath .githooks
