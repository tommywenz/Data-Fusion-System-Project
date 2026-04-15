# Neo4j Aura Project Bundle — 20-Paper Data Fusion Knowledge Graph

This folder is the Aura-ready Phase 3 build for the CIS 360 project.

## What this bundle contains
- `aura_setup.cypher` — creates constraints, nodes, and relationships in Neo4j Aura.
- `aura_queries.cypher` — the required rubric queries plus extra search examples.
- `professor_demo_read_only.cypher` — safe demo queries only.
- `papers.csv`, `methods.csv`, `dataset_mentions.csv`, `datasets.csv`, `uncertainty_types.csv`
- relationship CSV files beginning with `rel_`
- `raw_structured_dataset_full.csv` — full extracted table for submission.
- `raw_structured_dataset_required_columns.csv` — the minimum required spreadsheet columns from the rubric.
- `ontology_diagram.png` — visual model for the final report.

## Graph model used
- `(:Paper)`
- `(:Method)`
- `(:DatasetMention)`
- `(:Dataset)`
- `(:Uncertainty)`

Relationships:
- `(:Paper)-[:USES_METHOD]->(:Method)`
- `(:Paper)-[:MENTIONS_DATASET]->(:DatasetMention)`
- `(:DatasetMention)-[:INSTANCE_OF]->(:Dataset)`
- `(:Method)-[:APPLIED_TO]->(:DatasetMention)`
- `(:Method)-[:APPLIED_TO_CANONICAL]->(:Dataset)`
- `(:Paper)-[:REPORTS_UNCERTAINTY]->(:Uncertainty)`
- `(:Method)-[:HAS_UNCERTAINTY]->(:Uncertainty)`
- `(:DatasetMention)-[:HAS_UNCERTAINTY]->(:Uncertainty)`

## Exact Aura setup steps
1. In your GitHub repo, create a folder named `aura_import`.
2. Upload every file from this folder into `aura_import`.
3. Wait until GitHub finishes saving the files to the `main` branch.
4. In your browser, confirm one raw file opens correctly. Example:
   `https://raw.githubusercontent.com/tommywenz/Data-Fusion-System-Project/main/aura_import/papers.csv`
5. Open Neo4j Aura and go to the Query editor.
6. Open `aura_setup.cypher` in a text editor.
7. Copy the entire contents of `aura_setup.cypher`.
8. Paste the script into the Aura Query editor.
9. Run the script.
10. Check the verification results at the bottom. They should return:
   - 20 papers
   - 27 methods
   - 52 dataset mentions
   - 33 canonical datasets
   - 3 uncertainty types
11. Open `aura_queries.cypher`.
12. Run the linkage, uncertainty, and discovery queries one by one.
13. Take screenshots of the query text and the results for your report.
14. Use `professor_demo_read_only.cypher` during class demo or grading.

## Important Aura note
Aura cannot read local `file:///...` imports the way Neo4j Desktop does. It can import CSV files from remote URLs, including HTTPS URLs, or you can use Aura's import tooling. This bundle uses the HTTPS `LOAD CSV` approach through raw GitHub links.

## Screenshots to include in the final report
1. Graph ontology diagram (`ontology_diagram.png`)
2. Verification counts after import
3. Linkage query and result
4. U2 uncertainty query and result
5. Discovery query and result
6. Optional graph visualization after import

## Suggested report talking points
- Why graph instead of Excel: data fusion is inherently relational and many-to-many.
- Why `DatasetMention` and `Dataset` are both used: exact paper wording is preserved while canonical grouping supports discovery queries.
- How uncertainty is modeled: U1/U2/U3 are explicit nodes and can be linked to papers, methods, and dataset mentions.
- Hardest ETL issue: standardizing inconsistent method names and dataset naming across papers.

## If you need to start over in Aura
Run this only if you intentionally want to wipe the database:
```cypher
MATCH (n) DETACH DELETE n;
DROP CONSTRAINT paper_id IF EXISTS;
DROP CONSTRAINT paper_doi IF EXISTS;
DROP CONSTRAINT method_id IF EXISTS;
DROP CONSTRAINT datasetmention_id IF EXISTS;
DROP CONSTRAINT dataset_id IF EXISTS;
DROP CONSTRAINT uncertainty_code IF EXISTS;
```
