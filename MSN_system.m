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
MN_DATA = MSN_RPM2(input_settings,AREA_DATA,MN_DATA_INIT); 

%计算社交指标MN_DATA_SOCIAL为有社交属性的移动节点数据

MN_DATA_SOCIAL = MSN_CALCULATE(input_settings,MN_DATA);


%% Visualization
%Plot_Area;

%% Save system's variables
% Set destination folder

save('MSN_init_data');