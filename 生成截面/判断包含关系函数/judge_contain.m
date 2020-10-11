function z=judge_contain(xin,yin,xout,yout)
n=length(xin);
for i=1:n
    if inpolygon(xin(i),yin(i),xout,yout)==0
        z=0;
        break;
    end
    z=1;
end
end