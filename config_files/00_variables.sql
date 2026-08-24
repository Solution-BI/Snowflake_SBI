-- =============================================================================
-- 00_variables.sql
-- SBI Canada — Seul fichier à modifier avant de lancer les autres scripts
-- Exécuter en premier, dans la même session que les scripts suivants
-- =============================================================================

-- ─── Groupes Azure AD (noms exacts des groupes AAD) ──────────────────────────
SET ADMIN_AAD_GROUP    = 'SF_NAM-ADMIN-USERS';
SET DEMO_AAD_GROUP     = 'SF_NAM-DEMO-USERS';
SET TRAINING_AAD_GROUP = 'SF_NAM-TRAINING-USERS';

-- ─── Rôles fonctionnels ───────────────────────────────────────────────────────
SET ADMIN_ROLE    = 'ADMIN_ROLE';
SET DEMO_ROLE     = 'DEMO_ROLE';
SET TRAINING_ROLE = 'TRAINING_ROLE';

-- ─── Bases de données ─────────────────────────────────────────────────────────
SET DEMO_DB     = 'DEMO_DB';
SET TRAINING_DB = 'TRAINING_DB';
SET PROJECTS_DB = 'PROJECTS_DB';

-- ─── Warehouses ───────────────────────────────────────────────────────────────
SET ADMIN_WH    = 'ADMIN_WH';
SET DEMO_WH     = 'DEMO_WH';
SET TRAINING_WH = 'TRAINING_WH';

-- ─── Intégration Git ──────────────────────────────────────────────────────────
-- Base et schema où seront stockés les objets Git (SECRET, GIT REPOSITORY)
SET GIT_DB     = 'PROJECTS_DB';
SET GIT_SCHEMA = 'PUBLIC';
