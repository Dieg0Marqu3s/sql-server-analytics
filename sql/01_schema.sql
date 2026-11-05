-- SQL Server | Modelo dimensional simplificado para Customer Experience.
-- Execute em uma base de TESTES. Não utilize bancos corporativos.
SET NOCOUNT ON;
GO
IF SCHEMA_ID(N'cx') IS NULL EXEC(N'CREATE SCHEMA cx');
GO
IF OBJECT_ID(N'cx.Canais', N'U') IS NULL
BEGIN
    CREATE TABLE cx.Canais (
        CanalID TINYINT IDENTITY(1,1) PRIMARY KEY,
        Nome VARCHAR(30) NOT NULL UNIQUE
    );
END;
GO
IF OBJECT_ID(N'cx.Clientes', N'U') IS NULL
BEGIN
    CREATE TABLE cx.Clientes (
        ClienteID INT IDENTITY(1,1) PRIMARY KEY,
        Nome NVARCHAR(80) NOT NULL,
        Segmento VARCHAR(30) NOT NULL,
        DataCadastro DATE NOT NULL,
        Ativo BIT NOT NULL DEFAULT (1)
    );
END;
GO
IF OBJECT_ID(N'cx.Agentes', N'U') IS NULL
BEGIN
    CREATE TABLE cx.Agentes (
        AgenteID INT IDENTITY(1,1) PRIMARY KEY,
        Nome NVARCHAR(80) NOT NULL
    );
END;
GO
IF OBJECT_ID(N'cx.Atendimentos', N'U') IS NULL
BEGIN
    CREATE TABLE cx.Atendimentos (
        AtendimentoID INT IDENTITY(1,1) PRIMARY KEY,
        ClienteID INT NOT NULL,
        CanalID TINYINT NOT NULL,
        AgenteID INT NULL,
        Inicio DATETIME2(0) NOT NULL,
        Fim DATETIME2(0) NULL,
        Status VARCHAR(20) NOT NULL,
        Motivo VARCHAR(40) NOT NULL,
        CONSTRAINT FK_Atendimentos_Cliente FOREIGN KEY (ClienteID) REFERENCES cx.Clientes(ClienteID),
        CONSTRAINT FK_Atendimentos_Canal FOREIGN KEY (CanalID) REFERENCES cx.Canais(CanalID),
        CONSTRAINT FK_Atendimentos_Agente FOREIGN KEY (AgenteID) REFERENCES cx.Agentes(AgenteID),
        CONSTRAINT CK_Atendimentos_Status CHECK (Status IN ('Resolvido', 'Pendente', 'Abandonado')),
        CONSTRAINT CK_Atendimentos_Datas CHECK (Fim IS NULL OR Fim >= Inicio),
        CONSTRAINT CK_Atendimentos_Abandono CHECK (Status <> 'Abandonado' OR AgenteID IS NULL)
    );
END;
GO
IF OBJECT_ID(N'cx.Avaliacoes', N'U') IS NULL
BEGIN
    CREATE TABLE cx.Avaliacoes (
        AvaliacaoID INT IDENTITY(1,1) PRIMARY KEY,
        AtendimentoID INT NOT NULL UNIQUE,
        NotaCSAT TINYINT NULL,
        NotaNPS TINYINT NULL,
        AvaliadoEm DATETIME2(0) NOT NULL,
        CONSTRAINT FK_Avaliacoes_Atendimento FOREIGN KEY (AtendimentoID) REFERENCES cx.Atendimentos(AtendimentoID),
        CONSTRAINT CK_Avaliacoes_CSAT CHECK (NotaCSAT IS NULL OR NotaCSAT BETWEEN 1 AND 5),
        CONSTRAINT CK_Avaliacoes_NPS CHECK (NotaNPS IS NULL OR NotaNPS BETWEEN 0 AND 10),
        CONSTRAINT CK_Avaliacoes_Nota CHECK (NotaCSAT IS NOT NULL OR NotaNPS IS NOT NULL)
    );
END;
GO
