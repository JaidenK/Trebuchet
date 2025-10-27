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

%DefineSystemParameters;

EoM_func = matlabFunction(subs(EoM_VecField,sysparam_symbols,sysparam_values),'vars', {'t','Y'});

% Make sure the indicator function is set up:
SubsSystemParameters;
% Energy still isn't being conserved after the paramer order was fixed with
% EoM_Subs discovery. Trying to decrease the time step period.
options=odeset('AbsTol',1e-9,'RelTol',1e-9,'MaxStep',0.005,'Events',releaseIndicatorFcn(sysvar,sysparam));
% Best energy stability seen: .010 J with ('AbsTol',1e-8,'RelTol',1e-8,'MaxStep',0.010)

% Initial conditions array. Note the variable order must match EoM_Subs
% order.
ode45initcond = double([sysparam.init_cond.theta_2_0.expr sysparam.init_cond.theta_dot_2_0.expr sysparam.init_cond.theta_1_0.expr sysparam.init_cond.theta_dot_1_0.expr]);

% The Grand Finale:
sol = ode45(EoM_func,sysparam.timeLimits,ode45initcond,options);

save(fullfile("solutions",string(datetime,"yyyyMMdd-HHmm")+"-DiffEqnSolution"),"sol","sysparam","sysparam_symbols","sysparam_values")


% Release time indicator 
function [f] = releaseIndicatorFcn(sysvar,sysparam)  
    
    f = @(t,y)localIndicator(t,y);
    
    function [launchIndicator,isterminal,direction] = localIndicator(t,y)
        % See devalToArgs in LoadSolution.m
        zeropadding = zeros(size(y(1,:)));
        FuncArgs = [t; zeropadding; zeropadding;  y(4); y(2); y(3); y(1)]';
        launchIndicator = sysvar.phi_2.func(FuncArgs)-double(sysparam.constants.phi_rel.expr);    
        isterminal = 1;  % Halt integration 
        direction = 0;   % The zero can be approached from either direction
    end
end
