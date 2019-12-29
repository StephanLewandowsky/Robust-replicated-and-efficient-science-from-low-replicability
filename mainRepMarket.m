%% replication market, August 2018 - December 2019 
% -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before

%% ==========struture of fixed parameters to run any simulation
fixedps.nExploreLevels = 10;   %number of levels in bivariate exploration space
fixedps.pH1true = .09;         %Dreber15 estimate = .09. If set to zero: 'bemscape'
fixedps.nExperiments = 100;
fixedps.nPerCond = 1000;       %number of simulation runs per condition of simulation
opdir = 'output/';
printflag=0;                   %if set to 1, then figures are printed to pdf

%% ===========define meta parameters for a range of simulations, each with
%             a different output file. 
% columns are: per'tile bayesflag symmetry fake theory alpha power
conds=[
% .9 0 0 0 0 .05 .8;
% .9 0 0 0 0 .2 .8;
% .9 0 0 0 0 .05 .7;
% .9 0 0 0 0 .05 .6;
% .9 0 0 0 0 .05 .5;
% .9 1 0 0 0 .05 .8;
% .9 0 0 0 0.1 .05 .8;
% .9 1 0 0 0.1 .05 .8;
% .9 0 0 0 0.5 .05 .8;
.9 1 0 0 0.5 .05 .8;
.9 0 0 0 1.0 .05 .8;
.9 1 0 0 1.0 .05 .8;
.9 1 1 0 0.1 .05 .8;
.9 1 1 0 0.5 .05 .8;
.9 1 1 0 1.0 .05 .8;
.9 0 0 1 0 .05 .8;
% .7 0 0 0 0 .05 .8;
% .5 0 0 0 0 .05 .8;
% .3 0 0 0 0 .05 .8;
% .1 0 0 0 0 .05 .8
];

howmanytorun = size(conds,1);  %how many of the meta experiments in the design to run?

%turn experimental plan into table with variable names.
expDesign = array2table(conds,'VariableNames',{'boundPertile','bayesFlag','symmFlag','fakeFlag','theory','alpha','power'});

%% ============run meta experiments defined by meta parameters, each of which
%              has a number of conditions within it
for metex=1:howmanytorun
    % get the citations of 2,000 articles in psychology from 2014
    % and plot citations and decision bound centered on (typically) 90th percentile
    load 'psychcites2014.dat'
    [decisionBound, gpParms] = plotParetoCites(expDesign.boundPertile(metex),...
                                              psychcites2014,printflag,opdir);
    
    % create new output directory if necessary
    resultsPathName = getMyPath(expDesign.boundPertile(metex), ...
        expDesign.alpha(metex), expDesign.power(metex), ...
        expDesign.bayesFlag(metex), expDesign.symmFlag(metex), ...
        expDesign.fakeFlag(metex), expDesign.theory(metex), fixedps.nPerCond);
    if ~exist([opdir resultsPathName],'dir')
        mkdir (opdir, resultsPathName) %make sure all output goes into dedicated directory
    end
    % call the crucial function that runs an entire meta experiment
    runMetaExperiment(fixedps, decisionBound, gpParms, ...
        resultsPathName, expDesign.alpha(metex), expDesign.power(metex), ...
        expDesign.bayesFlag(metex), expDesign.symmFlag(metex), ...
        expDesign.fakeFlag(metex), expDesign.theory(metex), printflag)
    %clean up if too many figures (in multi-meta-experiment
    %situation
    hall =  findobj('type','figure');
    if length(hall) > 40
        close all;
    end
end %metex