
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%
	String saved = Util.null2String(request.getParameter("saved"));
    int companyid = Util.getIntValue(request.getParameter("companyid"),0);
    int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
    int sync = Util.getIntValue(request.getParameter("sync"),0);
    
    int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);
    String resourceType = Util.null2String((String)request.getParameter("resourceType"));
    
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

    //取得总部/分部菜单
    LeftMenuHandler leftMenuHandler = new LeftMenuHandler();
	//如果还未设定总部/分部菜单
	//leftMenuHandler.addDefaultLeftMenuConfig(resourceId,resourceType);
    HashMap leftMenuMapping = leftMenuHandler.getLeftMenuMapping(resourceId,resourceType);
    ArrayList topLevelLeftMenuInfos = (ArrayList) leftMenuMapping.get("topLevel");

    String oldCheckedString = "";
    String oldIdString = "";

    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage());//左侧菜单维护
    titlename += " - ";
    if(resourceType.equals("1")) titlename += (Util.toScreen(CompanyComInfo.getCompanyname(""+resourceId), user.getLanguage()));
    if(resourceType.equals("2")) titlename += (Util.toScreen(SubCompanyComInfo.getSubCompanyname(""+resourceId), user.getLanguage()));
    
    String needfav = "1";
    String needhelp = "";

    boolean isShowSyncInfo = false;
    
    if(resourceType.equals("2")) isShowSyncInfo = true;
    
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<style>
img{vertical-align:middle}
td{background-position:"right";background-repeat:"no-repeat";}

a:link {color:blue}
a:visited {color:blue}
a:hover {color:blue} 
a:active {color:blue}
</style>
</head>
  
<body onselectstart ="return false" onselect="document.selection.empty()" style="text-align:center">
<TEXTAREA NAME="txtTest"  id="txtTest" ROWS="10" COLS="60" style="display:none"></TEXTAREA>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18378,user.getLanguage())+",javascript:onNew(this),_self} " ;//新建菜单分类
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
%>
  
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmmain action="LeftMenuMaintenanceOperation.jsp" method=post style="width:98%;">
<input type="hidden" name="method" value="maintenance">
<input type="hidden" name="resourceId" value="<%=resourceId%>">
<input type="hidden" name="resourceType" value="<%=resourceType%>">

<TABLE class="ViewForm">
<TBODY>
<colgroup>
<col width="36%">
<col width="*">
<% if(isShowSyncInfo) { %>
<tr class="Title" ><th colspan="2"><%=SystemEnv.getHtmlLabelName(19014,user.getLanguage())%></th></tr><!-- 同步信息 -->
<tr class="Spacing" ><td class="Line1" colspan="2"></td></tr>
<tr>
    <td><%=SystemEnv.getHtmlLabelName(19016, user.getLanguage())%></td><!-- 同步下级分部人员 -->
    <td class=Field><input type="checkbox" name="sync" value="1" <%if(sync==1){%>checked<%}%> %></td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<% } %>

<tr class="Title" ><th colspan="2"><%=SystemEnv.getHtmlLabelName(18160,user.getLanguage())%></th></tr><!-- 菜单信息 -->
<tr class="Spacing" ><td class="Line1" colspan="2"></td></tr>
</TBODY>
</TABLE>
<TABLE class=ListStyle cellspacing=1>
	<TR>
		<TD colSpan=4></TD>
	</TR>
	<TR class=Header>		
		<TH width="30"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TH><!-- 显示 -->
		<th width="*"><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></th><!-- 菜单名称 -->
		<th width="120"></th>
	</TR>
	<TR class=Line>
		<TD colSpan=4></TD>
	</TR>
</TABLE>
	
