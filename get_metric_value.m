function metric = get_metric_value(node_received_messages)
         %

%先设公制值为0
metric_value = 0;
%如果节点的信息不为空
if ~isempty(node_received_messages)
    %遍历信息序列的每一位
    for message_index = 1: length(node_received_messages)
        %每一位跳数为信息位对应为的向前跳数
        hop_nodes = node_received_messages(message_index).NUMBER_OF_FORWARDS;
        %公制值为 各个信息位的跳数和
        metric_value = metric_value + length(hop_nodes);
        
    end
    %将其归一化
    metric = metric_value/length(node_received_messages);
    
else
    %如果信息为空，则设为0
    metric = 0;
    
end

end
