
%% load pre-trained edge detection model and set opts (see edgesDemo.m)
model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

%% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .65;     % step size of sliding window search
opts.beta  = .75;     % nms threshold for object proposals
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 100;  % max number of boxes to detect

%% detect Edge Box bounding box proposals (see edgeBoxes.m)
%I = imread('peppers.png');
I = imread('img/room2.jpg');
tic, bbs=edgeBoxes(I,model,opts); toc % tic toc ≤‚ ‘‘ÀÀ„ ±º‰
gettedBoxes = bbs;

%% draw box
color = ['y','m','c','r','g','b','w'];
figure(1);imshow(I);hold on
for i=1:length(gettedBoxes)
    boxes = gettedBoxes(i,:);
    r = rectangle('Position',boxes(1:4));
    r.EdgeColor = rand(1,3);
    r.LineWidth = 3;
end

%% computeHOG
featureMatrix = [];
for i=1:length(gettedBoxes)
    boxes = gettedBoxes(i,:);
    resizedImg = imresize(imcrop(I,boxes(1:4)),[32 32],'nearest');
    tic,[feature,] = extractHOGFeatures(resizedImg,'CellSize',[8,8]);toc
    featureMatrix = [featureMatrix;feature];
end

%% output
xlswrite('data/100room2.xlsx',featureMatrix);