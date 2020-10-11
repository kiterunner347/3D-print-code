function spoint=samplep(idface)
%划分区域重新采样得到支撑�?
global HE_edge
global face
global vertex
global trunk 
idlen=length(idface);
spoint=cell(1,idlen);
for i=1:idlen
    %划分区域
    A=[vertex(face(idface{i},1),1),vertex(face(idface{i},2),1),vertex(face(idface{i},3),1)];
    xface=[min(A,[],2),max(A,[],2)];
    xmin=min(xface(:,1));xmax=max(xface(:,2));
    B=[vertex(face(idface{i},1),2),vertex(face(idface{i},2),2),vertex(face(idface{i},3),2)];
    yface=[min(B,[],2),max(B,[],2)];
    ymin=min(yface(:,1));ymax=max(yface(:,2));
    x=linspace(xmin,xmax,max([floor((xmax-xmin)/trunk) 2]));
    %x(1)=[];x(end)=[];
    y=linspace(ymin,ymax,max([floor((ymax-ymin)/trunk) 2]));
    %y(1)=[];y(end)=[];
    
    %找到原来对应的点
    xlen=length(x);
    ylen=length(y);
    temp=zeros(xlen*ylen,4);
    index=1;
    tempid=idface{i};
    for j=1:ylen
        for k=1:xlen
            xlabel=find(x(k)>=xface(:,1) & x(k)<=xface(:,2));
            ylabel=find(y(j)>=yface(:,1) & y(j)<=yface(:,2));
            %由网格点得到的最有可能含有该网格点的面，取交集得�?
            inter=intersect(xlabel,ylabel);
            if ~isempty(inter)
                %判断具体在哪个面
                for pp=1:length(inter)
                    tempface=face(tempid(inter(pp)),:);
                    in=inpolygon(x(k),y(j),vertex(tempface,1),vertex(tempface,2));
                    if in
                        inter=tempid(inter(pp));
                        pp=pp-1;
                        break;
                    end
                end
                if pp==length(inter)
                    %fprintf('Error!\n');
                    continue;
                end
                
                temp(index,1)=inter;
                %由面的两个向量求得z�?
                vex1=vertex(face(inter,2),:)-vertex(face(inter,1),:);
                vex2=vertex(face(inter,3),:)-vertex(face(inter,1),:);
                base=vertex(face(inter,1),:);
                Kp=[vex1(1:2)',vex2(1:2)']\([x(k);y(j)]-base(1:2)');
                temp(index,2:4)=Kp'*[vex1;vex2]+vertex(face(inter,1),:);
                index=index+1;
            end
        end
    end
    temp(temp(:,1)==0,:)=[];
    spoint{i}=temp;
end

end