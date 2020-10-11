function idface=slice(vertex,HE_edge,face,m,theta)
%切片重采样，得到每一层的切片信息,m为层数,并得到需要支撑的面
mymax=max(vertex(:,3))-1e-5;
mymin=min(vertex(:,3))+1e-5;
z=linspace(mymin,mymax,m);

%求每个面的zmax,zmin
A=[vertex(face(:,1),3),vertex(face(:,2),3),vertex(face(:,3),3)];
zface=[min(A,[],2),max(A,[],2)];

%找到一个面被切片i切到,idface为[被切面的编号;交线的列编号]
idface=cell(m,1);
for i=1:m
    %找到所有被切面
    idface{i}=find(zface(:,1)<z(i) & zface(:,2)>z(i));
    if isempty(idface{i})
        continue;
    end
    len=length(idface{i});
    for j=1:len
        id=idface{i}(j);
        temp=idface{i};
        face_point=[vertex(face(id,1),:);
                    vertex(face(id,2),:);
                    vertex(face(id,3),:)];
        if ~ifsupport(face_point,theta)
            temp(j)=[];
        end
    end
    idface{i}=temp;
end

end