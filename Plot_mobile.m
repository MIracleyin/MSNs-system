%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Plot_Area.m %%%%%%%%%%%%%%%%%%%%%%%
% This script is used to visualize the area%%%%%%%%%



scatter(AREA_DATA.cCenter_x,AREA_DATA.cCenter_y);

for i = 1:15
    x = [AREA_DATA.cCenter_x(i)-50,AREA_DATA.cCenter_x(i)-50,AREA_DATA.cCenter_x(i) + 50,AREA_DATA.cCenter_x(i)+50,AREA_DATA.cCenter_x(i)-50 ];
    y = [AREA_DATA.cCenter_y(i)-50,AREA_DATA.cCenter_y(i)+50,AREA_DATA.cCenter_y(i) + 50,AREA_DATA.cCenter_y(i)-50,AREA_DATA.cCenter_y(i)-50];

    plot(x, y, 'b');
    hold on;
end

for i=1:10
    for j = 1 : 60:7200
        x(end+1)= [MN_DATA.VS_NODE(i).X_POSITION(j)];
        y(end+1) = [MN_DATA.VS_NODE(i).Y_POSITION(j)];
    end
    plot(x,y,'k');
    hold on;
end

grid on
box on
xlim([0,sLength]);
xticks(0:sLength/5:sLength);
ylim([0,sWidth]);
yticks(0:sWidth/5:sWidth);