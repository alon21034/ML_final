function result = getGaborFeature(data, var)
data = mat2gray(data);
% figure,imshow(data);
data = bwmorph(data>0.07, 'clean');
% figure,imshow(data);
data = bwmorph(data, 'majority');
% figure,imshow(data);
data = bwmorph(data, 'thin', Inf);
% figure,imshow(data);
data = getFitImage(data);
% figure,imshow(data);
result = zeros(4, 1600);


f = pi/2;

[~,~,~,r1] = gaborfilter2(data,var,var,f,0);
[~,~,~,r2] = gaborfilter2(data,var,var,f,pi/4);
[~,~,~,r3] = gaborfilter2(data,var,var,f,pi/2);
[~,~,~,r4] = gaborfilter2(data,var,var,f,3*pi/4);

result(1,:) = reshape(imresize(r1,[40,40]),[1,1600]);
result(2,:) = reshape(imresize(r2,[40,40]),[1,1600]);
result(3,:) = reshape(imresize(r3,[40,40]),[1,1600]);
result(4,:) = reshape(imresize(r4,[40,40]),[1,1600]);

% [~,~,~,I] = gaborfilter2(data,var,var,f,0);
% [~,~,~,II] = gaborfilter2(data,var,var,f,pi/4);
% [~,~,~,III] = gaborfilter2(data,var,var,f,pi/2);
% [~,~,~,IIII] = gaborfilter2(data,var,var,f,3*pi/4);

% figure,imshow(10*I);
% figure,imshow(10*II);
% figure,imshow(10*III);
% figure,imshow(10*IIII);


end