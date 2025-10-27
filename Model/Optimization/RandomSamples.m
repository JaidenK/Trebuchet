clear all;
close all;
clc;

iterationsThisRun = 0;
while(1)
    tic
    
    % First we have to choose a point to test.
    % For now we'll use the default values.
    load("Optimization\FeasibleRegion.mat");
    DefineSysParamFromFeasibleRegion;
    
    % Run the model
    SymbolicParameters;
    DeriveEquationsOfMotion;
    SolveDifferentialEquationsOfMotion;
    LoadSolution;
    
    % Determine cost
    cost = -double(sysparam.discrete.T_2_release.subsexpr);
    fprintf("Cost: %f\n",cost);
    
    % Save results
    load("Optimization\CostResults.mat");
    CostResults(end+1,1) = {"-"}; % Append empty row
    % parameters
    fieldNames = fieldnames(sysparam.constants);
    for i=1:numel(fieldNames)
        fieldName = fieldNames{i};
        value = double(sysparam.constants.(fieldName).expr);
        CostResults{end,fieldName} = value;
    end
    fieldNames = fieldnames(sysparam.init_cond);
    for i=1:numel(fieldNames)
        fieldName = fieldNames{i};
        value = double(sysparam.init_cond.(fieldName).expr);
        CostResults{end,fieldName} = value;
    end
    % results
    fieldNames = fieldnames(sysparam.discrete);
    for i=1:numel(fieldNames)
        fieldName = fieldNames{i};
        value = double(sysparam.discrete.(fieldName).subsexpr);
        CostResults{end,fieldName} = value;
    end
    if(isempty(sol.ie))
        % Indicate release didn't occure.
        % This isn't good, but better than nothing.
        cost = cost + 9999e9;
    end
    CostResults{end,"Cost"} = cost;
    CostResults{end,"CPU_Time"} = toc;
    
    save("Optimization\CostResults","CostResults");

    iterationsThisRun = iterationsThisRun + 1;
    fprintf("\ni: %d\n",iterationsThisRun);
end
