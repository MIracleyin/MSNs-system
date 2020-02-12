%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_init.m %%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to initialize the area for MNs%

%% randomly generate community area
% community generate boundry
b_x = [cLength/2, sLength - cLength/2];
b_y = [cWidth/2, sWidth - cWidth/2];

% community center
cCenter_x = 0,cCenter_y = 0;
cCenter_x = b_x(1) + (b_x(2)-b_x(1)) * rand(N_communities,1);
cCenter_y = b_x(1) + (b_x(2)-b_x(1)) * rand(N_communities,1);
cCenter = [cCenter_x, cCenter_y];

% set mininum distanc for upgate
% TODO:
%{
cCenter = zeros(N_communities, 2); %建立一个15*2的矩阵
cDistance = 0;%设置一个参数存通信区间中点的距离
cMinimum = 50;%假设生成距离不小于50
cBorn = 1;%生成数标记

while cBorn == N_communities
    cCenter_x = b_x(1) + (b_x(2)-b_x(1)) * rand(1,1);
    cCenter_y = b_x(1) + (b_x(2)-b_x(1)) * rand(1,1);
    tempDistance = 0;
    for n = 1:N_communities
        tempDistance(end + 1) = ...
        sqrt((cCenter(n,1)-cCenter_x)^2 + (cCenter(n,2) - cCenter_y)^2);
    end
    cDistance = min(tempDistance)
    cDistance
    if cDistance > cMinimum
        cCenter(cBorn,1) = cCenter_x;
        cCenter(cBorn,2) = cCenter_y;
        cBorn = cBorn + 1;
    end
end
%}




