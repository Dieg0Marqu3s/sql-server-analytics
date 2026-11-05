-- Índices ilustrativos: valide seletividade, custo de escrita e plano de execução antes de usar em produção.
-- Dados pequenos do seed não permitem demonstrar ganhos mensuráveis.
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'cx.Atendimentos') AND name = N'IX_Atendimentos_Inicio_Canal'
)
    CREATE INDEX IX_Atendimentos_Inicio_Canal
        ON cx.Atendimentos (Inicio, CanalID)
        INCLUDE (AgenteID, Fim, Status, Motivo, ClienteID);
GO
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'cx.Atendimentos') AND name = N'IX_Atendimentos_Cliente_Inicio'
)
    CREATE INDEX IX_Atendimentos_Cliente_Inicio
        ON cx.Atendimentos (ClienteID, Inicio, AtendimentoID)
        INCLUDE (CanalID);
GO
-- Exemplo de filtro SARGable: manter a coluna Inicio sem conversão na condição.
DECLARE @Inicio DATETIME2(0) = '2026-10-01T00:00:00';
DECLARE @Fim DATETIME2(0) = '2026-11-01T00:00:00';
SELECT AtendimentoID, ClienteID, CanalID, Inicio, Status
FROM cx.Atendimentos
WHERE Inicio >= @Inicio AND Inicio < @Fim
ORDER BY Inicio;
GO
