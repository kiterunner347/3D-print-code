function idface=seedspread(theta,flag)
%寻找�?要支撑的面并利用种子扩散法分成若干待支撑区域
global HE_edge
global face
global vertex
global seedface

numface=size(face,1);
seedface=zeros(numface,1);
index=1;
for i=1:numface
    face_point=[vertex(face(i,1),:);
                vertex(face(i,2),:);
                vertex(face(i,3),:)];
    if ifsupport(face_point,theta,flag)
        seedface(index)=i;
        index=index+1;
    end
end
seedface(index:end)=[];
% fv=struct('faces',face,'vertice',vertex);
% patch(fv,'FaceColor','green')
% hold on;
% fv=struct('faces',face(seedface',:),'vertice',vertex);
% patch(fv,'FaceColor','red')
% xlabel('x');ylabel('y');zlabel('z');
idface=cell(1,1);
%第i个种子面的序�?,第j区域的种子面序号
global j
i=1;
areaIndex=1;
global temp

while ~isempty(seedface)
    len=length(seedface);j=1;
%     if areaIndex==2
%         fv=struct('faces',face,'vertice',vertex);
%         patch(fv,'FaceColor','green')
%         hold on;
%         fv=struct('faces',face(seedface',:),'vertice',vertex);
%         patch(fv,'FaceColor','red')
%         idface=cell(1,1);
%     end
    temp=zeros(len,1);
    last=seedface(1);
    temp(1)=seedface(1);
    
    seed(1)=HE_edge{seedface(1),1}(3);
    seed(2)=HE_edge{seedface(1),2}(3);
    seed(3)=HE_edge{seedface(1),3}(3);
    seedface(1)=[];
    for k=1:3
        flag=find(seed(k)==seedface);
        if flag
            j=j+1;
            temp(j)=seedface(flag);        
            spread(last,seed(k));
        end
    end
    temp(temp==0)=[];
    if size(temp,1)>0
        idface{areaIndex}=temp;
        areaIndex=areaIndex+1;
    else
        j=j-1;
    end
end

end