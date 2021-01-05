
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<%
	String type = Util.null2String(request.getParameter("type"));// top left 
	String mode = Util.null2String(request.getParameter("mode"));  //visible hidden 默认为hidden
	int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);
    String resourceType = Util.null2String((String)request.getParameter("resourceType"));
	String isCustom = Util.null2String(request.getParameter("isCustom"));


	String saved = Util.null2String(request.getParameter("saved"));
    int companyid = Util.getIntValue(request.getParameter("companyid"),0);
    int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
	int sync = Util.getIntValue(request.getParameter("sync"),0);

	
    
   
    
    int userId = 0;
    userId = user.getUID();
    
    //判断总部菜单维护权限
    if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
    	if(companyid>0||"1".equals(resourceType)){
    		response.sendRedirect("/notice/noright.jsp");
            return;
    	}
    } else {
    	if(companyid==0&&subCompanyId==0&&resourceId==0&&"".equals(resourceType)) companyid = 1;
    }
    
    //判断分部菜单维护权限
    if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    	if(subCompanyId>0||"2".equals(resourceType)){
    		response.sendRedirect("/notice/noright.jsp");
            return;
    	}
    } else {
    	CheckSubCompanyRight newCheck = new CheckSubCompanyRight();
    	int[] subcomids = newCheck.getSubComByUserRightId(userId,"SubMenu:Maint");
    	if(subCompanyId==0&&companyid==0&&resourceId==0&&"".equals(resourceType)){
        	if(subcomids!=null&&subcomids.length>0) subCompanyId = subcomids[0];
        	else {
        		response.sendRedirect("/notice/noright.jsp");
                return;
        	}
    	}
    	//for TD.4374
    	if(subCompanyId>0&&companyid==0){
	    	boolean tmpFlag = false;
	    	for(int i=0;i<subcomids.length;i++){
	    		if(subCompanyId == subcomids[i]){
	    			tmpFlag = true;
	    			break;
	    		}
	    	}
	    	if(!tmpFlag) {
	    		response.sendRedirect("/notice/noright.jsp");
	            return;
	    	}
    	}
    }

    if(companyid>0||subCompanyId>0){
    	resourceId = (companyid>0?companyid:subCompanyId);
    	resourceType = (companyid>0?"1":"2");
    }
//out.println("resourceId "+resourceId+" resourceType "+resourceType);

    String oldCheckedString = "";
    String oldIdString = "";

    String imagefilename = "/images/hdMaintenance_wev8.gif";

	

	String titlename="";

	String menuTitle="";
    if(resourceType.equals("1")) {
		menuTitle= (Util.toScreen(CompanyComInfo.getCompanyname(""+resourceId), user.getLanguage()));
	} else if(resourceType.equals("2")){
		menuTitle = (Util.toScreen(SubCompanyComInfo.getSubCompanyname(""+resourceId), user.getLanguage()));
	} else if(resourceType.equals("3")) {
		menuTitle = user.getLastname();
	}

	//menuTitle=menuTitle+titlename;

    
    String needfav = "1";
    String needhelp = "";

    boolean isShowSyncInfo = false;
    
    if(resourceType.equals("2")) isShowSyncInfo = true;


	String ownerid="";
		 if("1".equals(resourceType)){/*总部 z* 分部 s*  个人 r*  */
			ownerid="z" + resourceId;
		} else if("2".equals(resourceType)){
			ownerid="s" + resourceId;
		}else if("3".equals(resourceType)){
			ownerid="r" + resourceId;
		}	
		
	String menuType = Util.null2String(request.getParameter("menuType"));
	menuType = "".equals(menuType)?"2":menuType;
    String sqlWhere=" menutype='"+menuType+"' ";
    sqlWhere += subCompanyId==0?"":" and subCompanyId="+subCompanyId; 
	String menuName = Util.null2String(request.getParameter("menuName"));
	sqlWhere += "".equals(menuName)?"":" and menuname like '%"+menuName+"%'";	
%>



