function spi=support_base(spoint,r)
%�����ṩ��spoint�����spi,spiÿһ�б�ʾһ��֧��(���������ʾ)����ʽΪ[x���� y���� �϶���z���� �¶���z����]
global face
global vertex

d=[];
for k=1:length(spoint)
    d=[d;spoint{k}(:,:)];
end

m=length(d);
S0=[vertex(face(:,1),:) vertex(face(:,2),:) vertex(face(:,3),:)];

%S1ΪS0��ÿ����Ƭ���ڵľ������򣬸�ʽΪ[xmax ymax xmin ymin ��������볤]
S1=[max([S0(:,1) S0(:,4) S0(:,7)],[],2) max([S0(:,2) S0(:,5) S0(:,8)],[],2) ...
    min([S0(:,1) S0(:,4) S0(:,7)],[],2) min([S0(:,2) S0(:,5) S0(:,8)],[],2)];
S1=[S1 (S1(:,1)-S1(:,3))/2 (S1(:,2)-S1(:,4))/2];

spi=[];
for j=1:m
    spi=[spi;find_z2(d(j,2:4),S0,S1,d(j,1),r)];
end
end
