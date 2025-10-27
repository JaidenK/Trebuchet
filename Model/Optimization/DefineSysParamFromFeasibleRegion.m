clear sysparam sysparam_symbols sysparam_values;

sysparam = struct;
sysparam.timeLimits = [0 2];

sysparam.init_cond = struct;
sysparam.constants = struct;

for i=1:height(FeasibleRegion)
    value = double(FeasibleRegion{i,"Default"});
    if(FeasibleRegion{i,"IncludeInOptimization"})
        value = rand()*(FeasibleRegion{i,"MaxFeasible"}-FeasibleRegion{i,"MinFeasible"})+FeasibleRegion{i,"MinFeasible"};
    end
    sysparam.(FeasibleRegion{i,"stuct_name"}).(FeasibleRegion{i,"field_name"}) = ...
        struct('sym', sym(FeasibleRegion{i,"field_name"}), ...
        'expr', value);
end

% Refactor code so I don't have to have this dumb duplicate
sysparam.constants.theta_1_0 = struct('sym', sym('theta_1_0'), 'expr', sysparam.init_cond.theta_1_0.expr);

% Constrain starting spring energy to 50 J
initial_energy = 50;
sysparam.constants.k.expr = 2*initial_energy/sysparam.constants.x_3_0.expr;

% build symbols and values arrays from sysparam.constants
% Copied from DefineSystemParameters.m
fieldNames = fieldnames(sysparam.constants);
sysparam_symbols = sym.empty;
sysparam_values = double.empty;
for i=1:numel(fieldNames)
    fieldName = fieldNames{i};
    sysvar_i = sysparam.constants.(fieldName);
    sysparam_symbols(i) = sysvar_i.sym;
    sysparam_values(i) = double(sysvar_i.expr);
end