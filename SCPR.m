%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%  Social Contact Probability Assisted Routing      %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCPR social contact probability protocol

%% 获取信息并缓存信息 目标地址
message_x = [];
message_y = [];

buffer_x = [];
buffer_y = [];

%刷新信息和缓存，同时读取信息和缓存
refresh_buffers;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 源节点与目标节点直接相遇的状况
%%1. 节点2是节点1的传信目标 不存入buffer
if sum ( message_x == MN_INDEX_2 ) >= 1
    % 节点1向节点2发送信息
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE( end + 1: end + sum(message_x == MN_INDEX_2)) = ...
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(message_x == MN_INDEX_2) %
    %
    for adding_time_index = 0 : sum(message_x == MN_INDEX_2) - 1
        %记录信息接收的时间
        MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end
    %移除原节点信息
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(message_x == MN_INDEX_2) = [];
    %接收信息量 + 1
    MN_DATA_ROURTING_temp.RECEIVED_COUNT = MN_DATA_ROURTING_temp.RECEIVED_COUNT + sum(message_x == MN_INDEX_2);
    %直接传递量 + 1
    MN_DATA_ROURTING_temp.RECEIVED_DIRECTLY = MN_DATA_ROURTING_temp.RECEIVED_DIRECTLY + sum(message_x == MN_INDEX_2);

    refresh_buffers;
end

%%2.节点2是节点1缓存中传信目标
if sum(buffer_x == MN_INDEX_2) >= 1
    % 节点1缓存向节点2发送信息
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE(end + 1:end + sum( buffer_x == MN_INDEX_2)) = ...
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).BUFFER(buffer_x == MN_INDEX_2)

    for adding_time_index = 0 : sum(buffer_x == MN_INDEX_2) - 1
        MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end

    %移除节点1缓存中的信息
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).BUFFER(buffer_x == MN_INDEX_2) = [];
    %接收信息量 + 1
    MN_DATA_ROURTING_temp.RECEIVED_COUNT = MN_DATA_ROURTING_temp.RECEIVED_COUNT + sum(buffer_x == MN_INDEX_2);
    %间接传递量 + 1
    MN_DATA_ROURTING_temp.RECEIVED_FROM_BUFFERED = MN_DATA_ROURTING_temp.RECEIVED_FROM_BUFFERED + sum(buffer_x == MN_INDEX_2);

    refresh_buffers;
end

%%3.节点1是节点2的传信目标 不存入buffer
if sum(message_y == MN_INDEX_1) >= 1
    % 节点2向节点1发送信息
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end + 1:end + sum(message_y == MN_INDEX_1)) = ...
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(message_y == MN_INDEX_1);

    for adding_time_index = 0 : sum(message_y == MN_INDEX_1) - 1
        MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end

    %移除节点2信息
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).MESSAGE( message_y == MN_INDEX_1) = [];
    %接收信息量 + 1
    MN_DATA_ROURTING_temp.RECEIVED_COUNT = MN_DATA_ROURTING_temp.RECEIVED_COUNT + sum(message_y == MN_INDEX_1);
    %直接传递量 + 1
    MN_DATA_ROURTING_temp.RECEIVED_DIRECTLY = MN_DATA_ROURTING_temp.RECEIVED_DIRECTLY + sum(message_y == MN_INDEX_1);

    refresh_buffers;
end

%%4. 节点1是节点2缓存中的传信目标
if sum(buffer_y == MN_INDEX_1) >= 1
    %节点2缓存向节点1发送消息
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end + 1:end + sum(buffer_y == MN_INDEX_1)) = ...
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).BUFFER(buffer_y == MN_INDEX_1);

    for adding_time_index = 0:sum(buffer_y == MN_INDEX_1) - 1
        MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(end - adding_time_index).RECEIPTION_TIME = time;
    end

    %移除节点2缓存信息
    MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).BUFFER( buffer_y == MN_INDEX_1) = [];
    %接收信息量 + 1
    MN_DATA_ROURTING_temp.RECEIVED_COUNT = MN_DATA_ROURTING_temp.RECEIVED_COUNT + sum(buffer_y == MN_INDEX_1);
    %间接传递量 + 1
    MN_DATA_ROURTING_temp.RECEIVED_FROM_BUFFERED = MN_DATA_ROURTING_temp.RECEIVED_FROM_BUFFERED + sum(buffer_y == MN_INDEX_1);

    refresh_buffers;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%依靠中间节点传递信息
%%节点1信息传至节点2缓存
%节点1信息非空且节点1信息并节点2并非节点1目标
if (~isempty( message_x) ) && (sum(message_x == MN_INDEX_2) == 0) 
    %调用传递脚本前，设定好节点与相遇节点
    nodeIndex = MN_INDEX_1;
    intermeet_node = MN_INDEX_2;

    delete_message = [];
    for forward_node = unique(message_x)
        %setForward; 未完成
        %如果满足传递调剂
        if forward_message == 1
            %节点2缓存储存节点1的信息
            MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end + 1 : end + sum(message_x == forward_message)) = ...
            MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(message_x == forward_node);
            %统计更新
            for adding_forwardNode_index = 0 : sum(message_x == forward_node) - 1
                MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end - adding_forwardNode_index).NUMBER_OF_FORWARDS(end + 1) = MN_INDEX_1;
                temp_TTL = MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end - adding_forwardNode_index).TTL;
                MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_2).BUFFER(end - adding_forwardNode_index).TTL = temp_TTL + 1;
            end

            MN_DATA_ROURTING_temp.BUFFERED_COUNT = MN_DATA_ROURTING_temp.BUFFERED_COUNT + sum(message_x == forward_node);
            MN_DATA_ROURTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(message_x == forward_node) = [];

            refresh_buffers;
        end
    end
end


%%节点2信息传至节点1缓存

%%节点1缓存传至节点2缓存

%%节点2缓存传至节点1缓存




