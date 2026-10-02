# Ma Caisse — Version 1
Application Android de gestion pour Orange Money, Airtel Money, M-Pesa, Afrimoney, caisse, rapports et autres activités.

Cette première version est une maquette fonctionnelle web/PWA prête à être testée sur Android. Elle n'effectue pas encore de transactions réelles auprès des opérateurs.

## Utilisation
Ouvrir `index.html` dans un navigateur. Les données sont conservées localement sur l'appareil dans cette version de démonstration.

Pour la prochaine étape, on peut connecter Supabase afin de sauvegarder les données en ligne.

## Gestion des dettes
Chaque réseau (Orange Money, Airtel Money, M-Pesa et Afrimoney) possède un bouton « Dettes ». Ajoutez le nom du client, le montant et une observation facultative. Lorsque le client paie, utilisez « Paiement reçu » : la dette quitte la liste des dettes en attente et reste visible dans « Dettes réglées » avec sa date de paiement.

Les dettes de cette version sont conservées localement sur l'appareil (localStorage). Elles ne sont pas encore synchronisées avec Supabase.
