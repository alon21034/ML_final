%% ML final



%% ReadImage

[dataY, dataX] = libsvmread('ml2013final_train.dat');
[testY, testX] = libsvmread('ml2013final_test1.nolabel.dat');

dataX = [dataX;testX];
dataY = [dataY;testY];

x = reshape(full(dataX)', [105, 122, size(dataX, 1)]);
x = x(5:101, 5:118, :);
y = reshape(full(dataY)', [1, size(dataX, 1)]);


%% Bagging

% [dataY, dataX] = libsvmread('ml2013final_train.dat');
% [testY, testX] = libsvmread('ml2013final_test1.nolabel.dat');

% x = reshape(full(dataX)', [105, 122, size(dataX, 1)]);
% x = x(5:101, 5:118, :);
% y = reshape(full(dataY)', [1, size(dataX, 1)]);
% 
% bag_num = 19600;
% [addY, addX] = getRandomData(y', x, bag_num);
% x = cat(3, x, addX);
% y = [y addY'];
% 
% x_test = reshape(full(testX)', [105, 122, size(testX, 1)]);
% x_test = x_test(5:101, 5:118, :);
% y_test = reshape(full(testY)', [1, size(testX, 1)]);
% 
% x = cat(3,x, x_test);
% y = [y y_test];

%% image processing & scale
% mkdir('processed')
save_orig_image = 0;
threshold_init = 0.15;
threshold_resize = 0.01;
train_num = size(x, 3);
orig_width = size(x, 1);
orig_height = size(x, 2);
scaled_width = 40;
scaled_height = 40;

%% export original image
%mkdir('image');

% if (save_orig_image == 1)
%     for i = 1:train_num
%         img = mat2gray(x(:,:,i)');
%         fileName = strcat('./image/', num2str(i), '_origin.png');
%         imwrite(img, fileName);
%     end
% end

% dim_num = 952+64+1;
dim_num = 6400;

features = zeros(train_num, dim_num);


for i = 1:train_num;
    
    i
    
%     img = mat2gray(x(:,:,i)');
% 
%     img = getFitImage(img);
%     img = imresize(img, [scaled_width scaled_height]);
% 
%     th = graythresh(img);
%     binary_img = img > 0.5*th;

%     a = getBDD(binary_img); %16*8 = 128
%     b = getZoningDensity(binary_img); %16
%     b = reshape(b, [1 16]);
%     c = sum(sort(binary_img));  % scaled_width
%     d = sum(sort(binary_img'));  % scaled_height
%     e = getDistanceProfile(binary_img);  %scaled_width*4
%     e = reshape(e, [1 scaled_width*4]);
%     
    f = getRemoveArea(mat2gray(x(:,:,i)'));  % 1
%     g = getMaxSwitchTimes(binary_img);  % 1
%     h = getMaxSwitchTimes(binary_img'); % 1
%     
    gabor_result = getGaborFeature(mat2gray(x(:,:,i)'), 5);
    gab_img_1 = reshape(gabor_result(1,:,:), [scaled_width scaled_width]);
    gab_img_2 = reshape(gabor_result(2,:,:), [scaled_width scaled_width]);
    gab_img_3 = reshape(gabor_result(3,:,:), [scaled_width scaled_width]);
    gab_img_4 = reshape(gabor_result(4,:,:), [scaled_width scaled_width]);
    
%     a1 = getBDD(gab_img_1);
%     a2 = getBDD(gab_img_2);
%     a3 = getBDD(gab_img_3);
%     a4 = getBDD(gab_img_4);
%     a = [a1 a2 a3 a4];
    
%     b1 = getZoningDensity(gab_img_1);
%     b2 = getZoningDensity(gab_img_2);
%     b3 = getZoningDensity(gab_img_3);
%     b4 = getZoningDensity(gab_img_4);
%     b = reshape([b1 b2 b3 b4], [1 64]);
%     
%     m = [getHistogram(gab_img_1) getHistogram(gab_img_2) getHistogram(gab_img_3) getHistogram(gab_img_4)]; % 4*(width*6-2)
    
%     [~,~,latent1] = princomp(gab_img_1*10);
%     [~,~,latent2] = princomp(gab_img_2*10);
%     [~,~,latent3] = princomp(gab_img_3*10);
%     [~,~,latent4] = princomp(gab_img_4*10);
%     
%     n1 = sort(latent1, 'descend');
%     n2 = sort(latent2, 'descend');
%     n3 = sort(latent3, 'descend');
%     n4 = sort(latent4, 'descend');
    
    features(i,1:dim_num) = [reshape(gab_img_1, [1 1600]), reshape(gab_img_2, [1 1600]), reshape(gab_img_3, [1 1600]), reshape(gab_img_4, [1 1600])];
%     features(i,1:dim_num) = [a];
     
    % thinImage = getThinImage(img)
    
%     if ~isempty(clean_img)
%         fileName = strcat('./processed/', num2str(i), '_processed.png');
%         imwrite(clean_img, fileName);
%     end
end


%% svm_train


% Linear
disp 'linear svm'
for C = -0.5
    disp 'start training!!!'
    [C]
    svmtrain(y(1:6144)', features(1:6144,1:6400), sprintf('-t 0 -c %f -q -v 5',10^C));
%     svmtrain(y(1:6144)', features(1:6144,1:128), sprintf('-t 0 -c %f -q -v 5',10^C));
%     svmtrain(y(1:6144)', features(1:6144,129:256), sprintf('-t 0 -c %f -q -v 5',10^C));
%     svmtrain(y(1:6144)', features(1:6144,257:384), sprintf('-t 0 -c %f -q -v 5',10^C));
%     svmtrain(y(1:6144)', features(1:6144,385:512), sprintf('-t 0 -c %f -q -v 5',10^C));
end

% model = svmtrain(y(1:6144)', features(1:6144,:), sprintf('-t 0 -c %f -q -b 1',0.1));
% [result accr probs] = svmpredict(y(6145:9216)', features(6145:9216,:), model, '-b 1');
% svmtrain(y(1:6144+bag_num)', features(1:6144+bag_num,:), sprintf('-t 2 -g %f -c %f -v 5 -b 1 -q', 0.1, 10^2));
% model = svmtrain(y(1:6144+bag_num)', features(1:6144+bag_num,:), sprintf('-t 2 -g %f -c %f -b 1 -q', 0.1, 10^2));
% [result, accr, probs] = svmpredict(y(6145+bag_num:9216+bag_num)', features(6145+bag_num:9216+bag_num,:), model, '-b 1');

%% RBF
% disp 'RBF'
% for gamma = [0.001 0.01 0.1 0.5 1 2 10 50]
%     for C = -4:2:4
%         disp 'start training!!!'
%         [gamma C]
%         svmtrain(y(1:6144)', features(1:6144,:), sprintf('-t 2 -g %f -c %f -v 5 -q', gamma, 10^C));
%         % model = svmtrain(y(1:6144)', features(1:6144,:), sprintf('-t 2 -g %f -c %f -q', 0.5/sigma^2, C));
%         % result = svmpredict(y(6145:9216)', features(6145:9216,:), model);
%     end
% end
 disp 'saving'







