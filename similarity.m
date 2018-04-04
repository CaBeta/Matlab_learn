%% 读取 HOG 特征
feature1 = xlsread('data/100room1.xlsx');
feature2 = xlsread('data/100room3.xlsx');
len = 100;

%% 读取匹配
match = xlsread('100room_match_1-3.xlsx');

%% 计算相似性 
sim = 0;
for i=1:length(match)
    distance = norm(feature1(match(i,1),:) - feature2(match(i,2),:));
    %dist = feature1(match(i,1),:) - feature2(match(i,2),:);
    %figure(i);plot(dist);
    %distance = (feature1(match(i,1),:)*feature2(match(i,1),:)')/(norm(feature1(match(i,1),:))*norm(feature2(match(i,1),:)));
    %disp(distance);
    sim = sim + 1.5/(1.5+distance);
    %sim = sim +(1-distance);
end
sim = sim/len;
