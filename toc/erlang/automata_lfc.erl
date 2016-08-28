-module(automata_lfc).
-export([state_after_w/2, new_lfc/4, next_status/3]).

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

r_state_after_w(L=#lfc{}, [Wh|_], Qn)  -> io:format("Wh=%s", Wh),
                                          next_status(Qn, Wh, L#lfc.d);
r_state_after_w(L=#lfc{}, [Wh|Wt], Qn) -> r_state_after_w(L, Wt, next_status(Qn, Wh, L#lfc.d)).

next_status(Q0, E, D) -> [Qf || {En, Qi, Qf} <- D, En == E, Qi == Q0].

accept_w(#lfc{}, W) -> accept.

%%Inclui transition_not_found nas lacunas de QxE para D
define_d(Q, E, D) -> D.
