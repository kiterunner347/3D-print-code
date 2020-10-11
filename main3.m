close all;clear;clc;
%%
%��ȡ�ļ�
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
vertex=data_xyz(1:n,:);   %���е�ļ��� ������ű�ʾ
face=data_xyz(n+1:end,:);  %������ļ��� �����ϵ������������
fprintf('��ȡ����');toc
%%
%��תģ��
vertex=myrotate(vertex,0,0);
%%
%���ɰ��
HE_edge=new_process(face,vertex);
fprintf('���ɰ��');toc
%%
%��Ƭ
% model_zmin=min(min(vertex(:,3)));
% model_zmax=max(max(vertex(:,3)));
% height=model_zmax-model_zmin;
% layer=floor(height/0.02);theta=1;
% idface=slice(vertex,HE_edge,face,layer,theta);
% fprintf('��Ƭ���');toc
%%
%�ֱ���
nface=100;%����ȷ���ֱ��ʵ���Ƭ������ֵ��Ч��֮��Ĺ�ϵ�����Ҫ��̽ȷ������ֵԽ��֧��Խ����Խ��
nface=min(nface,length(face));
global trunk    %�ֱ��ʣ�������Ƭ��������Ϣȷ��
trunk=2*sum(abs(vertex(face(1:nface,1),1)-vertex(face(1:nface,2),1)))/(10*sqrt(nface))+...
      2*sum(abs(vertex(face(1:nface,1),2)-vertex(face(1:nface,2),2)))/(10*sqrt(nface));
nr=4;%����֧�Ű뾶��ֱ���֮��ı�ֵ��nrԽ��֧�Ű뾶ԽС 
r=trunk/nr;%֧�Ű뾶
%% 
%�����״��֧������
theta=pi/3;flag=-1;
idface=seedspread(theta,flag);
fprintf('������״֧������');toc
%%
%�����������²����õ���״֧�ŵ�
spoint=samplep(idface);
fprintf('�����������²����õ���״֧�ŵ�');toc
%%
%���֧�ŵ��µ���װ����
%tspp{i}{j}��ʾ��i����֧������ĵ�j��֧��
phi=pi/6;
tspp=treesp(spoint,phi);
fprintf('���֧�ŵ��µ���װ����');toc
%%
%�����״֧������
theta=pi/3;%��Ҫ����֧�ŵĽǶ�
idface_col=seedspread(theta,0);%1��ʾ�ڲ�֧�ţ�-1��ʾ�ⲿ֧�ţ�0��ʾȫ֧��
fprintf('�����״֧������');toc
%%
%����֧���������²����õ�֧���϶˵�
spoint_col=samplep(idface_col);
fprintf('����֧���������²����õ���״֧���϶˵�');toc
%%
%����״֧���¶˵�
%Cspÿ��Ϊ[x1 y1 z1 x2 y2 z2]
 Csp=support_base(spoint_col,r);
 fprintf('����״֧���¶˵�');toc
%%
%������״֧�Ű��
[Cface,Cvertex]=colsupport(Csp,r);
Csp_Edge=new_process(Cface,Cvertex);
fprintf('������״֧�Ű��');toc
%%
%��ͼ
fv=struct('faces',face,'vertice',vertex);
% patch(fv,'FaceColor','c')
view([135 45]);
rotate3d on 
hold on;
%����������������ϵĵ�
% for i=1:length(spoint)
%     plot3(spoint{i}(:,2),spoint{i}(:,3),spoint{i}(:,4),'ob')
% end
% plot3(spoint{1}(:,2),spoint{1}(:,3),spoint{1}(:,4),'ob')

%����״֧��
cfv=struct('faces',Cface,'vertice',Cvertex);
% patch(cfv,'FaceColor','m','LineStyle',':')
view([135 45]);
rotate3d on 
hold on;

% �����ɲ������µ����ɲ���װ֧��
% for tr=1:length(tspp)
%     for i=1:length(tspp{tr})
%         plot3(tspp{tr}{i}(:,1),tspp{tr}{i}(:,2),tspp{tr}{i}(:,3),'ob')
%     end
% end

%����״֧��
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

%����֧������
% for i=1:layer
%     fv=struct('faces',face(idface{i},:),'vertice',vertex);
%     patch(fv,'FaceColor','red')
% end
% xlabel('x');ylabel('y');zlabel('z');
% rotate3d on 
% axis('image');
% view([90 0]);
 fprintf('����ͼ��');toc
 %%
 %��ʵ���֧�ŵĽ���ͼ  ����ʵ���֧��������
z=0.5;
[area,perimeter]=plot_cross_section(face,vertex,HE_edge,Csp,r,z,Cface,Cvertex,Csp_Edge);
% zlim([0,z])
fprintf('���ɽ���');toc