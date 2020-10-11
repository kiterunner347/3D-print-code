function [area_total,perimeter_total,fv_low,tri_cross,four_cross]=plot_cross_section(face,vertex,HE_edge,Csp,r,z,Cface,Cvertex,Csp_Edge)
m=length(face);
mark=[];        % ��¼�����ڵ���Ͱ��    iΪ���ڵ��� 3i-xΪ����Ӧ�İ��
cross_point=[]; 
count=0;
%����һ������ �����洢���������ĵ�ĺ�������
%һ���������ʼ��ͽ����㣬����߱�����ᴩ��ʱ�򣬱ض���һ�������ϣ�һ��������
for i=1:m
    for j=1:3
        if (vertex(HE_edge{i,j}(1),3)-z)*(vertex(HE_edge{i,j}(2),3)-z)<=0   %��Ҫ�����������������x,y
            ratio=-(vertex(HE_edge{i,j}(1),3)-z)/(vertex(HE_edge{i,j}(2),3)-z);   %��ʼ����Ͻ������z����֮��
            new_x=vertex(HE_edge{i,j}(1),1)*(1/(1+ratio))+vertex(HE_edge{i,j}(2),1)*(ratio/(1+ratio));
            new_y=vertex(HE_edge{i,j}(1),2)*(1/(1+ratio))+vertex(HE_edge{i,j}(2),2)*(ratio/(1+ratio));
            cross_point=[cross_point;new_x new_y];
            count=count+1;
            mark=[mark;i j 0 0];      %��¼����i,j������֪����Ͱ��   %���ֵõ���mark�����˳���С�������У�������û��������
            HE_edge{i,j}(7)=1;       %mark ������0�ڱ����ʱ���ʾ����δ����/���ĸ����ʾ��ĳ���պ������е�λ��
            HE_edge{i,j}(8)=count;   %ͨ��������ݽṹ���ѯ�������λ��
        end                                
    end
end
Label=0; %��¼�м����������

while(ismember(0,mark(:,3)))
    p=1;                   %��ʼλ����Ϊ1
    Label=Label+1;
    L=length(cross_point);
    xmin=max(cross_point(:,1));   %�����ʼ��
    for i=1:L
        if cross_point(i,1)<xmin && mark(i,3)==0
            xmin=cross_point(i,1);
        end
    end
    for i=1:L                % �ҵ���ʼ��
        if cross_point(i,1)==xmin
            BG_row=i;                 %��cross_point��mark�ĵڼ���
            mark(i,3)=Label;          %�ѱ��
            mark(i,4)=p;p=p+1;
            break;
        end
    end
    HE_a0=mark(BG_row,1);HE_b0=mark(BG_row,2);%�����ҵ���ߵ����У����ʼ���
    HE_a=HE_a0;HE_b=HE_b0;
    while 1==1    %�ҵ���ͬһ�����ϵ�����һ����ߣ����ҵ����������Եİ��
        for j=1:3
            if HE_edge{HE_a,j}(7)==1 && j~=HE_b    %�ҵ��˹���İ�ߣ�������Ѱ������pair
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
    for j=1:L     %�ȸ������߻�������
        if mark(j,3)==i
            tempt=[tempt;cross_point(j,1) cross_point(j,2) mark(j,4)];
        end
    end
    tempt=sortrows(tempt,3);
%   tempt=double(vpa(tempt,7));
    tempt=tempt(1:2:end,1:2);         %ע�����������ظ����ʸ���������ѡһ��
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

%���������Ƿ��а�����ϵ�����Ӱ������Ĵ�С
%�ж�i�Ƿ������j
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
%���λ��Ʊպ�����           
for i=1:Label
% %     Z=z*ones(1,length(curve{1,i}(:,1)));
%     [u,v] = dzy_nihe(curve{1,i}(:,1),curve{1,i}(:,2),z);
% %     patch(curve{1,i}(:,1),curve{1,i}(:,2),Z,'g','EdgeColor','g');
%     hold on 
    perimeter_total=perimeter_total+perimeter(alphaShape(curve{1,i}(:,1),curve{1,i}(:,2)));  %����������ܳ�
    if ismember(i,contain(:))
        area_total=area_total-polyarea(curve{1,i}(:,1),curve{1,i}(:,2));
    else
        area_total=area_total+polyarea(curve{1,i}(:,1),curve{1,i}(:,2));   %�������������
    end
end
 

%����֧�Ž���
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

%�����·���Ƭ
face_record=ones(length(face),1);        %1����λ���·�
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


%���ɽ���λ����Ƭ
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
        if c==1          %��������״
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
            ratio1=-(vertex(face(i,resid(2)),3)-z)/(vertex(face(i,up),3)-z);     %��������һ����Ľص�
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

%%�����·��ͽ����֧��
% plot_cross_support(Cface,Cvertex,Csp_Edge,z)
end



            
            
            
            




        
        
        
