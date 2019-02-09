%replication market, August 2018 -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before

%% ==========struture of fixed parameters to run any simulation
fixedps.nExploreLevels = 10;   %number of levels in bivariate exploration space
fixedps.pH1true = .09;         %Dreber15 estimate = .09. If set to zero: 'bemscape'
fixedps.nExperiments = 100;
fixedps.nPerCond = 100;        %number of simulation runs per condition of simulation
opdir = 'output/';
printflag=1;                   %if set to 1, then figures are printed to pdf

%% ===========define meta parameters for a range of simulations, each with
%             a different output file. Each of these can be a vector
LI_boundPertile =.9;  %threshold for citations being interesting
LI_bayesFlag = 0;     %if 1 then Bayesian t-test and 'bfcritval' will be used, otherwise normal z-test and 'critval'
LI_symmFlag = 0;      %only considered for Bayesian analysis. If 1, then 1/bfcritval will also be
%counted towards 'significant' effects (and considered true if H0 is true).
LI_fakeFlag = 0;      %if 1, then pretend everything is significant
LI_theory = .0;       %if >0, then there is structure in the world, and this value determines overlap between
%theory and the world. If set to 1, theory is perfect.
%If near zero, the theory is grazing in the wrong space

%% ============run meta experiments defined by meta parameters, each of which
%              has a number of conditions within it
for boundPertile = LI_boundPertile
    % get the citations of 2,000 articles in psychology from 2014
    % and plot citations and decision bound centered on (typically) 90th percentile
    load 'psychcites2014.dat'
    [decisionBound, gpParms] = plotParetoCites(boundPertile,psychcites2014,printflag,opdir);
    
    for bayesFlag = LI_bayesFlag
        for symmFlag = LI_symmFlag
            for fakeFlag = LI_fakeFlag
                for theory = LI_theory
                    % create new output directory if necessary
                    resultsPathName = getMyPath(boundPertile, bayesFlag, ...
                                                symmFlag, fakeFlag, theory, fixedps.nPerCond);
                    if ~exist([opdir resultsPathName],'dir')
                        mkdir (opdir, resultsPathName) %make sure all output goes into dedicated directory
                    end
                     % call the crucial function that runs an entire meta experiment
                    runMetaExperiment(fixedps, decisionBound, gpParms, ...
                        resultsPathName, bayesFlag, symmFlag, fakeFlag, theory)
                end %LI_theory
            end %LI_fakeflag
        end %LI_symmflag
    end %LI_bayesFlag
end %LI_boundPertile