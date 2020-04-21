%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_system.m %%%%%%%%%%%%%%%%%%%%%%
% This script is used to simulate the MSN system %%%
% from Pitiphol Pholpabu and Lie-Liant Yang .%%%%%%%
% This system depends on RPM model. %%%%%%%%%%%%%%%%
% The proposed model can intergate people's roles, %
% daily activies and occasional acitivies. %%%%%%%%%
% The part of routing protocols will be later. %%%%%

%clc;
%clear all;
%close all;
%close all hidden;

%% Initialiaze parameters used for simulations.
MSN_INIT;
%% Initialiaze simulations area and communities.

AREA_DATA = MSN_AREA(input_settings);

MN_DATA_INIT = MN_INIT(input_settings,15); %用于初始化移动节点的家与主任务，后续仿真中不改变该值

%% Simulate the mobile of MNs and record its data
%生成1天的数据用于计算节点社交指标
%节点位置数据无误
%protocol: SCPR、Prophet、SimBet、Epidemic、NULL
                %para:仿真初始化, 区域设置, 节点初始化, 仿真总时长
MN_DATA = MSN_RPM3(input_settings,AREA_DATA,MN_DATA_INIT,15); 

%路由表                             %para:仿真初始化,节点数据,路由表时长,ageing(只有scpr需要,其余随意赋值),路由协议
                                                                                                        %路由协议与路由结果相匹配，Epidemic使用NULL
MN_DATA_SOCIA = MSN_CALCULATE4(input_settings,MN_DATA,10,1.5,'SimBet'); %null协议无需计算HOP 使用2减少计算  

% 路由结果        数据结果          %para:仿真初始化     节点数据  路由表数据     路由协议  仿真时长 与初始化，移动模型相同 
%[MN_DATA_ROUTING, Report] = MSN_ROUTING(input_settings, MN_DATA, MN_DATA_SOCIA, 'SimBet', 15);
