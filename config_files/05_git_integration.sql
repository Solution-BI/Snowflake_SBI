-- =============================================================================
-- 05_git_integration.sql
-- SBI Canada — Intégration Git native Snowflake
-- Repository : Solution-BI/Snowflake_SBI
-- URL        : https://github.com/Solution-BI/Snowflake_SBI
-- Prérequis  : avoir exécuté 00_variables.sql dans la même session
-- =============================================================================
-- ⚠ Avant d'exécuter ce script :
--    1. Créer un Personal Access Token (PAT) GitHub avec le scope "repo" (lecture)
--       → GitHub → Settings → Developer settings → Personal access tokens
--    2. Renseigner le nom d'utilisateur et le PAT dans la section SECRET ci-dessous
--    3. Ne jamais committer ce fichier avec un vrai PAT — utiliser un compte de service
-- =============================================================================

-- -----------------------------------------------------------------------------
-- ÉTAPE 1 : API Integration (run as ACCOUNTADMIN)
-- Objet au niveau compte — déclare GitHub comme provider de dépôt Git autorisé
-- -----------------------------------------------------------------------------
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE API INTEGRATION GITHUB_API_INTEGRATION
  API_PROVIDER         = GIT_HTTPS_API
  API_ALLOWED_PREFIXES = ('https://github.com/Solution-BI/')
  ENABLED              = TRUE
  COMMENT              = 'Intégration GitHub pour le repo Solution-BI/Snowflake_SBI';

-- Vérification
SHOW API INTEGRATIONS LIKE 'GITHUB%';

-- -----------------------------------------------------------------------------
-- ÉTAPE 2 : Secret GitHub PAT (run as SYSADMIN)
-- Stocke les credentials GitHub comme objet Snowflake chiffré
-- ⚠ Remplacer les deux placeholders avant d'exécuter
-- -----------------------------------------------------------------------------
USE ROLE SYSADMIN;
USE DATABASE   IDENTIFIER($GIT_DB);
USE SCHEMA     IDENTIFIER($GIT_SCHEMA);

CREATE OR REPLACE SECRET GITHUB_PAT_SECRET
  TYPE     = PASSWORD
  USERNAME = '<GITHUB_SERVICE_ACCOUNT_USERNAME>'   -- ex: sbi-snowflake-bot
  PASSWORD = '<GITHUB_PAT_TOKEN>'                  -- token généré sur GitHub
  COMMENT  = 'PAT GitHub pour accès en lecture au repo Solution-BI/Snowflake_SBI';

-- -----------------------------------------------------------------------------
-- ÉTAPE 3 : Objet GIT REPOSITORY (run as SYSADMIN)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE GIT REPOSITORY SNOWFLAKE_SBI_REPO
  API_INTEGRATION = GITHUB_API_INTEGRATION
  GIT_CREDENTIALS = GITHUB_PAT_SECRET
  ORIGIN          = 'https://github.com/Solution-BI/Snowflake_SBI'
  COMMENT         = 'Repo d''initialisation du compte Snowflake SBI Canada';

-- -----------------------------------------------------------------------------
-- ÉTAPE 4 : Vérification — déclenche un fetch depuis GitHub
-- -----------------------------------------------------------------------------
ALTER GIT REPOSITORY SNOWFLAKE_SBI_REPO FETCH;

-- Lister les branches disponibles dans le repo
SHOW GIT BRANCHES IN GIT REPOSITORY SNOWFLAKE_SBI_REPO;

-- Lister les fichiers à la racine de la branche main
-- LS @SNOWFLAKE_SBI_REPO/branches/main/;

-- -----------------------------------------------------------------------------
-- ÉTAPE 5 : Grants sur les objets Git (run as SYSADMIN)
-- ADMIN_ROLE peut lire le repo ; les autres rôles n'en ont pas besoin
-- -----------------------------------------------------------------------------
GRANT READ ON SECRET GITHUB_PAT_SECRET
  TO ROLE IDENTIFIER($ADMIN_ROLE);

GRANT USAGE ON INTEGRATION GITHUB_API_INTEGRATION
  TO ROLE IDENTIFIER($ADMIN_ROLE);
