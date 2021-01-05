
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="weaver.file.FileUpload" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />

<%	

int userid=user.getUID();     //用户id

FileUpload fu = new FileUpload(request);
int id=Util.getIntValue(fu.getParameter("id"),0);  //协作id

String needfresh = Util.fromScreen(fu.getParameter("needfresh"),user.getLanguage());//刷新左侧列表变量 1 刷新
//如果id=0跳转到新建页面
if(id==0){
	response.sendRedirect("/cowork/welcome.jsp?needfresh="+needfresh);
	return;
}

boolean canView = false;    //是否具有查看权限
boolean canEdit = false;    //是否具有编辑权限

canView=CoworkShareManager.isCanView(""+id,""+userid,"all");
canEdit=CoworkShareManager.isCanEdit(""+id,""+userid,"all");

//如果不具有查看权限则跳转到无权限页面
if (id>0&&!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return;
}

int docid=Util.getIntValue(Util.null2String(fu.getParameter("docid")),0);//TD5067，从协作区创建文档返回的文档ID
String maintypeid = Util.null2String(fu.getParameter("maintypeid"));
int type=Util.getIntValue(fu.getParameter("type"),0);
int viewall=Util.getIntValue(fu.getParameter("viewall"),0);//是否查看部分讨论记录，0：否,1：是
int isworkflow = Util.getIntValue(Util.null2String(fu.getParameter("isworkflow")),0);
int isreward = Util.getIntValue(Util.null2String(fu.getParameter("isreward")),0);
//int maintypeid = Util.getIntValue(Util.null2String(fu.getParameter("maintypeid")),0);

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。

String view = (String)fu.getParameter("view");

if(isworkflow==1&&id!=0){	
	response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+id);
	return;
}

CoworkDAO dao = new CoworkDAO(id);
CoworkItemsVO vo = dao.getCoworkItemsVO();
String name = Util.null2String(vo.getName());
String levelvalue = Util.null2String(vo.getLevelvalue());
String coworkers = Util.null2String(vo.getCoworkers());
String typeid=Util.null2String(vo.getTypeid());
String begindate = Util.null2String(vo.getBegindate());
String beingtime = Util.null2String(vo.getBeingtime());
String enddate = Util.null2String(vo.getEnddate());
String endtime = Util.null2String(vo.getEndtime());
String remark = Util.null2String(vo.getRemark());
String remarkhtml = Util.StringReplace(Util.toHtml(remark),"\n","<br>");
String isnew = Util.null2String(vo.getIsnew());
String creater = Util.null2String(vo.getCreater());
String status = Util.null2String(vo.getStatus());
String createdate2 = Util.null2String(vo.getCreatedate());
String createtime2 = Util.null2String(vo.getCreatetime());
String principal=Util.null2String(vo.getPrincipal());
String coworkid2=vo.getId();

String logintype = user.getLogintype();

if(status.equals("1") && canView&&dao.getIsRead(""+id,""+userid)){
	PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,9,"0",id);
}

//更新协作查看着

String sql="insert into cowork_read(coworkid,userid) values("+id+","+userid+")";
RecordSet.execute(sql);  //添加查看者记录

//添加日志
Date newdate = new Date();
SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("HH:mm:ss");

String currentdate=dateFormat1.format(newdate);
String currenttime=dateFormat2.format(newdate);

char flag = 2;
String ProcPara = ""+id+flag+"2"+flag+currentdate+flag+currenttime+flag+userid+flag+fu.getRemoteAddr();
RecordSet.executeProc("cowork_log_insert",ProcPara);


int pagesize = 10;//讨论交流每页显示条数
int currentpage =1;

int floorNumber=Util.getIntValue((String)fu.getParameter("floorNum"), 0);
int discussid=Util.getIntValue((String)fu.getParameter("discussid"), 0);

if(floorNumber!=0){
	  int totalsize =dao.getDiscussVOListCount();
	  currentpage=(totalsize-floorNumber)/pagesize+1;
}

int totalsize =dao.getDiscussVOListCount();
int totalpage = totalsize / pagesize;
if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;

%>
<html>
<head>
<script language=javascript src="/js/weaver_wev8.js"></script>
<link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>

<link href="/js/jquery/plugins/weavertabs/weavertabs_wev8.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/plugins/weavertabs/jquery.weavertabs_wev8.js"></script>
<script type="text/javascript">
  var languageid=<%=user.getLanguage()%>;
</script>
<script type="text/javascript" src="/rte/jquery.rte_wev8.js"></script>
<script type="text/javascript" src="/rte/jquery.rte.tb_wev8.js"></script>
<script type="text/javascript" src="/rte/jquery.ocupload-1.1.4_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/rte/jquery.rte_wev8.css" />


<link href="/cowork/css/ViewCoWork_wev8.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/cowork/js/CoWorkView_wev8.js"></script>

<SCRIPT language="VBS" src="/js/browser/ProjectMultiBrowser.vbs"></SCRIPT>
<SCRIPT language="VBS" src="/cowork/js/Cowork.vbs"></SCRIPT>
<script type="text/javascript" src="/cowork/js/scrollTop_wev8.js"></script>

<script type="text/javascript">

</script>
<%@ include file="/cowork/uploader.jsp" %>
<title><%=name%></title>
</head>
<BODY id="ViewCoWorkBody" style="overflow: auto;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canEdit&&id!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:editCowork(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
} 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addCowork(),_self} ";
    RCMenuHeight += RCMenuHeightStep ;
    
