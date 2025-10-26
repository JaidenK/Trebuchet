% Derives the equations of motion assuming that the Lagrangian has already
% been defined in the workspace by running SymbolicParameters.m

q = {str2sym('theta_1(t)'); str2sym('theta_2(t)')}; % Assemble the generalized coordinates into a vector
clear EoM
EoM = [];

for i=1:length(q)
    % Partial L wrt q_dot
    dLdqdot = diff(sysvar.L.f_of_t,diff(q{i},t));
    % Time derivative of the previous partial
    ddt_dLdqdot = diff(dLdqdot,t);
    % Partial L wrt q
    dLdq = diff(sysvar.L.f_of_t,q{i});
    %EoM = [EoM; simplify(expand(ddt_dLdqdot - dLdq)) == 0];
    EoM = [EoM; ddt_dLdqdot - dLdq == 0];
end

%sysvar.EoM = struct('sym', sym('EoM'), 'f_of_t', EoM);