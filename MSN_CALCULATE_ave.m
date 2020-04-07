%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_CALCULATE.m %%%%%%%%%%%%%%%%%%%%
% This script is used to calcualte the mobile of MNs%

function [MN_DATA_AVE] = MSN_CALCULATE_ave(input_settings,MN_DATA_SOCIA,DAY)
%myFun - Description
%
% Syntax: [MN_DATA] = MSN_CALCULATE_ave(input_settings,MN_DATA_SOCIA,DAY)
%
% Long description
% 首先将先前计算的数据取平均，其次计算其间接概率
clear MN_DATA_temp;

global MN_DATA_temp;

MN_DATA_temp = MN_DATA_SOCIA;



%取平均
%对节点1
for MN_INDEX_1 = 1 : input_settings.MN_N
    %节点1对节点2
    for MN_INDEX_2 = 1 : input_settings.MN_N
        %取一个值记录所有天之和
        DIRECT_PROBABLITY_sum = 0;
        %节点1对节点2的每一天求和
        for EVERY_DAY = 1 : DAY
            DIRECT_PROBABLITY_sum = DIRECT_PROBABLITY_sum + ...
            MN_DATA_temp(EVERY_DAY).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY;
        end
        for EVERY_DAY = 1 : DAY
            MN_DATA_temp(EVERY_DAY).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_SUM = DIRECT_PROBABLITY_sum;
            MN_DATA_temp(EVERY_DAY).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_AVE = DIRECT_PROBABLITY_sum/DAY;
        end
    end
end

%此变量用于保存平均后的数据，以及间接概率
MN_DATA_temp(DAY + 1) = MN_DATA_temp(DAY)
%记录间接概率，使用DIRECT_PROBABILITY_AVE计算
%HOP1 
for MN_INDEX_1 = 1 : input_settings.MN_N %源节点MN1
    for MN_INDEX_2 = 1:input_settings.MN_N %目标节点MN2
        MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_HOP1 = ...
        MN_DATA_temp(EVERY_DAY).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_AVE;
    end
end

%HOP2
for MN_INDEX_1 = 1 : input_settings.MN_N %源节点MN1
    for MN_INDEX_2 = 1:input_settings.MN_N %目标节点MN2
        for MN_INDEX_X = 1 : input_settings.MN_N 
            if (MN_INDEX_X ~= MN_INDEX_1) & (MN_INDEX_X ~= MN_INDEX_2) %选取一个除了节点1和节点2以外的节点
                %节点1到节点2二跳传递概率为 节点1直接传递给节点x的概率*节点x直接传给节点2的概率
                MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_HOP2 = ...
                MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_X).DIRECT_PROBABILITY_AVE * ...
                MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_X).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_AVE;
            else
                %待修改，可能有问题
                MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_HOP2 = 0;
            end
        end
    end
end

%HOP3
for MN_INDEX_1 = 1 : input_settings.MN_N
    for MN_INDEX_2 = 1 : input_settings.MN_N
        for MN_INDEX_X1 = 1 : input_settings.MN_N
            for MN_INDEX_X2 = 1 : input_settings.MN_N
                if (MN_INDEX_X1 ~= MN_INDEX_1) & (MN_INDEX_X1 ~= MN_INDEX_2) & (MN_INDEX_X2 ~= MN_INDEX_X1) & (MN_INDEX_X2 ~= MN_INDEX_2)
                    MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_HOP3 = ...
                    MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_X1).DIRECT_PROBABILITY_AVE * ...
                    MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_X1).SOCIAL_CONTANT(MN_INDEX_X2).DIRECT_PROBABILITY_AVE * ...
                    MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_X2).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_AVE;
                else
                    MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_HOP3 = 0;
                end
            end
        end
    end
end

%HOP4
%for MN_INDEX_1 = 1 : input_settings.MN_N
%    for MN_INDEX_2 = 1 : input_settings.MN_N
%        for MN_INDEX_X1 = 1 : input_settings.MN_N
%            for MN_INDEX_X2 = 1 : input_settings.MN_N
%                for MN_INDEX_X3 = 1 : input_settings.MN_N
%                    if (MN_INDEX_X1 ~= MN_INDEX_1) & (MN_INDEX_X1 ~= MN_INDEX_2) & (MN_INDEX_X2 ~= MN_INDEX_X1) & (MN_INDEX_X2 ~= MN_INDEX_2) & (MN_INDEX_X3 ~= MN_INDEX_X2) & (MN_INDEX_X3 ~= MN_INDEX_2)
%                        MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_HOP4 = ...
%                        MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_X1).DIRECT_PROBABILITY_AVE * ...
%                        MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_X1).SOCIAL_CONTANT(MN_INDEX_X2).DIRECT_PROBABILITY_AVE * ...
%                        MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_X2).SOCIAL_CONTANT(MN_INDEX_X3).DIRECT_PROBABILITY_AVE * ...
%                        MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_X3).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_AVE
%                    else
%                        MN_DATA_temp(DAY + 1).VS_NODE(MN_INDEX_1).SOCIAL_CONTANT(MN_INDEX_2).DIRECT_PROBABILITY_HOP4 = 0;
%                    end
%                end
%            end
%        end
%    end
%end

MN_DATA_AVE = MN_DATA_temp;
    
    
end