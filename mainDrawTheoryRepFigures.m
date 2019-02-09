%draw replication market figures for theory simulations (multiple
%   rhos to a panel), September 2018 -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before

%% ========== set up input for figures ====================================
printflag=1;   %if set to 1, then figures are printed to pdf
symmetryflag=0;  %#ok<NASGU> %if set, then max discoverable is omitted because null effects also count
shadings=[1 .5 .1];   %graphical representation of rho
%various file names
% resultsPathNames ={'TheoryFreqCent1.0\TheoryFreqCent1.0N100'
%     'TheoryFreqCent0.5\TheoryFreqCent0.5N100'
%     'TheoryFreqCent0.1\TheoryFreqCent0.1N100'};
%figurePathName = 'TheoryDrivFreq';
% resultsPathNames ={'TheoryBayesCent1.0\TheoryBayesCent1.0N100'
%     'TheoryBayesCent0.5\TheoryBayesCent0.5N100'
%     'TheoryBayesCent0.1\TheoryBayesCent0.1N100'};
% figurePathName = 'TheoryDrivBayes';
resultsPathNames ={'TheoryBayesSymCent1.0/TheoryBayesSymCent1.0N100'
    'TheoryBayesSymCent0.5/TheoryBayesSymCent0.5N100'
    'TheoryBayesSymCent0.1/TheoryBayesSymCent0.1N100'};
figurePathName = 'TheoryDrivBayesSym';
symmetryflag=1;

if ~exist(['output/' figurePathName],'dir')
    mkdir ('output', figurePathName) %make sure all output goes into dedicated directory
end

T=cell(1,length(resultsPathNames));

for i=1:length(resultsPathNames)
    fn = ['output/' resultsPathNames{i} '.xlsx'];
    Ttemp=readtable(fn,'ReadVariableNames',1);
    T{i}=Ttemp(Ttemp.phack==0,:);   %ignore p-hacking
end

%create figure
figure;
subplot(1,2,1); %first plot number of experiments
ul = max(T{1}.nTotExptsPrivRep+5);
ll = min([90, (T{1}.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
for i=1:length(resultsPathNames)
    [hpriv,hpub]=plotPubvPriv(gcf, T{i},'gain', {'nTotExptsPrivRep','nTotExptsPubRep'},shadings(i));
end
p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
annotation('textarrow',[.3 .24],[.165 .19],'String','First round')
xlabel('Temperature')
ylabel('Total number of experiments conducted')
lh=[hpriv hpub];
legend(lh,'Private replication','Public replication', ...
    'Location','best')

subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T{1}.nPrivRealInterestTrueEffs T{1}.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
for i=1:length(resultsPathNames)
    [hpriv,hpub]=plotPubvPriv(gcf, T{i}, 'gain', {'nPrivRealInterestTrueEffs', 'nPubRealInterestTrueEffs'},shadings(i));
    mte(i) = mean(T{i}.trueEffsPresent(T{i}.gain>0));
end
if ~symmetryflag
    pmaxl=refline([0 mean(mte)]);
    pmaxl.Color='black';
    pmaxl.LineStyle='--';
    pmaxl.Marker='none';
    annotation('textarrow',[.69 .62],[.85 .79],'String','Max discoverable')
end
xlabel('Temperature')
ylabel('Number of interesting truths (effects or non-effects) revealed')
%ylabel('Number of interesting true effects revealed')


if printflag, print(['output/' figurePathName '/' figurePathName  '.pdf'],'-dpdf', '-bestfit' ); end