if(canEdit&&id!=0){ 
	if(!status.equals("2")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:doEnd(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
    } 
    if(status.equals("2")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(360,user.getLanguage())+",javascript:doOpen(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
    }
}
if(id!=0){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17480,user.getLanguage())+",CoworkLogView.jsp?id="+id+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(!status.equals("2")&&id!=0){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17698,user.getLanguage())+",javascript:doAdd(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(id!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+",javascript:doexport(),_self}";
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 <!-- 提交回复等待 -->
 <div>
	 <DIV id=bg></DIV>
	 <div id="loading">
			<div style=" position: absolute;top: 35%;left: 25%" align="center">
			    <img src="/images/loading2_wev8.gif" style="vertical-align: middle"><label id="loadingMsg"><%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%></label>
			</div>
	 </div>
 </div>
 
 
<%//是否需要刷新协作列表
if(needfresh.equals("1")){
%>
<script language=javascript>
   if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined)
      window.parent.reloadItemListContent();
</script>
<%}%>
 
<form name="frmmain" id="frmmain" method="post" action="CoworkOperation.jsp">
  
  <input type=hidden name="type" value="<%=type%>">
  <input type=hidden name="viewall" value="<%=viewall%>">
  <input type=hidden name="method" id="method" value="doremark">
  <input type=hidden name="id" value="<%=id%>">
  <input type=hidden name="typeid" value="<%=typeid%>">  
  <input type=hidden name="creater" value="<%=creater%>">
  <input type=hidden name="txtPrincipal" value="<%=principal%>">
  
  <input type=hidden name="replayid" id="replayid" value="0">
  <input type=hidden name="floorNum" id="floorNum" value="0">
  <TABLE width="100%" cellpadding="0" cellspacing="0"  class="remarkTable">
	<TR>
		<TD class="lefttopconer"></TD>
		<TD></TD>
		<TD class="righttopconer"></TD>
	</TR>

	<TR>
		<TD></TD>
		<TD>
		  <div id="remarkdiv">
		  		
		      <div>
		         <div>
		            <span style="font-weight: bold;"><%=name%></span>
		            <br>
		            <br>
		            <%=remarkhtml.length()<300?remarkhtml:(remarkhtml.substring(0,300)+"<span id='pointspan'>...</span>")%><span id="remarkhtml" style="display: none"><%=remarkhtml.length()<300?"":remarkhtml.substring(300,remarkhtml.length())%></span>
		         </div>
		         <div style="width: 100%;display: none;margin-top: 10px" id="more">
		             <div  class="weavertabs">
						<table  class="weavertabs-nav" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td target="weavertabs-property" id="property"><%=SystemEnv.getHtmlLabelName(25448,user.getLanguage())%></td><!--相关属性-->
								<td target="weavertabs-condition" id="condition"><%=SystemEnv.getHtmlLabelName(25435,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(622,user.getLanguage())%></td><!--参与情况--> 
								<td target="weavertabs-related" id="related"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6105,user.getLanguage())%></td><!--相关资源-->
							</tr>
						</table>	
						<div style="border-top:#36BDEF solid 2px;"></div>
						<div  class="weavertabs-content">
								   <div id="weavertabs-property" style="overflow: auto;background: white;">
							           <table id=table1 class=ViewForm > 
										    <COLGROUP> 
											<COL width="15%">
											<COL width="35%">
											<COL width="15%">
											<COL width="35%">
										    <tr> 
										        <!-- 创建者 -->
										        <td><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></td>
										    	<td class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%></td>
												<TD><%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%></TD>
											    <TD class=Field>
											        <%=begindate%> <%=beingtime%><%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>&nbsp;<%=enddate%> <%=endtime%> 
											    </td>
										    </tr>
										    <TR><TD class=Line colSpan=8></TD></TR>
										    <tr>
										      <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
										      <td  class=field>
										      	<%=CoTypeComInfo.getCoTypename(typeid)%>       
										      </td>
										      <td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
										    	<td class=Field>
													<span id="spanPrincipal">
														<a href='javaScript:openhrm(<%=principal%>);' onclick='pointerXY(event);'>
														<%=Util.toScreen(ResourceComInfo.getResourcename(principal),user.getLanguage())%></a>
													</span>
												</td>      
										    </tr>
										    <TR><TD class=Line colSpan=8></TD></TR>
		                                 </table>	
								    </div>
									<div id="weavertabs-condition" style="background: white;height: 150px">
									     <iframe src="" id="conditionFrame" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>
									</div>
									<div  id="weavertabs-related" style="background: white;height: 150px">
									     <iframe src="" id="relatedFrame" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>
									</div>
						</div>
		            </div>
		         </div>
		          <div align="right" style="margin-top: 5px;margin-bottom: 5px;">
		             <a class="btnEcology" href="void(0)" onclick="return false;"><div class="left" onclick="showmore(this);return false"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%></div><div class="right" onclick="return false;"> &nbsp;</div></a>&nbsp;<!--查看更多-->
		          </div>
		         <div align="center" style="width: 100%" id="mainremark">
		           <span id="initRemark">
		                <textarea onclick="replay();" class="normal_remark" style="padding-top: 10px"><%=SystemEnv.getHtmlLabelName(20009,user.getLanguage())%>...</textarea>
		           </span>
		         </div>
		      </div>
		  </div> 
  	</TD>
		<TD></TD>
	</TR>
	<TR>
		<TD class="leftbottomconer"></TD>
		<TD></TD>
		<TD class="rightbottomconer"></TD>
	</TR>
</TABLE>

