%% Refresh_ID : Refresh ID arrays used in Epidemic and PRoPHET routing protocols


% Get messages and buffered messages destination address
ID_messages_x = [];
ID_messages_y = [];

ID_received_messages_x = [];
ID_received_messages_y = [];

ID_buffer_x = [];
ID_buffer_y = [];

% Get messages IDs of nodes x and y
if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE) > 0
    for msg_index =  1: length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE)
        ID_messages_x(end+1) = str2double(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(msg_index).ID);
    end
end

if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE) > 0
    for msg_index = 1: length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE)
        ID_messages_y(end+1) = str2double(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(msg_index).ID);
    end
end

% Get received messages IDs of nodes x and y
if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE) > 0
    for msg_index =  1: length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE)
        ID_received_messages_x(end+1) = str2double(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).RECEIVED_MESSAGE(msg_index).ID);
    end
end

if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE) > 0
    for msg_index = 1: length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE)
        ID_received_messages_y(end+1) = str2double(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).RECEIVED_MESSAGE(msg_index).ID);
    end
end

% Get buffered messages IDs of nodes x and y
if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER) > 0
    for msg_index = 1: length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER)
        ID_buffer_x(end+1)  = str2double(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(msg_index).ID);
    end
end

if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER) > 0
    for msg_index = 1: length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER)
        ID_buffer_y(end+1) = str2double(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(msg_index).ID);
    end
end