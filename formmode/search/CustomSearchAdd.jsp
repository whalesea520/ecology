<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
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
//自定义查询:新建
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+ ":" +SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";
String customname = Util.null2String(request.getParameter("customname"));
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
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;//返回
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain action="/formmode/search/CustomSearchOperation.jsp" method=post >

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
		        			<INPUT type=text class=Inputstyle size=30 name="Customname" onchange='checkinput("Customname","Customnameimage")' maxlength="50" value="">
		          			<SPAN id=Customnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
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
						<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD><!-- 描述 -->
						<TD class=Field>
							<textarea rows="4" style="width:80%" name="Customdesc" class=Inputstyle onkeyup="this.value = this.value.substring(0, 200)"></textarea>
						</TD>
					</TR>
                	<TR class="Spacing" style="height: 1px">
			    		<TD class="Line1" colSpan=2 ></TD>
			    	</TR>
			 	</TBODY>
			</TABLE>
			<input type="hidden" name=operation value=customadd>
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
		checkfields = 'Customname,modeid';
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
        frmMain.submit();
    }
}

function doback(){
    enableAllmenu();
    location.href="/formmode/search/CustomSearch.jsp?modeid=<%=modeid%>&customname=<%=customname%>";
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
