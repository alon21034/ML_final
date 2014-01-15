function result = getFitImage(img)

    top     = size(img, 1);
    bot     = 1;
    left    = size(img, 2);
    right   = 1;

    for j = 1:size(img, 1)
        for k = 1:size(img, 2)
            if img(j,k) > 0.15
                
                if top>j 
                    top=j;
                end
                if bot<j 
                    bot=j;
                end
                if left>k 
                    left=k;
                end
                if right<k 
                    right=k;
                end
            end
        end
    end
    
    if (top > bot || right < left)
        result = 0;
    else
        result = img(top:bot, left:right);
    end

end