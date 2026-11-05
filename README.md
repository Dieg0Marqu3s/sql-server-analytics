# SQL Server Analytics | Customer Experience

Projeto de portfólio em **T-SQL** para demonstrar modelagem relacional, transformação de dados, indicadores de negócio e otimização de consultas em SQL Server.

> **Dados 100% fictícios.** Este projeto não utiliza informações, estruturas ou regras proprietárias de qualquer empregador.

## O que este projeto demonstra

- Modelo relacional com chaves primárias, estrangeiras e restrições de integridade.
- Views analíticas para consumo por ferramentas de BI.
- Indicadores de CX: **volume de contatos, TMA, abandono, CSAT, NPS e rechamada em até 7 dias**.
- **CTEs, CASE, agregações condicionais, LAG e funções de janela**.
- Índices e consultas de validação para apoiar qualidade e desempenho.

## Organização

```text
sql-server-analytics/
├── README.md
└── sql/
    ├── 01_schema.sql           # Tabelas e relacionamentos
    ├── 02_seed.sql             # Dados fictícios para demonstração
    ├── 03_views.sql            # Camada analítica
    ├── 04_indicadores.sql      # Consultas de negócio
    ├── 05_indices.sql          # Estratégias básicas de performance
    └── 06_validacoes.sql       # Verificação de qualidade
```

## Execução

**Requisito:** SQL Server 2016 SP1 ou superior (para `CREATE OR ALTER VIEW`) e uma base de desenvolvimento vazia ou destinada a testes.

1. Crie ou escolha **um banco de testes** no SQL Server Management Studio (SSMS) ou Azure Data Studio.
2. Execute os arquivos na ordem `01_schema.sql` até `06_validacoes.sql`.
3. Consulte `cx.vw_AtendimentosEnriquecidos` e `cx.vw_ResumoMensalCanal` para explorar os indicadores.

O script de dados fictícios considera as tabelas de demonstração recém-criadas. Se já existirem registros, ele não substitui nem mistura dados.

## Regras dos indicadores

| Indicador | Critério utilizado |
|---|---|
| TMA | Média, em minutos, de atendimentos com agente e horários de início/fim preenchidos |
| Abandono | Atendimento classificado como `Abandonado`, sobre o total de contatos |
| CSAT positivo | Avaliação com nota 4 ou 5, entre as respostas CSAT disponíveis |
| NPS | % promotores (9–10) menos % detratores (0–6), entre as respostas NPS |
| Rechamada em 7 dias | Contato do mesmo cliente até 7 dias depois do contato anterior, independentemente do canal |

**Observação:** essas regras são exemplos de negócio para fins didáticos e devem ser ajustadas antes de utilização real. A view mensal atribui avaliações ao mês do atendimento, não ao mês da resposta. Comparar períodos exige considerar cobertura e atraso nas avaliações.

## Próximas evoluções

- Testes automatizados de regras de negócio e integridade.
- Procedimentos de carga incremental e auditoria.
- Dashboard demonstrativo em Power BI utilizando as views.

## Autor

[Diego Marques](https://github.com/Dieg0Marqu3s) · [LinkedIn](https://www.linkedin.com/in/diego-ferreira-marques/) · [Portfólio](https://dashboards.digital/p/diegoferreiramarques)
