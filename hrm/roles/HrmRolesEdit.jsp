
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	int id=Util.getIntValue(request.getParameter("id"),0);
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	rs.execute("hrmroles_selectSingle",String.valueOf(id));
	rs.next();
	String rolesmark=rs.getString(1);
	String rolesname=rs.getString(2);
	String subcompanyid = Util.null2String(rs.getString(5));
	int docid=Util.getIntValue(rs.getString(3),0);
	int type=Util.getIntValue(rs.getString("type"),0);
	int flag=Util.getIntValue(request.getParameter("flag"),0);
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	//int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
	int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
	session.setAttribute("role_type",String.valueOf(type));
	
	String sql = "select count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid where 1 = 1 ";
	if(detachable==1&&!"".equals(subcompanyid)){
		sql += " and t1.subcompanyid="+subcompanyid;
	}else{
		sql += " and t1.type=0 ";
	}
	sql += " and t1.id = "+id+" group by t1.id,t1.rolesmark,t1.rolesname,t1.type,t2.roleid ";
	rs.executeSql(sql);
	rs.next();
	int cnt = rs.getInt("cnt");
	
	rs.executeSql("select isdefault from hrmroles where id = "+id);
	rs.next();
	int isdefault = rs.getInt("isdefault");
	

	String structureid ="";
	if(request.getParameter("subCompanyId")==null){
		structureid=String.valueOf(session.getAttribute("role_subCompanyId"));
	}else{
		structureid=Util.null2String(request.getParameter("subCompanyId"));
	}

	if(!"".equals(subcompanyid)){
	   structureid = subcompanyid;
	}

	int operatelevel=0;
	if(detachable==1){
		operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesEdit:Edit",Integer.parseInt(structureid));
	}else{
		if(HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user))
			operatelevel=2;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();	
				if(dialog)
					dialog.close();
			}
			function doSave(){
				if(check_form(document.frmMain,'idname,structureid')){
					document.frmMain.operationType.value = "Edit";
					document.frmMain.submit();
				}
			}
			
			function doDel(){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
					document.frmMain.operationType.value = "Delete";
					document.frmMain.cmd.value = "closeDialog";
					document.frmMain.submit();
				});
			}
		</script>
	</head>
	<BODY>
	
	<% if(flag==12) {%>
<script type="text/javascript">
	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34285,user.getLanguage())%>");
</script>
	
<%}%>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(operatelevel > 0){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(cnt <= 0&&isdefault!=1){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(operatelevel > 0){ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%} %>
					<%if(cnt <= 0 && operatelevel> 0 &&isdefault!=1 ){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="HrmRolesOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<%if(operatelevel > 0){ %>
				  		<wea:required id="namespan" required='<%=rolesmark.length()==0%>'>
				  			<input class=inputstyle type=text size=50 name="idname" value='<%=rolesmark%>' onchange="checkinput('idname','namespan')">
						</wea:required>
						<%}else{ %>
						<%=rolesmark%>
						<%} %>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<%if(operatelevel > 0){ %>
				  		<wea:required id="descriptionspan" required="false">
				  			<input class=inputstyle type=text size=60 name="description" value='<%=rolesname%>' onchange="checkinput('description','descriptionspan')">
						</wea:required>
						<%}else{ %>
						<%=rolesname%>
						<%} %>
					</wea:item>
					<%if(detachable==1){%>
					<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<%=type==0?SystemEnv.getHtmlLabelName(17866,user.getLanguage()):SystemEnv.getHtmlLabelName(17867,user.getLanguage())%>
							&nbsp;
							<img src="/wechat/images/remind_wev8.png" align="absMiddle" id="crmImg" title='<%=SystemEnv.getHtmlLabelName(23265,user.getLanguage())+"\r\n"+SystemEnv.getHtmlLabelName(23266,user.getLanguage())%>' />
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
				  			<%if(operatelevel > 0){ %>
							<brow:browser viewType="0" name="structureid" browserValue='<%=structureid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmRolesAdd:Add&isedit=1&selectedids="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(structureid),user.getLanguage())%>'>
							</brow:browser>
							<%}else{ %>
							<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(structureid),user.getLanguage())%>
							<%} %>
						</span>
					</wea:item>
					<%}%>
					<wea:item><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
				  			<%if(operatelevel > 0){ %>
							<brow:browser viewType="0" name="docid" browserValue='<%=String.valueOf(docid)%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=9" width="60%" browserSpanValue='<%=DocComInfo.getDocname(""+docid)%>'>
							</brow:browser>
							<%}else{ %>
							<%=DocComInfo.getDocname(""+docid)%>
							<%} %>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input class="inputstyle" type="hidden" name="cmd">
			<input class="inputstyle" type="hidden" name="operationType">
			<input class="inputstyle" type="hidden" name="id" value="<%=id%>">
			<input class="inputstyle" type="hidden" name="roletype" value="<%=type%>"> 
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
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