# Databricks Metadata Intelligence Demo

This implementation rebuilds the Snowflake/OpenAI workflow as a Databricks-native stack in a single schema:

- Catalog: `jack_demos_classic`
- Schema: `data_catalogue_demo`

## Deployed Components

- Lakeflow Declarative Pipeline SQL files in `pipeline/`
  - Synthetic Snowflake-like source objects
  - Metadata ingestion + AI enrichment using `ai_query`
  - `metadata_docs` for vector search
- Vector Search index on `metadata_docs`
- Evaluation runner in `eval/run_agent_evaluation.py`

## Key Tables

- `sf_mock_databases`
- `sf_mock_tables`
- `sf_mock_columns`
- `metadata_ingestion`
- `metadata_generation_raw`
- `metadata_generation_extraction`
- `metadata_docs`

## Deployment Notes

- Pipeline creates and refreshes all workflow objects in schema.
- Vector Search endpoint/index is deployed separately against `metadata_docs`.
- AI-generated metadata comments are produced in-pipeline via `ai_query`.
