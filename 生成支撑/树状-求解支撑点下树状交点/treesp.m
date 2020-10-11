function tspp=treesp(spoint,phi)
%找到支撑的结�?,num为若干层支撑
area=length(spoint);
tspp=cell(1,area);
threshold=0;
for kk=1:area
    %对于第kk个局部最小区域进行支撑的生成
    num=1;
    len=size(spoint{kk},1);
    while len>2^num
        num=num+1;
    end
    num=num+1;
    %读取第kk个区域点的数�?
    clear tsp
    tsp{1}=spoint{kk}(:,2:4);
    
    index=1;
    for i=1:num-1
        %生成下一层支�?,mylength为上�?步的支撑点数
        mylength=size(tsp{i},1);
        if mylength==1
            break;
        end
        flag=mod(mylength,2);
        mylength=floor((mylength+1)/2);
        temp=zeros(mylength-1,3);
        tin=1;

        for j=1:mylength-1
            p1=tsp{i}(2*j-1,1:3);
            p2=tsp{i}(2*j,1:3);
            temp(tin,3)=0.5*(p1(3)+p2(3)-cot(phi)*norm(p1(1:2)-p2(1:2)));
            %去除支撑过低的部�?
            if temp(tin,3)<=threshold
                temp(tin,:)=[];
                continue;
            end
            r1=(p1(3)-temp(tin,3))*tan(phi);
            r2=(p2(3)-temp(tin,3))*tan(phi);
            temp(tin,1)=r1/(r1+r2)*(p1(1)-p2(1))+p2(1);
            temp(tin,2)=r2/(r1+r2)*(p1(2)-p2(2))+p2(2);
            temp(tin,4)=2*j-1;
            temp(tin,5)=2*j;
            tin=tin+1;
        end
        
        if flag
            %flag判断是否多出�?个支撑点
            p1=tsp{i}(2*j,1:3);
            p2=tsp{i}(2*j+1,1:3);
            temp(end+1,3)=0.5*(p1(3)+p2(3)-cot(phi)*norm(p1(1:2)-p2(1:2)));
            if temp(end,3)<=threshold
                temp(end,:)=[];
            else
                r1=(p1(3)-temp(end,3))*tan(phi);
                r2=(p2(3)-temp(end,3))*tan(phi);
                temp(end,1)=r1/(r1+r2)*(p1(1)-p2(1))+p2(1);
                temp(end,2)=r2/(r1+r2)*(p1(2)-p2(2))+p2(2);
                temp(end,4)=2*j;
                temp(end,5)=2*j+1;
            end
        end
        if ~isempty(temp)
            tsp{index+1}=temp;
            index=index+1;
        else
            break;
        end
    end
    tspp{kk}=tsp;
end

end