-- Exemplos de consultas de Analytics para Customer Experience.
SET NOCOUNT ON;

-- 1. Painel mensal por canal: volume, TMA, abandono, CSAT e NPS.
SELECT *
FROM cx.vw_ResumoMensalCanal
ORDER BY MesReferencia, Canal;

-- 2. Volume de contatos por motivo e mês.
SELECT
    MesReferencia,
    Motivo,
    COUNT(*) AS TotalContatos,
    SUM(CASE WHEN Status = 'Resolvido' THEN 1 ELSE 0 END) AS Resolvidos,
    SUM(FlagAbandono) AS Abandonados
FROM cx.vw_AtendimentosEnriquecidos
GROUP BY MesReferencia, Motivo
ORDER BY MesReferencia, TotalContatos DESC;

-- 3. Rechamada: contato do mesmo cliente até 7 dias do contato anterior.
-- A classificação ocorre no nível do contato e atravessa meses/canais.
WITH ContatosOrdenados AS (
    SELECT
        AtendimentoID,
        ClienteID,
        Canal,
        Inicio,
        LAG(Inicio) OVER (
            PARTITION BY ClienteID ORDER BY Inicio, AtendimentoID
        ) AS ContatoAnterior
    FROM cx.vw_AtendimentosEnriquecidos
), Rechamadas AS (
    SELECT
        AtendimentoID,
        ClienteID,
        Canal,
        Inicio,
        ContatoAnterior,
        CASE WHEN ContatoAnterior IS NOT NULL
              AND Inicio <= DATEADD(DAY, 7, ContatoAnterior)
             THEN 1 ELSE 0 END AS FlagRechamada7d
    FROM ContatosOrdenados
)
SELECT
    DATEFROMPARTS(YEAR(Inicio), MONTH(Inicio), 1) AS MesReferencia,
    Canal,
    COUNT(*) AS TotalContatos,
    SUM(FlagRechamada7d) AS Rechamadas7d,
    CAST(100.0 * SUM(FlagRechamada7d) / NULLIF(COUNT(*), 0) AS DECIMAL(6,2)) AS TaxaRechamadaPct
FROM Rechamadas
GROUP BY DATEFROMPARTS(YEAR(Inicio), MONTH(Inicio), 1), Canal
ORDER BY MesReferencia, Canal;

-- 4. Resumo geral de satisfação, ponderado por respostas e não pela média das taxas dos canais.
SELECT
    MesReferencia,
    COUNT(NotaCSAT) AS RespostasCSAT,
    CAST(100.0 * SUM(CASE WHEN NotaCSAT >= 4 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(NotaCSAT),0) AS DECIMAL(6,2)) AS CSATPositivoPct,
    COUNT(NotaNPS) AS RespostasNPS,
    CAST(100.0 * (
        SUM(CASE WHEN NotaNPS >= 9 THEN 1 ELSE 0 END)
      - SUM(CASE WHEN NotaNPS <= 6 THEN 1 ELSE 0 END)
    ) / NULLIF(COUNT(NotaNPS),0) AS DECIMAL(6,2)) AS NPS
FROM cx.vw_AtendimentosEnriquecidos
GROUP BY MesReferencia
ORDER BY MesReferencia;
GO
