% Initially, don't forward message!
forward_message = 0;
intermeet_node = intermeet_node;

% Get rank of node nodeIndex
nodeIndex_rank = mobilized_node_tmp.VS_NODE(nodeIndex).RANK;

% Rank of intermeeting node
intermeet_node_rank = mobilized_node_tmp.VS_NODE(intermeet_node).RANK;

%% Get average friendship relation of both nodes with higher rank nodes

% Nodes that nodeIndex usually meet
periodic_intermeeting_nodes = [mobilized_node_tmp.VS_NODE(nodeIndex).INTER_MEET];

% Ranks of nodes that nodeIndex usually meet
ranks_intermeet = [ mobilized_node_tmp.VS_NODE(periodic_intermeeting_nodes).RANK ];

% Check relation between nodeIndex and higher rank nodes
if nodeIndex_rank ~= 3
    
    % Get friendships with
    temp_rank2 = [ mobilized_node_tmp.VS_NODE(nodeIndex).FRIENDSHIP_RELATIONS( periodic_intermeeting_nodes (ranks_intermeet == 2)  ).FRIENDSHIP ];
    temp_rank3 = [ mobilized_node_tmp.VS_NODE(nodeIndex).FRIENDSHIP_RELATIONS( periodic_intermeeting_nodes (ranks_intermeet == 3)  ).FRIENDSHIP ];
    
    % Get a weighted freindship average of nodeIndex with higher rankings
    nodeIndex_average_ranks = ( sum(temp_rank2) + 2*sum(temp_rank3) )/(length(temp_rank2) + 2*length(temp_rank3));
    
else
    
    nodeIndex_average_ranks = 0;
    
end

intermeet_average_ranks = [];

% Get the relationship between the intermeeting node and the high rank
% nodes
temp_intermeet_intermeet = mobilized_node_tmp.VS_NODE( intermeet_node ).INTER_MEET;
ranks_of_intermeet_nodes = [ mobilized_node_tmp.VS_NODE( temp_intermeet_intermeet).RANK ];
temp_rank2 = [ mobilized_node_tmp.VS_NODE(intermeet_node).FRIENDSHIP_RELATIONS( temp_intermeet_intermeet (ranks_of_intermeet_nodes == 2)  ).FRIENDSHIP ];
temp_rank3 = [ mobilized_node_tmp.VS_NODE(intermeet_node).FRIENDSHIP_RELATIONS( temp_intermeet_intermeet (ranks_of_intermeet_nodes == 3)  ).FRIENDSHIP ];
intermeet_average_ranks = ( sum(temp_rank2) + 2*sum(temp_rank3) )/(length(temp_rank2) + 2*length(temp_rank3));

%% Get Ranks of both nodes

friendships_intermeet = [];

% Get freindship of the intermeeting node with the message destination
% node
friendships_intermeet = mobilized_node_tmp.VS_NODE(intermeet_node).FRIENDSHIP_RELATIONS(forward_node).FRIENDSHIP;

% Get freindship of node nodeIndex with the message destination node
friendship_temp = mobilized_node_tmp.VS_NODE(nodeIndex).FRIENDSHIP_RELATIONS(forward_node).FRIENDSHIP;



rank_scale =  intermeet_node_rank > nodeIndex_rank;


rank_relation_scale =  intermeet_average_ranks > nodeIndex_average_ranks;
[V max_raltionship_with_max_rank ]= max (intermeet_average_ranks);

mobilized_node_tmp.VS_NODE(nodeIndex).FORWARD_NODE(forward_node).NODES = -1;

% Set Max relay node!
temp_relays = mobilized_node_tmp.VS_NODE(nodeIndex).FORWARD_NODE(forward_node).NODES;

if friendships_intermeet > friendship_temp
    
    forward_message = 1;
    
elseif ( friendship_temp <= 0 ) && ( intermeet_average_ranks > nodeIndex_average_ranks ) && ( nodeIndex_rank ~= 3 )
    
    forward_message = 1;
    
elseif ( friendship_temp <= 0 ) && ( intermeet_node_rank > nodeIndex_rank ) && ( nodeIndex_rank ~= 3 )
    
    forward_message = 1;
    
end





