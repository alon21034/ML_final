function result = getZoningDensity(data)

    width = size(data, 2);
    height = size(data, 1);
    
    w = fix(width/4);
    h = fix(width/4);
    
    y = [0 w 2*w 3*w width];
    x = [0 h 2*h 3*h height];
   
    result = zeros(4);
    
    for i = 1 : 4
        for j = 1 : 4
            img = data(x(i)+1:x(i+1), y(j)+1:y(j+1));
            result(i, j) = sum(sum(img));
        end
    end

end