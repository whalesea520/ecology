<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<style>
	html{height:auto;}
		table.ListStyle tbody tr.Header{
			background-color: #e5e5e5;
		}
		table.ListStyle tr{
			height: 25px;
		}
		table.ListStyle th{
			height: 25px;
		}
		table.ListStyle tbody tr th{
			padding: 0 0 0 0px;
			font-weight: normal;
		}
		table.ListStyle tbody tr td{
			padding: 0 0 0 0px;
		}
		.e8_tblForm_title{
			font-weight:bold;
			margin: 10px 0 5px 0;
			/*
			padding: 0 0 0 20px;
			background-image: url(/wui/theme/ecology8/templates/default/images/groupHead_wev8.png);
			background-repeat: no-repeat;
			background-position: 0 50%;
			*/
		}

	</style>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(27244,user.getLanguage());//批量操作设置
	String needfav ="1";
	String needhelp ="";
	
	String modeid="";
	String modename = "";
	String sql = "";
	String formID = "";	
	String isBill = "1";
    String Customname = "";
    String Customdesc = "";
	
	String id = Util.null2String(request.getParameter("id"));
	
	String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customsearch a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	String userRightStr = "FORMMODEAPP:ALL";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
	
	sql = "select a.modeid,a.customname,a.customdesc,b.modename,b.formid,a.defaultsql,a.disQuickSearch from mode_customsearch a,modeinfo b where a.modeid = b.id and a.id="+id;
	rs.executeSql(sql);
	boolean isVirtualForm = false;
	if(rs.next()){
		formID = Util.null2String(rs.getString("formid"));	
		isBill = "1";
		isVirtualForm = VirtualFormHandler.isVirtualForm(formID);
	    Customname = Util.toScreen(rs.getString("Customname"),user.getLanguage()) ;
		modeid = Util.null2String(rs.getString("modeid"));
		modename = Util.null2String(rs.getString("modename"));
	    Customdesc = Util.toScreenToEdit(rs.getString("Customdesc"),user.getLanguage());
	}
	int modeidInt = Util.getIntValue(modeid, 0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0 && modeidInt > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
	RCMenuHeight += RCMenuHeightStep ;
}


//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmMain name=frmMain action="/formmode/batchoperate/ModeBatchSetOperation.jsp" method=post>
<input type="hidden" id="id" name="id" class="inputstyle" value="<%=id%>">
<input type="hidden" id="operation" name="operation" class="inputstyle" value="edit">
<%
if(modeidInt <= 0){
	String emptyMsg = SystemEnv.getHtmlLabelName(129746,user.getLanguage());
	out.print("<div style='color:red;font-weight:bold;margin-top:4px;'>"+emptyMsg+"</div>");
	return;
}
%>

