%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc ruil startup code

-module(ruil).
-author('author <author@example.com>').
-export([start/0, stop/0]).

%% @spec start() -> ok
%% @doc Start the ruil server.
start() ->
    ok = application:ensure_started(sasl),
    ok = application:ensure_started(syntax_tools),
    ok = application:ensure_started(compiler),
    ok = application:ensure_started(goldrush),
    ok = application:ensure_started(lager),
    ok = application:ensure_started(crypto),
    ok = application:ensure_started(inets),
    ok = application:ensure_started(mochiweb),
    ok = application:ensure_started(webmachine),
    application:start(ruil).

%% @spec stop() -> ok
%% @doc Stop the ruil server.
stop() ->
    Res = application:stop(ruil),
    application:stop(webmachine),
    application:stop(mochiweb),
    application:stop(inets),
    application:stop(crypto),
    application:stop(lager),
    application:stop(goldrush),
    application:stop(compiler),
    application:stop(syntax_tools),
    application:stop(sasl),
    Res.
