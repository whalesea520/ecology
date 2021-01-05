<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.email.domain.MailFolder"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<link href="/email/css/color_wev8.css" rel="stylesheet" type="text/css" />
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "" + SystemEnv.getHtmlLabelName(81343, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDelete(),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script>
var diag;
function doAdd(){
	getDialog("<%=SystemEnv.getHtmlLabelNames("82,18473",user.getLanguage()) %>","/email/new/FolderManageAdd.jsp");
}

function doEdit(id ,foldername){
	getDialog("<%=SystemEnv.getHtmlLabelNames("93,18473",user.getLanguage()) %>","/email/new/FolderManageAdd.jsp?id="+id+"&foldername="+encodeURI(encodeURI(foldername)));
}

var diag ;
function getDialog(title , url){
    diag = new window.top.Dialog();
    diag.currentWindow = window;
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =450;
	diag.Height =150;
	diag.Title = title;
	diag.URL = url;
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();
 }

function batchDelete(){
	var id = _xtable_CheckedCheckboxId();
   	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568, user.getLanguage()) %>!");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	doDel(id);
}

function doDel(id){	
	//这个地方做物理删除，并且还要刷新左边菜单-??
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31265, user.getLanguage()) %>?",function(){
		var para ={method:'del',folderids:id};
		$.post("/email/new/FolderManageOperation.jsp",para,function(){
			_table.reLoad();
			init();
		})
	});
}

function doClearFolder(id){
	//这个地方做逻辑删除-??
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31266, user.getLanguage()) %>?",function(){
		var para ={method:'clear',folderid:id};
		$.post("/email/new/FolderManageOperation.jsp",para,function(){
			_table.reLoad();
			if(id == "-1"){
				try{
					window.parent.parent.mailUnreadUpdate();
				}catch(e){
					try{
						//说明是老版的模式查看
						window.parent.parent.document.getElementById("LeftMenuFrame").contentWindow.document.getElementById("ifrm2").contentWindow.mailUnreadUpdate();	
					}catch(e){
						//左右树形结构查看
						window.parent.parent.document.getElementById("mailFrameLeft").contentWindow.mailUnreadUpdate();
					}	
				}
			}
		})	 	
	});
}

function closeDialogcreateLabel(){
	diag.close();
	_table.reLoad();
}

jQuery(function(){
	init();
});

