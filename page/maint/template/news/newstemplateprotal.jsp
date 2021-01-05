
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page" />

<%
//Get Parameter
int hpidInt=Util.getIntValue(Util.null2String(request.getParameter("templateid")));
String hpid = hpidInt+"";
int templateTypeInt = Util.getIntValue(Util.null2String(request.getParameter("templatetype")),-1);
String templateType=Util.null2String(request.getParameter("templatetype"))+"";
boolean isSetting="true".equalsIgnoreCase(Util.null2String(request.getParameter("isSetting")));
String pagetype = Util.null2String(request.getParameter("pagetype"));
int docidInt= Util.getIntValue(Util.null2String(request.getParameter("docid")),-1);
String docid=docidInt+"";
int npidInt= Util.getIntValue(Util.null2String(request.getParameter("npid")),-1);
String npid=npidInt+"";
docid = docid+"&npid="+npid;
int isfromportal =0;
String serverName=request.getHeader("Host");
if("".equals(hpid)||"-1".equals(hpid)){
	ArrayList list = Util.TokenizerString(templateType,"@");
	Iterator it =list.iterator();
	while(it.hasNext()){
		String str =(String)it.next();
		if(str.indexOf("templateid")!=-1){
			 hpid=str.substring(str.indexOf("=")+1,str.length());
		}else if(str.indexOf("docid")!=-1){
			 docid=str.substring(str.indexOf("=")+1,str.length());
		}else if(str.indexOf("npid")!=-1){
			 npid=str.substring(str.indexOf("=")+1,str.length());
		}
	}

}

//计算相关页面数据

%>
<html>
  <head>
  	 <STYLE TYPE="text/css">
  	<%=pu.getHpCss(hpid,-1,0)%>
  	</STYLE>  	  
  	<!-- 引入CSS -->  	  
	<!-- 引入JavaScript -->  
	<%=pu.getPageJsImportStr("") %>
	<%=pu.getPageCssImportStr("") %>
	<script type="text/javascript">
		function initGauges(id,xml){
			try{
				setTimeout('bindows.loadGaugeIntoDiv("' + xml + '", "' +id+ '")', 1000);
			}catch(e){
				alert(e.name)
			}
		}
		
	</script>
</head>  
<body>
<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>


<div id="divInfo" style="border:1px solid #8888AA; background:white;display:none;position:absolute;padding:5px;posTop:expression(document.body.offsetHeight/2+document.body.scrollTop-50);posLeft:expression(document.body.offsetWidth/2-50);z-index:100;"></div>
<!--Content Table-->
<input type="hidden" value="btnWfCenterReload" name="btnWfCenterReload" onclick="elmentReLoad(8)">

<div>
 <%
 
	String strSpanContentWidth="100%";
%>
	<span  id="spanContent" style="width:<%=strSpanContentWidth%>;vertical-align:top;">		
		 <%=pu.getPageNewsTemplateBaseStr(hpid,null,isSetting,docid,templateType,serverName,request)%>	 
	</span>	
</div>

</body>
</html>


<SCRIPT LANGUAGE="JavaScript">

$(document).ready(function(){

	$(".item").bind("reload",function(){
		elementReload(this.eid,this.cornerTop,this.cornerBottom,this.cornerTopRadian,this.cornerBottomRadian)
	});
	
	$(".item").trigger("reload");	
});

function elementReload(eid,top,bottom,topRadian,bottomRadian){	
	var $this = $("#content_view_id_"+eid);
	var url=$.trim($this.attr("url")).replace(/&amp;/g,"&");
	
	if(url.substring(0,1)!="?")  {
		$this.html("<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,7)%>...")
		log(url)
		$this.load(url,{},function(){
			
		});
	} 
	
	if(top=="Round") {
		$("#header_"+eid).corner("Round top "+topRadian); 
	}

	if(bottom=="Round") {
		$("#content_"+eid).corner("Round bottom "+bottomRadian); 
	}	
}

function toggleELib(obj){
	if($('#spanELib').css("width")=="0%") {
		$('#spanELib').css("margin","10 0 0 10");
		$('#spanELib').css("width","15%");		
		$('#spanContent').css("width","84%");

		obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(19614,7)%>";
	} else {
		$('#spanELib').css("margin","0");
		$('#spanELib').css("width","0%");
		$('#spanContent').css("width","100%");
		obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(19613,7)%>";
	}
}


function openMaginze(obj,url,linkmode){
  url=url+obj.value;
  if(linkmode=="1") window.location=url; 
  if(linkmode=="2") openFullWindowForXtable(url);
}

function onRefresh(eid,ebaseid){
	$("#item_"+eid).trigger("reload");  
}

//菜单
function onBack()
{
	
}
function onBackList()
{
	
}
//-->
</SCRIPT>

<%@ include file="/js/homepage/LoginHomepage_js.jsp"%>
