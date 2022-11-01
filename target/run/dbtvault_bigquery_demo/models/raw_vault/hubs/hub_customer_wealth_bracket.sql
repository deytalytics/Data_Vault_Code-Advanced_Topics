
        
    

    

    merge into `steadfast-task-363413`.`data_vault`.`hub_customer_wealth_bracket` as DBT_INTERNAL_DEST
        using (
          -- Generated by dbtvault.

WITH row_rank_1 AS (
    SELECT rr.`CUSTOMER_WEALTH_BRACKET_HK`, rr.`ID`, rr.`LOAD_DATE`, rr.`RECORD_SOURCE`,
           ROW_NUMBER() OVER(
               PARTITION BY rr.`CUSTOMER_WEALTH_BRACKET_HK`
               ORDER BY rr.`LOAD_DATE`
           ) AS row_number
    FROM `steadfast-task-363413`.`data_vault`.`v_stg_customer_wealth_brackets` AS rr
    WHERE rr.`CUSTOMER_WEALTH_BRACKET_HK` IS NOT NULL
    QUALIFY row_number = 1
),


records_to_insert AS (
    SELECT a.`CUSTOMER_WEALTH_BRACKET_HK`, a.`ID`, a.`LOAD_DATE`, a.`RECORD_SOURCE`
    FROM row_rank_1 AS a
    LEFT JOIN `steadfast-task-363413`.`data_vault`.`hub_customer_wealth_bracket` AS d
    ON a.`CUSTOMER_WEALTH_BRACKET_HK` = d.`CUSTOMER_WEALTH_BRACKET_HK`
    WHERE d.`CUSTOMER_WEALTH_BRACKET_HK` IS NULL
)

SELECT * FROM records_to_insert
        ) as DBT_INTERNAL_SOURCE
        on FALSE

    

    when not matched then insert
        (`CUSTOMER_WEALTH_BRACKET_HK`, `ID`, `LOAD_DATE`, `RECORD_SOURCE`)
    values
        (`CUSTOMER_WEALTH_BRACKET_HK`, `ID`, `LOAD_DATE`, `RECORD_SOURCE`)


  