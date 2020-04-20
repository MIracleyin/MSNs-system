% Delete messages and buffered messages already received by any of both
% nodes. This is only used for Epidemic and PRoPHET routing protocol.


% Check if message ID of x already received by y, by comparing all IDs.
if ~isempty(messages_x)

    IDs = [];
for msgIndex = 1: length(messages_x)
    
    if sum(  ID_received_messages_y == ID_messages_x(msgIndex) ) >= 1
        
        IDs(end+1) = msgIndex;
        
    end
    
end

% Remove message from source queue
if ~isempty(IDs)
mobilized_node_tmp.VS_NODE(index1).MESSAGE(  IDs   ) = [];

Refresh_ID;
refresh_buffers;
end

end


% Check if buffered message ID of x already received by y, by comparing all IDs.
if ~isempty(buffer_x)
    
IDs = [];
for msgIndex = 1: length(buffer_x)
    
    if sum(  ID_received_messages_y == ID_buffer_x(msgIndex) ) >= 1
        
        IDs(end+1) = msgIndex;
        
    end
    
end

% Remove message from source queue
if ~isempty(IDs)
mobilized_node_tmp.VS_NODE(index1).BUFFER(  IDs   ) = [];

Refresh_ID;
refresh_buffers;
end

end


% Check if message ID of x already received by y, by comparing all IDs.
if ~isempty(messages_y)

    IDs = [];
for msgIndex = 1: length(messages_y)
    
    if sum(  ID_received_messages_x == ID_messages_y(msgIndex) ) >= 1
        
        IDs(end+1) = msgIndex;
        
    end
    
end

% Remove message from source queue
if ~isempty(IDs)
mobilized_node_tmp.VS_NODE(index2).MESSAGE(  IDs   ) = [];

Refresh_ID;
refresh_buffers;
end

end


% Check if buffered message ID of x already received by y, by comparing all IDs.
if ~isempty(buffer_y)
    
IDs = [];
for msgIndex = 1: length(buffer_y)
    
    if sum(  ID_received_messages_x == ID_buffer_y(msgIndex) ) >= 1
        
        IDs(end+1) = msgIndex;
        
    end
    
end

% Remove message from source queue
if ~isempty(IDs)
mobilized_node_tmp.VS_NODE(index2).BUFFER(  IDs   ) = [];

Refresh_ID;
refresh_buffers;
end

end
