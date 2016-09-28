% Enter your code here. Read input from STDIN. Print output to STDOUT
% Your class should be named solution

-module(solution).
-export([list_rep_main/0, list_rep/2, f_array_main/0, f_array/2]).
hello_main() -> {ok, [X]} = io:fread("", "~d"),
                 hello(X).

hello(1)   -> io:fwrite("Hello World\n");
hello(N)   -> io:fwrite("Hello World\n"),
              hello(N-1).


list_rep_main()  -> list_rep_read([]).
list_rep_read(L) ->
  case io:fread("", "~d") of
    eof ->
      lists:foreach(fun(X) -> io:fwrite("~w\n", [X]) end,
                    list_rep(hd(lists:reverse(L)), tl(lists:reverse(L))));
    {ok, [N]} -> list_rep_read([N|L])
  end.
list_rep(_, []) -> [];
list_rep(N, Z)  ->
  R = lists:seq(1, N),
  L = fun(X) -> lists:map(fun(_) -> X end, R) end,
  lists:flatmap(L, Z).

f_array_main() -> f_array([]).
f_array(L)     ->
  case io:fread("", "~d") of
    eof ->
     lists:foreach(fun(X) -> io:fwrite("~w\n", [X]) end,
                   f_array(fun(X) -> hd(lists:reverse(L)) < X end, tl(lists:reverse(L))));
    {ok, [N]} -> f_array([N|L])
  end.
f_array(P, [H|T]) ->
  case P(H) of
     true  -> [H|f_array(P, T)];
     false -> f_array(P, T)
  end;
f_array(_, [])    -> [].
