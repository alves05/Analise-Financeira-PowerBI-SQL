----- Criando banco de dados de produção

CREATE DATABASE DEMONSTRACOES_DADOS

---- Criando Tabela de dados do ambiente de produção

CREATE TABLE DadosGerais(
Descricao_conta varchar(300),
Ano_2021 numeric(20, 2),
Ano_2020 numeric(20, 2),
Ano_2019 numeric(20, 2),
Codigo_conta varchar(100),
Categoria varchar(100),
Codigo_categoria varchar(100),
Subgrupo varchar(100),
Codigo_subgrupo varchar(100),
Grupo varchar(100),
Codigo_grupo varchar(100),
Codigo_empresa varchar(100),
Nome_empresa varchar(100),
CNPJ_empresa varchar(100),
Setor_empresa varchar(100)
)

---- Importando dataset pré processado em excel

BULK INSERT DadosGerais
	FROM 'D:\Cursos\1 - CIÊNCIA DE DADOS\1- Projetos Práticos\Power BI\Dashboard e Analises\3 - Análise das Demonstrações Contabéis\Dados\DatasetDFs.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '0x0A'
	)


---- Verificando a importação do dataset

select * from DadosGerais