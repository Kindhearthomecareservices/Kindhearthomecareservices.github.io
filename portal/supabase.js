// KindHeart Supabase Connection - Production
const SUPABASE_URL = "https://enlvelqeqbmhamyqtzxj.supabase.co";
const SUPABASE_KEY = "sb_publishable_PIHnwkRKsXvvJjnVQRLx5g_l5SAXbQw";
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

function checkBP(bp_text){
  if(!bp_text ||!bp_text.includes('/')) return {level:'ok', text:'--'};
  let s=parseInt(bp_text.split('/')[0]), d=parseInt(bp_text.split('/')[1]);
  if(s>=180 || d>=120) return {level:'bad', text:`CRISIS ${bp_text} - Urgent Review`};
  if(s>=140 || d>=90) return {level:'bad', text:`HIGH ${bp_text}`};
  if(s>=130 || d>=85) return {level:'warn', text:`Elevated ${bp_text}`};
  return {level:'ok', text:`Normal ${bp_text}`};
}
function checkTemp(t){ let v=parseFloat(t); if(isNaN(v)) return {level:'ok',text:'--'}; if(v>=38) return {level:'bad',text:`Fever ${v}°C`}; if(v>=37.5) return {level:'warn',text:`High ${v}°C`}; return {level:'ok',text:`Normal ${v}°C`} }
function checkSpO2(v){ let n=parseInt(v); if(isNaN(n)) return {level:'ok',text:'--'}; if(n<90) return {level:'bad',text:`LOW ${n}%`}; if(n<94) return {level:'warn',text:`Low ${n}%`}; return {level:'ok',text:`Normal ${n}%`} }
