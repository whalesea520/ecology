DELETE
FROM mode_custombrowserDspField
WHERE customid IN
  (SELECT id
  FROM mode_custombrowser
  WHERE formid IN
    (SELECT a.id
    FROM workflow_bill a
    LEFT JOIN HtmlLabelInfo c
    ON a.namelabel   =c.indexid
    AND c.languageid = 7
    LEFT JOIN ModeFormExtend m
    ON a.id             =m.formid
    WHERE isvirtualform =1
    )
  )
AND fieldid <0 
GO