"""Carga los CSV de Olist en una base DuckDB con nombres cortos de tabla."""
from pathlib import Path

import duckdb

RAIZ = Path(__file__).resolve().parent.parent
TABLAS = {
    "orders": "olist_orders_dataset",
    "order_items": "olist_order_items_dataset",
    "customers": "olist_customers_dataset",
    "products": "olist_products_dataset",
    "sellers": "olist_sellers_dataset",
    "payments": "olist_order_payments_dataset",
    "reviews": "olist_order_reviews_dataset",
    "category_translation": "product_category_name_translation",
}


def cargar(db: Path | str = ":memory:") -> duckdb.DuckDBPyConnection:
    con = duckdb.connect(str(db))
    for tabla, archivo in TABLAS.items():
        con.execute(f"create or replace table {tabla} as select * from read_csv('{RAIZ / 'data' / archivo}.csv', header = true)")
    return con
