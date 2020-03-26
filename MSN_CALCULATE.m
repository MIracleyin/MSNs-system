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
    MN_DATA_temp.VS_NODE(MN_INDEX).INTER_MEET = [];
    %每一个节点都创建50个记录与对应节点相遇的储存空间
    for INTERMEET_INDEX = 1 : input_settings.MN_N
        MN_DATA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTANT(INTERMEET_INDEX).ID = INTERMEET_INDEX;
        MN_DATA_temp.VS_NODE(MN_INDEX).SOCIAL_CONTANT(INTERMEET_INDEX).MEETING_TIME = [];
        %TODO:待补充
    end
end


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
            
            %如果节点之间的距离小于定义的距离，那么定义为两个节点相遇
            %然后检查他们是否已经相遇，如果没有，那么修改两个节点之间的相遇记录
            if(inter_distance < input_settings.MN_R)
                %如果index1节点从未与index2节点相遇，然后将其添加到相遇数组中，记录相遇时间
                %否则只记录相遇时间
                if( isempty( find( MN_DATA_temp.VS_NODE(MN_INDEX_1).INTER_MEET == MN_INDEX_2, 1)))
                    %讲节点2加入相遇数组
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).INTER_MEET(end + 1) = MN_INDEX_2;
                    %记录时间，节点1的社交关系中，节点2的位置，相遇时间记录为节点1当前的时间
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(end + 1) = ...
                    MN_DATA_temp.VS_NODE(MN_INDEX_1).V_TIME(time);
                else
                    %倘若这次相遇时间在上次相遇的 2 分钟之后（待修改）
                    if ( time * 60 == MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(end) )
                        MN_DATA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).MEETING_TIME(end + 1) = ...
                        MN_DATA_temp.VS_NODE(MN_INDEX_1).V_TIME(time);
                    end
                end

                %对 节点2做同样的操作
                if( isempty( find( MN_DATA_temp.VS_NODE(MN_INDEX_2).INTER_MEET == MN_INDEX_1, 1)))
                    %讲节点2加入相遇数组
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).INTER_MEET(end + 1) = MN_INDEX_1;
                    %记录时间，节点1的社交关系中，节点2的位置，相遇时间记录为节点1当前的时间
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEETING_TIME(end + 1) = ...
                    MN_DATA_temp.VS_NODE(MN_INDEX_2).V_TIME(time);
                else
                    %倘若这次相遇时间在之后（待修改）
                    if ( time * 60 == MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEETING_TIME(end) )
                        MN_DATA_temp.VS_NODE(MN_INDEX_2).SOCIAL_CONTANT(MN_INDEX_1).MEETING_TIME(end + 1) = ...
                        MN_DATA_temp.VS_NODE(MN_INDEX_2).V_TIME(time);
                    end
                end
            end

        end %对所有节点2结束
    end %对所有节点1结束
end

MN_DATA = MN_DATA_temp;

end
%计算社交活跃度