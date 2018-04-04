% city centre≤‚ ‘
clear;
%% ∂¡»°Õº∆¨
% Parameters:
clear param
param.imageSize = [60 60]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;

featureVector = [];
for i=1:2:2474
     I = imread(['../datasets/CityCentre/',getName(i,4),'.jpg']);
%     tic,[feature_gist, param] = LMgist(I, '', param);toc
     resizedImg = imresize(I,[32 32],'nearest');
     tic,[feature_hog,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
     featureVector = [featureVector;feature_hog];
end

%% PCA
[feature_pca,] = pca(featureVector,40);

%% º∆À„æ‡¿Îæÿ’Û
differenceMatrix = [];
for i=1:1237
    differenceVector = [];
    for j=1:1237
        feature1 = feature_pca(i,:);
        feature2 = feature_pca(j,:);
        difference = norm(feature1-feature2);
        %difference = (feature1*feature2')/(norm(feature1)*norm(feature2));
        differenceVector = [differenceVector,difference];
    end
    differenceMatrix = [differenceMatrix;differenceVector];
end

%% πÈ“ªªØ
differenceMatrix = mapminmax(differenceMatrix,0,1);
imagesc(differenceMatrix);
colormap Hot
colorbar

%% ª≠Õº
display = [];
Points = [];
for i=1:663
    for j=1:663
        if differenceMatrix(i,j)<0.2 && abs(i-j)>5
            display(i,j)=0;
            Points = [Points;i,j];
        else
            display(i,j)=1;
        end
    end
    
end
scatter(Points(:,1),Points(:,2),'*');
%imagesc(display);
%colormap Hot
%colorbar