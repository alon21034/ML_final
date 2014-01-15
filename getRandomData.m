function [ resY, resX ] = getRandomData(dataY, dataX, N )

resY = zeros(N,1);
resX = zeros(97, 114, N);

for i = 1:N
    i
    index = randsample(size(dataX,3),1);
    type = randsample(3, 1);
    
    resY(i,1) = dataY(index, 1);
    I = dataX(:, :, index);
    
    if (type == 1)          % rotation
        scale = 1.2;       % scale factor
        angle = (15*(rand(1)-0.5))*pi/180; % rotation angle
        tx = 0;            % x translation
        ty = 0;            % y translation
        
        sc = scale*cos(angle);
        ss = scale*sin(angle);
        
        T = [ sc -ss;
              ss  sc;
              tx  ty];
        t_lc = maketform('affine',T);
        resX(:,:,i) = imresize(imtransform(I,t_lc,'FillValues',0), [97, 114]);
        
        
    elseif (type == 2)          % Affine
        if rand(1)>0.5
            T = [1  (0.4*(rand(1)-0.5));
                0  1;
                0  0];
        else
            T = [1  0;
                (0.4*(rand(1)-0.5))  1;
                0  0];
        end
        t_aff = maketform('affine',T);
        resX(:,:,i) = imresize(imtransform(I,t_aff,'FillValues',0), [97, 114]);
        
    else
        imid = round(size(I,2)/2); % Find index of middle element
        [nrows,ncols] = size(I);
        [xi,yi] = meshgrid(1:ncols,1:nrows);
        a1 = rand(1)*5; % Try varying the amplitude of the sinusoids.
        a2 = rand(1)*5;
        u = xi + a1*sin(pi*xi/imid);
        v = yi - a2*sin(pi*yi/imid);
        tmap_B = cat(3,u,v);
        resamp = makeresampler('linear','fill');
        resX(:,:,i) = imresize(tformarray(I,[],resamp,[2 1],[1 2],[],tmap_B,0), [97, 114]);
        
    end
    
end

end

