% Monte Carlo Localization
% 使用粒子滤波算法寻找潜在回环

%% 准备图像
rootDir = 'E:\MATLAB_ws\datasets\CityCentre';
imageList = dir(rootDir);
imageLeft = {};
for i=3:2:length(imageList)
    imageName = [rootDir,imageList(i).name];
    imageLeft{i/2-0.5}=imageName;
end

%% 计算回环
N = 0; % 节点
t = 1; % 步数
imageNum = length(imageLeft); % 图像数量
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
        for i=1:M % 移动
            alphabet = [0 1 2 3]; prob = [0.1 0.7 0.1 0.1];
            r = randsrc(1,1,[alphabet; prob]);
            X(i) = X(i) + r;
            W(i) = computeSim(imageLeft{X(i)},imageLeft{t}); % 权重为当前所看到的图像和粒子位置图像的相似度
            X_b = [X_b;X(i),W(i)]; % 在重采样前保存粒子位置和权重
        end
        X = [];
        for i=1:M % 重采样
            alphabet = X; prob = W/sum(W);
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

%% 画图