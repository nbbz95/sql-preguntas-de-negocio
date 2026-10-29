"""Corre todas las consultas de queries/ y genera site/data.json y RESULTADOS.md."""
from __future__ import annotations

import json
import re
from datetime import date, datetime
from decimal import Decimal
from pathlib import Path

from cargar import RAIZ, cargar

CABECERA = re.compile(r"^-- (\w+): (.*)$")


def leer(path: Path) -> dict:
    meta, cuerpo = {}, []
    for linea in path.read_text().splitlines():
        m = CABECERA.match(linea)
        if m and not cuerpo:
            meta[m.group(1)] = m.group(2).strip()
        else:
            cuerpo.append(linea)
    return {"id": path.stem, "sql": "\n".join(cuerpo).strip(), **meta}


def valor(v):
    if isinstance(v, Decimal):
        return float(v)
    if isinstance(v, (date, datetime)):
        return v.isoformat()
    return v


def correr(con, consulta: dict) -> dict:
    cur = con.execute(consulta["sql"])
    columnas = [d[0] for d in cur.description]
    filas = [[valor(v) for v in fila] for fila in cur.fetchall()]
    return {**consulta, "columnas": columnas, "filas": filas}


def markdown(resultados: list[dict]) -> str:
    out = ["# Resultados\n", "Generado por `python src/build.py`. Cada sección es una consulta de `queries/`.\n"]
    for r in resultados:
        out.append(f"## {r['titulo']}\n")
        out.append(f"`{r['id']}.sql` · {r['tecnica']}\n")
        out.append(f"> {r['hallazgo']}\n")
        out.append("| " + " | ".join(r["columnas"]) + " |")
        out.append("|" + "---|" * len(r["columnas"]))
        for f in r["filas"]:
            out.append("| " + " | ".join("" if v is None else str(v) for v in f) + " |")
        out.append("")
    return "\n".join(out)


def main() -> list[dict]:
    con = cargar()
    resultados = [correr(con, leer(p)) for p in sorted((RAIZ / "queries").glob("*.sql"))]
    (RAIZ / "site" / "data.json").write_text(json.dumps(resultados, ensure_ascii=False, indent=1))
    (RAIZ / "RESULTADOS.md").write_text(markdown(resultados))
    return resultados


if __name__ == "__main__":
    for r in main():
        print(f"{r['id']}: {len(r['filas'])} filas")
