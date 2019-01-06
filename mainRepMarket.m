%replication market, August 2018 -- written by Stephan Lewandowsky
close all                     %close all figures
clearvars                     %get rid of variables from before
global outcomeSpace theoryCentroid;

%% ========== get the citations of 2,000 articles in psychology from 2014 and create output path
load 'psychcites2014.dat'
resultsPathName = 'TheoryBayesSymCent0.1'; %'BayesianExplorResults'; %'standardResults';
if ~exist(['output/' resultsPathName],'dir')
    mkdir ('output', resultsPathName) %make sure all output goes into dedicated directory
end
printflag=0;   %if set to 1, then figures are printed to pdf

%%  ==========draw illustrative figure of citation distribution, pareto fit, and
% decision bound centered on 90th percentile
h2=histfit(psychcites2014,30,'gp');
set(gca, 'XLim', [0 100])
yt = get(gca, 'YTick');
set(gca, 'YTick', yt, 'ytickLabel', (num2str(yt./numel(psychcites2014),'%.1f\n')))
hold on
gpParms = fitdist(psychcites2014,'gp') %#ok<NOPTS>
%k=shape, sigma=scale
%k-->alpha and sigma-->X_m in https://en.wikipedia.org/wiki/Pareto_distribution#Probability_density_function
%if k=-1 then pareto sampling returns uniform distribution

%create decision function and so on centered on 90th percentile of citations
%this could also be done as: decisionBound = quantile(psychcites2014,.9);
decisionBound = gpinv(.9,gpParms.k,gpParms.sigma,gpParms.theta); %stays constant
citcounts = sort(psychcites2014);
%plot boundary for various levels of gain
k=0;
for gain=[1,5,10]
    k=k+1;
    pRepDecision = makeRepDecision(citcounts, decisionBound, gain);
    %add a bit to get it off the axis
    hl(k)=plot(citcounts,pRepDecision*numel(psychcites2014)+10,'-','LineWidth',2); %#ok<SAGROW>
end
vline(decisionBound,'k--');
annotation('textarrow',[.4 .32],[.35 .35],'String','Threshold')
annotation('textarrow',[.45 .38],[.25 .14],'String','Pareto fit to observed distribution')
xlabel('Total number of citations')
ylabel('Proportion of articles / P(Interest)')
l1=legend(hl,'1','5', '10', ...
    'Location','best')
title(l1,'Gain')
hold off
if printflag, print('citesDecisions','-dpdf'); end


%% ==========struture of fixed parameters to run this simulation
fixedps.nExploreLevels = 10;   %number of levels in bivariate exploration space
fidexps.pH1true = .09;         %Dreber15 estimate = .09. If set to zero: 'bemscape'
fixedps.nExperiments = 100;
fixedps.decBnd = decisionBound;
fixedps.nPerCond = 1000;        %number of replications per condition of simulation

%% ========== structure of free (flex) parameters to govern behavior of simulation
% anything initialized to nan here is set below in experimental-condition
% loop
flexps.sampleSize = 30;       %n subjects in each experiment before p-hacking
flexps.sampleSD = 1.5;          %standard deviation of population. Usually 2, but set to 1.5 for Bayesian analysis
flexps.pHack = nan;           %if 0, no p-hack. Otherwise, add batch of n subjects until significant
flexps.pHackBatches = 5;      %number of times p-hacking can occur
flexps.decisionGain = nan;    %gain for replication decision. gain=0 means always replicate
flexps.interestGain = 5;      %if replic-gain=0, then use this gain to decide if interesting
flexps.fakeit = 0;            %if 1, then pretend everything is significant
flexps.critval = 2.;          %z value: use 2 for .05, 2.58 for .01, 3.29 for .001
flexps.bfcritval = 3;         %use 3 for moderate, 10 for strong, 30 for very strong, 100 for decisive
% BF=3 roughly p=.05; http://imaging.mrc-cbu.cam.ac.uk/statswiki/FAQ/RscaleBayes
flexps.bayesian = 1;          %if 1 then Bayesian t-test and 'bfcritval' will be used, otherwise normal z-test and 'critval'
flexps.symmetrical = 1;       %only considered for Bayesian analysis. If 1, then 1/bfcritval will also be 
%counted towards 'significant' effects (and considered true if H0 is true). 
flexps.theory = .1;            %if >0, then there is structure in the world, and this value determines overlap between
%theory and the world. If set to 1, theory is perfect.
%If near zero, the theory is grazing in the
%wrong space

