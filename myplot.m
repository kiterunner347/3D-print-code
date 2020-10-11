clear;clc;
data=importdata('plane.txt')

n=1;
while data.textdata{n}~='f'
    n=n+1;
end

figure(1);
hold on;axis equal;
tri=length(data.textdata);
for i=n:10:tri
    p=data.data(i,:);
    triplot(data.data(p(1),:),data.data(p(2),:),data.data(p(3),:));
end