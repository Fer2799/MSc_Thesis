

rng default

n_ind = [1e2, 2e2, 3e2, 4e2, 5e2, 6e2, 7e2, 8e2, 9e2, 1e3, 2e3, 3e3, 4e3, 5e3, 6e3, 7e3, 8e3, 9e3, 1e4, 2e4, 3e4, 4e4, 5e4, 6e4, 7e4, 8e4, 9e4, 1e5];
n_vars = 6;


for ind = n_ind
    lhs = lhsdesign(ind, n_vars);  % Latin hypercube sampling
    file = strcat('lhs', int2str(ind), '.txt');
    writematrix(lhs, file)
end
