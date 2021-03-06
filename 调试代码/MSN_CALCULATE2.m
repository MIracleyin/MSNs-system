%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_CALCULATE.m %%%%%%%%%%%%%%%%%%%%
% This script is used to calcualte the mobile of MNs%

function [MN_DATA_SOCIA,ROUTING_TABLE] = MSN_CALCULATE2(input_settings,MN_DATA,s_data_day,ageing)
%myFun - Description
%
% Syntax: [MN_DATA] = myFun(input_settings,MN_DATA)
%
% Long description
%根据论文2，计算移动节点的社交属性

clear MN_DATA_SOCIA_temp;
clear ROUTING_TABLE;
%The Role Playing Mobility Model.
global MN_DATA_SOCIA_temp; %global MN_DATA Index.

MN_DATA_SOCIA_temp = MN_DATA;
%ROUTING_TABLE_temp = ROUTING_TABLE;

%创建节点相遇的字段

for MN_INDEX = 1 : input_settings.MN_N
    %记录相遇
    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX).MEET_ALLTIMES = 0; %用于记录节点相遇总次数
    %MN_DATA_temp.VS_NODE(MN_INDEX).MEET_ALLID = [];%用于记录所有节点相遇的ID
    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX).MEET_ID = []; %用于记录相遇过节点的ID 
    %每一个节点都创建50个记录与对应节点相遇的储存空间
    for INTERMEET_INDEX = 1 : input_settings.MN_N
        %节点1与节点INTERMEET_INDEX的相遇记录，社交参数
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTACT(INTERMEET_INDEX).ID = INTERMEET_INDEX;
        %用于记录节点1与INTERMMET_INDEX的相遇次数
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTACT(INTERMEET_INDEX).MEET_TIMES = 0;
        %用于记录节点1与INTERMMET_INDEX的相遇时间
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTACT(INTERMEET_INDEX).MEETING_TIME = [];
        %两节点之间的相遇概率 = 1节点遇到2节点次数/1节点遇到所有节点的次数 
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTACT(INTERMEET_INDEX).ENCOUNTER_PROBABILITY = 0;
        %修正 ：1节点遇到2节点次数/最大相遇次数
        %MN_DATA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTACT(INTERMEET_INDEX).ENCOUNTER_PROBABILITY = 0;
        %TODO:待补充
    end
end

%count = 0

