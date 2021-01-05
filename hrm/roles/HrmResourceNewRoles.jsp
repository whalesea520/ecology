
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	if (!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
		function doDel(id){
			if(!id){
				id = _xtable_CheckedCheckboxId();
			}
			if(!id){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
				return;
			}
			if(id.match(/,$/)){
				id = id.substring(0,id.length-1);
			}
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
				var idArr = id.split(",");
				var ajaxNum = 0;
				for(var i=0;i<idArr.length;i++){
					ajaxNum++;
					jQuery.ajax({
						url:"HrmRolesMembersOperation.jsp?isdialog=1&operationType=Delete&id="+idArr[i],
						type:"post",
						async:true,
						complete:function(xhr,status){
							ajaxNum--;
							if(ajaxNum==0){
								_table.reLoad();
							}
						}
					});
				}
			});
		}
		</script>
	</head>
	<%
		String imagefilename = "/images/hdHRMCard_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(16527, user.getLanguage());
		String needfav = "1";
		String needhelp = "";

		String sqlwhere = "";
		int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
		int perpage=Util.getIntValue(request.getParameter("perpage"),0);
		rs.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
		if(rs.next()){
			perpage =Util.getIntValue(rs.getString(36),-1);
		}

		if(perpage<=1 )	perpage=10;
		
		String roleid = "";
		String rolename = "";
		String zhurolename = "";
		String resourceid = Util.null2String(request.getParameter("resourceid"));
		rs.executeSql("select id,rolesmark from hrmroles where id in (select roleid from hrmrolemembers where resourceid = "+ resourceid + ")");
		while (rs.next()) {
			roleid += rs.getString("id") + ",";
			rolename += rs.getString("rolesmark") + ",";
		}
		if (!"".equals(rolename))
			rolename = rolename.substring(0, rolename.length() - 1);
		if (!"".equals(roleid))
			roleid = roleid.substring(0, roleid.length() - 1);
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if (HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)) {
				RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(86, user.getLanguage())
				+ ",javascript:submitData(this),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(91, user.getLanguage())
					+ ",javascript:doDel(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if (HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)) { %>
				<input type=button class="e8_btn_top" onclick="submitData(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<%}%>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form method=post name=hrmrolesadd action="HrmRolesMembersOperation.jsp">
	<input type=hidden name=operationType>
	<input type=hidden name=employeeID value="<%=resourceid%>">
	<input type=hidden name=roleID>
	<input type=hidden name=rolelevel2>
	<input type=hidden name=topagetmp value="hrmsingle">
	<input type=hidden name=id>
	<input type=hidden name=idtmps>
	<input type=hidden name=roleIDtmps>
	<input type=hidden name=rolelevel2tmps>
	<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16527,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(24055, user.getLanguage())%></wea:item>
	<wea:item>
	 	<brow:browser viewType="0"  name="rolesid" browserValue="" width="150px"
    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp"
    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
    completeUrl="/data.jsp?type=65"
    browserSpanValue=""></brow:browser>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(139, user.getLanguage())%></wea:item>
	<wea:item>
		<SELECT class=inputstyle name=rolelevel style="width: 150px">
			<option value="0"><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></option>
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(140, user.getLanguage())%></option>
		</SELECT>
	</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(24055, user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
	<wea:item attributes="{'colspan':'full','isTableList':true}">
	<%
	String backfields = " id, roleid, rolelevel "; 
	String fromSql  = " from HrmRoleMembers ";
	String sqlWhere = " where roleid >0 and resourceid= "+resourceid;
	String orderby = " id " ;
	String tableString = "";
	
	//操作字符串
	String  operateString= "";
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom></popedom> ";
	 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" isalwaysshow='true' index=\"0\"/>";
	 	       operateString+="</operates>";	
	 
	tableString =" <table instanceid=\"rolesMembersTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
			" <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.hrm.roles.RolesComInfo.getRolesCheckbox\"  popedompara=\"column:id\" />"+
			"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
	    operateString+
	    "			<head>"+
	    "				<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(15068,user.getLanguage())+"\" column=\"roleid\" transmethod=\"weaver.hrm.roles.RolesComInfo.getRolesRemark\" orderkey=\"roleid\"/>"+
	    "				<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(139,user.getLanguage())+"\" column=\"rolelevel\" transmethod=\"weaver.hrm.roles.RolesComInfo.getRoleLevelName\" otherpara=\""+""+user.getLanguage()+"\" orderkey=\"rolelevel\"/>"+
	    "			</head>"+
	    " </table>";
	%>
	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
	</wea:item>
	</wea:group>
	</wea:layout>
</FORM>
		<script language=javascript>
			function submitData(obj) {
			     document.hrmrolesadd.operationType.value="newRoles";
			     hrmrolesadd.submit();
			     obj.disabled = true;		      
			}
			
			function onShowRole(spanname, inputname){
			   var hrm_id = "<%=user.getUID()%>";
			    tmpids = jQuery("input[name="+inputname+"]").val();
			    if(tmpids!="-1"){ 
			      url="/hrm/roles/MutiRolesBrowser.jsp?resourceids="+tmpids+"&hrm_id="+hrm_id;
			    }else{
			      url="/hrm/roles/MutiRolesBrowser.jsp?hrm_id="+hrm_id;
			    }
				var data;
			    try {
			        data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
			    } catch(e) {
			        //return;
			    }
			    if (data != null) {
			        if (data.id != "0" && data.name!="") {
				        var name = "";
				        var id = "";
				        if(data.name.length>1){
				        	name = data.name.substring(1);
				        	id = data.id.substring(1)
					    }
			            jQuery("#"+spanname).html(name);
			            jQuery("input[name="+inputname+"]").val(id);
					}else{
						 jQuery("#"+spanname).html("");
				         jQuery("input[name="+inputname+"]").val("");
					}
				}
			    
			}
		</script>
	</BODY>
</HTML>
