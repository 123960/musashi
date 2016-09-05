-module(automata_lfc).
-export([state_after_w/2, new_lfc/4, next_status/3, full_d/2, accept_w/2, process_exp/2]).

-record(lfc, {q, %%estados
              e, %%eventos
              d, %%transicoes
              q0, %%estado inicial
              qf}). %%estados aceitaveis

new_lfc(Q, E, D, Q0) -> #lfc{q=Q ++ [transition_not_found],
                             e=E,
                             d=define_d(Q, E, D),
                             q0=Q0,
                             qf=Q}.

state_after_w(L=#lfc{}, W) -> r_state_after_w(L, W, L#lfc.q0).

r_state_after_w(L=#lfc{}, [Wh|Wt], Qn) -> r_state_after_w(L, Wt, next_status(Qn, Wh, L#lfc.d));
r_state_after_w(#lfc{}, _, Qn)         -> Qn.

next_status(Q0, E, D) -> hd([Qf || {En, Qi, Qf} <- D, En == E, Qi == Q0]).

accept_w(L=#lfc{}, W) -> case state_after_w(L, W) of
                           transition_not_found -> false;
                           Qf                   -> sets:is_element(Qf, sets:from_list(L#lfc.qf))
                         end.

%%Inclui transition_not_found nas lacunas de QxE -> D
define_d(Q, E, D) -> L  = sets:from_list([{Qi, Ei} || {Qi, Ei, _} <- D]),
                     FD = sets:from_list(full_d(Q, E)),
                     T  = [{X, Y, transition_not_found} || {X, Y} <- sets:to_list(sets:subtract(FD, L))],
                     T2 = [{X, transition_not_found, transition_not_found} || X <- E],
                     D ++ T ++ T2.

%%Cria todas as transicoes de QxE
full_d(Q, E) -> lists:flatmap(fun(X) -> lists:map(fun(Y) -> {X, Y} end, Q) end, E).

process_exp(EXP, V) -> re:split(EXP, " OR ").