%对所有时间，计算移动节点相遇状况
%waitbar
wait_bar = waitbar(0, 'Meet Situation');
set(wait_bar, 'name','Meeting...');
wb = 1;
for time = 1 : 24 * 60 * s_data_day%考虑到抽样
    %对于每一个移动节点
    for MN_INDEX_1 = 1 : input_settings.MN_N
        %计算所有时刻和移动节点的相遇情况
        %创建节点相遇数组

        for MN_INDEX_2 = 1 : input_settings.MN_N
            %获取当前节点1的 x,y
            temp_x_1 = MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).X_POSITION(time);
            temp_y_1 = MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).Y_POSITION(time);

            %获取当前节点2的 x,y
            temp_x_2 = MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).X_POSITION(time);
            temp_y_2 = MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).Y_POSITION(time);

            %计算两个节点的距离
            inter_distance = sqrt( (temp_y_2 - temp_y_1)^2 + (temp_x_2 - temp_x_1)^2 );
            
            %如果节点之间的距离小于定义的距离，那么定义为两个节点相遇，节点1相遇次数加一
            %然后检查他们是否已经相遇，如果没有，那么修改两个节点之间的相遇记录
            if(inter_distance < input_settings.MN_R)
                %如果节点1从未与节点2相遇，然后将其添加到相遇ID数组中，记录相遇时间
                if( isempty( find( MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ID == MN_INDEX_2, 1)))
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES = ... %节点1总相遇次数+1
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES + 1;
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ID(end + 1) = MN_INDEX_2; %记录相遇对象的ID
                    %节点1 与 节点2 的社会联系
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES + 1;%节点1与节点2相遇次数+1
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(end + 1) = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).V_TIME(time);%记录节点1与节点2的相遇时刻
                else
                    %若节点1以及和节点2相遇过，为了防止相同的时间多次相遇（这不符合常理）
                    %若时间与最后一次相遇的时间不同
                    if( (time * 60 ~= MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(end) ))
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES = ... %节点1总相遇次数+1
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES + 1;
                        %此时无需记录节点ID，因为已经有过记录
                        %MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ID(end + 1) = MN_INDEX_2; %记录相遇对象的ID
                        %节点1 与 节点2 的社会联系
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES = ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES + 1;%节点1与节点2相遇次数+1
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(end + 1) = ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).V_TIME(time);%记录节点1与节点2的相遇时刻
                    end
                end
                %对节点2做同样的操作
                if( isempty( find( MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).MEET_ID == MN_INDEX_1, 1)))
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).MEET_ALLTIMES = ... %节点1总相遇次数+1
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).MEET_ALLTIMES + 1;
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).MEET_ID(end + 1) = MN_INDEX_1; %记录相遇对象的ID
                    %节点1 与 节点2 的社会联系
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTACT(MN_INDEX_1).MEET_TIMES = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTACT(MN_INDEX_1).MEET_TIMES + 1;%节点1与节点2相遇次数+1
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTACT(MN_INDEX_1).MEETING_TIME(end + 1) = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).V_TIME(time);%记录节点1与节点2的相遇时刻
                else
                    %若节点1以及和节点2相遇过，为了防止相同的时间多次相遇（这不符合常理）
                    %若时间与最后一次相遇的时间不同
                    if( (time * 60 ~= MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTACT(MN_INDEX_1).MEETING_TIME(end) ))
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).MEET_ALLTIMES = ... %节点1总相遇次数+1
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).MEET_ALLTIMES + 1;
                        %此时无需记录节点ID，因为已经有过记录
                        %MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ID(end + 1) = MN_INDEX_2; %记录相遇对象的ID
                        %节点1 与 节点2 的社会联系
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTACT(MN_INDEX_1).MEET_TIMES = ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTACT(MN_INDEX_1).MEET_TIMES + 1;%节点1与节点2相遇次数+1
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTACT(MN_INDEX_1).MEETING_TIME(end + 1) = ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_2).V_TIME(time);%记录节点1与节点2的相遇时刻
                    end
                end     
            end
        end
    end
    str_bar = ['The Meet ' num2str(wb) ' Time'];
    waitbar(wb/(24 * 60 * s_data_day), wait_bar, str_bar);
    wb = wb + (24*60*s_data_day)/(24*60*s_data_day);
end
close(wait_bar);

%社交参数的计算
wait_bar = waitbar(0, 'Mobile Node Parameter Calculate');
set(wait_bar,'name', 'Mobile Node Parameter Calculate' );
wb = 50/input_settings.MN_N;
for MN_INDEX_1 = 1 : input_settings.MN_N
    for MN_INDEX_2 =  1 : input_settings.MN_N
        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_PROBABILITY = ...
        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES/...
        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES;
        %使用公式2
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_PROBABILITY = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES / 28800;%MEET_TINES/1440

        %计算公式4,5 需要修正
        %如果相遇次数小于2，那么
        if(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES < 2)
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY = 0;
        else
            %4 
            SUM_T = 0;
            for M_counter =  2 : MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES
                SUM_T = SUM_T + ...
                ( MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(M_counter) - ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(M_counter - 1) );
            end
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DELTA_T = ...
            1/(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES - 1) * SUM_T;
            
            %5
            SUM_T_diff = 0;
            for M_counter =  2 : MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES
                SUM_T_diff = SUM_T_diff + ...
                ( MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(M_counter) - ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(M_counter - 1) - ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DELTA_T )^2;
            end
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).S_DELTA_T = ...
            sqrt( 1/(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES - 2) * SUM_T_diff);
            if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).S_DELTA_T)
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).S_DELTA_T = 0;
            end

            %3
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY = ...
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DELTA_T / ...
            (MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DELTA_T + ...
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).S_DELTA_T);

            if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY)
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY = 0;
            end
        end

        %6
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY * ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_PROBABILITY;

        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY * ageing;%ageing
        %直接概率存入路由表
        ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
        %结合仿真时长，可以结合8修正ageing效应
    end
    str_bar = ['NO.' num2str(wb) ' Mobile Node'];
    waitbar(wb/input_settings.MN_N, wait_bar, str_bar);
    wb = wb + 50/input_settings.MN_N;
end
close(wait_bar);

