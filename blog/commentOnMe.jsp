
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogReplyVo"%>
<%@page import="weaver.blog.AppDao"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
 <div id="commentDiv">
 </div>
<script type="text/javascript">
  jQuery.post("discussList.jsp?requestType=commentOnMe",function(data){
     jQuery("#commentDiv").html(data);
     //初始化处理图片
     jQuery('.reportContent img').each(function(){
		initImg(this);
     });
	 //上级评分初始化
	 jQuery(".blog_raty").each(function(){
	   managerScore(this);
	   jQuery(this).attr("isRaty","true"); 
	 });
     jQuery("#commentcount").hide();
     jQuery.post("blogOperation.jsp?operation=markCommentRead"); //删除评论提醒
  }); 
</script>



