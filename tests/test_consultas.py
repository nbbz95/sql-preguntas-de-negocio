import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))
from build import correr, leer  # noqa: E402
from cargar import RAIZ, cargar  # noqa: E402

CONSULTAS = sorted((RAIZ / "queries").glob("*.sql"))


@pytest.fixture(scope="session")
def con():
    return cargar()


@pytest.fixture(scope="session")
def resultados(con):
    return {p.stem[:2]: correr(con, leer(p)) for p in CONSULTAS}


def test_hay_15_preguntas():
    assert len(CONSULTAS) == 15


@pytest.mark.parametrize("path", CONSULTAS, ids=lambda p: p.stem)
def test_cada_consulta_documentada_y_con_resultado(con, path):
    c = leer(path)
    for campo in ("titulo", "tecnica", "hallazgo"):
        assert c.get(campo), f"{path.name} no tiene '-- {campo}:'"
    r = correr(con, c)
    assert r["filas"], f"{path.name} no devolvió filas"
    if "grafico" in c:
        _, x, y = c["grafico"].split()
        assert x in r["columnas"] and y in r["columnas"]


def as_dicts(r):
    return [dict(zip(r["columnas"], f)) for f in r["filas"]]


def test_participaciones_suman_100(resultados):
    for clave, col in (("09", "share_monto_pct"), ("15", "share_facturacion_pct")):
        total = sum(f[col] for f in as_dicts(resultados[clave]))
        assert total == pytest.approx(100, abs=0.5)


def test_pareto_es_coherente(resultados):
    r = as_dicts(resultados["04"])[0]
    assert 0 < r["vendedores_para_80pct"] < r["vendedores_totales"]


def test_atraso_empeora_la_nota(resultados):
    notas = [f["nota_promedio"] for f in as_dicts(resultados["08"])]
    assert notas == sorted(notas, reverse=True)


def test_top_n_por_grupo(resultados):
    filas = as_dicts(resultados["14"])
    assert {f["puesto"] for f in filas} == {1, 2, 3}
    assert len({f["categoria"] for f in filas}) == 3
    assert len({f["estado"] for f in as_dicts(resultados["05"])}) == 10
