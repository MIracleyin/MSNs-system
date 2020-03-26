%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_RPM.m %%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to simulate the mobile of MNs%
%此版本为结束主任务后直接回家

function [MN_DATA AREA_DATA input_settings] = MSN_RPM1(input_settings)
%mobile_RPM - Description
%
% Syntax: [MN_DATA input_setting] = mobile_RPM(input_setting)
%
% Long description
% Design from Role playing Mbility Model for Mobile Social Networks
clear MN_DATA_temp;
%clear C_DATA_temp;

%The Role Playing Mobility Model.
global MN_DATA_temp; %global MN_DATA Index.
%global cCenter; %global cCenter for all algorithm
%global C_DATA_temp; %global C_DATA Index.

% Used to set messages IDs, instead of using fixed ID length, use ID length
% according to simulation time
%digit_count = numel(num2str(input_settings.sTIME/... %当前值为5
%                            input_settings.MN_T_interval)); %根据总的仿真时间与信息生成间隔计算信息
                            
% community center
%% Initializing Community Area
b_x = [(input_settings.sMAP_X(1) + input_settings.cAREA_X(2)/2),...
       (input_settings.sMAP_X(2) - input_settings.cAREA_X(2)/2)];
b_y = [(input_settings.sMAP_Y(1) + input_settings.cAREA_Y(2)/2),...
       (input_settings.sMAP_Y(2) - input_settings.cAREA_Y(2)/2)];

cCenter_x = 0;
cCenter_y = 0;
cCenter_x = b_x(1) + (b_x(2)-b_x(1)) * rand(input_settings.cAREA_N,1);
cCenter_y = b_x(1) + (b_x(2)-b_x(1)) * rand(input_settings.cAREA_N,1);
cCenter = [cCenter_x cCenter_y];

%TODO:message deliver parts.

