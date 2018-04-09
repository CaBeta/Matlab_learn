% Monte Carlo Localization
% ʹ�������˲��㷨Ѱ��Ǳ�ڻػ�

%% ׼��ͼ��
rootDir = 'E:\MATLAB_ws\datasets\CityCentre';
imageList = dir(rootDir);
imageLeft = {};
for i=3:2:length(imageList)
    imageName = [rootDir,imageList(i).name];
    imageLeft{i/2-0.5}=imageName;
end

%% ����ػ�
N = 0; % �ڵ�
t = 1; % ����
imageNum = length(imageLeft); % ͼ������
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
        for i=1:M % �ƶ�
            alphabet = [0 1 2 3]; prob = [0.1 0.7 0.1 0.1];
            r = randsrc(1,1,[alphabet; prob]);
            X(i) = X(i) + r;
            W(i) = computeSim(imageLeft{X(i)},imageLeft{t}); % Ȩ��Ϊ��ǰ��������ͼ�������λ��ͼ������ƶ�
            X_b = [X_b;X(i),W(i)]; % ���ز���ǰ��������λ�ú�Ȩ��
        end
        X = [];
        for i=1:M % �ز���
            alphabet = X; prob = W/sum(W);
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

%% ��ͼ