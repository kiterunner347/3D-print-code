function [x,y]=plot_circle(r,xp,yp)
xita=0:2*pi/20:2*pi/20*19;
x=xp+r.*cos(xita);
y=yp+r.*sin(xita);
end