function init(){
	jQuery.post("/email/new/FolderManageOperation.jsp",{"method":"getSize"},function(info){
		info = jQuery.trim(info);
		// alert(info);
		var arr = info.split(",");
		var totalSize = arr[0];
		var unreadsize = arr[1];
		var occupyspace = arr[2];
		var totalspace = arr[3];
		
		if(occupyspace < 0)occupyspace =0; 
		
		jQuery("#totalSize").html(totalSize);
		jQuery("#unreadsize").html(unreadsize);
		jQuery("#occupyspace").html(occupyspace);
		jQuery("#totalspace").html(totalspace);
		jQuery("#canusespace").html(totalspace-occupyspace);
		
		var schedulev = (occupyspace*100/totalspace).toFixed(2);
		if(schedulev < 0)schedulev = 0;
		if(totalspace !=0){
			if(occupyspace*100/totalspace >= 90){
				jQuery("#schedule").css("background-color","red");
			}else{
				jQuery("#schedule").css("background-color","rgb(150,215,248)");
			}
			if(occupyspace*100/totalspace >= 100){
				jQuery("#schedule").css("width","100%");
			}else{
				jQuery("#schedule").css("width",schedulev+"%");
			}
			
			jQuery("#scheduleValue").html(schedulev+"%");
		}
	});
}
</script>
<%
	boolean isSystemManager = false;
	rs.executeSql("select 1 from hrmresourcemanager where id="+user.getUID());
	if(rs.getCounts()>0) isSystemManager = true;

	String orderBy = "";
	String backFields = "t.*";
	String sqlwhere ="1=1";
	String sqlFrom = "";
	
	String inboxtitle = SystemEnv.getHtmlLabelName(19816,user.getLanguage());
	String lajititle = SystemEnv.getHtmlLabelName(2040,user.getLanguage());
	String caogaotitle = SystemEnv.getHtmlLabelName(2039,user.getLanguage());
	String neibutitle = SystemEnv.getHtmlLabelName(24714,user.getLanguage());
	String bxtitle = SystemEnv.getHtmlLabelName(81337,user.getLanguage());
	String sendtitle = SystemEnv.getHtmlLabelName(19558,user.getLanguage());
	
	if("oracle".equals(rs.getDBType())){
		sqlFrom = "(SELECT -1 id , '"+inboxtitle+"' folderName from dual UNION SELECT -2,'"+sendtitle+"' from dual UNION SELECT -3, '"+caogaotitle+"' from dual"+
			"  UNION SELECT -4,'"+lajititle+"' from dual UNION SELECT -5,'"+neibutitle+"' from dual UNION SELECT -6,'"+bxtitle+"' from dual"+
			"  UNION SELECT id , folderName  FROM MailInboxFolder WHERE userId = "+user.getUID()+" ) t";
	}else{
		sqlFrom = "(SELECT -1 AS id , '"+inboxtitle+"' AS folderName  UNION SELECT -2,'"+sendtitle+"' UNION SELECT -3,'"+caogaotitle+"'"+
			"  UNION SELECT -4,  '"+lajititle+"' UNION SELECT -5, '"+neibutitle+"' UNION SELECT -6, '"+bxtitle+"'"+
			"  UNION SELECT id , folderName  FROM MailInboxFolder WHERE userId = "+user.getUID()+" ) t";
	}
	String operateString= "<operates width=\"15%\">";
	    operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getFolderOpratePopedom\"></popedom> ";
	    operateString+="     <operate href=\"javascript:doEdit()\" otherpara=\"column:folderName\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" index=\"0\"/>";
		operateString+="     <operate href=\"javascript:doClearFolder()\" text=\""+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
		operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>";
		operateString+="</operates>";
	String tableString="<table  pageId=\""+PageIdConst.Email_Folder+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Folder,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"checkbox\" needPage=\"true\">";
	    tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
	    tableString+="<checkboxpopedom showmethod=\"weaver.email.MailSettingTransMethod.getFolderCheckInfo\" popedompara=\"column:id\"  />";
		tableString+="<head>";
	    tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(19825,user.getLanguage()) +"\" column=\"folderName\" />";
	    tableString+="<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(25426,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(83087,user.getLanguage())+"\" "+ 
	     " column=\"id\" otherpara=\""+user.getUID()+"\" transmethod=\"weaver.email.MailSettingTransMethod.getFolderCount\"/>";
	    tableString+="<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(83086,user.getLanguage())+"\""+
	    "  column=\"id\" otherpara=\""+user.getUID()+"\" transmethod=\"weaver.email.MailSettingTransMethod.getFolderSpace\"/>";
	    tableString+="</head>"+operateString;
	    tableString+="</table>";
%>
<html>
<body>
    <div style="height:20px;">
    	<span class="p-l-10 left m-t-5"><%=SystemEnv.getHtmlLabelName(83082,user.getLanguage()) %>：<label id="totalSize"></label><%=SystemEnv.getHtmlLabelName(83083,user.getLanguage()) %>&nbsp;&nbsp; 
    		  <%=SystemEnv.getHtmlLabelName(27603,user.getLanguage()) %>：<label id="unreadsize"></label><%=SystemEnv.getHtmlLabelName(83083,user.getLanguage()) %>&nbsp;&nbsp;
    		  <% if(!isSystemManager){ %>
    		  <%=SystemEnv.getHtmlLabelName(83085,user.getLanguage()) %>&nbsp;<label id="totalspace"></label id="totalSize">M：<%=SystemEnv.getHtmlLabelName(83084,user.getLanguage()) %>&nbsp;<label id="occupyspace"></label>M，<%=SystemEnv.getHtmlLabelName(25723,user.getLanguage()) %>&nbsp;<label id="canusespace"></label>M，
    		  <%=SystemEnv.getHtmlLabelName(20007,user.getLanguage()) %>
    		  <%} %>
    	</span>
    	<%if(!isSystemManager){ %>
    	<div class="e8_outPercent left m-l-5 m-t-5" style="width: 200px;">
    		<span class="e8_innerPercent"  id="schedule" style="width: 0%;"></span>
    		<span class="e8_innerText" id="scheduleValue">0.00%</span>
    	</div>
    	<%} %>
    </div>

    <div style="height: 10px;"></div>
    <wea:layout attributes="{layoutTableId:topTitle}">
    	<wea:group context="" attributes="{groupDisplay:none}">
    		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
    			<input class="e8_btn_top middle" onclick="doAdd()" type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
    			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
    			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
    		</wea:item>
    	</wea:group>
    </wea:layout>
    <div style="position: relative;">
	   <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_Folder%>">
	   <wea:SplitPageTag tableString='<%=tableString%>'  mode="run"/>
    </div>
</body>
</html>


