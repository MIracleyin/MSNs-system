%% Refresh_ID : Refresh ID arrays used in Epidemic and PRoPHET routing protocols


% Get messages and buffered messages destination address
ID_messages_x = [];
ID_messages_y = [];

ID_received_messages_x = [];
ID_received_messages_y = [];

ID_buffer_x = [];
ID_buffer_y = [];

% Get messages IDs of nodes x and y
if length(mobilized_node_tmp.VS_NODE(index1).MESSAGE) > 0
    for msg_index =  1: length(mobilized_node_tmp.VS_NODE(index1).MESSAGE)
        ID_messages_x(end+1) = str2double(mobilized_node_tmp.VS_NODE(index1).MESSAGE(msg_index).ID);
    end
end

if length(mobilized_node_tmp.VS_NODE(index2).MESSAGE) > 0
    for msg_index = 1: length(mobilized_node_tmp.VS_NODE(index2).MESSAGE)
        ID_messages_y(end+1) = str2double(mobilized_node_tmp.VS_NODE(index2).MESSAGE(msg_index).ID);
    end
end

% Get received messages IDs of nodes x and y
if length(mobilized_node_tmp.VS_NODE(index1).RECEIVED_MESSAGE) > 0
    for msg_index =  1: length(mobilized_node_tmp.VS_NODE(index1).RECEIVED_MESSAGE)
        ID_received_messages_x(end+1) = str2double(mobilized_node_tmp.VS_NODE(index1).RECEIVED_MESSAGE(msg_index).ID);
    end
end

if length(mobilized_node_tmp.VS_NODE(index2).RECEIVED_MESSAGE) > 0
    for msg_index = 1: length(mobilized_node_tmp.VS_NODE(index2).RECEIVED_MESSAGE)
        ID_received_messages_y(end+1) = str2double(mobilized_node_tmp.VS_NODE(index2).RECEIVED_MESSAGE(msg_index).ID);
    end
end

% Get buffered messages IDs of nodes x and y
if length(mobilized_node_tmp.VS_NODE(index1).BUFFER) > 0
    for msg_index = 1: length(mobilized_node_tmp.VS_NODE(index1).BUFFER)
        ID_buffer_x(end+1)  = str2double(mobilized_node_tmp.VS_NODE(index1).BUFFER(msg_index).ID);
    end
end

if length(mobilized_node_tmp.VS_NODE(index2).BUFFER) > 0
    for msg_index = 1: length(mobilized_node_tmp.VS_NODE(index2).BUFFER)
        ID_buffer_y(end+1) = str2double(mobilized_node_tmp.VS_NODE(index2).BUFFER(msg_index).ID);
    end
end