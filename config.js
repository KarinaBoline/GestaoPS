// Conexão com o Supabase da P&S Cobranças.
//   supabaseUrl     = "Project URL" (Supabase → Project Settings → API)
//   supabaseAnonKey = chave "anon public"
// A chave anon é pública: sozinha não dá acesso a nada, porque as regras do banco exigem login.
// Nunca coloque aqui a chave "service_role" (ou "secret"): ela dá acesso total ao banco.
// Com os dois campos vazios, o sistema funciona em modo local (dados só neste navegador).
window.PS_CONFIG = {
  supabaseUrl: 'https://xhvdsitastyjwrivhwgz.supabase.co',
  supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhodmRzaXRhc3R5andyaXZod2d6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE0MzM2MDUsImV4cCI6MjEwNzAwOTYwNX0.o1tkzl_XyJ-RomqxDmsNK39ci8S2pAEjAjXIjzrjayQ'
};
