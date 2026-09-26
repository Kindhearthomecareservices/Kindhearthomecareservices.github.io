// KindHeart Core - V2
const DB_KEY='kindheart_v2';
const getDB=()=>JSON.parse(localStorage.getItem(DB_KEY)||'{}');
const saveDB=(d)=>localStorage.setItem(DB_KEY,JSON.stringify(d));

function initDB(){
 let db=getDB();
 if(!db.patients) db={patients:[{id:'KHA5577',full_name:'Mama Jane',location:'Eldoret',allergies:'Protein',diagnosis:'Flu',care_started_date:new Date().toISOString().slice(0,10),baseline:{bp:'120/80',temp:36.5,spo2:96,hr:80}}], staff:[{id:'STF001',full_name:'Jackie',role:'Nurse'}], treatment:[], vitals:[], care_notes:[], inventory:[], meds_given:[], appointments:[], reports:[]};
 saveDB(db); return db;
}

// Vitals Detection - SpO2 89-100%
function checkVitals(bp,temp,spo2,hr){
 let alerts=[];
 let sys = parseInt((bp||'120/80').split('/')[0]);
 let dia = parseInt((bp||'120/80').split('/')[1]);
 if(sys<90||sys>140||dia<60||dia>90) alerts.push(`BP ${bp} abnormal`);
 if(temp<36.1||temp>37.5) alerts.push(`Temp ${temp}°C ${temp>37.5?'HIGH':'LOW'}`);
 if(spo2<89||spo2>100) alerts.push(`SpO2 ${spo2}% abnormal (Normal 89-100%)`);
 if(hr<60||hr>100) alerts.push(`HR ${hr} ${hr>100?'HIGH':'LOW'}`);
 return {isAbnormal:alerts.length>0, msg: alerts.length? '🔴 ABNORMAL ALERT - '+alerts.join(', ') : '✅ Normal', alerts};
}

function dayCount(startDate){
 let start=new Date(startDate); let now=new Date();
 return Math.floor((now-start)/(1000*60*60*24))+1;
}

// Treatment Sheet automation
function addTreatment(patient_id, drug, dosage, notes, total, start_date, duration){
 let db=initDB();
 let end=new Date(start_date); end.setDate(end.getDate()+parseInt(duration));
 db.treatment.push({id:'TR'+Date.now(), patient_id, drug_name:drug, dosage, notes, total_qty:parseInt(total), remaining_qty:parseInt(total), start_date, duration_days:parseInt(duration), end_date:end.toISOString().slice(0,10), created_at:new Date().toISOString()});
 saveDB(db);
}

function giveMed(treatment_id, qty){
 let db=initDB(); let t=db.treatment.find(x=>x.id===treatment_id);
 if(!t) return;
 t.remaining_qty=Math.max(0,t.remaining_qty-qty);
 db.meds_given.push({id:'MG'+Date.now(), treatment_id, patient_id:t.patient_id, qty_given:qty, remaining_after:t.remaining_qty, created_at:new Date().toISOString(), staff:'Jackie'});
 saveDB(db);
}
