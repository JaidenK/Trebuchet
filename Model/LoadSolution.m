% Specify input data
filename = ""; % Set filename to empty string to use latest solution

% look for most recent data
if(strlength(filename)==0)
    d            = dir('solutions/*mat');
    [~, index]   = max([d.datenum]);
    filename = fullfile(d(index).folder, d(index).name);
    disp(filename)
else
    filename = fullfile("solutions",filename);
end

% Load the model
SymbolicParameters

% Clear values we expect to load so that we don't accidentally get stuck 
% with old data if the load fails.
clear sol sysparam;
% Load the solution
load(filename);

SubsSystemParameters;
EvaluateDiscreteEvents;

