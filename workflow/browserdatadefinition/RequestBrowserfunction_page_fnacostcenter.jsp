
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.List" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="FnaCommon" class="weaver.fna.general.FnaCommon" scope="page"/>

<%
	//浏览数据自定义-期间

	User bdfUser = (User) request.getAttribute("bdfUser");
	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	ConditionFieldConfig conf = field.getConfig();

	String value = field.getValue();
	if (value == null || value.isEmpty()) {
		//默认选择全部
		value = "38";
	}
	
	String sql = "";
	RecordSet rs = new RecordSet();
	String workflowId = request.getAttribute("wfid").toString();
	String fieldId = request.getAttribute("fieldId").toString();
	String fieldType = request.getAttribute("type").toString();
	List list = FnaCommon.getWfBrowdefList(workflowId, fieldId, fieldType);
	String costcenterRange = "";
	if(list != null){
		int idx = 0;
		for(Object obj : list){
			if(idx > 0){
				costcenterRange += ",";
			}
			costcenterRange += (String)obj;
			idx++;
		}
	}
	
	StringBuffer shownameFcc = new StringBuffer();
	if(!"".equals(costcenterRange)){
		sql = "select a.id, a.name from FnacostCenter a where a.id in ("+costcenterRange+") ORDER BY a.code, a.name";
		costcenterRange = "";
		rs.executeSql(sql);
		while(rs.next()){
			if(shownameFcc.length() > 0){
				shownameFcc.append(",");
				costcenterRange+=",";
			}
			shownameFcc.append(Util.null2String(rs.getString("name")).trim());
			costcenterRange+=Util.null2String(rs.getString("id")).trim();
		}
	}
%>

<brow:browser viewType="0" name="fccId" browserValue='<%=costcenterRange %>' 
        browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/costCenterByWfBrowdef/costCenterByWfBrowdefMulti.jsp%3Fselectids=#id#"
        hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
        completeUrl="/data.jsp?type=FnaFccWfBtnSetting"  temptitle='<%= SystemEnv.getHtmlLabelName(515,bdfUser.getLanguage())%>'
        browserSpanValue='<%=FnaCommon.escapeHtml(shownameFcc.toString()) %>' width="60%" 
       	>
</brow:browser>
