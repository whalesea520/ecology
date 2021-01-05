
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
</script>
<%
 String from=Util.null2String(request.getParameter("from"));
 String userid=Util.null2String(request.getParameter("userid"));
 String currentUserid=""+user.getUID();
 BlogDao blogDao=new BlogDao(); 
 SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
 SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日");
 SimpleDateFormat timeFormat=new SimpleDateFormat("HH:mm");

 String departmentid=ResourceComInfo.getDepartmentID(userid);   //用户所属部门
 String subCompanyid=ResourceComInfo.getSubCompanyID(userid);   //用户所属分部
 String seclevel=ResourceComInfo.getSeclevel(userid);           //用于安全等级
 
 String allowRequest=blogDao.getSysSetting("allowRequest");    //系统申请设置情况
 
 BlogShareManager shareManager=new BlogShareManager();
 RecordSet recordSet = new RecordSet();
 String managerstr = "";
 if ("oracle".equals(recordSet.getDBType())) {
 	managerstr = "','||t.managerstr||','";
 } else if ("sqlserver".equals(recordSet.getDBType())) {
 	managerstr = "','+t.managerstr+','";
 } else if ("mysql".equals(recordSet.getDBType())) {
 	managerstr = "CONCAT(',', t.managerstr, ',')";
 }
 
 List blogList=blogDao.getBlogMapList(userid,"attention",null);
 
 if(blogList.size()>0){
%>
<DIV id=footwall_visitme class="footwall" style="width: 100%;float: left;">
<UL>
<%	 
for(int i=0;i<blogList.size();i++){
    Map map=(Map)blogList.get(i);	
    String attentionid=(String)map.get("attentionid");
    
    String isnew=(String)map.get("isnew");
    String isshare=(String)map.get("isshare");//主动共享
    String isSpecified=(String)map.get("isSpecified"); //指定共享
    String isattention=(String)map.get("isattention");
    String islower=(String)map.get("islower");
    String iscancel=(String)map.get("iscancel");
    String status="0";                  //不在共享和关注范围内
    
    if(isshare.equals("1") || isSpecified.equals("1"))                 //在共享范围内
  	  status="1";
    if(status.equals("1")&&isattention.equals("1")) //在关注范围内
  	  status="2";
    if(status.equals("2")&&islower.equals("1")&&iscancel.equals("1"))
  	  status="1";
    
    if(status.equals("0")){
  	  int isReceive=1;
  	  RecordSet recordSet2=new RecordSet();
  	  String sqlStr="select isReceive from blog_setting where userid="+attentionid;
  	  recordSet2.execute(sqlStr);
  	  if(recordSet2.next())
  		 isReceive=recordSet2.getInt("isReceive");
  	  if(isReceive==0)
  		 status="-1";             //不允许申请
  	  if(allowRequest.equals("0"))
  		  status="-1";             //系统设置为不允许申请
    }	  
         
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
		   <SPAN class=line ><A class=name href="viewBlog.jsp?blogid=<%=attentionid%>" target=_blank><%=username%></A></SPAN> 
		   <SPAN class="line gray-time" title="<%=deptName%>"><%=deptName%></SPAN>
	   </div>
	   
	   <div class=info>
	    <div style="float: left;">
			<span style="visibility: hidden; ">相互关注</span>	    
	    </div>
	    <div style="float: left;padding-left: 15px"> 
			<%if(!"view".equals(from)) {%>
	           <button class="grayButton" onclick="disAttention(this,<%=attentionid%>,<%=islower%>,event);" type="button" status="cancel" style="margin-right: 8px;width:65px;display:<%=attentionid.equals(""+user.getUID())?"none":"" %>">
			           		<label id="btnLabel"><span class='add'>-</span><%=SystemEnv.getHtmlLabelName(24957,user.getLanguage())%></span></label>
			   </button>
			  <%} %>
		 </div>
	   </div>	   
	</DIV>
  </LI>
   <%}%> 
</UL>
</DIV>   
<%}else{ 
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
}%>
<script>
  jQuery("#footwall_visitme li").hover(
    function(){
       jQuery(this).addClass("LIhover");
    },function(){
       jQuery(this).removeClass("LIhover");
    }
  );
</script>
<br>
<br>	    
