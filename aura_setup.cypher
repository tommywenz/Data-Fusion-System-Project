// Neo4j Aura import script for the CIS 360 Data Fusion Knowledge Graph
// IMPORTANT:
// 1) Upload all CSV files from this folder into your GitHub repo under: aura_import/
// 2) Because the repo is public, Aura can read the raw GitHub CSV URLs below.
// 3) Then paste this entire script into the Aura Query editor and run it.
// 4) If you store the files in a different folder, replace the base URL everywhere.

// ---------- constraints ----------
CREATE CONSTRAINT paper_id IF NOT EXISTS FOR (p:Paper) REQUIRE p.paper_id IS UNIQUE;
CREATE CONSTRAINT paper_doi IF NOT EXISTS FOR (p:Paper) REQUIRE p.doi IS UNIQUE;
CREATE CONSTRAINT method_id IF NOT EXISTS FOR (m:Method) REQUIRE m.method_id IS UNIQUE;
CREATE CONSTRAINT datasetmention_id IF NOT EXISTS FOR (dm:DatasetMention) REQUIRE dm.datasetmention_id IS UNIQUE;
CREATE CONSTRAINT dataset_id IF NOT EXISTS FOR (d:Dataset) REQUIRE d.dataset_id IS UNIQUE;
CREATE CONSTRAINT uncertainty_code IF NOT EXISTS FOR (u:Uncertainty) REQUIRE u.uncertainty_code IS UNIQUE;

// ---------- node imports ----------
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/papers.csv' AS row
MERGE (p:Paper {paper_id: row.paper_id})
SET p.doi = row.doi,
    p.title = row.title,
    p.authors = row.authors,
    p.publication_title = row.publication_title,
    p.publication_date = row.publication_date,
    p.url = row.url,
    p.keywords = row.keywords,
    p.abstract = row.abstract,
    p.publisher = row.publisher,
    p.field_of_study = row.field_of_study,
    p.is_data_fusion_paper = row.is_data_fusion_paper,
    p.classification_reason = row.classification_reason,
    p.source_group = row.source_group,
    p.source_type = row.source_type;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/methods.csv' AS row
MERGE (m:Method {method_id: row.method_id})
SET m.name = row.method_name,
    m.description = row.method_description,
    m.method_key_original = row.method_key_original,
    m.source_group = row.source_group,
    m.extraction_source = row.extraction_source;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/dataset_mentions.csv' AS row
MERGE (dm:DatasetMention {datasetmention_id: row.datasetmention_id})
SET dm.name = row.data_name,
    dm.dataset_url = row.dataset_url,
    dm.data_type = row.data_type,
    dm.collection_method = row.collection_method,
    dm.spatial_coverage = row.spatial_coverage,
    dm.temporal_coverage = row.temporal_coverage,
    dm.format = row.format,
    dm.license = row.license,
    dm.provenance = row.provenance,
    dm.sensor_type = row.sensor_type,
    dm.source_group = row.source_group,
    dm.extraction_source = row.extraction_source,
    dm.canonical_dataset = row.canonical_dataset;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/datasets.csv' AS row
MERGE (d:Dataset {dataset_id: row.dataset_id})
SET d.name = row.canonical_dataset,
    d.sensor_type = row.sensor_type;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/uncertainty_types.csv' AS row
MERGE (u:Uncertainty {uncertainty_code: row.uncertainty_code})
SET u.name = row.name,
    u.definition = row.definition;

// ---------- relationship imports ----------
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/rel_paper_method.csv' AS row
MATCH (p:Paper {paper_id: row.paper_id})
MATCH (m:Method {method_id: row.method_id})
MERGE (p)-[:USES_METHOD]->(m);

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/rel_paper_datasetmention.csv' AS row
MATCH (p:Paper {paper_id: row.paper_id})
MATCH (dm:DatasetMention {datasetmention_id: row.datasetmention_id})
MERGE (p)-[:MENTIONS_DATASET]->(dm);

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/rel_datasetmention_dataset.csv' AS row
MATCH (dm:DatasetMention {datasetmention_id: row.datasetmention_id})
MATCH (d:Dataset {dataset_id: row.dataset_id})
MERGE (dm)-[:INSTANCE_OF]->(d);

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/rel_method_datasetmention.csv' AS row
MATCH (m:Method {method_id: row.method_id})
MATCH (dm:DatasetMention {datasetmention_id: row.datasetmention_id})
MERGE (m)-[:APPLIED_TO]->(dm);

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/rel_method_dataset.csv' AS row
MATCH (m:Method {method_id: row.method_id})
MATCH (d:Dataset {dataset_id: row.dataset_id})
MERGE (m)-[:APPLIED_TO_CANONICAL]->(d);

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/rel_paper_uncertainty.csv' AS row
MATCH (p:Paper {paper_id: row.paper_id})
MATCH (u:Uncertainty {uncertainty_code: row.uncertainty_code})
MERGE (p)-[r:REPORTS_UNCERTAINTY]->(u)
SET r.description = row.description;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/rel_method_uncertainty.csv' AS row
MATCH (m:Method {method_id: row.method_id})
MATCH (u:Uncertainty {uncertainty_code: row.uncertainty_code})
MERGE (m)-[r:HAS_UNCERTAINTY]->(u)
SET r.description = row.description;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/rel_datasetmention_uncertainty.csv' AS row
MATCH (dm:DatasetMention {datasetmention_id: row.datasetmention_id})
MATCH (u:Uncertainty {uncertainty_code: row.uncertainty_code})
MERGE (dm)-[r:HAS_UNCERTAINTY]->(u)
SET r.description = row.description;

// ---------- verification ----------
MATCH (p:Paper) RETURN count(p) AS paper_count;
MATCH (m:Method) RETURN count(m) AS method_count;
MATCH (dm:DatasetMention) RETURN count(dm) AS datasetmention_count;
MATCH (d:Dataset) RETURN count(d) AS canonical_dataset_count;
MATCH (u:Uncertainty) RETURN count(u) AS uncertainty_count;
