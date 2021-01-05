
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.homepage.HomepageBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page" />
<jsp:useBean id="wbe" class="weaver.admincenter.homepage.WeaverBaseElementCominfo" scope="page" />
<jsp:useBean id="hpsb" class="weaver.homepage.style.HomepageStyleBean" scope="page"/>
<jsp:useBean id="wp" class="weaver.admincenter.homepage.WeaverPortal" scope="page"/>
<jsp:useBean id="wpc" class="weaver.admincenter.homepage.WeaverPortalContainer" scope="page"/>


<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<LINK href="/css/commom_wev8.css" type=text/css rel=STYLESHEET>

<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>

<%
//BaseBean.writeLog(request.getQueryString()+"%%%%%%%%%");
//Get Parameter
String hpid = Util.null2String(request.getParameter("hpid"));
int isfromportal = Util.getIntValue(request.getParameter("isfromportal"),0);
int isfromhp = Util.getIntValue(request.getParameter("isfromhp"),0);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
boolean isSetting="true".equalsIgnoreCase(Util.null2String(request.getParameter("isSetting")));
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String opt = Util.null2String(request.getParameter("opt"));
String from = Util.null2String(request.getParameter("from"));
String pagetype = Util.null2String(request.getParameter("pagetype"));
String hasTemplate = Util.null2String(request.getParameter("hastemplate"));
boolean hasRight = true;
boolean issubmenu = false;

	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		hasRight=false;
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String layoutid=pc.getLayoutid(hpid);
	String styleid=pc.getStyleid(hpid);
	String menuStyleid = pc.getMenuStyleid(hpid);
	if("".equals(menuStyleid)){
		menuStyleid ="1";
		
	}
%>
<html>
<body>
<style>
	html,body{
		height:100%;
		width: 100%;
		
	}
	#editor{
		background: #dadada;
	}
	#htoolbar{
		position:absolute;
		width: 300px;
		height: 120px;
		top:50%;
		left:50%;
		margin-left: -150px;
		margin-top:-60px;
		
	}
	
	.hbtn{
		height: 114px;
		width: 114px;
		float: left;
		cursor: pointer;
	}
	
	.hbtn span{
		display: none;
		color:#fe8814;
		font-size: 14px;
		line-height: 114px;
	}
	
	.hbtnover{
		background: url("/wui/theme/ecology8/page/images/themeedit/hbg_wev8.png") center center no-repeat!important;
	}
	
	.hbtnover span{
		display: block!important;
	}
	
	
</style>
<%
String skin = request.getParameter("skin");
if("ecologyBasic".equals(skin)){%>	
<div>
<%@ include file="/homepage/HpCss.jsp" %>	
<%@ include file="/homepage/Navigation.jsp" %>
</div>
<%}
%>
<div class="w-all h-all center" id="editor">
	
	<div id = "htoolbar" class="" >
		<div class="hbtn" id="hedit" style="background: url(/wui/theme/ecology8/page/images/themeedit/hedit_wev8.png)" title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>">
			<span><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></span>
		</div>
		<div class="hbtn" id="helement" style="background: url(/wui/theme/ecology8/page/images/themeedit/helement_wev8.png);margin-left:60px;"  title="<%=SystemEnv.getHtmlLabelName(19650,user.getLanguage())%>">
			<span><%=SystemEnv.getHtmlLabelName(19650,user.getLanguage())%></span>
		</div>
		<div class="clear" title=""></div>
	</div>
	
</div>
<script type="text/javascript">
	//菜单
	$(document).ready(function(){
		var link = parent.document.location.href;
		
		if(link.indexOf("/systeminfo/template/ThemeEditor.jsp")>-1){
			$("#htoolbar").hide();
		}
	})
	function onMenuDivClick(hpid,subCompanyId){
		window.location="/homepage/HomepageEditor.jsp?hpid="+hpid+"&subCompanyId="+subCompanyId+"&skin=<%=skin%>"
	}
	
	function onSubMenuShow(obj){
	var divCurrent=obj.parentElement;
	var pSibling=divCurrent;

	var subMenu=document.getElementById("divSubMenu");       
	subMenu.style.display='block';

	subMenu.style.position="absolute";
	//subMenu.style.width=pSibling.offsetWidth;
	subMenu.style.posLeft=pSibling.offsetLeft;
	subMenu.style.posTop=pSibling.offsetTop+pSibling.offsetHeight;        
}

function onSubMenuHidden(obj){
	var subMenu=document.getElementById("divSubMenu");       
	subMenu.style.display='none';           
}

/*首页导航栏设置*/
var lastestSubDiv;
/*
   cObj:Current Object
   pObj:Pervious Sibling Object
   sObj:Sub Menu Object
*/
function onShowSubMenu(cObj,sObj){
  
	if (sObj.style.display=="none")    {
		/*初始化其显示的位置及大小*/
		//var pObj=cObj.previousSibling;
		var pObj=$(cObj).prev("div")[0];

		$(sObj).css({
			"position":"absolute",
			"left":$(pObj).offset().left,
			"top":$(pObj).offset().top+$(pObj).height()+10		
		})
		
		if(lastestSubDiv!=null) lastestSubDiv.style.display="none";
		lastestSubDiv=sObj;
		sObj.style.display="";

		//alert(sObj.offsetWidth+":"+pObj.offsetWidth)
		
		var factDivWidth=pObj.offsetWidth+cObj.offsetWidth;		
		if(factDivWidth<sObj.offsetWidth) factDivWidth=sObj.offsetWidth;

		sObj.style.width=factDivWidth;
		if (sObj.canHaveChildren) {
			var childDivs=sObj.children;
			for(var i=0;i<childDivs.length;i++) {
				var aChild=childDivs[i];
				if(aChild.offsetWidth<factDivWidth) aChild.style.width=factDivWidth;
			}
		}

		


	}
}

	function doEdit(){
		
	 	var title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepagePageEdit.jsp?opt=edit&method=savebase&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
	 	showDialog(title,url,900,600,true);
	}
	function doSetElement(){
		
	 	var title = "<%=SystemEnv.getHtmlLabelName(19650,user.getLanguage())%>"; 
	 	var url = "/homepage/maint/HomepageTabs.jsp?_fromURL=ElementSetting&isSetting=true&hpid=<%=hpid%>&from=setElement&pagetype=&opt=edit&subCompanyId=<%=subCompanyId%>";
	 	showDialog(title,url,1024,600,true);
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
	
	$(".hbtn").hover(function(){
		$(this).addClass("hbtnover")
	},function(){
		$(this).removeClass("hbtnover")
	})
	
	$("#hedit").bind("click",doEdit);
	$("#helement").bind("click",doSetElement);
</script>
</body>
</html>
