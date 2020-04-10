%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_CALCULATE.m %%%%%%%%%%%%%%%%%%%%
% This script is used to routing all MN's message %%%

function [MN_DATA_ROUTING Report] = MSN_ROUTING(input_settings, MN_DATA, routing_table, protocol)
%MSN_ROUTING - Description
%
% Syntax: [MN_DATA_ROUTING Report] = MSN_ROUTING(input_settings, MN_DATA, routing_table, protocol)
% 时长，一天
% 路由信息，并生成路由报告

clear MN_DATA_temp;

global MN_DATA_temp;
global message_index;

time_step = input_settings.MN_T_interval;

%将移动节点数据导入临时变量
MN_DATA_temp = MN_DATA;

%用于记录路由信息序列 TODO：待改进描述
message_index = 1;
%用于记录路由时间序列 TODO：待改进描述
routing_time_index = 1;

%初始化节点携带的信息
MN_DATA_temp.BUFFERED_COUNT = 0;
MN_DATA_temp.RECIVED_DIRECTLY = 0;
MN_DATA_temp.RECIVED_FROM_BUFFERED = 0;

%报告参数
total_messages = [];         %储存在每一个时间间隔中的所有信息数
received_messages = [];      %储存在每一个时间间隔中的所有接受信息数
buffered_messages = [];      %储存在每一个时间间隔中的所有累计缓存信息数

received_directly = [];      %储存在每一个时间间隔里的所有直接受到的信息数
received_from_buffered = []; %储存在每一个时间间隔里的所有从缓存获得的信息数
report_timing = [];          %储存时间

%
in_buffer = 0;
in_message = 0;
average_latency = 0;
metric_ratio = 0;

%所有时间
for time = 0 : time_step : input_settings.sTIME + time_step
        %  0 :    60     : 24 * 60 * 60 + 60

    for MN_INDEX_1 = 1 : input_settings.MN_INDEX_1 - 1 
        for MN_INDEX_2 = MN_INDEX_1 + 1 : input_settings.MN_N

            temp_x1 = MN_DATA_temp.VS_NODE(MN_INDEX_1).X_POSTION(routing_time_index);
            temp_y1 = MN_DATA_temp.VS_NODE(MN_INDEX_1).Y_POSTION(routing_time_index);

            temp_x2 = MN_DATA_temp.VS_NODE(MN_INDEX_2).X_POSTION(routing_time_index);
            temp_y2 = MN_DATA_temp.VS_NODE(MN_INDEX_2).Y_POSTION(routing_time_index);

            inter_distance = sqrt( (temp_x2 - temp_x1)^2 + (temp_y2 - temp_y1)^2 );

            %检查是否相遇
            if (inter_distance < input_settings.MN_R)
                switch protocol

                    case 'SCPR'
                        SCPR;
                    case 'other'
                        SCPR;
                end

                clc

                disp(['Time: ',num2str(time)])
                disp('--------------------------------')
                disp(['Message Count: ',num2str(MN_DATA_temp.MESSAGES_COUNT)])
                disp(['Received Count: ',num2str(MN_DATA_temp.RECEIVED_COUNT)])
                disp(['Message Receipt Percentage = ',num2str(100*MN_DATA_temp.RECEIVED_COUNT / MN_DATA_temp.MESSAGES_COUNT),' %',])
                disp(['Buffered Count: ',num2str(MN_DATA_temp.BUFFERED_COUNT)])
                disp(['Received Directly: ',num2str(MN_DATA_temp.RECEIVED_DIRECTLY)])
                disp(['Received from Buffer: ',num2str(MN_DATA_temp.RECEIVED_FROM_BUFFERED)])
                disp('--------------------------------')
                disp(['Stored In Buffer: ',num2str(in_buffer(end))])
                disp(['Not Yet Forwarded: ',num2str(in_message(end))])
                disp(['Average Latency: ',num2str(average_latency(end))])
                disp(['Average Hops: ',num2str(metric_ratio(end))])
                disp('--------------------------------')
            end
        end %序列2
    end %序列1

    %如果时间对采样周期取余小于采样间隔
    if ( rem( time, input_settings.MN_T_interval) < time_step) 
        total_messages(end + 1) = [MN_DATA_temp.MESSAGES_COUNT];   %目前为止生成信息总数
        received_messages(end + 1) = [MN_DATA_temp.RECEIVED_COUNT];%所有节点接受的信息总数
        buffered_messages(end + 1) = [MN_DATA_temp.BUFFERED_COUNT];%所有节点的缓存信息

        received_directly(end + 1) = [MN_DATA_temp.RECEIVED_DIRECTLY];%所有直接接收的信息
        received_from_buffered(end + 1) = [MN_DATA_temp.RECEIVED_FROM_BUFFERED];%所有从缓存接收的信息
        report_timing(end + 1) = time %更新时间

        % 为每个节点设定参数、接收和缓存的信息数量
        inBuffer = 0;
        inMessages = 0;
        metric = []; %不理解

        for MN_INDEX = 1 : input_settings.MN_N
            MN_DATA_temp.VS_NODE(MN_INDEX).INSTANT_MESSAGE_COUNT(end + 1) = ...
            length([MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE]);

            MN_DATA_temp.VS_NODE(MN_INDEX).INSTANT_BUFFER_COUNT(end + 1) = ...
            length([MN_DATA_temp.VS_NODE(MN_INDEX).BUFFER]);

            MN_DATA_temp.VS_NODE(MN_INDEX).INSTANT_RECEIVED_COUNT(end + 1) = ...
            length([MN_DATA_temp.VS_NODE(MN_INDEX).RECEIVED_MESSAGE]);

            inBuffer = inBuffer + length(MN_DATA_temp.VS_NODE(MN_INDEX).BUFFER)


            %获取接收信息的间隔以及信息长度
            [reception_delay(MN_INDEX) packets_received(MN_INDEX)] = ...
            get_reception_duration(MN_DATA_temp.VS_NODE(MN_INDEX).RECEIVED_MESSAGE); 
            %用于计算信息的公制
            metric(MN_INDEX) = get_metric_value(MN_DATA_temp.VS_NODE(MN_INDEX).RECEIVED_MESSAGE);
        end
        
        in_buffer(end + 1) = inBuffer;
        in_message(end + 1) = inMessages;
        metric_ratio(end + 1) = sum(metric)/input_settings.MN_N;

        %如果接收的数据包不为0
        if sum(packets_received) ~= 0
            average_latency(end + 1) = sum(reception_delay)/sum(packets_received);
        else
            average_latency(end + 1) = 0;
        end
    end

    %每个信息间隔创建消息                                       % 时间不为 0  % 时间为一天的早8个小时
    if ( rem(time, input_settings.MN_T_interval) < time_step) && time ~= 0 && time <= input_settings.sTIME/4

        no_of_message_nodes = randi( [1 input_settings.MN_N], [1 1] );
        no_of_message_nodes = 10;







end