%Initializing MN_DATA Values   
for MN_INDEX = 1:input_settings.MN_N/50
       %random 1 - cAREA_N
       %生成节点的家、节点在地图上的绝对位置
       %节点随机出生的家
       MN_DATA_temp.VS_NODE(MN_INDEX).HOME = unidrnd(input_settings.cAREA_N); 
       %标记家的坐标
       MN_DATA_temp.VS_NODE(MN_INDEX).HOME_LOC = ...
       [cCenter_x(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) cCenter_y(MN_DATA_temp.VS_NODE(MN_INDEX).HOME)];
       %生成出生点x坐标
       MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION = ... 
       unifrnd(cCenter_x(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) - input_settings.cAREA_X(2)/2,...
               cCenter_x(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) + input_settings.cAREA_X(2)/2);
       %生成出生点y坐标
       MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION = ... 
       unifrnd(cCenter_y(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) - input_settings.cAREA_Y(2)/2,...
               cCenter_y(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) + input_settings.cAREA_Y(2)/2);
       
       %节点时间坐标
       MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME = 0; 
      
       %节点的主要任务1.携带随机信息2.7-9点间随机从家出发到主任务点3.16-18点间随机离开主任务点
       %完成主任务中的2./3.

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %生成节点主任务地点
       %主任务地点不能为家
       MN_DATA_temp.VS_NODE(MN_INDEX).P_community = MN_DATA_temp.VS_NODE(MN_INDEX).HOME;%将任务地点设为家
       while MN_DATA_temp.VS_NODE(MN_INDEX).P_community == MN_DATA_temp.VS_NODE(MN_INDEX).HOME%当任务地点为家时，循环成立
              MN_DATA_temp.VS_NODE(MN_INDEX).P_community = unidrnd(input_settings.cAREA_N);%任务随机生成，当随机任务不为家时，循环结束
       end
       %主任务坐标
       MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC = ...
       [cCenter_x(MN_DATA_temp.VS_NODE(MN_INDEX).P_community) cCenter_y(MN_DATA_temp.VS_NODE(MN_INDEX).P_community)];
       % 主任务地点可以为家
       %MN_DATA_temp.VS_NODE(MN_INDEX).P_community = unidrnd(input_settings.cAREA_N);

       %生成节点主任务开始时间 
       
       %节点随机生成到达主任务通信区时间
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_arrive = input_settings.MN_T_arrive(1) +... 
       unidrnd(input_settings.MN_T_arrive(2) - input_settings.MN_T_arrive(1));
       %节点在到达以主任务通信区后，随机暂停[30-180]分钟
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_work = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_arrive +...
       input_settings.MN_T_pause(1) + ...
       unidrnd(input_settings.MN_T_pause(2) - input_settings.MN_T_pause(1));
       %生成节点主任务结束时间
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_depart = input_settings.MN_T_depart(1) +... 
       unidrnd(input_settings.MN_T_depart(2) - input_settings.MN_T_depart(1));

       %计算生成节点到目标通信区的直线路径
       MN_DATA_temp.VS_NODE(MN_INDEX).P_L_trace = ...
       sqrt(( cCenter_x( MN_DATA_temp.VS_NODE(MN_INDEX).P_community ) - ...
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end) ).^2 + ...
            ( cCenter_y( MN_DATA_temp.VS_NODE(MN_INDEX).P_community ) - ...
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end) ).^2 );
       %在通信区之间，使用中间速度[1 20]
       MN_DATA_temp.VS_NODE(MN_INDEX).P_V_trace = input_settings.MN_V_corss(1) + ...
       unidrnd(input_settings.MN_V_corss(2) - input_settings.MN_V_corss(1));


       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %主任务路上花掉的时间，使用向下取整的办法
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_trace = ...
       floor(MN_DATA_temp.VS_NODE(MN_INDEX).P_L_trace / MN_DATA_temp.VS_NODE(MN_INDEX).P_V_trace);
       %移动节点出发前往主任务的时间
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_start = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_arrive - MN_DATA_temp.VS_NODE(MN_INDEX).P_T_trace;

       %移动节点开始工作以后的初角度
       MN_DATA_temp.VS_NODE(MN_INDEX).MVOING_DIRECTION = unifrnd(input_settings.MN_A_inside(1),input_settings.MN_A_inside(2))
       %节点是否移动
       %MN_DATA_temp.VS_NODE(MN_INDEX).IS_MOVING = rand(1,1) > input_settings.MN_P_move;

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%MOVE1 节点在家中等待出发%%%%%%%%%%%%%%%%%%
       %直接等待
       %MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = ...
       %floor(MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end) + 0); %X方向无移动
       %MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = ...
       %floor(MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end) + 0); %Y方向无移动
       
       
       time_go = 60; %等待开始时间
       time_step = input_settings.MN_T_interval;
       time_end = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_start;%等待结束

       for time = time_go : time_step : time_end
              %设置时间坐标，每次更新
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end) + time_step;
              %记录上一次节点x坐标
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end) + 0; %原地等待
              %记录上一次节点y坐标
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end) + 0; %原地等待
       end
       %TODO:时间格式化输出，待完成
       %disp(['节点出门，时间为：',time_end]);
       %观察
       %disp(1)
       %MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end)
       %MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end)
       %}

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%MOVE2 节点出发到达目标位置%%%%%%%%%%%%%%%%%
       %%直接移动至目标点
       %{
       MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(1); %节点X直接移动至目标位置X
       MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(2); %节点Y直接移动至目标位置Y
       %}
       
       time_go = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_start; %节点出发
       time_step = input_settings.MN_T_interval;
       time_end = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_arrive;%节点到达目标
       
       temp_angle_cos = ... %计算节点x方向增量
       (MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(1) - MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end))/...
       MN_DATA_temp.VS_NODE(MN_INDEX).P_L_trace;

       temp_angle_sin = ... %计算节点y方向增量
       (MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(2) - MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end))/...
       MN_DATA_temp.VS_NODE(MN_INDEX).P_L_trace;
       
       
       for time = time_go : time_step : time_end %修改步长，使之不至于过头
              %设置一时间坐标，每次更新
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end) + time_step;
              %更新上一次节点x坐标，每次更新，x方向增量 * x方向距离
              %为防止越界
              new_x = MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end) + ...
              temp_angle_cos * MN_DATA_temp.VS_NODE(MN_INDEX).P_V_trace * time_step;
              if (new_x > 1000) %如果新x坐标大于
                     new_x = 1000;
              elseif (new_x < 0)
                     new_x = 0;
              end
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = new_x

              %更新上一次节点y坐标，每次更新，y方向增量 * y方向距离
              new_y = MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end) + ...
              temp_angle_sin * MN_DATA_temp.VS_NODE(MN_INDEX).P_V_trace * time_step;
              if (new_y > 1000) %如果新x坐标大于
                     new_y = 1000;
              elseif (new_y < 0)
                     new_y = 0;
              end
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = new_y
       end
       
       %%节点到目标通信区中心
       MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end) + time_step;
       MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(1); %节点到达目标X
       MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(2); %节点到达目标Y
       %}
       %%节点随机停顿一段时间
       
       time_go = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_arrive; %到达时间，然后暂停随机[30 180]的一个时间
       time_step = input_settings.MN_T_interval;
       time_end = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_work;%等待结束

       for time = time_go : time_step : time_end
              %设置时间坐标，每次更新
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end) + time_step;
              %记录上一次节点x坐标
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end) + 0; %原地等待
              %记录上一次节点y坐标
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end) + 0; %原地等待
       end
       

       %MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end)
       %MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end)

       %移动节点开始主任务
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%%MOVE3 随机漫步%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %移动节点在主任务通信区内做随机漫步运动
       %时间间隔为60s
       
       time_go = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_work; %随机漫步开始时间为到达时间
       time_step = input_settings.MN_T_interval;
       time_end = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_depart;%随机漫步结束时间

       %对某节点，取从主任务到达时间，到主任务结束时间
       for time = time_go : time_step : time_end
              %设置一时间坐标，每次更新
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end) + time_step;

              %记录上一次节点x坐标
              temp_x = MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end);
              %记录上一次节点y坐标
              temp_y = MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end);
              %当节点在通信区内时，使用中间速度
              temp_v = input_settings.MN_V_inside;
              %运动距离
              temp_distance = temp_v * time_step;
              %每次随机生成一个运动角度
              temp_angle = MN_DATA_temp.VS_NODE(MN_INDEX).MVOING_DIRECTION(end);
              %每次随机确定下一步时间间隔是否移动
              temp_is_movie = rand(1,1) > input_settings.MN_P_move;

              if( temp_is_movie == 1 )
                     %计算x,y方向位移
                     new_x = temp_x + temp_distance * cosd(temp_angle);
                     new_y = temp_y + temp_distance * sind(temp_angle);

                     flag_mobility_was_outside = false;

                     %当x位置超出通信区x方向最大值
                     %如果新的位置，在通信区x方向之外
                     if(new_x > MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(1) + input_settings.cAREA_X(2)/2)
                            flag_mobility_was_outside = true;
                            new_angle = 180 - temp_angle;
                            new_x = MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(1) + input_settings.cAREA_X(2)/2;
                            new_y = temp_y + diff([temp_x new_x]) * tand(temp_angle);
                     end

                     %%当x位置低于通信区x方向最小值
                     %如果新的位置，在通信区x方向之外
                     if(new_x < MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(1) - input_settings.cAREA_X(2)/2)
                            flag_mobility_was_outside = true;
                            new_angle = 180 - temp_angle;
                            new_x = MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(1) - input_settings.cAREA_X(2)/2;
                            new_y = temp_y + diff([temp_x new_x]) * tand(temp_angle);
                     end

                     %%当y位置低于通信区y方向最大值
                     %如果新的位置，在通信区y方向之外
                     if(new_y > MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(2) + input_settings.cAREA_Y(2)/2)
                            flag_mobility_was_outside = true;
                            new_angle = - temp_angle;
                            new_y = MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(2) + input_settings.cAREA_Y(2)/2;
                            new_x = temp_x + diff([temp_y new_y]) / tand(temp_angle);
                     end
                     
                     %%当y位置低于通信区y方向最小值
                     %如果新的位置，在通信区y方向之外
                     if(new_y < MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(2) - input_settings.cAREA_Y(2)/2)
                            flag_mobility_was_outside = true;
                            new_angle = - temp_angle;
                            new_y = MN_DATA_temp.VS_NODE(MN_INDEX).P_community_LOC(2) - input_settings.cAREA_Y(2)/2;
                            new_x = temp_x + diff([temp_y new_y]) / tand(temp_angle);
                     end

                     if(flag_mobility_was_outside)
                            MN_DATA_temp.VS_NODE(MN_INDEX).MVOING_DIRECTION(end + 1) = new_angle;
                     end

                     %将新计算的x、y赋值
                     MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = new_x;
                     MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = new_y;
              else
                     MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = temp_x;
                     MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = temp_y; 
              end
              
       end
       %}
       

       %移动节点回家
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%MOVE4 WPM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %移动节点由最后位置回到出生点
       %计算移动节点最后位置到出生点的距离
       
       MN_DATA_temp.VS_NODE(MN_INDEX).H_L_trace = ... %回家距离总是等于移动节点末位置和初位置
       sqrt( (MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(1) - ...   %x末位置
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end) ).^2 + ...%x初位置
             (MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(1) - ...   %y末位置
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end) ).^2 );   %y初位置
       
       MN_DATA_temp.VS_NODE(MN_INDEX).H_V_trace = input_settings.MN_V_corss(1) + ... %生成中间速度
       unidrnd(input_settings.MN_V_corss(2) - input_settings.MN_V_corss(1));
       MN_DATA_temp.VS_NODE(MN_INDEX).H_T_trace = ... %回家的时间为回家距离除回家速度向下取整
       floor(MN_DATA_temp.VS_NODE(MN_INDEX).H_L_trace / MN_DATA_temp.VS_NODE(MN_INDEX).H_V_trace);
       MN_DATA_temp.VS_NODE(MN_INDEX).H_T_arrive = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_depart + ...
       MN_DATA_temp.VS_NODE(MN_INDEX).H_T_trace;
       %如果回家，在子任务时间标记的末尾加上节点回家的时间

       time_go = MN_DATA_temp.VS_NODE(MN_INDEX).P_T_depart; %主任务结束后，回家
       time_step = input_settings.MN_T_interval;
       time_end = MN_DATA_temp.VS_NODE(MN_INDEX).H_T_arrive; %到家的时间

       temp_angle_cos = ... %计算节点x方向增量
       (MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(1) - MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end))/...
       MN_DATA_temp.VS_NODE(MN_INDEX).H_L_trace;

       temp_angle_sin = ... %计算节点y方向增量
       (MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(1) - MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end))/...
       MN_DATA_temp.VS_NODE(MN_INDEX).H_L_trace;

       for time = time_go : time_step : time_end %修改步长，使之不至于过头
              %设置一时间坐标，每次更新
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end) + time_step;
              %更新上一次节点x坐标，每次更新，x方向增量 * x方向距离
              %为防止越界
              new_x = MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end) + ...
              temp_angle_cos * MN_DATA_temp.VS_NODE(MN_INDEX).P_V_trace * time_step;
              if (new_x > 1000) %如果新x坐标大于
                     new_x = 1000;
              elseif (new_x < 0)
                     new_x = 0;
              end
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = new_x;

              %更新上一次节点y坐标，每次更新，y方向增量 * y方向距离
              new_y = MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end) + ...
              temp_angle_sin * MN_DATA_temp.VS_NODE(MN_INDEX).P_V_trace * time_step;
              if (new_y > 1000) %如果新x坐标大于
                     new_y = 1000;
              elseif (new_y < 0)
                     new_y = 0;
              end
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = new_y;
       end
       
       %%节点到目标通信区中心
       MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end) + time_step;
       MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(1); %节点到达目标X
       MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(1); %节点到达目标Y
       %}

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%MOVE4 回到出生地点等待 %%%%%%%%%%%%%%%%%%%%%%%
       %移动节点由最后位置回到出生点
       %计算移动节点最后位置到出生点的距离
       % time_end = P_T_depart + H_T_trace; %回家时间+路上花掉的时间
       
       time_go = time_end; 
       time_step = input_settings.MN_T_interval;
       time_end = input_settings.sTIME;%随机漫步结束时间

       for time = time_go : time_step : time_end
              %设置一时间坐标，每次更新
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end) + time_step;
              %记录上一次节点x坐标
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end) + 0; %原地等待
              %记录上一次节点y坐标
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end + 1) = ...
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end) + 0; %原地等待
       end
       
