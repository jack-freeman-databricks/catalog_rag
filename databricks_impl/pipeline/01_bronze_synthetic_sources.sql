CREATE OR REFRESH MATERIALIZED VIEW sf_mock_databases AS
SELECT *
FROM VALUES
  ('FINANCE_DB', 'finance_platform_team', 'Finance and reporting source domain', 7),
  ('SALES_DB', 'sales_ops_team', 'Sales enablement and customer pipeline source domain', 7),
  ('SUPPLY_DB', 'supply_chain_team', 'Procurement and inventory source domain', 7),
  ('MARKETING_DB', 'growth_team', 'Campaign attribution and channel spend source domain', 7)
AS t(
  database_name,
  database_owner,
  database_comment,
  retention_time
);

CREATE OR REFRESH MATERIALIZED VIEW sf_mock_tables AS
SELECT *
FROM VALUES
  ('FINANCE_DB', 'GL', 'GENERAL_LEDGER', 'BASE TABLE', 'fin_owner', 1200000, 1850000000, current_timestamp(), current_timestamp(), 'Accounting journal entries by period'),
  ('FINANCE_DB', 'AP', 'INVOICES', 'BASE TABLE', 'fin_owner', 230000, 245000000, current_timestamp(), current_timestamp(), 'Accounts payable invoices from ERP'),
  ('SALES_DB', 'CRM', 'OPPORTUNITIES', 'BASE TABLE', 'sales_owner', 950000, 760000000, current_timestamp(), current_timestamp(), 'Sales opportunities and pipeline status'),
  ('SALES_DB', 'CRM', 'ACCOUNTS', 'BASE TABLE', 'sales_owner', 110000, 180000000, current_timestamp(), current_timestamp(), 'Customer accounts and segmentation attributes'),
  ('SUPPLY_DB', 'WAREHOUSE', 'INVENTORY_SNAPSHOT', 'BASE TABLE', 'supply_owner', 4900000, 4200000000, current_timestamp(), current_timestamp(), 'Daily inventory levels by SKU and location'),
  ('MARKETING_DB', 'ATTRIBUTION', 'CAMPAIGN_PERFORMANCE', 'BASE TABLE', 'mkt_owner', 1750000, 910000000, current_timestamp(), current_timestamp(), 'Campaign performance by channel and date')
AS t(
  table_catalog,
  table_schema,
  table_name,
  table_type,
  table_owner,
  row_count,
  bytes,
  created,
  last_altered,
  table_user_comment
);

CREATE OR REFRESH MATERIALIZED VIEW sf_mock_columns AS
SELECT *
FROM VALUES
  ('FINANCE_DB', 'GL', 'GENERAL_LEDGER', 'ENTRY_ID', 1, 'STRING', 'NO', '', 'Unique journal entry identifier'),
  ('FINANCE_DB', 'GL', 'GENERAL_LEDGER', 'POSTING_DATE', 2, 'DATE', 'NO', '', 'Accounting posting date'),
  ('FINANCE_DB', 'GL', 'GENERAL_LEDGER', 'ACCOUNT_CODE', 3, 'STRING', 'NO', '', 'General ledger account code'),
  ('FINANCE_DB', 'GL', 'GENERAL_LEDGER', 'AMOUNT_LOCAL', 4, 'DECIMAL(18,2)', 'NO', '', 'Transaction amount in local currency'),
  ('FINANCE_DB', 'AP', 'INVOICES', 'INVOICE_ID', 1, 'STRING', 'NO', '', 'Unique supplier invoice ID'),
  ('FINANCE_DB', 'AP', 'INVOICES', 'SUPPLIER_ID', 2, 'STRING', 'NO', '', 'Supplier identifier'),
  ('FINANCE_DB', 'AP', 'INVOICES', 'INVOICE_DATE', 3, 'DATE', 'NO', '', 'Invoice issue date'),
  ('FINANCE_DB', 'AP', 'INVOICES', 'INVOICE_TOTAL', 4, 'DECIMAL(18,2)', 'NO', '', 'Total invoice value'),
  ('SALES_DB', 'CRM', 'OPPORTUNITIES', 'OPPORTUNITY_ID', 1, 'STRING', 'NO', '', 'Sales opportunity ID'),
  ('SALES_DB', 'CRM', 'OPPORTUNITIES', 'ACCOUNT_ID', 2, 'STRING', 'NO', '', 'Foreign key to account'),
  ('SALES_DB', 'CRM', 'OPPORTUNITIES', 'STAGE', 3, 'STRING', 'NO', '', 'Current sales stage'),
  ('SALES_DB', 'CRM', 'OPPORTUNITIES', 'EXPECTED_ARR', 4, 'DECIMAL(18,2)', 'YES', '', 'Expected annual recurring revenue'),
  ('SALES_DB', 'CRM', 'ACCOUNTS', 'ACCOUNT_ID', 1, 'STRING', 'NO', '', 'Account identifier'),
  ('SALES_DB', 'CRM', 'ACCOUNTS', 'ACCOUNT_NAME', 2, 'STRING', 'NO', '', 'Customer legal name'),
  ('SALES_DB', 'CRM', 'ACCOUNTS', 'SEGMENT', 3, 'STRING', 'YES', '', 'Commercial segment classification'),
  ('SUPPLY_DB', 'WAREHOUSE', 'INVENTORY_SNAPSHOT', 'SNAPSHOT_DATE', 1, 'DATE', 'NO', '', 'Daily snapshot date'),
  ('SUPPLY_DB', 'WAREHOUSE', 'INVENTORY_SNAPSHOT', 'SKU_ID', 2, 'STRING', 'NO', '', 'Stock keeping unit identifier'),
  ('SUPPLY_DB', 'WAREHOUSE', 'INVENTORY_SNAPSHOT', 'LOCATION_ID', 3, 'STRING', 'NO', '', 'Warehouse location identifier'),
  ('SUPPLY_DB', 'WAREHOUSE', 'INVENTORY_SNAPSHOT', 'ON_HAND_QTY', 4, 'INT', 'NO', '', 'On hand inventory quantity'),
  ('MARKETING_DB', 'ATTRIBUTION', 'CAMPAIGN_PERFORMANCE', 'CAMPAIGN_ID', 1, 'STRING', 'NO', '', 'Campaign identifier'),
  ('MARKETING_DB', 'ATTRIBUTION', 'CAMPAIGN_PERFORMANCE', 'CHANNEL', 2, 'STRING', 'NO', '', 'Marketing channel'),
  ('MARKETING_DB', 'ATTRIBUTION', 'CAMPAIGN_PERFORMANCE', 'EVENT_DATE', 3, 'DATE', 'NO', '', 'Attribution event date'),
  ('MARKETING_DB', 'ATTRIBUTION', 'CAMPAIGN_PERFORMANCE', 'SPEND_USD', 4, 'DECIMAL(18,2)', 'NO', '', 'Daily media spend in USD')
AS t(
  table_catalog,
  table_schema,
  table_name,
  column_name,
  ordinal_position,
  data_type,
  is_nullable,
  column_default_value,
  column_comment
);
