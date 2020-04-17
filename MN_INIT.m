%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MN_init.m %%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to initialize the MN DATA %%%%

function [MN_DATA_INIT] = MN_INTI(input_settings, s_data_day)

    clear MN_DATA_INIT_temp;

    global MN_DATA_INIT_temp;

    digit_count = numel( num2str(input_settings.sTIME * s_data_day /input_settings.MSG_T_interval) );
    %用于初始化节点出生位置

    %% Wait Bar
    wait_bar = waitbar(0 , 'Mobile Node initialize');
    set(wait_bar, 'name', 'Mobile Node initializing...');
    wb = 50/length(1:input_settings.MN_N);
    for MN_INDEX = 1:input_settings.MN_N
        %节点随机出生的家
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).HOME = unidrnd(input_settings.cAREA_N);
        %生成节点主任务地点
        %主任务地点不能为家
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).P_community = MN_DATA_INIT_temp.VS_NODE(MN_INDEX).HOME;%将任务地点设为家
        while MN_DATA_INIT_temp.VS_NODE(MN_INDEX).P_community == MN_DATA_INIT_temp.VS_NODE(MN_INDEX).HOME%当任务地点为家时，循环成立
                MN_DATA_INIT_temp.VS_NODE(MN_INDEX).P_community = unidrnd(input_settings.cAREA_N);%任务随机生成，当随机任务不为家时，循环结束
        end

        %% 可能要直接赋值
        %设置节点的ID, FROM, TO, TTL, Number of forwards,Creation
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).MESSAGE(1).ID = num2str(MN_INDEX * 1000);
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).MESSAGE(1).FROM = MN_INDEX;

        %设置目标节点
        message_receipt_while = true;
        while message_receipt_while
            receipt_index_temp = randi([1 input_settings.MN_N], [1 1]);
            if receipt_index_temp ~= MN_INDEX
                MN_DATA_INIT_temp.VS_NODE(MN_INDEX).MESSAGE(1).TO = receipt_index_temp;
                message_receipt_while = false;
            end
        end

        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).MESSAGE(1).NUMBER_OF_FORWARDS = [];
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).MESSAGE(1).TTL = 0;
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).MESSAGE(1).CREATION_TIME = 0;
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).MESSAGE(1).RECEIPTION_TIME = 0;

        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).RECEIVED_MESSAGE = ...
            struct('ID', {},...
                   'FROM', {},...
                   'TO',{},...
                   'NUMBER_OF_FORWARDS', {},...
                   'TTL', {},...
                   'CREATION_TIME', {},...
                   'RECEIPTION_TIME', {}) ;

        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).BUFFER =  ...
            struct('ID', {},...
                   'FROM', {},...
                   'TO', {},...
                   'NUMBER_OF_FORWARDS', {},...
                   'TTL', {},...
                   'CREATION_TIME', {},...
                   'RECEIPTION_TIME', {}) ;

        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).INSTANT_MESSAGE_COUNT = [];
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).INSTANT_BUFFER_COUNT = [];
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).INSTANT_RECEIVED_COUNT = [];
    
        str_bar = ['NO.' num2str(wb) ' Mobile Node initializing...'];
        waitbar(wb/50, wait_bar, str_bar);
        wb = wb + 50/length(1:input_settings.MN_N);
    end
    close(wait_bar); 

    MN_DATA_INIT_temp.MESSAGES_COUNT = 1 * input_settings.MN_N;
    MN_DATA_INIT_temp.RECEIVED_COUNT = 0;
    MN_DATA_INIT_temp.BUFFERED_COUNT = 0;
    MN_DATA_INIT_temp.ID_DIGIT_COUNT = digit_count;

    MN_DATA_INIT = MN_DATA_INIT_temp;
end
    
