
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.ArrayList"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<%
int type=Util.getIntValue(request.getParameter("type"),0);
int id=Util.getIntValue(request.getParameter("id"),0);
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。

boolean isLight=false;
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String userid=String.valueOf(user.getUID());

String logintype = user.getLogintype();
CoworkDAO dao = new CoworkDAO(id);
%>


<%
	isLight=false;
	ArrayList docList = dao.getRelatedDocs();
	if(docList.size()>0){
%>
<!--相关文档-->
<div class="lettercontainer">

     <div class="C  signalletter" style="background:url('/cowork/images/related_doc_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></div>
	 
	<%for(int i=0;i<docList.size();i++){
		String docName=DocComInfo.getDocname(docList.get(i).toString());
	%>
		<div class="itemdetail">
			 <div class="centerItem" title="<%=docName%>">
					<a href="javascript:opendoc2('<%=docList.get(i).toString()%>','<%=id%>')"><%=docName%></a>
			 </div>
	     </div>
	 <%}%>
	 
	 <div class="clear"></div>
	 
</div>	
<%}

   ArrayList wfList = dao.getRelatedWfs();
   if(wfList.size()>0){	
%>
<!-- 相关流程 -->	
<div class="lettercontainer">
     <div class="C  signalletter" style="background:url('/cowork/images/related_wf_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></div>
    
	<%
	for(int j=0;j<wfList.size();j++){
		String wfName=RequestComInfo.getRequestname(wfList.get(j).toString());
	%>
	
		<div class="itemdetail">
			 <div class="centerItem" title="<%=wfName%>">
					<a href="javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=wfList.get(j).toString()%>')"><%=wfName%></a>
			 </div>
	     </div>
	 <%}%>
	 
	 <div class="clear"></div>
</div>	

<%}
    ArrayList cusList = dao.getRelatedCuss();
	if(isgoveproj==0){
	  isLight = false;
	  if(cusList.size()>0){
%>
<!-- 相关客户 -->	
<div class="lettercontainer">
     <div class="C  signalletter" style="background:url('/cowork/images/related_crm_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></div>
	 
	 <%for(int j=0;j<cusList.size();j++){
		 String cusName=CustomerInfoComInfo.getCustomerInfoname(cusList.get(j).toString());
	 %>
	 	<div class="itemdetail">
			 <div class="centerItem" title="<%=cusName%>">
					<a href="javascript:void(0)" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?moduleid=cowork&CustomerID=<%=cusList.get(j).toString()%>')">
	    				<%=cusName%>
	   			    </a>
			 </div>
	     </div>
	 <%}%>
	 
	 <div class="clear"></div>
</div>		
<%}
}
   ArrayList taskList = dao.getRelatedPrjs();
   if(isgoveproj==0){
	  if(taskList.size()>0){
%>
<!-- 相关项目任务 -->	
<div class="lettercontainer">
     <div class="C  signalletter" style="background:url('/cowork/images/related_task_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelNames("522,1332",user.getLanguage())%></div>
	   <%for(int j=0;j<taskList.size();j++){
	   		String taskName=ProjectTaskApprovalDetail.getTaskSuject(taskList.get(j).toString());
	   %>
	 	<div class="itemdetail">
			 <div class="centerItem" title="<%=taskName%>">
					<a href="javascript:void(0)" target="_blank" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=taskList.get(j).toString()%>')">
					    <%=taskName%>(<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+ProjectTaskApprovalDetail.getProjectNameByTaskId(taskList.get(j).toString())%>)
					</a>
			 </div>
	     </div>
	 <%}%>
	 <div class="clear"></div>
</div>	
<%}
}
  	ArrayList mutilprjList = dao.getMutilPrjsList();
	if(isgoveproj==0){
	if(mutilprjList.size()>0){
%>
<!-- 相关项目 -->
<div class="lettercontainer">
     <div class="C  signalletter" style="background:url('/cowork/images/related_proj_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></div>
	
	 <%for(int j=0;j<mutilprjList.size();j++){
	 		String prjName=projectInfoComInfo.getProjectInfoname(mutilprjList.get(j).toString());
	 %>
	 	<div class="itemdetail">
			 <div class="centerItem" title="<%=prjName%>">
					<a target="_blank" href="javascript:openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=mutilprjList.get(j).toString()%>')"><%=prjName%></a>
			 </div>
	     </div>
	 <%}%>
	 <div class="clear"></div>
</div>	
<%}
}%>

<%
		ArrayList accList = dao.getRelatedAccs();
		if(accList.size()>0){
%>
<!-- 相关附件 -->	
<div class="lettercontainer">
     <div class="C  signalletter" style="background:url('/cowork/images/related_acc_wev8.png') no-repeat;"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></div>
    
	<%for(int j=0;j<accList.size();j++){%>
				<%
            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+accList.get(j));
            int linknum=-1;
          	if(RecordSet.next()){
          		linknum++;
          		String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
              if(accessoryCount>1){
                fileExtendName ="htm";
              }
             String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
		 %>
		 <div class="itemdetail">
			 <div class="centerItem" style="float:left;" title="<%=tempshowname%>">
					<%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx"))){%>
            			<a href="javascript:void(0)" style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>','<%=id%>')"><%=docImagefilename%></a>&nbsp
          			<%}else{%>
            			<a style="cursor:hand" onclick="opendoc1('<%=showid%>','<%=id%>')"><%=tempshowname%></a>&nbsp;
					<%}%>
			 </div>
			 <%if(accessoryCount==1){%>
                <div style="color:blue;text-decoration: underline;cursor:pointer;float:left;" onclick="downloads('<%=docImagefileid%>',<%=id%>)">
                  <%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>(<%=docImagefileSize/1000%>K)
                </div>
              <%} %>
              <div class="clear"></div>
	     </div>
		 <%}%>
	 <%}%>
	<div class="clear"></div> 
</div>	
<%}
if(docList.size()==0&&wfList.size()==0&&cusList.size()==0&&taskList.size()==0&&mutilprjList.size()==0&&accList.size()==0)		
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
%>
