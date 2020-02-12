%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_RPM.m %%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to simulate the mobile of MNs%

%% MNs born location
%home choice
MNhome = unidrnd(15);
MNborn_x = (cCenter_x(MNhome) - cLength/2) + cLength * rand(1);
MNborn_y = (cCenter_y(MNhome) - cWidth/2) + cWidth * rand(1);
MNborn_loc = [MNborn_x,MNborn_y]
