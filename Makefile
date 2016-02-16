WATCH_TARGET = "test"

ifdef t
	 WATCH_TARGET = $(t)
endif

all: warnings dogma test

compile:
	mix compile --warnings-as-errors

dialyzer: compile
	mix dialyzer

dogma:
	mix dogma --format=flycheck

server:
	mix phoenix.server

test:
	mix test $(testargs)

warnings:
	mix compile --force --warnings-as-errors

# See https://facebook.github.io/watchman/docs/watchman-make.html
watch:
	watchman-make -p 'lib/**/*.ex' 'test/**/*.exs' 'test/data/test_cases/*.json' 'config/*.exs' -t $(WATCH_TARGET)

webpack:
	webpack --config webpack.config.js

.PHONY: all compile dialyzer dogma stage-release prod-release server test warnings watch

