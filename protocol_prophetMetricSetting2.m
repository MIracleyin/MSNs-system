%% Initializing Prophet Values
for temp_nodeIndex = 1:input_settings.MN_N
    
    for intermeet_index = 1:input_settings.MN_N
        
        MN_DATA_SOCIA_temp.VS_NODE(temp_nodeIndex).PROPHET(intermeet_index) = 0;
        
    end
end


P_init = .75;
BETA = .25;


% Wait Bar
wait_bar = waitbar(0, 'Percentage Completed');
set(wait_bar, 'name', 'Setting Prophet Metrics (Stage 1)...');
wb = 100/length(1:input_settings.MN_N);


%%
ALL_NODES_INDICES = 1:input_settings.MN_N;

for MN_INDEX_1 = ALL_NODES_INDICES
    
    SOME_NODES_INDICES = ALL_NODES_INDICES;
    SOME_NODES_INDICES( SOME_NODES_INDICES ==  MN_INDEX_1 ) =[];
    
    for MN_INDEX_2 = SOME_NODES_INDICES
        
        intermeeting_times = [MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME];
        
        if length(intermeeting_times) <= 1
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).PROPHET(MN_INDEX_2) = 0;
            
        else
            
            for intermeet_times_index = intermeeting_times
                
                temp_probability_a_b = MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).PROPHET(MN_INDEX_2);
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).PROPHET(MN_INDEX_2) = temp_probability_a_b + (1- temp_probability_a_b)*P_init;
                
            end
        end
        
    end
    
    str_bar = [num2str(wb) '% Completed'];
    waitbar(wb/100, wait_bar, str_bar);
    wb = wb + 100/length(1:input_settings.MN_N);
end
close(wait_bar); % Wait Bar


% Wait Bar
wait_bar = waitbar(0, 'Percentage Completed');
set(wait_bar, 'name', 'Setting Prophet Metrics (Stage 2)...');
wb = 100/length(1:input_settings.MN_N);
for MN_INDEX_1 = ALL_NODES_INDICES
    
    SOME_NODES_INDICES = ALL_NODES_INDICES;
    SOME_NODES_INDICES( SOME_NODES_INDICES ==  MN_INDEX_1 ) =[];
    
    for MN_INDEX_2 = SOME_NODES_INDICES
        
        MN_INDEX_1_prophet_intermeet_nodes = [MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ID];
        
        temp_probability_a_b = MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).PROPHET(MN_INDEX_2);
        
        prophet_intermeet_nodes = [MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).MEET_ID];
        prophet_intermeet_nodes( prophet_intermeet_nodes == MN_INDEX_1) = [];
        
        for delivery_probabilities = prophet_intermeet_nodes
            
            relay_intermeet_times = [MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTACT(delivery_probabilities).MEETING_TIME];
            
            if (length(relay_intermeet_times)> 1) && isempty(find ( MN_INDEX_1_prophet_intermeet_nodes == delivery_probabilities, 1 ) )
                
                temp_probability_a_c = MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).PROPHET(delivery_probabilities);
                temp_b_c = MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).PROPHET(delivery_probabilities);
                
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).PROPHET(delivery_probabilities) = ...
                    temp_probability_a_c + ( (1 - temp_probability_a_c)*temp_probability_a_b*temp_b_c*BETA );
                
%             else
%                 MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).PROPHET(delivery_probabilities) = 0;
            end
            
        end
    end
    
    str_bar = [num2str(wb) '% Completed'];
    waitbar(wb/100, wait_bar, str_bar);
    wb = wb + 100/length(1:input_settings.MN_N);
end

close(wait_bar); % Wait Bar


clear MN_INDEX_1 MN_INDEX_2 routing_time_index