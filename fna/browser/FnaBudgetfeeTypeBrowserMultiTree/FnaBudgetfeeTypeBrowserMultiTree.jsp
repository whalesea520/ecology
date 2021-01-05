<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
RecordSet rs = new RecordSet();
BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

int supsubject = Util.getIntValue(request.getParameter("supsubject"),0);
String selectIds = Util.null2String(request.getParameter("selectids")).trim();

List<String> selectIds_list = null;
if(!"".equals(selectIds)){
	String[] selectedPks_array = selectIds.split(",");
	selectIds_list = Arrays.asList(selectedPks_array);
}else{
	selectIds_list = new ArrayList<String>();
}

List<Map<String, Object>> treeNodeList = new ArrayList<Map<String,Object>>();
List<String> subject2_list = BudgetfeeTypeComInfo.recursiveSubordinate(supsubject+"");
int subject2_list_len = subject2_list.size();
for(int i=0;i<subject2_list_len;i++){
	int _id = Util.getIntValue(subject2_list.get(i));
	if(_id!=supsubject){
		String _name = budgetfeeTypeComInfo.getBudgetfeeTypename(_id+"");
		int pId = Util.getIntValue(budgetfeeTypeComInfo.getBudgetfeeTypeSupSubject(_id+""));
		
		Map<String, Object> treeNode = new HashMap<String, Object>();
		treeNodeList.add(treeNode);
		
		
		boolean chkDisabled = Util.getIntValue(budgetfeeTypeComInfo.getIsEditFeeType(_id+""))!=1;
		boolean isParent = chkDisabled;
		
		treeNode.put("id", _id);
		treeNode.put("name", _name);
		treeNode.put("isParent", isParent);
		treeNode.put("chkDisabled", chkDisabled);
		if(selectIds_list.contains(_id+"") && !chkDisabled){
			treeNode.put("checked", true);
		}
		treeNode.put("pId", pId);
	}
}

JSONObject jsonObject = new JSONObject();
jsonObject.element("treeNodeArray", treeNodeList.toArray());

String _fnaWfTree_zNodes = jsonObject.getJSONArray("treeNodeArray").toString();

%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="net.sf.json.JSONObject"%><html>
<head>
<link rel="stylesheet" href="/fna/browser/FnaBudgetfeeTypeBrowserMultiTree/FnaBudgetfeeTypeBrowserMultiTree.css" type="text/css">
<script type="text/javascript">
var _fnaWfTree_zNodes = <%=_fnaWfTree_zNodes %>;
</script>
<script language="javascript" src="/fna/browser/FnaBudgetfeeTypeBrowserMultiTree/FnaBudgetfeeTypeBrowserMultiTree.js?r=2"></script>
<script language="javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core.min_wev8.js"></script>
<script language="javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.excheck.min_wev8.js"></script>
<script language="javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.exedit.min_wev8.js"></script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:parent.onClear(),_self}";
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parent.btncancel_onclick(),_self}";
RCMenuHeight += RCMenuHeightStep ;
%>
</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(27766, user.getLanguage()) %>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="dialog">
	<ul style="margin: 0; border: 0; padding: 0;" id="fnaWfTree" class="ztree"></ul>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" class="zd_btn_cancle" id="btnsave" onclick="onSave1();" 
					value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
				<input type="button" class="zd_btn_cancle" id="btnclear" onclick="onClear();" 
					value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
		        <input type="button" class="zd_btn_cancle" id="btncancel" onclick="btncancel_onclick();" 
		        	value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>
</body>
</html>