<HTML>
 <HEAD>
   <TITLE> New Document </TITLE>
	<style  id="thisStyle">
		.clsTxt{
			display:none;
		}
		span{
			display: inline-block;
		}
		.spanTitle{
			font-size: 13px;
			font-weight: bold;
			height: 29px;
			line-height: 161%;
			position: absolute;
			top: 5px;
		}
		#closeBtn{
			position: absolute;
			top: 8px;
			right: 5px;
		}
	</style>

	<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
 </HEAD>
 <BODY>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 	<form id="searchMenuForm" name="searchMenuForm" method="post" action="CustomMenuMaintList.jsp">
	<input type="hidden" id="operate" name="operate" value=""/>
	<input type="hidden" id="menuType" name="menuType" value="<%=menuType%>"/>
		<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="160px">					
				</td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" class="e8_btn_top" onclick="onAdd();" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="onDelAll();"/>
					<input type="text" class="searchInput" name="menuName"/>
					&nbsp;&nbsp;&nbsp;
					<input type="hidden" value="<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>" class="advancedSearch" onclick="jQuery('#advancedSearchDiv').toggle('fast');return false;"/>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
	</form>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<%
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;	
		
		if(subCompanyId!=0){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}

		//RCMenu += "{<span id=spanOrder>"+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"</span>,javascript:order(this),_self} " ;
		//RCMenuHeight += RCMenuHeightStep ;
		

		//RCMenu += "{<span id=spanExOrCo stat='co'>"+SystemEnv.getHtmlLabelName(20606,user.getLanguage())+"</span>,javascript:ExOrCo(this),_self} " ;
		//RCMenuHeight += RCMenuHeightStep ;
		
		if("visible".equals(mode)){
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(20766,user.getLanguage())+",javascript:hiddenNoVisbleMenu(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
		} else {
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(20767,user.getLanguage())+",javascript:showNoVisbleMenu(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;			
		}
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(20608,user.getLanguage())+",javascript:synchAll(this),_self} " ;
		//RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<%
						//得到pageNum 与 perpage
						int perpage =10;
						//设置好搜索条件
						String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
						  + "<checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.splitepage.transform.SptmForMenu.getMenuDel\"/>"
						  + "<sql backfields=\" id,menuname,menudesc,menutype,menucreater,subcompanyid,menulastdate \" sqlform=\" from menucenter \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+sqlWhere+"\" sqlisdistinct=\"false\" />"+
							"<head >"+
								"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(18390,user.getLanguage())+"\"   column=\"menuname\"  otherpara=\"column:id+column:menutype+column:subcompanyid\" transmethod=\"weaver.splitepage.transform.SptmForMenu.getMenuName\"/>"+
								"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(23036,user.getLanguage())+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"   column=\"menudesc\"/>"+
								"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(19054,user.getLanguage())+"\"   column=\"menutype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForMenu.getMenuType\"/>"+
								"<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\"   column=\"menucreater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
								"<col width=\"18%\"   text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\"   column=\"subcompanyid\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForMenu.getMenuSubCompany\"/>"+
								"<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(19520,user.getLanguage())+"\"   column=\"menulastdate\"/>"+
							"</head>"
							 + "<operates><popedom otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForMenu.getOperate\"></popedom> "
							 + "<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_blank\"  index=\"0\"/>"
							 + "<operate href=\"javascript:saveNew();\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"
							 + "<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>"
							 + "</operates></table>";						
						%>
					<TABLE width="100%">
						<TR>
							<TD valign="top">
								<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
							</TD>
						</TR>
					</TABLE>
 </BODY>
</HTML>
	<LINK REL=stylesheet type=text/css HREF=/wui/theme/ecology8/skins/default/wui_wev8.css>
	<!--For zDialog-->
	<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	
<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		
	})
	
	function onSearch(){
		searchMenuForm.submit();
	}	
	
	function onAdd(){
	 	var title = "<%=SystemEnv.getHtmlLabelName(23033,user.getLanguage())%>"; 
	 	var url = "/page/maint/menu/CustomMenuEdit.jsp?operate=addMenu&menutype=<%=menuType%>&subCompanyId=<%=subCompanyId%>";
	 	showDialog(title,url,600,300,true);
	}
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}

	function onDel(menuId){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			jQuery.post("CustomMenuOprate.jsp?operate=delMenu&menuid="+menuId,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}

   function onDelAll(){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){		
			var menuids = _xtable_CheckedCheckboxId();
			if(menuids=="") return;
			jQuery.post("CustomMenuOprate.jsp?operate=delAllMenu&menuid="+menuids,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}
	
	function onEdit(menuid){
		var url = jQuery("#menu_"+menuid).val();
		if(url=="")return;
		url = "/page/maint/menu/"+url;
		var title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>";
		showDialog(title,url,800,600,true);
	}
	
	function saveNew(menuid){
		var type = jQuery(jQuery.getSelectedRow()).find("td:eq(1) input").attr("menutype");
		var subCompanyId = jQuery(jQuery.getSelectedRow()).find("td:eq(1) input").attr("subcompanyid");
		var title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
	 	var url = "/page/maint/menu/CustomMenuEdit.jsp?operate=saveNew&menuid="+menuid+"&menutype="+type+"&subCompanyId="+subCompanyId;
	 	showDialog(title,url,500,200,false);
		//jQuery.post("CustomMenuOprate.jsp?operate=saveNew&menuid="+menuid+"&menutype="+type+"&subcompanyid="+subCompanyId,
		//function(data){if(data.indexOf("OK")!=-1) location.reload();});
	}
	
	function onShowSubcompany(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+currentids);
	   	if(id1){
	          var sHtml = "<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmSubCompanyDsp.jsp?id="+id1.id+"')>"+id1.name+"</a>&nbsp;";
	          jQuery("#"+inputid).val(id1.id);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
	}
</script>




