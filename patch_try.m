clear all
clc
ori_data=importdata('tree.txt');
data_xyz=ori_data.data;
text_data=char(ori_data.textdata);
n=1;
while text_data(n)=='v'
    n=n+1;
end
n=n-1;%**************ԭ��n����1
vertex=data_xyz(1:n,:);   %���е�ļ��� ������ű�ʾ
face=data_xyz(n+1:end,:);  %������ļ��� �����ϵ������������
m=length(face);


%patch ����
vertice=zeros(3*m,3); %�洢���ϵĵ�
rem=1;    
for i=1:m
    vertice(rem,:)=vertex(face(i,1),:);     %����Ϊ˳���¼�������
    rem=rem+1;                              %vertice ÿһ�ж���һ��������꣬face�ǰ������귽��˳�����
    vertice(rem,:)=vertex(face(i,2),:);     %face������vertice��1/3
    rem=rem+1;
    vertice(rem,:)=vertex(face(i,3),:);
    rem=rem+1;
end
faces=[(1:3:3*m-2)' (2:3:3*m-1)' (3:3:3*m)'];    %patch�е��� 
fv=struct('faces',faces,'vertice',vertice);
patch(fv,'FaceColor',[0.2 0.5 0.8])
xlabel('x');ylabel('y');zlabel('z');
rotate3d on 
% ���������Դ�����ҵ�������ǿ��
% camlight('headlight'); 
% material('dull'); 
% �趨�鿴�Ƕ� ʹͼ���ʺϴ��ڴ�С��ʾ
axis('image');
view([-135 40]);

    