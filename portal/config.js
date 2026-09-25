const KH_CONFIG = {
  SUPA_URL: "https://enlvelqeqbmhamyqtxzj.supabase.co",
  SUPA_KEY: "sb_publishable_PIHnwkRKsXvvJjnVQRLx5g_l5SAXbQw",
  ADMIN_PASS: "KindHeart@2024",
  COLORS: { blue:"#14495f", green:"#5ca94a", bg:"#f8faf6" }
};
const supa = supabase.createClient(KH_CONFIG.SUPA_URL, KH_CONFIG.SUPA_KEY);
