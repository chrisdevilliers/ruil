%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the ruil application.

-module(ruil_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for ruil.
start(_Type, _StartArgs) ->
    ruil_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for ruil.
stop(_State) ->
    ok.
