% Initially, don't forward message!
%初始化，信息默认不传递
forward_message = 0;
%记录两个移动节点 nodeIndex是为发信者序号 intermeet_node是为潜在收信者序号
nodeIndex = nodeIndex;

intermeet_node = intermeet_node;

%获取发信者对 forward_node 的直接概率
nodeIndex_direct = routing_table.VS_NODE(nodeIndex).SOCIAL_CONTACT(forward_node).DIRECT_PROBABILITY;
%获取发信者对 forward_node 的间接概率
nodeIndex_trans = [routing_table.VS_NODE(nodeIndex).SOCIAL_CONTACT(forward_node).TRANS_PROBABILITY_HOP1, ...
                   routing_table.VS_NODE(nodeIndex).SOCIAL_CONTACT(forward_node).TRANS_PROBABILITY_HOP2, ...
                   routing_table.VS_NODE(nodeIndex).SOCIAL_CONTACT(forward_node).TRANS_PROBABILITY_HOP3, ...
                   routing_table.VS_NODE(nodeIndex).SOCIAL_CONTACT(forward_node).TRANS_PROBABILITY_HOP4];
%获取潜在受信者对 forward_node 的直接概率
intermeet_node_direct = routing_table.VS_NODE(intermeet_node).SOCIAL_CONTACT(forward_node).DIRECT_PROBABILITY;
%获取潜在受信者对 forward_node 的间接概率
intermeet_node_trans = [routing_table.VS_NODE(intermeet_node).SOCIAL_CONTACT(forward_node).TRANS_PROBABILITY_HOP1, ...
                        routing_table.VS_NODE(intermeet_node).SOCIAL_CONTACT(forward_node).TRANS_PROBABILITY_HOP2, ...
                        routing_table.VS_NODE(intermeet_node).SOCIAL_CONTACT(forward_node).TRANS_PROBABILITY_HOP3,
                        routing_table.VS_NODE(intermeet_node).SOCIAL_CONTACT(forward_node).TRANS_PROBABILITY_HOP4];

%如果潜在受信者对 forward_node 的直接概率大于等于 发信者对 forward_node 的直接概率
%如果潜在受些者对 forward_node 的间接概率(1 2 3)大于等于 发信者对 forward_node 的间接概率
if (intermeet_node_direct >= nodeIndex_direct) && (intermeet_node_trans(1) >= nodeIndex_trans(1)) && (intermeet_node_trans(2) >= nodeIndex_trans(2)) && (intermeet_node_trans(3) >= nodeIndex_trans(3)) && (intermeet_node_trans(4) >= nodeIndex_trans(4))

    forward_message = 1;

end





