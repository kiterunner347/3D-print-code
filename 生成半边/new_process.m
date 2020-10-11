function HE_edge=new_process(face,vertex)
%n���㣬m����
m=length(face);
numpoint=length(vertex);

% time1=toc
%HE_edge=('initial_point','next_point','pair�Աߵİ������(i,j)',...
%'Next_Edge��һ���ߵİ������(i,j)');
%%'Next_Edge'�к���'face'��Ϣ������ʡ��
HE_edge=cell(m,3);
for i=1:m
    HE_edge{i,1}=[face(i,3),face(i,1),0,0,i,2,0,0];
    HE_edge{i,2}=[face(i,1),face(i,2),0,0,i,3,0,0];
    HE_edge{i,3}=[face(i,2),face(i,3),0,0,i,1,0,0];
end

% time2=toc
%��ȡ��԰��
map=cell(numpoint,1);
for i=1:m
    for j=1:3
        %����ͼ
        matrix=map{HE_edge{i,j}(2)};
        if isempty(matrix)
            %�鿴����Ѱ�ҵ��б��ǲ��ǿռ�
           map{HE_edge{i,j}(1)}=[map{HE_edge{i,j}(1)};
                                  HE_edge{i,j}(2),i,j];
        else
            %�鿴�б��ǿռ����ڸü����в����Ƿ��ж�Ӧ�İ��
            temp=find(matrix(:,1)==HE_edge{i,j}(1));
            if isempty(temp)
                map{HE_edge{i,j}(1)}=[map{HE_edge{i,j}(1)};
                                       HE_edge{i,j}(2),i,j];
            else
                %��Ԫ���ĵ�temp��ӦΪ��ƥ��İ��
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
            fprintf('error!');%û���ҵ�ƥ��İ��
            break;
        end
    end
end

% i=3;j=3;
% pos=HE_edge{i,j}(3:4);
% HE_edge{i,j}(1:2)
% HE_edge{pos(1),pos(2)}(1:2)
end
