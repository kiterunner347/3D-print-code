function [area_total,perimeter_total,fv_low,tri_cross,four_cross]=plot_cross_section(face,vertex,HE_edge,Csp,r,z,Cface,Cvertex,Csp_Edge)
m=length(face);
mark=[];        % 记录点所在的面和半边    i为所在的面 3i-x为所对应的半边
cross_point=[]; 
count=0;
%创建一个数组 用来存储符合条件的点的横纵坐标
%一条半边有起始点和结束点，当半边被截面横穿的时候，必定是一个点在上，一个点在下
for i=1:m
    for j=1:3
        if (vertex(HE_edge{i,j}(1),3)-z)*(vertex(HE_edge{i,j}(2),3)-z)<=0   %需要折算出交叉带点的坐标x,y
            ratio=-(vertex(HE_edge{i,j}(1),3)-z)/(vertex(HE_edge{i,j}(2),3)-z);   %起始点比上结束点的z坐标之差
            new_x=vertex(HE_edge{i,j}(1),1)*(1/(1+ratio))+vertex(HE_edge{i,j}(2),1)*(ratio/(1+ratio));
            new_y=vertex(HE_edge{i,j}(1),2)*(1/(1+ratio))+vertex(HE_edge{i,j}(2),2)*(ratio/(1+ratio));
            cross_point=[cross_point;new_x new_y];
            count=count+1;
            mark=[mark;i j 0 0];      %记录的是i,j，可以知道面和半边   %发现得到的mark由面的顺序从小到大排列（因此这边没有做排序）
            HE_edge{i,j}(7)=1;       %mark 第三个0在编组的时候表示数据未处理/第四个零表示在某个闭合曲线中的位置
            HE_edge{i,j}(8)=count;   %通过半边数据结构体查询到交叉点位置
        end                                
    end
end
Label=0; %记录有几个封闭曲线

while(ismember(0,mark(:,3)))
    p=1;                   %初始位置设为1
    Label=Label+1;
    L=length(cross_point);
    xmin=max(cross_point(:,1));   %随意初始化
    for i=1:L
        if cross_point(i,1)<xmin && mark(i,3)==0
            xmin=cross_point(i,1);
        end
    end
    for i=1:L                % 找到起始点
        if cross_point(i,1)==xmin
            BG_row=i;                 %在cross_point和mark的第几行
            mark(i,3)=Label;          %已标记
            mark(i,4)=p;p=p+1;
            break;
        end
    end
    HE_a0=mark(BG_row,1);HE_b0=mark(BG_row,2);%由行找到半边的序列，最初始半边
    HE_a=HE_a0;HE_b=HE_b0;
    while 1==1    %找到在同一个面上的另外一条半边，再找到那条半边配对的半边
        for j=1:3
            if HE_edge{HE_a,j}(7)==1 && j~=HE_b    %找到了共面的半边，接下俩寻找它的pair
                number=HE_edge{HE_a,j}(8);
                mark(number,3)=Label;
                mark(number,4)=p;p=p+1;
                pair_a=HE_edge{HE_a,j}(3);
                pair_b=HE_edge{HE_a,j}(4);
                HE_a=pair_a;
                HE_b=pair_b;
                number=HE_edge{HE_a,HE_b}(8);
                mark(number,3)=Label;
                mark(number,4)=p;p=p+1;
            end
        end
        if (HE_a==HE_a0 && HE_b==HE_b0) || (p>L)
            break;
        end
    end
end

curve=cell(1,Label);
for i=1:Label
    tempt=[];
    for j=1:L     %先根据曲线划分数组
        if mark(j,3)==i
            tempt=[tempt;cross_point(j,1) cross_point(j,2) mark(j,4)];
        end
    end
    tempt=sortrows(tempt,3);
%   tempt=double(vpa(tempt,7));
    tempt=tempt(1:2:end,1:2);         %注意半边数据有重复，故隔两个数据选一个
    min=max(tempt(:,1));
    change=1;
    for j=1:length(tempt)
        if tempt(j,1)<min
            change=j;
            min=tempt(j,1);
        end
    end
    tempt=[tempt(change:end,:);tempt(1:change-1,:)];
    curve{1,i}=tempt;
end
perimeter_total=0;area_total=0;

%检验曲线是否有包含关系，这会影响面积的大小
%判断i是否包含于j
contain=[];
for i=1:Label
    for j=1:Label
        if i==j
            continue;
        elseif judge_contain(curve{1,i}(:,1),curve{1,i}(:,2),curve{1,j}(:,1),curve{1,j}(:,2))==1
            contain=[contain;i];
        end
    end
end
%依次绘制闭合曲线           
for i=1:Label
% %     Z=z*ones(1,length(curve{1,i}(:,1)));
%     [u,v] = dzy_nihe(curve{1,i}(:,1),curve{1,i}(:,2),z);
% %     patch(curve{1,i}(:,1),curve{1,i}(:,2),Z,'g','EdgeColor','g');
%     hold on 
    perimeter_total=perimeter_total+perimeter(alphaShape(curve{1,i}(:,1),curve{1,i}(:,2)));  %计算面积与周长
    if ismember(i,contain(:))
        area_total=area_total-polyarea(curve{1,i}(:,1),curve{1,i}(:,2));
    else
        area_total=area_total+polyarea(curve{1,i}(:,1),curve{1,i}(:,2));   %不考虑套娃情况
    end
