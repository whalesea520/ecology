<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="OverTimeSetBean" class="weaver.workflow.request.OverTimeSetBean" scope="page" />
<%
	String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
	String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
	user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
    int userid=user.getUID();
    String logintype=user.getLogintype();
    int usertype=0;
    if(logintype.equals("1")) usertype = 0;
    if(logintype.equals("2")) usertype = 1;
    String option=Util.null2String(request.getParameter("option"));
    int workflowid=Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
    int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
    int requestid=Util.getIntValue(Util.null2String(request.getParameter("requestid")),0);
    int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
    int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),0);
    int billid=Util.getIntValue(Util.null2String(request.getParameter("billid")),0);
    String sql="";
    if(!OverTimeSetBean.getRight(requestid,workflowid,nodeid,userid,usertype)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
    String nodeids="";
    ArrayList nodeidlist=new ArrayList();
    ArrayList nodepasshourlist=new ArrayList();
    ArrayList nodepassminutelist=new ArrayList();
    ArrayList ProcessorOpinionlist=new ArrayList();
    if(option.equals("save")){
        nodeids=Util.null2String(request.getParameter("nodeids"));
        OverTimeSetBean.dosave(nodeids,requestid,workflowid,request);
        ArrayList[] arrnodelist=OverTimeSetBean.getOverTimeInfo(requestid,workflowid,nodeid,formid,isbill,billid,nodeids);
        if(arrnodelist!=null&&arrnodelist.length==4){
            nodeidlist=arrnodelist[0];
            nodepasshourlist=arrnodelist[1];
            nodepassminutelist=arrnodelist[2];
            ProcessorOpinionlist=arrnodelist[3];
        }
    }else{
        nodeids=OverTimeSetBean.getCurrentNodeToEndNode(nodeid,workflowid,requestid,""+nodeid);
        ArrayList[] arrnodelist=OverTimeSetBean.getOverTimeInfo(requestid,workflowid,nodeid,formid,isbill,billid,nodeids);
        if(arrnodelist!=null&&arrnodelist.length==4){
            nodeidlist=arrnodelist[0];
            nodepasshourlist=arrnodelist[1];
            nodepassminutelist=arrnodelist[2];
            ProcessorOpinionlist=arrnodelist[3];
        }
    }
%>
<html>
<head>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="height: 100%!important;">
<form id="overtiemform" name="overtiemform" method=post action="OverTimeSetByNodeUserTab.jsp" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:onsave(this),_self"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type="hidden" name="option" value="save">
<input type="hidden" name="requestid" value="<%=requestid%>">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="nodeid" value="<%=nodeid%>">
<input type="hidden" name="formid" value="<%=formid%>">
<input type="hidden" name="isbill" value="<%=isbill%>">
<input type="hidden" name="billid" value="<%=billid%>">
<input type="hidden" name="nodeids" value="<%=nodeids%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18818,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(2068,user.getLanguage())%></wea:item>
		<%
	      for(int i=0;i<nodeidlist.size();i++){
	        int tempnodeid=Util.getIntValue(""+nodeidlist.get(i));
	        String tempnodename=OverTimeSetBean.getNodeName(tempnodeid);
	        String tempProcessorOpinion=""+ProcessorOpinionlist.get(i);
	        String tempnodepasshour=""+nodepasshourlist.get(i);
	        String tempnodepassminute=""+nodepassminutelist.get(i);
		%>
			<wea:item><%=tempnodename%>
        		<input type="hidden" name="nodeid_<%=tempnodeid%>" value="<%=tempnodeid%>">
        		<input type="hidden" name="ProcessorOpinion_<%=tempnodeid%>" value="<%=tempProcessorOpinion%>"  maxlength="100" size="30">
			</wea:item>
			<wea:item>
				<input type=text class=InputStyle name="nodepasshour_<%=tempnodeid%>" id ="nodepasshour_<%=tempnodeid%>" 
					size=5 maxlength="3" style="width:40px;" value="<%=tempnodepasshour%>" 
        			onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);if(this.value<0) this.value="";' />
             	<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
		       <%
		       if("true".equals(isIE)){%>
		            <!-- 
		        	<span class="xpSpin1" id="nodepassminute_<%=tempnodeid%>"  fieldname="nodepassminute_<%=tempnodeid%>" 
		         	min="0" max="59"  value="<%=tempnodepassminute%>" style="font-size:12px;font-family:MS Shell Dlg;height:20px;width:40px;" 
		         	language=<%=user.getLanguage()%>></span>
		         	-->
		         	<span>
		         	<input  type="text" id="nodepassminute_<%=tempnodeid%>"  name="nodepassminute_<%=tempnodeid%>" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this);checkNum(this);"
		         	min="0" max="59" value="<%=tempnodepassminute%>" style="font-size:12px;font-family:MS Shell Dlg;height:20px;width:40px;" 
		         	language=<%=user.getLanguage()%>>
		         	<img usemap="#changeNumber<%=tempnodeid%>" ismap="ismap" style="padding:0px;margin:0px;vertical-align:middle; cursor: pointer;" src="/js/jquery/plugins/spin/spin-button_wev8.png"/>
		            <map name="changeNumber<%=tempnodeid%>">
		              <area shape="rect" coords="0,0,15,8" href="javascript:changeNum(jQuery('#nodepassminute_<%=tempnodeid%>'),1)">
		              <area shape="rect" coords="0,8,15,16" href="javascript:changeNum(jQuery('#nodepassminute_<%=tempnodeid%>'),-1)">
		            </map>
		            </span>
		       <%} else {%>
					<input type="number" min="0" max="59"  maxLength="2" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this);checkNum(this);" 
						name="nodepassminute_<%=tempnodeid%>"  value="<%=tempnodepassminute%>" id="nodepassminute_<%=tempnodeid%>" 
						style="width: 40px; height: 20px; font-family: MS Shell Dlg; font-size: 12px;" />
		       <%}%>  
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</wea:item>
		<%} %>
	</wea:group>
</wea:layout>

<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
	<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
</div>
<script language=javascript>
function checkNum(obj) {
	var mintue = obj.value;
	if(parseInt(mintue) > 59) {
		<%if (user.getLanguage() == 7) {%>
			alert("<%=SystemEnv.getHtmlLabelName(28372,user.getLanguage())%> ");
		<% } else if (user.getLanguage() == 8) {%>
			alert("<%=SystemEnv.getHtmlLabelName(28372,user.getLanguage())%> ");
		<% } else {%>
			alert("<%=SystemEnv.getHtmlLabelName(28372,user.getLanguage())%> ");
		<%}%>
		obj.value = 59; 
	}
}
						
function onsave(obj){
    obj.disabled=true;
    overtiemform.submit();
}

<%if(option.equals("save")){	%>
	window.close();
<%}%>

function changeNum(obj,flag){
   var target = jQuery(obj);
   var val = target.val();
   if(!isNaN(val)&&"" != val){
      var result = (parseInt(val)+flag);
      if(result<0)
      	  result = 0;
      if(result>59)
      	  result = 59;
   	  target.val(result);
   }else{
      if(flag == 1)
        target.val(1);
      else
        target.val(0);
   }
}

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent.window);
	dialog =parent.parent.getDialog(parent.window);
}catch(e){}

</script>
</body>
</html>