---- Criando View lista de clientes

CREATE VIEW vwEmpresas AS
SELECT DISTINCT
	Codigo_empresa,
	Nome_empresa,
	CNPJ_empresa,
	Setor_empresa
FROM DadosGerais

---- Criando View de lista de lançamentos realizando unpivot das colunas referentes ao ano

CREATE VIEW vwLancamentos AS
SELECT
	Codigo_empresa,
	Codigo_conta,
	Codigo_categoria,
	Codigo_subgrupo,
	Codigo_grupo,
	Saldo_contas,
	Exercicio
FROM 
	(SELECT
			Codigo_empresa,
			Codigo_conta,
			Codigo_categoria,
			Codigo_subgrupo,
			Codigo_grupo,
			Ano_2019,
			Ano_2020,
			Ano_2021
	FROM DadosGerais) p
UNPIVOT
	(Saldo_contas for Exercicio IN
		(Ano_2019, Ano_2020, Ano_2021)
) AS unpivot_dadosgerais

----- Criando View de lista do Plano de contas

CREATE VIEW vwPlanodecontas AS
SELECT DISTINCT
	Codigo_conta,
	Descricao_conta,
	Codigo_categoria,
	Categoria,
	Codigo_subgrupo,
	Subgrupo,
	Codigo_grupo,
	Grupo
FROM DadosGerais