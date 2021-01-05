package weaver.formmode.virtualform;

import java.util.*;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.User;

/**
 *	表单数据保存 自定义主键策略 
 */
public class CustomPKVFormDataSave extends AbstractPKVFormDataSave {

	private Object id;
	
	/***
	 * 生成主键
	 * @param paramMap
	 * paramMap包含(但不限于)以下数据
	 * formid 表单id.
	 * dataIDMap 页面数据以字段id为键存储的数据对象. 如：[121=张三, 122=男, 123=上海市]
	 * dataNameMap 页面数据以字段名称为键存储的数据对象. 如：[name=张三, sex=男, address=上海市]
	 * vFormInfo 表单自身的对象信息. 参见workflow_bill和ModeFormExtend表(几乎包含两个表中所有的列)
	 * user 当前用户
	 * @return
	 */
	public Object generateID(Map<String, Object> paramMap) {
		int formid = Util.getIntValue(Util.null2String(paramMap.get("formid")));			//表单id
		Map<String, String> dataIDMap = (Map<String, String>)paramMap.get("dataIDMap");		//页面数据以字段id为键存储的数据对象
		Map<String, String> dataNameMap = (Map<String, String>)paramMap.get("dataNameMap");	//页面数据以字段名称为键存储的数据对象
		
		Map<String, Object> vFormInfo = (Map<String, Object>)paramMap.get("vFormInfo");		//表单自身的对象信息
		String vtablename = Util.null2String(vFormInfo.get("tablename"));		//表名称
		String vdatasource = Util.null2String(vFormInfo.get("vdatasource"));	//数据源名称
		String vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));	//主键列名称
		
		//在此处键入代码为id赋值以生成主键
		
		/** 以下代码为示例代码(查找最小的主键值，并减1作为当前主键)
		RecordSet rs = new RecordSet();
		String sql = "select min("+vprimarykey+") as minid from " + vtablename;
		rs.executeSql(sql, vdatasource); 
		if (rs.next()) {
			id = Util.getIntValue(rs.getString("minid")) - 1;
		}*/
		
		return id;
	}

	/***
	 * 返回主键
	 * @param paramMap 参见generateID方法的paramMap参数
	 * @return
	 */
	public Object returnID(Map<String, Object> paramMap) {
		return id;
	}

}