%记录间接概率，使用DIRECT_PROBABILITY_AVE计算
%MN_DATA_SOCIA_temp(2) = MN_DATA_SOCIA_temp %保存路由表
%HOP1
%{
for MN_INDEX_1 = 1 : input_settings.MN_N %源节点MN1
    for MN_INDEX_2 = 1:input_settings.MN_N %目标节点MN2
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
        if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1)
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = 0;
        end
        %保存为路由表，方便调用
        ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1;
    end
end

%HOP2
for MN_INDEX_1 = 1 : input_settings.MN_N %源节点MN1
    for MN_INDEX_2 = 1:input_settings.MN_N %目标节点MN2
        for MN_INDEX_X = 1 : input_settings.MN_N %任取一中间节点
            if (MN_INDEX_X ~= MN_INDEX_1) & (MN_INDEX_X ~= MN_INDEX_2) %选取一个除了节点1和节点2以外的节点
                %节点1到节点2二跳传递概率为 节点1直接传递给节点x的概率*节点x直接传给节点2的概率
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_X).DIRECT_PROBABILITY * ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
            else
                %待修改，可能有问题
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = 0;
            end
            if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2)
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = 0;
            end
            ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = ...
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2;
        end
    end
end

%HOP3
wait_bar = waitbar(0 , 'Mobile Node HOP3 calculate');
set(wait_bar, 'name', 'Mobile Node HOP3 calculating...');
wb = 50/length(1:input_settings.MN_N)
for MN_INDEX_1 = 1 : input_settings.MN_N%源节点MN1
    for MN_INDEX_2 = 1 : input_settings.MN_N%目标节点MN2
        for MN_INDEX_X1 = 1 : input_settings.MN_N%任取一中间节点1
            for MN_INDEX_X2 = 1 : input_settings.MN_N%任取一中间节点2
                if (MN_INDEX_X1 ~= MN_INDEX_1) & (MN_INDEX_X1 ~= MN_INDEX_2) & (MN_INDEX_X2 ~= MN_INDEX_X1) & (MN_INDEX_X2 ~= MN_INDEX_2)
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_X1).DIRECT_PROBABILITY * ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X1).SOCIAL_CONTACT(MN_INDEX_X2).DIRECT_PROBABILITY * ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X2).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
                else
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = 0;
                end
                if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3)
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = 0;
                end
                ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3;
            end
        end
    end
    str_bar = ['NO.' num2str(wb) ' Mobile Node HOP3 calculating...']
    waitbar(wb/50, wait_bar, str_bar);
    wb = wb + 50/length(1:input_settings.MN_N);
end
close(wait_bar);
%}

%HOP3
wait_bar = waitbar(0 , 'Mobile Node HOP calculate');
set(wait_bar, 'name', 'Mobile Node HOP calculating...');
wb = 50/length(1:input_settings.MN_N);
for MN_INDEX_1 = 1 : input_settings.MN_N%源节点MN1
    for MN_INDEX_2 = 1 : input_settings.MN_N%目标节点MN2
        for MN_INDEX_X1 = 1 : input_settings.MN_N%任取一中间节点1
            for MN_INDEX_X2 = 1 : input_settings.MN_N%任取一中间节点2
                if (MN_INDEX_X1 ~= MN_INDEX_1) && (MN_INDEX_X1 ~= MN_INDEX_2) && (MN_INDEX_X2 ~= MN_INDEX_X1) && (MN_INDEX_X2 ~= MN_INDEX_2)
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_X1).DIRECT_PROBABILITY * ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X1).SOCIAL_CONTACT(MN_INDEX_X2).DIRECT_PROBABILITY * ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X2).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
                    if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3)
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = 0;
                    end
                    ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3;
                elseif (MN_INDEX_X1 ~= MN_INDEX_1) && (MN_INDEX_X1 ~= MN_INDEX_2)
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_X1).DIRECT_PROBABILITY * ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
                    if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2)
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = 0;
                    end
                    ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2;
                else
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
                    if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1)
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = 0;
                    end
                    ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = ...
                    MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1;
                end
            end
        end
    end
    str_bar = ['NO.' num2str(wb) ' Mobile Node HOP calculating...'];
    waitbar(wb/50, wait_bar, str_bar);
    wb = wb + 50/length(1:input_settings.MN_N);
end
close(wait_bar);

MN_DATA_SOCIA = MN_DATA_SOCIA_temp;
ROUTING_TABLE = ROUTING_TABLE_temp;

end
%计算社交活跃度