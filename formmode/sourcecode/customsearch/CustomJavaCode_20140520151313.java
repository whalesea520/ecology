package weaver.formmode.customjavacode.customsearch;

import java.util.*;
import weaver.conn.RecordSet;
import weaver.crm.CrmShareBase;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.formmode.customjavacode.AbstractCustomSqlConditionJavaCode;

public class CustomJavaCode_20140520151313 extends AbstractCustomSqlConditionJavaCode {

	/**
	 * 生成SQL查询限制条件
	 * @param param
	 *  param包含(但不限于)以下数据
	 *  user 当前用户
	 * 
	 * @return
	 *  返回的查询限制条件的格式举例为: t1.a = '1' and t1.b = '3' and t1.c like '%22%'
	 *  其中t1为表单主表表名的别名
	 */
	public String generateSqlCondition(Map<String, Object> param) throws Exception {
		String sqlCondition = "";
		
		User user = (User)param.get("user");
		String loginType = user.getLogintype();
		String userid = String.valueOf(user.getUID());
		
		if(loginType.equals("1")){
			CrmShareBase crmShareBase = new CrmShareBase();
			sqlCondition = "t1.deleted = 0 and t1.id in" + crmShareBase.getTempTable(userid);
		}else{
			sqlCondition = "t1.deleted = 0 and t1.agent="+userid;
		}
		
		return sqlCondition;
	}

}