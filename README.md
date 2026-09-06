# Laboratorio 4.1 - AWS S3 CLI

Laboratorio del curso DevOps - UTEC.

## Objetivo

Automatizar el ciclo de vida de un sitio web estático en Amazon S3 utilizando AWS CLI y scripts Bash idempotentes.

## Estructura

```text
.
├── deploy_site.sh
├── cleanup.sh
└── site/
    ├── index.html
    ├── error.html
    └── assets/
        └── styles.css
