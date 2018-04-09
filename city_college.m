% city centre �� college ����
clear;
%% ��ȡͼƬ
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

%% ����������
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

%% ��һ��
differenceMatrix = mapminmax(differenceMatrix,0,1);
imagesc(differenceMatrix);
colormap Hot
colorbar
%% ȡ��
simMatrix = (1-differenceMatrix);
imagesc(simMatrix);
colormap Hot
colorbar
%% ��ͼ
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
%% ����ػ�
N = 0; % �ڵ�
t = 1; % ����
imageNum = 1237; % ͼ������
X = []; % ����
W = []; % Ȩ��
a = 0.5; % ������������ϵ��
X_b = []; % ��ʱ���Ӽ�
M = 200; % ������
loop = []; % �ػ�
while t < imageNum
    if t == 1
        N = N+1;
        for i=1:M
            X(i) = N; % ��ʼ��
        end
    else
        X_b = [];
        for i=1:M % �ƶ�
            alphabet = [0 1 2 3]; prob = [0.1 0.7 0.1 0.1];
            r = randsrc(1,1,[alphabet; prob]);
            X(i) = X(i) + r;
            W(i) = simMatrix(X(i),t); % Ȩ��Ϊ��ǰ��������ͼ�������λ��ͼ������ƶ�
            X_b = [X_b;X(i),W(i)]; % ���ز���ǰ��������λ�ú�Ȩ��
        end
        X = [];
        for i=1:M % �ز���
            alphabet = X_b(:,1)'; prob = W/sum(W);
            x_i = randsrc(1,1,[alphabet; prob]);
            X = [X,x_i];
        end
        for i=1:ceil(M*a) % ��������������ӣ����������
            j = unidrnd(N,1); % ������ɴ�1��N����ɢֵ
            k = unidrnd(M,1); % ������ɴ�1��M����ɢֵ
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