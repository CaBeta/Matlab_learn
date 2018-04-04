%% 读取 HOG 特征
feature1 = xlsread('data/100room1.xlsx');
feature2 = xlsread('data/100room2.xlsx');
len = 100; %50

%% 计算距离 & 匹配
matchMatrix1to2 = [];
matchMatrix2to1 = [];
for i=1:len
    local = feature1(i,:);
    min = 100;
    minNum = 0;
    for j=1:len
        %distance = 1-(local*feature2(j,:)')/(norm(local)*norm(feature2(j,:)));
        distance = norm(local-feature2(j,:));
        disp(distance)
        if(distance<min)
            min = distance;
            minNum = j;
        end
    end
    matchMatrix1to2 = [matchMatrix1to2;minNum];
end
for i=1:len
    local = feature2(i,:);
    min = 100;
    minNum = 0;
    for j=1:len
        %distance = 1-(local*feature1(j,:)')/(norm(local)*norm(feature1(j,:)));
        distance = norm(local-feature1(j,:));
        if(distance<min)
            min = distance;
            minNum = j;
        end
    end
    matchMatrix2to1 = [matchMatrix2to1;minNum];
end

%% 交叉验证
output = [];
for i=1:len
    if(matchMatrix2to1(matchMatrix1to2(i)) == i)
        output = [output;i,matchMatrix1to2(i)];
    end
end
%% output
xlswrite('100room_match_1-2.xlsx',output);