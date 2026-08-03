-- =============================================================================
-- 03_warehouses.sql
-- SBI Canada — Création des warehouses
-- Prérequis : avoir exécuté 00_variables.sql dans la même session
-- =============================================================================

USE ROLE SYSADMIN;

CREATE WAREHOUSE IF NOT EXISTS IDENTIFIER($ADMIN_WH)
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND   = 60
  AUTO_RESUME    = TRUE
  COMMENT        = 'Administration Snowflake et scripts de maintenance SBI';

CREATE WAREHOUSE IF NOT EXISTS IDENTIFIER($DEMO_WH)
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND   = 60
  AUTO_RESUME    = TRUE
  COMMENT        = 'Sessions de démonstration SBI';

CREATE WAREHOUSE IF NOT EXISTS IDENTIFIER($TRAINING_WH)
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND   = 120
  AUTO_RESUME    = TRUE
  COMMENT        = 'Sessions de formation et exercices pratiques SBI';

-- Vérification
SHOW WAREHOUSES LIKE '%_WH';
