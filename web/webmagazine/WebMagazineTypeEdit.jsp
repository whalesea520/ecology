
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31516,user.getLanguage());
String needfav ="1";
String needhelp ="";
String typeID = ""+Util.getIntValue(request.getParameter("typeID"),0);
String typeName = "";
String typeRemark = "";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int subcompanyid = 0;
int operatelevel=0;

String optype=Util.null2String(request.getParameter("optype"));

RecordSet.executeSql("select * from WebMagazineType where id = " + typeID);
if (RecordSet.next()) 
{
	typeName = Util.null2String(RecordSet.getString("name"));
	typeRemark = Util.fromHtmlToEdit(Util.null2String(RecordSet.getString("remark")));
	subcompanyid = Util.getIntValue(RecordSet.getString("subcompanyid"),0);
}
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
if(detachable==1){
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WebMagazine:Main",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("WebMagazine:Main", user))
        operatelevel=2;
}
%>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%= typeName %>");
	}catch(e){}
</script>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isDialog.equals("1")){ 
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/web/webmagazine/WebMagazineList.jsp?typeID="+typeID+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			  
			<FORM name="Magazine"  action="WebMagazineOperation.jsp" method="post">
			<input type="hidden" name="method" value="TypeUpdate">
			<input type="hidden" name="typeID" value="<%=typeID%>">
			<input type="hidden" name="isdialog" value="<%=isDialog%>">
			<wea:layout>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(31517,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="nameSpan" required="true" value='<%=typeName%>'>
							<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(31517,user.getLanguage())%>" class="InputStyle" type="text" value="<%=typeName%>" name="name" onChange="checkinput('name','nameSpan')">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
					<wea:item><textarea class="InputStyle" name="remark" cols="50"><%=typeRemark%></textarea></wea:item>
					<%if(detachable==1){ %>
						<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
						        <brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
						                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
						                language='<%=""+user.getLanguage() %>'
						                hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
						                completeUrl="/data.jsp?type=164" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
						                browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
						        </brow:browser>
						     </span>
						</wea:item>
					<%} %>
				</wea:group>
			</wea:layout>
			
			</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
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
</BODY>
</HTML>
<script language="javascript">
function submitData()
{
	if (check_form(Magazine,'name'))
		Magazine.submit();
}
var parentWin = parent.parent.getParentWindow(parent);
var parentDialog = parent.parent.getDialog(parent); 
if("<%=isclose%>"=="1"){
	//parentWin.location="WebMagazineTypeList.jsp";
	parentWin._table.reLoad();
	parentWin.closeDialog();	
}

</script>