<table class=ViewForm id="myform">	
    <%
        for (int i = 0; i < topLevelLeftMenuInfos.size(); i++) {
            LeftMenuConfig topConfig = (LeftMenuConfig) topLevelLeftMenuInfos.get(i);
            LeftMenuInfo topInfo = (LeftMenuInfo) topConfig.getLeftMenuInfo();
            
            int topId = topInfo.getId();
            String isCustom = topInfo.getIsCustom();
            String topName = topConfig.getName(user);
            
            ArrayList subLevelLeftMenuInfos = (ArrayList) leftMenuMapping.get(new Integer(topId));
            
            boolean superLocked = topConfig.getLockedById()>0;
            boolean isLocked = topConfig.isLocked();
            boolean superVisible = topConfig.isVisible();
            
    %>
    <tr class=field>
        <td colSpan=4>
            <table border="1" id="tbl<%=i%>" style="border-collapse:collapse;border-style:solid;width:100%" topid="<%=topId%>">
                <tbody>
                    <tr class=field>
                        <input type="hidden" name="main_infoids" value="<%=topId%>">
                        <td align=left width="30">
                            <%if(superLocked){//如果被上级锁定%>
	                            <input type="checkbox" name="chk_visible" <%if(superVisible){out.print("checked");}%> disabled>
	                            <% if(topConfig.isVisible()){%>
	                            	<input type="hidden" name="chk_visible" value="<%=topId%>">
	                            <%}%>
                            <%} else {%>
                            	<input type="checkbox" name="chk_visible" value="<%=topId%>" onclick="checkMain(this)" <%if(topConfig.isVisible()){out.print("checked");}%>>
                            <%}%>
                        </td>
                        <td
						onmousedown="mousedown()" 
						onmouseup="mouseup()" 
						onmousemove="mousemove()"
						onmouseover="mouseover()"
						onmouseout="mouseout()"
						iscustom="<%=isCustom%>"
						topid="<%=topId%>"						
						>
                            <%if (subLevelLeftMenuInfos != null) {%><img src="/images/collapsed_wev8.gif"
                                                                         onclick="collapseTR()"
                                                                         style="cursor:hand"/><%} else {%>&nbsp;&nbsp;&nbsp;&nbsp;<%}%>
                            <b><%= topName %></b>
                        </td>
                        <td width="120" style="padding-left:3px">
                            <%if (!superLocked&&isCustom.equals("2")) {%>
                            <%-- 添加 --%>
                            <a onclick="goWithSync('LeftMenuMaintenanceAdd.jsp?id=<%=topId%>&resourceId=<%=topConfig.getResourceId()%>&resourceType=<%=topConfig.getResourceType()%>')"
                               style="cursor:hand;color:blue;"><%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></a>
                            <%-- 编辑 --%>
                            <a onclick="goWithSync('LeftMenuMaintenanceEdit.jsp?id=<%=topId%>&resourceId=<%=topConfig.getResourceId()%>&resourceType=<%=topConfig.getResourceType()%>')"
                               style="cursor:hand;color:blue;"><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></a>
                            <%} else {%>
                            <%if(!superLocked){%>
                            <%-- 自定义名称 --%>
                            <a onclick="goWithSync('CustomLeftMenuName.jsp?id=<%=topId%>&resourceId=<%=topConfig.getResourceId()%>&resourceType=<%=topConfig.getResourceType()%>')"
                               style="cursor:hand;color:blue;"><%=SystemEnv.getHtmlLabelName(17607, user.getLanguage())%></a>
                            <%}%>
                            <%}%>
                        </td>
                    </tr>
                    <%
                        if (subLevelLeftMenuInfos != null) {
                            boolean hasSub = false;
                            for (int j = 0; j < subLevelLeftMenuInfos.size(); j++) {
                                LeftMenuConfig subConfig = (LeftMenuConfig) subLevelLeftMenuInfos.get(j);
                                LeftMenuInfo subInfo = subConfig.getLeftMenuInfo();
                                int subId = subInfo.getId();
                                RecordSet.executeSql("SELECT COUNT(id) AS SubCount FROM LeftMenuInfo WHERE parentId=" + subId + "");
                                if (RecordSet.next()) {
                                    hasSub = RecordSet.getInt("SubCount") == 0 ? false : true;
                                }
                                
                                String subName = subConfig.getName(user);
                                
                                String subLinkAddress = subInfo.getLinkAddress();
                                
                                boolean subSuperLocked = subConfig.getLockedById()>0;
                                boolean subSuperVisible = subConfig.isVisible();
                                boolean subIsLocked = subConfig.isLocked();
                                boolean subIsVisible = subConfig.isVisible();

                    %>
                    <tr class=field>
						<input type="hidden" name="sub_infoids_<%=(topId<0?Math.abs(topId)+"_neg":""+Math.abs(topId))%>" value="<%=subId%>">
                        <td></td>
                        <td 
						onmousedown="mousedown()"
						onmouseup="mouseup()"
						onmousemove="mousemove()"
						onmouseover="mouseover()"
						onmouseout="mouseout()"
						>
                        	<%if(subSuperLocked){%>
	                            <input type="checkbox" name="chk_visible_<%=(topId<0?Math.abs(topId)+"_neg":""+Math.abs(topId))%>" <%if(subSuperVisible){out.print("checked");}%> disabled>
	                            <% if(subIsVisible){ %>
	                            	<input type="hidden" name="chk_visible_<%=(topId<0?Math.abs(topId)+"_neg":""+Math.abs(topId))%>" value="<%=subId%>">
	                            <% } %>
                            <% } else { %>
                            	<input type="checkbox" name="chk_visible_<%=(topId<0?Math.abs(topId)+"_neg":""+Math.abs(topId))%>" value="<%=subId%>" onclick="checkSub(this)" hasSub="<%=hasSub%>" <%if(subIsVisible){out.print("checked");}%>>
                            <% } %>
                            <span href="<%=subLinkAddress%>"><%=subName%></span>
                        </td>
                        <td width="120" style="padding-left:3px;white-space:nowrap">
                         	<%if((!subSuperLocked||(subSuperLocked&&subSuperVisible))&&(subLinkAddress!=null&&!subLinkAddress.equals("")&&!subLinkAddress.startsWith("javascript:void(0)"))){%>
                        	<%-- 功能入口 --%>
                            <a href="<%=subLinkAddress%>" style="color:blue"><%=SystemEnv.getHtmlLabelName(18367, user.getLanguage())%></a>
                            <% } %>
                            <%if (!subSuperLocked&&isCustom.equals("2")) {%>
                            <%-- 编辑 --%>
                            <a onclick="goWithSync('LeftMenuMaintenanceEdit.jsp?id=<%=subId%>&resourceId=<%=subConfig.getResourceId()%>&resourceType=<%=subConfig.getResourceType()%>&edit=sub')"
                               style="cursor:hand;color:blue;"><%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></a>
                            <%} else {%>
                            <%if(!subSuperLocked){%>
                            <%-- 自定义名称 --%>
                            <a onclick="goWithSync('CustomLeftMenuName.jsp?id=<%=subId%>&resourceId=<%=subConfig.getResourceId()%>&resourceType=<%=subConfig.getResourceType()%>&edit=sub')"
                               style="cursor:hand;color:blue;"><%=SystemEnv.getHtmlLabelName(17607, user.getLanguage())%></a>
                            <%}%>
                            <%}%>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </td>
    </tr>
    <%}%>
</table>

<table id="report" class="ReportStyle" style="margin-top:15px;">
    <TBODY>
        <TR><TD>            
        	<!-- 显示:即下级分部管理员以及用户可对该菜单进行显示隐藏的操作 -->
            <B>1<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(89, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %></B><%=SystemEnv.getHtmlLabelName(19051, user.getLanguage())%>
            <BR>
            <!-- 自定义名称:即下级分部管理员以及用户可对该菜单进行自定义名称的操作-->
            <B>2<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(17607, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %></B><%=SystemEnv.getHtmlLabelName(19052, user.getLanguage())%>
            <BR>
            <BR>
            <!-- 注意事项:当前操作将会影响(总部或分部下)所有人员,包括当前维护人员 -->
            <B><%=SystemEnv.getHtmlLabelName(15736, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %></B><%=SystemEnv.getHtmlLabelName(19053, user.getLanguage())%>
        </TD>
        </TR>
    </TBODY>
</table>

<input type="hidden" name=oldCheckedString value=<%=oldCheckedString%>>
<input type="hidden" name=oldIdString value=<%=oldIdString%>>
</FORM>



<SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
<script LANGUAGE="JavaScript">
/*
*add ajax code
*/
function  GetContent(url){	
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("GET",url, true);
	xmlHttp.onreadystatechange = function () {
		switch (xmlHttp.readyState) {
		   case 4 :
				//xmlHttp.responseText;
                if(xmlHttp.status < 400)   {					
					eval(xmlHttp.responseText);
				}
		        break;
		}
	}
	xmlHttp.setRequestHeader("Content-Type","text/xml")
	xmlHttp.send(null);
}


/*	
========================================
Drag&Drop
hubo,2005/12/12
*/
var tblform,tbody;
var el = null;
var table_src = null;
var objDragItem;
var bDragMode = false;

function initAdditionalElements(){
	objDragItem = document.createElement("DIV");
	with(objDragItem.style){
		textAlign = "left";
		fontFamily = "Verdana";
		fontSize = "12px";
		color = "black";
		backgroundColor = "buttonshadow";
		cursor = "default";
		position = "absolute";
		filter = "progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=50)";
		zIndex = 3001;
		visibility = "hidden";
	}
	window.document.body.insertAdjacentElement("afterBegin", objDragItem);
}

function getArrayIndex(el){
	var rowIndex=el.parentNode.rowIndex;
	return rowIndex;
	/*for(m=0;m<tbody.rows.length;m++){
		if(el==tbody.rows[m].children[1]){
			return m;			
		}
	}*/
}

function moveRows(fRow,tRow){

	for(i=0;i<tbody.rows[0].children.length;i++){
		moveBodyRows(i,fRow,tRow);
	}
}

function moveBodyRows(iCol,fRow,tRow){
	if(fRow>tRow){
		dRow = -1;
		nRow = fRow - tRow;
	}else{
		dRow = 1;
		nRow = tRow - fRow;
	}
	saveHtml = tbody.children[fRow].children[iCol].innerHTML;
	for(j=0;j<nRow;j++){
		tbody.children[fRow].children[iCol].innerHTML = tbody.children[fRow+dRow].children[iCol].innerHTML;
		fRow = fRow + dRow;
	}
	tbody.children[tRow].children[iCol].innerHTML = saveHtml;	
}

function moveTables(fRow,tRow){
	if(fRow>tRow){
		dRow = -1;
		nRow = fRow - tRow;
	}else{
		dRow = 1;
		nRow = tRow - fRow;
	}
	saveTblHtml = tblform.rows[fRow].firstChild.innerHTML;
	for(j=0;j<nRow;j++){
		tblform.rows[fRow].firstChild.innerHTML = tblform.rows[fRow+dRow].firstChild.innerHTML;
		fRow = fRow + dRow;
	}
	tblform.rows[tRow].firstChild.innerHTML = saveTblHtml;
}

function cloneMenu(oEl,oElTarget){
	//txtTest.value=oEl.firstChild.value+"\n";

	//txtTest.value+=oElTarget.topid;
	//oElTarget.parentNode.parentNode.appendChild(oEl.parentNode)
	//add move code

	url="LeftMenuDrag.jsp?method=clone&subCompanyId=<%=subCompanyId%>&sInfoid="+oEl.firstChild.value+"&tParentid="+oElTarget.topid;	
	txtTest.value=url
	GetContent(url);
	//window.location.reload();
}

function mousedown(){
	el = window.event.srcElement;
	if(el.tagName=="INPUT"){
		el = null;
		return false;
	}else if(el.tagName=="A"){
		location.href = el.getAttribute("href");
		el = null;
		return false;
	}else if(el.tagName=="IMG"){
		el = null;
		return false;
	}
	while(el.tagName!="TD"){
		el = el.parentElement;
		if(el==null) return false;
	}

	bDragMode = true;
	with(objDragItem){
		innerHTML = el.innerHTML;
		style.height = el.offsetHeight;
		//style.width  = el.offsetWidth - 2;
		style.width = "200px";
	}

	tbody = el.parentElement.parentElement;
	table_src = tbody.parentElement;
	el.setCapture();
	el.style.cursor = "move";
}

function mouseup(){
	var row_target,row_src;
	var el_target;
	bDragMode = false;
	objDragItem.style.visibility = "hidden";
	objDragItem.style.cursor = "default";
	hideFlag();
	
	try{
		el_target = window.event.srcElement;

		if(el_target!=null && el!=null){
			while(el_target.tagName!="TD"){
				el_target = el_target.parentElement;
			}

			if(el.parentElement.rowIndex!=0){			//DragMenu
				/*txtTest.value="rowIndex:"+el.parentElement.rowIndex+"\n";
				txtTest.value=txtTest.value+"el_target.tagName:"+el_target.tagName+"   id:"+el_target.parentElement.parentElement.parentElement.id+"\n";
				txtTest.value+="table_src.id:"+table_src.id+"\n";
				txtTest.value+="el_target.parentElement.rowIndex:"+el_target.parentElement.rowIndex;
				*/
				
				
				if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id==table_src.id && el_target.parentElement.rowIndex!=0){					
					//row_target = getArrayIndex(el_target);				
					//row_src = getArrayIndex(el);					
					//moveRows(row_src,row_target);

					el_target.parentNode.parentNode.insertBefore(el.parentNode,el_target.parentNode)

					//txtTest.value=el.parentNode.parentNode.parentNode.tagName+"\n\n";
					//txtTest.value+=el_target.firstChild.value;					

					//add move code
					//txtTest.value=url

					var url="LeftMenuDrag.jsp?method=move&subCompanyId=<%=subCompanyId%>&sInfoid="+el.firstChild.value+"&tInfoid="+el_target.firstChild.value;
					txtTest.value=url
					GetContent(url);
				}
				if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id!=table_src.id){
					/*txtTest.value="in ok. \n";
					txtTest.value+=el_target.tagName;
					txtTest.value+=el_target.outerHTML;*/
					

					if(el_target.childNodes[2].innerText){
						//txtTest.value+="true ok. \n";
						if(el_target.getAttribute("iscustom")=="1" || el_target.getAttribute("iscustom")=="2"){
							if(el.firstChild.getAttribute("hasSub")=="true"){
								alert("<%=SystemEnv.getHtmlLabelName(18420,user.getLanguage())%>!");
								return false;
							}
							if(confirm("<%=SystemEnv.getHtmlLabelName(18421,user.getLanguage())%>["+el_target.childNodes[2].innerText+"]?")) 		cloneMenu(el,el_target);
						}
					}else{
						//txtTest.value+="false ok. \n";
						if(el_target.getAttribute("iscustom")=="1" || el_target.getAttribute("iscustom")=="2"){
							if(el.firstChild.getAttribute("hasSub")=="true"){
								alert("<%=SystemEnv.getHtmlLabelName(18420,user.getLanguage())%>!");
								return false;
							}
							if(confirm("<%=SystemEnv.getHtmlLabelName(18421,user.getLanguage())%>["+el_target.childNodes[1].innerText+"]?")) 		cloneMenu(el,el_target);
						}
					}
				}
			}else if(el.parentElement.rowIndex==0){	//DragMenuCategory
				if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id!=table_src.id && el_target.parentElement.rowIndex==0){
					var oT=el_target.parentElement.parentElement.parentElement.parentElement.parentElement;
					var oS=el.parentElement.parentElement.parentElement.parentElement.parentElement;
					//tbl_target = oT.rowIndex;
					//tbl_src = oS.rowIndex;

					//moveTables(tbl_src,tbl_target);

					oT.parentNode.insertBefore(oS,oT)
					
					//txtTest.value=oS.outerHTML
				    //var oSInfoIds=oS.getElementsByName("main_infoids")
					//txtTest.value=oS.firstChild.firstChild.topid;
					var oTInfoId=oT.firstChild.firstChild.topid
					var oSInfoId=oS.firstChild.firstChild.topid
					var url="LeftMenuDrag.jsp?method=move&subCompanyId=<%=subCompanyId%>&sInfoid="+oSInfoId+"&tInfoid="+oTInfoId;
					//txtTest.value=url
					GetContent(url);					
				}
			}
		
			el.releaseCapture();
			el.style.cursor = "default";
			el = null;
			
		}
	}catch(e){
		if(el!=null){
			el.releaseCapture();
			el.style.cursor = "default";
			el = null;
		}
	}
}

function mousemove(){
	window.event.cancelBubble = false;
	cliX = window.event.clientX;
	cliY = window.event.clientY;
	if(bDragMode && objDragItem!=null){
		with(objDragItem){
			if(style.visibility =="hidden") style.visibility = "visible";
			style.posLeft = cliX + 5;
			style.posTop  = cliY+document.body.scrollTop;
		}
	}
}

function mouseover(){
	var el_target = window.event.srcElement;
	if(bDragMode && el_target.tagName=="TD"){
		if(el_target.cellIndex!=1) return false;
		if(el.parentElement.rowIndex!=0){			//DragMenu
			if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id==table_src.id && el_target.parentElement.rowIndex!=0){
				showFlag(el_target);
			}
			if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id!=table_src.id){
				if(el_target.getAttribute("iscustom")=="1"||el_target.getAttribute("iscustom")=="2"){
					showFlag(el_target);
				}
			}
		}else if(el.parentElement.rowIndex==0){		//DragMenuCategory
			if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id!=table_src.id && el_target.parentElement.rowIndex==0){
				showFlag(el_target);
			}
		}
		//window.event.srcElement.style.backgroundImage = "url(/images/gdDownArrow_wev8.gif)";
	}
}

