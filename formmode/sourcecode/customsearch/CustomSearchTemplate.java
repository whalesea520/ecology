package weaver.formmode.customjavacode.customsearch;

import java.util.*;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.formmode.customjavacode.AbstractCustomSqlConditionJavaCode;

/**
 * 说明
 * 修改时
 * 类名要与文件名保持一致
 * class文件存放位置与路径保持一致。
 * 请把编译后的class文件，放在对应的目录中才能生效
 * 注意 同一路径下java名不能相同。
 * @author Administrator
 *
 */
public class CustomSearchTemplate extends AbstractCustomSqlConditionJavaCode {

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
		User user = (User)param.get("user");
		
		String sqlCondition = "";
		
		return sqlCondition;
	}

}
