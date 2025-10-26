function DispSysVar(var,displayCase,nDigits)
    arguments
        var
        displayCase = 1 
        nDigits = 2
    end
    oldDigits = digits;
    digits(nDigits);
    switch(displayCase)
        % Symbol, Expression, and Substituted Expression
        case 1 
            if(isfield(var,'subsexpr'))
                if(isa(var.subsexpr,'sym') || isa(var.subsexpr,'symfunc'))
                    disp(var.sym == var.expr == vpa(simplify(expand(var.subsexpr))));
                else
                    disp(var.sym == var.expr == vpa(var.subsexpr));
                end
            else
                disp(var.sym == var.expr == vpa(var.expr));
            end

        % Symbol, Expression
        case 2 
            disp(var.sym == var.expr);
        
        % Symbol, Numeric (Constant System Parameters)
        case 3 
            disp(var.sym == vpa(var.expr));

        % Symbol, Numeric (degrees) (Constant System Parameters)
        case 4 
            disp([var.sym == vpa(rad2deg(var.expr)), 'degrees']);

        otherwise
            warning("DispSysVar: bad displayCase");
    end
    digits(oldDigits);
end


%disp(subs(str2sym('f(t)'),sym('f'),var.sym) == var.f_of_t);