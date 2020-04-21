%% Epidemic Routing Protocol


%% Get messages and buffered messages destination address
messages_x = [];
messages_y = [];

buffer_x = [];
buffer_y = [];

in_refresh_buffers;


%% Get messages and buffered messages IDs
ID_messages_x = [];
ID_messages_y = [];

ID_buffer_x = [];
ID_buffer_y = [];

%% Refresh Buffers and IDs and clear already received messages!
in_Refresh_ID;
in_refresh_buffers;
in_already_received_cleared;

%% Check if either nodes are the destination of any message and buffered messages for both nodes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 源节点与目标节点直接相遇的状况 首先完成直接传递
%%1. 节点2是节点1的传信目标 不存入buffer
if   sum (messages_x == MN_INDEX_2 ) >= 1
    
    % Forward message to its destination
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE( end+1: end+ sum(messages_x == MN_INDEX_2 ) ) = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(  messages_x == MN_INDEX_2   );
    
    for adding_time_index = 0:sum( messages_x == MN_INDEX_2 )-1
        MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE( end - adding_time_index ).RECEIPTION_TIME = time;
    end
    
    % Remove message from source queue
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(  messages_x == MN_INDEX_2   ) = [];
    
    % Increment message counter
    MN_DATA_ROUTING_temp.RECEIVED_COUNT = MN_DATA_ROUTING_temp.RECEIVED_COUNT + sum(messages_x == MN_INDEX_2 );
    
    MN_DATA_ROUTING_temp.RECEIVED_DIRECTLY = MN_DATA_ROUTING_temp.RECEIVED_DIRECTLY + sum(messages_x == MN_INDEX_2 );
    
    % Then refresh
    in_Refresh_ID;
    in_refresh_buffers;
    in_already_received_cleared;
    
end


%%2.节点2是节点1缓存中传信目标
if sum(buffer_x == MN_INDEX_2 ) >= 1
    
    % Forward message to its destination
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE( end+1 : end+ sum( buffer_x == MN_INDEX_2 ) ) = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(  buffer_x == MN_INDEX_2   );
    
    for adding_time_index = 0:sum( buffer_x == MN_INDEX_2 )-1
        MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE( end - adding_time_index ).RECEIPTION_TIME = time;
    end
    
    % Remove message from source queue
    MN_DATA_ROUTING_temp.VS_NODE( MN_INDEX_1 ).BUFFER(  buffer_x == MN_INDEX_2   ) = [];
    
    % Increment message counter
    MN_DATA_ROUTING_temp.RECEIVED_COUNT = MN_DATA_ROUTING_temp.RECEIVED_COUNT + sum( buffer_x == MN_INDEX_2 );
    
    MN_DATA_ROUTING_temp.RECEIVED_FROM_BUFFERED = MN_DATA_ROUTING_temp.RECEIVED_FROM_BUFFERED + sum( buffer_x == MN_INDEX_2 );
    
    % Then refresh
    in_Refresh_ID;
    in_refresh_buffers;
    in_already_received_cleared;
    
end



%%3.节点1是节点2的传信目标 不存入buffer
if  sum(messages_y == MN_INDEX_1 ) >= 1
    
    % Forward message to its destination
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE ( end+1 : end+ sum( messages_y == MN_INDEX_1 ) ) = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(  messages_y == MN_INDEX_1  );
    
    % Add time index to each received message
    for adding_time_index = 0:sum( messages_y == MN_INDEX_1 )-1
        MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end
    
    % Remove message from source queue
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(  messages_y == MN_INDEX_1   ) = [];
    
    % Increment message counter
    MN_DATA_ROUTING_temp.RECEIVED_COUNT = MN_DATA_ROUTING_temp.RECEIVED_COUNT + sum( messages_y == MN_INDEX_1 );
    
    MN_DATA_ROUTING_temp.RECEIVED_DIRECTLY = MN_DATA_ROUTING_temp.RECEIVED_DIRECTLY + sum( messages_y == MN_INDEX_1 );
    
    % Then refresh  
    in_Refresh_ID;
    in_refresh_buffers;
    in_already_received_cleared;
    
end


