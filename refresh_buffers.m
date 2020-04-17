%% Refresh_buffers
% Get messages and buffered messages destination address
messages_x = [];
messages_y = [];

buffer_x = [];
buffer_y = [];

%获取节点x,y的信息ID
% Get messages IDs of nodes x and y
%如果节点x的长度大于等于1，那么读取该信息ID
if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE) >= 1
    messages_x = [MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).MESSAGE(:).TO];
end

%如果节点y的长度大于等于1，那么读取该信息ID
if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE) >= 1
    messages_y = [MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).MESSAGE(:).TO];
end

% Get buffered messages IDs of nodes x and y
%获取缓存中的信息ID
if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER) >= 1
    buffer_x  = [MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_1).BUFFER(:).TO];
end

if length(MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER) >= 1
    buffer_y = [MN_DATA_ROUTING_temp.VS_NODE(MN_INDEX_2).BUFFER(:).TO];
end