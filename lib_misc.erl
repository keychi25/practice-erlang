-module(lib_misc).
-export([sum/1, sum/2]).
-export([qsort/1]).
-export([pythag/1]).
-export([perms/1]).

sum(L) -> sum(L, 0).

sum([], N) -> N;
sum([H | T], N) -> sum(T, H + N).

% クイックソート
qsort([]) -> [];
qsort([Pivot|T]) ->
  qsort([X || X <- T, X < Pivot]) % Pivotより小さいもののリストを[qsort/1]に実行
  ++ [Pivot] ++ % 普通は使用しないもの
  qsort([X || X <- T, X >= Pivot]). % Pivotよりも大きいもののリストを[qsort/1]に実行

% ピタゴラ数
pythag(N) ->
  [ {A, B, C} ||
    A <- lists:seq(1, N),
    B <- lists:seq(1, N),
    C <- lists:seq(1, N),
    A + B + C =< N,
    A*A + B*B =:= C*C
  ].

% アナグラム
perms([]) -> [[]];
perms(L) -> [[H|T] ||  H <- L, T <- perms(L -- [H]) ].
