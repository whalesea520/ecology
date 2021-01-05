
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.MessageFormat"%>
<%@page import="weaver.hrm.job.JobActivitiesComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.AppDao"%>
<%@page import="weaver.blog.AppItemVo"%>
<%@page import="weaver.blog.AppVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css"> 
<link rel=stylesheet href="/css/Weaver_wev8.css" type="text/css" />
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
<script type="text/javascript" src="/weaverEditor/kindeditor-Lang_wev8.js"></script>
<script type='text/javascript' src='js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='js/timeline/easing_wev8.js'></script>
<script type='text/javascript' src='js/highlight/jquery.highlight_wev8.js'></script>
<link href="js/weaverImgZoom/weaverImgZoom_wev8.css" rel="stylesheet" type="text/css">
<script src="js/weaverImgZoom/weaverImgZoom_wev8.js"></script>

<script type="text/javascript" src="js/raty/js/jquery.raty_wev8.js"></script>

<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad_wev8.js"></script>
<jsp:include page="blogUitl.jsp"></jsp:include>
<%

String blogid=Util.null2String(request.getParameter("blogid"));   //要查看的微博id
String userid=""+user.getUID();
BlogDao blogDao=new BlogDao();
BlogShareManager shareManager=new BlogShareManager();
int status=shareManager.viewRight(blogid,userid); //微博查看权限
AppDao appDao=new AppDao();
List appItemVoList=appDao.getAppItemVoList("mood");

Calendar calendar=Calendar.getInstance();
int currentMonth=calendar.get(Calendar.MONTH)+1;
int currentYear=calendar.get(Calendar.YEAR);

BlogReportManager reportManager=new BlogReportManager();
reportManager.setUser(user);

Date today=new Date();
Date startDateTmp=new Date();
SimpleDateFormat frm=new SimpleDateFormat("yyyy-MM-dd");
String curDate=frm.format(today);    //当前日期
startDateTmp.setDate(startDateTmp.getDate()-30);
String startDate=frm.format(startDateTmp);
String enableDate=blogDao.getSysSetting("enableDate");         //微博启用日期 
String attachmentDir=blogDao.getAttachmentDir();   //附件上传目录
if(frm.parse(enableDate).getTime()>frm.parse(startDate).getTime()){
	startDate=enableDate;
}

List tempList=blogDao.getTemplate(""+user.getUID());
String tempContent="";
int isUsedTemp=0;
if(tempList.size()>0){
	isUsedTemp=1;
	tempContent=(String)((Map)tempList.get(0)).get("tempContent");
}
String from=Util.null2String(request.getParameter("from"));
%>
<title><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%>:<%=ResourceComInfo.getLastname(blogid)%></title>
</head>
<body style="margin: 0px;padding: 0px;"> 
<%@ include file="/blog/uploader.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="warn">
	<div class="title"></div>
</div>

<div id="blogLoading" class="loading" align='center'>
	<div id="loadingdiv" style="right:260px;">
		<div id="loadingMsg">
			<div><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%></div>
		</div>
	</div>
</div>

