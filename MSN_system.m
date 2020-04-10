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

MN_DATA_INIT = MN_INIT(input_settings,AREA_DATA); %用于初始化移动节点的家与主任务，后续仿真中不改变该值

%% Simulate the mobile of MNs and record its data
%生成1天的数据用于计算节点社交指标
%节点位置数据无误

%计算15天移动状态，前十天用于生成节点位置数据等，后5天基于前十天数据得出的路由表路由
s_data_day = 15;
wait_bar = waitbar(0 , 'Simulate Movie');
set(wait_bar, 'name', 'Simulate Moving...');
wb = 15/s_data_day;
for DAY = 1 : s_data_day
    MN_DATA(DAY) = MSN_RPM2(input_settings,AREA_DATA,MN_DATA_INIT); 
    str_bar = ['NO.' num2str(wb) ' Simulate Day'];
    waitbar(wb/15, wait_bar, str_bar);
    wb = wb + 15/s_data_day;
end
close(wait_bar);

%前十天综合数据
cal_data_day = 10;
wait_bar = waitbar(0 , 'Calculate Data');
set(wait_bar, 'name', 'Calculating...');
wb = 10/cal_data_day;
for DAY = 1 : cal_data_day
    MN_DATA_SOCIA(DAY) = MSN_CALCULATE_oneday(input_settings,MN_DATA(DAY));
    str_bar = ['NO.' num2str(wb) ' Day Calculating...'];
    waitbar(wb/10, wait_bar, str_bar);
    wb = wb + 10/cal_data_day;
end
close(wait_bar);

%得出路由表，保存在第cal_data_day + 1 = 11处
MN_DATA_AVE = MSN_CALCULATE_ave(input_settings,MN_DATA_SOCIA,cal_data_day);

%路由信息
%protocol = 'SCPR';
%[MN_DATA_ROUTING Report]= MSN_ROUTING(MN_DATA, MN_DATA_AVE(cal_data_day + 1), input_settings, protocol);

%结论

%% Save system's variables
% Set destination folder

save('MSN_init_data');