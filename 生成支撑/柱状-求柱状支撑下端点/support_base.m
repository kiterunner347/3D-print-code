function spi=support_base(spoint,r)
%根据提供的spoint，获得spi,spi每一行表示一个支撑(用两个点表示)，格式为[x坐标 y坐标 上顶点z坐标 下顶点z坐标]
global face
global vertex

d=[];
for k=1:length(spoint)
    d=[d;spoint{k}(:,:)];
end

m=length(d);
S0=[vertex(face(:,1),:) vertex(face(:,2),:) vertex(face(:,3),:)];

%S1为S0中每个面片所在的矩形区域，格式为[xmax ymax xmin ymin 矩形区域半长]
S1=[max([S0(:,1) S0(:,4) S0(:,7)],[],2) max([S0(:,2) S0(:,5) S0(:,8)],[],2) ...
    min([S0(:,1) S0(:,4) S0(:,7)],[],2) min([S0(:,2) S0(:,5) S0(:,8)],[],2)];
S1=[S1 (S1(:,1)-S1(:,3))/2 (S1(:,2)-S1(:,4))/2];

spi=[];
for j=1:m
    spi=[spi;find_z2(d(j,2:4),S0,S1,d(j,1),r)];
end
end
