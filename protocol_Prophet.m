%% PRoPHET Routing Protocol

%% Get messages and buffered messages destination address
messages_x = [];
messages_y = [];

buffer_x = [];
buffer_y = [];

refresh_buffers;
%% Get messages and buffered messages IDs

ID_messages_x = [];
ID_messages_y = [];

ID_buffer_x = [];
ID_buffer_y = [];


prophet_threshold = 0.985;

Refresh_ID;
refresh_buffers;
already_received_cleared;

%% Check if either nodes are the destination of any message and buffered messages for both nodes

% Any of messages in first node destined to second node?
if   sum (messages_x == index2 ) >= 1
    
    % Forward message to its destination
    mobilized_node_tmp.VS_NODE(index2).RECEIVED_MESSAGE( end+1: end+ sum(messages_x == index2 ) ) = mobilized_node_tmp.VS_NODE(index1).MESSAGE(  messages_x == index2   );
    
    for adding_time_index = 0:sum( messages_x == index2 )-1
        mobilized_node_tmp.VS_NODE(index2).RECEIVED_MESSAGE( end - adding_time_index ).RECEIPTION_TIME = time;
    end
    
    % Remove message from source queue
    mobilized_node_tmp.VS_NODE(index1).MESSAGE(  messages_x == index2   ) = [];
    
    % Increment message counter
    mobilized_node_tmp.RECEIVED_COUNT = mobilized_node_tmp.RECEIVED_COUNT + sum(messages_x == index2 );
    
    mobilized_node_tmp.RECEIVED_DIRECTLY = mobilized_node_tmp.RECEIVED_DIRECTLY + sum(messages_x == index2 );
    
    % Then refresh
    Refresh_ID;
    refresh_buffers;
    already_received_cleared;
    
end


% Any of buffered messages in first node destined to second node?
if sum(buffer_x == index2 ) >= 1
    
    % Forward message to its destination
    mobilized_node_tmp.VS_NODE(index2).RECEIVED_MESSAGE( end+1 : end+ sum( buffer_x == index2 ) ) = mobilized_node_tmp.VS_NODE(index1).BUFFER(  buffer_x == index2   );
    
    for adding_time_index = 0:sum( buffer_x == index2 )-1
        mobilized_node_tmp.VS_NODE(index2).RECEIVED_MESSAGE( end - adding_time_index ).RECEIPTION_TIME = time;
    end
    
    % Remove message from source queue
    mobilized_node_tmp.VS_NODE( index1 ).BUFFER(  buffer_x == index2   ) = [];
    
    % Increment message counter
    mobilized_node_tmp.RECEIVED_COUNT = mobilized_node_tmp.RECEIVED_COUNT + sum( buffer_x == index2 );
    
    mobilized_node_tmp.RECEIVED_FROM_BUFFERED = mobilized_node_tmp.RECEIVED_FROM_BUFFERED + sum( buffer_x == index2 );
    
    % Then refresh
    Refresh_ID;
    refresh_buffers;
    already_received_cleared;
    
end




% Any of messages in second node destined to first node?
if  sum(messages_y == index1 ) >= 1
    
    % Forward message to its destination
    mobilized_node_tmp.VS_NODE(index1).RECEIVED_MESSAGE ( end+1 : end+ sum( messages_y == index1 ) ) = mobilized_node_tmp.VS_NODE(index2).MESSAGE(  messages_y == index1  );
    
    % Add time index to each received message
    for adding_time_index = 0:sum( messages_y == index1 )-1
        mobilized_node_tmp.VS_NODE(index1).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end
    
    % Remove message from source queue
    mobilized_node_tmp.VS_NODE(index2).MESSAGE(  messages_y == index1   ) = [];
    
    % Increment message counter
    mobilized_node_tmp.RECEIVED_COUNT = mobilized_node_tmp.RECEIVED_COUNT + sum( messages_y == index1 );
    
    mobilized_node_tmp.RECEIVED_DIRECTLY = mobilized_node_tmp.RECEIVED_DIRECTLY + sum( messages_y == index1 );
    
    % Then refresh  
    Refresh_ID;
    refresh_buffers;
    already_received_cleared;
    
end



