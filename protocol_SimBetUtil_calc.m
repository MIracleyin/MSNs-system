% Wait Bar
wait_bar = waitbar(0, 'Percentage Completed');
set(wait_bar, 'name', 'SimBet Metrics...');
wb = 1/length(1:input_settings.MN_N);

% Main loop to get the Adjacency Matrix
for simIndex = 1:input_settings.MN_N
    
    
    node_intermeet_temp = [MN_DATA_SOCIA_temp.VS_NODE(simIndex).MEET_ID];
    
    % Getting Intersection(intermeet of x, intermeet of y)
    for intermeet_index = 1:input_settings.MN_N
        
        if intermeet_index ~= simIndex
            
            other_intermeet_temp =  [MN_DATA_SOCIA_temp.VS_NODE(simIndex).MEET_ID];
            nodes_intersections = sum( ismember(node_intermeet_temp,other_intermeet_temp ) );
            
        else
            nodes_intersections = 0;
        end
        
        MN_DATA_SOCIA_temp.VS_NODE(simIndex).SIM_BET.SIM_VALUE(intermeet_index) = nodes_intersections;
        
    end
    
    
    
    node_intermeet_temp = [MN_DATA_SOCIA_temp.VS_NODE(simIndex).MEET_ID];
    simMatrix  = zeros( length(node_intermeet_temp) + 1 );
    
    simMatrix(1,:) = [0  ones(1, length(node_intermeet_temp) ) ];
    simMatrix(:,1) = [0 ;ones(1, length(node_intermeet_temp) )' ];
    
    for row_simIndex = 2:length(node_intermeet_temp) + 1
        for Column_simIndex = 2:length(node_intermeet_temp) + 1
            
            simMatrix(row_simIndex, Column_simIndex) = sum( ismember(MN_DATA_SOCIA_temp.VS_NODE(node_intermeet_temp(row_simIndex - 1)).MEET_ID,...
                node_intermeet_temp(Column_simIndex - 1)) );
            %                 sum(mobilized_node_tmp.VS_NODE(row_simIndex).INTER_MEET == Column_simIndex) > 0;
        end
    end
    
    BET_VALUE = (simMatrix^2)*(1 - simMatrix);
    
    % Adjacency matrix
    MN_DATA_SOCIA_temp.VS_NODE(simIndex).SIM_BET.ADJACENCY_MATRIX = simMatrix;
    MN_DATA_SOCIA_temp.VS_NODE(simIndex).SIM_BET.BET_VALUE = sum( sum(BET_VALUE) );

    str_bar = [num2str(wb) '% Completed'];
    waitbar(wb/100, wait_bar, str_bar);
    wb = wb + 100/length(1:input_settings.MN_N);
end


close(wait_bar); % End wait bar