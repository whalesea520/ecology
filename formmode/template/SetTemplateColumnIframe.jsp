<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int customid = Util.getIntValue(request.getParameter("customid"),0);
int templateid = Util.getIntValue(request.getParameter("templateid"),0);
String sourcetype = Util.null2String(request.getParameter("sourcetype"),"1");

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<HTML>
<HEAD>
<link href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<style>
.Line {
	 BACKGROUND-COLOR: #F3F2F2 !important ; BACKGROUND-REPEAT: repeat-x; HEIGHT: 1px
}
</style>
<script type="text/javascript" language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
if("<%=isclose%>"=="1"){
	parent.closeWinAFrsh();	
}
</script>
<TITLE></TITLE>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closePrtDlgARfsh(),mainFrame} " ;//关闭
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存 -->
				<input class="e8_btn_top middle" onclick="javascript:submitData()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<div class="zDialog_div_content">
<form id="frmain" name="frmain" method="post" action="SaveTemplateOperation.jsp" >
<input type="hidden" name="customid" value="<%=customid %>" />
<input type="hidden" name="templateid" value="<%=templateid %>" />
<input type="hidden" name="valuearray" value="" />
<input type="hidden" name="method" value="saveTemplateField" />
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
<td ></td>
<td valign="top">
<table class=liststyle cellspacing=1 id="tab_dtl_list-1">
	<COLGROUP>
	<COL width="20%">
	<COL width="20%">
	<COL width="20%">
	</COLGROUP>
	<tr class=header>
		<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><!-- 字段名 --></td>
		<td>
			<input type="checkbox" name="title_viewall"  onClick="onChangeViewAll(-1,this.checked)" >
			<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%><!-- 是否显示 -->
		</td>
		<td><%=SystemEnv.getHtmlLabelName(23691,user.getLanguage())%><!-- 字段排序 --></td>
	</tr>
	<TR class=Line ><TD colSpan=3></TD></TR>
	<%
	String sqlwhere = "";
	if ("1".equals(sourcetype)) { //高级查询
		sqlwhere = " and cdf.isAdvancedQuery=1 ";
	} else { //普通查询
		sqlwhere = " and cdf.isquery=1 ";
	}
	if ("sqlserver".equals(RecordSet.getDBType())) {
		RecordSet.executeSql("select wb.id,fieldlabel,t.isshow,t.fieldorder from workflow_billfield wb left join mode_TemplateDspField t on (wb.id=t.fieldid and t.templateid="+templateid+"),mode_customsearch ms,mode_CustomDspField cdf where ms.id=cdf.customid and wb.billid=ms.formid and cdf.fieldid=wb.id "+sqlwhere+" and ms.id="+customid+" and (wb.viewtype=0 or wb.detailtable=ms.detailtable) order by isNull(t.fieldorder,999999),wb.viewtype,wb.id asc");
	} else {
		RecordSet.executeSql("select wb.id,fieldlabel,t.isshow,t.fieldorder from workflow_billfield wb left join mode_TemplateDspField t on (wb.id=t.fieldid and t.templateid="+templateid+"),mode_customsearch ms,mode_CustomDspField cdf where ms.id=cdf.customid and wb.billid=ms.formid and cdf.fieldid=wb.id "+sqlwhere+" and  ms.id="+customid+" and (wb.viewtype=0 or wb.detailtable=ms.detailtable) order by nvl(t.fieldorder,999999),wb.viewtype,wb.id asc");
	}
	while (RecordSet.next()) {
		String fieldid = RecordSet.getString("id");
		String fieldlabel = RecordSet.getString("fieldlabel");
		String isshow = RecordSet.getString("isshow");
		String fieldorder = RecordSet.getString("fieldorder");
		String fieldlabelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
	%>
	<tr>
	   <td><input type="hidden" name="templatefieldid" value="<%=fieldid %>"/><%=fieldlabelname %></td>
	   <td><input type="checkbox" id="template<%=fieldid%>_isshow" <%if("1".equals(isshow)){ %>checked<%} %>></td>
	   <td><input type="text" class="Inputstyle" id="template<%=fieldid%>_order" maxlength="6" onKeyPress="ItemCount_KeyPress(this)" value="<%=fieldorder%>" style="width:80%"></td>
	</tr>
	<TR class=Line ><TD colSpan=3></TD></TR>
	<%} %>
</table>
</td>
</tr>
<td></td>
</table>
</form>
</div>
<%if ("1".equals(isDialog)) {%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar"><!-- 关闭 -->
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %>
<script language="javascript">

function submitData() {
	var fieldobjs = document.getElementsByName("templatefieldid");
	var params = "";
	for (var i = 0 ; i < fieldobjs.length ; i++) {
		var fieldObj = fieldobjs[i];
		var fieldid = fieldObj.value;
		var fieldisshow = document.getElementById("template"+fieldid+"_isshow").checked;
		if (!fieldisshow) {
			continue;
		}
		fieldisshow = "1";
		var fieldorder = document.getElementById("template"+fieldid+"_order").value;
		if (!fieldorder) fieldorder = "0";
		params += fieldid +"," + fieldisshow + "," + fieldorder ;
		params += "+";
	}
	document.frmain.valuearray.value = params;
	document.frmain.submit();
}
function closePrtDlgARfsh() {
	window.parent.closeWinAFrsh();
}
function onChangeViewAll(id, opt) {
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows[i];
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd1 = tmpTr.cells[1];
		if(tmpTd1 == undefined){
			continue;
		}
		changeCheckboxStatus(tmpTd1.childNodes[0].childNodes[0],opt);
	}
}
// 判断input框中是否输入的是数字,不包括小数点
function ItemCount_KeyPress()
{
	var evt = getEvent();
	var keyCode = evt.which ? evt.which : evt.keyCode;
 if(!(((keyCode>=48) && (keyCode<=57))))
  {
     if (evt.keyCode) {
     	evt.keyCode = 0;evt.returnValue=false;     
     } else {
     	evt.which = 0;evt.preventDefault();
     } 
  }
}
</script>
</BODY>
</HTML>