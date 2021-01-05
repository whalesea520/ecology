
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(385,user.getLanguage());
	String needfav ="1";
	String needhelp ="1";

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String roleId = Util.null2String(request.getParameter("id")) ;
	
	String sqlstr ="";
	String sqlstr2 ="";
	String languageid = ""+user.getLanguage();
	int type =Util.getIntValue(String.valueOf(session.getAttribute("role_type")));
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);

	if(hrmdetachable==0){
		//不分权：返回所有功能
		sqlstr =" select distinct b.id,rightname,d.id as groupid,d.rightgroupname "+
				" from SystemRights a, SystemRightsLanguage b, systemrighttogroup c, SystemRightGroups d" +
				" where a.id = b.id and languageid= "+languageid +
				" and a.id=c.rightid and c.groupid=d.id order by d.id";
		//没有归组的权限
		sqlstr2=" select distinct(a.id),b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
				" from SystemRights a, SystemRightsLanguage b "+
				" where a.id = b.id and languageid= "+languageid +
				" and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
				" order by a.id";
	}else{
		if(user.getUID()==1){
			if(type==0){
				//sysadmin、赋权角色：返回所有功能
				sqlstr =" select distinct b.id,rightname,d.id as groupid,d.rightgroupname "+
						" from SystemRights a, SystemRightsLanguage b, systemrighttogroup c, SystemRightGroups d" +
						" where a.id = b.id and languageid= "+languageid +
						" and a.id=c.rightid and c.groupid=d.id order by d.id";
				//没有归组的权限
				sqlstr2=" select distinct(a.id),b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
						" from SystemRights a, SystemRightsLanguage b "+
						" where a.id = b.id and languageid= "+languageid +
						" and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
						" order by a.id";
			}else{
				//sysadmin、分权角色：返回所有可分权功能
				sqlstr =" select distinct b.id,rightname,d.id as groupid,d.rightgroupname "+
						" from SystemRights a , SystemRightsLanguage b, systemrighttogroup c, SystemRightGroups d" +
						" where a.id = b.id and languageid= "+languageid +
						" and a.id=c.rightid and c.groupid=d.id "+
						" and a.detachable=1 order by d.id";
				//没有归组的权限
				sqlstr2=" select distinct(a.id),b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
						" from SystemRights a, SystemRightsLanguage b "+
						" where a.id = b.id and languageid= "+languageid +
						" and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
						" and a.detachable=1 order by a.id";
			}
		}else{
			if(type==0){
				//非sysadmin、赋权角色：返回所有上级赋予的功能
				sqlstr =" select distinct b.id,rightname,f.id as groupid,f.rightgroupname "+
						" from SystemRights a, SystemRightsLanguage b, systemrighttogroup e, SystemRightGroups f" +
						" where a.id = b.id and languageid= "+languageid +
						" and a.id=e.rightid and e.groupid=f.id "+
						" and a.id in(select distinct(c.rightid) from SystemRightRoles c, HrmRoleMembers d where c.roleid=d.roleid and d.resourceid="+user.getUID()+") order by f.id";
				//没有归组的权限
				sqlstr2=" select distinct a.id,b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
						" from SystemRights a, SystemRightsLanguage b "+
						" where a.id = b.id and languageid= "+languageid + 
						" and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
						" and a.id in(select distinct(c.rightid) from SystemRightRoles c, HrmRoleMembers d where c.roleid=d.roleid and d.resourceid="+user.getUID()+") "+
						" order by a.id";
			}else{
				//非sysadmin、分权角色：返回所有上级赋予的分权功能
				sqlstr =" select distinct b.id,rightname,f.id as groupid,f.rightgroupname "+
						" from SystemRights a , SystemRightsLanguage b, systemrighttogroup e, SystemRightGroups f" +
						" where a.id = b.id and languageid= "+languageid +" and a.detachable=1 " +
						" and a.id=e.rightid and e.groupid=f.id "+
						" and a.id in(select distinct(c.rightid) from SystemRightRoles c, HrmRoleMembers d where c.roleid=d.roleid and d.resourceid="+user.getUID()+") order by f.id";
				//没有归组的权限
				sqlstr2=" select distinct a.id,b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
						" from SystemRights a, SystemRightsLanguage b "+
						" where a.id = b.id and languageid= "+languageid + 
						" and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
						" and a.id in(select distinct(c.rightid) from SystemRightRoles c, HrmRoleMembers d where c.roleid=d.roleid and d.resourceid="+user.getUID()+") "+
						" and a.detachable=1 order by a.id";
			}
		}
	}

	rs.executeSql(sqlstr);
	String rightid_tmp = "";
	String rightname_tmp = "";
	String rightgroup_tmp = "";
	String groupid_tmp = "";
	String groupname_tmp = "";
	ArrayList rightids=new ArrayList();
	ArrayList rightnames=new ArrayList();
	ArrayList rightgroups=new ArrayList();
	ArrayList groupids=new ArrayList();
	ArrayList groupnames=new ArrayList();
	while(rs.next()){
		rightid_tmp = rs.getString("id");
		rightname_tmp = rs.getString("rightname");
		rightgroup_tmp =rs.getString("groupid");
		rightids.add(rightid_tmp);
		rightnames.add(rightname_tmp);
		rightgroups.add(rightgroup_tmp);
		if(!groupid_tmp.equals(rs.getString("groupid"))){
			groupid_tmp = rs.getString("groupid");
			groupname_tmp = rs.getString("rightgroupname");
			groupids.add(groupid_tmp);
			groupnames.add(groupname_tmp);
		}
	}

	rs.executeSql(sqlstr2);
	while(rs.next()){
		rightid_tmp = rs.getString("id");
		rightname_tmp = rs.getString("rightname");
		rightgroup_tmp =rs.getString("groupid");
		rightids.add(rightid_tmp);
		rightnames.add(rightname_tmp);
		rightgroups.add(rightgroup_tmp);
		if(!groupid_tmp.equals(rs.getString("groupid"))){
			groupid_tmp = rs.getString("groupid");
			groupname_tmp = rs.getString("rightgroupname");
			groupids.add(groupid_tmp);
			groupnames.add(groupname_tmp);
		}
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
				parentWin.id = "<%=roleId%>";
				parentWin.closeDialog();	
			}
			function doSave(){
				if (check_form($GetEle("frmMain"),"rightId")){
					$GetEle("frmMain").operationType.value = "addRoleRight";
					$GetEle("frmMain").submit();
				}
			}

			function checkMain(id) {
				var len = $GetEle("frmMain").elements.length;
				var mainchecked=$GetEle("t"+id).checked;
				var i=0;
				for( i=0; i<len; i++) {
					var obj = $GetEle("frmMain").elements[i];
					if (obj.id=='w'+id) {
						changeCheckboxStatus(obj,mainchecked);
					} 
				} 
			}

			function checkSub(id) {
				var len = $GetEle("frmMain").elements.length;
				var i=0;
				for( i=0; i<len; i++) {
					var obj = $GetEle("frmMain").elements[i];
					if (obj.id=='w'+id && obj.checked) {
						changeCheckboxStatus($GetEle("t"+id),true);
						return;
					} 
				}
				changeCheckboxStatus($GetEle("t"+id),false);
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver id="frmMain" name="frmMain" action="HrmRoleRightOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span><%=RolesComInfo.getRolesRemark(roleId)%></span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select name="roleLevel" id="roleLevel" class=inputstyle>
								<option VALUE="2" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
								<option VALUE="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
								<option VALUE="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							</select>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<wea:layout attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%>'>
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<TABLE class=ViewForm style="width:100%">
						<%
							int typecate = groupids.size();
							int rownum = typecate/2;
							if((typecate-rownum*2)!=0)  rownum=rownum+1;
						%>
							<tr class=field>
								<td width="50%" align=left valign=top>
							<%
								int needtd=rownum;
								int k=0;
								for(int i=0;i<groupids.size();i++){
									String groupid = (String)groupids.get(i);
									String groupname=(String)groupnames.get(i);
									needtd--;
							%>
									<table class="viewform">
										<tr class=field>
											<td colspan=2 align=left>
												<input type="checkbox" id="t<%=groupid%>" value="<%=groupid%>" onclick="checkMain('<%=groupid%>')">
												<b><%=groupname%></b>
											</td>
										</tr>
									<%
										for(int j=0;j<rightgroups.size();j++){
											String rightgroup = (String)rightgroups.get(j);
											if(!groupid.equals(rightgroup)) 
												continue;
											String rightid=(String)rightids.get(j);
											String rightname=(String)rightnames.get(j);
									%>
											<tr class="field">
												<td width="20%"></td>
												<td>
													<input type="checkbox" name='chk_<%=k%>' id="w<%=groupid%>" value="1" onclick="checkSub('<%=groupid%>')">
													<%=rightname%>
												</td>
												<input class=inputstyle type=hidden name='rightid_<%=k%>' value=<%=rightid%> >
												<input class=inputstyle type=hidden name='rightname_<%=k%>' value=<%=rightname%> >
											</tr>
									<%
											k++;
										}
									%>
									</table>
								<%
									if(needtd==0){
										needtd=typecate/2;
								%>
								</td>
								<td align=left valign=top />
							<%		
									}
								}
							%>		
							</tr>
						</TABLE>
						<input type=hidden name="rightcount" value="<%=new Integer(k)%>">
						<input type=hidden name="roleId" value="<%=roleId%>">
						<input type=hidden name=operationType>
					</wea:item>
				</wea:group>
			</wea:layout>
		</FORM>
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
	</body>
</html>

