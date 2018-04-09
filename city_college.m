% city centre 和 college 测试
clear;
%% 读取图片
% Parameters:
clear param
param.imageSize = [60 60]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;

featureVector = [];
for i=1:2:2474
%for i=1:2:2146
     I = imread(['../datasets/CityCentre/',getName(i,4),'.jpg']);
%     tic,[feature_gist, param] = LMgist(I, '', param);toc
     resizedImg = imresize(I,[32 32],'nearest');
     tic,[feature_hog,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
     featureVector = [featureVector;feature_hog];
end

%% PCA
[feature_pca,] = pca(featureVector,40);

%% 计算距离矩阵
differenceMatrix = [];
for i=1:1237 %1237 1073
    differenceVector = []; 
    for j=1:1237 %1237 1073
        feature1 = feature_pca(i,:);
        feature2 = feature_pca(j,:);
        difference = norm(feature1-feature2);
        %difference = (feature1*feature2')/(norm(feature1)*norm(feature2));
        differenceVector = [differenceVector,difference];
    end
    differenceMatrix = [differenceMatrix;differenceVector];
end

%% 归一化
differenceMatrix = mapminmax(differenceMatrix,0,1);
imagesc(differenceMatrix);
colormap Hot
colorbar
%% 取反
simMatrix = (1-differenceMatrix);
imagesc(simMatrix);
colormap Hot
colorbar
%% 画图
display = [];
Points = [];
for i=1:1237
    for j=1:1237
        if differenceMatrix(i,j)<0.30 && abs(i-j)>10
            display(i,j)=0;
        else
            display(i,j)=1;
        end
    end
    
end
imagesc(display);
colormap Hot
colorbar
%% 计算回环
N = 0; % 节点
t = 1; % 步数
imageNum = 1237; % 图像数量
X = []; % 粒子
W = []; % 权重
a = 0.5; % 粒子重新生成系数
X_b = []; % 临时粒子集
M = 200; % 粒子数
loop = []; % 回环
while t < imageNum
    if t == 1
        N = N+1;
        for i=1:M
            X(i) = N; % 初始化
        end
    else
        X_b = [];
        for i=1:M % 移动
            alphabet = [0 1 2 3]; prob = [0.1 0.7 0.1 0.1];
            r = randsrc(1,1,[alphabet; prob]);
            X(i) = X(i) + r;
            W(i) = simMatrix(X(i),t); % 权重为当前所看到的图像和粒子位置图像的相似度
            X_b = [X_b;X(i),W(i)]; % 在重采样前保存粒子位置和权重
        end
        X = [];
        for i=1:M % 重采样
            alphabet = X_b(:,1)'; prob = W/sum(W);
            x_i = randsrc(1,1,[alphabet; prob]);
            X = [X,x_i];
        end
        for i=1:ceil(M*a) % 随机重新生成粒子（添加噪声）
            j = unidrnd(N,1); % 随机生成从1到N的离散值
            k = unidrnd(M,1); % 随机生成从1到M的离散值
            X(k) = j;
        end
    end
    x_t = mode(X);
    if abs(x_t - t) > 10
        loop = [loop;x_t,t];
    else
        N = N+1;
    end
    t = t+1;
end