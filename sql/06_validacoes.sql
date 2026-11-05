-- Testes exploratórios de qualidade dos dados fictícios.
SET NOCOUNT ON;

SELECT 'Canais' AS Entidade, COUNT(*) AS Quantidade FROM cx.Canais
UNION ALL SELECT 'Clientes', COUNT(*) FROM cx.Clientes
UNION ALL SELECT 'Agentes', COUNT(*) FROM cx.Agentes
UNION ALL SELECT 'Atendimentos', COUNT(*) FROM cx.Atendimentos
UNION ALL SELECT 'Avaliacoes', COUNT(*) FROM cx.Avaliacoes;

-- Deve retornar zero registros: duração negativa ou avaliação anterior ao atendimento.
SELECT a.AtendimentoID, a.Inicio, a.Fim, av.AvaliadoEm
FROM cx.Atendimentos AS a
LEFT JOIN cx.Avaliacoes AS av ON av.AtendimentoID = a.AtendimentoID
WHERE (a.Fim IS NOT NULL AND a.Fim < a.Inicio)
   OR av.AvaliadoEm < a.Inicio;

-- Regras de consistência: as taxas devem permanecer entre 0 e 100%; NPS entre -100 e 100.
SELECT *
FROM cx.vw_ResumoMensalCanal
WHERE TaxaAbandonoPct NOT BETWEEN 0 AND 100
   OR CSATPositivoPct NOT BETWEEN 0 AND 100
   OR NPS NOT BETWEEN -100 AND 100;
GO
