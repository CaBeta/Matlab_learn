numFeatures = 5000 ;
dimension = 10 ;
data = rand(dimension,numFeatures); % ���ݼ�����

numClusters = 30 ; % GMM��K�Ĵ�С
[means, covariances, priors] = vl_gmm(data, numClusters);

%%
numDataToBeEncoded = 1000;
dataToBeEncoded = rand(dimension,numDataToBeEncoded); % Ҫ����ĵ�ǰ֡

%%
encoding = vl_fisher(dataToBeEncoded, means, covariances, priors);