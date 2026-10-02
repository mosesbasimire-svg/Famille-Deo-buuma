# Ma Caisse — version complète

Fonctions incluses :
- code d'accès `20072007` ;
- verrouillage automatique après passage en arrière-plan et verrouillage manuel ;
- opérations Orange Money, Airtel Money, M-Pesa et Afrimoney ;
- suppression d'une opération depuis l'historique, avec suppression Supabase ;
- dettes et paiements ;
- signature avec le doigt lors de l'enregistrement d'une dette et de son paiement ;
- suppression d'un paiement/d'une dette réglée en cas d'erreur ;
- photo de profil personnelle enregistrée dans Supabase ;
- après 3 codes incorrects, demande de caméra avant et enregistrement d'une capture de sécurité dans Supabase ;
- autres activités, caisse et rapports ;
- dépenses personnelles séparées, avec catégories, total, historique et suppression ;
- fonctionnement local + synchronisation Supabase.

## Installation
1. Remplacez les fichiers du projet GitHub par les fichiers de ce dossier, en gardant votre workflow Android existant si votre compilation fonctionne déjà.
2. Dans Supabase > SQL Editor, exécutez `supabase_policies.sql`.
3. Vérifiez que l'authentification anonyme est activée dans Supabase.
4. Ouvrez l'application via HTTPS (GitHub Pages ou l'application Android configurée pour utiliser cette page) pour que la caméra puisse demander son autorisation.

La clé présente dans `index.html` est une clé publishable côté navigateur. Ne mettez jamais une clé `service_role` dans l'application.


## Dépenses personnelles
La rubrique `💳 Dépenses personnelles` est indépendante des opérations commerciales. Les dépenses sont enregistrées localement et dans Supabase, puis peuvent être supprimées depuis leur historique.
