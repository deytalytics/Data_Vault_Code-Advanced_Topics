

  create or replace view `steadfast-task-363413`.`data_vault`.`v_stg_customer_wealth_bracket`
  OPTIONS()
  as 







WITH staging AS (
-- Generated by dbtvault.

    

WITH source_data AS (

    SELECT

    `ID`,
    `NAME`,
    `DESCRIPTION`,
    `LASTMODIFIEDDATE`,
    `CREATEDDATE`

    FROM `steadfast-task-363413`.`data_vault`.`v_raw_customer_wealth_bracket`
),

derived_columns AS (

    SELECT

    `ID`,
    `NAME`,
    `DESCRIPTION`,
    `LASTMODIFIEDDATE`,
    `CREATEDDATE`,
    ID AS `CUSTOMER_WEALTH_BRACKET_KEY`,
    '3' AS `RECORD_SOURCE`,
    LASTMODIFIEDDATE AS `EFFECTIVE_FROM`

    FROM source_data
),

hashed_columns AS (

    SELECT

    `ID`,
    `NAME`,
    `DESCRIPTION`,
    `LASTMODIFIEDDATE`,
    `CREATEDDATE`,
    `CUSTOMER_WEALTH_BRACKET_KEY`,
    `RECORD_SOURCE`,
    `EFFECTIVE_FROM`,

    CAST(UPPER(TO_HEX(SHA256(NULLIF(UPPER(TRIM(CAST(`CUSTOMER_WEALTH_BRACKET_KEY` AS STRING))), '')))) AS STRING) AS `CUSTOMER_WEALTH_BRACKET_HK`,
    UPPER(TO_HEX(SHA256(CONCAT(
        IFNULL(NULLIF(UPPER(TRIM(CAST(`CREATEDDATE` AS STRING))), ''), '^^'),'||',
        IFNULL(NULLIF(UPPER(TRIM(CAST(`DESCRIPTION` AS STRING))), ''), '^^'),'||',
        IFNULL(NULLIF(UPPER(TRIM(CAST(`ID` AS STRING))), ''), '^^'),'||',
        IFNULL(NULLIF(UPPER(TRIM(CAST(`LASTMODIFIEDDATE` AS STRING))), ''), '^^'),'||',
        IFNULL(NULLIF(UPPER(TRIM(CAST(`NAME` AS STRING))), ''), '^^')
    )))) AS `CUSTOMER_WEALTH_BRACKET_HASHDIFF`

    FROM derived_columns
),

columns_to_select AS (

    SELECT

    `ID`,
    `NAME`,
    `DESCRIPTION`,
    `LASTMODIFIEDDATE`,
    `CREATEDDATE`,
    `CUSTOMER_WEALTH_BRACKET_KEY`,
    `RECORD_SOURCE`,
    `EFFECTIVE_FROM`,
    `CUSTOMER_WEALTH_BRACKET_HK`,
    `CUSTOMER_WEALTH_BRACKET_HASHDIFF`

    FROM hashed_columns
)

SELECT * FROM columns_to_select
)

SELECT *,
       '2009-11-05 08.36.0000000' AS LOAD_DATE
FROM staging;