%%4. 节点1是节点2缓存中的传信目标
if sum(buffer_y == MN_INDEX_1 ) >= 1
    
    % Forward message to its destination
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end+1: end+ sum( buffer_y == MN_INDEX_1 )) = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(  buffer_y == MN_INDEX_1   );
    
    % Add time index to each received message
    for adding_time_index = 0:sum( buffer_y == MN_INDEX_1 )-1
        MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end
    
    % Remove message from source queue
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(  buffer_y == MN_INDEX_1   ) = [];
    
    % Increment message counter
    MN_DATA_ROUTING_temp.RECEIVED_COUNT = MN_DATA_ROUTING_temp.RECEIVED_COUNT + sum( buffer_y == MN_INDEX_1 );
    
    MN_DATA_ROUTING_temp.RECEIVED_FROM_BUFFERED = MN_DATA_ROUTING_temp.RECEIVED_FROM_BUFFERED + sum( buffer_y == MN_INDEX_1 );
    
    % Then refresh
    in_Refresh_ID;
    in_refresh_buffers;
    in_already_received_cleared;
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%依靠中间节点传递信息
%%节点1信息传至节点2缓存
%节点1信息非空且节点1信息并节点2并非节点1目标
%%1.MSG_X -> Buffer_Y
if ( ~isempty( messages_x ) ) && (sum (messages_x == MN_INDEX_2 ) == 0)
    
    delete_messages = [];
    
    % for forward_node = unique(messages_x)
    for forward_node = ID_messages_x
        
        if sum (ID_buffer_y == forward_node) == 0
            
            % Copy message of node one to the buffer of the next node
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end+1 ) = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE( forward_node == ID_messages_x  );
            
            % Add forwarded node index
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end ).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_1;
            temp_TTL = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end ).TTL;
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end ).TTL = temp_TTL + 1;
            
            
            % Increment buffer counter
            MN_DATA_ROUTING_temp.BUFFERED_COUNT = MN_DATA_ROUTING_temp.BUFFERED_COUNT + 1;
            
                                    
        end
        
    end % End for message_index_temp
        
    
    % Then refresh
    in_Refresh_ID;
    in_refresh_buffers;
    in_already_received_cleared;
    
end


%% MsgY -> BufferX
if ( ~isempty( messages_y ) ) && (sum (messages_y == MN_INDEX_1 ) == 0)
    
    delete_messages = [];
    
    % for forward_node = unique(messages_y)
    for forward_node = ID_messages_y
        
        if sum(ID_buffer_x == forward_node) == 0
            
            % Copy message of node one to the buffer of the next node
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end+1 ) = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE( forward_node == ID_messages_y  );
            
            % Add forwarded node index
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end ).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_2;
            temp_TTL = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end ).TTL;
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end ).TTL = temp_TTL + 1;           
            
            % Increment buffer counter
            MN_DATA_ROUTING_temp.BUFFERED_COUNT = MN_DATA_ROUTING_temp.BUFFERED_COUNT + 1;
            
                                    
        end
        
    end % End for message_index_temp
            
    % Then refresh
    in_Refresh_ID;
    in_refresh_buffers;
    in_already_received_cleared;
    
end

%% BufferX -> BufferY
if ( ~isempty( buffer_x ) ) && (sum (buffer_x == MN_INDEX_2 ) == 0)
    
    delete_messages = [];
    
    % for forward_node = unique(buffer_x)
    for forward_node = ID_buffer_x
        
        if sum(ID_buffer_y == forward_node) == 0
            
            % Copy message of node one to the buffer of the next node
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end+1 ) = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( forward_node == ID_buffer_x  );
            
            % Add forwarded node index
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end ).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_1;
            temp_TTL = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end ).TTL;
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end ).TTL = temp_TTL + 1;
            
            
            % Increment buffer counter
            MN_DATA_ROUTING_temp.BUFFERED_COUNT = MN_DATA_ROUTING_temp.BUFFERED_COUNT + 1;
            
                                    
        end
        
    end % End for message_index_temp
            
    % Then refresh
    in_Refresh_ID;
    in_refresh_buffers;
    in_already_received_cleared;
    
end

%% BufferY -> BufferX
if ( ~isempty( buffer_y ) ) && (sum (buffer_y == MN_INDEX_1 ) == 0)
    
    delete_messages = [];
    
    % for forward_node = unique(buffer_y)
    for forward_node = ID_buffer_y
        
        if sum (ID_buffer_x == forward_node) == 0
            
            % Copy message of node one to the buffer of the next node
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end+1 ) = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( forward_node == ID_buffer_y  );
            
            % Add forwarded node index
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end ).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_2;
            temp_TTL = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end ).TTL;
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end ).TTL = temp_TTL + 1;
            
            
            % Increment buffer counter
            MN_DATA_ROUTING_temp.BUFFERED_COUNT = MN_DATA_ROUTING_temp.BUFFERED_COUNT + 1;
            
                        
        end
        
    end % End for message_index_temp
        
    
    % Then refresh
    in_Refresh_ID;
    in_refresh_buffers;
    in_already_received_cleared;
    
end