function mouseout(){
	window.event.srcElement.style.backgroundColor = "";
	window.event.srcElement.style.backgroundImage = "";
}

function showFlag(o){
	if(o.parentElement.className == "field"){
		o.style.backgroundColor = "#EEEEEE";
		o.style.backgroundImage = "url(/images/ArrowLeftRed_wev8.gif)";
	}
}

function hideFlag(){
	var t = document.getElementsByTagName("TD");
	for(var i=0;i<t.length;i++){
		t[i].style.backgroundColor = "";
		t[i].style.backgroundImage = "";
	}
}



function window.onload(){
	tblform = document.getElementById("myform");
	collapseAll();
	initAdditionalElements();
	<%if(saved.equals("true")){%>
	loadLeftFrame();
	<%}%>
}
//======================================


/*	
========================================
Collapse&Expand
hubo,2005/12/12
*/
function collapseTR(){
	var elImg = window.event.srcElement;
	el = elImg.parentElement.parentElement.parentElement;
	
	if(el.childNodes.length>1){
		if(el.childNodes[1].style.display=="none"){
			elImg.src = "/images/expanded_wev8.gif";
			for(var i=1;i<el.childNodes.length;i++) el.childNodes[i].style.display="block";
		}else{
			elImg.src = "/images/collapsed_wev8.gif";
			for(var i=1;i<el.childNodes.length;i++) el.childNodes[i].style.display="none";
		}
	}
}

