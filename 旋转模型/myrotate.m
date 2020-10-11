function vertex=myrotate(vertex,caz1,cel1,caz2,cel2)
% function vertex=myrotate(vertex,theta1,theta2)
% %theta1为方位角（从负 y 轴围绕 z 轴水平旋转的角度）
% %theta2为仰角（正值对应于在对象上方移动，负值对应于在对象下方移动）
% [caz1,cel1] = view;
% caz1=deg2rad(caz1);
% cel1=deg2rad(cel1);
% 
% if true
%     [caz2,cel2] = view;
%     %下面为测试使用，实际使用可以去掉
%     caz2=caz1+theta1;
%     cel2=cel1+theta2;
% end
% theta为仰角的旋转角度，phi为方位角旋转角度
% phi=caz2-caz1;
% theta=cel2-cel1;
phi=caz1-caz2;
theta=cel1-cel2;
alpha=caz1-pi/2;
vt=1-cos(theta); cst=cos(theta); st=sin(theta);
%寻找仰角的旋转轴
rx=cos(alpha);ry=sin(alpha);
temp=cross([rx,ry,0],[0 0 1]);
rx=temp(1);ry=temp(2);

Rz=[cos(phi) -sin(phi) 0;
    sin(phi) cos(phi) 0;
    0 0 1];
Rw=[rx^2*vt+cst rx*ry*vt ry*st ;
    rx*ry*vt    ry^2*vt+cst -rx*st ;
    -ry*st rx*st cst];
R=Rz*Rw;
if det(R)~=1
    fprintf('Rotate error!');
end
vertex=transpose(R*transpose(vertex));
%沿z轴向上移动
zmin=min(vertex(:,3));
vertex(:,3)=vertex(:,3)-zmin;
end