%% ========== run replication market experiment
resultsSim = zeros(16, 15);
avgNTrueResults = 0;
k=0;
for fph = [0,1,5,10]
    flexps.pHack = fph;
    for fpg = [0 1 5 10]
        flexps.decisionGain = fpg;
        k=k+1;
        
        %conduct a number of simulations for each cell of the design
        disp([fph fpg])
        for i=1:fixedps.nPerCond
            %a new 2D space of variables worthy of exploration, with some random locations
            %that have a "true" effect.
            if flexps.theory > 0
                outcomeSpace = zeros(fixedps.nExploreLevels);
                centroid = [randi([3 fixedps.nExploreLevels-2]) randi([3 fixedps.nExploreLevels-2])];
                neff = ceil(fidexps.pH1true*fixedps.nExploreLevels^2);
                while abs(sum(sum(outcomeSpace))-neff)>1
                    outcomeSpace = zeros(fixedps.nExploreLevels);
                    for j=1:neff
                        xvaleffs(j) = randi([centroid(1)-1 centroid(1)+2]); %#ok<SAGROW>
                        yvaleffs(j) = randi([centroid(2)-1 centroid(2)+2]); %#ok<SAGROW>
                        outcomeSpace(xvaleffs(j),yvaleffs(j))= 1;
                    end
                end
                distort = round((1-flexps.theory)*9);
                theoryCentroid = [randi([max(centroid(1)-distort,1) min(centroid(1)+distort,fixedps.nExploreLevels)]) ...
                    randi([max(centroid(2)-distort,1) min(centroid(2)+distort,fixedps.nExploreLevels)])];
            else
                outcomeSpace = rand(fixedps.nExploreLevels) < fidexps.pH1true;
                theoryCentroid = nan;
            end
            avgNTrueResults = avgNTrueResults + sum(sum(outcomeSpace));
            %last argument in next call triggers snapshot display of theory
            %space
            simResults (i) = runRepMarket(fixedps,flexps,gpParms,i==fixedps.nPerCond); %#ok<SAGROW>
        end
        
        %print results for that cell
        fn = fieldnames(simResults);
        forMeans=[];
        for i=1:length(fn)
            forMeans=cat(2,forMeans,[simResults.(fn{i})]');
        end
        fixedps %#ok<NOPTS>
        gpParms %#ok<NOPTS>
        flexps %#ok<NOPTS>
        cellMeans=mean(forMeans,'omitnan');
        disp([fn num2cell(cellMeans')])
        
        %keep track of results for further analysis
        resultsSim(k,1)=fph;
        resultsSim(k,2)=fpg;
        resultsSim(k,3:15)=cellMeans;
        
    end
end
avgNTrueResults / (k*fixedps.nPerCond)  %#ok<NOPTS>
tx=array2table(resultsSim,'VariableNames',{'phack','gain', ...
    'typeI','power', ...
    'trueEffsPresent', ...
    'nTotExptsPrivRep','nPrivRealEffs', ...
    'nPrivRealInterestEffs', ...
    'nPrivRealInterestTrueEffs', ...
    'typeIRep', ...
    'powerRep', ...
    'nAppntEffs', ...
    'nTotExptsPubRep', ...
    'nPubRealInterestEffs', ...
    'nPubRealInterestTrueEffs'}) %#ok<NOPTS>

%% show effects of error rates in initial exploration (before replication)
% this shows effects of p-hacking
g5=tx((tx.gain==5),:);
figure
plot(g5.phack,g5.typeI,'r-o','MarkerFaceColor','red');
hold on
plot(g5.phack,1-g5.power,'k-o','MarkerFaceColor','black');% ,ylim=c(0,.3),xlab="p-Hacking (batch size)", ylab="Type I/II error rate",las=1,type="l")
p05=refline([0 .05]);
p05.Color='black';
p05.LineStyle='--';
p05.Marker='none';
axis([-.5,10.5,0,.5])
legend('Type I','Type II');
xlabel('p-Hacking (batch size)');
ylabel('Type I/II error rate');
hold off
if printflag, print('phackEffects','-dpdf'); end


%% plot results for selected values of gain
for g = [1 10]
    g5 = tx((tx.gain==g),:);
    ul = max(g5.nTotExptsPrivRep+2);
    ll = min([95, (g5.nTotExptsPubRep-2)']);
    figure
    box on
    hold on
    plot(g5.phack,g5.nTotExptsPrivRep,'r-o','MarkerFaceColor','red')
    axis([-.5 10.5 ll ul])
    xlabel('p-Hacking (batch size)')
    ylabel('Number of experiments conducted')
    
    plot(g5.phack,g5.nTotExptsPubRep,'b-o','MarkerFaceColor','blue')
    p100=refline([0 100]);
    p100.Color='black';
    p100.LineStyle='--';
    p100.Marker='none';
    
    title(['g=' num2str(g)])
    legend('Private replication','Public replication','Location','east')
    hold off
    if printflag, print(['output/' resultsPathName '/expNum_g' num2str(g)],'-dpdf', '-bestfit'); end
    
    
    figure
    hold on
    box on
    
    ul2 = max([10, max([g5.nPrivRealInterestEffs g5.nPubRealInterestEffs])]);
    plot(g5.phack,g5.nPrivRealInterestTrueEffs,'r-o','MarkerFaceColor','red')
    axis([-.5 10.5 0 ul2])
    xlabel('p-Hacking (batch size)')
    ylabel('Number of interesting (true) effects revealed')
    
    plot(g5.phack,g5.nPubRealInterestTrueEffs,'b-o','MarkerFaceColor','blue')
    
    plot(g5.phack,g5.nPrivRealInterestEffs,'r--o','MarkerFaceColor','red')
    plot(g5.phack,g5.nPubRealInterestEffs,'b--o','MarkerFaceColor',[0.5843    0.8157    0.9882])
    title(['g=' num2str(g)])
    p100=refline([0 avgNTrueResults / (k*fixedps.nPerCond)]);
    p100.Color='black';
    p100.LineStyle='--';
    p100.Marker='none';
    
    legend('True effects private replication','True effects public replication', ...
        'Interesting effects private replication',...
        'Interesting effects public replication',...
        'Location','east')
    if printflag, print(['output/' resultsPathName '/discoveryNum_g' num2str(g)],'-dpdf', '-bestfit' ); end
    
end

%save results in Excel, with results and parameters in different sheets
ofn = ['output/' resultsPathName '/' resultsPathName 'N' num2str(fixedps.nPerCond) '.xlsx' ];
if exist(ofn,'file')
    apn = 1;
    while ~movefile(ofn,['output/' resultsPathName '/' resultsPathName 'N' num2str(fixedps.nPerCond) '_' num2str(apn) '.xlsx' ]);
        apn=apn+1;
    end
end
writetable(tx,ofn,'Sheet','results')
writetable(struct2table(flexps),ofn,'Sheet','parameters')

%now clean up the default sheets 1-3 that we do not need
newExcel = actxserver('Excel.Application');
newExcel.DisplayAlerts = false;
excelWB = newExcel.Workbooks.Open(fullfile(pwd,ofn));
excelWB.Sheets.Item(1).Delete; %sheets 'move over' after deletion, so it's always the 1st to be deleted
excelWB.Sheets.Item(1).Delete;
excelWB.Sheets.Item(1).Delete;
excelWB.Save();
excelWB.Close();
newExcel.Quit();
delete(newExcel);