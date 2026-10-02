# Ma Caisse — Version 1
Application Android de gestion pour Orange Money, Airtel Money, M-Pesa, Afrimoney, caisse, rapports et autres activités.

Cette première version est une maquette fonctionnelle web/PWA prête à être testée sur Android. Elle n'effectue pas encore de transactions réelles auprès des opérateurs.

## Utilisation
Ouvrir `index.html` dans un navigateur. Les données sont conservées localement sur l'appareil dans cette version de démonstration.

Pour la prochaine étape, on peut connecter Supabase afin de sauvegarder les données en ligne.

## Gestion des dettes
Chaque réseau (Orange Money, Airtel Money, M-Pesa et Afrimoney) possède un bouton « Dettes ». Ajoutez le nom du client, le montant et une observation facultative. Lorsque le client paie, utilisez « Paiement reçu » : la dette quitte la liste des dettes en attente et reste visible dans « Dettes réglées » avec sa date de paiement.

Les dettes de cette version sont conservées localement sur l'appareil (localStorage). Elles ne sont pas encore synchronisées avec Supabase.


## Nouvelles fonctions de sécurité
- Signature manuscrite avec le doigt sur l'écran lors de la création d'une dette.
- Signature manuscrite lors du paiement d'une dette.
- Suppression d'une dette ou d'un paiement enregistré par erreur.
- Verrouillage automatique lorsque l'application passe en arrière-plan.
- Après 3 codes incorrects consécutifs, l'application tente une photo avec la caméra frontale et conserve jusqu'à 20 captures localement dans l'application/navigateur. L'autorisation de la caméra et une connexion HTTPS sont nécessaires.
- Les photos de sécurité restent sur l'appareil dans cette version; elles ne sont pas envoyées à Supabase.

### Supabase
Exécuter `supabase_policies.sql` dans le SQL Editor pour ajouter les colonnes de signatures et autoriser la suppression des dettes.
