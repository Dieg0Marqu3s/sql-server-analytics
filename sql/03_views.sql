-- Camada semântica para BI. Execute após schema e seed.
CREATE OR ALTER VIEW cx.vw_AtendimentosEnriquecidos
AS
SELECT
    a.AtendimentoID,
    a.ClienteID,
    cl.Segmento,
    ca.Nome AS Canal,
    a.AgenteID,
    a.Inicio,
    a.Fim,
    a.Status,
    a.Motivo,
    CONVERT(date, a.Inicio) AS DataAtendimento,
    DATEFROMPARTS(YEAR(a.Inicio), MONTH(a.Inicio), 1) AS MesReferencia,
    CASE
        WHEN a.AgenteID IS NOT NULL AND a.Fim IS NOT NULL
        THEN DATEDIFF(SECOND, a.Inicio, a.Fim) / 60.0
    END AS TempoAtendimentoMin,
    CASE WHEN a.Status = 'Abandonado' THEN 1 ELSE 0 END AS FlagAbandono,
    av.NotaCSAT,
    av.NotaNPS
FROM cx.Atendimentos AS a
JOIN cx.Clientes AS cl ON cl.ClienteID = a.ClienteID
JOIN cx.Canais AS ca ON ca.CanalID = a.CanalID
LEFT JOIN cx.Avaliacoes AS av ON av.AtendimentoID = a.AtendimentoID;
GO

-- Taxas calculadas sobre os denominadores corretos (apenas respostas válidas).
CREATE OR ALTER VIEW cx.vw_ResumoMensalCanal
AS
SELECT
    MesReferencia,
    Canal,
    COUNT_BIG(*) AS TotalContatos,
    SUM(FlagAbandono) AS Abandonos,
    CAST(100.0 * SUM(FlagAbandono) / NULLIF(COUNT_BIG(*),0) AS DECIMAL(6,2)) AS TaxaAbandonoPct,
    CAST(AVG(TempoAtendimentoMin) AS DECIMAL(10,2)) AS TMAMin,
    COUNT(NotaCSAT) AS RespostasCSAT,
    CAST(100.0 * SUM(CASE WHEN NotaCSAT >= 4 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(NotaCSAT),0) AS DECIMAL(6,2)) AS CSATPositivoPct,
    COUNT(NotaNPS) AS RespostasNPS,
    CAST(100.0 * (
          SUM(CASE WHEN NotaNPS >= 9 THEN 1 ELSE 0 END)
        - SUM(CASE WHEN NotaNPS <= 6 THEN 1 ELSE 0 END)
    ) / NULLIF(COUNT(NotaNPS),0) AS DECIMAL(6,2)) AS NPS
FROM cx.vw_AtendimentosEnriquecidos
GROUP BY MesReferencia, Canal;
GO
