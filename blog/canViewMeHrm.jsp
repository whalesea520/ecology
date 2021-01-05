
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>
<%
    String from=Util.null2String(request.getParameter("from"));
    String currentuserid=""+user.getUID();
	String userid=Util.null2String(request.getParameter("userid"));
	BlogShareManager shareManager=new BlogShareManager();  
	List shareList=shareManager.getShareList(userid);
	

if(shareList.size()>0){
%>
<DIV id=footwall_visitme class="footwall" style="width: 100%">
<UL>
<%
for(int i=0;i<shareList.size();i++){
	  String attentionid=(String)shareList.get(i);
	  if(attentionid.equals(currentuserid))
		  continue;
	 
      String username=ResourceComInfo.getLastname(attentionid);
      String deptName=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(attentionid));
%>
  <LI class="LInormal" style="height: 75px">
	<DIV class="LIdiv">
	   <A class=figure href="viewBlog.jsp?blogid=<%=attentionid%>" target=_blank>
		<!--<IMG src="<%=ResourceComInfo.getMessagerUrls(attentionid)%>" width=55  height=55>-->
		<%=weaver.hrm.User.getUserIcon(attentionid,"width: 55px; height: 55px;cursor: pointer;line-height: 55px;border-radius:40px;") %>
		</A>
	    <div style="float: left;padding-top: 10px;padding-left: 10px;overflow: hidden;">
	      <SPAN class=line><A class=name href="viewBlog.jsp?blogid=<%=attentionid%>" target=_blank><%=username%></A></SPAN> 
	      <SPAN class="line gray-time" title="<%=deptName%>"><%=deptName%></SPAN>
	    </DIV>
	</DIV>
  </LI>
<%} %>
</UL>
</DIV>
<div style="margin-top: 10px;text-align: left;color: #666;clear: both;"><%=SystemEnv.getHtmlLabelName(83168,user.getLanguage())%>“<a href="blogSetting.jsp?tabItem=share"><%=SystemEnv.getHtmlLabelName(26630,user.getLanguage())%>--<%=SystemEnv.getHtmlLabelName(26945,user.getLanguage())%></a>”<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></div>
<%
}else
    out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
%>
<script>
  jQuery("#footwall_visitme li").hover(
    function(){
       jQuery(this).addClass("LIhover");
    },function(){
       jQuery(this).removeClass("LIhover");
    }
  );
</script>
<br/>
<br/>      
