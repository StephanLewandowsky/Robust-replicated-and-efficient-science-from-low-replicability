function simResults = runRepMarket(fixedps,flexps,gpParms,snapshotFlag)
global outcomeSpace theoryCentroid;

%create structure to hold outcome from experiments
expInfo = struct('trueEffect', num2cell(zeros(1,fixedps.nExperiments)), ...
    'sigResult', num2cell(zeros(1,fixedps.nExperiments)), ...
    'iv1val', num2cell(zeros(1,fixedps.nExperiments)), ...
    'iv2val', num2cell(zeros(1,fixedps.nExperiments)), ...
    'z', num2cell(zeros(1,fixedps.nExperiments)), ...
    'bf', num2cell(zeros(1,fixedps.nExperiments)), ...
    'finalSample', num2cell(zeros(1,fixedps.nExperiments)), ...
    'finalBatches', num2cell(zeros(1,fixedps.nExperiments)));
%define arguments 
notAReplication = 0;
aReplicaton = 1; 

%% ========== run fixed number of experiments for publication and also replicate
privRepInfo = expInfo(1);
nPrivReps = 0;
exptsRun = zeros(fixedps.nExploreLevels);
for i=1:fixedps.nExperiments
    if flexps.theory > 0 %we have theory, so let's use it to focus
        iv1= randi([max(theoryCentroid(1)-1,1) min(theoryCentroid(1)+2,fixedps.nExploreLevels)]);
        iv2= randi([max(theoryCentroid(2)-1,1) min(theoryCentroid(2)+2,fixedps.nExploreLevels)]);
    else %randomly explore a combination of independent variables
        iv1 = randi(fixedps.nExploreLevels);
        iv2 = randi(fixedps.nExploreLevels);
    end
    exptsRun(iv1,iv2) = exptsRun(iv1,iv2) + 1;
    expInfo(i)= runExperiment(iv1, iv2, flexps, notAReplication);
    if expInfo(i).sigResult  %replicate before publication
        nPrivReps = nPrivReps +1;
        privRepInfo(nPrivReps) = runExperiment(iv1, iv2, flexps, aReplicaton);
    end
end

if snapshotFlag %on last rep of each condition, draw a snapshot of outcome and experimental space
    scrsz = get(groot,'ScreenSize');
    figure('Position',[100 100 scrsz(3)*.25 scrsz(4)*.8])
    subplot (2,1,1);
    axis('square');
    contour(outcomeSpace);
    subplot (2,1,2);
    axis('square');
    contour(exptsRun);
end

%% ========== analyze results of first set of experiments
simResults.typeI = sum(~[expInfo.trueEffect] & [expInfo.sigResult])/sum(~[expInfo.trueEffect]);
simResults.power = sum([expInfo.trueEffect] & [expInfo.sigResult])/sum([expInfo.trueEffect]);

simResults.nTotExptsPrivRep =  fixedps.nExperiments + nPrivReps; %~flexps.fakeit *
%compute real (i.e., replicated) effects, by considering significance only,
%but not all of those are of interest
simResults.nPrivRealEffs = sum([privRepInfo.sigResult]);
paretos4interest = gprnd(gpParms.k,gpParms.sigma,gpParms.theta,1,simResults.nPrivRealEffs);
%apply interest criterion for privately replicated real effects
%if gain=0 replace decision gain with interest gain.
if flexps.decisionGain==0
    dG = flexps.interestGain;
else
    dG = flexps.decisionGain;
end
simResults.nPrivRealInterestEffs = sum(rand < makeRepDecision(paretos4interest, fixedps.decBnd, dG));
%now do it for true effects
nPrivRealTrueEffs = sum([privRepInfo.trueEffect] & [privRepInfo.sigResult]);
paretos4interest2 = gprnd(gpParms.k,gpParms.sigma,gpParms.theta,1,nPrivRealTrueEffs);
%apply interest criterion for privately replicated real & true effects
simResults.nPrivRealInterestTrueEffs = sum(rand < makeRepDecision(paretos4interest2, fixedps.decBnd, dG));



%% ========== now decide on replication of _published_ result based on how interesting an effect is
%look at significant results
appntEffs = find([expInfo.sigResult]);  
pubRepInfo = expInfo(1);
% sample citation count for published (=significant) results
paretos = gprnd(gpParms.k,gpParms.sigma,gpParms.theta,1,length(appntEffs));
% now decide what to replicate, and then replicate....
nPubReps = 0;
for i=1:length(appntEffs)
    if rand < makeRepDecision(paretos(i), fixedps.decBnd, flexps.decisionGain)
        nPubReps = nPubReps +1;
        pubRepInfo(nPubReps) = runExperiment(expInfo(appntEffs(i)).iv1val, expInfo(appntEffs(i)).iv2val, flexps, aReplicaton);
    end
end

%% ========== analyze what's left (i.e., replicated interesting effects)
simResults.typeIRep = sum(~[pubRepInfo.trueEffect] & [pubRepInfo.sigResult])/sum(~[pubRepInfo.trueEffect]);
simResults.powerRep = sum([pubRepInfo.trueEffect] & [pubRepInfo.sigResult])/sum([pubRepInfo.trueEffect]);
simResults.nAppntEffs = length(appntEffs);
simResults.nTotExptsPubRep = fixedps.nExperiments + nPubReps; %~flexps.fakeit * 

%after replication, count significance as being real
if flexps.decisionGain==0
    paretos4interest3 = gprnd(gpParms.k,gpParms.sigma,gpParms.theta,1,sum([pubRepInfo.sigResult]));
    simResults.nPubRealInterestEffs = sum(rand < makeRepDecision(paretos4interest3, fixedps.decBnd, flexps.interestGain));
else
    simResults.nPubRealInterestEffs = sum([pubRepInfo.sigResult]);
end
%but also do it for true effects
if flexps.decisionGain==0
    paretos4interest4 = gprnd(gpParms.k,gpParms.sigma,gpParms.theta,1,sum([pubRepInfo.trueEffect] & [pubRepInfo.sigResult]));
    simResults.nPubRealInterestTrueEffs = sum(rand < makeRepDecision(paretos4interest4, fixedps.decBnd, flexps.interestGain));
else
    simResults.nPubRealInterestTrueEffs = sum([pubRepInfo.trueEffect] & [pubRepInfo.sigResult]);
end
