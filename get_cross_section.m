clear all;
clc;

new_process;
%ǰ�濽���˰�����ݽṹ����Ϣ
mark=[];        % ��¼�����ڵ���Ͱ��    iΪ���ڵ��� 3i-xΪ����Ӧ�İ��
cross_point=[];M=0      %����һ������ �����洢���������ĵ�ĺ�������
%һ���������ʼ��ͽ����㣬����߱�����ᴩ��ʱ�򣬱ض���һ�������ϣ�һ��������
prompt = 'input z value? ';
z = input(prompt);
for i=1:m
    for j=1:3
        if (vertex(HE_edge{i,j}(1),3)-z)*(vertex(HE_edge{i,j}(2),3)-z)<=0   %��Ҫ�����������������x,y
            ratio=-(vertex(HE_edge{i,j}(1),3)-z)/(vertex(HE_edge{i,j}(2),3)-z);   %��ʼ����Ͻ������z����֮��
            new_x=vertex(HE_edge{i,j}(1),1)*(1/(1+ratio))+vertex(HE_edge{i,j}(2),1)*(ratio/(1+ratio));
            new_y=vertex(HE_edge{i,j}(1),2)*(1/(1+ratio))+vertex(HE_edge{i,j}(2),2)*(ratio/(1+ratio));
            cross_point=[cross_point;new_x new_y];
            mark=[mark;i 3*i-(3-j) 0];      %�ֱ��¼��Ͱ��   %���ֵõ���mark�����˳���С�������У�������û��������
            M=M+1
        end                                 %mark ����һ��0�ڱ����ʱ���ʾ����δ����
    end
end
cross_copy=cross_point;
count=1;
while(ismember(0,mark(:,3)))
    xmin=min(cross_copy(:,1));
    for i=1:M
        if cross_copy(i,1)==xmin
            BG=i;        %��ʼ��
            mark(i,3)=count;  %�ѱ��   %��count���ֵڼ����������
        end
    end
    L=length(corss_copy)
    Face_BG=mark(BG,1);
    End_HE=mark(BG,2);           %�ҵ���ͬһ�����ϵ�����һ����ߣ����ҵ����������Եİ��
    while 1==1
        for i=1:L
            if mark(i,1)==BG & i~=BG
                Next_HE=mark(i,2);
                pair=1;
        end
    count=count+1;
end

function [a,b]=find_number(x)%����pair���
if mod(x,3)==0
    a=x/3;b=3;
else mod(x,3)==1
    a=x/3+1;
    b=1;
else
    a=x/3+1
    b=2;
end
end

%�۲����ɵĵ�
% cross_point=unique(cross_point,'rows');       %ɾ���ظ���
% plot(cross_point(:,1),cross_point(:,2),'k.')