end 

%{
       %TODO:支线任务待完成

       %%set first message ID, FROM, TO, TTL, Number of forwards,
       %%Creation time and reception time
       %MESSAGE FROM
       %生成信息ID,ex:45号节点，4500000
       MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(1).ID = num2str( MN_INDEX * (10^digit_count) );
       %记录信息从哪里来，信息刚生成时，为原节点
       MN_DATA_temp.VS_NODE(MN_INDEX).message(1).FROM = MN_INDEX;

       %%MESSAGE TO
       %如果随机的目标不是节点本身，那么将随机的目标设为信息传递的目标对象
       message_receipt_while = true;
       while message_receipt_while
              recept_index_temp = randi([1 input_settings.MN_N], [1 1]);
              if recept_index_temp ~= MN_INDEX
                     MN_DATA_temp.VS_NODE(MN_INDEX).message(1).TO = recept_index_temp;
                     message_receipt_while = false;
              end
       end
       
       %当从某节点发来信息时，会加入到此目录
       MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(1).NUMBER_OF_FORWARDS = [];
       %MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(1).TTL = 0;
       %信息产生的时间(存疑)
       MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(1).CRATION_TIME = 0;
       %信息接收的时间
       MN_DATA_temp.VS_NODE(MN_INDEX).MESSAGE(1).RECEPTION_TIME = 0;

       %为每一个节点设置信息接收空间
       MN_DATA_temp.VS_NODE(MN_INDEX).RECEIVED_MESSAGE = ...
              struct(...
              'ID', {}, ...
              'FROM', {}, ...
              'TO', {}, ...
              'NUMBER_OF_FORWARDS', {}, ...
              'TTL', {}, ...
              'CREATION_TIME', {}, ...
              'RECEIPTION_TIME', {});
       
       % 初始化计数，接受，缓存信息
       MN_DATA_temp.MESSAGES_COUNT = 1 * input_settings.MN_N;
       MN_DATA_temp.RECEIVED_COUNT = 0;
       MN_DATA_temp.BUFFERED_COUNT = 0;

       %为每一个节点设置信息缓存空间
       MN_DATA_temp.VS_NODE(MN_INDEX).BUFFER = ...
              struct(...
              'ID', {}, ...
              'FROM', {}, ...
              'TO', {}, ...
              'NUMBER_OF_FORWARDS', {}, ...
              'TTL', {}, ...
              'CREATION_TIME', {}, ...
              'RECEIPTION_TIME', {});
%}

%返回节点数据
MN_DATA = MN_DATA_temp;
AREA_DATA = cCenter;
end
       


       
              

