<%@page import="weaver.systeminfo.workflowbill.WorkFlowBillUtil"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.formmode.virtualform.VirtualFormCacheManager"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@ include file="/formmode/pub.jsp"%>
<%
int formId = Util.getIntValue(request.getParameter("formId"), 0);
String actiontype = Util.null2String(request.getParameter("actiontype"));
if(actiontype.equals("refreshform")){
	RecordSet rs = new RecordSet();
	rs.executeSql("select * from workflow_bill where id='"+formId+"'");
	String tablename = "";
	if(rs.next()){
		tablename = rs.getString("tablename");
		if(VirtualFormHandler.isVirtualForm(formId)){
			tablename = VirtualFormHandler.getRealFromName(tablename);
		}
	}
	Map<String, Object> vFormInfo = VirtualFormHandler.getVFormInfo(formId);
	String vdatasource = Util.null2String(vFormInfo.get("vdatasource"));//虚拟表单数据源
	String vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));//虚拟表单主键列名称
	RecordSet rs1 = new RecordSet();
	FormInfoService formInfoService = new FormInfoService();
	//虚拟表单
	List<Map<String, Object>> dataList = formInfoService.getFieldsByTable(vdatasource, tablename);
	List<Map<String, Object>> allFields = formInfoService.getAllField(formId);
	List<String> addFieldList = new ArrayList<String>();
	//List<Map<String, Object>> removeFieldList = new ArrayList<Map<String, Object>>();
	//查找增加的
	for(int i=0;i<dataList.size();i++){
		Map<String,Object> map = dataList.get(i);
		String column_name = Util.null2String(map.get("column_name"));
		boolean isSameField = false;
		for(int j=0;j<allFields.size();j++){
			String fieldname = Util.null2String(allFields.get(j).get("fieldname"));
			if(fieldname.toLowerCase().equals(column_name.toLowerCase())){
				isSameField = true;
				break;
			}
		}
		if(!isSameField){
			addFieldList.add(column_name);
		}
	}
	String[] vfieldNameArr = new String[addFieldList.size()];
	for(int i=0;i<addFieldList.size();i++){
		vfieldNameArr[i] = addFieldList.get(i);
	}
	formInfoService.generateVirtualTableColumns(formId, tablename, vfieldNameArr, vdatasource);
	//查找被删除的
	for(int j=0;j<allFields.size();j++){
		String fieldname = Util.null2String(allFields.get(j).get("fieldname"));
		boolean isSameField = false;
		for(int i=0;i<dataList.size();i++){
			Map<String,Object> map = dataList.get(i);
			String column_name = Util.null2String(map.get("column_name"));
			if(fieldname.toLowerCase().equals(column_name.toLowerCase())){
				isSameField = true;
				break;
			}
		}
		if(!isSameField){
			rs.execute("delete from workflow_billfield where id="+allFields.get(j).get("id"));
		}
	}
	response.sendRedirect("/formmode/setup/formfield2.jsp?id="+formId);
}
%>