<div class="e8_tblForm_title"><%=SystemEnv.getHtmlLabelName(27244,user.getLanguage()) %></div><!-- 批量操作设置 -->
		
	  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="15%">
  		<COL width="15%">
  		<COL width="15%">
		<COL width="15%">
		<COL width="15%">
		<COL width="15%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(81454,user.getLanguage())%></th><!-- 操作名称 -->
	      <th><%=SystemEnv.getHtmlLabelName(17987,user.getLanguage())%></th><!-- 用途描述 -->
	      <th><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></th><!-- 操作类型 -->
	      <th><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%></th><!-- 显示名称 -->
	      <th><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></th><!-- 是否启用 -->
	      <th><%=SystemEnv.getHtmlLabelName(125138,user.getLanguage())%></th><!-- 快捷按钮 -->
	      <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th><!-- 显示顺序 -->
	    </TR>
		
		<%
			int nLogCount=0;
			boolean isbatchsetnew = true;
	    	recordSet.executeSql("select 1 from mode_batchset where customsearchid="+id);
	    	if(recordSet.next()){
	    		isbatchsetnew = false;
	    	}
		    String isVirtualFormFilterSql = "";
		    if(isVirtualForm){
		    	isVirtualFormFilterSql = " and (a.issystemflag not in(103,104) or a.issystemflag is null) ";
		    }
			if(rs.getDBType().equals("oracle")){
				sql = "select a.id,a.expendname,a.expenddesc,b.isuse,nvl(b.showorder,a.showorder) showorder,a.issystem,b.listbatchname,a.defaultenable,b.isshortcutbutton,a.issystemflag from mode_pageexpand a left join mode_batchset b on a.id = b.expandid and b.customsearchid = "+id+" where a.isbatch in(1,2) "+isVirtualFormFilterSql+" and a.modeid = " + modeidInt + " order by issystem desc,nvl(b.isuse,defaultenable) desc,showorder asc,a.id asc";
			}else{
				sql = "select a.id,a.expendname,a.expenddesc,b.isuse,isnull(b.showorder,a.showorder) showorder,a.issystem,b.listbatchname,a.defaultenable,b.isshortcutbutton,a.issystemflag from mode_pageexpand a left join mode_batchset b on a.id = b.expandid and b.customsearchid = "+id+" where a.isbatch in(1,2) "+isVirtualFormFilterSql+" and a.modeid = " + modeidInt + " order by issystem desc,isnull(b.isuse,defaultenable) desc,showorder asc,a.id asc";	
			}
			rs.executeSql(sql);
			boolean isLight = false;
			while(rs.next()) {
				String expendname = Util.null2String(rs.getString("expendname"));
				String defaultenable = Util.null2String(rs.getString("defaultenable"));
				String expenddesc = Util.null2String(rs.getString("expenddesc"));
				String listbatchname = Util.null2String(rs.getString("listbatchname"));
				String isuse = Util.null2String(rs.getString("isuse"));
				String isshortcutbutton = Util.null2String(rs.getString("isshortcutbutton"));
				double showorder = Util.getDoubleValue(rs.getString("showorder"),0);
				int issystem = Util.getIntValue(rs.getString("issystem"),0);
				int expendid = Util.getIntValue(rs.getString("id"),0);
				int issystemflag = Util.getIntValue(rs.getString("issystemflag"),0);
				String operatename = "";
				if(issystem==0){
					operatename = SystemEnv.getHtmlLabelName(73,user.getLanguage());//用户自定义
				}else{
					operatename = SystemEnv.getHtmlLabelName(28119,user.getLanguage());//系统默认
					if(isuse.equals("")){
						isuse = defaultenable;
					}
				}
				
				if(listbatchname.equals("")){
					listbatchname = expendname;
				}
				
				if(isLight) {
		%>	
					<TR CLASS=DataLight>
		<%		
				}else{
		%>
					<TR CLASS=DataDark>
		<%		
				}
		%>
						<TD>
							<%=expendname%>
							<input type="hidden" id="expandid_<%=nLogCount%>" name="expandid_<%=nLogCount%>" class="inputstyle" value="<%=expendid%>">
						</TD>
						<TD><%=rs.getString("expenddesc")%></TD>
						<TD><%=operatename%></TD>
						<TD><input type="text" id="listbatchname_<%=nLogCount%>" name="listbatchname_<%=nLogCount%>" class="inputstyle" value="<%=listbatchname%>"></TD>
						<TD>
							<input type="checkbox" id="isuse_<%=nLogCount%>" name="isuse_<%=nLogCount%>" class="inputstyle" value="1" onclick="selectShortcutButtonByIsuse('<%=nLogCount %>');" <%if(isuse.equals("1"))out.println("checked"); %>>
						</TD>
						<TD>
							<input type="checkbox" id="isshortcutbutton_<%=nLogCount%>" name="isshortcutbutton_<%=nLogCount%>" class="inputstyle shortcutbutton" value="1" onclick="selectShortcutButton('<%=nLogCount %>');" <%if(isshortcutbutton.equals("1"))out.println("checked");else if(isbatchsetnew && issystemflag==101)out.println("checked");else if(isshortcutbutton.equals("") && issystemflag==101)out.println("checked"); %>>
						</TD>
						<TD><input type="text" id="showorder_<%=nLogCount%>" name="showorder_<%=nLogCount%>" class="inputstyle" value="<%=showorder%>" onkeypress="ItemDecimal_KeyPress('showorder_<%=nLogCount%>',6,2)" onblur="checknumber1(this);"></TD>
			        </TR>
			<%
				isLight = !isLight;
				nLogCount++;
			}
		%>
	  </TBODY>
	  </TABLE>
	  <input type="hidden" id="nLogCount" name="nLogCount" value="<%=nLogCount%>">

</FORM>

<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})

    function doSubmit(){
        enableAllmenu();
        document.frmMain.submit();
    }
    function doBack(){
		enableAllmenu();
        location.href="/formmode/search/CustomSearchEdit.jsp?id=<%=id%>";
    }
    
    function selectShortcutButton(index){
    	var num = 0;
    	$(".shortcutbutton").each(function(){
    		if($(this).attr("checked")){
    			num++;
    		}
    	});
    	if (num < 6) {
    		changeCheckboxStatus($("#isuse_"+index), true);
    	} else {
    		changeCheckboxStatus($("#isshortcutbutton_"+index), false);
    		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128215,user.getLanguage())%>");
    	}
    	
    }
    
    function selectShortcutButtonByIsuse(index){
    	if($("#isuse_"+index).attr("checked")!="checked"){
    		changeCheckboxStatus($("#isshortcutbutton_"+index), false);
    	}
    }
</script>

</BODY>
</HTML>
