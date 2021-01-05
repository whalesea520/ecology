
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig" %>
<%@ include file="/systeminfo/init_wev8.jsp" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
//自定义界面-左侧菜单
String titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17596,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

boolean isShowMainMenu=true;

String menuSql = "SELECT b.isShowMainMenu FROM SystemTemplateUser a, SystemTemplate b WHERE a.userid="+userid+" AND a.templateId=b.id";
RecordSet.executeSql(menuSql);
if(RecordSet.next()){
	if(RecordSet.getString("isShowMainMenu").equals("0"))	isShowMainMenu = false;	
}

String saved = Util.null2String(request.getParameter("saved"));

LeftMenuHandler leftMenuHandler = new LeftMenuHandler();
HashMap leftMenuMapping = leftMenuHandler.getLeftMenuMapping(userid);
ArrayList topLevelLeftMenuInfos = (ArrayList)leftMenuMapping.get("topLevel");

String oldCheckedString = "";
String oldIdString = "";


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
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18378,user.getLanguage())+",CustomLeftMenuCAdd.jsp,_self} " ;//新建菜单分类
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep ;

/*
if(HrmUserVarify.checkUserRight("MenuCustom:Maintenance", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(17607,user.getLanguage())+",javascript:customName(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

}

RCMenu += "{"+SystemEnv.getHtmlLabelName(15084,user.getLanguage())+",javascript:up(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(15085,user.getLanguage())+",javascript:down(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
*/ 

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CustomSetting.jsp,_self} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
%>
  
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmmain action="LeftMenuOperation.jsp" method=post style="width:98%;">
<input type=hidden name=ret value="--">
<input type=hidden name=valueT1 value="--">
<input type=hidden name=valueT2 value="--">
<input type=hidden name=checkedString value="--">

