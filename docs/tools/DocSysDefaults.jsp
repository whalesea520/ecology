<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
boolean CanEdit = HrmUserVarify.checkUserRight("DocSysDefaults:Edit", user);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		//jQuery("#form1").submit();
	}
	
	function shFixWidth(obj){
		if(obj.value==1){
			hideEle("fixWidth");
		}else{
			showEle("fixWidth");
		}
	}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(112,user.getLanguage());
String needfav ="1";
String needhelp ="";

String  saved=Util.null2String(request.getParameter("saved"));
%>
<script language=javascript>
function onLoad(){
    if(<%=(saved.equals("true")?"true":"false")%>){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
    }
}
</script>
<BODY onload="onLoad()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocSysDefaults:log", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where operateitem =7")+"',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%
String sql="select * from docsysdefault";
RecordSet.executeSql(sql);
RecordSet.next();
String fgpicwidth=RecordSet.getString("fgpicwidth");
String fgpicfixtype=RecordSet.getString("fgpicfixtype");
String docdefmouldid=RecordSet.getString("docdefmouldid");
String docapprovewfid=RecordSet.getString("docapprovewfid");
%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


<FORM id=weaver name=frmmain action="DocSysDefaultsOperation.jsp" method=post >
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(74,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(209,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle name="fgpicfixtype" onchange="shFixWidth(this)" size="1" class=InputStyle>
				<option value="1" <%if (fgpicfixtype.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(33607,user.getLanguage())%></option>
				<option value="2" <%if (fgpicfixtype.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(33608,user.getLanguage())%></option>
				<option value="3" <%if (fgpicfixtype.equals("3")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(33609,user.getLanguage())%></option>
				<option value="4" <%if (fgpicfixtype.equals("4")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(33610,user.getLanguage())%></option>
		  </select>
		</wea:item>
		<%String attrs = "{'samePair':'fixWidth','display':'"+(fgpicfixtype.equals("1")?"none":"")+"'}"; %>
		<wea:item attributes='<%=attrs %>'><%=SystemEnv.getHtmlLabelName(33606,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=attrs %>'>
			  <%if (CanEdit) {%>
					<input class=InputStyle style="width:150px;" type=text name="fgpicwidth" size=14
			onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'
			value="<%=Util.toScreenToEdit(fgpicwidth,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>
			  <% }else {%>
					<%=Util.toScreen(fgpicwidth,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>
				<%}%>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

</html>
