function idface=slice(vertex,HE_edge,face,m,theta)
%��Ƭ�ز������õ�ÿһ�����Ƭ��Ϣ,mΪ����,���õ���Ҫ֧�ŵ���
mymax=max(vertex(:,3))-1e-5;
mymin=min(vertex(:,3))+1e-5;
z=linspace(mymin,mymax,m);

%��ÿ�����zmax,zmin
A=[vertex(face(:,1),3),vertex(face(:,2),3),vertex(face(:,3),3)];
zface=[min(A,[],2),max(A,[],2)];

%�ҵ�һ���汻��Ƭi�е�,idfaceΪ[������ı��;���ߵ��б��]
idface=cell(m,1);
for i=1:m
    %�ҵ����б�����
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