# Snowflake_SBI
Git repo to find initialization files for account set up

# SBI — Initialisation Snowflake

Scripts d'initialisation du compte Snowflake SBI Canada. Paramétrables et reproductibles pour le déploiement sur d'autres filiales.

## Structure

```
snowflake_SBI/
├── config_files/
│   ├── 01_rbac_sso.sql         ← intégration SCIM, SSO, rôles, pont SCIM → fonctionnel
│   ├── 02_databases.sql        ← DEMO_DB, TRAINING_DB, PROJECTS_DB
│   ├── 03_warehouses.sql       ← ADMIN_WH, DEMO_WH, TRAINING_WH
│   └── 04_grants.sql           ← tous les grants de permissions
└── README.md
```

## Prérequis

- [SnowSQL CLI](https://docs.snowflake.com/en/user-guide/snowsql) installé
- Accès ACCOUNTADMIN sur le compte Snowflake cible
- Groupes Azure AD créés (`SBI_SNOW_ADMIN`, `SBI_SNOW_DEMO`, `SBI_SNOW_TRAINING`)

## Déploiement

```bash
# Rendre le script exécutable (une seule fois)
chmod +x deploy.sh

# Déployer pour SBI Canada
./deploy.sh config/sbi-canada.env
```

## Ajouter une nouvelle filiale

1. Copier le modèle : `cp config/template.env.example config/sbi-<filiale>.env`
2. Remplir les variables du fichier `.env` (compte, région, groupes AAD)
3. Créer les groupes AAD correspondants dans l'annuaire de la filiale
4. Exécuter : `./deploy.sh config/sbi-<filiale>.env`
5. Activer SCIM et SSO manuellement (voir guide d'initialisation)

## Architecture des accès

| Rôle         | Bases accessibles | Warehouse    |
|--------------|-------------------|--------------|
| ADMIN_ROLE   | Tout              | Tous         |
| DEMO_ROLE    | DEMO_DB           | DEMO_WH      |
| TRAINING_ROLE| TRAINING_DB       | TRAINING_WH  |

## Étapes manuelles post-déploiement

Les scripts automatisent la création des objets Snowflake. Les étapes SSO/SCIM restent manuelles car elles nécessitent des actions dans le portail Azure :

1. Récupérer le token SCIM (généré dans `01_rbac_sso.sql`)
2. Coller le token dans l'application Enterprise Azure → Provisionnement
3. Attendre le premier cycle de provisionnement
4. Renseigner les valeurs SAML dans `01_rbac_sso.sql` et activer le SSO

Référencer le **Guide d'initialisation Snowflake SBI** pour les instructions détaillées.