% Any of buffered messages in second node destined to first node?
if sum(buffer_y == index1 ) >= 1
    
    % Forward message to its destination
    mobilized_node_tmp.VS_NODE(index1).RECEIVED_MESSAGE(end+1: end+ sum( buffer_y == index1 )) = mobilized_node_tmp.VS_NODE(index2).BUFFER(  buffer_y == index1   );
    
    % Add time index to each received message
    for adding_time_index = 0:sum( buffer_y == index1 )-1
        mobilized_node_tmp.VS_NODE(index1).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end
    
    % Remove message from source queue
    mobilized_node_tmp.VS_NODE(index2).BUFFER(  buffer_y == index1   ) = [];
    
    % Increment message counter
    mobilized_node_tmp.RECEIVED_COUNT = mobilized_node_tmp.RECEIVED_COUNT + sum( buffer_y == index1 );
    
    mobilized_node_tmp.RECEIVED_FROM_BUFFERED = mobilized_node_tmp.RECEIVED_FROM_BUFFERED + sum( buffer_y == index1 );
    
    % Then refresh
    Refresh_ID;
    refresh_buffers;
    already_received_cleared;
    
end


%% Forward messages of node 1 to best relay

%% MsgX -> BufferY
if ( ~isempty( messages_x ) ) && (sum (messages_x == index2 ) == 0)
    
    delete_messages = [];
    
    % for forward_node = unique(messages_x)
    for forward_node = ID_messages_x
        
        if (~isempty (messages_x))
            
        to_node = mobilized_node_tmp.VS_NODE(index1).MESSAGE(ID_messages_x == forward_node).TO;
        
        node1_to_nodex = mobilized_node_tmp.VS_NODE(index1).PROPHET(to_node);
        node2_to_nodex = mobilized_node_tmp.VS_NODE(index2).PROPHET(to_node);
        
        else
            node2_to_nodex = 0;
        end
        
        if (sum (ID_buffer_y == forward_node) == 0) && ( node2_to_nodex > prophet_threshold )
            
            % Copy message of node one to the buffer of the next node
            mobilized_node_tmp.VS_NODE(index2).BUFFER( end+1 ) = mobilized_node_tmp.VS_NODE(index1).MESSAGE( forward_node == ID_messages_x  );
            
            % Add forwarded node index
            mobilized_node_tmp.VS_NODE(index2).BUFFER( end ).NUMBER_OF_FORWARDS(end + 1) = index1;
            temp_TTL = mobilized_node_tmp.VS_NODE(index2).BUFFER( end ).TTL;
            mobilized_node_tmp.VS_NODE(index2).BUFFER( end ).TTL = temp_TTL + 1;
            
            
            % Increment buffer counter
            mobilized_node_tmp.BUFFERED_COUNT = mobilized_node_tmp.BUFFERED_COUNT + 1;
            
            
            delete_messages(end +1) = find(forward_node == ID_messages_x);
                        
        end
        
    end % End for message_index_temp
        
    
    % Then refresh
    Refresh_ID;
    refresh_buffers;
    already_received_cleared;
    
end


%% MsgY -> BufferX
if ( ~isempty( messages_y ) ) && (sum (messages_y == index1 ) == 0)
    
    delete_messages = [];
    
    % for forward_node = unique(messages_y)
    for forward_node = ID_messages_y
        
        if (~isempty (messages_y))
            
        to_node = mobilized_node_tmp.VS_NODE(index2).MESSAGE(ID_messages_y == forward_node).TO;
        
        node1_to_nodex = mobilized_node_tmp.VS_NODE(index1).PROPHET(to_node);
        node2_to_nodex = mobilized_node_tmp.VS_NODE(index2).PROPHET(to_node);
        else
            
         node1_to_nodex = 0;   
        end 
        
        if (sum(ID_buffer_x == forward_node) == 0) && ( node1_to_nodex > prophet_threshold )
            
            % Copy message of node one to the buffer of the next node
            mobilized_node_tmp.VS_NODE(index1).BUFFER( end+1 ) = mobilized_node_tmp.VS_NODE(index2).MESSAGE( forward_node == ID_messages_y  );
            
            % Add forwarded node index
            mobilized_node_tmp.VS_NODE(index1).BUFFER( end ).NUMBER_OF_FORWARDS(end + 1) = index2;
            temp_TTL = mobilized_node_tmp.VS_NODE(index1).BUFFER( end ).TTL;
            mobilized_node_tmp.VS_NODE(index1).BUFFER( end ).TTL = temp_TTL + 1;           
            
            % Increment buffer counter
            mobilized_node_tmp.BUFFERED_COUNT = mobilized_node_tmp.BUFFERED_COUNT + 1;
            
            
            delete_messages(end +1) = find(forward_node == ID_messages_y);
                        
        end
        
    end % End for message_index_temp
            
    % Then refresh
    Refresh_ID;
    refresh_buffers;
    already_received_cleared;
    
