<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />

<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%

if(!HrmUserVarify.checkUserRight("CptCapitalGroupAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
int subcompanyid1 = Util.getIntValue(request.getParameter("subcompanyid1"),0) ;
//int subcompanyid1 = user.getUserSubCompany1();
String supassortmentid = "" ;
String supassortmentstr ="" ;
if(paraid.equals("")) {
	supassortmentid="0";
	supassortmentstr = "0|" ;
}
else {
supassortmentid=paraid;
RecordSet.executeProc("CptCapitalAssortment_SSupAssor",supassortmentid);
RecordSet.next();
supassortmentstr = Util.null2String(RecordSet.getString(1))+supassortmentid+"|" ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";


String needfav ="1";
String needhelp ="";
%>
<BODY >
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("831",user.getLanguage()) %>'/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),mainFrame} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
if(msgid!=-1){
	out.print( "<font color=red size=2>" + SystemEnv.getErrorMsgName(msgid,user.getLanguage()) + "</font>") ;
}

%>

<FORM id=frmain action=CptAssortmentOperation.jsp method=post >
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="operation" value="addassortment">


<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
<%
if(subcompanyid1>0){
	String tmpMustInput="2";
	
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
		<wea:item>
<%
if(Util.getIntValue(supassortmentid)>0){
	%>
	<%=subcompanyid1>0? SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid1)):""%>
	<input type="hidden" name="subcompanyid1" value="<%=subcompanyid1>0?""+subcompanyid1:""%>" />
	<%
}else{
	%>
			<brow:browser viewType="0" name="subcompanyid1" browserValue='<%=subcompanyid1>0?""+subcompanyid1:""%>' browserSpanValue='<%=subcompanyid1>0? SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid1)):""%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=164" />
	<%
}

%>
		
		
		</wea:item>
	<%
}

%>	
<%
if(Util.getIntValue( supassortmentid,0)>0){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelNames("596,831",user.getLanguage())%></wea:item>
		<wea:item>
			<span><%=CapitalAssortmentComInfo.getAssortmentName(supassortmentid) %> </span>
		</wea:item>
	<%
}

%>	

	
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="assortmentname_span" required="true">
				<input class="InputStyle"  id=assortmentname  name=assortmentname size="30" onchange="checkinput(this.name,'assortmentname_span')"  >
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="assortmentmark_span" required="true">
				<input class="InputStyle" id=assortmentmark  name=assortmentmark size="30" onchange="checkinput(this.name,'assortmentmark_span')"  >
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
		<wea:item>
			<TEXTAREA  style="WIDTH:95%;overflow-x:visible;overflow-y:visible;" name=Remark rows=8></TEXTAREA>
		</wea:item>
	</wea:group>

</wea:layout>
<div style="height:50px;"></div>
<!-- 对话框底下的按钮 -->
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


</FORM>
<script language="javascript">

function submitData()
{
	if (check_form(frmain,'assortmentname,assortmentmark')){
		//frmain.submit();
		var form=jQuery("#frmain");
		var form_data=form.serialize();
		var form_url=form.attr("action");
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : true,
			data : form_data,
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				if(msg&&msg.msgid){
					if(msg.msgid==31||msg.msgid==162){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83651",user.getLanguage())%>");
					}else{
                        try{
                            if(parentWin._table){
                                parentWin._table.reLoad();
                            }
                            parentWin.refreshLeftTree();
                            parentWin.closeDialog();
                        }catch(e){}

					}
				}else{
                    try{
                        if(parentWin._table){
                            parentWin._table.reLoad();
                        }
                        parentWin.refreshLeftTree();
                        parentWin.closeDialog();
                    }catch(e){}

				}
			}
		});
		
	}
}
</script>


</BODY></HTML>
