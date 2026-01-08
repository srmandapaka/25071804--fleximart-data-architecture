# NoSQL Justification Report (10 marks - Theory)

## Section A: Limitations of RDBMS (4 marks - 150 words)

### Explain why the current relational database would struggle with:


1. Products having different attributes (e.g., laptops have RAM/processor, shoes have size/color)
2. Frequent schema changes when adding new product types
3. Storing customer reviews as nested data

#### Relational databases are designed around strucured, tabular, schema-first data. JSON is the opposite: semi-structured, flexible, and nested. this mismatch created friction due to following reasons. 
1. RDBMS expect fixed schemas; JSON is schema‑less, as Tables require predefined columns and data types. JSON allows arbitrary nesting, missing fields, and dynamic structures. Where as RDBMS must constantly parse, validate, and adapt to unpredictable shapes. This adds overhead and reduces performance.

2. JSON breaks normalization, as Relational design encourages atomic values, foreign keys, normalized tables. JSON often contains arrays, nested objects, repeated structures
This violates 1NF (First Normal Form), forcing the database to treat JSON as a “blob” rather than a relational entity.

3. Querying JSON is slower 
To query JSON, RDBMS must parse the JSON text or binary format, traverse nested structures, extract values dynamically
This is far slower than reading fixed columns with known offsets. Even with JSON indexes (like MySQL’s ->> or PostgreSQL’s GIN indexes), performance is still behind native relational queries.

4. Indexing JSON is complex and limited. Indexing a column is easy where as Indexing a nested JSON path is not. The key Challenges are we must define indexes on specific JSON paths, Deeply nested or dynamic keys cannot be indexed efficiently, Index maintenance becomes expensive.
Document databases (MongoDB, Couchbase) are optimized for this where as RDBMS are not.

5. Joins + JSON is extremely awkward. Relational databases shine with joins. JSON documents often contain embedded relationships. To analyze any  SQL, we must extract the array, unnest it, join it. 
This is unnatural and computationally heavy.

6. JSON breaks relational optimization. Query optimizers rely on known data types, known column statistics, predictable structure. JSON destroys these assumptions. The optimizer cannot easily estimate cardinality, predict selectivity, choose optimal execution plans. This leads to slower queries.

7. JSON storage is heavier, as JSON requires extra metadata, variable-length storage, parsing overhead. Even binary JSON formats (MySQL’s JSON, PostgreSQL’s jsonb) are heavier than simple columns.

8. RDBMS are not built for document workloads. Document databases are optimized for flexible schemas, nested structures, hierarchical queries,partial updates, document-level indexing. where as RDBMS are optimized for structured data, joins, transactions, constraints. When we push JSON-heavy workloads into RDBMS, we are forcing a square peg into a round hole.


## Section B: NoSQL Benefits (4 marks - 150 words)

### Explain how MongoDB solves these problems using:

1. Flexible schema (document structure)
2. Embedded documents (reviews within products)
3. Horizontal scalability

MongoDB is built specifically to avoid the pain points that traditional RDBMS  face when dealing with semi‑structured or evolving data. Each of the features we listed directly addresses a limitation of RDBMS. if we break down how MongoDB solves these problems in a clean, structured way.

1. Flexible Schema (Document Structure)
MongoDB stores data as BSON documents, which behave like JSON but with richer types. This gives MongoDB a schema‑flexible model. 
- No fixed schema required: we don’t need to predefine columns, as each document can have different fields, nested structures, or arrays.
- Evolving data is easy: If the product catalog changes (e.g., new attributes like “color”, “dimensions”, “tags”), we simply add them to new documents without altering existing ones.
- No ALTER TABLE downtime: In RDBMS, schema changes can lock tables or require migrations. MongoDB avoids this entirely, as it handles both seamlessly.

2. Embedded Documents (Reviews within Products)
MongoDB encourages embedding related data inside a single document instead of splitting it across multiple tables.
- No joins needed: in RDBMS, product reviews would be in a separate table, requiring joins to fetch them. MongoDB embeds them directly inside the product document.
- Better read performance: Fetching a product and its reviews is a single document read, not multiple table lookups.
- Data locality: Related data lives together on disk, improving query speed.This structure is natural, intuitive, and avoids the overhead of joins.

3. Horizontal Scalability (Sharding)
MongoDB is designed from the ground up to scale horizontally, not vertically. This is solving the traditional RDBMS scale by:
- buying bigger servers
- adding more CPU/RAM
- hitting a hard limit eventually
MongoDB scales by sharding — splitting data across multiple machines.
##### **Benefits** 
- Massive dataset support: Collections can grow to terabytes or petabytes by distributing data across shards.
- High throughput: Reads and writes are spread across multiple nodes.
- Automatic load balancing: MongoDB distributes documents based on a shard key.
- Fault tolerance: Each shard is a replica set, so data remains available even if nodes fail.

## Section C: Trade-offs (2 marks - 100 words)

### What are two disadvantages of using MongoDB instead of MySQL for this product catalog?

#### Here are the two disadvantages of choosing MongoDB over MySQL for product catelog system. 
1. Weaker Support for Complex Queries & Joins. MongoDB can simulate joins using $lookup, but it’s not as efficient or expressive as MySQL’s relational engine.This point in context of a product catalog: Product catalogs often need multi-table relationships:
- products ↔ categories
- products ↔ suppliers
- products ↔ inventory
- products ↔ promotions
2. In MySQL, these are natural and fast using foreign keys and joins.
- In MongoDB, we must either embed everything (which can cause duplication), or use $lookup (which is slower and not as optimized as SQL joins)

Resulting trade-off: 
- Harder to run complex analytical queries
- More work to maintain data consistency
- Potential performance issues when data grows

2. No Strong ACID Transactions Across Many Documents
MongoDB now supports multi-document transactions, but they are slower than MySQL transactions, they are not the default design pattern, they reduce MongoDB’s performance advantage

If our catalog updates multiple collections at once (e.g., product + inventory + pricing), MySQL handles this naturally with strong ACID guarantees.
MongoDB encourages embedding to avoid multi-document updates but embedding can cause data duplication and duplication leads to update anomalies (we must update the same data in many places)

Resulting trade-off:
- Harder to guarantee strict consistency
- More risk of stale or inconsistent product data
- More complex update logic
