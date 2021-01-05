
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
 request.setCharacterEncoding("UTF-8");
 BlogDao blogDao=new BlogDao();
 String listType=request.getParameter("listType");
 String keyworkd=Util.null2String(request.getParameter("keyworkd"));
 keyworkd = URLDecoder.decode(keyworkd,"UTF-8");
 String searchUserName = Util.null2String(request.getParameter("searchUserName"));
 searchUserName =  URLDecoder.decode(searchUserName,"UTF-8");
 String itemType =  Util.null2String(request.getParameter("itemType"));
 String userid=""+user.getUID();
 int departmentid=user.getUserDepartment();   //用户所属部门
 int subCompanyid=user.getUserSubCompany1();  //用户所属分部
 String seclevel=user.getSeclevel();          //用于安全等级
 String sqlStr="";
%>

 <%if(listType.equals("attention")){
	int pagesize=Util.getIntValue(request.getParameter("pagesize"),30);
	int total=Util.getIntValue(request.getParameter("total"),30);
	int currentpage=Util.getIntValue(request.getParameter("currentpage"),1);
	Map conditions=new HashMap();
	conditions.put("userName",searchUserName);
	conditions.put("itemType", itemType);
	List attentionList=blogDao.getAttentionMapList(userid,currentpage,pagesize,total,"",conditions);
    if(attentionList.size()>0){
 %>

<%
    for(int i=0;i<attentionList.size();i++){
      Map map=(Map)attentionList.get(i);	
      String attentionid=(String)map.get("attentionid");
      String isnew=(String)map.get("isnew");
      String username=(String)map.get("username");
      String deptName=(String)map.get("deptName");
      String jobtitle=(String)map.get("jobtitle");
      String islower=(String)map.get("islower");
%>
  <div class="blogItem" onclick="openBlog(<%=attentionid%>,1,this)">
 	<div class="blogItemdiv">
 		<div class="headdiv">
	       	<!--<img width="40px" height="40px" src="<%=ResourceComInfo.getMessagerUrls(attentionid)%>">-->
			<%=weaver.hrm.User.getUserIcon(attentionid,"width: 40px; height: 40px;cursor: pointer;line-height: 40px;border-radius:30px;") %>
	       	<div class="headbg"></div>
	    </div>
	  	<div class="left m-l-10">
	  		<div class="h-l-24 h-24 w-195">
	  			<div class="left">
	  				<span style="color:#242425"><%=username%></span>
		  			<%if(isnew.equals("1")){%>
		  				<img class="newimg" src="/images/ecology8/statusicon/BDNew_wev8.png">
		  			<%}%>
	  			</div>
		        <div class="right">
		        	<button class="blogbtn whiteBtn hide" onclick="disAttention(this,<%=attentionid%>,<%=islower%>,event);" type="button" status="cancel" style="width:75px;">
	           			<label id="btnLabel"><span class='add'>-</span><%=SystemEnv.getHtmlLabelName(24957,user.getLanguage())%></label>
	           		</button>
		        </div>
		        <div class="clear"></div>
	  		</div>
	  		<div class="h-l-20 h-20">	
	  			<div class="w-195 ellipsis" style="color:#5c5c5c;">
		  			<span title="<%=deptName%>"><%=deptName%></span>&nbsp;&nbsp;<span title="<%=jobtitle%>"><%=jobtitle%></span>
	  			</div>
	  		</div>
	  	</div>
	  	<div class="clear"></div>
 	</div>
  </div>
  <%} %>
  <%}else
	  out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(26963,user.getLanguage())+"</div>");  //当前没有关注的人
  %> 
