%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_init.m %%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to simulate the MSN system %%%
% from Pitiphol Pholpabu and Lie-Liant Yang .%%%%%%%
% This system depends on RPM model. %%%%%%%%%%%%%%%%
% The proposed model can intergate people's roles, %
% daily activies and occasional acitivies. %%%%%%%%%
% The part of routing protocols will be later. %%%%%

clc;
clear all;
close all;
close all hidden;

%% Simulation Setup

% Simulation area
Length = 1000; %(m)
Width = 1000; %(m)