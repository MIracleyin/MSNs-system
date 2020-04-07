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
%load('MSN_init_data');
%% Initialiaze simulations area and communities.

AREA_DATA = MSN_AREA(input_settings);

MN_DATA_INIT = MN_INIT(input_settings,AREA_DATA); %用于初始化移动节点的家与主任务，后续仿真中不改变该值

%% Simulate the mobile of MNs and record its data
%生成1天的数据用于计算节点社交指标
%节点位置数据无误

data_day = 10;
for DAY = 1 : data_day
    MN_DATA(DAY) = MSN_RPM2(input_settings,AREA_DATA,MN_DATA_INIT); 
end

for DAY = 1 : data_day
    MN_DATA_SOCIA(DAY) = MSN_CALCULATE_oneday(input_settings,MN_DATA(DAY));
end

MN_DATA_AVE = MSN_CALCULATE_ave(input_settings,MN_DATA_SOCIA,data_day);

%Plot_Area;

%% Save system's variables
% Set destination folder

save('MSN_init_data');