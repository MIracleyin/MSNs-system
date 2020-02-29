%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% MSN_RPM.m %%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to simulate the mobile of MNs%

function [MN_DATA input_settings] = MSN_RPM(input_settings)
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
global cCenter; %global cCenter for all algorithm
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
cCenter = [cCenter_x, cCenter_y];


%TODO:message deliver parts.

%Initializing MN_DATA Values   
for MN_INDEX = 1:input_settings.MN_N
       %random 1 - cAREA_N
       %生成节点的家、节点在地图上的绝对位置
       MN_DATA_temp.VS_NODE(MN_INDEX).HOME = unidrnd(input_settings.cAREA_N); %节点随机出生的家
       MN_DATA_temp.VS_NODE(MN_INDEX).HOME_LOC = cCenter(MN_DATA_temp.VS_NODE(MN_INDEX).HOME); %标记家的坐标
       MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION = ... %生成出生点x坐标
       unifrnd(cCenter_x(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) - input_settings.cAREA_X(2)/2,...
               cCenter_x(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) + input_settings.cAREA_X(2)/2);
       %MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION = ... %生成出生点x坐标
       %cCenter_x(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) - input_settings.cAREA_X(2)/2 +...
       %rand(1) * input_settings.cAREA_X(2);
       MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION = ... %生成出生点y坐标
       unifrnd(cCenter_y(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) - input_settings.cAREA_Y(2)/2,...
               cCenter_y(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) + input_settings.cAREA_Y(2)/2);
       %MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION = ... %生成出生点y坐标
       %cCenter_y(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) - input_settings.cAREA_Y(2)/2 +...
       %rand(1) * input_settings.cAREA_Y(2);
       
       %节点的主要任务1.携带随机信息2.7-9点间随机从家出发到主任务点3.16-18点间随机离开主任务点
       %完成主任务中的2./3.
       %生成节点主任务开始时间
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_arrive = input_settings.MN_T_arrive(1) +... 
       unidrnd(input_settings.MN_T_arrive(2) - input_settings.MN_T_arrive(1));
       %生成节点主任务结束时间
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_depart = input_settings.MN_T_depart(1) +... 
       unidrnd(input_settings.MN_T_depart(2) - input_settings.MN_T_depart(1));
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %生成节点主任务地点
       MN_DATA_temp.VS_NODE(MN_INDEX).P_community = unidrnd(input_settings.cAREA_N);
       %计算生成节点到目标通信区的直线路径
       MN_DATA_temp.VS_NODE(MN_INDEX).P_trace_long = ...
       sqrt(( cCenter_x( MN_DATA_temp.VS_NODE(MN_INDEX).P_community ) - ...
              MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION ).^2 + ...
            ( cCenter_y( MN_DATA_temp.VS_NODE(MN_INDEX).P_community ) - ...
              MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION ).^2 );
       %在通信区之间，使用中间速度[1 20]
       MN_DATA_temp.VS_NODE(MN_INDEX).P_trace_v = ...
       unidrnd(input_settings.MN_V_corss(2) - input_settings.MN_V_corss(1));
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %主任务路上花掉的时间，使用向下取整的办法
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_trace = ...
       floor(MN_DATA_temp.VS_NODE(MN_INDEX).P_trace_long / MN_DATA_temp.VS_NODE(MN_INDEX).P_trace_v);
       %移动节点出发前往主任务的时间
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_start = ...
       MN_DATA_temp.VS_NODE(MN_INDEX).P_T_arrive - MN_DATA_temp.VS_NODE(MN_INDEX).P_T_trace;
       %移动节点开始主任务
       %移动节点在主任务通信区内做随机漫步运动
       %时间间隔为60s
       time_step = input_settings.MN_T_interval;
       MN_DATA_temp.VS_NODE(MN_INDEX).MOVING_DIRECTION = ... %随机漫步的初始角度
       rand(1) * 
MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION = ... %生成出生点x坐标
       cCenter_x(MN_DATA_temp.VS_NODE(MN_INDEX).HOME) - input_settings.cAREA_X(2)/2 +...
       rand(1) * input_settings.cAREA_X(2);
       %对某节点，取从主任务到达时间，到主任务结束时间
       for time = MN_T_arrive : time_step : MN_T_depart
              MN_DATA_temp.VS_NODE(MN_INDEX).V_TIME(end + 1) = time;%设置一时间坐标，每次更新
              temp_x = MN_DATA_temp.VS_NODE(MN_INDEX).X_POSITION(end);%记录上一次节点x坐标
              temp_y = MN_DATA_temp.VS_NODE(MN_INDEX).Y_POSITION(end);%记录上一次节点y坐标
              %当节点在通信区内时，使用中间速度fang
              temp_v = input_settings.MN_V_inside;
       
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
end
       


       
              

