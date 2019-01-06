%% ===== August 2018: added Bayesian t-test as well
function expResults = runExperiment(iv1, iv2, parms, repFlag)
global outcomeSpace;
trueEffect=outcomeSpace(iv1,iv2);

data = trueEffect+randn(1,parms.sampleSize)*parms.sampleSD;
if parms.fakeit && ~repFlag
    z = 5;
    bf = 100; %make it a decisive Bayes factor if we are faking things
else
    % frequentist z and Bayes factor
    z = mean(data)/(std(data)/sqrt(parms.sampleSize));
    bf = t1smpbf(z,parms.sampleSize);
end
n = parms.sampleSize;
ph = 0;
while parms.pHack && (abs(z) < 2) && (ph < parms.pHackBatches)  %if we (have to) p-hack, we do this now...
    data = [data randn(1,parms.pHack)*parms.sampleSD+trueEffect]; %#ok<AGROW>
    n = n + parms.pHack;
    z = mean(data)/(std(data)/sqrt(n));
    bf = t1smpbf(z,n);
    ph = ph + 1;
end

expResults.iv1val = iv1;
expResults.iv2val = iv2;
expResults.z = z;
expResults.bf = bf;
if parms.bayesian
    if parms.symmetrical  %bayesian consideration of BF01 and BF10 is a little complicated
        expResults.sigResult = (bf > parms.bfcritval) | ((1/bf) > parms.bfcritval);
        if ((bf > parms.bfcritval) && trueEffect) || (((1/bf) > parms.bfcritval) && ~trueEffect)
           expResults.trueEffect = 1;
        else 
           expResults.trueEffect = 0;
        end 
    else %bayesian looking for effects is simple
        expResults.sigResult = bf > parms.bfcritval;
        expResults.trueEffect = trueEffect;
    end 
else  %frequentist statistics are simple
    expResults.sigResult = abs(z)> parms.critval;
    expResults.trueEffect = trueEffect;
end
expResults.finalSample = n;
expResults.finalBatches = ph;