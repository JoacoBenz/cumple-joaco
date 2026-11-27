# Cumple de Joaco 🎂

Invitación con rueda de nombres, cartas personalizadas y confirmaciones guardadas en Supabase.
Es un sitio estático: no necesita build ni dependencias.

```
cumple-joaco/
├─ index.html          ← toda la invitación (cartas, rueda, easter eggs)
├─ config.js           ← URL y anon key de Supabase (completar)
├─ img/                ← portada y fotos de las cartas
├─ supabase/migrations/20261127000000_rsvps.sql
├─ vercel.json
└─ README.md
```

Los comandos son para **cmd** de Windows.

---

## 1. Supabase (base de datos de las confirmaciones)

1. Entrá a https://supabase.com/dashboard y creá un proyecto nuevo, por ejemplo `cumple-joaco` (región São Paulo, plan Free).
2. Abrí **SQL Editor → New query**, pegá todo el contenido de `supabase/migrations/20261127000000_rsvps.sql` y tocá **Run**.
3. Andá a **Project Settings → API** y copiá:
   - **Project URL**
   - **anon public key**
4. Pegalos en `config.js`:

```js
window.CUMPLE_CONFIG = {
  supabaseUrl: "https://TU-PROYECTO.supabase.co",
  supabaseAnonKey: "eyJhbGciOi..."
};
```

La anon key es pública por diseño: lo que protege la tabla son las reglas (RLS) del SQL.
Los invitados pueden ver, confirmar y cambiar su respuesta, pero no pueden borrar nada ni inventar nombres que no estén en la lista.

**Ver las respuestas:** Supabase → Table Editor → `rsvps`. Ahí también podés borrar filas de prueba.

> Si `config.js` queda vacío, la invitación sigue funcionando y confirma por WhatsApp como antes.

---

## 2. GitHub

```bat
cd /d C:\GitHub\cumple-joaco
git init
git add .
git commit -m "Invitación cumple de Joaco"
git branch -M main
```

Con GitHub CLI (recomendado repo **privado**, porque tiene fotos de tus amigos):

```bat
gh repo create cumple-joaco --private --source=. --push
```

O sin `gh`: creá el repo vacío en github.com y después:

```bat
git remote add origin https://github.com/TU-USUARIO/cumple-joaco.git
git push -u origin main
```

---

## 3. Vercel

**Desde la web:**
1. https://vercel.com/new → **Import** el repo `cumple-joaco`.
2. Framework Preset: **Other**. Build Command y Output Directory: vacíos.
3. **Deploy**. Si el nombre del proyecto es `cumple-joaco`, el link queda `https://cumple-joaco.vercel.app` (si está tomado, Vercel te propone otro; lo podés cambiar en Settings → Domains).

**O desde cmd:**

```bat
npm i -g vercel
cd /d C:\GitHub\cumple-joaco
vercel --prod
```

Cada `git push` a `main` vuelve a publicar solo.

---

## Cambios frecuentes

| Qué | Dónde |
|---|---|
| Fecha, hora, lugar, WhatsApp, playlist | `CONFIG` al principio del `<script>` en `index.html` |
| Invitados y cartas | `GUESTS` en `index.html` |
| Tu carta secreta | `HOST_CARD` en `index.html` |
| Fotos | carpeta `img/` (y la ruta en `fotos:` de cada carta) |
| Fecha de la cuenta regresiva | `PARTY` en `index.html` |

Si agregás un invitado nuevo, sumá también su clave a la lista `rsvps_guest_key_valid` del SQL
(la clave es el nombre en minúsculas, sin tildes y con guiones: `Martín y Ro` → `martin-y-ro`).
