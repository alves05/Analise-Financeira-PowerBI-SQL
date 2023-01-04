----- Criando banco de dados dimensional

CREATE DATABASE DEMONSTRACOES_DW

---- Criando Tabela dCalendario

CREATE TABLE dCalendario(
Data DATE PRIMARY KEY,
Dia AS DATEPART(DAY,Data),
Mes AS DATEPART(MONTH,Data),
Nome_Mes AS DATENAME(MONTH,Data),
Ano AS DATEPART(YEAR,Data)
);

---- Incluindo registros na tabela dCalendario

DECLARE @Inicio DATE = '20170101',
    @Fim DATE = '20220101',
    @Intervalo INT = 1
;
WITH SEQUENCIA AS
(
    SELECT
       @Inicio AS STARTRANGE, 
       DATEADD(DAY, @Intervalo, @Inicio) AS ENDRANGE
    UNION ALL
    SELECT
      ENDRANGE, 
      DATEADD(DAY, @Intervalo, ENDRANGE)
    FROM SEQUENCIA 
	WHERE DATEADD(DAY, @Intervalo, ENDRANGE) <= @Fim
)
INSERT INTO dCalendario(Data)
SELECT STARTRANGE FROM SEQUENCIA
OPTION (MAXRECURSION 0)

---- Criando Tabela dEmpresas

CREATE TABLE dEmpresas(
Codigo_empresa varchar(100) PRIMARY KEY,
Nome_empresa varchar(100),
CNPJ_empresa varchar(100),
Setor_empresas varchar(100)
);

---- Importando dados da view vwEmpresas para a tabela dEmpresas

INSERT INTO dEmpresas
SELECT *
FROM [DEMONSTRACOES_DADOS].[dbo].[vwEmpresas]

---- Criando Tabela dPlanodecontas

CREATE TABLE dPlanodecontas(
Codigo_conta varchar(100) PRIMARY KEY,
Descricao_conta varchar(300),
Codigo_categoria varchar(100),
categoria varchar(100),
Codigo_subgrupo varchar(100),
Subgrupo varchar(100),
Codigo_grupo varchar(100),
Grupo varchar(100),
Ordem int IDENTITY(1,1)
);

---- Importando dados da view vwPlanodecontas para a tabela dEmpresas

INSERT INTO dPlanodecontas
SELECT *
FROM [DEMONSTRACOES_DADOS].[dbo].[vwPlanodecontas]

---- Criando Tabela fLancamentos

CREATE TABLE fLancamentos(
Ordem_lacamento int IDENTITY(1,1) PRIMARY KEY,
Codigo_empresa varchar(100),
Codigo_conta varchar(100),
Codigo_categoria varchar(100),
Codigo_subcategoria varchar(100),
Codigo_grupo varchar(100),
Saldo_contas numeric(20, 2),
Exercicio nvarchar(150)
);

---- Importando dados da view vwLancamentos para a tabela fLancamentos

INSERT INTO fLancamentos
SELECT *
FROM [DEMONSTRACOES_DADOS].[dbo].[vwLancamentos]

---- Padronizando a tabela fLancamentos

--- Criando Coluna Data

ALTER TABLE fLancamentos
ADD Data date

--- Substituindo valores NULL da coluna Data
UPDATE fLancamentos
SET Data = '2021-12-31'
WHERE Exercicio = 'Ano_2021'

UPDATE fLancamentos
SET Data = '2020-12-31'
WHERE Exercicio = 'Ano_2020'

UPDATE fLancamentos
SET Data = '2019-12-31'
WHERE Exercicio = 'Ano_2019'

--- Substituindo valores da coluna Exercicio pelo ano
UPDATE fLancamentos
SET Exercicio = '2021'
WHERE Data = '2021-12-31'

UPDATE fLancamentos
SET Exercicio = '2020'
WHERE Data = '2020-12-31'

UPDATE fLancamentos
SET Exercicio = '2019'
WHERE Data = '2019-12-31'

---- Criando Foreign Key das tabelas dimensão e fato

ALTER TABLE [dbo].[fLancamentos]  WITH CHECK ADD  CONSTRAINT [FK_fLancamentos_dCalendario] FOREIGN KEY([Data])
REFERENCES [dbo].[dCalendario] ([Data])
GO
ALTER TABLE [dbo].[fLancamentos] CHECK CONSTRAINT [FK_fLancamentos_dCalendario]
GO

ALTER TABLE [dbo].[fLancamentos]  WITH CHECK ADD  CONSTRAINT [FK_fLancamentos_dEmpresas] FOREIGN KEY([Codigo_empresa])
REFERENCES [dbo].[dEmpresas] ([Codigo_empresa])
GO
ALTER TABLE [dbo].[fLancamentos] CHECK CONSTRAINT [FK_fLancamentos_dEmpresas]
GO

ALTER TABLE [dbo].[fLancamentos]  WITH CHECK ADD  CONSTRAINT [FK_fLancamentos_dPlanodecontas] FOREIGN KEY([Codigo_conta])
REFERENCES [dbo].[dPlanodecontas] ([Codigo_conta])
GO
ALTER TABLE [dbo].[fLancamentos] CHECK CONSTRAINT [FK_fLancamentos_dPlanodecontas]
GO
