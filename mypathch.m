clear all;
clc;
ori_data=importdata('test.txt');
data_xyz=ori_data.data;
text_data=char(ori_data.textdata);
n=1;
while text_data(n)=='v'
    n=n+1;
end
n=n-1;
vertex=data_xyz(1:n,:);   %所有点的集合 点以序号表示
face=data_xyz(n+1:end,:); %所有面的集合 以面上的三个点代表面
m=length(face);

fv=struct('faces',face,'vertice',vertex);
patch(fv,'FaceColor',[0.2 0.5 0.8])
xlabel('x');ylabel('y');zlabel('z');
rotate3d on 
% 增加相机光源，并且调整反光强度
% camlight('headlight'); 
% material('dull'); 
% 设定查看角度 使图形适合窗口大小显示
axis('image');
view([45 25]);