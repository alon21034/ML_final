function result = getRemoveArea(img)

width = size(img, 1);
height = size(img, 2);

a = sum(sum(img(1:fix(width/2), 1:fix(height/2))));
b = sum(sum(img(1:fix(width/2), fix(height/2)+1:height)));
c = sum(sum(img(fix(width/2)+1:width, 1:fix(height/2))));
d = sum(sum(img(fix(width/2)+1:width, fix(height/2)+1:height)));

t = [a b c d];

result = find(t == min(t));
if size(result, 2) > 1
    result = result(fix(rand*size(result,2)) + 1);
end

end