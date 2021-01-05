<%@ page import="weaver.general.Util,weaver.hrm.User" %>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.Timestamp,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />

<%
String username = user.getAliasname() ;
String usertype = "" ;
if(user.getLogintype().equals("1")) usertype = "1" ;
else  usertype = ""+(-1*user.getType()) ;
String userid = ""+user.getUID() ;
String loginfile = Util.getCookie(request , "loginfileweaver") ;
String initsrcpage = "/datacenter/input/DataCenterInput.jsp" ;
String targetid = "10" ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentyear = (timestamp.toString()).substring(0,4) ;
String currentmonth = ""+Util.getIntValue((timestamp.toString()).substring(5,7)) ;
String currentdate = ""+Util.getIntValue((timestamp.toString()).substring(8,10));
String currenthour = (timestamp.toString()).substring(11,13) ;
%>

<html>
<head>
<title>高效源于协同 - <%=username%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" href="/css/Weaver.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" scroll="no">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
<tr height="60" id="topMenu" name="topMenu" style="DISPLAY:''">
<td >
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr height="90">
		<td bgcolor="#172971" height="60">
			<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width ="100"><img src="/images_face/ecologyFace_1/logo_weaver.gif" border="0">
				</td>
				<td valign="bottom">
					<table border="0" cellpadding="0" cellspacing="0" width="100%" ALIGN="CENTER">
					<tr> 
					<td valign="top"> 
					    <applet CODE="apXPDropDown.class" width=790 height=20 >
						<param name = CODEBASE value = "/classbean/Menu" >
						<param name="MAYSCRIPT" value="true">
						
						<param name="Copyright" value="">
						<param name="isHorizontal" value="true">
						<param name="buttonType" value="3">
						<param name="solidArrows" value="false">
						<param name="systemSubFont" value="true">
						<param name="backColor" value="172971">
						<param name="buttonColor" value="070799">
						<param name="fontColor" value="ffffff">
						<param name="fontHighColor" value="ffffff">
						<param name="font" value="宋体,12,0">
						<param name="alignText" value="left"> 
						<param name="status" value="text"> 
						<param name="3DBackground" value="false">
						<%  String menuStr = "" ;
							
							//--------------数据中心Begin----------------//
							//--------------新闻中心Begin----------------//
							menuStr = "{ " + SystemEnv.getHtmlLabelName(16371,user.getLanguage()) + " } " ;
							menuStr += "{|" + SystemEnv.getHtmlLabelName(16371,user.getLanguage()) + ",/datacenter/input/DataCenterInput.jsp,mainFrame}";
							
						%>					
						<param name="menuItems" value="<%=menuStr%>">
						</applet>
					</td>
					</tr>
					<tr>
						<td height="5">
						</td>
					</tr>
					</table>
				</td>
				<td width ="100" valign="bottom">
				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="115" height="59">
				<param name="movie" value="/images_face/ecologyFace_1/logo_ecology.swf">
				<param name="quality" value="high">
				<embed src="/images_face/ecologyFace_1/logo_ecology.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="115" height="59">
				</embed>
				</object>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td background = "/images_face/ecologyFace_1/TopMenuBg_1.gif" height="4">
		</td>
	</tr>
	<tr>
		<td bgcolor="#BFBFBF" height="22">
		<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td width="10"></td>
		<td align="left">
		<table  height=100% border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width=30 align="center">
				<table width=22 height=18 border="0" cellspacing="0" cellpadding="0" Style="cursor:hand" onMouseDown='ItemClicked(this)' onMouseUp='ItemSelected(this)' onMouseOver='OverItems(this)' onMouseOut='OutItems(this)' onclick="javascript:toolBarLogOut()">
				<tr><td align="center">
				<img src="/images_face/ecologyFace_1/toolBarIcon/LogOut.gif" border=0 title="退出">
				</td></tr>
				</table>		
			</td>
			<td width=10 align="center">
				<img src="/images_face/ecologyFace_1/VLine_1.gif" border=0>
			</td>
			<td width=30 align="center">
				<table width=22 height=18 border="0" cellspacing="0" cellpadding="0" Style="cursor:hand" onMouseDown='ItemClicked(this)' onMouseUp='ItemSelected(this)' onMouseOver='OverItems(this)' onMouseOut='OutItems(this)' onclick="javascript:toolBarBack()">
				<tr><td align="center">
				<img src="/images_face/ecologyFace_1/toolBarIcon/Back.gif" border=0 title="后退">
				</td></tr>
				</table>		
			</td>
			<td width=30 align="center">
				<table width=22 height=18 border="0" cellspacing="0" cellpadding="0" Style="cursor:hand" onMouseDown='ItemClicked(this)' onMouseUp='ItemSelected(this)' onMouseOver='OverItems(this)' onMouseOut='OutItems(this)' onclick="javascript:toolBarForward()">
				<tr><td align="center">
				<img src="/images_face/ecologyFace_1/toolBarIcon/Pre.gif" border=0 title="前进">
				</td></tr>
				</table>		
			</td>
			<td width=30 align="center">
				<table width=22 height=18 border="0" cellspacing="0" cellpadding="0" Style="cursor:hand" onMouseDown='ItemClicked(this)' onMouseUp='ItemSelected(this)' onMouseOver='OverItems(this)' onMouseOut='OutItems(this)' onclick="javascript:mainFrame.history.go(0)">
				<tr><td align="center">
				<img src="/images_face/ecologyFace_1/toolBarIcon/Refur.gif" border=0 title="刷新">
				</td></tr>
				</table>		
			</td>
			<td width=30 align="center">
				<table width=22 height=18 border="0" cellspacing="0" cellpadding="0" Style="cursor:hand" onMouseDown='ItemClicked(this)' onMouseUp='ItemSelected(this)' onMouseOver='OverItems(this)' onMouseOut='OutItems(this)' onclick="javascript:toolBarPrint()">
				<tr><td align="center">
				<img src="/images_face/ecologyFace_1/toolBarIcon/Print.gif" border=0 title="打印">
				</td></tr>
				</table>		
			</td>
			</tr>
		</table>
		</td>
		<td align="right">
		</td>
		<td width="10"></td>
		</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td bgcolor="#5F5F5F" height="1">
		</td>
	</tr>
	</table>
