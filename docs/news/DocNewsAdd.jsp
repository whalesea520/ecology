
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocFrontpageAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String to = Util.null2String(request.getParameter("to"));
String id = Util.null2String(request.getParameter("id"));
int subcompanyid = 0;
int operatelevel=0;
int detachable = 0;
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
if(isUseDocManageDetach){
detachable=1;
}
if(detachable==1){
	if(subcompanyid==0){
	String hasRightSub=String.valueOf(session.getAttribute("docdftsubcomid"));
	String hasRightSubFirst="";
	if(!hasRightSub.equals("")){
	 if(hasRightSub.indexOf(',')>-1){  
	   hasRightSubFirst=Util.null2String(hasRightSub.substring(0,hasRightSub.indexOf(',')));
	 
          }else{
            hasRightSubFirst=hasRightSub;
          }

	 subcompanyid=Util.getIntValue(hasRightSubFirst,0);
    }
	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("docNews_subcompanyid")),subcompanyid);
	}
	
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocFrontpageAdd:Add",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("DocFrontpageAdd:Add", user))
        operatelevel=2;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" >
function checkSubmit(){
	var languageid=<%=user.getLanguage()%>;
	if(check_form(weaver,'frontpagename')){
		<%if(detachable==1){ %>
    		if(check_form(weaver,'subcompanyid')){
    	<%}%>
	    weaver.submit();
	    <%if(detachable==1){ %>
        }
        <%}%>
	}
}

function onSave(isEnteryDetail){
	if(isEnteryDetail)jQuery('#to').val(1);
	checkSubmit();
}

var dialog = null;
var parentWin = null;
try{
	dialog = parent.parent.getDialog(parent);
	parentWin = parent.parent.getParentWindow(parent); 
}catch(e){}

if("<%=isclose%>"=="1"){
		if("<%=to%>"=="1"){
			parentWin.location = "DocNews.jsp?id=<%=id%>&to=1";
			parentWin.closeDialog();
		}else{
			parentWin.location="DocNews.jsp";
			parentWin.closeDialog();
		}	
	}

</script>
</head>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(70,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:onSave(1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="onSave(1);" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="NewsOperation.jsp" method=post >
<input type="hidden" name="isdialog" value="<%=isDialog%>">
			<input type="hidden" name="to" id="to" value="<%=to%>">
<INPUT type="hidden" class=InputStyle name=newsperpage value="10">
<INPUT type="hidden" class=InputStyle  name=titlesperpage value="8">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="frontpagespan" required="true">
				<INPUT class=InputStyle id="frontpagename" name=frontpagename onChange="checkinput('frontpagename','frontpagespan')" >
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></wea:item>
		<wea:item>
			 <select class=InputStyle  name=newstypeid>
				<%
					rs.executeSql("select id,typename from newstype order by dspnum");
					while(rs.next()){
				%>	
					<option value="<%=rs.getString("id")%>"><%=rs.getString("typename")%></option>
				<%}%>
			 </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1993,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle  name=publishtype size=1>
				<option value="1"><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
				<option value="0"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
				<%if(isgoveproj==0){%>
					<%if(isPortalOK){%><!--portal begin-->
						   <%while(CustomerTypeComInfo.next()){
								String curid=CustomerTypeComInfo.getCustomerTypeid();
								String curname=CustomerTypeComInfo.getCustomerTypename();
								String value="-"+curid;
						   %>
								<option value="<%=value%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
						   <%
						   }%>
					<%}%><!--portal end-->
				<%}%>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=InputStyle name=isactive value=1 type=checkbox checked></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=InputStyle style="width:30px;" maxLength=3 size=3 name=typeordernum></wea:item>
		<%if(detachable==1){ %>
			<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
							hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
							completeUrl="/data.jsp?type=164" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
							browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
					</brow:browser>
				</span>
			</wea:item>
		<%}%>
	</wea:group>
</wea:layout>
  
<input type=hidden name=operation value=add>

</FORM>

<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#to').val(1);checkSubmit();">
					<span class="e8_sep_line">|</span>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="checkSubmit()">
					<span class="e8_sep_line">|</span> --%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
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
</BODY></HTML>
