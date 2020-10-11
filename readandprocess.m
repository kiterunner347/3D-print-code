clear all
clc

tic;
ori_data=importdata('tree.txt');
data_xyz=ori_data.data;
text_data=char(ori_data.textdata);
n=1;
while text_data(n)=='v'
    n=n+1;
end
vertex=data_xyz(1:n,:);   %���е�ļ��� ������ű�ʾ
face=data_xyz(n+1:end,:);  %������ļ��� �����ϵ������������
global m
m=length(face);

time3=toc
HE_vertex(1:n)=struct('x',[],'y',[],'z',[]);        %������
for i=1:n
    HE_vertex(i)=struct('x',vertex(i,1),'y',vertex(i,2),'z',vertex(i,3));
end

time4=toc
HE_edge(1:m,3)=struct('initial_point',[],'next_point',[],'pair',[],'Next_Edge',[],'face',[]);   %Ԥ�ȷ���ռ䣬
for i=1:m                             %�����˳�������,��i����
    HE_edge(i,1)=struct('initial_point',face(i,3),'next_point',face(i,1),'pair',[],'Next_Edge',[i,2],'face',i);   %[i,2]��ʾ�����ţ�����Ŵ洢��Ӧ���
    HE_edge(i,2)=struct('initial_point',face(i,1),'next_point',face(i,2),'pair',[],'Next_Edge',[i,3],'face',i);   %�Ա�ָ����������ʼ�㣬��������
    HE_edge(i,3)=struct('initial_point',face(i,2),'next_point',face(i,3),'pair',[],'Next_Edge',[i,1],'face',i);   
end

time2=toc
%��ȡ��԰��
for i=1:100
    j=1;v1=face(i,3);v2=face(i,1);itself=i;
    while j<=m
        if ismember(v1,face(j,:))==1 & ismember(v2,face(j,:))==1 & j~=itself
            a=j;
            if v1==face(j,1) & v2==face(j,2) | v2==face(j,1) & v1==face(j,2)   %1-->2
                b=2;
            elseif v1==face(j,2) & v2==face(j,3) | v2==face(j,2) & v1==face(j,3)  %2-->3
                b=3;
            elseif v1==face(j,3) & v2==face(j,1) | v2==face(j,3) & v1==face(j,1)
                b=1;
            end
            break;
        end
        j=j+1;
    end
    HE_edge(i,1).pair=[a,b];
    j=1;v1=face(i,1);v2=face(i,2);itself=i;
    while j<=m
        if ismember(v1,face(j,:))==1 & ismember(v2,face(j,:))==1 & j~=itself
            a=j;
            if v1==face(j,1) & v2==face(j,2) | v2==face(j,1) & v1==face(j,2)   %1-->2
                b=2;
            elseif v1==face(j,2) & v2==face(j,3) | v2==face(j,2) & v1==face(j,3)  %2-->3
                b=3;
            else
                b=1;
            end
            break;
        end
        j=j+1;
    end
    HE_edge(i,2).pair=[a,b];
    j=1;v1=face(i,2);v2=face(i,3);itself=i;
    while j<=m
        if ismember(v1,face(j,:))==1 & ismember(v2,face(j,:))==1 & j~=itself
            a=j;
            if v1==face(j,1) & v2==face(j,2) | v2==face(j,1) & v1==face(j,2)   %1-->2
                b=2;
            elseif v1==face(j,2) & v2==face(j,3) | v2==face(j,2) & v1==face(j,3)  %2-->3
                b=3;
            else
                b=1;
            end
            break;
        end
        j=j+1;
    end
    HE_edge(i,2).pair=[a,b];
%     HE_edge(i,1).pair=find_pair(face(i,3),face(i,1),i);
%     HE_edge(i,2).pair=find_pair(face(i,1),face(i,2),i);
%     HE_edge(i,3).pair=find_pair(face(i,2),face(i,3),i);
%     ��Ҫ����face�����޷����У������
end
time=toc

% HE_face(1:m)=struct('edge',HE_edge)
% %�������ǵİ�߽ṹ���Ǹ����湹��ģ����Ե�i��HE_edge�ʹ���HE_face

% �������ܣ����ڽ������face��Ϊȫ�ֱ��������⣬��ʱֱ�Ӵ���pair����
% function [a,b]=find_pair(v1,v2,itself)    %v2Ϊend_point
% i=1;
% while i<=m
%     if ismember(v1,face(i,:))==1 & ismember(v2,face(i,:))==1 & i~=itself
%         a=i;
%         if if v1==face(i,1) & v2==face(i,2) | v2==face(i,1) & v1==face(i,2)
%             b=2;
%         elseif v1==face(j,2) & v2==face(j,3) | v2==face(j,2) & v1==face(j,3)
%             b=3;
%         else
%             b=1;
%         end
%         break;
%     end
%     i=i+1;
% end
% end