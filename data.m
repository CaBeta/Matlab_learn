%% 读取文件
%{
x=[];
y=[];
o=[];
for i=0:645
    fid = fopen(['../datasets/UofA_dataset/day_evening/day/',int2str(i),'.txt']);
    file = textscan(fid,'%s%f');
    x=[x;file{2}(2)];
    y=[y;file{2}(3)];
    o=[o;file{2}(8)];
    fclose(fid);
end
x2=[];
y2=[];
o2=[];
for i=0:645
    fid = fopen(['../datasets/UofA_dataset/day_evening/evening/',int2str(i),'.txt']);
    file = textscan(fid,'%s%f');
    x2=[x2,file{2}(2)];
    y2=[y2,file{2}(3)];
    o2=[o2,file{2}(8)];
    fclose(fid);
end
%transform = ([x2(1),y2(1);x2(2),y2(2)]^-1)*([x(1),y(1);x(2),y(2)]);
%tmp = [x2,y2]*transform;
transform = [cos(1),-sin(1);sin(1),cos(1)];
tmp=transform*[x2;y2];
%}
fid = fopen('../datasets/rgbd_dataset_freiburg2_desk/groundtruth2.txt');
file = textscan(fid,'%f%f%f%f%f%f%f%f');
x=file{2};
y=file{3};
z=file{4};
fclose(fid);

%% 画轨迹
figure(1);plot(x,y);
figure(2);scatter3(x,y,z)
%plot(tmp(1,:),tmp(2,:),'.');
%% 检查回环
threshold = 0.3;
x_loop = [];
y_loop = [];
for i=1:646
    for j=1:646
        dis = (x(j)-x(i))^2 + (y(j)-y(i))^2;
        o_dis = (o(j)-o(i))^2;
        if dis>0 && dis<threshold && o_dis<0.2
            x_loop = [x_loop;x(i)];
            y_loop = [y_loop;y(i)];
            disp([i,j]);
        end
    end
end
plot(x_loop,y_loop,'*');