end

%% BufferX -> BufferY
if ( ~isempty( buffer_x ) ) && (sum (buffer_x == index2 ) == 0)
    
    delete_messages = [];
    
    % for forward_node = unique(buffer_x)
    for forward_node = ID_buffer_x
        
        if (~isempty (buffer_x))
        
        to_node = mobilized_node_tmp.VS_NODE(index1).BUFFER(ID_buffer_x == forward_node).TO;
        
        node1_to_nodex = mobilized_node_tmp.VS_NODE(index1).PROPHET(to_node);
        node2_to_nodex = mobilized_node_tmp.VS_NODE(index2).PROPHET(to_node);
        
        else
            node2_to_nodex = 0;
        end 
        
        if ( sum(ID_buffer_y == forward_node) == 0 ) && ( node2_to_nodex > prophet_threshold )
            
            % Copy message of node one to the buffer of the next node
            mobilized_node_tmp.VS_NODE(index2).BUFFER( end+1 ) = mobilized_node_tmp.VS_NODE(index1).BUFFER( forward_node == ID_buffer_x  );
            
            % Add forwarded node index
            mobilized_node_tmp.VS_NODE(index2).BUFFER( end ).NUMBER_OF_FORWARDS(end + 1) = index1;
            temp_TTL = mobilized_node_tmp.VS_NODE(index2).BUFFER( end ).TTL;
            mobilized_node_tmp.VS_NODE(index2).BUFFER( end ).TTL = temp_TTL + 1;
            
            
            % Increment buffer counter
            mobilized_node_tmp.BUFFERED_COUNT = mobilized_node_tmp.BUFFERED_COUNT + 1;
            
            
            delete_messages(end +1) = find(forward_node == ID_buffer_x);
                        
        end
        
    end % End for message_index_temp
        
    
    % Then refresh
    Refresh_ID;
    refresh_buffers;
    already_received_cleared;
    
end

%% BufferY -> BufferX
if ( ~isempty( buffer_y ) ) && (sum (buffer_y == index1 ) == 0)
    
    delete_messages = [];
    
    % for forward_node = unique(buffer_y)
    for forward_node = ID_buffer_y
        
        if (~isempty (buffer_y))
            
        to_node = mobilized_node_tmp.VS_NODE(index2).BUFFER(ID_buffer_y == forward_node).TO;
        
        node1_to_nodex = mobilized_node_tmp.VS_NODE(index1).PROPHET(to_node);
        node2_to_nodex = mobilized_node_tmp.VS_NODE(index2).PROPHET(to_node);
        
        else
            node1_to_nodex = 0;
        end
        
        if ( sum (ID_buffer_x == forward_node) == 0 ) && ( node1_to_nodex > prophet_threshold )
            
            % Copy message of node one to the buffer of the next node
            mobilized_node_tmp.VS_NODE(index1).BUFFER( end+1 ) = mobilized_node_tmp.VS_NODE(index2).BUFFER( forward_node == ID_buffer_y  );
            
            % Add forwarded node index
            mobilized_node_tmp.VS_NODE(index1).BUFFER( end ).NUMBER_OF_FORWARDS(end + 1) = index2;
            temp_TTL = mobilized_node_tmp.VS_NODE(index1).BUFFER( end ).TTL;
            mobilized_node_tmp.VS_NODE(index1).BUFFER( end ).TTL = temp_TTL + 1;
            
            
            % Increment buffer counter
            mobilized_node_tmp.BUFFERED_COUNT = mobilized_node_tmp.BUFFERED_COUNT + 1;
            
            
            delete_messages(end +1) = find(forward_node == ID_buffer_y);
                        
        end
        
    end % End for message_index_temp
            
    % Then refresh
    Refresh_ID;
    refresh_buffers;
    already_received_cleared;
    
end