% city centre 和 new college 的 Ground truth
%groundtruth = load('../datasets/CityCentreGroundTruth.mat');
groundtruth = load('../datasets/NewCollegeGroundTruth.mat');
truth = groundtruth.truth;
%% 拆分左和右
image = [];
for i=1:2:length(truth)
    for j=1:2:length(truth)
    image(i/2+0.5,j/2+0.5) = truth(i,j);
    end
end
imagesc(image);
