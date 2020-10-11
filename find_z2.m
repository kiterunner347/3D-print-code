function z2=find_z2(D1,S0,S1,i,r)
%֧�����ĸ���Ƭ�ཻ
%��ǰ֧�ŵ��϶˵�ΪD1��������ƬΪS0��������Ƭλ�÷�ΧΪS1��������Ƭ��Ϊm��D1�ڵ�i����Ƭ�ϣ��ƻ����ɵ�֧�Ű뾶Ϊr
S0(i,:)=[];
S1(i,:)=[];

% Բ������Ƿ��ص�
v=[abs(D1(1)-(S1(:,1)+S1(:,3))/2) abs(D1(2)-(S1(:,2)+S1(:,4))/2)];
u=[max(v(:,1)-S1(:,5),0) max(v(:,2)-S1(:,6),0)];
kk=find(u(:,1).^2+u(:,2).^2<r*r);

% Բ���������Ƿ��ص�����bug
% d1=sqrt((S0(:,1)-D1(1)).^2+(S0(:,2)-D1(2)).^2);
% d2=sqrt((S0(:,4)-D1(1)).^2+(S0(:,5)-D1(2)).^2);
% d3=sqrt((S0(:,7)-D1(1)).^2+(S0(:,8)-D1(2)).^2);
% kk1=union(find(d1<r),union(find(d2<r),find(d3<r)));
% 
% L1=(abs((S0(:,2)-S0(:,5))*D1(1)+(S0(:,4)-S0(:,1))*D1(2)+S0(:,1).*S0(:,5)-S0(:,4).*S0(:,2)))./sqrt((S0(:,2)-S0(:,5)).^2+(S0(:,1)-S0(:,4)).^2);
% L2=(abs((S0(:,2)-S0(:,8))*D1(1)+(S0(:,7)-S0(:,1))*D1(2)+S0(:,1).*S0(:,8)-S0(:,7).*S0(:,2)))./sqrt((S0(:,2)-S0(:,8)).^2+(S0(:,1)-S0(:,7)).^2);
% L3=(abs((S0(:,5)-S0(:,8))*D1(1)+(S0(:,7)-S0(:,4))*D1(2)+S0(:,4).*S0(:,8)-S0(:,7).*S0(:,5)))./sqrt((S0(:,5)-S0(:,8)).^2+(S0(:,4)-S0(:,7)).^2);
% n21=(S0(:,4)-S0(:,1)).*(D1(1)-S0(:,1))+(S0(:,5)-S0(:,2)).*(D1(2)-S0(:,2));n12=(S0(:,1)-S0(:,4)).*(D1(1)-S0(:,4))+(S0(:,2)-S0(:,5)).*(D1(2)-S0(:,5));
% n31=(S0(:,7)-S0(:,1)).*(D1(1)-S0(:,1))+(S0(:,8)-S0(:,2)).*(D1(2)-S0(:,2));n13=(S0(:,1)-S0(:,7)).*(D1(1)-S0(:,7))+(S0(:,2)-S0(:,8)).*(D1(2)-S0(:,8));
% n32=(S0(:,7)-S0(:,4)).*(D1(1)-S0(:,4))+(S0(:,8)-S0(:,5)).*(D1(2)-S0(:,5));n23=(S0(:,4)-S0(:,7)).*(D1(1)-S0(:,7))+(S0(:,5)-S0(:,8)).*(D1(2)-S0(:,8));
% %q1=[L1 n21 n12];q2=[L2 n31 n13];q3=[L3 n32 n23];
% kk2=union(intersect(find(L1<r),intersect(find(n21>0),find(n12>0))),...
%     union(intersect(find(L2<r),intersect(find(n31>0),find(n13>0))),...
%     intersect(find(L3<r),intersect(find(n12>0),find(n23>0)))));
% kk=union(kk1,kk2);

% �㣨Բ�ģ��Ƿ����������ڲ�
% D=ones(m,1)*D1(1:2);
% a=[D-S0(:,1:2),zeros(m,1)]';b=[D-S0(:,4:5),zeros(m,1)]';c=[D-S0(:,7:8),zeros(m,1)]';
% t1=cross(a,b);t2=cross(b,c);t3=cross(c,a);
% X=sign(t1(3,:))+sign(t2(3,:))+sign(t3(3,:));
% kk=find(abs(X)==3);

deta=ones(length(kk),1)*D1(3)-(S0(kk(:),3)+S0(kk(:),6)+S0(kk(:),9))/3;
j=min(deta(find(deta>r)));
if isempty(j)
    z2=[D1 D1(1:2) 0];
else
    jj=min(deta(find(deta>3*r)));
    if isempty(jj)
        z2=[];
    else
        k=kk(find(deta==jj));
        z2=[D1 (S0(k,1)+S0(k,4)+S0(k,7))/3 (S0(k,2)+S0(k,5)+S0(k,8))/3 (S0(k,3)+S0(k,6)+S0(k,9))/3];
        %z2=point_in_T(S0(kk(find(deta==j)),:),D1(1),D1(2));
    end
 end
end