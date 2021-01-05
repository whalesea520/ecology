
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>
<script>
  function addAttention(attentionid,islower){
      jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid="+attentionid);
      jQuery("#cancelAttention_"+attentionid).show();
      jQuery("#addAttention_"+attentionid).hide();
   }
  function cancelAttention(attentionid,islower){
      jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid="+attentionid);
      jQuery("#cancelAttention_"+attentionid).hide();
      jQuery("#addAttention_"+attentionid).show();
   }
  function requestAttention(obj,attentionid){
    if(jQuery(obj).attr("isApply")!="true"){
      jQuery.post("blogOperation.jsp?operation=requestAttention&attentionid="+attentionid,function(){
         jQuery(obj).find("#btnLabel").html("<span class='apply'>√</span><%=SystemEnv.getHtmlLabelName(18659,user.getLanguage())%>");
         jQuery(obj).attr("isApply","true");
         alert("<%=SystemEnv.getHtmlLabelName(27084,user.getLanguage())%>");//申请已经发送
      });
     }else{
         alert("<%=SystemEnv.getHtmlLabelName(27084,user.getLanguage())%>");//申请已经发送
     }  
   } 
</script>
<%
String from=Util.null2String(request.getParameter("from"));
String userid=""+user.getUID();
String attentionedid=Util.null2String(request.getParameter("userid"));
BlogDao blogDao=new BlogDao();
List attentionList=blogDao.getAttentionMe(attentionedid);
SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日");

BlogShareManager shareManager=new BlogShareManager();

if(attentionList.size()>0){
%>
<DIV id=footwall_visitme class="footwall" style="width: 100%;float: left;">
<UL>
<%	
for(int i=0;i<attentionList.size();i++){
	  String attentionid=(String)attentionList.get(i);
	  int status=shareManager.viewRight(attentionid,userid);
	  String islower="0";
	  if(status==2||status==4) 
		  islower="1";
	  String username=ResourceComInfo.getLastname(attentionid);
      String deptName=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(attentionid));
%>
   <LI class="LInormal">
	<DIV class="LIdiv">
	   <A class=figure href="viewBlog.jsp?blogid=<%=attentionid%>" target=_blank>
	   <!--
	   <IMG src="<%=ResourceComInfo.getMessagerUrls(attentionid)%>" width=55  height=55>
	   -->
	   <%=weaver.hrm.User.getUserIcon(attentionid,"width: 55px; height: 55px;cursor: pointer;line-height: 55px;border-radius:40px;") %>
	   </A>
	   <div style="float: left;padding-top: 10px;padding-left: 10px;overflow: hidden;">
		   <SPAN class=line><A class=name href="viewBlog.jsp?blogid=<%=attentionid%>" target=_blank><%=username%></A></SPAN> 
	       <SPAN class="line gray-time" title="<%=deptName%>"><%=deptName%></SPAN>
	   </div>
	   
	   <div class=info>
	    <div style="float: left;">
			<span style="visibility: hidden; "><%=SystemEnv.getHtmlLabelName(83152,user.getLanguage())%></span>	    
	    </div>
	    <div style="float: left;padding-left: 15px"> 
			<%if(!"view".equals(from)) {%>
			   <button class="blueButton" onclick="disAttention(this,<%=attentionid%>,<%=islower%>,event);" type="button" status="add" style="margin-right: 8px;width:65px;display: <%=status==1||status==2?"":"none"%>">
	           		<label id="btnLabel" style="font-size:12px;"><span class='add'>+</span><%=SystemEnv.getHtmlLabelName(26939,user.getLanguage())%></span></label>
	           </button>
	           
			   <button class="grayButton" onclick="disAttention(this,<%=attentionid%>,<%=islower%>,event);" type="button" status="cancel" style="margin-right: 8px;width:65px;display: <%=status==3||status==4?"":"none"%>">
	           		<label id="btnLabel" style="font-size:12px;"><span class='add'>-</span><%=SystemEnv.getHtmlLabelName(26938,user.getLanguage())%></span></label>
	           </button>
	           
	           <button class="blueButton" onclick="disAttention(this,<%=attentionid%>,<%=islower%>,event);" type="button" status="apply" style="margin-right: 8px;width:65px;display: <%=status==0?"":"none"%>">
	           		<label id="btnLabel" style="font-size:12px;"><span class='add'>√</span><%=SystemEnv.getHtmlLabelName(26941,user.getLanguage())%></span></label>
	           </button>
		        
		    <%} %>
		 </div>
	   </div>	   
	</DIV>
  </LI>
   <%}%>
</UL>
</DIV>      
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
