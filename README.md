# Ma Caisse — version complète Supabase

Cette version conserve les activités : Orange Money, Airtel Money, M-Pesa, Afrimoney, Caisse, Rapports et Autres activités.

Fonctions incluses :
- synchronisation Supabase des opérations, activités et dettes ;
- suppression d'une opération dans l'historique ;
- suppression d'une dette ;
- annulation d'un paiement enregistré par erreur ;
- signature manuscrite avec le doigt à la prise de dette ;
- signature manuscrite avec le doigt au paiement ;
- verrouillage lorsque l'application passe en arrière-plan ;
- après 3 faux codes, demande d'accès à la caméra frontale et capture de sécurité ;
- stockage des captures de sécurité dans Supabase Storage ;
- photo de profil avec stockage Supabase ;
- fonctionnement HTTPS/PWA.

## Mise en place
1. Remplacer les fichiers du projet par ceux de ce dossier.
2. Dans Supabase > SQL Editor > +, coller tout `supabase_policies.sql` puis Run.
3. Vérifier que l'authentification anonyme est activée.
4. Ouvrir le site depuis HTTPS (GitHub Pages) pour que la caméra fonctionne.
5. Compiler ensuite avec le workflow GitHub existant.

Le fichier `.github/workflows` n'est volontairement pas inclus : conserve ton workflow de compilation actuel s'il fonctionne déjà.
