
% Latin Hypercube Sampling process for VehSimParallel
% ------------------------------
rng default


% Initialize parameters
lhs = lhsdesign(n_ind, n_vars);  % Latin hypercube sampling
pop = lhs;  % Boundary-settled individual values
intervals = [x_Vlu; x_Qlu; x_Nlu; x_Rlu; x_PMlu];

% Set the individuals between the previous intervals
for i = 0:1:n_vars-1
    l_limit = i * n_ind + 1;
    h_limit = (i+1) * n_ind;
    pop(l_limit:h_limit) = (intervals(i+1, 2)-intervals(i+1, 1)) * lhs(l_limit:h_limit) + intervals(i+1, 1);
end

% Add objective functions columns
experiments = [pop lambda*ones(n_ind, 1) zeros(n_ind, n_obj)];

clearvars i l_limit h_limit x_Vlu x_Qlu x_Rlu;
clearvars x_Nlu L_Mlu x_PMlu s f lhs pop intervals;