%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_init.m %%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to initialize the area for MNs%

%% randomly generate community area
% community generate boundry
b_x = [cLength/2, sLength - cLength/2];
b_y = [cWidth/2, sWidth - cWidth/2];

% community center
cCenter_x = b_x(1) + (b_x(2)-b_x(1)) * rand(N_communities,1);
cCenter_y = b_x(1) + (b_x(2)-b_x(1)) * rand(N_communities,1);
cCenter = [cCenter_x, cCenter_y];
% community bounter
cCenter_up = [cCenter(:,1) + cLength/2,cCenter(:,2)];
cCenter_upline = [cCenter_up - cLength/2, cCenter_up + cLength/2];
cCenter_down = [cCenter(:,1) - cLength/2,cCenter(:,2)];
cCenter_left = [cCenter(:,1),cCenter(:,2) - cWidth/2];
cCenter_right = [cCenter(:,1),cCenter(:,2) + cWidth/2];


