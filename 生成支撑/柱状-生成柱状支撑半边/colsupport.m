function [Cface,Cvertex]=colsupport(csp,r)
%得到的Cvertex每行为一个参与生成支撑的点的xyz坐标，格式与vertex相同
%得到的Cface每行为三个构成的一个面片的点的代号，格式与face相同
Cface=[];Cvertex=[];k=0;
for i=1:length(csp)
      if csp(i,3)-csp(i,6)>3*r
          k=k+1;
          [u_sp,v_sp,w_sp]=cylinder(r);
          u_sp=[transpose(u_sp(1,1:20))+csp(i,1);transpose(u_sp(2,1:20))+csp(i,1)];
          v_sp=[transpose(v_sp(1,1:20))+csp(i,2);transpose(v_sp(2,1:20))+csp(i,2)];
          w_sp=transpose([w_sp(1,1:20) w_sp(2,1:20)])*(csp(i,3)-csp(i,6)-3*r)+csp(i,6)+2*r;
          Cvertex=[Cvertex;csp(i,4:6);u_sp v_sp w_sp;csp(i,1:3)];%构成支撑的点信息
          base=zeros(20,3);top=zeros(20,3);side=zeros(40,3);
          for j=1:19
              base(j,:)=[(k-1)*42+1 (k-1)*42+j+2 (k-1)*42+j+1];
              top(j,:)=[k*42 (k-1)*42+j+21 (k-1)*42+j+22];
              side([2*j-1 2*j],:)=[(k-1)*42+j+1 (k-1)*42+j+2 (k-1)*42+j+21;(k-1)*42+j+2 (k-1)*42+j+22 (k-1)*42+j+21];
          end
          base(20,:)=[(k-1)*42+1 (k-1)*42+2 (k-1)*42+21];
          top(20,:)=[k*42 (k-1)*42+41 (k-1)*42+22];
          side([39 40],:)=[(k-1)*42+21 (k-1)*42+2 (k-1)*42+41;(k-1)*42+2 (k-1)*42+22 (k-1)*42+41];
          Cface=[Cface;base;side;top];
      end
end
end