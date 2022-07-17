-module(practice).
-export([benchmark/2]).

benchmark(N, M) ->
    % リングの作成
    RingNodes = for(1, N, fun() -> spawn( fun() -> ring_node() end) end),
    [FirstRingNode|_] = RingNodes,
    connect(RingNodes, FirstRingNode),
    statistics(runtime),
    statistics(wall_clock),
    FirstRingNode ! {M, FirstRingNode, self()},
    receive
        finish ->
            io:format("finish!!!~n"),
            finish
    end,
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    U1 = Time1 * 1000 / (N * M),
    U2 = Time2 * 1000 / (N * M),
    io:format("N(~p) x M(~p) : time per message passing = ~p (~p) microseconds, total = ~p (~p) milliseconds ~n", [N, M, U1, U2, Time1, Time2]).

connect(RingNodes, FirstRingNode) ->
    case RingNodes of
        [RingNode|[]] ->
            RingNode ! {start, FirstRingNode};
        [RingNode, NextRingNode|T] ->
            RingNode ! {start, NextRingNode},
            connect([NextRingNode|T], FirstRingNode)
    end.

ring_node() ->
    receive
        {start, NextNode} ->
            messenger(NextNode);
        _ ->
            void
    end.

messenger(NextRingNode) ->
    ThisNode = self(),
    receive
        {0, ThisNode, Benchmarker} -> % M周おわったら終了をお知らせ
            Benchmarker ! finish,
            NextRingNode ! die;
        {M, ThisNode, Benchmarker} -> % わたってきたFirstRingNode が自分だったら次の周にうつる
            NextRingNode ! {M - 1, ThisNode, Benchmarker},
            messenger(NextRingNode);
        {M, FirstRingNode, Benchmarker} -> % FirstRingNode ではない場合は次にメッセージを送るだけ
            NextRingNode ! {M, FirstRingNode, Benchmarker},
            messenger(NextRingNode);
        die ->
            NextRingNode ! die
    end.

for(N, N, F) -> [ F() ];
for(I, N, F) -> [ F() | for(I+1, N, F) ].