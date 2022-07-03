-module(lib_misc).
-export([sum/1, sum/2]).
-export([qsort/1]).
-export([pythag/1]).
-export([perms/1]).
-export([odds_and_evens/1]).
-export([odds_and_evens_acc/1]).

sum(L) -> sum(L, 0).

sum([], N) -> N;
sum([H | T], N) -> sum(T, H + N).

% クイックソート
qsort([]) -> [];
qsort([Pivot|T]) ->
  qsort([X || X <- T, X < Pivot]) % Pivotより小さいもののリストを[qsort/1]に実行
  ++ [Pivot] ++ % 普通は使用しないもの
  qsort([X || X <- T, X >= Pivot]). % Pivotよりも大きいもののリストを[qsort/1]に実行

% ピタゴラス数
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

% アキュムレータ
odds_and_evens(L) ->
  Odds = [X || X <- L, (X rem 2) =:= 1],
  Evens = [X || X <- L, (X rem 2) =:= 0],
  {Odds, Evens}.

odds_and_evens_acc(L) ->
  odds_and_evens_acc(L, [], []).


odds_and_evens_acc([H|T], Odds, Evens) ->
  case (H rem 2) of
    1 -> odds_and_evens_acc(T, [H|Odds], Evens);
    0 -> odds_and_evens_acc(T, Odds, [H|Evens])
  end;

odds_and_evens_acc([], Odds, Evens) ->
  {Odds, Evens}.