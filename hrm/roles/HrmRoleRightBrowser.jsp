
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(385,user.getLanguage());
	String needfav ="1";
	String needhelp ="1";

	String rightname = Util.null2String(request.getParameter("rightname"));
	String rightdesc = Util.null2String(request.getParameter("rightdesc"));
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	
	if(!rightname.equals("")){
		sqlwhere += " and b.rightname like '%" + Util.fromScreen2(rightname,user.getLanguage()) +"%' ";
	}
	if(!rightdesc.equals("")){
		sqlwhere += " and b.rightdesc like '%" + Util.fromScreen2(rightdesc,user.getLanguage()) +"%' ";
	}

	String sqlstr ="";
	String sqlstr2 ="";
	String languageid = ""+user.getLanguage();

	//不分权：返回所有功能
	sqlstr =" select distinct b.id,rightname,d.id as groupid,d.rightgroupname "+
			" from SystemRights a, SystemRightsLanguage b, systemrighttogroup c, SystemRightGroups d" +
			" where a.id = b.id and languageid= "+languageid + sqlwhere+
			" and a.id=c.rightid and c.groupid=d.id order by d.id";
	//没有归组的权限
	sqlstr2=" select distinct(a.id),b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
			" from SystemRights a, SystemRightsLanguage b "+
			" where a.id = b.id and languageid= "+languageid + sqlwhere+
			" and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
			" order by a.id";
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
			try{
				parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("81897",user.getLanguage())%>");
			}catch(e){
				if(window.console)console.log(e+"-->HrmRoleRightBrowser.jsp");
			}
		  var parentWin = null;
		  var dialog = null;
		  try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		  }catch(e){}

			function checkMain(id) {
				var len = $GetEle("SearchForm").elements.length;
				var mainchecked=$GetEle("t"+id).checked;
				var i=0;
				for( i=0; i<len; i++) {
					var obj = $GetEle("SearchForm").elements[i];
					if (obj.id=='w'+id) {
						changeCheckboxStatus(obj,mainchecked);
					} 
				} 
			}

			function checkSub(id) {
				var len = $GetEle("SearchForm").elements.length;
				var i=0;
				for( i=0; i<len; i++) {
					var obj = $GetEle("SearchForm").elements[i];
					if (obj.id=='w'+id && obj.checked) {
						changeCheckboxStatus($GetEle("t"+id),true);
						return;
					} 
				}
				changeCheckboxStatus($GetEle("t"+id),false);
			}
			
			function onSave(){
				var chkObj = $("input:checked[name^='chk_']");
				var ids = "";
				var names = "";
				chkObj.each(function(){
					var trObj = jQuery(this).parent().parent().parent();
					if(ids!="")ids+=",";
					ids += jQuery(trObj).find("input[name^='rightid_']").val();
					if(names!="")names+=",";
					names += jQuery(trObj).find("input[name^='rightname_']").val();
				});
		   var returnjson = {id:ids,name:names};
		   if(dialog){
		   	try{
		      dialog.callback(returnjson);
		     }catch(e){}
		
			try{
				dialog.close(returnjson);
			}catch(e){}
		   }else{
		    window.parent.parent.returnValue  = returnjson;
		   	window.parent.close();
		   }
		}

			function submitClear()
			{
				var returnjson = {id:"",name:""};
				if(dialog){
					dialog.callback(returnjson);
				}else{
					window.parent.returnValue = returnjson;
			  	window.parent.close();
				}
			}
			  
			function btncancel_onclick(){
				if(dialog){
					dialog.closeByHand();
				}else{
			  	window.parent.close();
				}
			}
		</script>
	</head>
	<BODY>
	<div class="zDialog_div_content" style="width:100%;height:100%">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="HrmRoleRightBrowser.jsp" method="post">
	<DIV align=right style="display:none">
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>	
	<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	</DIV>

	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
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
											rightname=(String)rightnames.get(j);
									%>
											<tr class="field">
												<td width="20%"></td>
												<td>
													<input type="checkbox" name='chk_<%=k%>' id="w<%=groupid%>" value="1" onclick="checkSub('<%=groupid%>')">
													<%=rightname%>
												</td>
												<input class=inputstyle type=hidden id='rightid_<%=k%>' name='rightid_<%=k%>' value=<%=rightid%> >
												<input class=inputstyle type=hidden id='rightname_<%=k%>' name='rightname_<%=k%>' value=<%=rightname%> >
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
					</wea:item>
				</wea:group>
			</wea:layout>
		</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="button" accessKey=O  id=btnok onclick="onSave()" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"  class="zd_btn_cancle">
					<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="zd_btn_cancle" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
	</body>
</html>
