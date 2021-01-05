
<%@ page language="java"  import="java.util.*" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%
  User user = HrmUserVarify.getUser (request , response) ;
%>
<jsp:useBean id="hotkey" class="weaver.fullsearch.bean.HotKeysBean"/>
<jsp:setProperty name="hotkey" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="hotkey" property="user" value="<%=user%>"/>
<%
   if(user == null){
		user = HrmUserVarify.checkUser(request,response);
   }
   String type = request.getParameter("hotkeystype");
   String showtype = request.getParameter("showType");
   List list = null;
   String divTile = "";
   if("sys".equals(type)){
   	    list = hotkey.setHotKeysRk(-1, 10);
   	    divTile = SystemEnv.getHtmlLabelName(81783,user.getLanguage());
   } else {
   		list = hotkey.setHotKeysRk(user.getUID(), 10);
   		divTile = SystemEnv.getHtmlLabelName(81784,user.getLanguage());
   }
   if(!"cloud".equals(showtype)){
 %>
 
 <div class="apptitle"><div class="apptitle_txt"><%=divTile %></div></div>
 <%
	}
   if(list != null && list.size() > 0){
       for(Object Obj:list){
           String str = (String)Obj;
		   if("cloud".equals(showtype)){
		   %>
		   <a href="javascript:" class="tagc1" title="<%=str%>"><%=str%></a>
		   <%
		   } else {
%>
				<div class="appdetail" title="<%=str%>" onclick="hotkeyclick(this)">
					<div class="appdetail_txt"><%=str%></div>
				</div>	
<% 
			}
       }
   }else{ %>
   
   <span style="LINE-HEIGHT: 26px; MARGIN-LEFT: 20px;FONT-SIZE: 13px;">
   	   <%=SystemEnv.getHtmlLabelName(81790,user.getLanguage()) %>
   </span>

<%}%>