<div id="myBlogdiv" style="width:100%;height: 100%;min-width:600px;">
   <%
  //如果status=0则不具有查看权限 status=-1 不能查看且不允许申请
   if (status>0||userid.equals(blogid)) {
 
       blogDao.addReadRecord(userid,blogid); //添加已读记录
       blogDao.addVisitRecord(userid,blogid);
       
       //删除被查看用户的更新提醒
       String sql="delete from blog_remind where remindType=6 and remindid="+userid+" and relatedid="+blogid;
	   RecordSet recordSet=new RecordSet();
	   recordSet.execute(sql);
       
   %>
	<div class="personalInfo">
		<div class="logo">
			<img width="80px" src="<%=ResourceComInfo.getMessagerUrls(blogid) %>">
		</div>
		<div class="sortInfo" style="width:340px">
			<div class="sortInfoTop"  style="padding-top:8px">
			  <div class="left">
			    <a href="/hrm/resource/HrmResource.jsp?id=<%=blogid%>" target="_blank" style="font-weight: bold;color: #007FCB"><%=ResourceComInfo.getLastname(blogid) %></a>
			    <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=ResourceComInfo.getDepartmentID(blogid)%>" target="_blank" style="margin-left: 8px"><%=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(blogid)) %></a>
			  </div>
			  <div class="actions left" style="margin-left:80px;float: left;">
				     <a class="btnEcology" id="addAttention" href="javascript:void(0)" onclick="addAttention_blogview(<%=status%>)" status="<%=status%>" style="margin-right: 8px;display: <%=status==1||status==2?"":"none"%>">
						<div class="left" style="width:68px;color: #666"><span id="btnLabel" ><span style="font-size: 13px;font-weight: bolder;margin-right: 3px">+</span><%=SystemEnv.getHtmlLabelName(26939,user.getLanguage())%></span></div><!-- 添加关注 -->
						<div class="right"> &nbsp;</div>
				     </a>
				     <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention_blogview(<%=status%>)" status="<%=status%>" style="margin-right: 8px;display: <%=status==3||status==4?"":"none"%>">
						<div class="left" style="width:68px;color: #666"><span ><span style="font-size: 13px;font-weight: bolder;margin-right: 3px">-</span><%=SystemEnv.getHtmlLabelName(24957,user.getLanguage())%></span></div><!-- 取消关注 -->
						<div class="right"> &nbsp;</div>
				     </a>
			   </div>
			   <div class="clear"></div>
			</div>
			<div>
			  <table width="100%">
			    <tr>
			       <td width="180px" valign="top">
					   <span style="color: #666">
					     <!-- 工作指数 -->
							 <div class="h-19 l-h-19"><%=SystemEnv.getHtmlLabelName(26929,user.getLanguage())%>：<span id="workIndexCount" title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="workIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></div><!-- 未提交 应提交 -->
							 <%if(appDao.getAppVoByType("mood").isActive()){ 
							 %>
							 <!-- 心情指数 -->
							 <div class="h-19 l-h-19"><%=SystemEnv.getHtmlLabelName(26930,user.getLanguage())%>：<span id="moodIndexCount" title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="moodIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></div><!-- 不高兴 高兴 -->
							 <%}%>
							 <% String isSignInOrSignOut=Util.null2String(blogDao.getIsSignInOrSignOut(user));//是否启用前到签退功能
							    if(isSignInOrSignOut.equals("1")){
							 %>
							 <!-- 考勤指数 -->
							 <div class="h-19 l-h-19"><%=SystemEnv.getHtmlLabelName(26931,user.getLanguage())%>：<span id="scheduleIndexCount" title="<%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(20079,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="scheduleIndex" style="font-weight: bold;margin-left: 8px;color: #666666">0.0</span></div><!-- 旷工 迟到 -->
						     <%} %>
					   </span>
			    </td>
			    <td>
			           <!-- 上级 -->
			           <div class="ellipsis h-19 l-h-19" style="color: #666666;width:155px;"><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>：<a href="/hrm/resource/HrmResource.jsp?id=<%=ResourceComInfo.getManagerID(blogid)%>" target="_blank" style="color: #007FCB"><%=ResourceComInfo.getLastname(ResourceComInfo.getManagerID(blogid))%></a></div>
			           <!-- 电话 -->
			           <div class="ellipsis h-19 l-h-19" style="color: #666666;width:155px;" title="<%=ResourceComInfo.getTelephone(blogid)%>"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>：<%=ResourceComInfo.getTelephone(blogid)%></div>
			           <!-- 手机 -->
			           <div class="ellipsis h-19 l-h-19" style="color: #666666;width:155px;" title="<%=ResourceComInfo.getMobile(blogid)%>"><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%>：<%=ResourceComInfo.getMobile(blogid)%></div>
			    </td>
			    </tr>
			  </table>
			   
			</div>
	    </div>
		
		<div class="right">
			<%
			String blogCount=""+blogDao.getMyBlogCount(blogid);               //微博总数
			String myAttentionCount=""+blogDao.getMyAttentionCount(blogid,"all");   //我关注的人总数
			String attentionMeCount=""+blogDao.getAttentionMe(blogid).size();        //关注我的人总数
			
			%>
			<div class="nav1" style="position:relative;border-top:0px;border-bottom:0px;margin-top:45px;">
					<div onclick="showItem(0)" class="item1 left" style="width:75px;padding-bottom:0px;">
						<div class="left">
							<img src="/blog/images/icon_blog_wev8.png">
						</div>
						<div class="left m-l-5">	
							<div style="color:#9b9b9b"><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%></div>
							<div><%=blogCount%></div>
						</div>
						<div class="clear"></div>
					</div>
					
					<div onclick="showItem(2)" class="item1 left" style="width:75px;padding-bottom:0px;">
						<div class="left">
							<img src="/blog/images/icon_attention_wev8.png">
						</div>
						<div class="left m-l-5">
							<div style="color:#9b9b9b"><%=SystemEnv.getHtmlLabelName(25436,user.getLanguage())%></div>
							<div><%=myAttentionCount%></div>
						</div>
						<div class="clear"></div>
					</div>
					
					<div onclick="showItem(3)" class="item1 left" style="width:74px;padding-bottom:0px;">
						<div class="left">
							<img src="/blog/images/icon_fans_wev8.png">
						</div>
						<div class="left m-l-5">
							<div style="color:#9b9b9b"><%=SystemEnv.getHtmlLabelName(33309,user.getLanguage())%></div>
							<div><%=attentionMeCount%></div>
						</div>
						<div class="clear"></div>
					</div>
					<div class="clear"></div>
				</div>
		</div>
		
		<div class="clear"></div>
	</div>

	<%
	  String blogTabName=SystemEnv.getHtmlLabelName(27011,user.getLanguage());//他的微博blogid
	  String reportTabName=SystemEnv.getHtmlLabelName(27012,user.getLanguage()); //他的报表
	  String myAttentionTabName=SystemEnv.getHtmlLabelName(27013,user.getLanguage());//他关注的
	  String attentionMeTabName=SystemEnv.getHtmlLabelName(27014,user.getLanguage()); //关注他的
	  if(userid.equals(blogid)){
		  blogTabName=SystemEnv.getHtmlLabelName(26468,user.getLanguage()); //我的微博
		  reportTabName=SystemEnv.getHtmlLabelName(18040,user.getLanguage()); //我的报表
		  myAttentionTabName=SystemEnv.getHtmlLabelName(26933,user.getLanguage());//我关注的
		  attentionMeTabName=SystemEnv.getHtmlLabelName(26940,user.getLanguage()); //关注我的
	  }else if(ResourceComInfo.getSexs(blogid).equals("1")){
		  blogTabName=SystemEnv.getHtmlLabelName(27015,user.getLanguage()); //她的微博
		  reportTabName=SystemEnv.getHtmlLabelName(27016,user.getLanguage()); //她的报表
		  myAttentionTabName=SystemEnv.getHtmlLabelName(27017,user.getLanguage());//她关注的
		  attentionMeTabName=SystemEnv.getHtmlLabelName(27018,user.getLanguage()); //她注我的
	  }
	%>
	
	<div class="tabStyle2" id="attentionMenu" style="padding-left:0px;margin-top:0px;">
		<!-- 关注 -->
		<div class="tabitem select2" id="blog" url="discussList.jsp?blogid=<%=blogid %>&requestType=myblog">
			<div class="title"><A href="javascript:void(0)"><%=blogTabName%></A></div>
			<div class="arrow"></div>
		</div>
		<!-- 粉丝 -->
		<div class="tabitem" id="report" url="myBlogReport.jsp?from=view&userid=<%=blogid%>">
			<div class="title"><A href="javascript:void(0)"><%=reportTabName%></A></div>
			<div class="arrow"></div>
		</div>
		<div class="tabitem" url="myAttentionHrm.jsp?from=view&userid=<%=blogid%>">
			<div class="title"><A href="javascript:void(0)"><%=myAttentionTabName%></A></div>
			<div class="arrow"></div>
		</div>
		<div class="tabitem" url="attentionMeHrm.jsp?from=view&userid=<%=blogid%>">
			<div class="title"><A href="javascript:void(0)"><%=attentionMeTabName%></A></div>
			<div class="arrow"></div>
		</div>
		<div class="clear"></div> 
	</div>
	
	<div class="reportBody" id="reportBody" style="width: 100%">
			
	</div>
	<%}else if(status==-1||status==0){%>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="blog"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(26469,user.getLanguage()) %>"/>
	</jsp:include>
	<%
		Object object[]=new Object[1];
		object[0]="<a href='/hrm/resource/HrmResource.jsp?id="+blogid+"' target='_blank' style='font-weight: bold;text-decoration: underline !important;'>"+ResourceComInfo.getLastname(blogid)+"</a>";
	    String message=MessageFormat.format(SystemEnv.getHtmlLabelName(27019,user.getLanguage()),object);
	    if(status==0)
	    	message=MessageFormat.format(SystemEnv.getHtmlLabelName(27020,user.getLanguage()),object);
	%>
        <div style="margin-top: 40px;text-align: center;">
            <%=message%>
            <%if(status==0){%>
            	<a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="doAttention(this,<%=blogid%>,0,event);" status="apply" style="margin-right: 8px;">
					<div class="left" style="width:68px;color: #666;font-weight: normal !important;padding-left: 0px"><span id="btnLabel"><span class="apply">√</span><%=SystemEnv.getHtmlLabelName(26941,user.getLanguage())%></span></div><!-- 申请关注 -->
					<div class="right"> &nbsp;</div>
		   		</a>
            <%}%>
        </div>
    <%}else if(status==0) {
    	Object object[]=new Object[1];
		object[0]="<a href='/hrm/resource/HrmResource.jsp?id="+blogid+"' target='_blank' style='font-weight: bold;text-decoration: underline !important;'>"+ResourceComInfo.getLastname(blogid)+"</a>";
    	String message=MessageFormat.format(SystemEnv.getHtmlLabelName(27020,user.getLanguage()),object);
    %>
        <div style="margin-top: 40px;text-align: center;">
           <%=message%>
           <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="doAttention(this,<%=blogid%>,0,event);" status="apply" style="margin-right: 8px;">
				<div class="left" style="width:68px;color: #666;font-weight: normal !important;padding-left: 0px"><span id="btnLabel"><span class="apply">√</span><%=SystemEnv.getHtmlLabelName(26941,user.getLanguage())%></span></div><!-- 申请关注 -->
				<div class="right"> &nbsp;</div>
		   </a>
        </div>   
    <%} %>
