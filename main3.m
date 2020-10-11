close all;clear;clc;
%%
%读取文件
global HE_edge
global face
global vertex
tic;
filename='plane.txt';
ori_data=importdata(filename);
data_xyz=ori_data.data;
text_data=char(ori_data.textdata);
n=1;
while text_data(n)=='v'
    n=n+1;
end
n=n-1;
vertex=data_xyz(1:n,:);   %所有点的集合 点以序号表示
face=data_xyz(n+1:end,:);  %所有面的集合 以面上的三个点代表面
fprintf('读取数据');toc
%%
%旋转模型
vertex=myrotate(vertex,0,0);
%%
%生成半边
HE_edge=new_process(face,vertex);
fprintf('生成半边');toc
%%
%切片
% model_zmin=min(min(vertex(:,3)));
% model_zmax=max(max(vertex(:,3)));
% height=model_zmax-model_zmin;
% layer=floor(height/0.02);theta=1;
% idface=slice(vertex,HE_edge,face,layer,theta);
% fprintf('切片完成');toc
%%
%分辨率
nface=100;%参与确定分辨率的面片数，数值与效果之间的关系大概需要试探确定，数值越大支撑越少且越大
nface=min(nface,length(face));
global trunk    %分辨率，根据面片的数据信息确定
trunk=2*sum(abs(vertex(face(1:nface,1),1)-vertex(face(1:nface,2),1)))/(10*sqrt(nface))+...
      2*sum(abs(vertex(face(1:nface,1),2)-vertex(face(1:nface,2),2)))/(10*sqrt(nface));
nr=4;%控制支撑半径与分辨率之间的比值，nr越大支撑半径越小 
r=trunk/nr;%支撑半径
%% 
%求解树状待支撑区域
theta=pi/3;flag=-1;
idface=seedspread(theta,flag);
fprintf('求解待树状支撑区域');toc
%%
%划分区域重新采样得到树状支撑点
spoint=samplep(idface);
fprintf('划分区域重新采样得到树状支撑点');toc
%%
%求解支撑点下的树装交点
%tspp{i}{j}表示第i个待支撑区域的第j层支撑
phi=pi/6;
tspp=treesp(spoint,phi);
fprintf('求解支撑点下的树装交点');toc
%%
%求解柱状支撑区域
theta=pi/3;%需要生成支撑的角度
idface_col=seedspread(theta,0);%1表示内部支撑，-1表示外部支撑，0表示全支撑
fprintf('求解柱状支撑区域');toc
%%
%划分支撑区域重新采样得到支撑上端点
spoint_col=samplep(idface_col);
fprintf('划分支撑区域重新采样得到柱状支撑上端点');toc
%%
%求柱状支撑下端点
%Csp每行为[x1 y1 z1 x2 y2 z2]
 Csp=support_base(spoint_col,r);
 fprintf('求柱状支撑下端点');toc
%%
%生成柱状支撑半边
[Cface,Cvertex]=colsupport(Csp,r);
Csp_Edge=new_process(Cface,Cvertex);
fprintf('生成柱状支撑半边');toc
%%
%画图
fv=struct('faces',face,'vertice',vertex);
% patch(fv,'FaceColor','c')
view([135 45]);
rotate3d on 
hold on;
%画区域采样后在面上的点
% for i=1:length(spoint)
%     plot3(spoint{i}(:,2),spoint{i}(:,3),spoint{i}(:,4),'ob')
% end
% plot3(spoint{1}(:,2),spoint{1}(:,3),spoint{1}(:,4),'ob')

%画柱状支撑
cfv=struct('faces',Cface,'vertice',Cvertex);
% patch(cfv,'FaceColor','m','LineStyle',':')
view([135 45]);
rotate3d on 
hold on;

% 画生成采样点下的若干层树装支撑
% for tr=1:length(tspp)
%     for i=1:length(tspp{tr})
%         plot3(tspp{tr}{i}(:,1),tspp{tr}{i}(:,2),tspp{tr}{i}(:,3),'ob')
%     end
% end

%画树状支撑
% Tsp=[];
% for tr=1:length(tspp)
%     if length(tspp{tr})>1
%         for i=2:length(tspp{tr})
%             in1=tspp{tr}{i}(:,4);
%             in2=tspp{tr}{i}(:,5);
%             for plo=1:length(in1)
%                 p0=tspp{tr}{i}(plo,1:3);
%                 p1=tspp{tr}{i-1}(in1(plo),1:3);
%                 p2=tspp{tr}{i-1}(in2(plo),1:3);
%                 Tsp=[Tsp;p1 p0;p2 p0];
%             end
%             inz=linspace(1,length(tspp{tr}{i-1}(:,1)),length(tspp{tr}{i-1}(:,1)));
%             in=setdiff(inz',union(in1,in2));
%             pend=tspp{tr}{i-1}(in',1:3);
%             Tsp=[Tsp;pend pend(:,1:2) zeros(length(pend(:,1)),1)];
%         end
%         pend=tspp{tr}{i}(:,1:3);
%         Tsp=[Tsp;pend pend(:,1:2) zeros(length(pend(:,1)),1)];
%     end
%     if length(tspp{tr})==1
%         pend=tspp{tr}{1}(:,1:3);
%         if ~isempty(pend)
%             Tsp=[Tsp;pend pend(:,1:2) zeros(length(pend(:,1)),1)];
%         end
%     end
% end
% for i=1:length(Tsp)
%     [u,v,w]=cylinder(r);
%     u(1,:)=u(1,:)+Tsp(i,4);u(2,:)=u(2,:)+Tsp(i,1);
%     v(1,:)=v(1,:)+Tsp(i,5);v(2,:)=v(2,:)+Tsp(i,2);
%     w(1,:)=w(1,:)+Tsp(i,6);w(2,:)=w(2,:)-1+Tsp(i,3);
%     mesh(u,v,w);
%     hold on;
% end

%画待支撑区域
% for i=1:layer
%     fv=struct('faces',face(idface{i},:),'vertice',vertex);
%     patch(fv,'FaceColor','red')
% end
% xlabel('x');ylabel('y');zlabel('z');
% rotate3d on 
% axis('image');
% view([90 0]);
 fprintf('生成图像');toc
 %%
 %画实体和支撑的截面图  计算实体和支撑物的面积
z=0.5;
[area,perimeter]=plot_cross_section(face,vertex,HE_edge,Csp,r,z,Cface,Cvertex,Csp_Edge);
% zlim([0,z])
fprintf('生成截面');toc