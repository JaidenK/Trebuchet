function [subsexpr,f_of_t] = SysVarDotDiff(sysvar_i,LeibnizNotation,DotNotation)
% Automated version of DotNotationDerivativeCalculator.mlx
% Use this when you need a variable that is purely just the derivative of
% another.

sysvar_to_be_differentiated = sysvar_i;
expr_fullsubs = sysvar_to_be_differentiated.subsexpr;
expr_fullsubs_leibniz = subs(expr_fullsubs,DotNotation,LeibnizNotation);
ans_leibniz = diff(expr_fullsubs_leibniz,sym('t'));
ans_dotted = subs(ans_leibniz,LeibnizNotation,DotNotation);

subsexpr = ans_dotted;
f_of_t = symfun(ans_leibniz,sym('t'));

end

