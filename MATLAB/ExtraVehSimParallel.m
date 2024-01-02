
% Vehicle Simulation implementing Parallel computing workers
% ------------------------------

% =========================
lambda = 1600;  % Identification of the partition
% =========================


% Initial declared parameters
n_vars = 5;  % Number of decision variables
n_obj = 2;  % Number of objectives
n_ind = 2e3;  % Number of total simulations
x_Vlu = [100 400];  % Battery voltage
x_Qlu = [4 100];  %  Battery capacity
x_Nlu = [0.5 10];  % Differential gear ratio
x_Rlu = [0.28 0.38];  % Wheel radius
x_PMlu = [40 150];  % Maximum power of the motor
part = 5e2;  % Subset of experiments per run
run("ExtraLHSdesign.m")

model = 'DivideNConquer';
load_system(model);

for num = 1:1:n_ind/part
    simIn(1:part) = Simulink.SimulationInput(model);

    for index = 1:1:part
        ex_index = (num - 1) * part + index;
        simIn(index) = setModelParameter(simIn(index), 'SimulationMode', 'accelerator');
        simIn(index) = setVariable(simIn(index), 'Vbatt', experiments(ex_index, 1), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'Qbatt', experiments(ex_index, 2), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'Rdiff', experiments(ex_index, 3), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'Rwheel', experiments(ex_index, 4), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'PMotmax', experiments(ex_index, 5), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'Mvehicle', experiments(ex_index, 6), 'Workspace', 'global-workspace');
    end

    simOut = parsim(simIn, 'ShowSimulationManager', 'on');

    % Allocate the objective simulation outputs in the pop matrix
    for index = 1:1:part
        ex_index = (num - 1) * part + index;
        if isempty(simOut(1,index).ErrorMessage)
            if simOut(1, index).Fsoc == 0 && simOut(1, index).Fstop == 0
                experiments(ex_index, 7) = simOut(1, index).H;
                experiments(ex_index, 8) = simOut(1, index).Pmech;
            elseif simOut(1, index).Fsoc == 1 && simOut(1, index).Fstop == 0
                experiments(ex_index, 7) = 1;
                experiments(ex_index, 8) = 1;        
            end
        end
    end

    l_limit = (num - 1) * part + 1;
    h_limit = num * part;
    file = strcat('lambda', int2str(lambda), '_part', int2str(num), '_ind', int2str(part), '.txt');
    writematrix(experiments(l_limit:h_limit,:), file)

    clearvars simOut simIn;
end