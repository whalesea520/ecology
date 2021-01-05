
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int language=user.getLanguage();
String from = Util.null2String(request.getParameter("from"));
String title="";
 if(language==7)
	title="欢迎进入协同工作区";
 else if(language==8)
	title="Welcome to Co-Work Zone";
 else if(language==9)
	title="歡迎進入系統工作區";
%>
<HTML>
 <HEAD>
 <title><%=title%></title>
 <style>
  body{
  	background:url('/cowork/images/welcomebg_wev8.png') no-repeat; 
  }
 </style>
 <script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
 <link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
  <script type="text/javascript">
  jQuery(document).ready(function(){
  //左侧下拉框处理
  if($(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
  });
  
  //新建协作
function addCowork(){
	if("<%=from%>"=="cowork")
       $(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/AddCoWork.jsp?from=<%=from%>");
	else
       window.location.href="/cowork/AddCoWork.jsp?from=<%=from%>";
   
}

  //跳转到查询协作
function toSearch(){
	if("<%=from%>"=="cowork")
		$(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/SearchCowork.jsp?from=<%=from%>");
	else
        window.location.href="/cowork/SearchCowork.jsp?from=<%=from%>";
    
}
  
 </script>
 </HEAD>
 <%
 String needfresh =request.getParameter("needfresh");//刷新左侧列表变量 1 刷新
  //是否需要刷新协作列表
  if("1".equals(needfresh)){
 %>
	<script language=javascript>
	if($(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined)
	   window.parent.reloadItemListContent();
	</script>
 <%}%>

 <BODY> 
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addCowork(),_self} ";
    RCMenuHeight += RCMenuHeightStep ;
	if(from.equals("cowork")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:toSearch(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<!--  
    <%if(language==7){ %>
    <div style="margin-top: 40px;margin-left: 60px;width: 400px">
         <span style="font-size: 22px;color:#4f8cc5;font-weight:900;">欢迎进入协同工作区</span>
         <div style="border-top:#4f8cc5 solid 1px;width:300px;"> 
           <div style="color: #5b97cf;margin-left: 40px;font-size: 12px;font-weight: bold" align="right">Welcome to Co-Work Zone</div>
         </div>
         <div style="margin-top: 20px">
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> 协同</span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> 跨部门</span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> 多事项</span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> 高效运作</span>
         </div>
         <div style="margin-top: 20px">
             注：您可在协作区(Co-Work Zone)进行跨部门、多任务协同运作。<br><br>
             所有协作区的主题事项都可以自定义，如您需要增加协作区主题事项，<br><br>
             请与系统管理员联系。
         </div>
      </div>
    <%}else if(language==8){%>
        <div style="margin-top: 40px;margin-left: 60px;">
         <span style="font-size: 22px;color: #003279;font-weight:900;">Welcome to Co-Work Zone</span>
         <div style="border-top:#003279 solid 1px;width:330px;">
           <div style="color: #00B4FF;margin-left: 40px;font-size: 12px;font-weight: bold" align="right">Welcome to Co-Work Zone</div>
         </div>
         <div style="margin-top: 20px">
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> Coordination </span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> Trans-departmental </span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> Multi-items </span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> Highly effective operation</span>
         </div>
         <div style="margin-top: 20px;width: 650px">
             Note: You may (Co-Work Zone) carry on trans-departmental, the multi-duty coordination operation in the cooperation area .<br><br>
             All cooperation area's subject item may from the definition, if you need to increase the cooperation area subject item ,<br><br>
             Please relate with the system manager .
         </div>
      </div>
    <%}else if(language==9){%>
            <div style="margin-top: 40px;margin-left: 60px;width: 400px">
         <span style="font-size: 22px;color: #003279;font-weight:900;">歡迎進入系統工作區</span>
         <div style="border-top:#003279 solid 1px;width:300px;">
           <div style="color: #00B4FF;margin-left: 40px;font-size: 12px;font-weight: bold" align="right">Welcome to Co-Work Zone</div>
         </div>
         <div style="margin-top: 20px">
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> 協同</span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> 跨部門</span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> 多事項</span>
	         <span style="color: #009A07;font-size: 12px;margin-right: 20px"><img src="/cowork/images/point_wev8.gif" align="absmiddle"> 高效運作</span>
         </div>
         <div style="margin-top: 20px">
             注：您可在協作區(Co-Work Zone)進行跨部門、多任務協同運作。<br><br>
             所有協作區的主題事項都可以自定義，如您需要增加協作區主題事項<br><br>
             請與管理員聯繫。 
          </div>
      </div>
    <%} %>
    -->
 </BODY>
</HTML>
