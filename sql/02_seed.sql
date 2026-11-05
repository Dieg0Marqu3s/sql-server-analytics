-- Seed inteiramente fictício. Rodar após 01_schema.sql.
-- Para evitar mistura com dados preexistentes, aborta se a base não estiver vazia.
SET NOCOUNT ON;
IF EXISTS (SELECT 1 FROM cx.Canais)
   OR EXISTS (SELECT 1 FROM cx.Clientes)
   OR EXISTS (SELECT 1 FROM cx.Agentes)
   OR EXISTS (SELECT 1 FROM cx.Atendimentos)
   OR EXISTS (SELECT 1 FROM cx.Avaliacoes)
BEGIN
    PRINT 'Dados de exemplo não inseridos: ao menos uma tabela já contém registros.';
END
ELSE
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO cx.Canais (Nome) VALUES ('Voz'), ('WhatsApp'), ('Chat');
        INSERT INTO cx.Clientes (Nome, Segmento, DataCadastro) VALUES
            (N'Cliente Exemplo A', 'Premium', '2025-05-10'),
            (N'Cliente Exemplo B', 'Check-in', '2025-07-22'),
            (N'Cliente Exemplo C', 'Boarding', '2026-01-15'),
            (N'Cliente Exemplo D', 'Premium', '2026-02-08'),
            (N'Cliente Exemplo E', 'Check-in', '2026-05-12');
        INSERT INTO cx.Agentes (Nome) VALUES (N'Agente A'), (N'Agente B'), (N'Agente C');

        INSERT INTO cx.Atendimentos (ClienteID, CanalID, AgenteID, Inicio, Fim, Status, Motivo) VALUES
            (1,1,1,'2026-10-01T09:00:00','2026-10-01T09:08:00','Resolvido','Saldo'),
            (2,2,2,'2026-10-01T10:00:00','2026-10-01T10:12:00','Resolvido','Reserva'),
            (3,3,NULL,'2026-10-02T11:00:00',NULL,'Abandonado','Voucher'),
            (1,2,2,'2026-10-03T09:00:00','2026-10-03T09:07:00','Resolvido','Saldo'),
            (4,1,1,'2026-10-04T14:00:00','2026-10-04T14:11:00','Resolvido','Cobranca'),
            (5,3,3,'2026-10-05T15:00:00','2026-10-05T15:10:00','Pendente','Reserva'),
            (2,2,NULL,'2026-10-06T16:00:00',NULL,'Abandonado','Reserva'),
            (2,1,1,'2026-10-07T08:30:00','2026-10-07T08:41:00','Resolvido','Reserva'),
            (3,3,3,'2026-10-10T13:00:00','2026-10-10T13:09:00','Resolvido','Voucher'),
            (4,2,2,'2026-10-11T10:00:00','2026-10-11T10:06:00','Resolvido','Cobranca'),
            (5,1,1,'2026-10-15T11:00:00','2026-10-15T11:08:00','Resolvido','Reserva'),
            (1,3,3,'2026-10-20T12:00:00','2026-10-20T12:05:00','Resolvido','Saldo'),
            (3,2,2,'2026-11-01T10:00:00','2026-11-01T10:06:00','Resolvido','Voucher'),
            (4,1,1,'2026-11-02T13:00:00','2026-11-02T13:12:00','Resolvido','Cobranca'),
            (4,3,3,'2026-11-03T13:30:00','2026-11-03T13:38:00','Resolvido','Cobranca'),
            (5,2,2,'2026-11-04T09:00:00','2026-11-04T09:06:00','Resolvido','Reserva');

        INSERT INTO cx.Avaliacoes (AtendimentoID, NotaCSAT, NotaNPS, AvaliadoEm) VALUES
            (1,5,10,'2026-10-01T10:00:00'),
            (2,4,9,'2026-10-02T10:00:00'),
            (4,3,7,'2026-10-03T10:00:00'),
            (5,2,4,'2026-10-05T10:00:00'),
            (8,5,9,'2026-10-07T10:00:00'),
            (9,4,8,'2026-10-10T16:00:00'),
            (10,1,2,'2026-10-11T16:00:00'),
            (11,5,10,'2026-10-16T10:00:00'),
            (12,5,10,'2026-10-20T16:00:00'),
            (13,4,8,'2026-11-01T13:00:00'),
            (14,3,6,'2026-11-03T10:00:00'),
            (15,5,9,'2026-11-04T10:00:00');
        COMMIT TRANSACTION;
        PRINT 'Dados fictícios carregados com sucesso.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
