
% Vehicle Simulation implementing Parallel computing workers for NDS after
% applying MOEAs
% ------------------------------

model = 'DivideNConquer';
load_system(model);

a = {'sms', 'imia', 'pimia'};

for i = 1:1:length(a)
    algorithm = a{i};
    file = strcat(algorithm, '_3points.txt');
    experiments = [importdata(file) zeros(30, 2)];
    
    simIn(1:30) = Simulink.SimulationInput(model);
    for index= 1:1:30
        simIn(index) = setModelParameter(simIn(index), 'SimulationMode', 'accelerator');
        simIn(index) = setVariable(simIn(index), 'Vbatt', experiments(index, 1), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'Qbatt', experiments(index, 2), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'Rdiff', experiments(index, 3), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'Rwheel', experiments(index, 4), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'PMotmax', experiments(index, 5), 'Workspace', 'global-workspace');
        simIn(index) = setVariable(simIn(index), 'Mvehicle', experiments(index, 6), 'Workspace', 'global-workspace');
    end
    
    simOut = parsim(simIn, 'ShowSimulationManager', 'on');
    
    % Allocate the objective simulation outputs in the pop matrix
    for index = 1:1:30
        if isempty(simOut(1,index).ErrorMessage)
            if simOut(1, index).Fsoc == 0 && simOut(1, index).Fstop == 0
                experiments(index, 9) = simOut(1, index).H;
                experiments(index, 10) = simOut(1, index).Pmech;
            elseif simOut(1, index).Fsoc == 1 && simOut(1, index).Fstop == 0
                experiments(index, 9) = 1;
                experiments(index, 10) = 1;        
            end
        end
    end

    file = strcat('MATLAB_' , algorithm, '_3points.txt');
    writematrix(experiments, file)
    
    clearvars simOut simIn;
end
