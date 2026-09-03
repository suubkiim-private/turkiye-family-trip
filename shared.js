const cfg = window.TRIP_CONFIG || {};
const isConfigured =
  cfg.SUPABASE_URL &&
  cfg.SUPABASE_KEY &&
  !cfg.SUPABASE_URL.includes("PASTE_") &&
  !cfg.SUPABASE_KEY.includes("PASTE_");

let db = null;
if (isConfigured && window.supabase) {
  db = window.supabase.createClient(cfg.SUPABASE_URL, cfg.SUPABASE_KEY);
}

function setSyncStatus(text, ok=true) {
  const el = document.getElementById("syncStatus");
  if (!el) return;
  el.textContent = text;
  el.dataset.ok = ok ? "1" : "0";
}
