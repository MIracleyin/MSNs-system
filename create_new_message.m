%% Create new message for each node

%信息数量
number_of_messages = length( MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE);

%临时信息数为 节点中储存的数值
message_count_temp = MN_DATA_temp.MESSAGES_COUNT;
% message_id_temp = str2num ( MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE( message_index ).ID )

%新的信息ID为 节点序号 * 10的MN_DATA.ID_DIGIT_COUNT次方 + 信息序列
message_id_new = MN_INDEX * 10^(MN_DATA.ID_DIGIT_COUNT) + message_index;
% message_id_new = message_id_temp + 1;
%转为字符串
message_id_new = num2str(message_id_new);

%移动节点的信息ID，以及信息源头
MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(number_of_messages+1).ID = message_id_new;
MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(number_of_messages+1).FROM = MN_INDEX;

%信息是否接受
message_receipt_while = true;
%当信息可以接受时
while message_receipt_whilez
    %随机生成一个1-50的值
    receipt_index_temp = randi([1 input_settings.NUMBER_OF_NODES], [1 1] );
    %如果这个值不是其本身
    if receipt_index_temp ~= MN_INDEX
        %那么就将该信息发向这个目标节点
        MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(number_of_messages+1).TO = receipt_index_temp;
        message_receipt_while = false;
    end
    
end
%创建下一条信息
MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(number_of_messages+1).NUMBER_OF_FORWARDS = [];
MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(number_of_messages+1).TTL = 0;
MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(number_of_messages+1).CREATION_TIME = time;
MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(number_of_messages+1).RECEIPTION_TIME = 0;

MN_DATA_temp.MESSAGES_COUNT = message_count_temp + 1;
