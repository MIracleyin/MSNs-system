%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_CALCULATE.m %%%%%%%%%%%%%%%%%%%%
% This script is used to calcualte the mobile of MNs%

function [MN_DATA] = MSN_CALCULATE(input_settings,MN_DATA)
%myFun - Description
%
% Syntax: [MN_DATA] = myFun(input_settings,MN_DATA)
%
% Long description
%根据论文2，计算移动节点的社交属性

clear MN_DATA_temp;
%clear C_DATA_temp;

%The Role Playing Mobility Model.
global MN_DATA_temp; %global MN_DATA Index.

MN_DATA_temp = MN_DATA;

%创建节点相遇的字段
for MN_INDEX = 1 : input_settings.MN_N
    %记录相遇
    MN_DATA_temp.VS_NODE(MN_INDEX).MEET_ALLTIMES = 0; %用于记录节点相遇总次数
    %MN_DATA_temp.VS_NODE(MN_INDEX).MEET_ALLID = [];%用于记录所有节点相遇的ID
    MN_DATA_temp.VS_NODE(MN_INDEX).MEET_ID = []; %用于记录相遇过节点的ID 
    %每一个节点都创建50个记录与对应节点相遇的储存空间
    for INTERMEET_INDEX = 1 : input_settings.MN_N
        %节点1与节点INTERMEET_INDEX的相遇记录，社交参数
        MN_DATA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTANT(INTERMEET_INDEX).ID = INTERMEET_INDEX;
        %用于记录节点1与INTERMMET_INDEX的相遇次数
        MN_DATA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTANT(INTERMEET_INDEX).MEET_TIMES = 0;
        %用于记录节点1与INTERMMET_INDEX的相遇时间
        MN_DATA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTANT(INTERMEET_INDEX).MEETING_TIME = [];
        %两节点之间的相遇概率 = 1节点遇到2节点次数/1节点遇到所有节点的次数 
        MN_DATA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTANT(INTERMEET_INDEX).ENCOUNTER_PROBABILITY = 0;
        %修正 ：1节点遇到2节点次数/最大相遇次数
        %MN_DATA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTANT(INTERMEET_INDEX).ENCOUNTER_PROBABILITY = 0;
        %TODO:待补充
    end
end

