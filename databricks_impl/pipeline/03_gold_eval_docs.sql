CREATE OR REFRESH MATERIALIZED VIEW metadata_docs
TBLPROPERTIES ('delta.enableChangeDataFeed' = 'true') AS
SELECT
  CONCAT(database_name, '.', schema_name, '.', table_name) AS doc_id,
  database_name,
  schema_name,
  table_name,
  CONCAT(database_name, '.', schema_name, '.', table_name) AS full_table_name,
  CONCAT(
    '# ', database_name, '.', schema_name, '.', table_name, '\n\n',
    '## Business Description\n',
    COALESCE(ai_generated_table_description, 'No generated description.'), '\n\n',
    '## User Comment\n',
    COALESCE(table_user_comment, 'No table comment provided.'), '\n\n',
    '## Columns\n',
    COALESCE(ai_generated_column_description, 'No column descriptions available.')
  ) AS content,
  current_timestamp() AS doc_updated_at
FROM metadata_generation_extraction;
