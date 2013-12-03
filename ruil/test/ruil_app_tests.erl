-module(ruil_app_tests).

-include_lib("eunit/include/eunit.hrl").


start_stop_test_() ->
    {setup,
     fun start/0,
     fun stop/1,
     fun app_is_running/1}.


start() ->
    ok = ruil:start().
 

stop(_) ->
    ok = ruil:stop().
 

app_is_running(_) ->
    timer:sleep(500),
    Apps = application:which_applications(),
    [?_assertEqual(true, lists:keymember(ruil, 1, Apps))].
