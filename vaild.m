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
I = imread('img/desk2.png');
tic, bbs=edgeBoxes(I,model,opts); toc % tic toc 测试运算时间
gettedBoxes = bbs;

%% 读取匹配
match = xlsread('100match1.xlsx');

%% draw box
color = ['y','m','c','r','g','b','w'];

for i=1:length(match)
    figure(i);imshow(I);hold on
    boxes = gettedBoxes(match(i,2),:);
    r = rectangle('Position',boxes(1:4));
    r.EdgeColor = rand(1,3);
    r.LineWidth = 2;
 
    saveas(gcf,[int2str(i),'.jpg']);
end