end
 

%绘制支撑截面
M=length(Csp);
for i=1:M
    if (Csp(i,3)-z)*(Csp(i,6)-z)<0  
        new_x=Csp(i,1);
        new_y=Csp(i,2);
        [x,y]=plot_circle(r,new_x,new_y);
        Z=ones(1,length(x))*z;
%         plot3(x,y,Z','b')
% %         patch(x,y,Z,'b','EdgeColor','b');
%         hold on
%         line([x(1),x(end)],[y(1),y(end)],'color','b');
    end                                
end  

%生成下方面片
face_record=ones(length(face),1);        %1代表位于下方
for i=1:m
    for j=1:3
        if vertex(HE_edge{i,j}(1),3)>=z
            face_record(i)=0;
        end
    end
end
face_low=[];
for i=1:length(face_record)
    if face_record(i)==1
        face_low=[face_low;face(i,:)];
    end
end
fv_low=struct('faces',face_low,'vertice',vertex);
% patch(fv_low,'FaceColor','green')


%生成交叉位置面片
cross_vertex_tri=[];
cross_vertex_four=[];
for i=1:m
    if HE_edge{i,1}(7)==1 || HE_edge{i,2}(7)==1 ||  HE_edge{i,3}(7)==1
        c=0;
        for j=1:3
            if vertex(face(i,j),3)<z
                c=c+1;
            end
        end        
        if c==1          %下三角形状
            resid=[];
            for j=1:3
              if vertex(face(i,j),3)<z
                  low=j;
              else
                  resid=[resid j];
              end
            end
            vertex1=vertex(face(i,low),:);
            ratio1=-(vertex(face(i,resid(1)),3)-z)/(vertex(face(i,low),3)-z);   
            new_x=vertex(face(i,resid(1)),1)*(1/(1+ratio1))+vertex(face(i,low),1)*(ratio1/(1+ratio1));
            new_y=vertex(face(i,resid(1)),2)*(1/(1+ratio1))+vertex(face(i,low),2)*(ratio1/(1+ratio1));
            vertex2=[new_x new_y z];
            ratio1=-(vertex(face(i,resid(2)),3)-z)/(vertex(face(i,low),3)-z);   
            new_x=vertex(face(i,resid(2)),1)*(1/(1+ratio1))+vertex(face(i,low),1)*(ratio1/(1+ratio1));
            new_y=vertex(face(i,resid(2)),2)*(1/(1+ratio1))+vertex(face(i,low),2)*(ratio1/(1+ratio1));
            vertex3=[new_x new_y z];
            cross_vertex_tri=[cross_vertex_tri;vertex1;vertex2;vertex3];
        else    %c=2
            resid=[];
            for j=1:3
              if vertex(face(i,j),3)>z
                  up=j;
              else
                  resid=[resid j];
              end
            end
            vertex1=vertex(face(i,resid(1)),:);
            vertex2=vertex(face(i,resid(2)),:);
            ratio1=-(vertex(face(i,resid(2)),3)-z)/(vertex(face(i,up),3)-z);     %先做后面一个点的截点
            new_x=vertex(face(i,resid(2)),1)*(1/(1+ratio1))+vertex(face(i,up),1)*(ratio1/(1+ratio1));
            new_y=vertex(face(i,resid(2)),2)*(1/(1+ratio1))+vertex(face(i,up),2)*(ratio1/(1+ratio1));
            vertex3=[new_x new_y z];
            ratio1=-(vertex(face(i,resid(1)),3)-z)/(vertex(face(i,up),3)-z);   
            new_x=vertex(face(i,resid(1)),1)*(1/(1+ratio1))+vertex(face(i,up),1)*(ratio1/(1+ratio1));
            new_y=vertex(face(i,resid(1)),2)*(1/(1+ratio1))+vertex(face(i,up),2)*(ratio1/(1+ratio1));
            vertex4=[new_x new_y z];
            cross_vertex_four=[cross_vertex_four;vertex1;vertex2;vertex3;vertex4];
        end
    end
end

l=length(cross_vertex_tri)/3;
face_tri=ones(l,3);
for i=1:l 
    for j=1:3
        face_tri(i,j)=3*(i-1)+j;
    end
end
tri_cross=struct('faces',face_tri,'vertice',cross_vertex_tri);
% patch(tri_cross,'FaceColor','green')

l2=length(cross_vertex_four)/4;
face_four=ones(l2,4);
for i=1:l2
    for j=1:4
        face_four(i,j)=4*(i-1)+j;
    end
end
four_cross=struct('faces',face_four,'vertice',cross_vertex_four);
% patch(four_cross,'FaceColor','green')

%%画出下方和交叉的支撑
% plot_cross_support(Cface,Cvertex,Csp_Edge,z)
end



            
            
            
            




        
        
        
