# -*- coding: utf-8 -*-
"""Forma de uma resposta do Exame, compartilhada pelos blocos.

O texto bíblico não entra aqui: `pt_ref` e `en_ref` apontam capítulo e
versículos na numeração de cada edição, e build_exam_relief.py extrai o texto.
As duas edições dividem versículos de forma diferente, por isso as referências
são separadas — ver o comentário no construtor.
"""

VAT = "Biografia: vatican.va (a conferir)."


def r(saint, pt_ref, en_ref, pt, en, *, pt_saint, en_saint, pt_why, en_why,
      pt_step, en_step, pt_title, en_title, source=VAT):
    return {
        "saintID": saint,
        "pt": {"ref": pt_ref, "title": pt_title, "psalmWhy": pt, "saintName": pt_saint,
               "saintWhy": pt_why, "stepTitle": "Um passo concreto", "stepBody": pt_step,
               "saintSource": source},
        "en": {"ref": en_ref, "title": en_title, "psalmWhy": en, "saintName": en_saint,
               "saintWhy": en_why, "stepTitle": "A concrete step", "stepBody": en_step,
               "saintSource": source},
    }
