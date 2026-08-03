-- =============================================================================
-- 01_rbac_sso.sql
-- SBI Canada — Intégration SCIM, SSO SAML, rôles fonctionnels
-- Prérequis : avoir exécuté 00_variables.sql dans la même session
-- =============================================================================

-- -----------------------------------------------------------------------------
-- SCIM : intégration Azure AD (run as ACCOUNTADMIN)
-- -----------------------------------------------------------------------------
USE ROLE ACCOUNTADMIN;

CREATE SECURITY INTEGRATION IF NOT EXISTS AZURE_AD_SCIM
  TYPE        = SCIM
  SCIM_CLIENT = 'AZURE'
  RUN_AS_ROLE = 'USERADMIN'
  COMMENT     = 'Synchronisation SCIM entre Azure Entra ID et Snowflake';

-- Copier ce token dans Azure (champ Secret Token du provisionnement SCIM)
SELECT SYSTEM$GENERATE_SCIM_ACCESS_TOKEN('AZURE_AD_SCIM');

-- Vérification après le premier cycle de provisionnement AAD
-- SHOW ROLES LIKE 'SBI_SNOW_%';

-- -----------------------------------------------------------------------------
-- SSO SAML (run as ACCOUNTADMIN — activer APRÈS provisionnement SCIM)
-- Remplacer les placeholders par les valeurs du fichier metadata Azure
-- -----------------------------------------------------------------------------
-- ALTER ACCOUNT SET SAML_IDENTITY_PROVIDER = '{
--   "certificate": "<CERT_BASE64_DEPUIS_METADATA_AZURE>",
--   "ssoUrl":      "<SSO_LOGIN_URL_DEPUIS_AZURE>",
--   "type":        "ADFS",
--   "label":       "AzureAD"
-- }';
-- ALTER ACCOUNT SET SSO_LOGIN_PAGE = TRUE;

-- -----------------------------------------------------------------------------
-- Rôles fonctionnels (run as USERADMIN)
-- -----------------------------------------------------------------------------
USE ROLE USERADMIN;

CREATE ROLE IF NOT EXISTS IDENTIFIER($ADMIN_ROLE)
  COMMENT = 'Accès complet à tous les objets SBI Snowflake';
CREATE ROLE IF NOT EXISTS IDENTIFIER($DEMO_ROLE)
  COMMENT = 'Accès en lecture seule à DEMO_DB — environnements de démonstration';
CREATE ROLE IF NOT EXISTS IDENTIFIER($TRAINING_ROLE)
  COMMENT = 'Accès en lecture seule à TRAINING_DB — sessions de formation';

-- Pont SCIM → fonctionnel
GRANT ROLE IDENTIFIER($ADMIN_ROLE)    TO ROLE IDENTIFIER($ADMIN_AAD_GROUP);
GRANT ROLE IDENTIFIER($DEMO_ROLE)     TO ROLE IDENTIFIER($DEMO_AAD_GROUP);
GRANT ROLE IDENTIFIER($TRAINING_ROLE) TO ROLE IDENTIFIER($TRAINING_AAD_GROUP);

-- Hiérarchie fonctionnelle : ADMIN_ROLE hérite de DEMO et TRAINING
GRANT ROLE IDENTIFIER($DEMO_ROLE)     TO ROLE IDENTIFIER($ADMIN_ROLE);
GRANT ROLE IDENTIFIER($TRAINING_ROLE) TO ROLE IDENTIFIER($ADMIN_ROLE);

-- -----------------------------------------------------------------------------
-- Élever ADMIN_ROLE dans la hiérarchie système (run as SECURITYADMIN)
-- -----------------------------------------------------------------------------
USE ROLE SECURITYADMIN;
GRANT ROLE IDENTIFIER($ADMIN_ROLE) TO ROLE SYSADMIN;
