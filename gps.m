% city centre 和 new college 的 GPS
gps_ = load('./datasets/NewCollegeGPS.mat');
groundtruth = load('./datasets/NewCollegeGroundTruth.mat');
GPS = gps_.GPS;
truth = groundtruth.truth;
%% 获得 Ground Truth 中的回环
num = length(truth);
loop = [];
for i=1:num
    for j=1:num
        if truth(i,j)==1
            loop = [loop;i];
        end
    end
end
temp = 0;
loop_ = [];
for i=1:length(loop)
    if loop(i)~=temp
        loop_=[loop_;loop(i)];
        temp = loop(i);
    end
end
loop_gps = [];
for i=1:length(loop_)
    loop_gps = [loop_gps;GPS(loop_(i),1),GPS(loop_(i),2)];
end
%%
plot(GPS(:,1),GPS(:,2),'.','color','b');hold on
plot(loop_gps(:,1),loop_gps(:,2),'.','color','g');