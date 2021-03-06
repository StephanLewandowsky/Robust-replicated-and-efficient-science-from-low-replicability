%% draw replication market figures, September 2018 -- written by Stephan Lewandowsky
% updated July 2019
close all                     %close all figures
clearvars                     %get rid of variables from before

%% ========== set up input for figures ====================================
printflag=1;   %if set to 1, then figures are printed to pdf

%create file name and indicate panel labels
bemscapeFlag = 0;      %special treatment if there are no effects present
boundPertile = 0.9;
bayesFlag    = 0;
symmFlag     = 0;
fakeFlag     = 0;
theory       = 0;
nPerCond     = 1000;
alpha        = .2;
power        = .8;
panelLabel   =['a' 'b'];   %depends on analysis and/or power

if bemscapeFlag
    resultsPathName = 'bemscapeResultsN1000';
    fn = 'output/bemscapeResultsN1000/bemscape.xlsx';
else
    resultsPathName = getMyPath(boundPertile, alpha, power, bayesFlag, symmFlag, ...
        fakeFlag, theory, nPerCond);
    fn = ['output/' resultsPathName '/' resultsPathName 'N' num2str(nPerCond) '.xlsx'];
end
T=readtable(fn,'ReadVariableNames',1);
%T.Properties.VariableNames
figdir = 'C:/Users/Lewan/Documents/Papers Written/Replication market/';

%% %%%%%%%%%%%%%%%%% focus on p-hacking
PH=T(T.phack>0 & T.gain>0,:);
linethickness = 0.5; %will be multiplied by 3 in function plotPubvPriv

mfh=figure;
subplot(1,2,1); %first plot number of experiments
ul = max(T.nTotExptsPrivRep+2);
ll = min([95, (T.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
[hpriv, hpub]=plotPubvPriv(gcf, T,'phack',{'nTotExptsPrivRep','nTotExptsPubRep'},linethickness);

panel = text(-3, ul+(ul-ll)*.05,  panelLabel(1));
panel.FontSize = 14;
panel.FontWeight = 'bold';

p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
t = text(5,99.5,'\uparrow');
t.FontSize = 14;
t = text(3,98.5,'First round');
t.FontSize = 12;
%annotation('textarrow',[.3 .24],[.19 .25],'String','First round')

xlabel('Additional participants (batch size)')
ylabel('Total number of experiments conducted')

lh1=[hpriv hpub];
legend(lh1,'Private replication ','Public replication ', ...
    'Location',[0.178581428571429 0.609523809523809 0.24464 0.086905]);
%for frequentist: [0.17501 0.5 0.24464 0.086905])

subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T.nPrivRealInterestTrueEffs T.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
[hpriv,hpub,hpriv2,hpub2]=plotPubvPriv(gcf, T,'phack',{'nPrivRealInterestTrueEffs', ...
    'nPubRealInterestTrueEffs', ...
    'nPrivRealInterestEffs',...
    'nPubRealInterestEffs'},linethickness);

panel = text(-3, ul2+(ul2*.05), panelLabel(2));
panel.FontSize = 14;
panel.FontWeight = 'bold';

pmaxl=refline([0 mean(T.trueEffsPresent(T.gain>0))]);
pmaxl.Color='black';
pmaxl.LineStyle='--';
pmaxl.Marker='none';
annotation('textarrow',[.69 .62],[.78 .83],'String','Max discoverable')
xlabel('Additional participants (batch size)')
ylabel('Number of interesting effects discovered')
lh=[hpriv hpub hpriv2 hpub2];
legend(lh,'Private replication true','Public replication true', ...
    ['Private replication' 10 'significant'], ...
    ['Public replication' 10 'significant'], ...
    'Location',[0.5944 0.4 0.2875 0.16548])

set(mfh,'Units','Inches');
pos = get(mfh,'Position');
set(mfh,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

if printflag, print([figdir resultsPathName 'ph.pdf'],'-dpdf', '-r0' ); end

%% %%%%%%%%%%%%%%%%% ignore p-hacking, focus on effects of gain
T=T(T.phack==0,:);
linethickness = 0.5; %will be multiplied by 3 in function plotPubvPriv

%create figure (with handle for papersize)
mfh=figure;

subplot(1,2,1); %first plot number of experiments
ul = 130; %can be set by hand to force same range in all panels max(T.nTotExptsPrivRep+2);
ll = min([95, (T.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
[hpriv, hpub]=plotPubvPriv(gcf, T, 'gain', {'nTotExptsPrivRep','nTotExptsPubRep'},linethickness);

panel = text(-3, ul+(ul-ll)*.05,  panelLabel(1));
panel.FontSize = 14;
panel.FontWeight = 'bold';

%add horizontal line with text marker
p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
t = text(5,99.5,'\uparrow');
t.FontSize = 14;
t = text(3,98.5,'First round');
t.FontSize = 12;

lh1=[hpriv hpub];
legend(lh1,'Private replication ','Public replication ', ...
    'Location',[0.17501 0.5 0.24464 0.086905])

xlabel('Temperature')
ylabel('Total number of experiments conducted')


subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T.nPrivRealInterestTrueEffs T.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
if fakeFlag  %do not print anything private (fraudsters wouldn't care)
    [hpriv,hpub,hpriv2,hpub2]=plotPubvPriv(gcf, T,'gain',{'', ...
        'nPubRealInterestTrueEffs', '',...
        'nPubRealInterestEffs'},linethickness);
else
    [hpriv,hpub,hpriv2,hpub2]=plotPubvPriv(gcf, T,'gain',{'nPrivRealInterestTrueEffs', ...
        'nPubRealInterestTrueEffs', ...
        'nPrivRealInterestEffs',...
        'nPubRealInterestEffs'},linethickness);
end
panel = text(-3, ul2+(ul2*.05), panelLabel(2));
panel.FontSize = 14;
panel.FontWeight = 'bold';

if ~bemscapeFlag
    maxeff = mean(T.trueEffsPresent(T.gain>0));
    pmaxl=refline([0 maxeff]);
    pmaxl.Color='black';
    pmaxl.LineStyle='--';
    pmaxl.Marker='none';
    
    t = text(5,maxeff-0.2,'\uparrow');
    t.FontSize = 14;
    t = text(2,maxeff-0.9,'Max discoverable');
    t.FontSize = 12;
end
xlabel('Temperature')
ylabel('Number of interesting effects discovered')

if fakeFlag
    lh=[hpub hpub2];
    legend(lh,'Public replication true', ...
        ['Public replication' 10 'significant'], ...
        'Location',[0.5944 0.4 0.2875 0.16548])
else
    lh=[hpriv hpub hpriv2 hpub2];
    legend(lh,'Private replication true','Public replication true', ...
        ['Private replication' 10 'significant'], ...
        ['Public replication' 10 'significant'], ...
        'Location',[0.5944 0.40 0.2875 0.16548])
end

set(mfh,'Units','Inches');
pos = get(mfh,'Position');
set(mfh,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

if printflag, print(mfh,[figdir resultsPathName '.pdf'],'-dpdf', '-r0' ); end
