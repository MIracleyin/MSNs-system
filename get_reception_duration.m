% Return reception_delay which stores the total delay of reception of the whole 
% buffer RECEIVED_MESSAGE And packets_received the count of messages in the 
% buffer.

function [ reception_delay packets_received ] = get_reception_duration(RECEIVED_MESSAGE)
         % 接收时延后      数据包长度
%先设接收时延为0
reception_delay = 0;
%接收数据包长度 为接收信息的长度
packets_received = length(RECEIVED_MESSAGE);

%遍历 数据包 中的每一位信息
for packets = 1:packets_received
    
    %记录 此接收到的信息 的创建时间
    creation_time = RECEIVED_MESSAGE(packets).CREATION_TIME;
    %记录 此接收到的信息 的接收时间
    reception_time = RECEIVED_MESSAGE(packets).RECEIPTION_TIME ;
    %接收时延为所有位上的接收时间减创建时间之差的总和
    reception_delay = reception_delay + (reception_time - creation_time);
    
end

end