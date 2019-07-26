% function to return a name of the directory for output based on meta
% parameters
function rpn =getMyPath(boundPertile, alpha, power, bayesFlag, symmFlag, fakeFlag, theory, npercond)

if theory>0
    ExplTheo = ['Theo' num2str(theory)];
else
    ExplTheo = 'Discov';
end
if symmFlag
    symmetry = 'Symmet';
else
    symmetry = '';
end
if fakeFlag
    fake = 'Fake';
else
    fake = '';
end
if bayesFlag
    freqBayes = 'Bayes';
else
    freqBayes = 'Freq';
end
rpn=[freqBayes ExplTheo symmetry fake 'Citptile' num2str(boundPertile) 'alpha' num2str(alpha) 'power' num2str(power) 'N' num2str(npercond)];