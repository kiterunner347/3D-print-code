function [fv_low_s,tri_cross_s,four_cross_s]=plot_cross_support(Cface,Cvertex,Csp_Edge,z)
%%生成下方支撑
Cface_record=ones(length(Cface),1);        %1代表位于下方
for i=1:length(Cface)
    for j=1:3
        if Cvertex(Csp_Edge{i,j}(1),3)>=z
            Cface_record(i)=0;
        end
    end
end
Cface_low=[];
for i=1:length(Cface_record)
    if Cface_record(i)==1
        Cface_low=[Cface_low;Cface(i,:)];
    end
end
fv_low_s=struct('faces',Cface_low,'vertice',Cvertex);
% patch(fv_low_s,'FaceColor','blue')

%%生成交叉位置支撑
%先标记交叉点
for i=1:length(Cface)
    for j=1:3
        if (Cvertex(Csp_Edge{i,j}(1),3)-z)*(Cvertex(Csp_Edge{i,j}(2),3)-z)<=0  
            Csp_Edge{i,j}(7)=1;   %通过半边数据结构体查询到交叉点位置
        end                                
    end
end
cross_vertex_tri=[];
cross_vertex_four=[];
for i=1:length(Cface)
    if Csp_Edge{i,1}(7)==1 || Csp_Edge{i,2}(7)==1 ||  Csp_Edge{i,3}(7)==1
        c=0;
        for j=1:3
            if Cvertex(Cface(i,j),3)<z
                c=c+1;
            end
        end        
        if c==1          %下三角形状
            resid=[];
            for j=1:3
              if Cvertex(Cface(i,j),3)<z
                  low=j;
              else
                  resid=[resid j];
              end
            end
            vertex1=Cvertex(Cface(i,low),:);
            ratio1=-(Cvertex(Cface(i,resid(1)),3)-z)/(Cvertex(Cface(i,low),3)-z);   
            new_x=Cvertex(Cface(i,resid(1)),1)*(1/(1+ratio1))+Cvertex(Cface(i,low),1)*(ratio1/(1+ratio1));
            new_y=Cvertex(Cface(i,resid(1)),2)*(1/(1+ratio1))+Cvertex(Cface(i,low),2)*(ratio1/(1+ratio1));
            vertex2=[new_x new_y z];
            ratio1=-(Cvertex(Cface(i,resid(2)),3)-z)/(Cvertex(Cface(i,low),3)-z);   
            new_x=Cvertex(Cface(i,resid(2)),1)*(1/(1+ratio1))+Cvertex(Cface(i,low),1)*(ratio1/(1+ratio1));
            new_y=Cvertex(Cface(i,resid(2)),2)*(1/(1+ratio1))+Cvertex(Cface(i,low),2)*(ratio1/(1+ratio1));
            vertex3=[new_x new_y z];
            cross_vertex_tri=[cross_vertex_tri;vertex1;vertex2;vertex3];
        else    %c=2
            resid=[];
            for j=1:3
              if Cvertex(Cface(i,j),3)>z
                  up=j;
              else
                  resid=[resid j];
              end
            end
            vertex1=Cvertex(Cface(i,resid(1)),:);
            vertex2=Cvertex(Cface(i,resid(2)),:);
            ratio1=-(Cvertex(Cface(i,resid(2)),3)-z)/(Cvertex(Cface(i,up),3)-z);     %先做后面一个点的截点
            new_x=Cvertex(Cface(i,resid(2)),1)*(1/(1+ratio1))+Cvertex(Cface(i,up),1)*(ratio1/(1+ratio1));
            new_y=Cvertex(Cface(i,resid(2)),2)*(1/(1+ratio1))+Cvertex(Cface(i,up),2)*(ratio1/(1+ratio1));
            vertex3=[new_x new_y z];
            ratio1=-(Cvertex(Cface(i,resid(1)),3)-z)/(Cvertex(Cface(i,up),3)-z);   
            new_x=Cvertex(Cface(i,resid(1)),1)*(1/(1+ratio1))+Cvertex(Cface(i,up),1)*(ratio1/(1+ratio1));
            new_y=Cvertex(Cface(i,resid(1)),2)*(1/(1+ratio1))+Cvertex(Cface(i,up),2)*(ratio1/(1+ratio1));
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
tri_cross_s=struct('faces',face_tri,'vertice',cross_vertex_tri);
% patch(tri_cross,'FaceColor','blue')

l2=length(cross_vertex_four)/4;
face_four=ones(l2,4);
for i=1:l2
    for j=1:4
        face_four(i,j)=4*(i-1)+j;
    end
end
four_cross_s=struct('faces',face_four,'vertice',cross_vertex_four);
% patch(four_cross_s,'FaceColor','blue')
end