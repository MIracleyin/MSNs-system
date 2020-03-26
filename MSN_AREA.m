%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_AREA.m %%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to simulate the area of MSN%%%
%此函数生成地图，作为可视化、节点运动的输入

function [AREA_DATA] = MSN_AREA(input_settings)
%myFun - Description
%
% Syntax: [AREA_DATA] = MSN_AREA(input_settings)%
% Long description
    %% Initializing Community Area
    b_x = [(input_settings.sMAP_X(1) + input_settings.cAREA_X(2)/2),...
           (input_settings.sMAP_X(2) - input_settings.cAREA_X(2)/2)];
    b_y = [(input_settings.sMAP_Y(1) + input_settings.cAREA_Y(2)/2),...
           (input_settings.sMAP_Y(2) - input_settings.cAREA_Y(2)/2)];
    
    cCenter_x = 0;
    cCenter_y = 0;
    cCenter_x_temp = b_x(1) + (b_x(2)-b_x(1)) * rand(input_settings.cAREA_N,1);
    cCenter_y_temp = b_x(1) + (b_x(2)-b_x(1)) * rand(input_settings.cAREA_N,1);
    cCenter_temp = [cCenter_x_temp cCenter_y_temp];
    
    AREA_DATA.cCenter_x = cCenter_x_temp;
    AREA_DATA.cCenter_y = cCenter_y_temp;
    AREA_DATA.cCenter = cCenter_temp


end