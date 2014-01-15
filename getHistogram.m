function result = getHistogram(img)

    a = sum(sort(img));
    b = sum(sort(img'));
    
    height = size(img, 1);
    width = size(img, 2);
    
    c = zeros(1, height + width - 1);
    d = zeros(1, height + width - 1);
    
    for i = 1:width
        for j = 1:height
            if img(i,j) > 0
               c(i+j-1) = c(i+j-1) + img(i,j);
               d(width-i+j) = d(width-i+j) + img(i,j);
            end
        end
    end
    
    result = [a b c d]; %w*6-2
    
end