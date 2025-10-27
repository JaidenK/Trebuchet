%% Substitute solution parameters into the model's time-depenent functions.
% We want to remove dependence on all symbols except time and theta
Func_args_symbols = {[sym('t') cell2sym(DotNotation)]};
fieldNames = fieldnames(sysvar);
for i=1:numel(fieldNames)
    fieldName = fieldNames{i};
    sysvar.(fieldName).f_of_t = subs(sysvar.(fieldName).f_of_t,sysparam_symbols,sysparam_values);
    sysvar.(fieldName).func = matlabFunction(subs(sysvar.(fieldName).f_of_t,LeibnizNotation,DotNotation),'vars',Func_args_symbols);    
end
disp("Lagrangian f_of_t Symvars:")
disp(symvar(sysvar.L.f_of_t));
