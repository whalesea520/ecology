package $PackageName$;

import java.util.*;

import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.formmode.customjavacode.AbstractRemindJobJavaCode;

public class $ClassName$ extends AbstractRemindJobJavaCode {

	/**
	 * 生成提醒内容
	 */
	public String getRemindContent(Map<String, Object> param) throws Exception {
		String billid = Util.null2String(param.get("billid"));//单号ID
		String modeid = Util.null2String(param.get("modeid"));//模块ID
		Map remindJob = (Map) param.get("remindJob");//提醒设置参数
		String remindid = Util.null2String(remindJob.get("id"));//从remindJob中获取id
		RecordSet rs = new RecordSet();
		String remindContent = "";//提醒内容
		
		
		return remindContent ;
	}

}