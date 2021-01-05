<%@page import="java.util.Map.Entry"%>
<%@page import="weaver.proj.util.PrjWfUtil"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />




<%

String rightStr="Cpt:CusWfConfig";
if(!HrmUserVarify.checkUserRight(rightStr,user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String id = Util.null2String(request.getParameter("id"));
String wfid = "";
	String wftype ="";
String formid="";
String formname="";
String prjtype="";
String isopen="1";
boolean isEdit=false;
if(Util.getIntValue(id)>0){
	RecordSet.executeSql("select * from uf4mode_cptwfconf where id="+id);
	if(RecordSet.next()){
		wfid = RecordSet.getString("wfid");
		wftype = RecordSet.getString("wftype");
		isopen = RecordSet.getString("isopen");
		formid=WorkflowComInfo.getFormId(wfid);
		isEdit = true;
	}
}else{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}



String titlelabel="";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));



%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<style type="text/css">
	select{
		/*width:300px!important;*/
	}
</style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver action="/formmode/cuspage/cpt/conf/cptwfop2.jsp" method=post>
<input type="hidden" name="method" value="fieldmap" />
<input type="hidden" name="wftype" value="<%=wftype %>" />
<input type="hidden" name="id" value="<%=id %>" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table class="ListStyle" cols=2  border=0 cellspacing=1 style="">
    <COLGROUP>
		<COL width="30%">
		<COL width="70%">
          <tr class=header>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("15552",user.getLanguage())%></td>
            <td nowrap><%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%></td>
          </tr>
<%
String checkStr1="";
JSONObject jsonObject1=new JSONObject();
jsonObject1.put("fieldname", "sqr");
jsonObject1.put("fieldhtmltype", "3");
jsonObject1.put("type", "1");
jsonObject1.put("ismand", 1);

JSONObject jsonObject2=new JSONObject();
jsonObject2.put("fieldname", "zczl");
jsonObject2.put("fieldhtmltype", "3");
jsonObject2.put("fielddbtype", "browser.cptcapital");
jsonObject2.put("type", "161");
jsonObject2.put("ismand", 1);

JSONObject jsonObject3=new JSONObject();
jsonObject3.put("fieldname", "zc");
jsonObject3.put("fieldhtmltype", "3");
String browsertype="cptcapitalinfo";
/**
 * 领用（cptcapitalinfo_workflow_ly），调拨（cptcapitalinfo_workflow_db），
 * 借用（cptcapitalinfo_workflow_jy），减损（cptcapitalinfo_workflow_js），
 * 报废（cptcapitalinfo_workflow_bf），送修（cptcapitalinfo_workflow_sx），
 * 归还（cptcapitalinfo_workflow_gh）
 */
if ("fetch".equalsIgnoreCase (wftype)) {
	browsertype="cptcapitalinfo_workflow_ly";
}else if ("move".equalsIgnoreCase (wftype)) {
	browsertype="cptcapitalinfo_workflow_db";
}else if ("lend".equalsIgnoreCase (wftype)) {
	browsertype="cptcapitalinfo_workflow_jy";
}else if ("loss".equalsIgnoreCase (wftype)) {
	browsertype="cptcapitalinfo_workflow_js";
}else if ("discard".equalsIgnoreCase (wftype)) {
	browsertype="cptcapitalinfo_workflow_bf";
}else if ("mend".equalsIgnoreCase (wftype)) {
	browsertype="cptcapitalinfo_workflow_sx";
}else if ("back".equalsIgnoreCase (wftype)) {
	browsertype="cptcapitalinfo_workflow_gh";
}
jsonObject3.put("fielddbtype", "browser."+browsertype);
jsonObject3.put("type", "161");
jsonObject3.put("ismand", 1);

JSONObject jsonObject4=new JSONObject();
jsonObject4.put("fieldname", "sl");
jsonObject4.put("fieldhtmltype", "1");
jsonObject4.put("type", "3");
jsonObject4.put("ismand", 1);

JSONObject jsonObject5=new JSONObject();
jsonObject5.put("fieldname", "jg");
jsonObject5.put("fieldhtmltype", "1");
jsonObject5.put("type", "3");
jsonObject5.put("ismand", 0);

JSONObject jsonObject6=new JSONObject();
jsonObject6.put("fieldname", "rq");
jsonObject6.put("fieldhtmltype", "3");
jsonObject6.put("type", "2");
jsonObject6.put("ismand", 0);

JSONObject jsonObject7=new JSONObject();
jsonObject7.put("fieldname", "ggxh");
jsonObject7.put("fieldhtmltype", "1");
jsonObject7.put("type", "1");
jsonObject7.put("ismand", 0);

JSONObject jsonObject8=new JSONObject();
jsonObject8.put("fieldname", "cfdd");
jsonObject8.put("fieldhtmltype", "1");
jsonObject8.put("type", "1");
jsonObject8.put("ismand", 0);

JSONObject jsonObject9=new JSONObject();
jsonObject9.put("fieldname", "bz");
jsonObject9.put("fieldhtmltype", "1");
jsonObject9.put("type", "1");
jsonObject9.put("ismand", 0);

JSONObject jsonObject10=new JSONObject();
jsonObject10.put("fieldname", "wxqx");
jsonObject10.put("fieldhtmltype", "3");
jsonObject10.put("type", "2");
jsonObject10.put("ismand", 0);

