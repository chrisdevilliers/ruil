.PHONY: deps test

all: compile

deps:
	./rebar get-deps

compile:
	./rebar compile

test: compile
	./rebar eunit skip_deps=true

release: compile
	./rebar generate

clean:
	./rebar clean

distclean: clean
	./rebar delete-deps

#docs:
#	@erl -noshell -run edoc_run application '$(APP)' '"."' '[]'
