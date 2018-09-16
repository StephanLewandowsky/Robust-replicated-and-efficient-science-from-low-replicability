%draw replication market figures, September 2018 -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before
%global outcomeSpace theoryCentroid;

%% ========== set up input for figures ====================================
printflag=1;   %if set to 1, then figures are printed to pdf

%various file names
%'TheoryDrivBayes/batch 2 centroid = 0.5/TheoryDrivBayesN1000';
%'standardResults/standResultsN1000'
%'BayesianExplorResults/BayesianResultsN1000_12845'
resultsPathName = 'BayesianExplorResults/BayesianResultsN1000_12845'; 
fn = ['output/' resultsPathName '.xlsx'];
T=readtable(fn,'ReadVariableNames',1);
%T.Properties.VariableNames

%create figure 
figure;
subplot(1,2,1); %first plot number of experiments
ul = max(T.nTotExptsPrivRep+2);
ll = min([95, (T.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
plotPubvPriv(gcf, T,{'nTotExptsPrivRep','nTotExptsPubRep'},1)

p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
xlabel('Gain')
ylabel('Number of experiments conducted')

subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T.nPrivRealInterestTrueEffs T.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
[hpriv,hpub]=plotPubvPriv(gcf, T,{'nPrivRealInterestTrueEffs', 'nPubRealInterestTrueEffs'},1);
xlabel('Gain')
ylabel('Number of interesting true effects revealed')
lh=[hpriv hpub];
legend(lh,'Private replication','Public replication', ...
       'Location','northeast')
 
if printflag, print(['output/' resultsPathName '.pdf'],'-dpdf', '-bestfit' ); end
