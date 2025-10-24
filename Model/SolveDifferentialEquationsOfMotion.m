% First run SymbolicParameters.m
% Then run DeriveEquationsOfMotion.m

% https://roygoodman.net/math473/ode45problem1

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

t_0 = 0;
t_f = 2;

initial_conditions = ...
[   
    deg2rad(-(90+40)); % rope angle
    0                  % rope vel  
    deg2rad(-(90+30)); % arm angle
    0;                 % arm vel
];

sysparam_matrix = ...
[            I_1,  0.39; 
               g,  9.81;
             l_1,     1;
           l_1cg,    .37;
             l_2,    .8;
             m_1,     5;
             m_2, 0.51;
 theta_1_initial, initial_conditions(1);
           l_pp1, 0.1;
           l_pp2, 0.3;
       theta_pp0, deg2rad(5);
           x_pp0, 0.21;
               k, 5000;
];

sysparam_symbols = sysparam_matrix(:,1).';
sysparam_values =  double(sysparam_matrix(:,2).');

EoM_func = matlabFunction(subs(EoM_VecField,sysparam_symbols,sysparam_values),'vars', {'t','Y'});

% Energy still isn't being conserved after the paramer order was fixed with
% EoM_Subs discovery. Trying to decrease the time step period.
options=odeset('AbsTol',1e-9,'RelTol',1e-9,'MaxStep',0.005);
% Best energy stability seen: .010 J with ('AbsTol',1e-8,'RelTol',1e-8,'MaxStep',0.010)

sol = ode45(EoM_func,[t_0 t_f],initial_conditions');

save(fullfile("solutions",string(datetime,"yyyyMMdd-HHmm")+"-DiffEqnSolution"),"sol","sysparam_symbols","sysparam_values")