<table class=ViewForm id="myform">
<%
for(int i=0; i<topLevelLeftMenuInfos.size(); i++){
	 LeftMenuConfig topConfig = (LeftMenuConfig)topLevelLeftMenuInfos.get(i);
	 LeftMenuInfo topInfo = (LeftMenuInfo)topConfig.getLeftMenuInfo();
	 int topId = topInfo.getId();
	 String topName = topConfig.getName(user);//topInfo.getName(user.getLanguage());
	 boolean topVisible = topConfig.isVisible();
	 boolean topLocked = topConfig.isLocked();
	 if(topLocked) topVisible = topConfig.isVisible();
	 String isCustom = topInfo.getIsCustom();
	 oldCheckedString+= topVisible==true?"1,":"0,";
	 oldIdString+= topId+",";
	
	 ArrayList subLevelLeftMenuInfos = (ArrayList)leftMenuMapping.get(new Integer(topId));
%>
<tr class=field>
<td>
	<table border="1" id="tbl<%=i%>" style="border-collapse:collapse;border-style:solid;width:100%">
	<tbody>
	<tr class=field>
		<td align=left width="30">
			<%if(topId!=114){%>
				<input type="checkbox" name="m<%=topId%>" value="M<%=topId%>" onclick="checkMain('<%=topId%>')" <%if(topVisible){out.print("checked");}%> <%if(topLocked){out.print("disabled");}%>>
			<%}else{%>
				<%if(isShowMainMenu){%>
					<input type="checkbox" name="m<%=topId%>" value="M<%=topId%>" onclick="checkMain('<%=topId%>')" disabled>
				<%}else{%>
					<input type="checkbox" name="m<%=topId%>" value="M<%=topId%>" onclick="checkMain('<%=topId%>')" <%if(topVisible){out.print("checked");}%> <%if(topLocked){out.print("disabled");}%>>
				<%}%>
			<%}%>
		</td>
		<td 
			width="*" 
			<%if(!topLocked){%>
			onmousedown="mousedown()" 
			onmouseup="mouseup()" 
			onmousemove="mousemove()"
			onmouseover="mouseover()"
			onmouseout="mouseout()"
			iscustom="<%=isCustom%>"
			topid="<%=topId%>"
			<%}%>
			>
			<%if(subLevelLeftMenuInfos!=null){%><img src="/images/collapsed_wev8.gif" onclick="collapseTR()" style="cursor:hand"/><%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;<%}%>
			<b><%=topName%></b><%if(topLocked){%><img class="tbIcon" src="/images/Lock_wev8.GIF" WIDTH="23" HEIGHT="22"><%}%>
		</td>
		<td width="120" style="padding-left:3px">
			<%if(isCustom.equals("1")){%>
			<a href="CustomLeftMenuAdd.jsp?id=<%=topId%>" style="color:blue"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><!-- 添加 -->
			<a href="CustomLeftMenuEdit.jsp?id=<%=topId%>" style="color:blue"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a><!-- 编辑 -->
			<%}else{%>
				<%if(!topLocked){//(HrmUserVarify.checkUserRight("MenuCustom:Maintenance", user)){%>
				<a href="CustomLeftMenuName.jsp?id=<%=topId%>&resourceId=<%=topConfig.getResourceId()%>&resourceType=<%=topConfig.getResourceType()%>"><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></a><!-- 自定义名称 -->
				<%}%>
			<%}%>
		</td>
	</tr>
	<%
	if(subLevelLeftMenuInfos!=null){
	boolean hasSub = false;
	for(int j=0; j<subLevelLeftMenuInfos.size(); j++){
		LeftMenuConfig subConfig = (LeftMenuConfig)subLevelLeftMenuInfos.get(j);
		LeftMenuInfo subInfo = subConfig.getLeftMenuInfo(); 
		int subId = subInfo.getId();
		RecordSet.executeSql("SELECT COUNT(id) AS SubCount FROM LeftMenuInfo WHERE parentId="+subId+"");
		if(RecordSet.next()){
			hasSub = RecordSet.getInt("SubCount")==0 ? false : true;
		}
		String subName = subConfig.getName(user);//subInfo.getName(user.getLanguage());
		String subLinkAddress = subInfo.getLinkAddress();
		boolean subVisible = subConfig.isVisible();
		boolean subLocked = subConfig.isLocked();
		if(subLocked) subVisible = subConfig.isVisible();
		oldCheckedString+= subVisible==true?"1,":"0,";
		oldIdString+= subId+",";
	%>
	<tr class=field>
		<td></td>
		<td 
			<%if(!subLocked){%>
			onmousedown="mousedown()"
			onmouseup="mouseup()"
			onmousemove="mousemove()"
			onmouseover="mouseover()"
			onmouseout="mouseout()"
			<%}%>
			>
			<%if(subVisible){%>
			<input type="checkbox" name="s<%=topId%>" value="S<%=subId%>" onclick="checkSub('<%=topId%>')" hasSub="<%=hasSub%>" checked <%if(subLocked){out.print("disabled");}%>>  
			<%}else{%>
			<input type="checkbox" name="s<%=topId%>" value="S<%=subId%>" onclick="checkSub('<%=topId%>')" hasSub="<%=hasSub%>" <%if(subLocked){out.print("disabled");}%>>  
			<%}%>
			<span href="<%=subLinkAddress%>"><%=subName%></span><%if(subLocked){%><img class="tbIcon" src="/images/Lock_wev8.GIF" WIDTH="23" HEIGHT="22"><%}%>
		</td>
		<td width="120" style="padding-left:3px;white-space:nowrap">
			<%if((!subLocked||(subLocked&&subVisible))&&(subLinkAddress!=null&&!subLinkAddress.equals("")&&!subLinkAddress.startsWith("javascript:void(0)"))){%>
			<a href="<%=subLinkAddress%>" style="color:blue"><%=SystemEnv.getHtmlLabelName(18367,user.getLanguage())%></a><!-- 功能入口 -->
			<%}%>
			<%if(isCustom.equals("1")){%>
			<a href="CustomLeftMenuEdit.jsp?id=<%=subId%>&edit=sub" style="color:blue"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a><!-- 编辑 -->
			<%}else{%>
				<%if(!subLocked){//(HrmUserVarify.checkUserRight("MenuCustom:Maintenance", user)){%>
				<a href="CustomLeftMenuName.jsp?id=<%=subId%>&resourceId=<%=subConfig.getResourceId()%>&resourceType=<%=subConfig.getResourceType()%>&edit=sub"><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></a><!-- 自定义名称 -->
				<%}%>
			<%}%>
		</td>
	</tr>	
	<%}}%>
	</tbody>
	</table>
</td>
</tr>
<%}%>
</table>

