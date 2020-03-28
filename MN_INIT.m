%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MN_init.m %%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to initialize the MN DATA %%%%

function [MN_DATA_INIT input_settings] = MN_INTI(input_settings, AREA_DATA)

    clear MN_DATA_INIT_temp;

    global MN_DATA_INIT_temp;

    %cCenter_x = AREA_DATA.cCenter_x;
    %cCenter_y = AREA_DATA.cCenter_y;
    %cCenter = AREA_DATA.cCenter;

    %用于初始化节点出生位置
    for MN_INDEX = 1:input_settings.MN_N
        %节点随机出生的家
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).HOME = unidrnd(input_settings.cAREA_N);
        %生成节点主任务地点
        %主任务地点不能为家
        MN_DATA_INIT_temp.VS_NODE(MN_INDEX).P_community = MN_DATA_INIT_temp.VS_NODE(MN_INDEX).HOME;%将任务地点设为家
        while MN_DATA_INIT_temp.VS_NODE(MN_INDEX).P_community == MN_DATA_INIT_temp.VS_NODE(MN_INDEX).HOME%当任务地点为家时，循环成立
                MN_DATA_INIT_temp.VS_NODE(MN_INDEX).P_community = unidrnd(input_settings.cAREA_N);%任务随机生成，当随机任务不为家时，循环结束
        end
    end

    MN_DATA_INIT = MN_DATA_INIT_temp;
end
    
