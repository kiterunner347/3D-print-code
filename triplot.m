function n = triplot(p1,p2,p3)
%plot
n=1;
pp=[p1;p2;p3;p1];
plot3(pp(:,1),pp(:,2),pp(:,3),'-xb');grid on;
end