<table width="100%" cellpadding="0" cellspacing="0" style="margin-top: 5px">
	<!-- 分页 -->
	<tr class="pagenav" style="<%if(totalsize==0){ %>display:none<%}%>">
	    <td>
	         <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalsize"><%=totalsize%></span><%=SystemEnv.getHtmlLabelName(24683,user.getLanguage())%> <!-- 共62条记录 -->
	         <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>    <!-- 每页10条 -->
	         <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalpage"><%=totalpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%> <!-- 共7页 -->
	         <%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><span class="currentpage"><%=currentpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%><!-- 当前第1页 --> 
	          <!-- 首页 上一页 下一页 尾页 --> 
			 <A style="<%if(totalpage>1&&currentpage!=1)out.print("cursor:hand;");%>TEXT-DECORATION:none;<%if(totalpage>1&&currentpage!=1)out.print("color:blue");else out.print("color:black");%>" onClick="toFirstPage()" class="FirstPage"><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></A>
			 <A style="<%if(totalpage>1&&currentpage!=1)out.print("cursor:hand;");%>TEXT-DECORATION:none;<%if(totalpage>1&&currentpage!=1)out.print("color:blue");else out.print("color:black");%>" onClick="toPrePage()"   class="PrePage"><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></A>
			 <A style="<%if(totalpage>1&&currentpage!=totalpage)out.print("cursor:hand;");%>TEXT-DECORATION:none;<%if(totalpage>1&&currentpage!=totalpage)out.print("color:blue");else out.print("color:black");%>" onClick="toNextPage()"  class="NextPage"><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></A>
			 <A style="<%if(totalpage>1&&currentpage!=totalpage)out.print("cursor:hand;");%>TEXT-DECORATION:none;<%if(totalpage>1&&currentpage!=totalpage)out.print("color:blue");else out.print("color:black");%>" onClick="toLastPage()"  class="LastPage"><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%></A>
	         <input type="button"  onclick="toGoPage('topagenum1')" value="<%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%>" style="cursor: pointer;height: 18px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input type="text" size="2" style="height: 18px;text-align: right" name='topagenum1' id="topagenum1" class="text" value="<%=currentpage %>"><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>
	    </td>
	</tr>
	<!-- 分页 -->
	
	<!-- 讨论内容 -->
	<tr>
	     <td id="discusses">
	     
	     </td>
	</tr>
	<!-- 讨论内容 -->
	
	<!-- 分页 -->
	<tr  class="pagenav" style="<%if(totalsize==0){ %>display:none<%}%>;">
	     <td>
		     <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalsize"><%=totalsize%></span><%=SystemEnv.getHtmlLabelName(24683,user.getLanguage())%> <!-- 共62条记录 -->
	         <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>    <!-- 每页10条 -->
	         <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalpage"><%=totalpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%> <!-- 共7页 -->
	         <%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><span class="currentpage"><%=currentpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%><!-- 当前第1页 --> 
	          <!-- 首页 上一页 下一页 尾页 --> 
			 <A style="<%if(totalpage>1&&currentpage!=1)out.print("cursor:hand;");%>TEXT-DECORATION:none;<%if(totalpage>1&&currentpage!=1)out.print("color:blue");else out.print("color:black");%>" onClick="toFirstPage()" class="FirstPage"><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></A>
			 <A style="<%if(totalpage>1&&currentpage!=1)out.print("cursor:hand;");%>TEXT-DECORATION:none;<%if(totalpage>1&&currentpage!=1)out.print("color:blue");else out.print("color:black");%>" onClick="toPrePage()"   class="PrePage"><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></A>
			 <A style="<%if(totalpage>1&&currentpage!=totalpage)out.print("cursor:hand;");%>TEXT-DECORATION:none;<%if(totalpage>1&&currentpage!=totalpage)out.print("color:blue");else out.print("color:black");%>" onClick="toNextPage()"  class="NextPage"><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></A>
			 <A style="<%if(totalpage>1&&currentpage!=totalpage)out.print("cursor:hand;");%>TEXT-DECORATION:none;<%if(totalpage>1&&currentpage!=totalpage)out.print("color:blue");else out.print("color:black");%>" onClick="toLastPage()"  class="LastPage"><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%></A>
	         <input type="button" onclick="toGoPage('topagenum2')" value="<%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%>" style="cursor: pointer;height: 18px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input type="text" size="2" style="height: 18px;text-align: right" name='topagenum2' id="topagenum2" class="text" value="<%=currentpage %>"><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>
	     </td>
	</tr>
	<!-- 分页 -->
</table>
</form>

