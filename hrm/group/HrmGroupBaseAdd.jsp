
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	boolean cansave = HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
	
	String cmd = Util.null2String(request.getParameter("cmd"));
	String isAdd = Util.null2String(request.getParameter("isAdd"));
	String istree = Util.null2String(request.getParameter("istree"));
	boolean isShow = cmd.equals("show");
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	int groupid = Util.getIntValue(request.getParameter("groupid"),-1);
	int ownerid = user.getUID();
	String name = Util.null2String(request.getParameter("name"));
	String type = Util.null2String(request.getParameter("type"));
	String sn = Util.null2String(request.getParameter("sn"));
	String hrmids = Util.null2String(request.getParameter("hrmids"));
	String hrmnames = Util.null2String(request.getParameter("hrmnames"));
	String isDetail = Util.null2String(request.getParameter("isDetail"));
	int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(81554,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	if(groupid!=-1){
		RecordSet rs=GroupAction.getGroup(groupid);
		rs.next();
		ownerid = rs.getInt("owner");
		name =Util.toHtmlForSplitPage(rs.getString("name"));
		type =rs.getString("type");
		sn = rs.getString("sn");
		
		if(user.getUID() != 1 && type.equals("0") && ownerid != user.getUID()) {
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		
		rs=GroupAction.getMembers(groupid);
		StringBuffer memberids=new StringBuffer();
		StringBuffer membernames=new StringBuffer();
		while(rs.next()){
			String userid=rs.getString("userid");
			String username=ResourceComInfo.getResourcename(userid);
			memberids.append(userid);
			memberids.append(",");
			membernames.append("<A href='/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+userid+"' target='_blank'>");
			membernames.append(username);
			membernames.append("</A>,");
		}
		hrmids=memberids.toString();
		if(!hrmids.equals(""))
			hrmids=hrmids.substring(0,hrmids.length()-1);
		hrmnames=membernames.toString();
		if(!hrmnames.equals(""))
			hrmnames=hrmnames.substring(0,hrmnames.length()-1);
	}
	
	if(sn.length() == 0){
		sn = "0.00";
	}
	
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
            if("<%= msgid %>" != "-1" ) {
                window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>');
            }

			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			
			if("<%=isDetail%>"=="1"){
				if("<%=istree%>"=="1"){
					if("<%=isclose%>"=="1"){
						try {
							if("<%=isDialog%>"=="1"){
								if("<%=isAdd%>"=="1"){
									var newNode= {id:"<%=groupid%>",name:"<%=name%>",parentid:"group_<%=type.equals("1")?"-2":"-3"%>",nodeid:"group_<%=groupid%>",type:"group",icon:"/images/treeimages/subCopany_Colse_wev8.gif"};
									parentWin.addNode(newNode);
								}else{
									parentWin.updateNode("<%=name%>");
								}
							}
						} catch (e) {parentDialog.close();}
						parentWin.closeDialog();	
					}else if("<%=isclose%>"=="2"){	
						parentWin.closeDialog();
						parentWin.doEdit("<%=groupid%>");
					}
					parentWin.doDetail("<%=groupid%>");
				}else{
					parentWin.closeDialog();
					parentWin.location.reload();
					parentWin.doDetail("<%=groupid%>");
				}
			}else{
				if("<%=isclose%>"=="1"){
					try {
						if("<%=isDialog%>"=="1"){
							if("<%=isAdd%>"=="1"){
								var newNode= {id:"<%=groupid%>",name:"<%=name%>",parentid:"group_<%=type.equals("1")?"-2":"-3"%>",nodeid:"group_<%=groupid%>",type:"group",icon:"/images/treeimages/subCopany_Colse_wev8.gif"};
								parentWin.addNode(newNode);
							}else{
								parentWin.updateNode("<%=name%>");
							}
						}
						parentDialog.close();
					} catch (e) {parentDialog.close();}
					parentWin.closeDialog();	
				}else if("<%=isclose%>"=="2"){	
					parentWin.closeDialog();
					parentWin.doEdit("<%=groupid%>");
				}
			}
		 	function doSave(op){
		    	if(check_form(document.frmMain,'name')){
		    		if(op === 1){
		    			jQuery("#savetype").val("1");
		    		}
				   	document.frmMain.submit();
		  		}
		 	}
			var dialog = null;
			var dWidth = 600;
			var dHeight = 400;
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/group/HrmGroup.jsp";
			}
			
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			function doShare(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=GroupShare&isdialog=1&creatorid=<%=ownerid%>&id=<%=groupid%>&name=<%=name%>","<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())+SystemEnv.getHtmlLabelName(17748,user.getLanguage())%>");
			}
			
			if("<%=cmd%>" == "share" && "<%=type%>" == "1"){
				doShare();
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(!cmd.equals("show")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(0),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				if(groupid <= 0){ 
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:doSave(1),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				}
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(!cmd.equals("show")){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave(0);">
					<% if(groupid <= 0){ 
					 %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="doSave(1);">
					<%}%>
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="GroupOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(name);}else{%>
						<wea:required id="namespan" required='<%=name.length()==0%>'>
							<INPUT class=inputstyle type=text size=30 name="name" value="<%=name%>" onchange='checkinput("name","namespan")'>
						</wea:required>
						<%}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(new SplitPageTagFormat().colFormat(type,"{cmd:array["+String.valueOf(user.getLanguage())+";0=17618,1=17619]}"));}else{%>
						<%if(groupid>0&&type.equals("1")){ 
								out.println(SystemEnv.getHtmlLabelName(17619,user.getLanguage()));
							%>
							<INPUT name="type" type="hidden" name="type" value="<%=type%>">
						<%}else{ %>
						<wea:required id="namespan" required="false">
							<select name="type" >
								<option value=0 <%if(type.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17618,user.getLanguage())%></option>
								<%if(cansave){%><option value=1 <%if(type.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17619,user.getLanguage())%></option><%}%>
							</select>
						</wea:required>
						<%}}%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(isShow){out.println(sn);}else{%>
						<wea:required id="namespan" required="false">
							<input class=inputstyle maxlength=10  size=10 name="sn" id="sn" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("sn")' value="<%=sn%>" >
						</wea:required>
						<%}%>
					</wea:item>
				</wea:group>
			</wea:layout>	
			<input class=inputstyle type="hidden" name=istree value="<%=istree%>">	
			<input class=inputstyle type="hidden" name=isdialog value="<%=isDialog%>">	
			<input class=inputstyle type="hidden" name=groupid value="<%=groupid%>">
			<input class=inputstyle type="hidden" name=ownerid value="<%=ownerid%>">
			<input class=inputstyle type="hidden" name=savetype id=savetype >
			<input class=inputstyle type="hidden" name=operation value=addgroupbase>
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
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
