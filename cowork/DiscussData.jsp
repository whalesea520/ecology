
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />

<%

  User user = HrmUserVarify.getUser(request,response);
  if(user == null)  return ;

  String userid=String.valueOf(user.getUID());
	
  int type=Util.getIntValue(request.getParameter("type"),0);
  
  int id=Util.getIntValue(request.getParameter("id"),0);
  
  int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。
  
  String logintype = user.getLogintype();
  
  CoworkDAO dao = new CoworkDAO(id);
	
  int currentpage = Util.getIntValue((String)request.getParameter("currentpage"), 1);
	
  int pagesize = 10;//讨论交流每页显示条数

  ArrayList list = dao.getCoworkDiscussVOList(currentpage, pagesize);
  
  String maxdiscussid=dao.getMaxDiscussid(""+id);
		
  Date nowdate=new Date();
  
  SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  
  //讨论记录
  for(int k=0;k<list.size();k++){
	  
		CoworkDiscussVO vo = (CoworkDiscussVO)list.get(k);
		String coworkid=vo.getCoworkid();                          //协作Id
		String discussant = Util.null2String(vo.getDiscussant());  //回复人id
		String createdate = Util.null2String(vo.getCreatedate());  //创建日期
		String createtime = Util.null2String(vo.getCreatetime());  //创建时间
		String remark2 = Util.null2String(vo.getRemark());         //回复内容 
		String remark2html = Util.StringReplace(remark2,"\r\n",""); 
		
		String relatedprj = Util.null2String(vo.getRelatedprj());  //相关项目任务
		String relatedcus = Util.null2String(vo.getRelatedcus());  //相关客户
		String relatedwf = Util.null2String(vo.getRelatedwf());    //相关流程
		String relateddoc = Util.null2String(vo.getRelateddoc());  //相关文档
		
		ArrayList relatedprjList = vo.getRelatedprjList();       
		ArrayList relatedcusList = vo.getRelatedcusList();
		ArrayList relatedwfList = vo.getRelatedwfList();
		ArrayList relateddocList = vo.getRelateddocList();
		
		ArrayList relatedaccList = vo.getRelatedaccList();
		
		ArrayList relatemutilprjsList = vo.getRelatemutilprjsList();
		
		Date discussDate=dateFormat.parse(createdate+" "+createtime);  //回复时间
		
		long timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
		
		//新添加字段
		String discussid=vo.getId();
		String floorNum=vo.getFloorNum();
		String replayid=vo.getReplayid();
		
		ArrayList replayDiscussList=dao.getReplayDisscussList(discussid);		
	%>
		<table style="width: 100%;margin:5 0" id="discuss_<%=discussid%>">
	         <tr>  
	         	<td>
	         	  <div style="100%">
	         			<div  style="width:128px;float:left"><img src="/cowork/images/discussLogo_wev8.jpg" border="0" align="absmiddle">&nbsp;</><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><%=floorNum%><%=SystemEnv.getHtmlLabelName(25403,user.getLanguage())%>&nbsp;&nbsp; <%=Util.toScreen(ResourceComInfo.getResourcename(discussant),user.getLanguage())%></div><!-- 第1楼 -->
	         			<div style="width:400px;float:left;"><%=createdate+" "+createtime%></div> 
	         			<div  style="width:100px;float:right;text-align:right">
							<a href="#" onclick="replay('<%=discussid%>');return false;" style="margin-right: 5px"><%=SystemEnv.getHtmlLabelName(18540,user.getLanguage())%></a><!-- 回复 -->
			                  <!-- 编辑 删除 权限 回复者本人 没有协作回复和讨论回复 操作时间间隔小于10分 -->
				              <%if(userid.equals(discussant)&&replayDiscussList.size()==0&&maxdiscussid.equals(discussid)&&timePass<=10){%>
				                      <a href="#" onclick="editDiscuss('<%=discussid%>','<%=replayid%>');return false;" class="editDel" style="margin-right: 5px"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a><!--编辑 -->
				                      <a href="#" onclick="deleteDiscuss('<%=discussid%>','remark');return false;" class="editDel" style="margin-right: 5px"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!--删除-->
				              <%} %>
						</div>
	         		</div>
	         	</td>
	         </tr>
	         <tr>
	             <td>
	                <div class="discuss">
	                  <TABLE width="100%" cellpadding="0" cellspacing="0">
						<TR>
							<TD colspan="3" style="height:10px;">
								<div style="height:10px;position:relative;">
									<div class="triangle"></div>
								</div>
							</TD>
						</TR>
						<TR>
							<TD class="corner-top-left"></TD>
							<TD class="line-x-top"></TD>
							<TD class="corner-top-right"></TD>
						</TR>
					
						<TR>
							<TD class="line-y-left"></TD>
							<TD class="centercenter">
			                 <div style="margin: 5px 2px 5px 2px;width: 100%" align="center" id="discuss_div_<%=discussid%>">
			                   <table width="100%" id="discuss_table_<%=discussid%>">
			                       <tr>
			                            <td><img src="/cowork/images/head_wev8.gif" /></td>
			                       		<td colspan="2" valgin="top">
			                       			  <%=remark2html%>
			                       		</td>			                          
			                       </tr>
			                       <!-- 相关资源 -->
			                       <%if(relateddocList.size()+relatedwfList.size()+relatedcusList.size()+relatedcusList.size()+relatemutilprjsList.size()+relatedprjList.size()+relatedaccList.size()>0){%>
			                       <tr>
			                           <td style="width: 20px">&nbsp;</td>
			                           <td>
			                                <table width="100%" cellpadding="0" cellspacing="0">
			                                      <colgroup>
			                                      <col width="40">
			                                      <col width="*">
			                                      
			                                      <%
			                                      if(relateddocList.size()!=0){ //相关文档%>
			                                      <tr><td colspan="2">
				                                      <div style="border-top:#d6d6d6 solid 1px;"></div>
				                                      <div style="border-top:#f4f4f4 solid 1px;"></div>
			                                      </td></tr>
												  <TR>
												    <td title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>" align="center">
										              <img src="images/icon/doc_wev8.png"><br>
										              <%=SystemEnv.getHtmlLabelName(22243,user.getLanguage())%>
										            </td>
												    <td>
												         <%for(int i=0;i<relateddocList.size();i++){%>
														    <a href="javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?isfromcoworkdoc=1&id=<%=relateddocList.get(i).toString()%>')">
																<%=DocComInfo.getDocname(relateddocList.get(i).toString())%>
															</a><br>
													     <%}%>
									               </td>
												  </TR>
												  <%} %>
												  <%if(relatedwfList.size()!=0){ //相关流程%>
		                                               <tr><td colspan="2">
		                                                    <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                                <div style="border-top:#f4f4f4 solid 1px;"></div>
		                                               </td></tr>
													   <TR>
													     <td title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>" align="center">
									                       <img src="images/icon/wf_wev8.png"><br>
									                       <%=SystemEnv.getHtmlLabelName(22244,user.getLanguage())%>
									                     </td>
													     <td>
													         <%for(int i=0;i<relatedwfList.size();i++){%>
																	<a href="javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>')">
																	<%=RequestComInfo.getRequestname(relatedwfList.get(i).toString())%>
																	</a><br>
															 <%}%>		
													     </td>
													  </tr>
		                                         <%}%>
				                                  <%if(isgoveproj==0&&relatedcusList.size()!=0){ //相关客户%>
				                                    <tr>
				                                        <td colspan="2">
				                                            <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                                <div style="border-top:#f4f4f4 solid 1px;"></div>
				                                        </td>
				                                    </tr>
													   <TR>
													     <td title="<%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>" align="center">
									                          <img src="images/icon/crm_wev8.png"><br>
									                          <%=SystemEnv.getHtmlLabelName(21313,user.getLanguage())%>
									                     </td>
													     <td>
													         <%for(int i=0;i<relatedcusList.size();i++){%>
																	<a href="javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>')">
																	<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())%>
																	</a><br>
															 <%}%>		
													     </td>
													  </tr>
		                                          <%} %>
		                                         <%if(isgoveproj==0&&relatemutilprjsList.size()!=0){ //相关项目%>
		                                           <tr><td colspan="2">
		                                              <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                          <div style="border-top:#f4f4f4 solid 1px;"></div>
		                                           </td></tr>
												   <TR>
												     <td title="<%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>" align="center">
									                      <img src="images/icon/proj_wev8.png"><br>
									                      <%=SystemEnv.getHtmlLabelName(22245,user.getLanguage())%>
									                 </td>
												     <td>
												         <%for(int i=0;i<relatemutilprjsList.size();i++){%>
															<a href="javascript:openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=relatemutilprjsList.get(i).toString()%>')">
															<%=projectInfoComInfo.getProjectInfoname(relatemutilprjsList.get(i).toString())%>
															</a><br>
														 <%}%>		
												     </td>
												  </tr>
		                                         <%}%>
											      <%if(isgoveproj==0&&relatedprjList.size()!=0){ //相关项目任务%>
											          <tr><td colspan="2">
											             <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                             <div style="border-top:#f4f4f4 solid 1px;"></div>
											          </td></tr>
													  <TR>
													     <td title="<%=SystemEnv.getHtmlLabelName(18871,user.getLanguage())%>" align="center">
									                         <img src="images/icon/task_wev8.png"><br>
									                         <%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>
									                     </td>
													     <td>
														      <%for(int i=0;i<relatedprjList.size();i++){%>
														         <a href="/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>" target="_blank">
														         <%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString()),user.getLanguage())%>
														         </a><br>
														      <%}%>
										                </td>
													  </tr>
											      <%}%>
											       <%if(relatedaccList.size()!=0){ //相关附件%>
											          <tr><td colspan="2">
											              <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                              <div style="border-top:#f4f4f4 solid 1px;"></div>
											          </td></tr>
													  <TR>
													      <td title="<%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>" align="center">
									                         <img src="images/icon/acc_wev8.png"><br>
									                         <%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>
									                      </td>
													     <td>
													         <%for(int i=0;i<relatedaccList.size();i++){
													            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+relatedaccList.get(i));
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
																		<%=imgSrc%>
															  <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx"))){%>
													                 <a  href="javascript:opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
													          <%}else{%>
													                 <a  href="javascript:opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp
															  <%}
													          if(accessoryCount==1){%>
													              <span id = "selectDownload">
													                <%
													                  //boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
													                  //if(!isLocked){
													                %>
													                <a href="javascript:downloads('<%=docImagefileid%>')"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>(<%=docImagefileSize/1000%>K)</a>
													                <!--  
													                  <button class=btn accessKey=1  onclick="downloads('<%=docImagefileid%>')">
													                    <%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
													                  </button>
													                 -->  
													                <%//}%>
													              </span>
																	<%}%>
																	<br>
																	<%}}%>
													        </td>
													  </tr>
		                                          <%}%>
			                                </table>
			                           </td>
			                       </tr>
			                       <%}%>
			                       <!-- 相关资源 -->
			                       <!-- 回复内容 -->
			                       <%
			                         for(int i=0;i<replayDiscussList.size();i++){
			                        	 CoworkDiscussVO replayvo = (CoworkDiscussVO)replayDiscussList.get(i);
			                        	 
			                        	 ArrayList relatedprjList2 = replayvo.getRelatedprjList();       
			                     		 ArrayList relatedcusList2 = replayvo.getRelatedcusList();
			                     		 ArrayList relatedwfList2 = replayvo.getRelatedwfList();
			                     		 ArrayList relateddocList2 = replayvo.getRelateddocList();
			                     		
			                     		 ArrayList relatedaccList2 = replayvo.getRelatedaccList();
			                     		
			                     		 ArrayList relatemutilprjsList2 = replayvo.getRelatemutilprjsList();
			                        	 
			                       %>
			                       <tr id="discuss_tr_<%=replayvo.getId()%>">
			                           <td width="20px">&nbsp;</td>
			                           <td>
			                              <div style="border-top:#d6d6d6 solid 1px;"></div>
			                           </td>
			                       </tr>
			                       <tr id="discuss_<%=replayvo.getId()%>">
			                           <td width="20px">&nbsp;</td>
							           <td valign="top" align="center" style="padding-left: 10px;word-break:break-all" id="discuss_div_<%=replayvo.getId()%>" colspan="3">
									     <table width="100%" cellpadding="0" cellspacing="0" id="discuss_table_<%=replayvo.getId()%>">
			                                      <colgroup>
			                                      <col width="30px">
			                                      <col width="40px">
			                                      <col width="*">
			                                      <tr>
			                                          <td valign="top" align="left"><img src="images/head_wev8.gif" style="vertical-align:middle;"/></td>
			                                          <td valign="top" align="left"><%=Util.toScreen(ResourceComInfo.getResourcename(replayvo.getDiscussant()),user.getLanguage())%></td>
			                                          <td>
			                                             <%=replayvo.getRemark() %>
														  <br><br>
														  <span style="color: #ADB0AD">
														      <%=replayvo.getCreatedate()+" "+replayvo.getCreatetime()%> 
															  <%
															    if(i==replayDiscussList.size()-1){
																    Date replayDate=dateFormat.parse(replayvo.getCreatedate()+" "+replayvo.getCreatetime());
																    long replayTimePass=(nowdate.getTime()-replayDate.getTime())/(60*1000);
																    if(userid.equals(replayvo.getDiscussant())&&replayTimePass<=10){%>
									                                     <a href="javascript:editDiscuss('<%=replayvo.getId()%>','<%=replayvo.getReplayid()%>')" class="editDel"  style="margin-right: 5px"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a><!-- 编辑 -->
									                                     <a href="javascript:deleteDiscuss('<%=replayvo.getId()%>','replay')" class="editDel"  style="margin-right: 5px"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!-- 删除 --> 
								                              <% }
															    }%>
														 </span>
			                                          </td>
			                                      </tr>
			                                      <%if(relateddocList2.size()!=0){ //相关文档%>
			                                      <tr>
			                                          <td></td>
				                                      <td colspan="2">
				                                                <div style="border-top:#d6d6d6 solid 1px;"></div>
				                                                <div style="border-top:#f4f4f4 solid 1px;"></div>
				                                      </td>
			                                      </tr>
												  <TR>
												    <td></td>
												    <td title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>" align="center">
										               <img src="images/icon/doc_wev8.png"><br>
										               <%=SystemEnv.getHtmlLabelName(22243,user.getLanguage())%>
										            </td>
												    <td>
												         <%for(int m=0;m<relateddocList2.size();m++){%>
														    <a href="javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?isfromcoworkdoc=1&id=<%=relateddocList2.get(m).toString()%>')">
																<%=DocComInfo.getDocname(relateddocList2.get(m).toString())%>
															</a><br>
													     <%}%>
									               </td>
												  </TR>
				                                  <%} %>
				                                  <%if(relatedwfList2.size()!=0){ //相关流程%>
		                                               <tr>
		                                                  <td></td>
		                                                  <td colspan="2">
		                                                    <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                                <div style="border-top:#f4f4f4 solid 1px;"></div>
		                                                  </td>
		                                               </tr>
													   <TR>
													      <td></td>
													     <td title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>" align="center">
									                       <img src="images/icon/wf_wev8.png"><br>
									                       <%=SystemEnv.getHtmlLabelName(22244,user.getLanguage())%>
									                     </td>
													     <td>
													         <%for(int m=0;m<relatedwfList2.size();m++){%>
																	<a href="javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList2.get(m).toString()%>')">
																	<%=RequestComInfo.getRequestname(relatedwfList2.get(m).toString())%>
																	</a><br>
															 <%}%>		
													     </td>
													  </tr>
		                                         <%}%>
				                                  <%if(isgoveproj==0&&relatedcusList2.size()!=0){ //相关客户%>
				                                    <tr>
				                                       <td></td>
				                                       <td colspan="2">
				                                            <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                                <div style="border-top:#f4f4f4 solid 1px;"></div>
				                                        </td>
				                                    </tr>
													   <TR>
													     <td></td>
													     <td title="<%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>" align="center">
									                          <img src="images/icon/crm_wev8.png"><br>
									                          <%=SystemEnv.getHtmlLabelName(21313,user.getLanguage())%>
									                     </td>
													     <td>
													         <%for(int m=0;m<relatedcusList2.size();m++){%>
																	<a href="javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList2.get(m).toString()%>')">
																	<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList2.get(m).toString())%>
																	</a><br>
															 <%}%>		
													     </td>
													  </tr>
		                                          <%} %>
		                                          
		                                         <%if(isgoveproj==0&&relatemutilprjsList2.size()!=0){ //相关项目%>
		                                           <tr>
		                                              <td></td>
		                                              <td colspan="2">
		                                               <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                           <div style="border-top:#f4f4f4 solid 1px;"></div>
		                                              </td>
		                                           </tr>
												   <TR>
												     <td></td>
												     <td title="<%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>" align="center">
									                      <img src="images/icon/proj_wev8.png"><br>
									                      <%=SystemEnv.getHtmlLabelName(22245,user.getLanguage())%>
									                 </td>
												     <td>
												         <%for(int m=0;m<relatemutilprjsList2.size();m++){%>
															<a href="javascript:openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=relatemutilprjsList2.get(m).toString()%>')">
															<%=projectInfoComInfo.getProjectInfoname(relatemutilprjsList2.get(m).toString())%>
															</a><br>
														 <%}%>		
												     </td>
												  </tr>
		                                         <%}%>
											      <%if(isgoveproj==0&&relatedprjList2.size()!=0){ //相关项目任务%>
											          <tr>
											            <td></td>
											            <td colspan="2">
											                <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                                <div style="border-top:#f4f4f4 solid 1px;"></div>
											            </td>
											          </tr>
													  <TR>
													     <td></td>
													     <td title="<%=SystemEnv.getHtmlLabelName(18871,user.getLanguage())%>" align="center">
									                         <img src="images/icon/task_wev8.png"><br>
									                         <%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>
									                     </td>
													     <td>
														      <%for(int m=0;m<relatedprjList2.size();m++){%>
														         <a href="/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList2.get(m).toString()%>" target="_blank">
														         <%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList2.get(m).toString()),user.getLanguage())%>
														         </a><br>
														      <%}%>
										                </td>
													  </tr>
											      <%}%>
											       <%if(relatedaccList2.size()!=0){ //相关附件%>
											          <tr>
											             <td></td>
											             <td colspan="2">
											                <div style="border-top:#d6d6d6 solid 1px;"></div>
			                                                <div style="border-top:#f4f4f4 solid 1px;"></div>
											             </td>
											          </tr>
													  <TR>
													     <td></td>
													     <td title="<%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>" align="center">
									                         <img src="images/icon/acc_wev8.png"><br>
									                         <%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%>
									                      </td>
													     <td>
													         <%for(int m=0;m<relatedaccList2.size();m++){
													            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+relatedaccList2.get(m));
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
															  <%=relatedaccList2.size()>1?m+1+".":""%><%=imgSrc%>
															  <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx"))){%>
													                 <a href="javascript:opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>
													          <%}else{%>
													                 <a href="javascript:opendoc1('<%=showid%>')"><%=tempshowname%></a>
															  <%}
													          if(accessoryCount==1){%>
													              <span id = "selectDownload">
													                <%
													                  //boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
													                  //if(!isLocked){
													                %>
													                <a href="javascript:downloads('<%=docImagefileid%>')"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>(<%=docImagefileSize/1000%>K)</a>
													                <!--  
													                  <button class=btn accessKey=1  onclick="downloads('<%=docImagefileid%>')">
													                    <%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
													                  </button>
													                 -->  
													                <%//}%>
													              </span>
																	<%}%>
																	<br>
																	<%}}%>
													        </td>
													  </tr>
		                                          <%}%>
			                                </table>
										   
							           </td>
			                       </tr>
			                       <%} %>
			                       <!-- 回复内容 -->
			                       <!-- 新添回复 -->
			                        <tr id="replayTr_<%=discussid%>">
			                            <td width="20px"></td>
			                            <td id="replayTd_<%=discussid%>" align="center"></td>
			                        </tr>   
			                       <!-- 新添回复 -->
			                   </table>
			                 </div>
			                </TD>
							<TD class="line-y-right"></TD>
						</TR>
					
						<TR>
							<TD class="corner-bottom-left"></TD>
							<TD class="line-x-bottom"></TD>
							<TD class="corner-bottom-right"></TD>
						</TR>
					
					  </TABLE>
								                 
	                 </div>
	             </td>
	         </tr>
	      </table>
		<%}
	%>
