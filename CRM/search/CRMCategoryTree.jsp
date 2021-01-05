
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rsMain" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsSub" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(147,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
String mainType = "2";//客户状态
String subType = "1";//客户描述

String leftMenus="";
if("2".equals(mainType)){
	rsMain.execute("select id ,fullname from CRM_CustomerStatus order by id desc");
	
	while(rsMain.next()){
		rsSub.execute("select id ,fullname from CRM_CustomerDesc order by id desc");
		String mainTypeId=rsMain.getString("id");
		String mainTypeName=rsMain.getString("fullname");
		
		String submenus="";
		while(rsSub.next()){
			String subTypeId=rsSub.getString("id");
			String subTypeName=rsSub.getString("fullname");
			
			submenus+=",{name:'"+subTypeName+"',"+
						"attr:{subTypeId:'"+subTypeId+"',parentid:'"+mainTypeId+"'},"+
						"numbers:{flowAll:100}}";
			
			leftMenus+=",{"+
						 "name:'"+mainTypeName+"',"+
						 "attr:{mainTypeId:'"+mainTypeId+"'},"+
						 "numbers:{flowAll:100},"+
						 "submenus:"+submenus+"}";
		}
		submenus=submenus.length()>0?submenus.substring(1):submenus;
		submenus="["+submenus+"]";
	}
	
	leftMenus=leftMenus.length()>0?leftMenus.substring(1):leftMenus;
	leftMenus="["+leftMenus+"]";

}
%>
<script type="text/javascript">
	var leftMenus = "<%=leftMenus%>";
	var demoLeftMenus=eval("("+leftMenus+")");
	
	/**
	 *	created by bpf in Oct,2013
	**/
	window.typeid=null;
	window.workflowid=null;
	window.nodeids=null;
	
	/**
	 *	wuiform.init针对本页的功能来说无任何作用，纯粹用于解决兼容init.jsp中的JS/css冲突的问题
	**/
	wuiform.init=function(){
		wuiform.textarea();
		wuiform.wuiBrowser();
		wuiform.select();
	}
	
	
	flowPageManager.loadFunctions.leftNumMenu = function(){
		
		var needflowOut=true;
		var needflowResponse=true;
		
		var	numberTypes={
				flowNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"}
		};
		if(needflowOut==true || needflowOut=="true"){
			numberTypes.flowOut={hoverColor:"#CB9CF4",color:"#CB9CF4",title:"<%=SystemEnv.getHtmlLabelName(84380,user.getLanguage())%>"};
		}
		if(needflowResponse==true || needflowResponse=="true"){
			numberTypes.flowResponse={hoverColor:"#FFC600",color:"#FFC600",title:"<%=SystemEnv.getHtmlLabelName(20288,user.getLanguage())%>"};
		}
		numberTypes.flowAll={hoverColor:"#A6A6A6",color:"black",title:"<%=SystemEnv.getHtmlLabelName(84382,user.getLanguage())%>"};
		$(".ulDiv").leftNumMenu(demoLeftMenus,{
			numberTypes:numberTypes,
			showZero:false,
			menuStyles:["menu_lv1",""],
			clickFunction:function(attr,level,numberType){
				leftMenuClickFn(attr,level,numberType);
			}
		});
		var sumCount=0;
		$(".e8_level_2").each(function(){
			sumCount+=parseInt($(this).find(".e8_block:last").html());
		});
		//$(".leftType").append("("+sumCount+")");
	}
	
	/**function leftMenuClickFn(attr,level,numberType){
		
		var typeid="";
		if(level==1){
		   var mainTypeDiv=$("#overFlowDiv div[parentid="+attr.mainTypeId+"]").each(function(){
		   		typeid+=","+$(this).attr("subTypeId");
		   });
		   typeid=typeid.length>0?typeid.substring(1):"";
		}else
		   typeid=attr.subTypeId;
		var url=menuUrl+"&typeid="+typeid;
		$(".flowFrame").attr("src",url);
		if(layout=="1")
		   showMenu();
	}***/
	
	


</script>


<body>


</body>

<html>




