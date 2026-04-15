// Required and supporting queries for the CIS 360 final demo in Neo4j Aura

// 1) Linkage query required by rubric
// Find all fusion methods that have been applied to both Dataset A and Dataset B
MATCH (m:Method)-[:APPLIED_TO_CANONICAL]->(d1:Dataset {name:'WHU Building Dataset'})
MATCH (m)-[:APPLIED_TO_CANONICAL]->(d2:Dataset {name:'Boston Building Dataset'})
RETURN DISTINCT m.name AS fusion_method
ORDER BY fusion_method;

// 2) Uncertainty query required by rubric
// Find all papers that report U2 (Measurement) uncertainty for a specific sensor type
MATCH (p:Paper)-[:MENTIONS_DATASET]->(dm:DatasetMention {sensor_type:'Aerial Imagery + LiDAR'})
MATCH (dm)-[r:HAS_UNCERTAINTY]->(u:Uncertainty {uncertainty_code:'U2'})
RETURN DISTINCT p.title AS paper, dm.name AS dataset_mention, r.description AS u2_measurement_uncertainty
ORDER BY paper, dataset_mention;

// 3) Discovery query required by rubric
// Find the most popular dataset in the graph by number of distinct methods
MATCH (d:Dataset)<-[:APPLIED_TO_CANONICAL]-(m:Method)
RETURN d.name AS dataset, count(DISTINCT m) AS distinct_methods
ORDER BY distinct_methods DESC, dataset ASC
LIMIT 10;

// 4) Requirement example from rubric
// Show all fusion methods used for Traffic Data (or any keyword you choose)
MATCH (m:Method)-[:APPLIED_TO_CANONICAL]->(d:Dataset)
WHERE toLower(d.name) CONTAINS toLower('traffic') OR toLower(d.sensor_type) CONTAINS toLower('traffic')
RETURN DISTINCT d.name AS dataset, d.sensor_type AS sensor_type, m.name AS method
ORDER BY dataset, method;

// 5) Requirement example from rubric
// List all papers that report U2 uncertainty for Satellite Imagery (or close sensor families)
MATCH (p:Paper)-[:MENTIONS_DATASET]->(dm:DatasetMention)
MATCH (dm)-[r:HAS_UNCERTAINTY]->(u:Uncertainty {uncertainty_code:'U2'})
WHERE toLower(dm.sensor_type) CONTAINS toLower('imagery') OR toLower(dm.sensor_type) CONTAINS toLower('satellite')
RETURN DISTINCT p.title AS paper, dm.sensor_type AS sensor_type, dm.name AS dataset_mention, r.description AS measurement_issue
ORDER BY paper;

// 6) Requirement example from rubric
// Which datasets are commonly fused with Census Data? (template example)
MATCH (seed:Dataset {name:'Census Data'})<-[:APPLIED_TO_CANONICAL]-(m:Method)-[:APPLIED_TO_CANONICAL]->(other:Dataset)
WHERE other.name <> seed.name
RETURN other.name AS related_dataset, count(DISTINCT m) AS shared_methods
ORDER BY shared_methods DESC, related_dataset;

// 7) Project-specific discovery query that is guaranteed to return data in this graph
MATCH (seed:Dataset {name:'SITW 2016'})<-[:APPLIED_TO_CANONICAL]-(m:Method)-[:APPLIED_TO_CANONICAL]->(other:Dataset)
WHERE other.name <> seed.name
RETURN other.name AS related_dataset, count(DISTINCT m) AS shared_methods
ORDER BY shared_methods DESC, related_dataset;

// 8) Short sanity query for the professor
MATCH (p:Paper) RETURN count(p) AS papers;
MATCH (m:Method) RETURN count(m) AS methods;
MATCH (dm:DatasetMention) RETURN count(dm) AS dataset_mentions;
MATCH (d:Dataset) RETURN count(d) AS canonical_datasets;
MATCH (u:Uncertainty) RETURN count(u) AS uncertainty_types;
