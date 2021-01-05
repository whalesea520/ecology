CREATE  INDEX IX_HrmSalaryTaxscope ON HrmSalaryTaxscope(itemid, benchid) ON [PRIMARY]
GO
CREATE  INDEX IX_HRM_ComTargetDetail ON HRM_CompensationTargetDetail(CompensationTargetid, Targetid) ON [PRIMARY]
GO
CREATE  INDEX IX_HRM_ComTargetInfo ON HRM_CompensationTargetInfo(id, Userid, CompensationYear, CompensationMonth) ON [PRIMARY]
GO
CREATE  INDEX IX_HRM_ComTargetSet ON HRM_CompensationTargetSet(id) ON [PRIMARY]
GO
CREATE  INDEX IX_HRM_ComTargetSetDetail ON HRM_ComTargetSetDetail(Targetid) ON [PRIMARY]
GO
CREATE  INDEX IX_HRM_PieceRateInfo ON HRM_PieceRateInfo(id, PieceRateNo, UserCode, PieceYear, PieceMonth) ON [PRIMARY]
GO
CREATE  INDEX IX_HRM_PieceRateSetting ON HRM_PieceRateSetting(id, PieceRateNo) ON [PRIMARY]
GO
CREATE  INDEX IX_HrmSalaryCalBench ON HrmSalaryCalBench(id, itemid) ON [PRIMARY]
GO
CREATE  INDEX IX_HrmSalaryCalRate ON HrmSalaryCalRate(benchid, timescope) ON [PRIMARY]
GO
CREATE  INDEX IX_HrmSalaryCalScope ON HrmSalaryCalScope(itemid, benchid, objectid) ON [PRIMARY]
GO
CREATE  INDEX IX_HrmSalaryPaydetail ON HrmSalaryPaydetail(payid, itemid, departmentid) ON [PRIMARY]
GO
CREATE  INDEX IX_HrmSalaryPaydetail_1 ON HrmSalaryPaydetail(payid, hrmid, itemid) ON [PRIMARY]
GO