<table id="report" class="ReportStyle" style="margin-top:15px;">
<TBODY>
<TR><TD>
<!-- 添加自定义菜单:点击右键菜单可以新建菜单分类。点击菜单分类右边的链接可以添加自定义菜单。 --> 
<B>1<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18379,user.getLanguage())%></B><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18380,user.getLanguage())%>
<BR>
<!-- 拖动排序:按住鼠标左键可以对菜单分类进行拖动排序。在同一菜单分类下，可以使用相同的方式调整该分类中的菜单顺序。 -->
<B>2<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18381,user.getLanguage())%></B><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18382,user.getLanguage())%>
<BR>
<!-- 菜单复制:点击图标 展开分类下的所有菜单。按住鼠标左键可以将菜单拖动到其它分类（系统默认菜单分类除外）中。 -->
<B>3<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18383,user.getLanguage())%></B><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18384,user.getLanguage())%><img src="/images/collapsed_wev8.gif" align="absmiddle"><%=SystemEnv.getHtmlLabelName(18385,user.getLanguage())%><BR>
<!-- 菜单隐藏:点击菜单(分类)前的复选框可以显示、隐藏菜单(分类)。 -->
<B>4<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18386,user.getLanguage())%></B><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18387,user.getLanguage())%><BR>
<BR>
<!-- 注意事项:系统默认菜单(分类)不可修改。拖动菜单(分类)时出现图标 表示操作可行。 -->
<B><%=SystemEnv.getHtmlLabelName(15736,user.getLanguage())%></B><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18388,user.getLanguage())%><img src="/images/ArrowLeftRed_wev8.gif" align="absmiddle"><%=SystemEnv.getHtmlLabelName(18389,user.getLanguage())%><BR>
</TD>
</TR>
</TBODY>
</table>

<input type="hidden" name=oldCheckedString value=<%=oldCheckedString%>>
<input type="hidden" name=oldIdString value=<%=oldIdString%>>
</FORM>



