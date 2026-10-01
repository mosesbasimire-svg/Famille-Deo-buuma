# Ma Caisse — version en ligne

Cette version est préparée pour être publiée sur **GitHub Pages** afin que Supabase puisse fonctionner depuis une adresse HTTPS.

## Important
- Mot de passe de l'application : `20072007`
- La clé utilisée dans `index.html` est une **publishable key** Supabase.
- Ne jamais mettre la clé `sb_secret_...` dans le navigateur.
- L'application doit être ouverte avec une adresse `https://...github.io/...`, pas avec `content://`.

## Publication rapide sur GitHub
1. Créez/ouvrez un dépôt GitHub.
2. Envoyez **tous les fichiers de ce dossier**, y compris `.github/workflows/pages.yml`.
3. Faites un commit sur la branche `main`.
4. Ouvrez l'onglet **Actions** et attendez la fin de `Deploy Ma Caisse to GitHub Pages`.
5. Dans **Settings → Pages**, vérifiez que la source utilise GitHub Actions si GitHub vous le demande.
6. Ouvrez l'adresse HTTPS fournie par GitHub Pages.

## Supabase
L'application utilise :
- URL : `https://lgzgzavi.supabase.co`
- clé publishable : déjà intégrée dans `index.html`

L'authentification anonyme doit rester activée et les tables/policies Supabase doivent autoriser les opérations de l'utilisateur authentifié.
