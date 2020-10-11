function a=ifsupport(S,theta,flag)
%给空间中3个点组成的面S，求在给定theta角下是否�?要支�?
%flag=0,外支撑判断，flag=1，内支撑判断
m=[0 0 1];
a=S(2,:)-S(1,:);
b=S(3,:)-S(2,:);

if flag~=0 
    if flag==1
        n=-cross(a,b);
    elseif flag==-1
        n=cross(a,b);
    end
    theta0=acos(dot(n,m)/(norm(n)*norm(m)));
    if theta0>pi/2+theta
        a=1;
    else
        a=0;
    end
else
    n1=-cross(a,b);n2=cross(a,b);
    theta01=acos(dot(n1,m)/(norm(n1)*norm(m)));
    theta02=acos(dot(n2,m)/(norm(n2)*norm(m)));
    if theta01>pi/2+theta||theta02>pi/2+theta
        a=1;
    else
        a=0;
    end
end