<script LANGUAGE="JavaScript">
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
	for(m=0;m<tbody.rows.length;m++){
		if(el==tbody.rows[m].children[1]){
			return m;
		}
	}
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
	var myHref;
	with(oEl.childNodes[2]){
		myHref = getAttribute("href");
		myHref = myHref.replace(/&/g,"*");
		location.href = "CustomLeftMenuOperation.jsp?operationType=clone&parentID="+oElTarget.getAttribute("topid")+"&customMenuName="+innerText+"&customMenuLink="+myHref;
	}
	/*多级菜单复制
	var subId,myHref;
	var subId = oEl.firstChild.value;
	subId = subId.substring(1,subId.length);
	with(oEl.childNodes[2]){
		myHref = getAttribute("href");
		myHref = myHref.replace(/&/g,"*");
		location.href = "CustomLeftMenuOperation.jsp?operationType=clone&subID="+subId+"&parentID="+oElTarget.getAttribute("topid")+"&customMenuName="+innerText+"&customMenuLink="+myHref;
	}
	*/
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
				if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id==table_src.id && el_target.parentElement.rowIndex!=0){
					row_target = getArrayIndex(el_target);
					row_src = getArrayIndex(el);
					moveRows(row_src,row_target);
				}
				if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id!=table_src.id){
					if(el_target.childNodes[2].innerText){
						if(el_target.getAttribute("iscustom")=="1"){
							if(el.firstChild.getAttribute("hasSub")=="true"){
								alert("<%=SystemEnv.getHtmlLabelName(18420,user.getLanguage())%>!");//只允许复制具体的菜单项
								return false;
							}
							// 是否复制到自定义分类 
							if(confirm("<%=SystemEnv.getHtmlLabelName(18421,user.getLanguage())%>["+el_target.childNodes[2].innerText+"]?")) 		cloneMenu(el,el_target);
						}
					}else{
						if(el_target.getAttribute("iscustom")=="1"){
							if(el.firstChild.getAttribute("hasSub")=="true"){
								alert("<%=SystemEnv.getHtmlLabelName(18420,user.getLanguage())%>!");//只允许复制具体的菜单项
								return false;
							}
							//是否复制到自定义分类
							if(confirm("<%=SystemEnv.getHtmlLabelName(18421,user.getLanguage())%>["+el_target.childNodes[1].innerText+"]?")) 		cloneMenu(el,el_target);
						}
					}
				}
			}else if(el.parentElement.rowIndex==0){	//DragMenuCategory
				if(el_target.tagName=="TD" && el_target.parentElement.parentElement.parentElement.id!=table_src.id && el_target.parentElement.rowIndex==0){
					tbl_target = el_target.parentElement.parentElement.parentElement.parentElement.parentElement.rowIndex;
					tbl_src = el.parentElement.parentElement.parentElement.parentElement.parentElement.rowIndex;
					moveTables(tbl_src,tbl_target);
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
			style.posTop  = cliY;
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
				if(el_target.getAttribute("iscustom")=="1"){
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

function checkMain(id) {
  len = document.frmmain.elements.length;
  var mainchecked=document.all("m"+id).checked ;
  var i=0;
  for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='s'+id) {
      document.frmmain.elements[i].checked= mainchecked ;
    }
  }
}

function checkSub(id) {
  len = document.frmmain.elements.length;
  var i=0;
  for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='s'+id) {
	  if(document.frmmain.elements[i].checked){
		document.all("m"+id).checked=true;
		return;
	  }
	}
  }
  document.all("m"+id).checked=false;
}

function onSave(){
	var hasChecked = false;
	var a = document.getElementsByTagName("input");
	for(var i=0;i<a.length;i++){
		if(a[i].name.indexOf("m")!=-1){
			if(a[i].checked){
				hasChecked = true;
				break;
			}
		}		
	}
	if(!hasChecked){
		alert("<%=SystemEnv.getHtmlLabelName(18353,user.getLanguage())%>");//请至少选择一项菜单
		return false;
	}

    len = document.frmmain.elements.length;
    var i=0;
    var nameString="";
    var valueString="";
    var checkedString="";

    for( i=0; i<len; i++) {
        var eName = document.frmmain.elements[i].name;
        var eValue = document.frmmain.elements[i].value;

        if (eName.indexOf("m")!=-1||eName.indexOf("s")!=-1) {
            nameString+=eName+",";
            valueString+=eValue+",";
            
            var eChecked = document.frmmain.elements[i].checked;
            if(eChecked==true)
                checkedString+=1+",";
            else
                checkedString+=0+",";
        }
    }
	
    document.frmmain.valueT1.value=nameString;
    document.frmmain.valueT2.value=valueString;
    document.frmmain.checkedString.value=checkedString;
	 window.frames["rightMenuIframe"].event.srcElement.disabled = true;
    frmmain.submit();
}

function customName(){
	if(selectedObj==null){
		return;
	}
    var id = selectedObj.parentElement.cells(2).innerText;
//	if(window.confirm("是否改变菜单自定义的设置？")){
//		document.frmmain.ret.value="false";
//		onSave();
//	}
	location = 'CustomLeftMenuName.jsp?id='+id;
}

function loadLeftFrame(){
    parent.LeftMenuFrame.location.reload();
}

</script>

</body>
</html>

