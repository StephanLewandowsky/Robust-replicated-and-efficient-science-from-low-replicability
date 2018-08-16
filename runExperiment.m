function expResults = runExperiment(iv1, iv2, parms, repFlag)
global outcomeSpace;
trueEffect=outcomeSpace(iv1,iv2);

data = trueEffect+randn(1,parms.sampleSize)*parms.sampleSD;
if parms.fakeit && ~repFlag
    z = 5;
else
    z = mean(data)/(std(data)/sqrt(parms.sampleSize));
end
n = parms.sampleSize;
ph = 0;
while parms.pHack && (abs(z) < 2) && (ph < parms.pHackBatches)  %if we (have to) p-hack, we do this now...
    data = [data randn(1,parms.pHack)*parms.sampleSD+trueEffect]; %#ok<AGROW>
    n = n + parms.pHack;
    z = mean(data)/(std(data)/sqrt(n));
    ph = ph + 1;
end

expResults.iv1val = iv1;
expResults.iv2val = iv2;
expResults.z = z;
expResults.sigResult = abs(z)>2;
expResults.trueEffect = trueEffect;
expResults.finalSample = n;
expResults.finalBatches = ph;