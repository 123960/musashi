c(automata_lfc).
rr(automata_lfc).

%%select * from lfc_cfg_entity where att2 = 'ZAPUNLIMITED' --ID=5012
%%--Q
%%SELECT DISTINCT actual_status status FROM NGIN_STS2_CFG_FLOW WHERE CFG_ID = 5012
%%union
%%SELECT DISTINCT next_status status FROM NGIN_STS2_CFG_FLOW WHERE CFG_ID = 5012;
%%--E
%%SELECT DISTINCT EVENT_ID FROM NGIN_STS2_CFG_FLOW WHERE CFG_ID = 5012;
%%--D
%%SELECT distinct event_id, actual_status, next_status FROM NGIN_STS2_CFG_FLOW WHERE CFG_ID = 5012;
ZAPUNLIMITED_lfc = automata_lfc:new_lfc([0,1], [5000, 5001], [{5000, 1, 0},
                                                              {5000, 0, 0},
                                                              %%{5001, 0, 0}, Não implementado as applicabilities ainda
                                                              {5001, 1, 0},
                                                              {5001, 0, 1}], 0).

automata_lfc:state_after_w(ZAPUNLIMITED_lfc, [5000, 5000, 5001, 5000]).

automata_lfc:next_status(0, 5000, [{5000, 1, 0},
                                   {5000, 0, 0},
                                   %%{5001, 0, 0}, Não implementado as applicabilities ainda
                                   {5001, 1, 0},
                                   {5001, 0, 1}]).

erlang:display(lists:flatten("Qn=" ++ io_lib:format("~p", [Qn]) ++ ",Wh=" ++ io_lib:format("~p", [Wh]))),
