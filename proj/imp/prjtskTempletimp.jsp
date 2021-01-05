<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.net.URLDecoder.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String templetId = Util.null2String(request.getParameter("templetId"));

%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent.window);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
/**if(!HrmUserVarify.checkUserRight("Prj:Imp",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }**/
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("1332,18596",user.getLanguage());
String needfav ="1";
String needhelp ="";

String isGeneratedTemplateFile=Util.null2String( request.getParameter("isGeneratedTemplateFile"));
if(!"1".equals(isGeneratedTemplateFile)){
	response.sendRedirect("/proj/imp/prjimpopt.jsp?generateTemplateFile=1&isdata=3&isdialog="+isDialog+"&templetId="+templetId) ;
	return;
}

rs.executeSql("select templetname  from Prj_Template where id="+templetId);
String templetname = "";
if (rs.next()){
     templetname = Util.null2String(rs.getString("templetname"));
 }
%>
<BODY style="overflow-x:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<FORM id=cms name=cms action="prjimpopt.jsp?isdata=3" method=post enctype="multipart/form-data">
<input type="hidden" name=templetId value="<%=templetId %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName( 615 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="onSave(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>

<!-- listinfo -->
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("101,64,1332,18596",user.getLanguage()) %>' attributes="{'groupDisplay':''}" >
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item>
			<%=templetname%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  type=file size=40 name="filename" id="filename">
		</wea:item>

<%
String msgtype=Util.null2String(request.getParameter("msgtype"));
String msg=Util.null2String(request.getParameter("msg"));
int msgsize;
if (Util.null2String(request.getParameter("msgsize"))==""){
   msgsize=0;
}else{
msgsize=Integer.valueOf(Util.null2String(request.getParameter("msgsize"))).intValue();
}
if(!"".equalsIgnoreCase(msgtype)|| "success".equals(msg)||msgsize>0){
	%>
		<wea:item attributes="{'id':'msg','colspan':'full'}">
<font size="2" color="#FF0000">
<%


String msg1=Util.null2String((String)session.getAttribute("cptmsg1"));
String msg2=Util.null2String((String)session.getAttribute("cptmsg2"));
int dotindex=0;
int cellindex=0;
if("e4".equalsIgnoreCase(msgtype)){
	msg=SystemEnv.getHtmlLabelNames("64,26161,563",user.getLanguage())+" !";
}else if("e6".equalsIgnoreCase(msgtype)){
	msg=SystemEnv.getHtmlLabelName(82699,user.getLanguage());
}else if("e7".equalsIgnoreCase(msgtype)){
	for (int i=0;i<msgsize;i++){
		dotindex=msg1.indexOf(",");
	    cellindex=msg2.indexOf(",");
		out.println(msg1.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg2.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+SystemEnv.getHtmlLabelNames("83959,27685",user.getLanguage())+" !"+"<br>");

		 msg1=msg1.substring(dotindex+1,msg1.length());
	     msg2=msg2.substring(cellindex+1,msg2.length());
	}
}else if("e3".equalsIgnoreCase(msgtype)){
	msg=""+SystemEnv.getHtmlLabelNames("83540",user.getLanguage());
}else if("e1".equalsIgnoreCase(msgtype)){
	msg=SystemEnv.getHtmlLabelNames("24652",user.getLanguage())+" !";
}else if (msg.equals("success")){
	msg=SystemEnv.getHtmlLabelName(28450,user.getLanguage());
}else{
	for (int i=0;i<msgsize;i++){
		dotindex=msg1.indexOf(",");
	    cellindex=msg2.indexOf(",");
		out.println(msg1.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg2.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+SystemEnv.getHtmlLabelName(19327,user.getLanguage())+"<br>");
		msg1=msg1.substring(dotindex+1,msg1.length());
	    msg2=msg2.substring(cellindex+1,msg2.length());
	}
}

out.println(msg);
%></font>			
		</wea:item>	
	<%
}
%>
		
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%>'>
		<wea:item attributes="{'colspan':'full'}">
			<div>
				<br>
				<%=SystemEnv.getHtmlLabelName(28447,user.getLanguage())%><a style="color: #1d98f8;cursor: pointer;" href="prjtskTempletimp_xlsnew.xls?V=<%=System.currentTimeMillis()%>"><%=SystemEnv.getHtmlLabelName(28446,user.getLanguage())%></a>.
				<br><br>
				<%=SystemEnv.getHtmlLabelName(32986,user.getLanguage())%>.
				<br><br>
				<%=SystemEnv.getHtmlLabelName(32987,user.getLanguage())%>.
				<br><br>
				<%=SystemEnv.getHtmlLabelName(32988,user.getLanguage())%>.
				<br><br>
			</div>
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("24962",user.getLanguage())%>'>
		<wea:item attributes="{'colspan':'full'}">
			<div>
				<br>
				<strong><%=SystemEnv.getHtmlLabelName(18617,user.getLanguage())%></strong>

				<br><br>
				<span>
					<%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%>:&nbsp;
					<%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(23785,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(15274,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(2232,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(2240,user.getLanguage())%>&nbsp;
					
				</span>

<%
TreeMap<String, JSONObject> mandfieldMap= CptFieldComInfo.getMandFieldMap();
TreeMap<String, JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(openfieldMap!=null && openfieldMap.size()>0&&mandfieldMap!=null&&openfieldMap.size()>mandfieldMap.size()){
%>	
				<span >	
					<%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%>(&nbsp;
					
<%
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v= entry.getValue();
		if(v.getInt("ismand")!=1){
			
%>			
					<%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage()) %>&nbsp;
<%
		}
	}
	%>
				)</span>
				<br><br>
	<%
}

%>
				
				
			</div>
		</wea:item>
	</wea:group>
	
</wea:layout>






<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'></div>

</FORM>
<script language="javascript">
function onSave(obj){
	if ($GetEle('filename').value=="" || $GetEle('filename').value.toLowerCase().indexOf(".xls")<0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
	}else{
        var showTableDiv  = document.getElementById('_xTable');
		var message_table_Div = document.createElement("div");
		message_table_Div.id="message_table_Div";
		message_table_Div.className="xTable_message";
		showTableDiv.appendChild(message_table_Div);
		var message_table_Div  = document.getElementById("message_table_Div");
		message_table_Div.style.display="inline";
		message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(20904,user.getLanguage())%>....";
		var pTop= document.body.offsetHeight/2-60;
		var pLeft= document.body.offsetWidth/2-100;
		message_table_Div.style.position="absolute";
		message_table_Div.style.top=pTop;
		message_table_Div.style.left=pLeft;

		$GetEle('cms').submit();
		obj.disabled = true;
    }
}
</script>
<%
if("1".equals( isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
	<%
}
%>

<script type="text/javascript">	
function goBack(){
	try{
		history.go(-1);
	}catch(e){}
}
</script>
</body>
</HTML>
