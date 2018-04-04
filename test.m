
% Read images that contain different textures.
brickWall = imread('bricks.jpg');
rotatedBrickWall = imread('bricksRotated.jpg');
carpet  = imread('carpet.jpg');

figure
imshow(brickWall)
title('Bricks')

figure
imshow(rotatedBrickWall)
title('Rotated bricks')

figure
imshow(carpet)
title('Carpet')

% Extract LBP features to encode image texture information.
lbpBricks1 = extractLBPFeatures(brickWall,'Upright',false);
lbpBricks2 = extractLBPFeatures(rotatedBrickWall,'Upright',false);
lbpCarpet = extractLBPFeatures(carpet,'Upright',false);

% Compute the squared error between the LBP features. This helps gauge
% the similarity between the LBP features.
brickVsBrick = (lbpBricks1 - lbpBricks2).^2;
brickVsCarpet = (lbpBricks1 - lbpCarpet).^2;

% Visualize the squared error to compare bricks vs. bricks and bricks vs.
% carpet. The squared error is smaller when images have similar texture.
figure
bar([brickVsBrick; brickVsCarpet]', 'grouped')
title('Squared error of LBP Histograms')
xlabel('LBP Histogram Bins')
legend('Bricks vs Rotated Bricks', 'Bricks vs Carpet')
%% HOG
I1 = imread('img/kitti00.png');
re = imresize(I1,[32,96]);
[hog1, visualization] = extractHOGFeatures(re,'CellSize',[8 8]);

imshow(re);

plot(visualization);
   
I2 = imread('img/desk2.png');
tic,corners   = detectFASTFeatures(rgb2gray(I2));toc
strongest = selectStrongest(corners, 10);
tic,[hog2, validPoints, ptVis] = extractHOGFeatures(I2, strongest);toc
figure;
imshow(I2); hold on;
plot(ptVis, 'Color','green');

%% display groundtruth of KITTI poses
% include sequence from 00-10.txt

% read from poses
filename = '../datasets/kitti_poses/05.txt';
fid = fopen(filename);
fseek(fid, 0, 'bof');
lastposition = ftell(fid);
disp(['start position:',num2str(lastposition)]);

groundtruth = [];

while fgetl(fid) ~= -1 % end of line check
    fseek(fid, lastposition, 'bof');
    line = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f\n',1);
    line = [line{:}];
    transform = vec2mat(line,4);
    
    groundtruth = [groundtruth; [transform(1,4), transform(3,4)]];
    lastposition = ftell(fid);
    disp(['lastposition:',num2str(lastposition)]);

end

%  display ground truth
scatter(groundtruth(:,1),groundtruth(:,2));

fclose(fid);
