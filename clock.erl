-module(clock).
-export([start/2, stop/0]).

start(Time, Fun) ->
    register(clock, spawn(fun() -> tick(Time, Fun) end)). % 登録済みプロセスに「clock」として登録する

stop() -> clock ! stop.

tick(Time, Fun) ->
    receive
        stop ->
            void
    after Time -> % Time[ms]ごと呼ばれる（Timeだけ時間がたったら）
        Fun(),
        tick(Time, Fun)
    end.
