%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Plot_Area.m %%%%%%%%%%%%%%%%%%%%%%%
% This script is used to visualize the area%%%%%%%%%

for n = 1:N_communities
    %scatter(cCenter(n,1),cCenter(n,2))
    %Length
    line([cCenter(n,1)-cLength/2,cCenter(n,1)+cLength/2],[cCenter(n,2)+cWidth/2,cCenter(n,2)+cWidth/2])
    line([cCenter(n,1)-cLength/2,cCenter(n,1)+cLength/2],[cCenter(n,2)-cWidth/2,cCenter(n,2)-cWidth/2])
    %Width
    line([cCenter(n,1)+cLength/2,cCenter(n,1)+cLength/2],[cCenter(n,2)-cWidth/2,cCenter(n,2)+cWidth/2])
    line([cCenter(n,1)-cLength/2,cCenter(n,1)-cLength/2],[cCenter(n,2)-cWidth/2,cCenter(n,2)+cWidth/2])
    hold on
end

scatter(MNborn_x,MNborn_y);

grid on
box on
xlim([0,sLength]);
xticks(0:sLength/5:sLength);
ylim([0,sWidth]);
yticks(0:sWidth/5:sWidth);