<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(82,user.getLanguage());//报表:新建
String needfav ="1";
String needhelp ="";
String reportname = Util.null2String(request.getParameter("reportname"));
String modeid=Util.null2String(request.getParameter("modeid"));
String modename = "";
String sql = "";
if(!modeid.equals("")){
	sql = "select modename from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
	}
}
if(modename.equals("")){
	modename = "<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>";
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep;
%>
<%//返回
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/formmode/report/ReportManage.jsp?reportname="+reportname+"&modeid="+modeid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain action="ReportOperation.jsp" method=post onsubmit="return false">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<TABLE class="viewform">
				<COLGROUP>
					<COL width="20%">
					<COL width="80%">
				</COLGROUP>
				<TBODY>
			    	<TR class="Spacing" style="height: 1px">
						<TD class="Line" colSpan=2 ></TD>
					</TR>
					<TR>
		      			<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><!-- 名称 -->
		          		<TD class=Field>
		        			<INPUT type=text class=Inputstyle size=30 maxlength="50" name="reportname" onchange='checkinput("reportname","reportnameimage")' value="">
		          			<SPAN id=reportnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		          		</TD>
		        	</TR>
		        	<TR style="height: 1px">
		    			<TD class="Line" colSpan=2 ></TD>
		    		</TR>
					<TR>
			      		<TD><%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%></TD><!-- 模块名称 -->
						<td class="Field">
					  		 <button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON>
					  		 <span id=modeidspan><%=modename%></span>
					  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
						</td>
			        </TR>
			        <TR class="Spacing" style="height: 1px">
			    		<TD class="Line" colSpan=2 ></TD>
			    	</TR>
					<TR>
			      		<TD><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage())%></TD><!-- 每页显示记录数 -->
						<td class="Field">
					  		 <input type="text" onKeyPress="ItemPlusCount_KeyPress()" maxlength="9" onblur='checkPlusnumber1(reportnumperpage),checkinput("reportnumperpage","reportnumperpageimage")' name="reportnumperpage" id="reportnumperpage">
					  		 <SPAN id=reportnumperpageimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
						</td>
			        </TR>
			        <TR class="Spacing" style="height: 1px">
			    		<TD class="Line" colSpan=2 ></TD>
			    	</TR>
					<TR>
						<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD><!-- 描述 -->
						<TD class=Field>
							<textarea rows="4" cols="80" name="reportdesc" onkeyup="this.value = this.value.substring(0, 2000)" class=Inputstyle></textarea>
						</TD>
					</TR>
                	<TR class="Spacing" style="height: 1px">
			    		<TD class="Line1" colSpan=2 ></TD>
			    	</TR>
			 	</TBODY>
			</TABLE>
			<input type="hidden" name=operation value=reportadd>
 </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

 </form>
 
<SCRIPT LANGUAGE="javascript">


function submitData()
{
	var checkfields = "";
		checkfields = 'reportname,modeid,reportnumperpage';
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
        frmMain.submit();
    }
}

function doback(){
    enableAllmenu();
    location.href="/formmode/search/CustomSearch.jsp?modeid=<%=modeid%>&reportname=<%=reportname%>";
}

function onShowModeSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>");
		}
	} 
}
</SCRIPT>

</BODY></HTML>
