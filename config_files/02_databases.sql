-- =============================================================================
-- 02_databases.sql
-- SBI Canada — Création des bases de données
-- Prérequis : avoir exécuté 00_variables.sql dans la même session
-- =============================================================================

USE ROLE SYSADMIN;

CREATE DATABASE IF NOT EXISTS IDENTIFIER($DEMO_DB)
  COMMENT = 'Base dédiée aux environnements de démonstration SBI';

CREATE DATABASE IF NOT EXISTS IDENTIFIER($TRAINING_DB)
  COMMENT = 'Base dédiée aux formations et montée en compétences';

CREATE DATABASE IF NOT EXISTS IDENTIFIER($PROJECTS_DB)
  COMMENT = 'Base destinée aux projets clients — vide lors de l''initialisation';

-- Vérification
SHOW DATABASES LIKE '%_DB';