</td>
</tr>
<tr>
	<td height="27" valign="top" nowrap>
		<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td  background = "/images_face/ecologyFace_1/TopMenuBg_2.gif" width="70%" height="27">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="5%"></td>
					<td width="10%" align="left" nowrap>
						<IMG id=TopHideShow  title=隐藏 style="CURSOR: hand" onclick=mnToggletop() src="/images_face/ecologyFace_1/BP2_Hide.gif">
					</td>
					<td width="20" align="left" nowrap><IMG src="/images_face/ecologyFace_1/VLine_1.gif" ></td>
					<td width="90%" align="left" nowrap></td>
				</tr>
			</table>
			</td>
			<td  background = "/images_face/ecologyFace_1/TopMenuBg_3.gif" width="30%" nowrap>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="31" valign="top" nowrap><img src="/images_face/ecologyFace_1/TopMenuImg_1.gif" border="0">
					</td>
					<td nowrap>
						<%=username%> 
						<% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%><%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
						<%} else if(currenthour.compareTo("12") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
						<%} else if(currenthour.compareTo("14") <= 0 ) {%><%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
						<%} else if(currenthour.compareTo("18") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%><%}%>! <%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%><%=currentyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=currentmonth%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=currentdate%><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
					</td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0" id="mainTable" name="mainTable">
		<tr>
			<td>
				<iframe id="mainFrame" name="mainFrame" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height="100%" width="100%" SCROLLING=yes SRC="<%=initsrcpage%>"></iframe>&nbsp;
			</td>
		</tr>
		</table>
	</td>
</tr>
</table>
</body>
<SCRIPT language=javascript>

function mnToggleleft(){
	if(leftMenu.style.display == ""){
		leftMenu.style.display = "none";
		LeftHideShow.src = "/images_face/ecologyFace_1/BP_Show.gif"; 
		LeftHideShow.title = "显示";
	}
	else{
		leftMenu.style.display = "";
		LeftHideShow.src = "/images_face/ecologyFace_1/BP_Hide.gif"; 
		LeftHideShow.title = "隐藏";
	}

}

function mnToggletop(){
	if(topMenu.style.display == ""){
		topMenu.style.display = "none";
		TopHideShow.src = "/images_face/ecologyFace_1/BP2_Show.gif"; 
		TopHideShow.title = "显示";

	}
	else{
		topMenu.style.display = "";
		TopHideShow.src = "/images_face/ecologyFace_1/BP2_Hide.gif"; 
		TopHideShow.title = "隐藏";
	}
//	leftFrame.location.reload();//重新load左边按钮
}

function newSelect()	//新建跳转
{
	var sendRedirect  = document.all("NewBuildSelect").value ;
	if (sendRedirect!="") mainFrame.location.href = sendRedirect ;
}

function favouriteSelect() //收藏夹跳转
{
	var sendRedirect  = document.all("FavouriteSelect").value ;
	if (sendRedirect!="") mainFrame.location.href = sendRedirect ;
}

function toolBarBack() //后退
{
	mainFrame.history.back();
}

function toolBarForward() //前进
{
	mainFrame.history.forward();
}

function toolBarFavourite() //收藏夹
{
	mainFrame.BacoAddFavorite.onclick();
	//杨国生2003-09-26 由于收藏无法直接得到mainFrame中的页面名称，所以采用折衷办法，把TopTile.jsp中的原收藏按钮类型改为hidden,然后直接调用该按钮的onclick()事件。
}

function toolBarPrint() //打印
{
	window.print();	
}

function isConfirm(LabelStr){
if(!confirm(LabelStr)){
   return false;
}
   return true;
} 

function toolBarLogOut() //退出
{
	var LabelStr= "<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>" ;
	if(isConfirm(LabelStr)) location.href="/datacenter/maintenance/user/login.jsp";
}
</SCRIPT>

<SCRIPT language=javascript>
function ItemClicked(item)
{
	if(this.sliding)
		return;		
	item.style.border="1 inset #ffffff";
}

function ItemSelected(item)
{
	if(this.sliding)
		return;		
	item.style.border="1px outset";
	item.style.borderColorDark="#ff3300";
	item.style.borderColorLight="#990000"; 
}

function OverItems(item)
{
	if(this.sliding)
		return;		
	item.style.border="1px outset";
	item.style.borderColorDark="#ff3300";
	item.style.borderColorLight="#990000"; 
}

function OutItems(item)
{
	if(this.sliding)
		return;		
	item.style.border="0 none black";
}
</SCRIPT>
</html>