<div id="replaydiv" style="display: none">
    <input type="hidden" id="remark" name="remark">
    <textarea  id="rteremark" name="rteremark"></textarea>
    <div style="display: none" id="moreprop">
       <table style="width: 100%;background:#C2D3E1 " class=ViewForm>
                <COLGROUP> 
				<COL width="15%">
				<COL width="35%">
				<COL width="15%">
				<COL width="35%">
	
       <tr>
			    <!-- 相关文档 -->
			      <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
			      <td class=Field style="word-break:break-all">
				      <button class=browser onclick="onShowDoc('relateddoc','relateddocsspan')"></button>
				      <input type=hidden id="relateddoc" name="relateddoc" value="<%=docid%>">
				      <!--
				      <a class="btnEcology" href="void(0)"><div class="left" onclick="onNewDoc();return false"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></div><div class="right"> &nbsp;</div></a>&nbsp;
				       -->
				      <span id="relateddocsspan"><a href="javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=docid%>')"><%=DocComInfo.getDocname(Integer.toString(docid))%></a></span>
			      </td>
			      <!-- 相关流程 -->
			      <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
			      <td class=Field style="word-break:break-all">
			         <button class=browser onclick="onShowRequest('relatedwf','relatedrequestspan')"></button>
			         <input type=hidden id="relatedwf" name="relatedwf">
			         <span id="relatedrequestspan"></span>
			      </td>
	  </tr>
	  <TR><TD class=Line colspan=4></TD></TR>
	 	<!-- 非政务版 -->	
	  <tr <%if(isgoveproj!=0){ %>style="display: none;"<%}%>>
			       <!-- 相关客户 -->
			      <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
			      <td class=Field style="word-break:break-all">
				      <button class=browser onclick="onShowCRM('relatedcus','crmspan')"></button>
				      <input type="hidden" id="relatedcus" name="relatedcus">
				      <span id="crmspan"></span>
			      </td>
			       <!-- 相关项目 -->
			      <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
			      <td class=Field style="word-break:break-all">
				      <BUTTON class="Browser" id="selectMultiProject" onclick="onShowMultiProjectCowork('projectIDs','mutilprojectSpan')"></BUTTON>
					  <INPUT type="hidden" id="projectIDs" name="projectIDs" >
					   <SPAN id="mutilprojectSpan"></SPAN>
			      </td>
		</tr>
		<TR <%if(isgoveproj!=0){ %>style="display: none;"<%}%>><TD class=Line colspan=4></TD></TR> 
		<tr> 
			       <!-- 非政务版 -->	
			       <!-- 相关项目任务 -->
				      <td <%if(isgoveproj!=0){%>style="display: none;"<%}%>><%=SystemEnv.getHtmlLabelName(18871,user.getLanguage())%></td>
				      <td class=Field style="word-break:break-all;<%if(isgoveproj!=0){%>display: none;<%}%>" >
					      <button class=browser onclick="onShowProject('relatedprj','projectspan')"></button>
					      <input type="hidden" id="relatedprj" name="relatedprj">
					      <span id="projectspan"></span>
				      </td>
			      <!-- 相关附件 -->
			      <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
			      <%
					Map dirMap=dao.getAccessoryDir(typeid);
					
					String mainId =(String)dirMap.get("mainId");
					String subId = (String)dirMap.get("subId");
					String secId = (String)dirMap.get("secId");
					String maxsize = (String)dirMap.get("maxsize");
					
					if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
					%>
					<td class=field <%if(isgoveproj!=0) out.println("colspan=3");%>>
						<div id="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
					 </td>
					<%}else{%>
							<td <%if(isgoveproj!=0) out.println("colspan=3");%>><font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font></td>
					<%}%> 
			     
		</tr>
	   <TR><TD class=Line colspan=4></TD></TR>  
		</table>	    
    </div>
    <div id="operation" align="left" class="oper">
        <a class="btnEcology" href="void(0)" onclick="return false;"><div class="left" onclick="doSave(this);return false;"><%=SystemEnv.getHtmlLabelName(18540,user.getLanguage())%></div><div class="right" onclick="return false;"> &nbsp;</div></a>&nbsp;<!-- 回复 -->
        <a class="btnEcology" href="void(0)" onclick="return false;"><div class="left" onclick="showmoreprop(this);return false" id="moreBtn"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></div><div class="right" onclick="return false;"> &nbsp;</div></a>&nbsp;<!-- 更多属性 -->
        <a class="btnEcology" href="void(0)" onclick="return false;"><div class="left" onclick="calcelReplay();return false"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></div><div class="right" onclick="return false;"> &nbsp;</div></a>&nbsp;<!--取消-->
    </div>
</div>

<div id="initRemarkdiv" style="display: none;"></div>
</BODY>
</html>					

<script type="text/javascript">
$(document).ready(function(){ 

    replay();//显示回复框
    displayLoading(1,"page");
    $.post("/cowork/DiscussRecord.jsp?type=1&id=<%=id%>&currentpage=<%=currentpage%>&floorNum=<%=floorNumber%>",{},function(data){
          $("#discusses").html(data);
          if("<%=floorNumber%>"!="0"){
             window.location.href="#floorNum<%=floorNumber%>";
             $("#discuss_<%=discussid%>").addClass("newdiscuss");
          }
          displayLoading(0);
    })
    
   $(".weavertabs").weavertabs({selected:0,call:function(divId){
   
        if(divId=="weavertabs-condition")
          $("#condition").css("background","#36BDEF");
        if(divId=="weavertabs-property")
          $("#property").css("background","#36BDEF");
        if(divId=="weavertabs-related")
          $("#related").css("background","#36BDEF");  
            
		if(divId=="weavertabs-condition"&&$("#conditionFrame").attr("src")=="")
		  $("#conditionFrame").attr("src","/cowork/CoworkShareManager.jsp?from=view&id=<%=id%>");
		if(divId=="weavertabs-related"&&$("#relatedFrame").attr("src")=="")  
		  $("#relatedFrame").attr("src","/cowork/ViewCoWorkDiscussData.jsp?id=<%=id%>&isgoveproj=<%=isgoveproj%>&viewall=<%=viewall%>&type=0");	       
   }});
		
     $(document.body).bind("mouseup",function(){
    	try{
    		parent.jQuery("html").trigger("mouseup.jsp");		
        }	catch(e){}
	   
    });
    $(document.body).bind("click",function(){
        try{
			$(parent.document.body).trigger("click");	
        }	catch(e){}
    });
		
}); 


