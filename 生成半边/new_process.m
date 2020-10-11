function HE_edge=new_process(face,vertex)
%n个点，m个面
m=length(face);
numpoint=length(vertex);

% time1=toc
%HE_edge=('initial_point','next_point','pair对边的半边坐标(i,j)',...
%'Next_Edge下一条边的半边坐标(i,j)');
%%'Next_Edge'中含有'face'信息，可以省略
HE_edge=cell(m,3);
for i=1:m
    HE_edge{i,1}=[face(i,3),face(i,1),0,0,i,2,0,0];
    HE_edge{i,2}=[face(i,1),face(i,2),0,0,i,3,0,0];
    HE_edge{i,3}=[face(i,2),face(i,3),0,0,i,1,0,0];
end

% time2=toc
%求取配对半边
map=cell(numpoint,1);
for i=1:m
    for j=1:3
        %填充地图
        matrix=map{HE_edge{i,j}(2)};
        if isempty(matrix)
            %查看所需寻找的列表是不是空集
           map{HE_edge{i,j}(1)}=[map{HE_edge{i,j}(1)};
                                  HE_edge{i,j}(2),i,j];
        else
            %查看列表不是空集，在该集合中查找是否有对应的半边
            temp=find(matrix(:,1)==HE_edge{i,j}(1));
            if isempty(temp)
                map{HE_edge{i,j}(1)}=[map{HE_edge{i,j}(1)};
                                       HE_edge{i,j}(2),i,j];
            else
                %该元胞的第temp行应为所匹配的半边
                num=matrix(temp,2:3);
                HE_edge{i,j}(3:4)=num;
                HE_edge{num(1),num(2)}(3:4)=[i,j];
            end
        end
    end
end
% time3=toc

for j=1:3
    for i=1:m
        if HE_edge{i,j}(3)==0
            fprintf('error!');%没有找到匹配的半边
            break;
        end
    end
end

% i=3;j=3;
% pos=HE_edge{i,j}(3:4);
% HE_edge{i,j}(1:2)
% HE_edge{pos(1),pos(2)}(1:2)
end
