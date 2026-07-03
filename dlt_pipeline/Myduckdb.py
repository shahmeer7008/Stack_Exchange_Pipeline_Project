import duckdb

# Connect to the DuckDB database
con = duckdb.connect(
    "stack_exchange_pipeline.duckdb"
)

print("===== SCHEMAS =====")
print(con.sql("SHOW SCHEMAS").fetchdf())

# Show all tables in all schemas
print("\n===== TABLES =====")
print(con.sql("""
    SELECT * from raw_stack_exchange_data.users
""").fetchdf())


con.close()