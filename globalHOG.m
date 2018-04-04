
%% 读取图片
%{
fid = fopen('./keyframe/keyframes.txt');
featureVector = [];
tline = fgetl(fid);
while ischar(tline)
    I = imread(['./keyframe/',tline,'.png']);
    resizedImg = imresize(I,[32 32],'nearest');
    tic,[feature,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
    featureVector = [featureVector;feature];
    %imgVector = [imgVector;tline]
    tline = fgetl(fid);
end
fclose(fid);
%}
%{
corrupt = load('../datasets/UofA_dataset/day_evening/day/corrupt');
featureVector = [];
for i=0:645
    I = imread(['../datasets/UofA_dataset/day_evening/day/',int2str(i),'.jpg']);
    resizedImg = imresize(I,[32 32],'nearest');
    tic,[feature,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
    featureVector = [featureVector;feature];
end
%}
% Parameters:
clear param
param.imageSize = [60 60]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;

fid = fopen('../datasets/malaga-urban-dataset-extract-07_all-sensors_IMAGES.txt');
tline = fgetl(fid);
featureVector = [];
featureVector2 = [];
while ischar(tline)
    try
        if tline(31:35)=='right'
            I = imread(['../datasets/malaga-urban-dataset-extract-07_rectified_800x600_Images/',tline]);
            resizedImg = imresize(I,[32 32],'nearest');
            %tic,[feature, param] = LMgist(I, '', param);toc
            tic,[feature,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
            featureVector2 = [featureVector2;feature];
            tline = fgetl(fid);
            tline = fgetl(fid);
            tline = fgetl(fid);
            continue
        end
        I = imread(['../datasets/malaga-urban-dataset-extract-07_rectified_800x600_Images/',tline]);
    catch
        tline = fgetl(fid);
        tline = fgetl(fid);
        tline = fgetl(fid);
        continue
    end
    resizedImg = imresize(I,[32 32],'nearest');
    %tic,[feature, param] = LMgist(I, '', param);toc
    tic,[feature,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
    featureVector = [featureVector;feature];
    %imgVector = [imgVector;tline]
    tline = fgetl(fid);
    tline = fgetl(fid);
    tline = fgetl(fid);
end
fclose(fid);

%{
fid = fopen('../datasets/rgbd_dataset_freiburg2_pioneer_360/associate.txt');
file = textscan(fid,'%s%s%s%s');
name = file{2};
featureVector = [];
for i=1:3:830
    I = imread(['../datasets/rgbd_dataset_freiburg2_pioneer_360/',char(file{2}(i))]);
    resizedImg = imresize(I,[32 32],'nearest');
    tic,[feature,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
    featureVector = [featureVector;feature];
end
%}
%{
featureVector = [];
featureVector2 = [];
for i=1:3:2760
    I = imread(['../datasets/05/image_0/',getName(i,6),'.png']);
    resizedImg = imresize(I,[32 96],'nearest');
    tic,[feature,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
    featureVector = [featureVector;feature];
end
for i=1:3:2760
    I = imread(['../datasets/05/image_1/',getName(i,6),'.png']);
    resizedImg = imresize(I,[32 96],'nearest');
    tic,[feature,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
    featureVector2 = [featureVector2;feature];
end
%}
%% PCA
[feature_pca,] = pca(featureVector,40);
[feature_pca2,] = pca(featureVector2,40);
%feature_pca = featureVector;
%% 计算相似性

simMatrix = [];
for i=1:663
    simVector = [];
    for j=1:663
        feature1 = feature_pca(i,:);feature2 = feature_pca(j,:);
        %feature12 = feature_pca2(i,:);feature22 = feature_pca2(j,:);
        %similar = (feature1*feature2')/(norm(feature1)*norm(feature2));
        similar = norm(feature1-feature2);
        %if similar<0 && (feature12*feature22')<0
        %    similar = -similar;
        %end
        %similar = similar*((feature12*feature22')/(norm(feature12)*norm(feature22)));
%         if similar>0.6 && similar<0.9
%             disp([i,j]);
%         end
        simVector = [simVector,similar];
    end
    simMatrix = [simMatrix;simVector];
end
simMatrix = mapminmax(simMatrix,0,1);
image(simMatrix,'CDataMapping','scaled');colorbar

%% 分析
Points = [];
display = [];
for i=1:663
    for j=1:663
        if simMatrix(i,j)<0.2 && abs(i-j)>10
            Points = [Points;i,j];
             display(i,j)=0;
        else
             display(i,j)=1;
        end
    end
end
imagesc(display);
colormap Hot
colorbar
%scatter(Points(:,1),Points(:,2),'*');