//提交回复时，提交等待
function displayLoading(state,flag){
  if(state==1){
        //遮照打开
        var bgHeight=document.body.scrollHeight; 
        var bgWidth=window.parent.document.body.offsetWidth;
        $("#bg").css("height",bgHeight,"width",bgWidth);
        $("#bg").show();
        
        if(flag=="save")
           $("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>");
        else if(flag=="page"||flag=="edit")
           $("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(20010,user.getLanguage())%>");
              
        //显示loading
	    var loadingHeight=$("#loading").height();
	    var loadingWidth=$("#loading").width();
	    $("#loading").css({"top":document.body.scrollTop + document.body.clientHeight/2 - loadingHeight/2,"left":document.body.scrollLeft + document.body.clientWidth/2 - loadingWidth/2});
	    $("#loading").show();
    }else{
        $("#loading").hide();
        $("#bg").hide(); //遮照关闭
    }
}

window.onscroll=function(){
  if($("#loading").is(":visible"))
     displayLoading(1);
}


//新建协作
function addCowork(){
    window.location.href="/cowork/AddCoWork.jsp?typeid=<%=typeid%>";
    $(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/AddCoWork.jsp?typeid=<%=typeid%>");
}

//编辑协作
function editCowork(){
    window.location.href="/cowork/EditCoWork.jsp?id=<%=id%>";
    $(window.parent.document).find("#ifmCoworkItemContent").attr("src","/cowork/EditCoWork.jsp?id=<%=id%>");
}
  
//查询协作  
function searchCowork(){
    window.parent.reloadItemListContent("search");
}

//显示更多
function showmore(obj){
   if($('#more').is(":hidden")){
       $('#more').show();
       $("#remarkhtml").show();
       $("#pointspan").hide();
       $(obj).html("<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>");//隐藏更多
     }
   else{  
     $('#more').hide(); 
     $("#remarkhtml").hide();
     $("#pointspan").show();
     $(obj).html("<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>");//查看更多
   } 
}

//显示更多属性
function showmoreprop(obj){
   if($('#moreprop').is(":hidden")){
     $('#moreprop').show();
     $(obj).html("<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%>");//隐藏更多属性
   }
   else{  
     $('#moreprop').hide();
     $(obj).html("<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%>");  //更多属性
   }
}
 
 //删除讨论
 function deleteDiscuss(discussid,flag){
   if(window.confirm("<%=SystemEnv.getHtmlLabelName(25405,user.getLanguage())%>")){ //确认要删除该讨论记录
      $.post("CoworkOperation.jsp?method=delete&id=<%=id%>&discussid="+discussid,{},function(data){
         if($.trim(data)=="true"){
             $("#discuss_"+discussid).remove();
             $("#discuss_tr_"+discussid).remove();
      
	         totalsize=totalsize-1;
	         $(".totalsize").html(totalsize);
	         totalpage=Math.floor(totalsize/pagesize)+((totalsize%pagesize)>0?1:0);
	         $(".totalpage").html(totalpage);
	         if(totalsize==0){
	           $(".pagenav").each(function(){
	             $(this).hide();
	           });
	          }
	     }else 
	         alert("<%=SystemEnv.getHtmlLabelName(25408,user.getLanguage())%>");
         
      });
	 }      
 }

 var replaydiv;
 var editorArray;
 var editdiscussid;
 var editreplayid;
 
 function replay(id,floorNum){
   
   if($("#editdiv").length!=0){  //editdiv已经存在
      alert("<%=SystemEnv.getHtmlLabelName(25404,user.getLanguage())%>"); //请关闭正在编辑的讨论
      return ;
   }
   if(!confirmLeave())
      return ;
   
   if(replaydiv==null)
      replaydiv=$("#replaydiv");
      
   if(id==undefined||id==0){   //当id为undefined时点击主回复
      replaydiv.appendTo($("#mainremark"));
      $("#initRemark").appendTo($("#initRemarkdiv"));
     }
   else{                //讨论回复
      replaydiv.appendTo($("#replayTd_"+id));   
      $("#replayid").val(id);
      $("#floorNum").val(floorNum);
   }
      
   replaydiv.show();
   
   if(id==undefined&&"<%=docid%>"!="0")
      showmoreprop($("#moreBtn")[0]);
   //绑定附件上传
   bindUploaderDiv(replaydiv.find("#uploadDiv"),"relatedacc"); 
   
   if(editorArray==null||editorArray["rteremark"]==undefined){
      editorArray = $('#rteremark').rte({
             height: 100,
             width: '100%',
 			controls_rte: rte_toolbar,
 			controls_html: html_toolbar
 		});
 	}
 	if(id!=undefined){ //首次进入页面不设置焦点
 	  window.setTimeout('editorArray["rteremark"].set_focus()',500); //设置编辑框焦点
 	  }
 }

 //编辑讨论
 function editDiscuss(discussid,replayid){
 
         if(confirmLeave()){ //判断回复是否处于编辑状态
            calcelReplay();
         }else 
            return ;
        
        if(editdiscussid==discussid) //如果相等说明当前评论处于编辑状态
           return ;        
        displayLoading(1,"edit");    
        $.post("discussOperation.jsp?operation=edit",{discussid:discussid,typeid:<%=typeid%>,isgoveproj:<%=isgoveproj%>},function(data){
             
             if($.trim(data)=="false"){ //首先进行是否超过时间判断
                alert("<%=SystemEnv.getHtmlLabelName(25408,user.getLanguage())%>");  //回复时间已经超过10分钟
                $("#discuss_"+discussid+" .editDel").each(function(){
                    $(this).hide();
                });
                displayLoading(0);
                return ;
                }
             else
                $("#discuss_table_"+discussid).hide();
                        
             $("#discuss_div_"+discussid).append(data);
             
             bindUploaderDiv($("#edit_uploadDiv"),"newrelatedacc");
             
             //初始化编辑器
             editorArray = $('#rte_edit_remark').rte({
 	            height: 120,
 	            width: '100%',
 				controls_rte: rte_toolbar,
 				controls_html: html_toolbar
 		     },editorArray);
 		     displayLoading(0);
        });
        
        editdiscussid=discussid;
        editreplayid=replayid;
   }


 //离开页面提醒
 window.onbeforeunload=function (){
    if((editorArray!=null&&editorArray["rteremark"]!=undefined&&editorArray["rteremark"].get_content()!="")
       ||($("#relateddoc").val()!=''&&$("#relateddoc").val()!='0')||$("#relatedcus").val()!=''
 	  ||$("#relatedwf").val()!=''||$("#relatedprj").val()!=''||$("#projectIDs").val()!=''||document.all("relatedacc").value!='')
 	  
      event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
    
    //编辑状态下 
    if($("#editdiv").length!=0)
      event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";  
 }

 //取消回复
 function calcelReplay(){
    
    if(editorArray==null||editorArray["rteremark"]==undefined)
       return ;
    
    if(replaydiv!=null)
 	       replaydiv.hide();
 	   
     $("#initRemark").appendTo($("#mainremark")); //还原mainremark状态
 	   
 	if(replaydiv!=null)
 	      replaydiv.appendTo($("#initRemarkdiv"));  //将replaydiv对象存储到initRemarkdiv中，防止分页时丢失对象
 	
 	$("#moreBtn").html("<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%>");//更多属性
 	$("#moreprop").hide();  //隐藏更多属性
 	
 	editorArray["rteremark"].set_content("");
 	
 	    //相关文档
 	    $("#relateddoc").val("");    
 		$("#relateddocsspan").html("");
 		//相关客户	    
 		$("#relatedcus").val("");
 		$("#crmspan").html("");
 		//相关流程	    
 		$("#relatedwf").val("");
 		$("#relatedrequestspan").html("");
 		//相关项目	    
 		$("#projectIDs").val("");
 		$("#mutilprojectSpan").html("");
 		//相关项目任务	    
 		$("#relatedprj").val("");
 		$("#projectspan").html("");
 		
 		//相关附件
 		document.all("relatedacc").value="";
 	    
 	    $("#replayid").val(0); //被回复的id设置为0
 	    $("#floorNum").val(0);       
 }

 //打开文档
 function opendoc(showid,versionid,docImagefileid){
   openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&coworkid=<%=id%>&isFromAccessory=true&isfromcoworkdoc=1");
  }
 function opendoc1(showid){
   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&coworkid=<%=id%>&isfromcoworkdoc=1");
  }
 function downloads(files){
   document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&coworkid=<%=id%>";
 }

 /*提交回复*/
 function doSave(obj){
     
     if($.trim(editorArray["rteremark"].get_content())!=""){
       var remark=editorArray["rteremark"].get_content();
       
       remark = remark.replace(/\n/g,"");     //替换换行\n
       remark = remark.replace(/\r/g,"");     //替换单行\r
       remark = remark.replace(/\\/g,"\\\\"); //替换斜杠
       remark = remark.replace(/'/g,"\\'");   //转义单引号
       
       $("#remark").val(remark);
       }
     else{
       alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18546,user.getLanguage())%>"); //请填写回复内容
       window.setTimeout('editorArray["rteremark"].set_focus()',500); //设置编辑框焦点
       return ;
     }
     
     displayLoading(1,"save");  //提交等待显示
     
     var oUploader=window[$("#uploadDiv").attr("oUploaderIndex")];
     try{
       if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
         doSaveAfterAccUpload();  //提交回复
       else 
     	 oUploader.startUpload();
	 }catch(e) {
	     doSaveAfterAccUpload(); //提交回复
	  }
 }
 
function   doSaveAfterAccUpload(){
     //提交参数
     var param="{";
     
     $("#frmmain").find("input[type='hidden']").each(function(){
        var element=$(this);
        param=param+element.attr("name")+":'"+element.val()+"',"
     });
     
     param=param.substr(0,param.length-1)+"}";
     var method=$("#method").val();
     //回复评论
     if(method=="doremark"){ 
        $.post("CoworkOperation.jsp", eval('('+param+')'),function(data){
              //alert($.trim(data));
	          totalsize=totalsize+1;
	          //显示分页
	          $(".pagenav").each(function(){
	             $(this).show();
	          });
	          
	 	      $(".totalsize").html(totalsize);
	 	      totalpage=Math.floor(totalsize/pagesize)+((totalsize%pagesize)>0?1:0);
	 	      $(".totalpage").html(totalpage);
	          toFirstPage('replay');
	 	      calcelReplay();
	 	      replay(0);
	 	      displayLoading(0);   
         });
     }else if(method=="editdiscuss"){ //编辑评论
         $.post("CoworkOperation.jsp", eval('('+param+')'),function(data){
         
		         $.post("discussOperation.jsp?operation=getdiscuss&discussid="+editdiscussid,{},function(data){
		            $("#discuss_div_"+editdiscussid).html(data);
		            editdiscussid=null;  //将当前被编辑的讨论id置为空，讨论可以多次编辑
		            replay(0);   
		         });
                 displayLoading(0); 
              });
          $("#method").val("doremark"); //恢复method值
     }
 }

 /*结束协作*/
 function doEnd(){
 	if(confirm("<%=SystemEnv.getHtmlLabelName(18899,user.getLanguage())%>")) {
         if(confirmLeave()){
        	jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");
            //jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");		
    		frmmain.method.value="end";
 		    document.frmmain.submit();
         }
 	}
 }
 /*打开协作*/
 function doOpen(){
 	if(confirm("<%=SystemEnv.getHtmlLabelName(18900,user.getLanguage())%>")) {
         if(confirmLeave()){
             jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");		
    		    frmmain.method.value="open";
 		    document.frmmain.submit();
         }
 	}
 }
 /*添加到日程安排*/
 function doAdd(){

   if(window.confirm("<%=SystemEnv.getHtmlLabelName(16634,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17698,user.getLanguage())%>?")){ //确认添加日程
      $.post("CoworkOperation.jsp?method=addtoplan&id=<%=id%>",function(data){
          alert("<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");//日程添加成功
      });
      }
   else      
      return ;
 }

 /*新建文档*/
 function onNewDoc(){

 if(window.parent.parent.parent.name!=""){
   if(confirmLeave()){
     jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");
 	document.frmmain.action="/docs/docs/DocList.jsp?isuserdefault=1&topage=/cowork/coworkview.jsp?id=<%=id%>";
 	document.frmmain.target="mainFrame";
 	document.frmmain.submit();
   }
 }else{
 	   parent.location.href="/docs/docs/DocList.jsp?isuserdefault=1&topage=/cowork/coworkview.jsp?id=<%=id%>";
 }
    
 }

 function confirmLeave(){
     
     if(editorArray==null||editorArray["rteremark"]==undefined)
        return true;
        
     if((editorArray!=null&&editorArray["rteremark"]!=undefined&&editorArray["rteremark"].get_content()!="")
       ||($("#relateddoc").val()!=''&&$("#relateddoc").val()!='0')||$("#relatedcus").val()!=''
 	   ||$("#relatedwf").val()!=''||$("#relatedprj").val()!=''||$("#projectIDs").val()!=''||document.all("relatedacc").value!=''){
        if(window.confirm("<%=SystemEnv.getHtmlLabelName(25406,user.getLanguage())%>")){  //确认要放弃正在编辑的讨论吗？
          calcelReplay();
          return true;
         }
        else
          return false;           
    }else{
          calcelReplay(); //还原为初始状态
          return true;
     }
     
 }
 /*导出协作*/
 function doexport(){
   if(confirmLeave())
     window.openFullWindowHaveBar("/docs/docs/DocList.jsp?coworkid=<%=id%>&isExpDiscussion=y");
 }


 /*************分页********************/ 
   
   var currentpage=<%=currentpage%>;  //当前页
   var totalpage=<%=totalpage%>;      //总页数
   var totalsize=<%=totalsize%>;      //总记录
   var pagesize=<%=pagesize%>;        //每页记录数
   
   //首页
   function toFirstPage(flag){
         
        if(currentpage==1&&flag==undefined)
            return ;
            
 		if(flag!=undefined||confirmLeave()){
 		    displayLoading(1,"page");
 		    jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");
 		    currentpage=1;
 		    $.post("/cowork/DiscussRecord.jsp?type=1&id=<%=id%>&currentpage="+currentpage,{},function(data){
 		       $("#discusses").html(data);
 		       displayLoading(0);
 		    });
 		    $(".currentpage").html(currentpage);  //修改当前第几页内容
 		    
 		    $(".text").each(function(){
 		        $(this).val(currentpage);
 		    }); 
 		    
 		    //改变分页颜色
 		    if(totalpage>1){
 		       $(".NextPage").css("color","blue");
 		       $(".NextPage").css("cursor","hand");
 		       
 		       $(".LastPage").css("color","blue");
 		       $(".LastPage").css("cursor","hand");
 		       
 		       $(".FirstPage").css("color","black");
 		       $(".FirstPage").css("cursor","");
 		       
 		       $(".PrePage").css("color","black");
 		       $(".PrePage").css("cursor","");
 		    }
 		}
 	}
   //上一页
   function toPrePage(){
 		if(currentpage == 1) {
 			return;
 		}
 		if(confirmLeave()){
 		    displayLoading(1,"page");
 		    jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");
 			currentpage=Number(currentpage) - 1;
 			$("#discusses").load("/cowork/DiscussRecord.jsp?type=1&id=<%=id%>&currentpage="+currentpage,{},function(){
 			  displayLoading(0);
 			});
 			$(".currentpage").html(currentpage);  //修改当前第几页内容
 			
 			$(".text").each(function(){
 		        $(this).val(currentpage);
 		    }); 
 			
 			 //改变分页颜色
 			if(totalpage>1&&currentpage==1){
 		       $(".NextPage").css("color","blue");
 		       $(".NextPage").css("cursor","hand");
 		       
 		       $(".LastPage").css("color","blue");
 		       $(".LastPage").css("cursor","hand");
 		       
 		       $(".FirstPage").css("color","black");
 		       $(".FirstPage").css("cursor","");
 		       
 		       $(".PrePage").css("color","black");
 		       $(".PrePage").css("cursor","");
 		    }else if(totalpage>1&&currentpage>1){
 		       $(".NextPage").css("color","blue");
 		       $(".NextPage").css("cursor","hand");
 		       
 		       $(".LastPage").css("color","blue");
 		       $(".LastPage").css("cursor","hand");
 		       
 		       $(".FirstPage").css("color","blue");
 		       $(".FirstPage").css("cursor","hand");
 		       
 		       $(".PrePage").css("color","blue");
 		       $(".PrePage").css("cursor","hand");
 		    }
 			
 		}
 	}
 	//下一页
 	function toNextPage(){
 		if(currentpage ==totalpage)
 			return;
 			
 		if(confirmLeave()){
 		    displayLoading(1,"page");
 		    jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");
 		    currentpage=Number(currentpage) + 1;
 		    $("#discusses").load("/cowork/DiscussRecord.jsp?type=1&id=<%=id%>&currentpage="+currentpage,{},function(){
 		      displayLoading(0);
 		    });
 		    $(".currentpage").html(currentpage);  //修改当前第几页内容
 		    
 		    $(".text").each(function(){
 		        $(this).val(currentpage);
 		    }); 
 		     //改变分页颜色
 		    if(totalpage>1&&currentpage==totalpage){
 		       $(".NextPage").css("color","black");
 		       $(".NextPage").css("cursor","");
 		       
 		       $(".LastPage").css("color","black");
 		       $(".LastPage").css("cursor","");
 		       
 		       $(".FirstPage").css("color","blue");
 		       $(".FirstPage").css("cursor","hand");
 		       
 		       $(".PrePage").css("color","blue");
 		       $(".PrePage").css("cursor","hand");
 		    }else if(totalpage>1&&currentpage<totalpage){
 		       $(".NextPage").css("color","blue");
 		       $(".NextPage").css("cursor","hand");
 		       
 		       $(".LastPage").css("color","blue");
 		       $(".LastPage").css("cursor","hand");
 		       
 		       $(".FirstPage").css("color","blue");
 		       $(".FirstPage").css("cursor","hand");
 		       
 		       $(".PrePage").css("color","blue");
 		       $(".PrePage").css("cursor","hand");
 		    }
 		    
 		}
 	}
    //尾页
    function toLastPage(){
         if(currentpage ==totalpage)
 			return;
         
 		if(confirmLeave()){
 		    displayLoading(1,"page");
 		    jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");
 		    currentpage=totalpage;
 		    $("#discusses").load("/cowork/DiscussRecord.jsp?type=1&id=<%=id%>&currentpage="+currentpage,{},function(){
 		      displayLoading(0);
 		    });
 		    $(".currentpage").html(currentpage);  //修改当前第几页内容
 		    
 		    $(".text").each(function(){
 		        $(this).val(currentpage);
 		    }); 
 		    
 		    //改变分页颜色
 		    if(totalpage>1){
 		       $(".NextPage").css("color","black");
 		       $(".NextPage").css("cursor","");
 		       
 		       $(".LastPage").css("color","black");
 		       $(".LastPage").css("cursor","");
 		       
 		       $(".FirstPage").css("color","blue");
 		       $(".FirstPage").css("cursor","hand");
 		       
 		       $(".PrePage").css("color","blue");
 		       $(".PrePage").css("cursor","hand");
 		    }
 		}
 	}
 	
 	//转到
 	function toGoPage(topage){
 	
 	    var topagenum=$("#"+topage);
 		var topage =topagenum.val();
 		
 		if(topage <0 || topage!=parseInt(topage) ) {
              alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
              topagenum.val(""); //置空
              topagenum.focus();
 		     return ;
 		 }
 		if(topage ==currentpage) return; //相等时返回
 		
 		if(topage>totalpage) //大于最大页数
 		    topage=totalpage;
 		
 		if(topage==0)       //小于最小页数 
 		    topage=1;
 		
 		if(confirmLeave()){
 		    jQuery("#ViewCoWorkBody").attr("onbeforeunload", "");
 		    
 		    currentpage=topage;
 		    
 		    $(".text").each(function(){
 		        $(this).val(currentpage);
 		    }); 
 		    
 		    if(currentpage==1){
 		       if(totalpage>1){
 			       $(".NextPage").css("color","blue");
 			       $(".NextPage").css("cursor","hand");
 			       
 			       $(".LastPage").css("color","blue");
 			       $(".LastPage").css("cursor","hand");
 			       
 			       $(".FirstPage").css("color","black");
 			       $(".FirstPage").css("cursor","");
 			       
 			       $(".PrePage").css("color","black");
 			       $(".PrePage").css("cursor","");
 		       }
 		    }else if(currentpage>1&&currentpage<totalpage){
 			       $(".NextPage").css("color","blue");
 			       $(".NextPage").css("cursor","hand");
 			       
 			       $(".LastPage").css("color","blue");
 			       $(".LastPage").css("cursor","hand");
 			       
 			       $(".FirstPage").css("color","blue");
 			       $(".FirstPage").css("cursor","hand");
 			       
 			       $(".PrePage").css("color","blue");
 			       $(".PrePage").css("cursor","hand");
 		    }else if(currentpage ==totalpage){
 		           $(".NextPage").css("color","black");
 		           $(".NextPage").css("cursor","");
 		           
 			       $(".LastPage").css("color","black");
 			       $(".LastPage").css("cursor","");
 			       
 			       $(".PrePage").css("color","blue");
 			       $(".PrePage").css("cursor","hand");
 			       
 			       $(".FirstPage").css("color","blue");
 			       $(".FirstPage").css("cursor","hand");
 			       
 		    }
 		    
 		       displayLoading(1,"page");
 		    $("#discusses").load("/cowork/DiscussRecord.jsp?type=1&id=<%=id%>&currentpage="+currentpage,{},function(){
 		       displayLoading(0);
 		    });
 		    $(".currentpage").html(currentpage);  //修改当前第几页内容
 		}
 	}
 	
  /*************分页********************/ 
</script>