% city centre �� new college �� Ground truth
%groundtruth = load('../datasets/CityCentreGroundTruth.mat');
groundtruth = load('../datasets/NewCollegeGroundTruth.mat');
truth = groundtruth.truth;
%% ��������
image = [];
for i=1:2:length(truth)
    for j=1:2:length(truth)
    image(i/2+0.5,j/2+0.5) = truth(i,j);
    end
end
imagesc(image);
