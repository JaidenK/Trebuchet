% First run SymbolicParameters.m
% Then run DeriveEquationsOfMotion.m

% https://roygoodman.net/math473/ode45problem1

% Clearing before risky business so we don't accidentally get left with 
% old data without knowing.
clear EoM_VecField EoM_Subs; 
[EoM_VecField,EoM_Subs] = odeToVectorField(EoM);

% Tip: Print EoM_Subs to make sure you have the order right
% EoM_Subs = 
%  theta_2
% Dtheta_2
%  theta_1
% Dtheta_1
disp("Columns should match:");
disp([[sym("theta_2");sym("Dtheta_2");sym("theta_1");sym("Dtheta_1");] EoM_Subs]);

% Tip: symvar(EoM_VecField)

clear sysparam sysparam_symbols sysparam_values;
sysparam = struct;
sysparam.timeLimits = [0 2];
sysparam.init_cond = struct;
sysparam.init_cond.theta_1_0     = struct('sym', sym('theta_1_0'),    'expr', deg2rad(-(90+30)));
sysparam.init_cond.theta_dot_1_0 = struct('sym', sym('theta_dot_1_0'),'expr', 0);
sysparam.init_cond.theta_2_0     = struct('sym', sym('theta_2_0'),    'expr', deg2rad(-(90+40)));
sysparam.init_cond.theta_dot_2_0 = struct('sym', sym('theta_dot_2_0'),'expr', 0);
sysparam.constants = struct;
sysparam.constants.I_1   = struct('sym', I_1,   'expr', 0.39);
sysparam.constants.g     = struct('sym', g,     'expr', 9.81);
sysparam.constants.l_1   = struct('sym', l_1,   'expr', 1);
sysparam.constants.l_1cg = struct('sym', l_1cg, 'expr', .37);
sysparam.constants.l_2   = struct('sym', l_2,   'expr', .8);
sysparam.constants.m_1   = struct('sym', m_1,   'expr', 5);
sysparam.constants.m_2   = struct('sym', m_2,   'expr', 0.51);
%sysparam.constants.theta_1_initial   = struct('sym', theta_1_initial, 'expr', sysparam.old_initial_conditions(1));
sysparam.constants.k     = struct('sym', k,     'expr', 20);

% build symbols and values arrays from sysparam.constants
fieldNames = fieldnames(sysparam.constants);
sysparam_symbols = sym.empty;
sysparam_values = double.empty;
for i=1:numel(fieldNames)
    fieldName = fieldNames{i};
    sysvar_i = sysparam.constants.(fieldName);
    sysparam_symbols(i) = sysvar_i.sym;
    sysparam_values(i) = double(sysvar_i.expr);
end

EoM_func = matlabFunction(subs(EoM_VecField,sysparam_symbols,sysparam_values),'vars', {'t','Y'});

% Energy still isn't being conserved after the paramer order was fixed with
% EoM_Subs discovery. Trying to decrease the time step period.
options=odeset('AbsTol',1e-9,'RelTol',1e-9,'MaxStep',0.005);
% Best energy stability seen: .010 J with ('AbsTol',1e-8,'RelTol',1e-8,'MaxStep',0.010)

% Initial conditions array. Note the variable order must match EoM_Subs
% order.
ode45initcond = double([sysparam.init_cond.theta_2_0.expr sysparam.init_cond.theta_dot_2_0.expr sysparam.init_cond.theta_1_0.expr sysparam.init_cond.theta_dot_1_0.expr]);

% The Grand Finale:
sol = ode45(EoM_func,sysparam.timeLimits,ode45initcond);

save(fullfile("solutions",string(datetime,"yyyyMMdd-HHmm")+"-DiffEqnSolution"),"sol","sysparam","sysparam_symbols","sysparam_values")
