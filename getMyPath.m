% function to return a name of the directory for output based on meta
% parameters
function rpn =getMyPath(boundPertile, bayesFlag, symmFlag, fakeFlag, theory, npercond)

if theory>0
    ExplTheo = ['Theo' num2str(theory)];
else
    ExplTheo = 'Expl';
end
if symmFlag
    symmetry = 'Symm';
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
rpn=[freqBayes ExplTheo symmetry fake 'Ptile' num2str(boundPertile) 'N' num2str(npercond)];