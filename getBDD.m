function result = getBDD(data)

    width = size(data, 2);
    height = size(data, 1);
    
    w = fix(width/4);
    h = fix(width/4);
    
    y = [0 w 2*w 3*w width];
    x = [0 h 2*h 3*h height];

    
    mask(:,:,1) = [0 0 1;0 0 2;0 0 1];
    mask(:,:,2) = [0 1 2;0 0 1;0 0 0];
    mask(:,:,3) = [1 2 1;0 0 0;0 0 0];
    mask(:,:,4) = [2 1 0;1 0 0;0 0 0];
    mask(:,:,5) = [1 0 0;2 0 0;1 0 0];
    mask(:,:,6) = [0 0 0;1 0 0;2 1 0];
    mask(:,:,7) = [0 0 0;0 0 0;1 2 1];
    mask(:,:,8) = [0 0 0;0 0 1;0 1 2];
    
    result = zeros(4, 4, 8);
    
    for i=1:4
        for j = 1:4
            img = data(x(i)+1:x(i+1), y(j)+1:y(j+1));
            
            ww = size(img, 2)+2;
            hh = size(img, 1)+2;
            
            bimg = zeros(hh, ww);
            bimg(2:hh-1,2:ww-1) = img;
            
            for m = 2:ww-1
                for n = 2:hh-1
                    for k = 1:8
                        result(i, j, k) = result(i, j, k) + sum(sum(bimg(n-1:n+1, m-1:m+1) .* mask(:,:,k)));
                    end
                end
            end
        end
    end
    
    result = reshape(result, [1 16*8]);
end