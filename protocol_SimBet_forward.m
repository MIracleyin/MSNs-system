function forward = protocol_SimBet_forward(node1, node2, forward_node, alfa, beta)


sim_x = node1.SIM_BET.SIM_VALUE(forward_node);
sim_y = node2.SIM_BET.SIM_VALUE(forward_node);

simUtil_x = sim_x/(sim_x + sim_y);
simUtil_y = sim_y/(sim_x + sim_y);


bet_x = node1.SIM_BET.BET_VALUE;
bet_y = node2.SIM_BET.BET_VALUE;

BetUtil_x = bet_x/(bet_x + bet_y);
BetUtil_y = bet_y/(bet_x + bet_y);

SimBetUtil_x = alfa*simUtil_x + beta*BetUtil_x;
SimBetUtil_y = alfa*simUtil_y + beta*BetUtil_y;

if( SimBetUtil_x < SimBetUtil_y)
    forward =1;
else
    forward=0;
end


end