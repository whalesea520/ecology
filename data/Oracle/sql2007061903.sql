CREATE  INDEX IX_HrmSalaryTaxscope ON HrmSalaryTaxscope(itemid, benchid)
/
CREATE  INDEX IX_HRM_ComTargetDetail ON HRM_CompensationTargetDetail(CompensationTargetid, Targetid)
/
CREATE  INDEX IX_HRM_ComTargetInfo ON HRM_CompensationTargetInfo(id, Userid, CompensationYear, CompensationMonth)
/
CREATE  INDEX IX_HRM_ComTargetSet ON HRM_CompensationTargetSet(id)
/
CREATE  INDEX IX_HRM_ComTargetSetDetail ON HRM_ComTargetSetDetail(Targetid)
/
CREATE  INDEX IX_HRM_PieceRateInfo ON HRM_PieceRateInfo(id, PieceRateNo, UserCode, PieceYear, PieceMonth)
/
CREATE  INDEX IX_HRM_PieceRateSetting ON HRM_PieceRateSetting(id, PieceRateNo)
/
CREATE  INDEX IX_HrmSalaryCalBench ON HrmSalaryCalBench(id, itemid)
/
CREATE  INDEX IX_HrmSalaryCalRate ON HrmSalaryCalRate(benchid, timescope)
/
CREATE  INDEX IX_HrmSalaryCalScope ON HrmSalaryCalScope(itemid, benchid, objectid)
/
CREATE  INDEX IX_HrmSalaryPaydetail ON HrmSalaryPaydetail(payid, itemid, departmentid)
/
CREATE  INDEX IX_HrmSalaryPaydetail_1 ON HrmSalaryPaydetail(payid, hrmid, itemid)
/
