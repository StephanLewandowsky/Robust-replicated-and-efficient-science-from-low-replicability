%draw replication market figures for theory simulations (multiple
%   rhos to a panel), September 2018 -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before

%% ========== set up input for figures ====================================
printflag=1;   %if set to 1, then figures are printed to pdf

%create file name and indicate panel labels
shadings=[1 .5 .1];   %graphical representation of rho
figdir = 'C:/Users/Lewan/Documents/Papers Written/Replication market/';
panelLabel   =['a' 'b'];
boundPertile = 0.9;
bayesFlag    = 1;
symmFlag     = 1;
fakeFlag     = 0;
nPerCond     = 1000;
alpha        = .05;
power        = .8;

resultsPathNames=cell(1,3);
k=0;
for theory=[1 .5 .1]
    k=k+1;
    tpath = getMyPath(boundPertile, alpha, power, bayesFlag, symmFlag, ...
        fakeFlag, theory, nPerCond);
    resultsPathNames{k} = ['output/' tpath  '/' tpath  'N' num2str(nPerCond) '.xlsx']; 
end
finfn = replace(tpath,'0.1','all'); %create summary file name for paper
T=cell(1,length(resultsPathNames));
for i=1:length(resultsPathNames)
    Ttemp=readtable(resultsPathNames{i},'ReadVariableNames',1);
    T{i}=Ttemp(Ttemp.phack==0,:);   %ignore p-hacking
end

%% ============ create figure (with handle for papersize)
mfh=figure;

subplot(1,2,1); %first plot number of experiments
ul = max(T{1}.nTotExptsPrivRep+5);
ll = min([90, (T{1}.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
for i=1:length(resultsPathNames)
    [hpriv,hpub]=plotPubvPriv(gcf, T{i},'gain', {'nTotExptsPrivRep','nTotExptsPubRep'},shadings(i));
end

panel = text(-3, ul+(ul-ll)*.05,  panelLabel(1));
panel.FontSize = 14;
panel.FontWeight = 'bold';

p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
t = text(5,98.,'\uparrow');
t.FontSize = 14;
t = text(3,95.,'First round');
t.FontSize = 12;

lh=[hpriv hpub];
legend(lh,'Private replication','Public replication', ...
    'Location','best')
xlabel('Temperature')
ylabel('Total number of experiments conducted')

subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T{1}.nPrivRealInterestTrueEffs T{1}.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
for i=1:length(resultsPathNames)
    [hpriv,hpub]=plotPubvPriv(gcf, T{i}, 'gain', {'nPrivRealInterestTrueEffs', 'nPubRealInterestTrueEffs'},shadings(i));
    mte(i) = mean(T{i}.trueEffsPresent(T{i}.gain>0));
end
panel = text(-3, ul2+(ul2*.05), panelLabel(2));
panel.FontSize = 14;
panel.FontWeight = 'bold';

if ~symmFlag
    pmaxl=refline([0 mean(mte)]);
    pmaxl.Color='black';
    pmaxl.LineStyle='--';
    pmaxl.Marker='none';
    annotation('textarrow',[0.668928571428571 0.6375],...
    [0.843333333333333 0.736666666666667],'String','Max discoverable');
end
xlabel('Temperature')
if symmFlag
    ylabel('Number of interesting truths (effects or non-effects) revealed')
else
    ylabel('Number of interesting true effects revealed')
end

%now print figure on correct paper size
set(mfh,'Units','Inches');
pos = get(mfh,'Position');
set(mfh,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
if printflag, print(mfh,[figdir finfn '.pdf'],'-dpdf', '-r0' ); end
