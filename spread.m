function spread(last,seed)
global HE_edge
global face
global seedface
global j
global temp

next(1)=HE_edge{seed,1}(3);
next(2)=HE_edge{seed,2}(3);
next(3)=HE_edge{seed,3}(3);
id=find(next==last);
next(id)=[];

for ti=1:2
    flag=find(next(ti)==seedface);
    if flag
        j=j+1;
        temp(j)=seedface(flag);
        last=seed;
        seedface(flag)=[];
        spread(last,next(ti));
    end
end

end