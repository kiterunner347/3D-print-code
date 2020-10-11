clear all
clc
ori_data=importdata('tree.txt');
data_xyz=ori_data.data;
text_data=char(ori_data.textdata);
n=1;
while text_data(n)=='v'
    n=n+1;
end
n=n-1;%**************原来n多了1
vertex=data_xyz(1:n,:);   %所有点的集合 点以序号表示
face=data_xyz(n+1:end,:);  %所有面的集合 以面上的三个点代表面
m=length(face);


%patch 部分
vertice=zeros(3*m,3); %存储面上的点
rem=1;    
for i=1:m
    vertice(rem,:)=vertex(face(i,1),:);     %以面为顺序记录点的坐标
    rem=rem+1;                              %vertice 每一行都是一个点的坐标，face是按横坐标方向顺序的面
    vertice(rem,:)=vertex(face(i,2),:);     %face数量是vertice的1/3
    rem=rem+1;
    vertice(rem,:)=vertex(face(i,3),:);
    rem=rem+1;
end
faces=[(1:3:3*m-2)' (2:3:3*m-1)' (3:3:3*m)'];    %patch中的面 
fv=struct('faces',faces,'vertice',vertice);
patch(fv,'FaceColor',[0.2 0.5 0.8])
xlabel('x');ylabel('y');zlabel('z');
rotate3d on 
% 增加相机光源，并且调整反光强度
% camlight('headlight'); 
% material('dull'); 
% 设定查看角度 使图形适合窗口大小显示
axis('image');
view([-135 40]);

    