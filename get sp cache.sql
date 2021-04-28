Use Reports_Support

select plan_handle, creation_time, last_execution_time, execution_count, qt.text
FROM
   sys.dm_exec_query_stats qs
   CROSS APPLY sys.dm_exec_sql_text (qs.[sql_handle]) AS qt
            WHERE TEXT LIKE '%LEX_SUM_EETs_udf%'


-- DBCC FREEPROCCACHE (0x05000800EA5B0F7DA0A8D0F65202000001000000000000000000000000000000000000000000000000000000);