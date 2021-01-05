<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.docs.category.security.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<HTML>
	<HEAD>
		<%
		
		//编辑权限验证
		if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		    response.sendRedirect("/notice/noright.jsp");
		    return;
		}
		
		    String titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(67, user.getLanguage());
		    String isclose = Util.null2String(request.getParameter("isclose"));
		    String isDialog = Util.null2String(request.getParameter("isdialog"));
		    String from = Util.null2String(request.getParameter("from"));
		    String oriSecId = Util.null2String(request.getParameter("oriSecId"));
		    String OriSubId = Util.null2String(request.getParameter("OriSubId"));
		   
		    
		    
		%>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/weaver_wev8.js"></script>
		<script language=javascript>
var parentWin = parent.getParentWindow(window);
var dialog = parent.getDialog(window);
if("<%=isclose%>"=="1"){
	parentWin.location.href="/rdeploy/doc/index.jsp";
	dialog.close();
}
</script>
	</head>
	<%
	    int id = -1;
	    int parentid = Util.getIntValue(request.getParameter("id"), 0);
	    int messageid = Util.getIntValue(request.getParameter("message"), 0);
	    int errorcode = Util.getIntValue(request.getParameter("errorcode"), 0);
	    boolean canEdit = false;
	    if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user)) {
	        canEdit = true;
	    }
	%>
	<BODY>

		<%
		    if (messageid != 0) {
		%>
		<script type="text/javascript">
	top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(messageid, user.getLanguage())%>");
</script>
		<%
		    }
		%>
		<%
		    if (errorcode == 10) {
		%>
		<script type="text/javascript">
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21999, user.getLanguage())%>");
	</script>
		<%
		    }
		%>
		<%
		    if (errorcode == 11) {
		%>
		<script type="text/javascript">
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31877, user.getLanguage())%>");
	</script>
		<%
		    }
		%>

		<FORM id=weaver name=weaver action="SecCategoryOperation.jsp"
			method=post>
			<input type=hidden name="operation">
			<input type=hidden name="id" value="<%=id%>">
			<input type=hidden name="secId" value="<%=parentid%>">
			<input type=hidden name="oriSecId" value="<%=oriSecId%>">
			<input type=hidden name="OriSubId" value="<%=OriSubId%>">
			<input type=hidden name="fromtab" value="0">
			<input type=hidden name="tab" value="0">
			<input type="hidden" name="isdialog" value="<%=isDialog%>">
			<input type="hidden" name="from" id="from" value="<%=from%>">
			<input type=hidden name="PDocCreater" value="3">
			<input type=hidden name="PCreaterManager" value="1">
			<input type=hidden name="PDocCreaterW" value="3">
			<input type=hidden name="PCreaterManagerW" value="1">
			<input type=hidden name="maxUploadFileSize" value="10">

			<div class="zDialog_div_content"
				style="position: absolute; bottom: 48px; top: 0px; width: 100%;">
				<table width="100%" height="100%" cellpadding="0px"
					cellspacing="0px" border="0px">
					<tr>
						<td style="text-align: right; width: 20%;">
							<span style="color: #546266;"><%=SystemEnv.getHtmlLabelName(24764, user.getLanguage())%></span><span
								style="display: inline-block; width: 12px;"></span>
						</td>
						<td valign="middle" align="left" style="width: 80%;">
							<span style="font-size: 12px;">
							 <wea:required
									id="categorynamespan" required="false" value="">
									<%
									    if (canEdit) {
									%>
									<INPUT
										temptitle="<%=SystemEnv.getHtmlLabelName(24764, user.getLanguage())%>"
										style="height: 35px; width: 265px; border: 1px solid #d6dae0;"
										class=InputStyle maxLength=100 size=60 name=categoryname
										value=""
										onChange="checkinput('categoryname','categorynamespan')">
									<%
									    } 
									%>
									<INPUT type=hidden maxLength=100 size=60 name=srccategoryname
										value="">
								</wea:required> </span>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<script language="javascript">
			function onSave(){
				try{
					parent.disableTabBtn();
				}catch(e){}
				
				if(check_form(document.weaver,'categoryname')){
					document.weaver.operation.value="add";
					document.weaver.submit();
				}else{
					try{
						parent.enableTabBtn();
					}catch(e){}
				}
			}
</script>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="onSave()">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(32694, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="dialog.close()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>

	</BODY>
</HTML>