JSONObject jsonObject11=new JSONObject();
jsonObject11.put("fieldname", "wxdw");
jsonObject11.put("fieldhtmltype", "3");
jsonObject11.put("fielddbtype", "browser.wxdw");
jsonObject11.put("type", "161");
jsonObject11.put("ismand", 0);


String sql="select t1.* from uf4mode_cptwfconf t1 where t1.id="+id;
RecordSet.executeSql(sql);
if(!RecordSet.next()){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<tr class="DataLight">
	<td><%=SystemEnv.getHtmlLabelNames("368", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject1, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("sqr"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("179,695",user.getLanguage())%>" />
	</td>
</tr>	
<tr class="DataDark" style="display:<%=!"apply".equalsIgnoreCase(wftype)?"none;":"" %> ">
	<td><%=SystemEnv.getHtmlLabelNames("1509", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject2, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("zczl"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("125361",user.getLanguage())%>" />
	</td>
</tr>	
<tr class="DataLight" style="display:<%="apply".equalsIgnoreCase(wftype)?"none;":"" %> ">
	<td><%=SystemEnv.getHtmlLabelNames("535", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject3, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("zc"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("21002",user.getLanguage())+":"+browsertype %>" />
	</td>
</tr>
<tr class="DataDark" style="display:<%="lend".equalsIgnoreCase(wftype)||"back".equalsIgnoreCase(wftype)||"move".equalsIgnoreCase(wftype)||"mend".equalsIgnoreCase(wftype)?"none;":"" %> ">
	<td><%=SystemEnv.getHtmlLabelNames("1331", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject4, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("sl"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("15203",user.getLanguage())%>" />
	</td>
</tr>
<tr class="DataLight" style="display:<%=!"apply".equalsIgnoreCase(wftype)&&!"loss".equalsIgnoreCase(wftype)&&!"discard".equalsIgnoreCase(wftype)&&!"mend".equalsIgnoreCase(wftype)?"none;":"" %> ">
	<td><%="apply".equalsIgnoreCase(wftype)? SystemEnv.getHtmlLabelNames("726",user.getLanguage()):SystemEnv.getHtmlLabelNames("1491",user.getLanguage()) %></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject5, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("jg"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("15203",user.getLanguage())%>" />
	</td>
</tr>
<tr class="DataDark">
	<td><%=SystemEnv.getHtmlLabelNames("97", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject6, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("rq"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("97,695",user.getLanguage())%>" />
	</td>
</tr>
<tr class="DataLight" style="display:<%=!"apply".equalsIgnoreCase(wftype)?"none;":"" %> ">
	<td><%=SystemEnv.getHtmlLabelNames("904", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject7, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("ggxh"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("19110",user.getLanguage())%>" />
	</td>
</tr>
<tr class="DataDark" style="display:<%="mend".equalsIgnoreCase(wftype)?"none;":"" %> ">
	<td><%=SystemEnv.getHtmlLabelNames("1387", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject8, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("cfdd"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("19110",user.getLanguage())%>" />
	</td>
</tr>
<tr class="DataLight">
	<td><%=SystemEnv.getHtmlLabelNames("454", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject9, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("bz"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("19110",user.getLanguage())%>" />
	</td>
</tr>
<tr class="DataDark" style="display:<%=!"mend".equalsIgnoreCase(wftype)?"none;":"" %> ">
	<td><%=SystemEnv.getHtmlLabelNames("22457", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject10, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("wxqx"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("97,695",user.getLanguage())%>" />
	</td>
</tr>
<tr class="DataDark" style="display:<%=!"mend".equalsIgnoreCase(wftype)?"none;":"" %> ">
	<td><%=SystemEnv.getHtmlLabelNames("1399", user.getLanguage())%></td>
	<td>
		<%=PrjWfUtil.getSelect(jsonObject11, user, formid, wftype, "-1", Util.null2String(RecordSet.getString("wxdw"))) %>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames("125362",user.getLanguage())%>" />
	</td>
</tr>


</table>
	
</FORM>
<script language="javascript">
function mycheck(obj){
	if(jQuery(obj).val()!=""){
		jQuery(obj).parents("td").first().find("img[type=mycheck]").hide();
	}else{
		if(jQuery(obj).attr("ismand")==1){
			jQuery(obj).parents("td").first().find("img[type=mycheck]").show();
		}
	}
}

function submitData()
{
	var wftype='<%=wftype %>';
	var checkstr="";
	if(wftype=="apply"){
		checkstr="apply_sqr,apply_zczl,apply_sl";
	}else if(wftype=="fetch"){
		checkstr="fetch_sqr,fetch_zc,fetch_sl";
	}else if(wftype=="move"){
		checkstr="move_sqr,move_zc";
	}else if(wftype=="lend"){
		checkstr="lend_sqr,lend_zc";
	}else if(wftype=="loss"){
		checkstr="loss_sqr,loss_zc,loss_sl";
	}else if(wftype=="discard"){
		checkstr="discard_sqr,discard_zc,discard_sl";
	}else if(wftype=="back"){
		checkstr="back_sqr,back_zc";
	}else if(wftype=="mend"){
		checkstr="mend_sqr,mend_zc";
	}
	if (check_form(weaver,checkstr)){
		//weaver.submit();
		var form=jQuery("#weaver");
		var form_data=form.serialize();
		var form_url=form.attr("action");
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : true,
			data : form_data,
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(data){
				if(!data.errmsg){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
				}
				
			}
		});
	}
}

$(function(){
	$("select").blur();
});
</script>
</BODY>
</HTML>
