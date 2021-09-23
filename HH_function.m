function fraction_deprotonated = HH_function(pKa, pH)

fraction_deprotonated =(10.^(pH-pKa)./(1+10.^(pH-pKa)));
