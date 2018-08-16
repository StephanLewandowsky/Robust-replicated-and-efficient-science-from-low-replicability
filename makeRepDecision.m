function d = makeRepDecision (cit,db,gain) 
if gain>0
    d = 1./(1+exp(-(cit-db)/gain));
else
    d=ones(1,length(cit)); 
end

