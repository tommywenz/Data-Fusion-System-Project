# Final Report Draft — Neo4j Aura Version

## 1. Ontology Design
Our group implemented the Phase 3 system in Neo4j Aura as a graph database because the project is centered on relationships between papers, datasets, methods, and uncertainty. A graph model is more appropriate than a flat spreadsheet because the same paper can mention multiple datasets and multiple methods, while the same method can also be reused across different datasets. This many-to-many structure is the core of the data-fusion problem.

### Nodes
- **Paper**: the research article, identified by `paper_id` and DOI.
- **Method**: the fusion technique, model, or algorithm used in the paper.
- **DatasetMention**: the exact dataset wording taken from a specific paper.
- **Dataset**: a canonical grouping of dataset mentions to support discovery queries.
- **Uncertainty**: one of the Three-Filter categories: U1, U2, or U3.

### Relationships
- `Paper -> USES_METHOD -> Method`
- `Paper -> MENTIONS_DATASET -> DatasetMention`
- `DatasetMention -> INSTANCE_OF -> Dataset`
- `Method -> APPLIED_TO -> DatasetMention`
- `Method -> APPLIED_TO_CANONICAL -> Dataset`
- `Paper -> REPORTS_UNCERTAINTY -> Uncertainty`
- `Method -> HAS_UNCERTAINTY -> Uncertainty`
- `DatasetMention -> HAS_UNCERTAINTY -> Uncertainty`

This structure preserves the original wording from the papers while still allowing broader graph analytics.

## 2. How Uncertainty Was Modeled
The project rubric emphasized the Three-Filter framework. We modeled uncertainty as explicit nodes labeled `Uncertainty` with codes U1, U2, and U3.

- **U1 (Conception)** captures ambiguity in how the real-world problem is defined or abstracted.
- **U2 (Measurement)** captures issues such as sensor noise, calibration drift, image resolution limits, or missing data.
- **U3 (Analysis)** captures algorithmic bias, model assumptions, and processing error.

These uncertainty nodes are connected not only to papers, but also to methods and dataset mentions. That means a user can ask whether a given sensor type tends to have measurement uncertainty, or whether a specific method is commonly associated with analysis uncertainty.

## 3. Lifecycle Justification
### Extraction / Collection
We converted unstructured research papers and bibliography records into structured rows. The hardest part of this step was standardizing method names and dataset names. Different papers often described similar techniques using different wording, and some papers referred to datasets informally rather than with consistent official names.

### Modeling / Storage
We chose Neo4j Aura because the project is fundamentally about linked information rather than isolated rows. A simple Excel spreadsheet can list papers, methods, and datasets, but it becomes much harder to answer questions about overlap, shared methods, or the most connected datasets. In contrast, Neo4j supports graph traversal directly, which makes it a strong fit for the linkage and discovery queries required by the rubric.

We also separated `DatasetMention` from `Dataset`. This design decision improved reliability because it kept the exact source wording from each paper while still allowing canonical grouping for search and analytics.

### Search / Retrieval
The graph supports direct retrieval of the three required stakeholder queries:
1. find all methods applied to both Dataset A and Dataset B,
2. find papers reporting U2 uncertainty for a chosen sensor type,
3. find the most popular dataset by number of connected methods.

## 4. Search Demonstration
### Linkage Query
We ran a graph traversal query to find fusion methods that have been applied to both the **WHU Building Dataset** and the **Boston Building Dataset**. This demonstrates graph-style overlap discovery.

### Uncertainty Query
We filtered papers by the sensor type **Aerial Imagery + LiDAR** and then retrieved only the records connected to **U2** uncertainty. This demonstrates filtering and uncertainty classification.

### Discovery Query
We ranked canonical datasets by the number of distinct connected methods and returned the most popular datasets in the graph. This demonstrates aggregation and analytic discovery.

## 5. Challenges
The largest challenge was converting unstructured text into consistent structured data. PDF papers do not describe methods and datasets in identical ways, so the extraction process required judgment and normalization. Another challenge was ensuring that the database would not break during grading, which is why we used Neo4j constraints and `MERGE` statements instead of raw `CREATE` statements. That design makes the import idempotent, so rerunning the script does not duplicate the graph.

## 6. Implementation Summary
The final Aura graph contains:
- 20 papers
- 27 methods
- 52 dataset mentions
- 33 canonical datasets
- 3 uncertainty categories

The system is searchable, reproducible, and matches the rubric requirement for a functional prototype rather than a static drawing.
