CREATE OR REFRESH MATERIALIZED VIEW metadata_ingestion AS
SELECT
  d.database_name,
  d.database_owner,
  d.database_comment,
  d.retention_time,
  t.table_schema AS schema_name,
  t.table_name,
  t.table_type,
  t.table_owner,
  t.row_count AS table_row_count,
  t.bytes AS table_bytes,
  t.created AS table_date_created,
  t.last_altered AS table_last_altered,
  t.table_user_comment,
  c.column_name,
  c.ordinal_position AS column_position,
  c.data_type,
  c.is_nullable,
  c.column_default_value AS column_default,
  c.column_comment,
  COUNT(*) OVER (PARTITION BY t.table_catalog, t.table_schema, t.table_name) AS total_columns_in_table,
  'snowflake_mock.information_schema' AS source,
  'SnowflakeMock' AS source_environment,
  'Metadata' AS source_type,
  current_timestamp() AS ingestion_timestamp
FROM sf_mock_databases d
JOIN sf_mock_tables t
  ON d.database_name = t.table_catalog
LEFT JOIN sf_mock_columns c
  ON t.table_catalog = c.table_catalog
 AND t.table_schema = c.table_schema
 AND t.table_name = c.table_name;

CREATE OR REFRESH MATERIALIZED VIEW metadata_generation_raw AS
SELECT
  database_name,
  schema_name,
  table_name,
  MAX(table_user_comment) AS table_user_comment,
  ai_query(
    'databricks-gpt-5-2',
    CONCAT(
      'You are generating a concise data catalog table description. ',
      'Return plain text only (no markdown, no JSON), 1-2 sentences. ',
      'Table: ', database_name, '.', schema_name, '.', table_name, '. ',
      'User table comment: ', COALESCE(MAX(table_user_comment), 'None provided'), '. ',
      'Columns in table: ', CAST(COUNT(*) AS STRING), '.'
    ),
    named_struct('temperature', 1)
  ) AS ai_generated_table_description,
  ai_query(
    'databricks-gpt-5-2',
    CONCAT(
      'Summarize the table columns for a catalog entry. ',
      'Return plain text only (no markdown, no JSON), 2-4 short sentences. ',
      'Table: ', database_name, '.', schema_name, '.', table_name, '. ',
      'Columns: ',
      CONCAT_WS(
        '; ',
        SORT_ARRAY(
          COLLECT_LIST(
            CONCAT(
              column_name,
              ' (', data_type, ', nullable=', is_nullable, ')',
              ' - ',
              COALESCE(column_comment, 'No comment provided')
            )
          )
        )
      )
    ),
    named_struct('temperature', 1)
  ) AS ai_generated_column_description,
  TO_JSON(SORT_ARRAY(COLLECT_LIST(column_name))) AS ai_generated_list_of_columns,
  'databricks-gpt-5-2' AS generation_model,
  'v1_ai_query_pipeline' AS prompt_version,
  CAST(NULL AS BIGINT) AS estimated_input_tokens,
  CAST(NULL AS BIGINT) AS estimated_output_tokens,
  current_timestamp() AS generation_timestamp
FROM metadata_ingestion
GROUP BY database_name, schema_name, table_name;

CREATE OR REFRESH MATERIALIZED VIEW metadata_generation_extraction AS
SELECT
  database_name,
  schema_name,
  table_name,
  table_user_comment,
  ai_generated_table_description,
  ai_generated_column_description,
  ai_generated_list_of_columns,
  generation_model,
  prompt_version,
  estimated_input_tokens,
  estimated_output_tokens,
  generation_timestamp,
  current_timestamp() AS extraction_timestamp
FROM metadata_generation_raw;