function collapseAll(){
	for(var i=0;i<tblform.rows.length;i++){
		for(var j=1;j<tblform.rows[i].cells[0].firstChild.rows.length;j++){
			tblform.rows[i].cells[0].firstChild.rows[j].style.display = "none";
		}
	}
}
//======================================





var selectedObj;
var oldSelectedObj;
var oldClassName;

function checkMain(obj) {
    var id = obj.value;
    var mainchecked = obj.checked;
    var son = eval("document.frmmain."+obj.name+"_"+(id<0?Math.abs(id)+"_neg":id));
    var i = 0;
    if(son!=null&&son.value!=null) son.checked = mainchecked;
    else
	    for (i = 0; son!=null && i < son.length; i++) {
	    	if(!son[i].disabled) son[i].checked = mainchecked;
	    }
}

function checkSub(obj) {
	var splitstrarray = obj.name.split("_");
	var id = splitstrarray[2];
	if(splitstrarray.length>3&&splitstrarray[3]=="neg") id = 0 - id;
    var son = eval("document.frmmain."+obj.name);
    var i = 0;
   	var parents = eval("document.frmmain."+splitstrarray[0]+"_"+splitstrarray[1]);
   	var parent = null;
   	for(i=0;parents!=null&&i<parents.length;i++){
   		parent = parents[i];
   		if(parent.value == id) break;
   	}
   	if(i>=parents.length) parent = null;
   	if(parent!=null){
	   	if(son!=null&&son.value!=null){
	   		if(son.checked) parent.checked = true;
	   		else parent.checked = false;
	   	} else {
		    for (i = 0; parent!=null && son !=null && i < son.length; i++) {
		        if (son[i].checked) {
		    		if(!parent.disabled) parent.checked = true;
		        	return;
		        }
		    }
	    	if(parent!=null) parent.checked = false;
	    }
	}
}

