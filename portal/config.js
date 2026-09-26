let status = 'Normal';
let sBP = parseInt(bp.value.split('/')[0]||0);
if(sBP>=180||parseFloat(temp.value)>=38||parseInt(spo2.value)<90) status='HIGH ALERT';
else if(sBP>=140||parseFloat(temp.value)>=37.5) status='Elevated';
