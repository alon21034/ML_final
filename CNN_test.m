function CNN_test(bag_num)

    [trainY, trainX] = libsvmread('ml2013final_train.dat');
    [testY, testX] = libsvmread('ml2013final_test1.nolabel.dat');

    % bag_num = 0; %% How much??
    tempX = reshape(full(trainX)', [105, 122, size(trainX, 1)]);
    tempX = tempX(5:101, 5:118, :);
%     [addY, addX] = getRandomData(trainY, tempX, bag_num);  

%     trainY = cat(1, addY, trainY);

    totalX = [trainX;testX];
    totalY = [trainY;testY];

    imgX = reshape(full(totalX)', [105, 122, size(totalX, 1)]);
    imgX = imgX(5:101, 5:118, :);
%     imgX = cat(3, addX, imgX);


    x = zeros(40, 40, size(imgX, 3));
    y = zeros(12, size(trainY, 1));

    for i = 1:size(imgX, 3)

        img = imgX(:,:,i)';
        img = imadjust(img,stretchlim(img),[]);  %%%%%%%%%%%% tune image contrast 
        img = mat2gray(img)>0.007;
        img = bwmorph(img, 'clean'); 
        img = bwmorph(img, 'fill'); 
        img = bwmorph(img, 'majority');
    %     img = bwmorph(img, 'majority'); 
    %     img = bwmorph(img, 'thin', Inf);  %%%%%%%%%%%%%%%% THIN is OFF
        img = getFitImage(img);
        img = imresize(img, [40, 40]);
        x(:,:,i) = img;
        if 0
            if ~isempty(img)
                fileName = strcat('./test/', num2str(i), '_test.png');
                imwrite(img, fileName);
            end
        end

    end

    for i = 1:size(trainY, 1)
        y(trainY(i), i)=1;
    end

    train_x = x(:,:,1:(bag_num + size(trainX, 1)));
    test_x = x(:,:,(bag_num + size(trainX, 1)+1):(bag_num + size(trainX, 1)+size(testX, 1)));
    train_y = y(:,1:size(trainY, 1));
    % test_y = y(:,5501:6144);

    % addpath('../data');
    % load mnist_uint8;

    % train_x = double(reshape(train_x',28,28,60000))/255;
    % test_x = double(reshape(test_x',28,28,10000))/255;
    % train_y = double(train_y');
    % test_y = double(test_y');

    %% ex1 
    %will run 1 epoch in about 200 second and get around 11% error. 
    %With 100 epochs you'll get around 1.2% error

    Ein = zeros(50:1);
    rr = zeros(50:1);
    index = 1;
    for iter_num = [500 400]

        cnn.layers = {
            struct('type', 'i') %input layer
            struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
            struct('type', 's', 'scale', 2) %sub sampling layer
            struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
            struct('type', 's', 'scale', 2) %subsampling layer
        };
        cnn = cnnsetup(cnn, train_x, train_y);

        opts.alpha = 1;              %%%%%%%%%%%    what's this?
        opts.batchsize = 48;         %%%%%%%%%%%  need to be the factor of train data size
        opts.numepochs = iter_num;        %%%%%%%%%%% Number of epochs!!!!!

        cnn = cnntrain(cnn, train_x, train_y, opts);
        [er, bad] = cnntest(cnn, train_x, train_y);   %%%%%%%%%% HERE we compute Ein!!!!!
        disp([num2str(er*100) '% Ein']);

        net = cnnff(cnn, test_x);                          %%%%%%%%%% HERE do the Prediction
        [~, pred] = max(net.o);

        load ans1.dat
        rr(index) = sum(pred' ~= ans1)*100 / 3072
        Ein(index) = [(er*100)]
        
        index = index+1;
        dlmwrite('cnn_result', pred');

        % plot mean squared error
        % plot(cnn.rL);
        %show test error
        disp([num2str(er*100) '% error']);
    end
    dlmwrite('cnn_all_err', rr);
end