</div>

<iframe id="downloadFrame" style="display: none"></iframe>
<!-- 微博模版内容 -->
<div id="templatediv" style="position: absolute;left: -1000;top: -10000;display:<%=userid.equals(blogid)?"":"none"%>">
  <%=tempContent%>
</div>
<div class="editorTmp" style="display:none">
<table style="width: 100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		 <textarea name="submitText" scroll="none" style="border: solid 1px;width:100%"></textarea>
		</td>
	</tr>
	<tr>
		<td>
			<div class="appItem_bg">
	   	    <%
		   	    List appVoList=appDao.getAppVoList();
		   	 	for(int i=0;i<appVoList.size();i++){
		   	 		AppVo appVo=(AppVo)appVoList.get(i);
		   	 		if("mood".equals(appVo.getAppType())){
		   	 		if(appItemVoList!=null&&appItemVoList.size()>0){ 
				   		AppItemVo appItemVo1=(AppItemVo)appItemVoList.get(0);
				   		
				   		String itemType1=appItemVo1.getType();
		  				String itemName1=appItemVo1.getItemName();
		  				if(itemType1.equals("mood"));
		  				   itemName1=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName1),user.getLanguage());
			 %>
			   <!-- 心情 -->
			   <div class="optItem" style="width:50px;position: relative;margin-left:5px;">
				  <div id="mood_title" class="opt_mood_title" style="background: url('<%=appItemVo1.getFaceImg()%>') no-repeat left center;"  onclick="show_select('mood_title','mood_items','qty_<%=appItemVo1.getType() %>','mood',event,this)">
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(26920,user.getLanguage())%></a><!-- 心情 -->
				  </div>
				  <div id="mood_items" style="display:none" class="opt_items">
				  		<%
				  			for(int j=0;j<appItemVoList.size();j++) {
				  				AppItemVo appItemVo= (AppItemVo)appItemVoList.get(j);
				  				String itemType=appItemVo.getType();
				  				String itemName=appItemVo.getItemName();
				  				if(itemType.equals("mood"));
				  				   itemName=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName),user.getLanguage());
				  		%>
					   		<div class='qty_items_out'  val='<%=appItemVo.getId() %>'><img src="<%=appItemVo.getFaceImg() %>" alt="<%=itemName%>" width="16px" align="absmiddle" style="margin-right:3px;margin-left:2px"><%=itemName%></div>
					   <%} %>
				  </div> 
				  <input name="qty_<%=appItemVo1.getType() %>" class="qty" type="hidden" id="qty_<%=appItemVo1.getType() %>" value="<%=appItemVo1.getId() %>" />
			   </div>
				
		   	 <%} 
	   	   }else if("attachment".equals(appVo.getAppType())){
	   	 %>
	   	    <!-- 附件 -->
	   	    <div class="optItem" style="width: 120px;position: relative;">
			  <div id="temp_title" style="width: 120px" class="opt_title" onclick="openApp(this,'')">
			   <%
			   if(attachmentDir!=null&&!attachmentDir.trim().equals("")){ 
				   RecordSet recordSet=new RecordSet();
				   recordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+attachmentDir);
				   recordSet.next();
				   String maxsize = Util.null2String(recordSet.getString(1));
			   %>
			    <a href="javascript:void(0)"><div class="uploadDiv" mainId="" subId="" secId="<%=attachmentDir%>" maxsize="<%=maxsize%>"></div></a>
			   <%}else{ %>
			    <span style="color: red"><%=SystemEnv.getHtmlLabelName(83157,user.getLanguage())%></span>
			   <%} %>
			  </div>
		  </div>
	   	 <%}else{ %>
			  <div class="optItem">
				  <div class="title" style="background: url('<%=appVo.getIconPath() %>') no-repeat left center;" class="opt_title" onclick="openApp(this,'<%=appVo.getAppType() %>')">
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(Integer.parseInt(appVo.getName()),user.getLanguage()) %></a>
				  </div>
	
			  </div>
		  <%}} %>
		  
		  	 <div style="float:right;vertical-align: middle;margin-right:5px;" >
				    <!-- 保存 -->
					<button type="button" class="submitButton" onclick="saveContent(this)"><%=SystemEnv.getHtmlLabelName(33848,user.getLanguage())%></button>
					<!-- 取消 -->
					<button type="button" class="editCancel" onclick="editCancel(this);"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
			 </div>
		  
			 <div class="clear"></div>
		</div>
	</td>
	</tr>
	</table>
