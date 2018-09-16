%draw replication market figures for theory simulations (multiple
%   rhos to a panel), September 2018 -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before

%% ========== set up input for figures ====================================
printflag=1;   %if set to 1, then figures are printed to pdf
shadings=[1 .5 .1];   %graphical representation of rho
%various file names
% resultsPathNames ={'TheoryDrivFreq/first runs with too little distortion/batch 1 theory=1/TheoryDrivFreqN1000'
%     'TheoryDrivFreq/batch 2 centroid = 0.5/TheoryDrivFreqN1000'
%     'TheoryDrivFreq/batch 1 centroid = .1/TheoryDrivFreqN1000'};
%figurePathName = 'TheoryDrivFreq';
resultsPathNames = {'TheoryDrivBayes/batch 1 centroid = 1/TheoryDrivBayesN1000'
      'TheoryDrivBayes/batch 2 centroid = 0.5/TheoryDrivBayesN1000'};
figurePathName = 'TheoryDrivBayes';
T=cell(1,length(resultsPathNames));

for i=1:length(resultsPathNames)
    fn = ['output/' resultsPathNames{i} '.xlsx'];
    T{i}=readtable(fn,'ReadVariableNames',1);
end

%create figure
figure;
subplot(1,2,1); %first plot number of experiments
ul = max(T{1}.nTotExptsPrivRep+2);
ll = min([95, (T{1}.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
for i=1:length(resultsPathNames)
    plotPubvPriv(gcf, T{i},{'nTotExptsPrivRep','nTotExptsPubRep'},shadings(i))
end
p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
xlabel('Gain')
ylabel('Number of experiments conducted')

subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T{1}.nPrivRealInterestTrueEffs T{1}.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
for i=1:length(resultsPathNames)
    [hpriv,hpub]=plotPubvPriv(gcf, T{i},{'nPrivRealInterestTrueEffs', 'nPubRealInterestTrueEffs'},shadings(i));
end
xlabel('Gain')
ylabel('Number of interesting true effects revealed')
lh=[hpriv hpub];
legend(lh,'Private replication','Public replication', ...
    'Location','northeast')

if printflag, print(['output/' figurePathName '/' figurePathName  '.pdf'],'-dpdf', '-bestfit' ); end
