%draw replication market figures, September 2018 -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before
%global outcomeSpace theoryCentroid;

%% ========== set up input for figures ====================================
printflag=1;   %if set to 1, then figures are printed to pdf

%various file names
%'TheoryDrivBayes/batch 2 centroid = 0.5/TheoryDrivBayesN1000';
%'standardResults/standardResultsN1000'
%'BayesianExplorResults/BayesianExplorResultsN1000'
%bemscapeResultsN1000/bemscapeResultsN1000
resultsPathName = 'fakeResultsN1000/fakeResultsN1000'; 
fn = ['output/' resultsPathName '.csv']; % or .xlsx
T=readtable(fn,'ReadVariableNames',1);
%T.Properties.VariableNames

%% %%%%%%%%%%%%%%%%% focus on p-hacking
PH=T(T.phack>0 & T.gain>0,:);   
linethickness = 0.5; %will be multiplied by 3 in function plotPubvPriv

figure;
subplot(1,2,1); %first plot number of experiments
ul = max(T.nTotExptsPrivRep+2);
ll = min([95, (T.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
[hpriv, hpub]=plotPubvPriv(gcf, T,'phack',{'nTotExptsPrivRep','nTotExptsPubRep'},linethickness);

lh1=[hpriv hpub];
legend(lh1,'Private replication ','Public replication ', ...
       'Location',[0.17501 0.5 0.24464 0.086905])

p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
annotation('textarrow',[.3 .24],[.19 .25],'String','First round')
xlabel('p-Hacking (batch size)')
ylabel('Total number of experiments conducted')

subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T.nPrivRealInterestTrueEffs T.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
[hpriv,hpub,hpriv2,hpub2]=plotPubvPriv(gcf, T,'phack',{'nPrivRealInterestTrueEffs', ...
                                  'nPubRealInterestTrueEffs', ...
                                  'nPrivRealInterestEffs',...
                                  'nPubRealInterestEffs'},linethickness);

pmaxl=refline([0 mean(T.trueEffsPresent(T.gain>0))]);
pmaxl.Color='black';
pmaxl.LineStyle='--';
pmaxl.Marker='none';
annotation('textarrow',[.69 .62],[.78 .83],'String','Max discoverable')
xlabel('p-Hacking (batch size)')
ylabel('Number of interesting effects discovered')
lh=[hpriv hpub hpriv2 hpub2];
legend(lh,'Private replication true','Public replication true', ...
          ['Private replication' 10 'significant'], ...
          ['Public replication' 10 'significant'], ... 
       'Location',[0.5944 0.4 0.2875 0.16548])
 
if printflag, print(['output/' resultsPathName 'ph.pdf'],'-dpdf', '-bestfit' ); end

%% %%%%%%%%%%%%%%%%% ignore p-hacking, focus on effects of gain
T=T(T.phack==0,:);   
linethickness = 0.5; %will be multiplied by 3 in function plotPubvPriv

%create figure 
figure;
subplot(1,2,1); %first plot number of experiments
ul = max(T.nTotExptsPrivRep+2);
ll = min([95, (T.nTotExptsPubRep-2)']);
axis([-.5 10.5 ll ul])
[hpriv, hpub]=plotPubvPriv(gcf, T, 'gain', {'nTotExptsPrivRep','nTotExptsPubRep'},linethickness);

lh1=[hpriv hpub];
legend(lh1,'Private replication ','Public replication ', ...
       'Location',[0.17501 0.55 0.24464 0.086905])

p100=refline([0 100]);
p100.Color='black';
p100.LineStyle='--';
p100.Marker='none';
%text(5,99,'First round');
%standard recults: annotation('textarrow',[.3 .24],[.24 .32],'String','First round')
%some other result (not bemscape): annotation('textarrow',[.3 .24],[.29 .35],'String','First round')
%bemscape:
annotation('textarrow',[.3 .24],[.37 .43],'String','First round')
xlabel('Gain')
ylabel('Total number of experiments conducted')

subplot(1,2,2) %now plot knowledge gain
ul2 = max([10, max([T.nPrivRealInterestTrueEffs T.nPubRealInterestTrueEffs])+1]);
axis([-.5 10.5 0 ul2])
[hpriv,hpub,hpriv2,hpub2]=plotPubvPriv(gcf, T,'gain',{'nPrivRealInterestTrueEffs', ...
                                  'nPubRealInterestTrueEffs', ...
                                  'nPrivRealInterestEffs',...
                                  'nPubRealInterestEffs'},linethickness);

pmaxl=refline([0 9]); %refline([0 mean(T.trueEffsPresent(T.gain>0))]);
pmaxl.Color='black';
pmaxl.LineStyle='--';
pmaxl.Marker='none';
annotation('textarrow',[.69 .62],[.78 .83],'String','Max discoverable')
xlabel('Gain')
ylabel('Number of interesting effects discovered')
lh=[hpriv hpub hpriv2 hpub2];
legend(lh,'Private replication true','Public replication true', ...
          ['Private replication' 10 'significant'], ...
          ['Public replication' 10 'significant'], ... 
       'Location',[0.5944 0.4 0.2875 0.16548])
 
if printflag, print(['output/' resultsPathName '.pdf'],'-dpdf', '-bestfit' ); end
