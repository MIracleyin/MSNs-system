%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%  Social Contact Probability Assisted Routing      %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCPR social contact probability protocol

%% 获取信息并缓存信息 目标地址
messages_x = []; %messages_x = [MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(:).TO]
messages_y = []; %messages_y = [MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(:).TO]

buffer_x = []; %[MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(:).TO]
buffer_y = []; %[MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(:).TO]

%刷新信息和缓存，同时读取信息和缓存
in_refresh_buffers;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 源节点与目标节点直接相遇的状况 首先完成直接传递
%%1. 节点2是节点1的传信目标 不存入buffer
if sum ( messages_x == MN_INDEX_2 ) >= 1
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
if sum(buffer_x == MN_INDEX_2) >= 1
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
if (~isempty( messages_x) ) && (sum(messages_x == MN_INDEX_2) == 0) 
    %调用传递脚本前，设定好节点与相遇节点
    nodeIndex = MN_INDEX_1;
    intermeet_node = MN_INDEX_2;

    delete_message = [];
    for forward_node = unique(messages_x)
        protocol_SCPRsetForward;
        %如果满足传递调剂
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
    end
end


%%节点2信息传至节点1缓存
%%2.MSG_Y -> Buffer_X
if (~isempty(messages_y) ) && (sum(messages_y == MN_INDEX_1) == 0)
    nodeIndex = MN_INDEX_2;
    intermeet_node = MN_INDEX_1;

    delete_message = [];
    for forward_node = unique(messages_y)
        protocol_SCPRsetForward;
        %如果满足传递调
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
    end
end

%%节点1缓存传至节点2缓存
%%3.BufferX -> BufferY
if ( ~isempty( buffer_x )) && (sum (buffer_x == MN_INDEX_2 ) == 0)
    nodeIndex = MN_INDEX_1;
    intermeet_node = MN_INDEX_2;

    delete_message = [];
    for forward_node = unique(buffer_x)
        protocol_SCPRsetForward;
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
    end
end

%%节点2缓存传至节点1缓存
%%4.BufferY -> BufferX
if ( ~isempty( buffer_y )) && ( sum (buffer_y == MN_INDEX_1) == 0)
    nodeIndex = MN_INDEX_2;
    intermeet_node = MN_INDEX_1;

    delete_message = [];
    for forward_node = unique(buffer_y)
        protocol_SCPRsetForward;
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
    end
end


%}


