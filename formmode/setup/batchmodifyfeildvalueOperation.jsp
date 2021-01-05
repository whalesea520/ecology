<%@page import="weaver.formmode.setup.ModeSetUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.general.GCONST" %>
<%@ page import="weaver.formmode.service.FormInfoService" %>
<%@ page import="weaver.formmode.view.ModeViewLog" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.formmode.setup.ModeRightInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page" />
<jsp:useBean id="ModeDataManager" class="weaver.formmode.data.ModeDataManager" scope="page"/>
<%
	String billids = Util.null2String(request.getParameter("billids"));
	if(billids.endsWith(",")){
		billids = billids.substring(0,billids.length()-1);
	}
	int detailid = Util.getIntValue(request.getParameter("detailid"), 0);
	String succes = "1";
	String modeid = Util.null2String(request.getParameter("modeid"));
	String maintablename = Util.null2String(request.getParameter("maintablename")); 
	String formid = Util.null2String(request.getParameter("formid"));
	String[] feildids = request.getParameterValues("feildid");
	String[] feildnames = request.getParameterValues("feildname");
	String[] tablenames = request.getParameterValues("tablename");
	String[] changetypes = request.getParameterValues("changetype");
	String[] defaultvalues = request.getParameterValues("defaultvalue");
	
	//获取表单的记录日志字段
	FormInfoService formInfoService = new FormInfoService();
	List<Map<String, Object>> needlogFieldList = formInfoService.getNeedlogField(Util.getIntValue(formid));
	String tableName = "";
	String columnNames = "";
	if(needlogFieldList.size() > 0){
		for(int i = 0; i < needlogFieldList.size(); i++){
			Map<String, Object> needlogField = needlogFieldList.get(i);
			String fieldname = Util.null2String(needlogField.get("fieldname"));
			columnNames += fieldname;
			if(i != (needlogFieldList.size() - 1)){
				columnNames += ",";
			}
		}
		rs.executeSql("select tablename from workflow_bill where id = " + formid); 
		if (rs.next()){
			tableName = rs.getString("tablename");  
		}
	}
		
	String[] billidsArray = billids.split(",");
	Map<String, Map<String, Object>> oldDataMap = new HashMap(); 
    for(int i=0;i<billidsArray.length;i++){
    	String billid = billidsArray[i];
    	Map<String, Object> oldData = new HashMap<String, Object>();
		if(needlogFieldList.size() > 0){
			oldData = formInfoService.getTableData(tableName, Util.getIntValue(billid), columnNames);
		}
		oldDataMap.put(billid, oldData);
    }
	
	RecordSetTrans rst = new RecordSetTrans();
	try{
		rst.setAutoCommit(false);
		for(int i=0;i<feildids.length;i++){
			String changetype = Util.null2String(changetypes[i]);
			String feildvalue = Util.null2String(defaultvalues[i]);
			String tablename = Util.null2String(tablenames[i]);
			String sqlwhere="  id in ("+billids+") ";
			if(!maintablename.equals(tablename)){
				sqlwhere = " mainid in ("+billids+")";
			}
			if(changetype.equals("2")){
				if(",$UserId$,$UserCode$,$DepartmentId$,$AllDepartmentId$,$SubcompanyId$,$AllSubcompanyId$,$date$,".indexOf(feildvalue)>-1){
					feildvalue = FormModeTransMethod.getDefaultSql(user,"","",feildvalue);
					feildvalue = feildvalue.replaceAll("\\$", "");
					rs.executeSql("update "+tablename+" set "+feildnames[i]+"='"+feildvalue+"' where "+sqlwhere);
				}else{
					feildvalue = feildvalue.replaceAll("\\$", "");
					rs.executeSql("update "+tablename+" set "+feildnames[i]+"="+feildvalue+" where "+sqlwhere);
				}
			}else{
				if(feildvalue.equals("")){
					rs.executeSql("update "+tablename+" set "+feildnames[i]+"=null where "+sqlwhere);
				}else{
					rs.executeSql("update "+tablename+" set "+feildnames[i]+"='"+feildvalue+"' where "+sqlwhere);
				}
			}
		}
		rst.commit();
		succes="1";
	}catch(Exception e){
		e.printStackTrace();
		rst.rollback();
		succes="0";
	}
	
	//记录更新日志	
	if(succes.equals("1")) {
		Set<String> keys = oldDataMap.keySet();
		for(String key : keys) {
			ModeViewLog ModeViewLog = new ModeViewLog();
			String operatedesc = SystemEnv.getHtmlLabelName(33797, user.getLanguage()) + SystemEnv.getHtmlLabelName(81913, user.getLanguage()) + SystemEnv.getHtmlLabelName(25465, user.getLanguage()) +  SystemEnv.getHtmlLabelName(82174, user.getLanguage());
			String operatetype = "2";//操作的类型： 1：新建 2：修改 3：删除 4：查看
			String relatedname = "";
			ModeViewLog.resetParameter();
			ModeViewLog.setClientaddress(request.getRemoteAddr());
			ModeViewLog.setModeid(Util.getIntValue(modeid));
			ModeViewLog.setOperatedesc(operatedesc);
			ModeViewLog.setOperatetype(operatetype);
			ModeViewLog.setOperateuserid(user.getUID());
			ModeViewLog.setRelatedid(Util.getIntValue(key));
			ModeViewLog.setRelatedname(relatedname);
			int viewlogid = ModeViewLog.setSysLogInfo();
			Map<String, Object> nowData = new HashMap<String, Object>();
			Map<String, Object> oldData = oldDataMap.get(key);
			if(needlogFieldList.size() > 0){
				nowData = formInfoService.getTableData(tableName, Util.getIntValue(key), columnNames);
			}
			if(operatetype.equals("2")&&needlogFieldList!=null){
				if(needlogFieldList.size() > 0){
					for(int i = 0; i < needlogFieldList.size(); i++){
						Map<String, Object> needlogField = needlogFieldList.get(i);
						String fieldid = Util.null2String(needlogField.get("id"));
						String fieldname = Util.null2String(needlogField.get("fieldname"));
						String oldFieldValue = Util.null2String(oldData.get(fieldname));
						String nowFieldValue = Util.null2String(nowData.get(fieldname));
						if(!oldFieldValue.equals(nowFieldValue)){
							Map<String, Object> logDetailMap = new HashMap<String,	Object>();
							logDetailMap.put("viewlogid", viewlogid);
							logDetailMap.put("fieldid", fieldid);
							logDetailMap.put("fieldvalue", nowFieldValue);
							logDetailMap.put("prefieldvalue", oldFieldValue);
							logDetailMap.put("modeid", modeid);
							formInfoService.saveFieldLogDetail(logDetailMap);
						}
					}
				}
			}
		}
	}
	
	String modetablename = "";
	String sql = "select b.tablename,a.formid,b.detailkeyfield from modeinfo a,workflow_bill b where a.formid = b.id and a.id = " + modeid;
    rs.executeSql(sql);
    if(rs.next()){
    	modetablename = Util.null2String(rs.getString("tablename"));
    }
	
	ModeDataManager.setFormid(Util.getIntValue(request.getParameter("formid"),-1));
    ModeDataManager.setFormmodeid(Util.getIntValue(request.getParameter("modeid"),-1));
    ModeDataManager.setPageexpandid(detailid);
    ModeDataManager.setUser(user);		
	
    //String[] billidsArray = billids.split(",");
    for(int i=0;i<billidsArray.length;i++){//重构主表字段权限和角色权限
    	int sourceId = Util.getIntValue(billidsArray[i]);
    	if(sourceId==-1){
    		continue;
    	}
		ModeRightInfo ModeRightInfo = new ModeRightInfo();
		ModeRightInfo.rebuildModeDataShareByEdit(-1,Util.getIntValue(modeid),sourceId);
		//页面扩展中的重构权限
		ModeRightInfo.addDocShare(-1,Util.getIntValue(modeid),sourceId);
		ModeDataManager.setBillid(sourceId);
	    ModeDataManager.doInterface(detailid);
	}
%>
<script type="text/javascript">
// 	var parentWin = parent.parent.getParentWindow(parent);
// 	var dialog = parent.parent.getDialog(parent);
	//debugger;
	<%if(succes.equals("1")){%>
		alert("<%=Util.null2String(SystemEnv.getHtmlLabelName(125585,user.getLanguage())).replace("{0}",billids.split(",").length+"")%>");
	<%}else{%>
		alert("<%=SystemEnv.getHtmlLabelName(125397, user.getLanguage())%>");
	<%}%>
	parent.closeWinAFrsh();
</script>

