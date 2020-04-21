% SimBet (in buffer or to be sent)
% index1 = index1; 
% index2 = index2;
%% Get messages and buffered messages destination address
messages_x = []; %messages_x = [MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(:).TO]
messages_y = []; %messages_y = [MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(:).TO]

buffer_x = []; %[MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(:).TO]
buffer_y = []; %[MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(:).TO]

alfa =0.5;
beta =0.5;

in_refresh_buffers;

%% Check if either nodes are the destination of any message and buffered messages for both nodes

%%1. 节点2是节点1的传信目标 不存入buffer
if   sum (messages_x == MN_INDEX_2) >= 1
    
    % 节点1的信息保存至节点2信息的「接收信息」中
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE( end + 1: end + sum(messages_x == MN_INDEX_2) ) = ...
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(messages_x == MN_INDEX_2); %
    %
    for adding_time_index = 0 : sum(messages_x == MN_INDEX_2) - 1
        %记录信息接收的时间
        MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end
    %移除原节点信息
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(messages_x == MN_INDEX_2) = [];
    %接收信息量 + 1
    MN_DATA_ROUTING_temp.RECEIVED_COUNT = MN_DATA_ROUTING_temp.RECEIVED_COUNT + sum(messages_x == MN_INDEX_2);
    %直接传递量 + 1
    MN_DATA_ROUTING_temp.RECEIVED_DIRECTLY = MN_DATA_ROUTING_temp.RECEIVED_DIRECTLY + sum(messages_x == MN_INDEX_2);

    in_refresh_buffers;
end

%%2.节点2是节点1缓存中传信目标
if sum(buffer_x == MN_INDEX_2 ) >= 1
    
   % 节点1缓存向节点2发送信息
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE(end + 1:end + sum( buffer_x == MN_INDEX_2)) = ...
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(buffer_x == MN_INDEX_2);

    for adding_time_index = 0 : sum(buffer_x == MN_INDEX_2) - 1
       MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end

    %移除节点1缓存中的信息
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(buffer_x == MN_INDEX_2) = [];
    %接收信息量 + 1
    MN_DATA_ROUTING_temp.RECEIVED_COUNT = MN_DATA_ROUTING_temp.RECEIVED_COUNT + sum(buffer_x == MN_INDEX_2);
    %间接传递量 + 1
    MN_DATA_ROUTING_temp.RECEIVED_FROM_BUFFERED = MN_DATA_ROUTING_temp.RECEIVED_FROM_BUFFERED + sum(buffer_x == MN_INDEX_2);

    in_refresh_buffers;
end

%%3.节点1是节点2的传信目标 不存入buffer
if sum(messages_y == MN_INDEX_1) >= 1
    % 节点2向节点1发送信息
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end + 1:end + sum(messages_y == MN_INDEX_1)) = ...
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(messages_y == MN_INDEX_1);

    for adding_time_index = 0 : sum(messages_y == MN_INDEX_1) - 1
        MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end

    %移除节点2信息
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE( messages_y == MN_INDEX_1) = [];
    %接收信息量 + 1
    MN_DATA_ROUTING_temp.RECEIVED_COUNT = MN_DATA_ROUTING_temp.RECEIVED_COUNT + sum(messages_y == MN_INDEX_1);
    %直接传递量 + 1
    MN_DATA_ROUTING_temp.RECEIVED_DIRECTLY = MN_DATA_ROUTING_temp.RECEIVED_DIRECTLY + sum(messages_y == MN_INDEX_1);

    in_refresh_buffers;
end

%%4. 节点1是节点2缓存中的传信目标
if sum(buffer_y == MN_INDEX_1) >= 1
    %节点2缓存向节点1发送消息
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end + 1:end + sum(buffer_y == MN_INDEX_1)) = ...
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(buffer_y == MN_INDEX_1);

    for adding_time_index = 0:sum(buffer_y == MN_INDEX_1) - 1
        MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end

    %移除节点2缓存信息
    MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( buffer_y == MN_INDEX_1) = [];
    %接收信息量 + 1
    MN_DATA_ROUTING_temp.RECEIVED_COUNT = MN_DATA_ROUTING_temp.RECEIVED_COUNT + sum(buffer_y == MN_INDEX_1);
    %间接传递量 + 1
    MN_DATA_ROUTING_temp.RECEIVED_FROM_BUFFERED = MN_DATA_ROUTING_temp.RECEIVED_FROM_BUFFERED + sum(buffer_y == MN_INDEX_1);

    in_refresh_buffers;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%依靠中间节点传递信息
