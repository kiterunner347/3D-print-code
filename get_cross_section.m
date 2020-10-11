clear all;
clc;

new_process;
%前面拷贝了半边数据结构的信息
mark=[];        % 记录点所在的面和半边    i为所在的面 3i-x为所对应的半边
cross_point=[];M=0      %创建一个数组 用来存储符合条件的点的横纵坐标
%一条半边有起始点和结束点，当半边被截面横穿的时候，必定是一个点在上，一个点在下
prompt = 'input z value? ';
z = input(prompt);
for i=1:m
    for j=1:3
        if (vertex(HE_edge{i,j}(1),3)-z)*(vertex(HE_edge{i,j}(2),3)-z)<=0   %需要折算出交叉带点的坐标x,y
            ratio=-(vertex(HE_edge{i,j}(1),3)-z)/(vertex(HE_edge{i,j}(2),3)-z);   %起始点比上结束点的z坐标之差
            new_x=vertex(HE_edge{i,j}(1),1)*(1/(1+ratio))+vertex(HE_edge{i,j}(2),1)*(ratio/(1+ratio));
            new_y=vertex(HE_edge{i,j}(1),2)*(1/(1+ratio))+vertex(HE_edge{i,j}(2),2)*(ratio/(1+ratio));
            cross_point=[cross_point;new_x new_y];
            mark=[mark;i 3*i-(3-j) 0];      %分别记录面和半边   %发现得到的mark由面的顺序从小到大排列（因此这边没有做排序）
            M=M+1
        end                                 %mark 最后的一个0在编组的时候表示数据未处理
    end
end
cross_copy=cross_point;
count=1;
while(ismember(0,mark(:,3)))
    xmin=min(cross_copy(:,1));
    for i=1:M
        if cross_copy(i,1)==xmin
            BG=i;        %开始点
            mark(i,3)=count;  %已标记   %用count区分第几个封闭曲线
        end
    end
    L=length(corss_copy)
    Face_BG=mark(BG,1);
    End_HE=mark(BG,2);           %找到在同一个面上的另外一条半边，再找到那条半边配对的半边
    while 1==1
        for i=1:L
            if mark(i,1)==BG & i~=BG
                Next_HE=mark(i,2);
                pair=1;
        end
    count=count+1;
end

function [a,b]=find_number(x)%计算pair序号
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

%观察生成的点
% cross_point=unique(cross_point,'rows');       %删除重复点
% plot(cross_point(:,1),cross_point(:,2),'k.')
