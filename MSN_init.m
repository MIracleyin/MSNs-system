%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_init.m %%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to initialize the MSN system %

%% Simulation Setup

% Simulation area size Value = 1000*1000 Unit m^2
sLength = 1000; %(m) 
sWidth = 1000; %(m)

% Community area size Value = 100*100 Unit m^2 
cLength = 100; %(m)
cWidth = 100; %(m)

% Communities Settings
N_communities = 15; %(communities) number of communities

% Mobile Nodes Settings
N_nodes = 10; %(MNs) number of MNs

% A speed is chosen betweet V_max and V_min uniformly,
% which represents the speed of its cross-community.
V_max = 10; %(m/s) MN's maximum speed
V_min = 1; %(m/s) MN's minumum speed

% A speed is V_walk, which represents 
% the speed of its inside-community.
V_walk = 1.4; %(m/s) MN's walk speed

P_home = 0.5; %(-) MN's probabity of go home
P_move = 0.5; %移动节点随机漫步运动的可能性
N_act = 2; %(activities) MN's maximum activities
L_prefer = [1 10]; %the occurrence probabilities reflected by the preference

r = 30; %(m) MN check their neigobors within a range of 30

% Timing Settings
D = 1; %(days)
T = 24 * 60 * 60 * D; %(s)
T_arrive = [7 9] * 60 * 60; %(s) 7-9AM 7:00-9:00
T_depart = [16 18] * 60 * 60; %(s) 4-6PM 16:00-18:00
T_pause = [30 180] * 60; %(s) 30-180min for pause
T_interval = 60; %(s) an interval for update
M_interval = 120;

% Add all system settings into struct intput_settings
%'MN_L_prefer',L_prefer%the occurrence probabilities reflected by the preference
%TODO:L_prefer
input_settings = struct('sTIME',T,... %Time range of Simulation仿真总时长
                        'sMAP_X',[0 sLength],... %仿真地图X长度
                        'sMAP_Y',[0 sWidth],... %Size of Simulation Map %仿真地图Y长度
                        'cAREA_X',[0 cLength],... %
                        'cAREA_Y',[0 cWidth],...%Size of Community Area
                        'cAREA_N',N_communities,...%Number of Community Areas
                        'MN_N',N_nodes,...%Number of MNs
                        'MN_N_act',N_act,...%Number of MNs' acts
                        'MN_V_corss',[V_min V_max],...%Speed of MNs' Cross-Community
                        'MN_V_inside',V_walk,...%Speed of MNs' Inside-Community
                        'MN_A_inside',[-180,180],...
                        'MN_P_home',P_home,...%Probabity of MNs' go home
                        'MN_P_move',P_move,...%移动节点随机漫步的移动概率
                        'MN_R',r,...%MN check their neigobors within a range of 30
                        'MN_T_arrive',T_arrive,...
                        'MN_T_depart',T_depart,...
                        'MN_T_pause',T_pause,...
                        'MN_T_interval',T_interval,...
                        'MSG_T_interval',M_interval);