</div>
</body>
</html>
<script>

    var tempHeight=0;      //微博模版高度
    var isUsedTemp=<%=isUsedTemp%>;  //是启用模版

    //跳转到我的微博
	function toMyBlog(){
	   if(jQuery(window.parent.document).find("#blogList").is(":hidden"))
	      window.location.href='myBlog.jsp'; 
	   else
	      window.parent.location.href='blogView.jsp';   
	}
	
	function showItem(index){
		$("#attentionMenu .tabitem:eq("+index+")").click();
	}
    
    //跳转到我的关注
    function toMyAttention(){
       if(jQuery(window.parent.document).find("#blogList").is(":hidden"))
          window.parent.location.href='blogView.jsp?item=attention';
	   else
	      window.location.href='myAttention.jsp'; 
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

function disAttention_blogview(status){
    var itemName="<%=ResourceComInfo.getLastname(blogid)%>";
    var islower=0;
	if(status==4||status==2) islower=1;
	jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid=<%=blogid%>");
	jQuery("#cancelAttention").hide();
	jQuery("#addAttention").show();    
}

function addAttention_blogview(status){
    var itemName="<%=ResourceComInfo.getLastname(blogid)%>";
    var islower=0;
    if(status==4||status==2) islower=1;
    if(islower == 1) {
        jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid=<%=blogid%>");
        jQuery("#cancelAttention").show();
        jQuery("#addAttention").hide();  
    } else if(islower == 0) {
        var obj = document.getElementById("addAttention");
        if(jQuery(obj).attr("isApply") != "true"){
            jQuery.post("blogOperation.jsp?operation=requestAttention&attentionid=<%=blogid%>",function(){
            jQuery(obj).find("#btnLabel").html("<span class='apply'>√</span><%=SystemEnv.getHtmlLabelName(18659,user.getLanguage())%>");
            jQuery(obj).attr("isApply","true");
            alert("<%=SystemEnv.getHtmlLabelName(27084,user.getLanguage())%>");//申请已经发送
        }); 
        }else{
             alert("<%=SystemEnv.getHtmlLabelName(27084,user.getLanguage())%>");//申请已经发送
        }
    }
}


function requestAttention(obj,attentionid,attentionName,islower){
	 jQuery.post("blogOperation.jsp?operation=requestAttention&islower="+islower+"&attentionid="+attentionid,function(){
	   alert("<%=SystemEnv.getHtmlLabelName(27084,user.getLanguage())%>"); //申请已经发送
	 });
}
    
jQuery(function(){
	jQuery(".tabStyle2 .tabitem").click(function(obj){
			jQuery(".tabStyle2 .tabitem").each(function(){
				jQuery(this).removeClass("select2");
			});
			jQuery(this).addClass("select2");
			var url=jQuery(this).attr("url");
			var tabid=jQuery(this).attr("id");
			
			/*
			if(tabid=="blog")
			   jQuery("#searchDiv").show();
			else
			   jQuery("#searchDiv").hide();   
			*/
			displayLoading(1,"page"); 
			jQuery.post(url,{},function(a){
				jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
				
				//显示今天编辑器
				jQuery(".editor").each(function(){
				 if(jQuery(this).css("display")=="block"){
					 showAfterSubmit(this);
					}
			    });
				    
				if(tabid=="blog"){
				    //图片缩小处理   
					jQuery('.reportContent img').each(function(){
					    initImg(this);
					});
					
					//上级评分初始化
					jQuery(".blog_raty").each(function(){
					   if(jQuery(this).attr("isRaty")!="true"){
					       managerScore(this);
					       jQuery(this).attr("isRaty","true"); 
			           }
					})
					
					//显示第一条工作微博系统操作记录
					var blogItem=jQuery(".reportItem[istoday='false']:first");
					var workdate=blogItem.attr("fordate");
					if(workdate)
					    showLog(blogItem.find(".showlog")[0],<%=blogid%>,workdate);    
				    	    
				}else if(tabid=="report"){  
				    jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
				}
				
				changeIframeHeight();
				
				displayLoading(0);
			});
		});
		displayLoading(0);
		if(<%=status%>>0||<%=userid%>==<%=blogid%>){
		    displayLoading(1,"page"); 
		    jQuery(".tabStyle2 .tabitem:first").click();
		    getIndex(<%=blogid%>); 
		}
		jQuery(document.body).bind("click",function(){
			jQuery(".dropDown").hide();
			jQuery(".opt_items").hide();
	    });
	    
	    notepad('.reportContent'); //微博便签选取数据
});

   //添加到收藏夹
    function openFavouriteBrowser(){
	   var url=window.location.href;
	   fav_uri=url.substring(url.indexOf("/blog/"),url.length)+"&";
	   fav_uri = escape(fav_uri); 
	   var fav_pagename=jQuery("title").html();
	   fav_pagename = encodeURI(fav_pagename); 
	   window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=&mouldID=doc");
    }	
    
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>

