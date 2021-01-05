<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="java.text.MessageFormat"%>

<%@include file="/systeminfo/init_wev8.jsp" %>
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>
<html>
<head>
    <link href="/blog/css/blog_wev8.css" type="text/css" rel="stylesheet" />
    <style>
        body{ height:auto; font-size: 12px;}
    </style>
    <script>
         function delMsg(msgid,remindType){
             jQuery.post("blogOperation.jsp?operation=delMsg&msgid="+msgid+"&remindType="+remindType);
             jQuery("#msg_"+msgid).remove();
             jQuery("#remindcount").text(jQuery("#remindcount").text()-1);
         }
    </script>
</head>
<body>
<%
    String titlename=SystemEnv.getHtmlLabelName(19085,user.getLanguage());
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15148,user.getLanguage()) %>"/>
</jsp:include>

    <div class="zDialog_div_content" style="height:320px;">
<%
    String userid=""+user.getUID();
    BlogDao blogDao=new BlogDao();
    SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat dateFormat2=new SimpleDateFormat("M月d日");
    
    List remindList=blogDao.getMsgRemidList(user,"remind",""); 
%>
<%if(remindList.size()>0){ %>
	<div style="text-align: left; padding-left: 20px; padding-top: 10px;" class="msgContainer">
<%
     for(int i=0;i<remindList.size();i++){ 
        Map map=(Map)remindList.get(i);
        
        String id=(String)map.get("id");
        String remindType=(String)map.get("remindType");
        String remindid=(String)map.get("remindid");
        String relatedid=(String)map.get("relatedid");
        String remindValue=(String)map.get("remindValue");
 %>
   <div id="msg_<%=id%>" class="msg" style="width: 95%;border-bottom: #e3eef8 1px solid;margin-bottom: 8px;clear: both;height: 22px;background: url('/blog/images/remind_wev8.gif') no-repeat;padding-left: 20px;">
     <div style="text-align: left; float: left; padding-left: 5px;width:100%">
      <%if(remindType.equals("1")) { %>
           <div style="text-decoration: none;float: left;">
			  <FONT class=font><FONT class=font><a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid) %></a>&nbsp;<%=SystemEnv.getHtmlLabelName(26988,user.getLanguage())%></FONT></FONT><!-- 向你申请关注 -->
		   </div>
		   <div style="float: right;">
		       <a style="margin-right: 8px;color: #1d76a4;text-decoration: none;" href="javascript:dealRequest(<%=relatedid%>,<%=id%>,'<%=ResourceComInfo.getLastname(relatedid) %>',-1)"><%=SystemEnv.getHtmlLabelName(25659,user.getLanguage())%></a> <!-- 拒绝 -->
		       <a style="margin-right: 8px;color: #1d76a4;text-decoration: none;" href="javascript:dealRequest(<%=relatedid%>,<%=id%>,'<%=ResourceComInfo.getLastname(relatedid) %>',1)"><%=SystemEnv.getHtmlLabelName(18186,user.getLanguage())%></a> <!-- 同意 -->
		   </div>
      <%}else if(remindType.equals("2")) {%>
         <!-- 关注申请 -->
         <div><a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid)%></a>&nbsp;<%=SystemEnv.getHtmlLabelName(26989,user.getLanguage())%></div><!-- 接受了你的关注请求 -->
       <%}else if(remindType.equals("3")){%>
         <!-- 关注申请拒绝 -->
         <div><a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid)%></a>&nbsp;<%=SystemEnv.getHtmlLabelName(26991,user.getLanguage())%></div>  <!-- 拒绝了你的关注请求 -->
       <%}else if(remindType.equals("8")){
    	   Object object[]=new Object[1];
		   object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+remindValue+"</span>&nbsp;";
    	   String message = MessageFormat.format(SystemEnv.getHtmlLabelName(26995,user.getLanguage()),object);
       %>
         <!-- 微博未提交系统提醒 -->
         <div><%=message %></div>
       <%}else if(remindType.equals("6")){
    	  BlogDiscessVo discessVo=blogDao.getDiscussVo(remindValue);   
    	  if(discessVo==null) continue;
    	  String content=discessVo.getContent();
          String contentHtml=content.replaceAll("<[^>].*?>","");
          String workdate=dateFormat2.format(dateFormat1.parse(discessVo.getWorkdate()));
          Object object[]=new Object[1];
		  object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+workdate+"</span>&nbsp;";
          String message = MessageFormat.format(SystemEnv.getHtmlLabelName(26993,user.getLanguage()),object);
    	%>
    	<!-- 微博提交提醒 -->
         <div>
         <a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid)%></a><%=message%></div>
         <div style="padding-left:5px;padding-right:5px">
         	<a href="viewBlog.jsp?blogid=<%=relatedid%>" style=""><% out.println(content); %></a>
         </div>
       <%}else if(remindType.equals("7")){
    	    remindValue=dateFormat2.format(dateFormat1.parseObject(remindValue));
    	    Object object[]=new Object[1];
  		    object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+remindValue+"</span>&nbsp;";
			String message = MessageFormat.format(SystemEnv.getHtmlLabelName(26994,user.getLanguage()),object);
       %>
         <!-- 微博未提交提交提醒 -->
         <div><a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid)%></a><%=message%></div>
       <%} %>
     </div>
   </div>  
   <%} %>
 </div>   
 
 <script>
   jQuery("#remindcount").hide();
   
   function dealRequest(sender,requestid,name,status){
     if(status==-1){
	     if(window.confirm("<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())+SystemEnv.getHtmlLabelName(25659,user.getLanguage())%>\“"+name+"\”<%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%>")){  //确认拒绝申请  
	        jQuery.post("blogOperation.jsp?operation=dealRequest&sender="+sender+"&requestid="+requestid+"&status="+status);
	        jQuery("#msg_"+requestid).remove();
	        if(jQuery(".msg").length==0)
	           jQuery(".msgContainer").append("<div class='norecord'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></div>");
	     }
	 }else {
	    if(window.confirm("<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())+SystemEnv.getHtmlLabelName(18186,user.getLanguage())%>\“"+name+"\”<%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%>?")){ //确认同意申请
	        jQuery.post("blogOperation.jsp?operation=dealRequest&sender="+sender+"&requestid="+requestid+"&status="+status);
	        jQuery("#msg_"+requestid).remove();
	        if(jQuery(".msg").length==0)
	           jQuery(".msgContainer").append("<div class='norecord'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></div>");
	    } 
	 }
  }
</script>
 <%
       //删除已经查看的提醒
       String sql="delete from blog_remind where remindid="+userid+" and (remindType=2 or remindType=3 or remindType=7 )";
       RecordSet.execute(sql);
       //更新系统未提交提醒状态
       sql="update blog_remind set status=-1  where remindid="+userid+" and remindType=8";
       RecordSet.execute(sql);
       
       sql="update blog_remind set status=1  where remindid="+userid+" and remindType=1";
       RecordSet.execute(sql);
     }else
	   out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
 %>
 </div>
 
 <div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
 
</html>
