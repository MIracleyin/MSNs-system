%% Initializing Prophet Values
for temp_nodeIndex = 1:input_settings.NUMBER_OF_NODES
    
    for intermeet_index = 1:input_settings.NUMBER_OF_NODES
        
        mobilized_node_tmp.VS_NODE(temp_nodeIndex).PROPHET(intermeet_index) = 0;
        
    end
end


P_init = .75;
BETA = .25;


% average_intermeeting_time = input_settings.RANGE/(sum(input_settings.SPEED_RANGE)/2/4)+ input_settings.MOTION_PERIOD;
average_intermeeting_time = input_settings.RANGE/(sum(input_settings.SPEED_RANGE)/2)+ input_settings.MOTION_PERIOD;

% Wait Bar
wait_bar = waitbar(0, 'Percentage Completed');
set(wait_bar, 'name', 'Setting Prophet Metrics (Stage 1)...');
wb = 100/length(1:input_settings.NUMBER_OF_NODES);


%%
ALL_NODES_INDICES = 1:input_settings.NUMBER_OF_NODES;

for index1 = ALL_NODES_INDICES
    
    SOME_NODES_INDICES = ALL_NODES_INDICES;
    SOME_NODES_INDICES( SOME_NODES_INDICES ==  index1 ) =[];
    
    for index2 = SOME_NODES_INDICES
        
        intermeeting_times = [mobilized_node_tmp.VS_NODE(index1).FRIENDSHIP_RELATIONS(index2).MEETING_TIMES];
        
        if length(intermeeting_times) <= 1
            mobilized_node_tmp.VS_NODE(index1).PROPHET(index2) = 0;
            
        else
            
            for intermeet_times_index = intermeeting_times
                
                
                temp_probability_a_b = mobilized_node_tmp.VS_NODE(index1).PROPHET(index2);
                mobilized_node_tmp.VS_NODE(index1).PROPHET(index2) = temp_probability_a_b + (1- temp_probability_a_b)*P_init;
                
            end
        end
        
    end
    
    str_bar = [num2str(wb) '% Completed'];
    waitbar(wb/100, wait_bar, str_bar);
    wb = wb + 100/length(1:input_settings.NUMBER_OF_NODES);
end
close(wait_bar); % Wait Bar


% Wait Bar
wait_bar = waitbar(0, 'Percentage Completed');
set(wait_bar, 'name', 'Setting Prophet Metrics (Stage 2)...');
wb = 100/length(1:input_settings.NUMBER_OF_NODES);
for index1 = ALL_NODES_INDICES
    
    SOME_NODES_INDICES = ALL_NODES_INDICES;
    SOME_NODES_INDICES( SOME_NODES_INDICES ==  index1 ) =[];
    
    for index2 = SOME_NODES_INDICES
        
        index1_prophet_intermeet_nodes = [mobilized_node_tmp.VS_NODE(index1).INTER_MEET];
        
        temp_probability_a_b = mobilized_node_tmp.VS_NODE(index1).PROPHET(index2);
        
        prophet_intermeet_nodes = [mobilized_node_tmp.VS_NODE(index2).INTER_MEET];
        prophet_intermeet_nodes( prophet_intermeet_nodes == index1) = [];
        
        for delivery_probabilities = prophet_intermeet_nodes
            
            relay_intermeet_times = [mobilized_node_tmp.VS_NODE(index2).FRIENDSHIP_RELATIONS(delivery_probabilities).MEETING_TIMES];
            
            if (length(relay_intermeet_times)> 1) && isempty(find ( index1_prophet_intermeet_nodes == delivery_probabilities, 1 ) )
                
                temp_probability_a_c = mobilized_node_tmp.VS_NODE(index1).PROPHET(delivery_probabilities);
                temp_b_c = mobilized_node_tmp.VS_NODE(index2).PROPHET(delivery_probabilities);
                
                mobilized_node_tmp.VS_NODE(index1).PROPHET(delivery_probabilities) = ...
                    temp_probability_a_c + ( (1 - temp_probability_a_c)*temp_probability_a_b*temp_b_c*BETA );
                
%             else
%                 mobilized_node_tmp.VS_NODE(index1).PROPHET(delivery_probabilities) = 0;
            end
            
        end
    end
    
    str_bar = [num2str(wb) '% Completed'];
    waitbar(wb/100, wait_bar, str_bar);
    wb = wb + 100/length(1:input_settings.NUMBER_OF_NODES);
end

close(wait_bar); % Wait Bar


clear index1 index2 routing_time_index