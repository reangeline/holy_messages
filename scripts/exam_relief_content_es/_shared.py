# -*- coding: utf-8 -*-
"""Forma de uma resposta espanhola do Exame.

O texto bíblico não está aqui: `passage` aponta um id do inventário
`torres_amat_1836_salmos.es.json`, e build_exam_relief.py copia de lá o texto
transcrito do fac-símile de Torres Amat (Paris, 1836). O gerador também recusa
uma passagem que a curadoria não marcou para aquele estado — a pertinência
pastoral é decisão da curadoria, não minha.
"""

VAT = "Biografía: vatican.va (por confirmar)."


def e(passage, saint, saint_name, *, title, why, saint_why, step, source=VAT):
    return {
        "passage": passage,
        "saintID": saint,
        "saintName": saint_name,
        "title": title,
        "psalmWhy": why,
        "saintWhy": saint_why,
        "stepBody": step,
        "saintSource": source,
    }