function onSave(obj) {

    var hasChecked = false;
    var a = eval("document.frmmain.chk_visible");
    for (var i = 0; a != null && i < a.length; i++) {
        if (a[i].checked) {
            hasChecked = true;
            break;
        }
    }
    if (!hasChecked) {
        alert("<%=SystemEnv.getHtmlLabelName(18353,user.getLanguage())%>");//请至少选择一项菜单
        return false;
    }
    //obj.disabled=true;
	//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
    frmmain.submit();

	
}

function customName() {
    if (selectedObj == null) {
        return;
    }
    var id = selectedObj.parentElement.cells(2).innerText;
    //	if(window.confirm("是否改变菜单自定义的设置？")){
    //		document.frmmain.ret.value="false";
    //		onSave();
    //	}
    location = 'CustomLeftMenuName.jsp?id=' + id;
}

function loadLeftFrame(){
   //parent.leftframe.location.reload();
}
function onNew(obj){
	var sync = 0;
<% if(resourceType.equals("1")) { %>
	sync = 1;
<% } else { %>
	if(frmmain.sync.checked) sync = 1;
<% } %>	
	location.href="LeftMenuMaintenanceAdd.jsp?resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync="+sync;
	obj.disabled=true;
}

function goWithSync(url){
	var sync = 0;
<% if(resourceType.equals("1")) { %>
	sync = 1;
<% } else { %>
	if(frmmain.sync.checked) sync = 1;
<% } %>	
	location.href=url+"&sync="+sync;
}

</script>

</body>
</html>

