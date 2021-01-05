package weaver.formmode.customjavacode.modeexpand;

import java.util.*;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.soa.workflow.request.RequestInfo;
import weaver.formmode.customjavacode.AbstractModeExpandJavaCode;


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
public class ModeExpandTemplate extends AbstractModeExpandJavaCode {
	/**
	 * 执行模块扩展动作
	 * @param param
	 *  param包含(但不限于)以下数据
	 *  user 当前用户
	 */
	public void doModeExpand(Map<String, Object> param) throws Exception {
		User user = (User)param.get("user");
		int billid = -1;//数据id
		int modeid = -1;//模块id
		RequestInfo requestInfo = (RequestInfo)param.get("RequestInfo");
		if(requestInfo!=null){
			billid = Util.getIntValue(requestInfo.getRequestid());
			modeid = Util.getIntValue(requestInfo.getWorkflowid());
			if(billid>0&&modeid>0){
				RecordSet rs =new RecordSet();
				//------请在下面编写业务逻辑代码------
				
			}
		}
	}

}