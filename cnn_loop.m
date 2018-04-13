% city centre CNN ����
clear;
run ../matconvnet-1.0-beta25/matlab/vl_setupnn ; %
%% ����ģ��
net = load('../imagenet-vgg-verydeep-16.mat') ;
net = vl_simplenn_tidy(net) ;

%% ��ȡͼƬ 
featureVector = [];
for i=1:2:2474
%for i=1:2:2146
    I = imread(['../datasets/CityCentre/',getName(i,4),'.jpg']);
    im_ = single(I) ; % note: 255 range
    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
    im_ = im_ - net.meta.normalization.averageImage ;
    tic,res = vl_simplenn(net, im_) ;toc
    feature_CNN = reshape(res(33).x,[1,4096]);
     %resizedImg = imresize(I,[32 32],'nearest');
     %tic,[feature_hog,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
    featureVector = [featureVector;feature_CNN];
end

%% PCA
[coeff,score,latent] = pca(featureVector);
feature_pca = score(:,1:512);
%% ����������
differenceMatrix = [];
for i=1:1237 %1237 1073
    differenceVector = []; 
    for j=1:1237 %1237 1073
        feature1 = feature_pca(i,:);
        feature2 = feature_pca(j,:);
        %difference = norm(feature1-feature2);
        difference = (feature1*feature2')/(norm(feature1)*norm(feature2));
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
            if X(i)>imageNum
                X(i) = imageNum;
            end
            W(i) = simMatrix(X(i),t); % Ȩ��Ϊ��ǰ��������ͼ�������λ��ͼ������ƶ�
            X_b = [X_b;X(i),W(i)]; % ���ز���ǰ��������λ�ú�Ȩ��
        end
        for i=1:M % �ز���
            alphabet = X_b(:,1)'; prob = W/sum(W);
            x_i = randsrc(1,1,[alphabet; prob]);
            X(i) = x_i;
        end
        for i=1:ceil(M*a) % ��������������ӣ����������
            j = unidrnd(N,1); % ������ɴ�1��N����ɢֵ
            k = unidrnd(M,1); % ������ɴ�1��M����ɢֵ
            X(k) = j;
        end
    end
    x_t = mode(X);
    if t - x_t > 10 && simMatrix(x_t,t)>0.75 %sum(X==x_t)>M/20
        loop = [loop;x_t,t];
    else
        N = N+1;
    end
    t = t+1;
end
%% ��ͼ
plot(loop(:,1),loop(:,2),'.');
