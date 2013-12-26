load tmp

X = tmp(:,2:size(tmp,2));
Y = tmp(:,1);

disp start

for sigma = [0.125 0.5 2]
    for C = [0.001 1 1000]
        model = svmtrain(Y, X, sprintf('-g %f -c %f -q', 0.5/sigma^2, C))
        svmpredict(Y, X, model);
        svmtrain(Y, X, sprintf('-g %f -c %f -v 5 -q', 0.5/sigma^2, C));
    end
end