%count = 0
%对所有时间，计算移动节点相遇状况
for time = 1 : 24 * 60 %考虑到抽样
    %对于每一个移动节点
    for MN_INDEX_1 = 1 : input_settings.MN_N
        %计算所有时刻和移动节点的相遇情况
        %创建节点相遇数组

        for MN_INDEX_2 = 1 : input_settings.MN_N
            %获取当前节点1的 x,y
            temp_x_1 = MN_DATA_temp.VS_NODE(MN_INDEX_1).X_POSITION(time);
            temp_y_1 = MN_DATA_temp.VS_NODE(MN_INDEX_1).Y_POSITION(time);

            %获取当前节点2的 x,y
            temp_x_2 = MN_DATA_temp.VS_NODE(MN_INDEX_2).X_POSITION(time);
            temp_y_2 = MN_DATA_temp.VS_NODE(MN_INDEX_2).Y_POSITION(time);

            %计算两个节点的距离
            inter_distance = sqrt( (temp_y_2 - temp_y_1)^2 + (temp_x_2 - temp_x_1)^2 );
            
            %如果节点之间的距离小于定义的距离，那么定义为两个节点相遇，节点1相遇次数加一
            %然后检查他们是否已经相遇，如果没有，那么修改两个节点之间的相遇记录
            if(inter_distance < input_settings.MN_R)
                %如果节点1从未与节点2相遇，然后将其添加到相遇ID数组中，记录相遇时间
                if( isempty( find( MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ID == MN_INDEX_2, 1)))
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES = ... %节点1总相遇次数+1
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES + 1;
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ID(end + 1) = MN_INDEX_2; %记录相遇对象的ID
                    %节点1 与 节点2 的社会联系
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES = ...
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES + 1;%节点1与节点2相遇次数+1
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(end + 1) = ...
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).V_TIME(time);%记录节点1与节点2的相遇时刻
                else
                    %若节点1以及和节点2相遇过，为了防止相同的时间多次相遇（这不符合常理）
                    %若时间与最后一次相遇的时间不同
                    if( (time * 60 ~= MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(end) ))
                        MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES = ... %节点1总相遇次数+1
                        MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES + 1;
                        %此时无需记录节点ID，因为已经有过记录
                        %MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ID(end + 1) = MN_INDEX_2; %记录相遇对象的ID
                        %节点1 与 节点2 的社会联系
                        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES = ...
                        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES + 1;%节点1与节点2相遇次数+1
                        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(end + 1) = ...
                        MN_DATA_temp.VS_NODE(MN_INDEX_1).V_TIME(time);%记录节点1与节点2的相遇时刻
                    end
                end
                %对节点2做同样的操作
                if( isempty( find( MN_DATA_temp.VS_NODE(MN_INDEX_2).MEET_ID == MN_INDEX_1, 1)))
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).MEET_ALLTIMES = ... %节点1总相遇次数+1
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).MEET_ALLTIMES + 1;
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).MEET_ID(end + 1) = MN_INDEX_1; %记录相遇对象的ID
                    %节点1 与 节点2 的社会联系
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEET_TIMES = ...
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEET_TIMES + 1;%节点1与节点2相遇次数+1
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEETING_TIME(end + 1) = ...
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).V_TIME(time);%记录节点1与节点2的相遇时刻
                else
                    %若节点1以及和节点2相遇过，为了防止相同的时间多次相遇（这不符合常理）
                    %若时间与最后一次相遇的时间不同
                    if( (time * 60 == MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEETING_TIME(end) ))
                        MN_DATA_temp.VS_NODE(MN_INDEX_2).MEET_ALLTIMES = ... %节点1总相遇次数+1
                        MN_DATA_temp.VS_NODE(MN_INDEX_2).MEET_ALLTIMES + 1;
                        %此时无需记录节点ID，因为已经有过记录
                        %MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ID(end + 1) = MN_INDEX_2; %记录相遇对象的ID
                        %节点1 与 节点2 的社会联系
                        MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEET_TIMES = ...
                        MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEET_TIMES + 1;%节点1与节点2相遇次数+1
                        MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEETING_TIME(end + 1) = ...
                        MN_DATA_temp.VS_NODE(MN_INDEX_2).V_TIME(time);%记录节点1与节点2的相遇时刻
                    end
                end     
            end
        end
    end
    
end

%社交参数的计算
for MN_INDEX_1 = 1 : input_settings.MN_N
    for MN_INDEX_2 =  1 : input_settings.MN_N
        %MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).ENCOUNTER_PROBABILITY = ...
        %MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES/...
        %MN_DATA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES;
        %使用公式2
        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).ENCOUNTER_PROBABILITY = ...
        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES / 1440;%MEET_TINES/1440

        %计算公式4,5 需要修正
        %如果相遇次数小于2，那么
        if(MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES < 2)
            MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).ENCOUNTER_REGULARITY = 0;
        else
            %4 
            SUM_T = 0;
            for M_counter =  2 : MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES
                SUM_T = SUM_T + ...
                ( MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(M_counter) - ...
                MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(M_counter - 1) );
            end
            MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DELTA_T = ...
            1/(MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES - 1) * SUM_T;
            
            %5
            SUM_T_diff = 0;
            for M_counter =  2 : MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES
                SUM_T_diff = SUM_T_diff + ...
                ( MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(M_counter) - ...
                MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(M_counter - 1) - ...
                MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DELTA_T )^2;
            end
            MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).S_DELTA_T = ...
            sqrt( 1/(MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEET_TIMES - 2) * SUM_T_diff);

            %3
            MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).ENCOUNTER_REGULARITY = ...
            MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DELTA_T / ...
            (MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DELTA_T + ...
            MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).S_DELTA_T)
        end

        %6
        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY = ...
        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).ENCOUNTER_REGULARITY * ...
        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).ENCOUNTER_PROBABILITY;
        %结合仿真时长，可以结合8修正ageing效应
    end
end

MN_DATA = MN_DATA_temp;

end
%计算社交活跃度