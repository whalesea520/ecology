
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceCominfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<%
	String agentid = Util.null2String(request.getParameter("agentid"));
	String type = Util.null2String(request.getParameter("type"));
	String agented = Util.null2String(request.getParameter("agented"));
	String agentFlag = Util.null2String(request.getParameter("agentFlag"));
	String aid = "";
	String beaid = "";
	String agentername = "";
	String beagentername = "";
	String agentcount = "";
	if(!type.equals("it"))
	{
		beaid = Util.null2String(request.getParameter("beagenterid"));
	}
	String isclose=Util.null2String(request.getParameter("isclose"));
	
	rs1.executeSql(" select agentuid,bagentuid from workflow_agentConditionSet  where agentId='"+agentid+"' and agenttype=1 ");
	if(rs1.next()){
		aid=Util.null2String(rs1.getString("agentuid"));
		beaid=Util.null2String(rs1.getString("bagentuid"));
	}
%>
<%
String info = (String)request.getParameter("infoKey");
//System.out.println("info:"+info);
%>
<script language="JavaScript">
<%if(info!=null && !"".equals(info)){

  if("1".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(76,user.getLanguage())%>")
 <%}
 else if("2".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(77,user.getLanguage())%>")
 <%}
 
 else if("3".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(78,user.getLanguage())%>")
 <%}
 else if("4".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(79,user.getLanguage())%>")
 <%}
 else if("5".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26802,user.getLanguage())%>")
 <%}
 }%>
</script>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript >
	var dialog =parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	var isclose = "<%=isclose%>";
	 
	if(isclose === "1")
	{
		 
 
	  try{
	      parentWin.cz();	
		  parentWin._table.reLoad();
		}catch(e){}
		
		dialog.close();
	}
</script>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:sumbitform(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id=weaver name=weaver action="/workflow/request/wfAgentOperatorNew.jsp" method=post>
<input type="hidden" name="method" value="backAgent">
<input type="hidden" name="agenttype" value="<%=type %>" >
<input type="hidden" name="agentid" value="<%=agentid%>" >
<input type="hidden" name="isCountermandRunning" >
<input type="hidden" name="agented" value="<%=agented %>" >
<input type="hidden" name="agentFlag" value="<%=agentFlag %>" >
<input type="hidden" name="aid" value="<%=aid %>" >
<input type="hidden" name="beaid" value="<%=beaid %>" >
</FORM>
<div style="text-align:center;padding-top:30px">
	<%if(type.equals("it") || type.equals("mt")){ %>
		<%=SystemEnv.getHtmlLabelName(33352,user.getLanguage()) %>?
	<%}else{ 
		String currentDate=TimeUtil.getCurrentDateString();
    	String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
    	String swt = " and ( ( (t1.endDate = '" + currentDate + "' and (t1.endTime='' or t1.endTime is null))" + 
		    " or (t1.endDate = '" + currentDate + "' and t1.endTime > '" + currentTime + "' ) ) " + 
		    " or t1.endDate > '" + currentDate + "' or t1.endDate = '' or t1.endDate is null)" ;
		RecordSet.executeSql("select count(0) agcount from workflow_agent t1,workflow_base t2 " +
				" where t1.workflowid = t2.id and t1.agenttype='1' and exists( select 1 from workflow_agentConditionSet t3 where t3.agentid=t1.agentId and t3.agentuid='"+aid+"' ) and t1.beagenterId ='"+beaid+"'"  + swt);
	 
		if(RecordSet.first()){
			agentcount = RecordSet.getString("agcount");
		}
		
		agentername= ResourceCominfo.getLastname(aid);
		beagentername = ResourceCominfo.getLastname(beaid);
		//System.out.println(beagentername);
	 %>
	<%=SystemEnv.getHtmlLabelName(82672,user.getLanguage()) %><%=beagentername %> → <%=agentername %><%=SystemEnv.getHtmlLabelName(82673,user.getLanguage()) %> <%=agentcount %> <%=SystemEnv.getHtmlLabelName(82674,user.getLanguage()) %>?
	 <%} %>
</div>
<div style="text-align:center;padding-top:10px;color:red">
	<input type="checkbox" checked="checked" name="isBackFlowed"> <%=SystemEnv.getHtmlLabelName(18460,user.getLanguage()) %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_submit"  class="zd_btn_submit" onclick="sumbitform()">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
	    </wea:item>
		</wea:group>
	</wea:layout> 
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
<script type="text/javascript">
	function sumbitform()
	{
		if(jQuery("input[name=isBackFlowed]").attr("checked"))
		{
			$("input[name=isCountermandRunning]").val("y");
		}
		
		 e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true); 
		$G("weaver").submit();
	}
</script>
</HTML>