numFeatures = 5000 ;
dimension = 10 ;
data = rand(dimension,numFeatures); % 数据集数据

numClusters = 30 ; % GMM中K的大小
[means, covariances, priors] = vl_gmm(data, numClusters);

%%
numDataToBeEncoded = 1000;
dataToBeEncoded = rand(dimension,numDataToBeEncoded); % 要编码的当前帧

%%
encoding = vl_fisher(dataToBeEncoded, means, covariances, priors);