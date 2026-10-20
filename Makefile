.PHONY: gen lint breaking check

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
	cd rust && cargo fmt --check && cargo clippy --all-targets -- -D warnings
