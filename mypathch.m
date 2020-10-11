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
vertex=data_xyz(1:n,:);   %���е�ļ��� ������ű�ʾ
face=data_xyz(n+1:end,:); %������ļ��� �����ϵ������������
m=length(face);

fv=struct('faces',face,'vertice',vertex);
patch(fv,'FaceColor',[0.2 0.5 0.8])
xlabel('x');ylabel('y');zlabel('z');
rotate3d on 
% ���������Դ�����ҵ�������ǿ��
% camlight('headlight'); 
% material('dull'); 
% �趨�鿴�Ƕ� ʹͼ���ʺϴ��ڴ�С��ʾ
axis('image');
view([45 25]);