
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
String type = Util.null2String(request.getParameter("type"));
String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

//4E8 项目权限等级(默认共享的值设置:项目成员0.5,项目经理2.5,项目经理上级3,项目管理员4;手动共享值设置:查看1,编辑2)
String ptype=Util.null2String( CommonShareManager.getPrjPermissionType(ProjID, user) );

if(ptype.equals("2.5")||ptype.equals("2")){
	canview=true;
	canedit=true;
	ismanager=true;
}else if (ptype.equals("3")){
	canview=true;
	canedit=true;
	ismanagers=true;
}else if (ptype.equals("4")){
	canview=true;
	canedit=true;
	isrole=true;
}else if (ptype.equals("0.5")){
	canview=true;
	ismember=true;
}else if (ptype.equals("1")){
	canview=true;
	isshare=true;
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdPRJ_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+" - "+"<a href='/proj/data/ViewProject.jsp?log=n&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("611,783",user.getLanguage()) %>'/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver action="/proj/process/PrjCustomerOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="type" value="<%=type%>">
<input type="hidden" name=powerlevel value="0">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1361",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("136",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="CustomerID" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=7"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("433",user.getLanguage())%></wea:item>
		<wea:item><input name=reasondesc class=InputStyle maxLength=100 style="width=100%"></wea:item>
		
	</wea:group>
</wea:layout>



</FORM>

<script type="text/javascript">
function onSubmit(){
	if (check_form(weaver,'CustomerID')){
		//weaver.submit();
		var form=jQuery("#weaver");
		var form_data=form.serialize();
		var form_url=form.attr("action");
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : true,
			data : form_data,
			dataType : "html",
			success: function do4Success(msg){
				parentWin.closeDialog();
				parentWin._table.reLoad();
			}
		});
		
	}
}
</script>

<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
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

</body>
</html>


