function [u,v] = dzy_nihe(x,y,z)
x(end+1)=x(1);y(end+1)=y(1);
L=[];l=1;
%分区域转折点L
dx=diff(x);
for i=1:length(dx)-1
    if dx(i)*dx(i+1)<0
        L(end+1)=i+1;
    end
end

for j=1:length(L)
    x_p=[];y_p=[];
    if l==1
        m=l;
    else
        m=l-1;
        l=l-1;
    end
    for i=m:L(j)
        x_p(i-m+1)=x(i);y_p(i-m+1)=y(i);
        l=l+1;
    end
    u=linspace(x_p(1),x_p(end),10*length(x_p));
    v=pchip(x_p,y_p,u);
    h=z*ones(1,length(u));
    plot3(u,v,h,'g');
    hold on;
end
%最后一条线插值
x_p=[];y_p=[];
for i=L(end):length(x)
    x_p(i-L(end)+1)=x(i);y_p(i-L(end)+1)=y(i);
end
    u=linspace(x_p(1),x_p(end),10*length(x_p));
    v=pchip(x_p,y_p,u);
    h=z*ones(1,length(u));
    plot3(u,v,h,'g');
end