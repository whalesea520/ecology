package $PackageName$;

import java.util.*;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.User;

import weaver.formmode.customjavacode.AbstractNumberCreateJavaCode;
import com.weaver.formmodel.mobile.remind.Reminder;

public class $ClassName$ extends AbstractNumberCreateJavaCode{

	
	/**
	 * @param paramMap 参数paramMap中包含内容如下：
	 * key: user		value: 当前用户的对象(weaver.hrm.User)
	 * key: pageParam	value: 当前页面的请求参数名和值封装的一个map对象(java.util.Map<String, String>)
	 * @return 返回一个数字，用于提醒
	 */
	@Override
	public int createANumber(Map<String, Object> paramMap) throws Exception {
		int result = 0;
		
		/* 应用示例1：获取建模查询的数据数量。(解开注释即可直接使用，注意需按实际情况修改customsearchid)
		paramMap.put("customsearchid", 0);	//表单建模的查询的id，此项需根据项目实际情况进行修改
		paramMap.put("sqlwhere", "");		//过滤条件，如果需额外增加过滤条件，此项可配置额外过滤条件如：t1.name='张三'，如无需要修改保持为""即可。
		
		Reminder reminder = new Reminder();
		result = reminder.getCountWithCustomSearch(paramMap);
		*/
		
		return result;
	}

}