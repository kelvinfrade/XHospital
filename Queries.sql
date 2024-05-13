-- dAcomodacao
SELECT
  ROW_NUMBER() OVER (
    ORDER BY
      acomodacao
  ) AS cod_acomodacao,
  acomodacao
FROM
  (
    SELECT
      DISTINCT acomodacao
    FROM
      tab_internacoes
  ) AS dimensao_acomodacao;


-- dMedico
SELECT
  *
FROM
  tab_medicos;


-- dPaciente
SELECT
  A.cod_paciente,
  A.nome_paciente,
  A.genero_paciente,
  DATE_FORMAT(
    CAST(
      LEFT(
        A.data_nasc_paciente,
        POSITION(' ' IN A.data_nasc_paciente) - 1
      ) AS DATE
    ),
    'dd/MM/yyyy'
  ) AS data_nasc_paciente,
  B.convenio
FROM
  tab_paciente AS A
  INNER JOIN tab_convenio AS B ON A.cod_convenio = B.cod_convenio;


-- dProcedimento
SELECT
  A.cod_procedimento,
  A.procedimento,
  B.classe
FROM
  tab_procedimento AS A
  INNER JOIN tab_classe_procedimento AS B ON A.cod_classe = B.cod_classe;


-- dTipoAlta
SELECT
  ROW_NUMBER() OVER (
    ORDER BY
      tipo_alta
  ) AS cod_tipo_alta,
  tipo_alta
FROM
  (
    SELECT
      DISTINCT tipo_alta
    FROM
      tab_internacoes
  ) AS dimensao_tipo_alta;


-- fInternacao
SELECT
  LEFT(data_admissao, POSITION(' ' IN data_admissao) - 1) AS data_admissao,
  LEFT(data_alta, POSITION(' ' IN data_alta) - 1) AS data_alta,
  SUBSTRING(
    data_admissao,
    LENGTH('           ') + 1,
    POSITION(',' IN data_admissao) - LENGTH('           ') - 1
  ) AS hora_admissao,
  SUBSTRING(
    data_alta,
    LENGTH('           ') + 1,
    POSITION(',' IN data_alta) - LENGTH('           ') - 1
  ) AS hora_alta,
  cod_tipo_alta,
  cod_paciente,
  numero_da_internacao,
  cod_medico,
  cod_procedimento,
  cod_medico,
  cod_procedimento,
  valor,
  cod_acomodacao
FROM
  tab_internacoes
  JOIN (
    SELECT
      ROW_NUMBER() OVER (
        ORDER BY
          tipo_alta
      ) AS cod_tipo_alta,
      tipo_alta
    FROM
      (
        SELECT
          DISTINCT tipo_alta
        FROM
          tab_internacoes
      ) AS dimensao_tipo_alta
  ) AS subconsulta1 ON tab_internacoes.tipo_alta = subconsulta1.tipo_alta
  JOIN (
    SELECT
      ROW_NUMBER() OVER (
        ORDER BY
          acomodacao
      ) AS cod_acomodacao,
      acomodacao
    FROM
      (
        SELECT
          DISTINCT acomodacao
        FROM
          tab_internacoes
      ) AS dimensao_acomodacao
  ) AS subconsulta2 ON tab_internacoes.acomodacao = subconsulta2.acomodacao;
