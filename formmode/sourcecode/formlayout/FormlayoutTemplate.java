package weaver.formmode.customjavacode.formlayout;

import java.util.*;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.formmode.customjavacode.AbstractFormLayoutSqlConditionJavaCode;

public class FormlayoutTemplate extends AbstractFormLayoutSqlConditionJavaCode {

	/**
	 * 生成SQL查询限制条件
	 * @param param
	 *  param包含(但不限于)以下数据
	 *  user 当前用户
	 * 
	 * @return
	 *  返回的查询限制条件的格式举例为: b.a = '3' and b.c like '%22%' and b.d='PARM(参数)' and b.e='$date$'
	 *  其中b为表单明细表表名的别名
	 */
	public String generateSqlCondition(Map<String, Object> param) throws Exception {
		User user = (User)param.get("user");
		
		String sqlCondition = "";
		
		return sqlCondition;
	}

}
