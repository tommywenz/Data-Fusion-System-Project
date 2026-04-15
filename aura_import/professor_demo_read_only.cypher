// Read-only demo script for the professor in Neo4j Aura
// This script only reads the graph. It does not create, delete, or modify anything.

MATCH (p:Paper) RETURN count(p) AS papers;
MATCH (m:Method) RETURN count(m) AS methods;
MATCH (dm:DatasetMention) RETURN count(dm) AS dataset_mentions;
MATCH (d:Dataset) RETURN count(d) AS canonical_datasets;
MATCH (u:Uncertainty) RETURN count(u) AS uncertainty_types;

MATCH (p:Paper)
RETURN p.source_group AS group_part, p.title AS title, p.doi AS doi, p.is_data_fusion_paper AS classified_as_fusion
ORDER BY group_part, title;

MATCH (m:Method)-[:APPLIED_TO_CANONICAL]->(:Dataset {name:'WHU Building Dataset'})
MATCH (m)-[:APPLIED_TO_CANONICAL]->(:Dataset {name:'Boston Building Dataset'})
RETURN DISTINCT m.name AS linkage_methods;

MATCH (p:Paper)-[:MENTIONS_DATASET]->(dm:DatasetMention {sensor_type:'Aerial Imagery + LiDAR'})
MATCH (dm)-[r:HAS_UNCERTAINTY]->(:Uncertainty {uncertainty_code:'U2'})
RETURN DISTINCT p.title AS paper, dm.name AS dataset_mention, r.description AS u2_note
ORDER BY paper;

MATCH (d:Dataset)<-[:APPLIED_TO_CANONICAL]-(m:Method)
RETURN d.name AS dataset, count(DISTINCT m) AS distinct_methods
ORDER BY distinct_methods DESC, dataset ASC
LIMIT 10;
