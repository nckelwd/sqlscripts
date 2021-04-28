SELECT *
  FROM [DATABASE].[dbo].[sysssislog]
  WHERE message <> '' AND message NOT LIKE '%End of%' AND message NOT LIKE '%Beginning%'
  ORDER BY starttime DESC