package weaver.formmode.customjavacode.moderightinfo;

import java.util.*;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.formmode.customjavacode.AbstractModeRightInfoJavaCode;

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
public class ModeRightTemplate extends AbstractModeRightInfoJavaCode {

	/**
	 *	根据具体数据内容，判断该权限是否生效
	 *	@param param
	 *	param包含(但不限于)以下数据
	 *	user 当前用户
	 *	dataNameMap 页面数据以字段名称为键存储的数据对象. 如：[name=张三, sex=男, address=上海市]
	 *
	 *	字段信息如下（如果包含不安全的字符，请将该字段注释去掉）：$fieldinfo$
	 *
	 * 	@return
	 */
	public boolean checkUserRight(Map<String, Object> param) throws Exception {
		User user = (User)param.get("user");
		Map<String,Object> dataNameMap=(Map<String, Object>)param.get("dataNameMap");
		boolean isRight=false;
		
		return isRight;
	}

}