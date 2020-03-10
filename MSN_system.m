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
MSN_init;
%load('MSN_init_data');
%% Initialiaze simulations area and communities.
%AREA_init;

%% Simulate the mobile of MNs and record its data
test_1 = MSN_RPM(input_settings);

%% Visualization
%Plot_Area;

%% Save system's variables
% Set destination folder

save('MSN_init_data');