<%}else if(listType.equals("searchList")||listType.equals("canview")){ 
	String allowRequest=blogDao.getSysSetting("allowRequest");   //系统申请设置情况
	Map conditions=new HashMap();
	conditions.put("keyworkd",searchUserName);
	conditions.put("itemType", itemType);
    List blogList=blogDao.getBlogMapList(userid,listType,conditions);
   if(blogList.size()>0){
%> 
		  <%
		    ResourceComInfo resourceComInfo=new ResourceComInfo();
		    DepartmentComInfo departmentComInfo=new DepartmentComInfo();
		    String trClass="";
		    for(int i=0;i<blogList.size();i++){
		      Map map=(Map)blogList.get(i);	
		      String attentionid=(String)map.get("attentionid");
		      
		      if(attentionid.equals(userid)) continue;
		      
		      String isnew=(String)map.get("isnew");
		      String isshare=(String)map.get("isshare");//主动共享
		      String isSpecified=(String)map.get("isSpecified"); //指定共享
		      String isattention=(String)map.get("isattention");
		      String islower=(String)map.get("islower");
		      String iscancel=(String)map.get("iscancel");
		      String jobtitle=(String)map.get("jobtitle");
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
		    	  sqlStr="select isReceive from blog_setting where userid="+attentionid;
		    	  recordSet2.execute(sqlStr);
		    	  if(recordSet2.next())
		    		 isReceive=recordSet2.getInt("isReceive");
		    	  if(isReceive==0)
		    		 status="-1";             //不允许申请
		    	  if(allowRequest.equals("0"))
		    		  status="-1";             //系统设置为不允许申请
		      }	  
		      String username=resourceComInfo.getLastname(attentionid);
		      String deptName=departmentComInfo.getDepartmentname(resourceComInfo.getDepartmentID(attentionid));
		  %>
			  <div class="blogItem" onclick="openBlog(<%=attentionid%>,1,this)" _status="<%=status%>">
			 	<div class="blogItemdiv">
			 		<div class="headdiv">
				       	<!--<img width="40px" height="40px" src="<%=ResourceComInfo.getMessagerUrls(attentionid)%>">-->
						<%=weaver.hrm.User.getUserIcon(attentionid,"width: 40px; height: 40px;cursor: pointer;line-height: 40px;border-radius:30px;") %>
				       	<div class="headbg"></div>
				    </div>
				  	<div class="left m-l-10">
				  		<div class="h-l-24 h-24 w-195">
				  			<div class="left">
				  				<span style="color:#242425"><%=username%></span>
					  			<%if(isnew.equals("1")){%>
					  				<img class="newimg" src="/images/ecology8/statusicon/BDNew_wev8.png">
					  			<%}%>
				  			</div>
					        <div class="right">
					        	<%if(status.equals("0")){%>
									   <button class="blogbtn whiteBtn hide" id="cancelAttention" onclick="disAttention(this,<%=attentionid%>,<%=islower%>,event);" type="button" status="apply" style="width:75px;">
							           		<label id="btnLabel"><span class='add'>√</span><%=SystemEnv.getHtmlLabelName(26941,user.getLanguage())%></label>
							           </button>
							    <%}else if(status.equals("1")){%>
								       <button class="blogbtn whiteBtn hide" id="cancelAttention" onclick="disAttention(this,<%=attentionid%>,<%=islower%>,event);" type="button" status="apply" style="width:75px;">
							           		<label id="btnLabel"><span class='add'>√</span><%=SystemEnv.getHtmlLabelName(26941,user.getLanguage())%></label>
							           </button>
							    <%}else if(status.equals("2")){%>
								       <button class="blogbtn whiteBtn hide" id="cancelAttention" onclick="disAttention(this,<%=attentionid%>,<%=islower%>,event);" type="button" status="cancel" style="width:75px;">
							           		<label id="btnLabel"><span class='add'>-</span><%=SystemEnv.getHtmlLabelName(24957,user.getLanguage())%></label>
							           </button>
							    <%} %>
					        </div>
					        <div class="clear"></div>
				  		</div>
				  		<div class="h-l-20 h-20">	
				  			<div class="w-195 ellipsis" style="color:#5c5c5c;">
					  			<span title="<%=deptName%>"><%=deptName%></span>&nbsp;&nbsp;<span title="<%=jobtitle%>"><%=jobtitle%></span>
				  			</div>
				  		</div>
				  	</div>
				  	<div class="clear"></div>
			 	</div>
			  </div>
		 <%} %>	
  
  <%}else
	  out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");  
  %> 
   <%}else if(listType.equals("hrmOrg")){ %>
    <script>
	 jQuery(document).ready(function(){
	       $("#hrmOrgTree").addClass("hrmOrg"); 
	       $("#hrmOrgTree").treeview({
	          url:"hrmOrgTree.jsp"
	       });
	 });
    </script> 
    <ul id="hrmOrgTree" style="width: 100%"></ul>
    
   <%}%>