%%节点1信息传至节点2缓存
%节点1信息非空且节点1信息并节点2并非节点1目标
%%1.MSG_X -> Buffer_Y
if ( ~isempty( messages_x ) ) && (sum (messages_x == MN_INDEX_2 ) == 0)
   
    for forward_node = unique(messages_x)
                
        node1 = routing_table.VS_NODE(MN_INDEX_1);
        node2 = routing_table.VS_NODE(MN_INDEX_2);
        forward_message = protocol_SimBet_forward(node1, node2, forward_node, alfa, beta);
        
        if forward_message == 1
            %节点2缓存储存节点1的信息
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end + 1 : end + sum(messages_x == forward_node)) = ...
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(messages_x == forward_node);
            %统计更新
            for adding_forwardNode_index = 0 : sum(messages_x == forward_node) - 1
                MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end - adding_forwardNode_index).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_1;
                temp_TTL = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end - adding_forwardNode_index).TTL;
                MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end - adding_forwardNode_index).TTL = temp_TTL + 1;
            end
            
            MN_DATA_ROUTING_temp.BUFFERED_COUNT = MN_DATA_ROUTING_temp.BUFFERED_COUNT + sum(messages_x == forward_node);
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(messages_x == forward_node) = [];

            in_refresh_buffers;
        end
        
    end % End for message_index_temp
    
end


%%2.MsgY -> BufferX
if ( ~isempty( messages_y ) ) && (sum (messages_y == MN_INDEX_1  ) == 0)
    
    
    for forward_node = unique(messages_y)
        
        node1 = routing_table.VS_NODE(MN_INDEX_2);
        node2 = routing_table.VS_NODE(MN_INDEX_1);
        forward_message = protocol_SimBet_forward(node1, node2, forward_node, alfa, beta);
        
        if forward_message == 1
            %节点1缓存储存节点2的信息
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(end + 1 : end + sum(messages_y == forward_node)) = ...
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(messages_y == forward_node);
            %统计更新
            for adding_forwardNode_index = 0 : sum( messages_y == forward_node ) - 1
                MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(end - adding_forwardNode_index ).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_2;
                temp_TTL = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(end - adding_forwardNode_index ).TTL;
                MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(end - adding_forwardNode_index ).TTL = temp_TTL + 1;
            end

            MN_DATA_ROUTING_temp.BUFFERED_COUNT = MN_DATA_ROUTING_temp.BUFFERED_COUNT + sum( messages_y == forward_node);
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE( messages_y == forward_node ) = [];

            in_refresh_buffers;
        end
       
    end % End for message_index_temp
    
end

%%3.BufferX -> BufferY
if ( ~isempty( buffer_x ) ) && (sum (buffer_x == MN_INDEX_2 ) == 0)
    
    for forward_node = unique(buffer_x)
        
        node1 = routing_table.VS_NODE(MN_INDEX_1);
        node2 = routing_table.VS_NODE(MN_INDEX_2);
        forward_message = protocol_SimBet_forward(node1, node2, forward_node, alfa, beta);
        
        if forward_message == 1
            %节点2缓存储存节点1缓存的信息
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end + 1 : end + sum(buffer_x == forward_node)) = ...
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(buffer_x == forward_node);

            for adding_forwardNode_index = 0 : sum( buffer_x == forward_node) - 1 %message_x
                MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end - adding_forwardNode_index).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_1;
                temp_TTL = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end - adding_forwardNode_index).TTL;
                MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER( end - adding_forwardNode_index).TTL = temp_TTL + 1;
            end
            
            MN_DATA_ROUTING_temp.BUFFERED_COUNT = MN_DATA_ROUTING_temp.BUFFERED_COUNT + sum( buffer_x == forward_node);
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( buffer_x == forward_node ) = [];

            in_refresh_buffers;
        end
       
    end % End for message_index_temp
    
end

%%4.BufferY -> BufferX
if ( ~isempty( buffer_y ) ) && (sum (buffer_y == MN_INDEX_1  ) == 0)
   
    for forward_node = unique(buffer_y)
        
        node1 = routing_table.VS_NODE(MN_INDEX_2);
        node2 = routing_table.VS_NODE(MN_INDEX_1);
        forward_message = protocol_SimBet_forward(node1, node2, forward_node, alfa, beta);
        
        if forward_message == 1
            %节点1缓存储存节点2缓存的信息
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(end + 1 : end + sum(buffer_y == forward_node)) = ...
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(buffer_y == forward_node);

            for adding_forwardNode_index = 0 : sum(buffer_y == forward_node) - 1 
                MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(end - adding_forwardNode_index).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_2;
                temp_TTL = MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(end - adding_forwardNode_index).TTL;
                MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER( end - adding_forwardNode_index).TTL = temp_TTL + 1;
            end

            MN_DATA_ROUTING_temp.BUFFERED_COUNT = MN_DATA_ROUTING_temp.BUFFERED_COUNT + sum( buffer_y == forward_node);
            MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(buffer_y == forward_node) = [];

            in_refresh_buffers;
        end
       
    end % End for message_index_temp
    
end
