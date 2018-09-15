%draw replication market figures, September 2018 -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before
%global outcomeSpace theoryCentroid;

%% ========== set up input for figures ====================================
printflag=1;   %if set to 1, then figures are printed to pdf

resultsPathName = 'TheoryDrivBayes/batch 2 centroid = 0.5/TheoryDrivBayesN1000';
fn = ['output/' resultsPathName '.xlsx'];
T=readtable(fn,'ReadVariableNames',1);
%T.Properties.VariableNames

%create figure 
figure;
subplot(1,2,1); %first plot number of experiments
ul = max(T.nTotExptsPrivRep+2);
ll = min([95, (T.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
plotPubvPriv(gcf, T,{'nTotExptsPrivRep','nTotExptsPubRep'})

p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
xlabel('Gain')
ylabel('Number of experiments conducted')

subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T.nPrivRealInterestTrueEffs T.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
plotPubvPriv(gcf, T,{'nPrivRealInterestTrueEffs', 'nPubRealInterestTrueEffs'})
xlabel('Gain')
ylabel('Number of interesting true effects revealed')
legend('Private replication','Public replication', ...
       'Location','northeast')
 
if printflag, print(['output/' resultsPathName '.pdf'],'-dpdf', '-bestfit' ); end
