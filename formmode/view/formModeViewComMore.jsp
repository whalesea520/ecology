<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.docs.docs.DocImageManager"%>
<%@page import="weaver.general.AttachFileUtil"%>
<%@page import="weaver.proj.Maint.ProjectInfoComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.lang.reflect.Array"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="commentRecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
ProjectInfoComInfo projectInfoComInfo = new ProjectInfoComInfo();
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int billId = Util.getIntValue(request.getParameter("billId"),0);
int pagesize = Util.getIntValue(request.getParameter("pageSize"),10);
int pagNo = Util.getIntValue(request.getParameter("pagNo"),1);
String sqlwhere = "";
String fmCommentContent = Util.null2String(request.getParameter("fmCommentContent"));
String fmCommentReplySdate = Util.null2String(request.getParameter("fmCommentReplySdate"));
String fmCommentReplyEdate =  Util.null2String(request.getParameter("fmCommentReplyEdate"));
String fmCommentReplyor = Util.null2String(request.getParameter("fmCommentReplyor"));
String fmCommentFloorNum = Util.null2String(request.getParameter("fmCommentFloorNum"));
Date nowdate=new Date();
SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
if(!StringHelper.isEmpty(fmCommentContent)){
	sqlwhere+= " and replycontent like '%" + fmCommentContent + "%'";
}
if(!StringHelper.isEmpty(fmCommentReplySdate)){
	sqlwhere+= " and replydate >= '" + fmCommentReplySdate + "'";
}
if(!StringHelper.isEmpty(fmCommentReplyEdate)){
	sqlwhere+= " and replydate <= '" + fmCommentReplyEdate + "'";
}
if(!StringHelper.isEmpty(fmCommentReplyor)){
	sqlwhere+= " and replyor = '"+fmCommentReplyor+"'";
}
if (!StringHelper.isEmpty(fmCommentFloorNum)) { 
	sqlwhere+= " and floorNum = " + fmCommentFloorNum + "";
}
int totalsize = 0;
String selSql = "select count(1) from uf_Reply where rqmodeid="+modeId+" and rqid="+billId+" and commentid=0";
selSql+=sqlwhere;
commentRecordSet.executeSql(selSql);
if(commentRecordSet.next()){
	totalsize = commentRecordSet.getInt(1);
}
int iNextNum = pagNo * pagesize;
int ipageset = pagesize;
if(totalsize - iNextNum + pagesize < pagesize) ipageset = totalsize - iNextNum + pagesize;
if(totalsize < pagesize) ipageset = totalsize;
if((commentRecordSet.getDBType()).equals("oracle")){
	selSql = "select * from uf_Reply where rqmodeid="+modeId+" and rqid="+billId+" and commentid=0 "+sqlwhere+" order by id desc";
	selSql = "select t1.*,rownum rn from (" + selSql + ") t1 where rownum <= " + iNextNum;
	selSql = "select t2.* from (" + selSql + ") t2 where rn > " + (iNextNum - pagesize);
}else{
	selSql = "select top " + iNextNum +" * from uf_Reply where rqmodeid="+modeId+" and rqid="+billId+" and commentid=0 "+sqlwhere+" order by id desc";
	selSql = "select top " + ipageset +" t1.* from (" + selSql + ") t1 where t1.rqmodeid="+modeId+" and t1.rqid="+billId+" and t1.commentid=0 "+sqlwhere+" order by t1.id asc";
	selSql = "select top " + ipageset +" t2.* from (" + selSql + ") t2 where t2.rqmodeid="+modeId+" and t2.rqid="+billId+" and t2.commentid=0 "+sqlwhere+" order by t2.id desc";
}


commentRecordSet.executeSql(selSql);
ArrayList commentList = new ArrayList();
while(commentRecordSet.next()){
	Map commentMap = new HashMap();
	commentMap.put("id", commentRecordSet.getString("id"));
	commentMap.put("rqid",commentRecordSet.getString("rqid"));
	commentMap.put("rqmodeid",commentRecordSet.getString("rqmodeid"));
	commentMap.put("replyor",commentRecordSet.getString("replyor"));
	commentMap.put("replydate",commentRecordSet.getString("replydate"));
	commentMap.put("replytime",commentRecordSet.getString("replytime"));
	commentMap.put("replycontent",commentRecordSet.getString("replycontent"));
	commentMap.put("rdocument",commentRecordSet.getString("rdocument"));
	commentMap.put("rworkflow",commentRecordSet.getString("rworkflow"));
	commentMap.put("rcustomer",commentRecordSet.getString("rcustomer"));
	commentMap.put("rproject",commentRecordSet.getString("rproject"));
	commentMap.put("rattach",commentRecordSet.getString("rattach"));
	commentMap.put("quotesid",commentRecordSet.getString("quotesid"));
	commentMap.put("commentid", commentRecordSet.getString("commentid"));
	commentMap.put("floornum", commentRecordSet.getString("floornum"));
	commentList.add(commentMap);
}
for(int idx=0;idx<commentList.size();idx++){
	Map commentMap = (Map)commentList.get(idx);
	String id = Util.null2String(commentMap.get("id"));
	String rqid = Util.null2String(commentMap.get("rqid"));
	String rqmodeid = Util.null2String(commentMap.get("rqmodeid"));
	String replyor = Util.null2String(commentMap.get("replyor"));
	String replydate = Util.null2String(commentMap.get("replydate"));
	String replytime = Util.null2String(commentMap.get("replytime"));
	String replycontent = Util.null2String(commentMap.get("replycontent"));
	String rdocument = Util.null2String(commentMap.get("rdocument"));
	String rworkflow = Util.null2String(commentMap.get("rworkflow"));
	String rcustomer = Util.null2String(commentMap.get("rcustomer"));
	String rproject = Util.null2String(commentMap.get("rproject"));
	String rattach = Util.null2String(commentMap.get("rattach"));
	String quotesid = Util.null2String(commentMap.get("quotesid"));
	String commentid = Util.null2String(commentMap.get("commentid"));
	String floornum = Util.null2String(commentMap.get("floornum"));
	List rdocumentList = Util.TokenizerString(rdocument,",");
	List rworkflowList = Util.TokenizerString(rworkflow,",");
	List rcustomerList = Util.TokenizerString(rcustomer,",");
	List rprojectList = Util.TokenizerString(rproject,",");
	boolean isOptComPer = false;
	long timePass=100L;
	if(replyor.equals(String.valueOf(user.getUID()))){
		if(replytime.length()<6){
			replytime =replytime+":00";
		}
		String dateStr=replydate+" "+replytime;
	    Date discussDate=dateFormat.parse(dateStr);  
	    timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
	    String checkSql = "select * from uf_Reply where rqmodeid="+rqmodeid+" and rqid="+rqid+" and commenttopid="+id;
	    checkSql+=" union all select * from uf_Reply where rqmodeid="+rqmodeid+" and rqid="+rqid+" and quotesid="+id;
	    commentRecordSet.executeSql(checkSql);
	    if(timePass<=10 && commentRecordSet.getCounts()<=0){
	    	isOptComPer = true;
	    }
	}
%>
	<div class="fmComentClass">
		<div class="commentAvtorClass">
			<img src="<%=ResourceComInfo.getMessagerUrls(replyor)%>" />
		</div>
		<div style="margin-left:85px;" id="discuss_div_<%=id%>">
			<div class="fmComment_arrow" style="left: 672.45px; top: 2328.62px; display: none;"></div>
			<table style="width:100%;margin:5px 0 5px 0;" id="discuss_table_" cellspacing="0">
				<col width="*"/>
                <col width="95%"/>
				<tr>
					<td nowrap="nowrap" style="padding:0 0 5px 0;">
						<a href="javascript:openhrm('<%=replyor%>');" onclick="pointerXY(event);" class="fmOptName">
							<%=Util.toScreen(ResourceComInfo.getResourcename(replyor),user.getLanguage())%>
						</a>
					</td>
					<td style="text-align:right;padding:0 0 5px 0;">#<%=floornum%></td>
				 </tr>
				 <%
				 	if(!"0".equals(quotesid) && !"".equals(quotesid)){
				 		String quo_id = "";
				 		String quo_rqid = "";
				 		String quo_rqmodeid = "";
				 		String quo_replyor = "";
				 		String quo_floornum = "";
				 		String quo_replydatetime = "";
				 		String quo_replycontent = "";
				 		String reply_rattach = "";
				 		List reply_rdocumentList = new ArrayList();
				 		List reply_rworkflowList = new ArrayList();
				 		List reply_rcustomerList = new ArrayList();
				 		List reply_rprojectList = new ArrayList();
				 		commentRecordSet.executeSql("select * from uf_Reply where id="+quotesid);
				 		if(commentRecordSet.next()){
				 			quo_id = Util.null2String(commentRecordSet.getString("id"));
				 			quo_rqid = Util.null2String(commentRecordSet.getString("rqid"));
				 			quo_rqmodeid = Util.null2String(commentRecordSet.getString("rqmodeid"));
				 			quo_replyor = Util.null2String(commentRecordSet.getString("replyor"));
				 			quo_floornum = Util.null2String(commentRecordSet.getString("floornum"));
				 			quo_replydatetime = Util.null2String(commentRecordSet.getString("replydate"))+" "+Util.null2String(commentRecordSet.getString("replytime"));
				 			quo_replycontent = Util.null2String(commentRecordSet.getString("replycontent"));
				 			reply_rattach = Util.null2String(commentRecordSet.getString("rattach"));
		       				reply_rdocumentList = Util.TokenizerString(commentRecordSet.getString("rdocument"),",");
		       				reply_rworkflowList = Util.TokenizerString(commentRecordSet.getString("rworkflow"),",");
		       				reply_rcustomerList = Util.TokenizerString(commentRecordSet.getString("rcustomer"),",");
		       				reply_rprojectList = Util.TokenizerString(commentRecordSet.getString("rproject"),",");
				 		}
				 %>
				 <tr>
		            <td style="padding: 5px 5px 2px; border: 1px solid rgb(218, 218, 218); background-color: rgb(247, 252, 253);" colspan="2">
	                     <table style="width: 100%; table-layout: fixed;" cellspacing="0" cellpadding="0">
	                         <colgroup><col width="65"><col width="*">
	                         <tbody>
	                         	<tr>
		                             <td colspan="2">
		                                <span style="color: rgb(153, 153, 153);"><%=SystemEnv.getHtmlLabelName(19422, user.getLanguage()) %>&nbsp;<%=quo_floornum%>#</span>&nbsp;&nbsp;
		                                <a class="fmOptName" onclick="pointerXY(event);openhrm('<%=quo_replyor%>');return false;" href="javascript:void(0)">
		                                	<%=Util.toScreen(ResourceComInfo.getResourcename(quo_replyor),user.getLanguage())%>
		                                </a>
		                                <span class="fmtime"><%=quo_replydatetime%></span>  
		                             </td>
	                         	</tr>
	                         	<tr>
		                             <td class="fmComment_replayContent" style="color: rgb(102, 102, 102);" colspan="2">
		                                 <div style="overflow: auto;">
		                                 	<%=quo_replycontent%>
		                                 </div>
		                             </td>
	                         	</tr>
	                         	<%if(reply_rdocumentList.size()!=0){%> <!-- 相关文档 -->
							  	  <tr>
				                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</td>
				                    <td style="word-break:break-all;vertical-align: top">
				                        <%for(int i=0;i<reply_rdocumentList.size();i++){%>
											<a href="/docs/docs/DocDsp.jsp?isrequest=1&id=<%=reply_rdocumentList.get(i).toString()%>&requestid=0&desrequestid=0&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId=<%=quo_rqmodeid%>&authorizeformmodebillId=<%=quo_rqid%>&authorizeformModeReplyid=<%=quo_id%>&authorizefMReplyFName=rdocument" target="_blank" class="fmRelatedLink">
											  <%=DocComInfo.getDocname(reply_rdocumentList.get(i).toString())%>
											</a>
										<%}%>
				                    </td>
				               	  </tr>
	              				<%}%>
				                <%if(reply_rworkflowList.size()!=0){%> <!-- 相关流程 -->
				              	  <tr>
				                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%>：</td>
				                    <td style="word-break:break-all;vertical-align: top">
				                        <%for(int i=0;i<reply_rworkflowList.size();i++){%>
											<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=reply_rworkflowList.get(i).toString()%>');return false" class="fmRelatedLink">
												<%=RequestComInfo.getRequestname(reply_rworkflowList.get(i).toString())%>
											</a>
										<%}%>
				                    </td>
				               	  </tr>
				                <%}%>
				              	<%if(reply_rcustomerList.size()!=0){%> <!-- 相关客户-->
				              	  <tr>
				                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
				                    <td style="word-break:break-all;vertical-align: top">
				                        <%for(int i=0;i<reply_rcustomerList.size();i++){%>
											<a href="/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID=<%=reply_rcustomerList.get(i).toString()%>&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId=<%=quo_rqmodeid%>&authorizeformmodebillId=<%=quo_rqid%>&authorizeformModeReplyid=<%=quo_id%>&authorizefMReplyFName=rcustomer" target="_blank" class="fmRelatedLink">
												<%=CustomerInfoComInfo.getCustomerInfoname(reply_rcustomerList.get(i).toString())%>
											</a>
										<%}%>
				                    </td>
				               	  </tr>
					            <%}%>
				                <%if(reply_rprojectList.size()!=0){%> <!-- 相关项目-->
				              		<tr>
					                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
					                    <td style="word-break:break-all;vertical-align: top">
					                       <%for(int i=0;i<reply_rprojectList.size();i++){%>
												<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=reply_rprojectList.get(i).toString()%>');return false" class="fmRelatedLink">
													<%=projectInfoComInfo.getProjectInfoname(reply_rprojectList.get(i).toString())%>
												</a>
										   <%}%>	
					                    </td>
				               		</tr>
				                <%}%>
				                <%if(!StringHelper.isEmpty(reply_rattach)){ 
									  String attrStr = getAttrStr(quo_rqmodeid,quo_rqid,quo_id,user,reply_rattach);
								%>
								  	<tr>
				                    	<td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</td> <!-- 相关附件-->
				                    	<td style="word-break:break-all;vertical-align: top">
					                       <%=attrStr%>
					                    </td>
					             	 </tr>
						        <%}%>
	                      	</tbody>
	                      </table>
	                  </td>  
	              </tr>
	              <%}%>
	              <tr>
					 <td colspan="2" style="border-bottom:0px solid #eee;padding:5px 0 10px 0;color:#444;">
						<%=replycontent%>
					 </td>
				  </tr>
				  <%if(rdocumentList.size()!=0){%> <!-- 相关文档 -->
				  	  <tr>
	                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                        <%for(int i=0;i<rdocumentList.size();i++){%>
								<a href="/docs/docs/DocDsp.jsp?isrequest=1&id=<%=rdocumentList.get(i).toString()%>&requestid=0&desrequestid=0&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId=<%=rqmodeid%>&authorizeformmodebillId=<%=rqid%>&authorizeformModeReplyid=<%=id%>&authorizefMReplyFName=rdocument" target="_blank" class="fmRelatedLink">
								  <%=DocComInfo.getDocname(rdocumentList.get(i).toString())%>
								</a>
							<%}%>
	                    </td>
	               	  </tr>
	              <%}%>
	              <%if(rworkflowList.size()!=0){%> <!-- 相关流程 -->
	              	  <tr>
	                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                        <%for(int i=0;i<rworkflowList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=rworkflowList.get(i).toString()%>');return false" class="fmRelatedLink">
									<%=RequestComInfo.getRequestname(rworkflowList.get(i).toString())%>
								</a>
							<%}%>
	                    </td>
	               	  </tr>
	              <%}%>
	              <%if(rcustomerList.size()!=0){%> <!-- 相关客户-->
	              	  <tr>
	                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                        <%for(int i=0;i<rcustomerList.size();i++){%>
								<a href="/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID=<%=rcustomerList.get(i).toString()%>&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId=<%=rqmodeid%>&authorizeformmodebillId=<%=rqid%>&authorizeformModeReplyid=<%=id%>&authorizefMReplyFName=rcustomer" target="_blank" class="fmRelatedLink">
									<%=CustomerInfoComInfo.getCustomerInfoname(rcustomerList.get(i).toString())%>
								</a>
							<%}%>
	                    </td>
	               	  </tr>
	              <%}%>
	              <%if(rprojectList.size()!=0){%> <!-- 相关项目-->
	              		<tr>
		                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
		                    <td style="word-break:break-all;vertical-align: top">
		                       <%for(int i=0;i<rprojectList.size();i++){%>
									<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=rprojectList.get(i).toString()%>');return false" class="fmRelatedLink">
										<%=projectInfoComInfo.getProjectInfoname(rprojectList.get(i).toString())%>
									</a>
							   <%}%>	
		                    </td>
	               		</tr>
	              <%}%>
				  <% 
				  	if(!StringHelper.isEmpty(rattach)){
				  		String attrStr = getAttrStr(rqmodeid,rqid,id,user,rattach);
			           
				  %>
				  <tr>
                    	<td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</td>
                    	<td style="word-break:break-all;vertical-align: top">
	                       <%=attrStr%>
	                    </td>
	              </tr>
	              <%}%>
	              <%
              		commentRecordSet.executeSql("select * from uf_Reply where commenttopid="+id);
              		if(commentRecordSet.getCounts()>0){
	              %>
	              <tr class="fmCommenttr" id="fmCommenttr_<%%>">
               		<td colspan="2">
               			<div class="fmCommentlist">
			       		   <%
			       		   int commentRecordidx = 0;
			       		   while(commentRecordSet.next()){
			       			    String comm_id = Util.null2String(commentRecordSet.getString("id"));
			       			    String comm_rqmodeid = Util.null2String(commentRecordSet.getString("rqmodeid"));
			       			    String comm_rqid = Util.null2String(commentRecordSet.getString("rqid"));
			       				String comm_replyor = Util.null2String(commentRecordSet.getString("replyor"));
			       				String comm_content = Util.null2String(commentRecordSet.getString("replycontent"));
			       				String comm_commenttopid = Util.null2String(commentRecordSet.getString("commenttopid"));
			       				String comm_commentusersid = Util.null2String(commentRecordSet.getString("commentusersid"));
			       				String comm_replydate = Util.null2String(commentRecordSet.getString("replydate"));
			       				String comm_replytime = Util.null2String(commentRecordSet.getString("replytime"));
			       				String comm_rattach = Util.null2String(commentRecordSet.getString("rattach"));
			       				List comm_rdocumentList = Util.TokenizerString(commentRecordSet.getString("rdocument"),",");
			       				List comm_rworkflowList = Util.TokenizerString(commentRecordSet.getString("rworkflow"),",");
			       				List comm_rcustomerList = Util.TokenizerString(commentRecordSet.getString("rcustomer"),",");
			       				List comm_rprojectList = Util.TokenizerString(commentRecordSet.getString("rproject"),",");
			       				commentRecordidx++;
			       				boolean isOptPer = false;
			       				if(comm_replyor.equals(String.valueOf(user.getUID()))){
			       					String dateStr=comm_replydate+" "+comm_replytime;
			       				    Date comDate=dateFormat.parse(dateStr);  
			       				    long comTimePass=(nowdate.getTime()-comDate.getTime())/(60*1000);
			       				    String checkSql = "select * from uf_Reply where rqmodeid="+comm_rqmodeid+" and rqid="+comm_rqid+" and commenttopid="+comm_id;
			       				    checkSql+=" union all select * from uf_Reply where rqmodeid="+comm_rqmodeid+" and rqid="+comm_rqid+" and quotesid="+comm_id;
			       				    rs.executeSql(checkSql);
			       				    if(comTimePass<=10 && rs.getCounts()<=0){
			       				    	isOptPer = true;
			       				    }
			       				}
			       		   %>
			       		   	   <div class="fmCommentitem <%=commentRecordidx==(commentRecordSet.getCounts())?"":"fmCommentline"%>">	 
				       			 <div>
					       			   <div class="fmLeft">
					       			 		<a href="javascript:void(0)" class="fmOptName" onclick="pointerXY(event);openhrm('<%=comm_replyor%>');return false;">
					       			 			<%=Util.toScreen(ResourceComInfo.getResourcename(comm_replyor),user.getLanguage())%>
					       			 		</a>
					       			 		<%if(!comm_commentusersid.equals("0")){%>
					       			 			<span class="fmtime"><%=SystemEnv.getHtmlLabelName(128123, user.getLanguage()) %></span>&nbsp;<a href="javascript:void(0)" class="fmOptName" onclick="pointerXY(event);openhrm('<%=comm_commentusersid%>');return false;">
					       			 				<%=ResourceComInfo.getResourcename(comm_commentusersid)%>
					       			 			</a>
					       			 		<%}%>
					       			 		&nbsp;&nbsp;
					       			 		<span class="fmtime">
					       			 			<%=Util.null2String(commentRecordSet.getString("replydate"))+" "+Util.null2String(commentRecordSet.getString("replytime"))%>
					       			 		</span>
					       			 	</div>
					       			 	<div class="fmRight">
					       			 		<%if(isOptPer){%>
					       			 			<a href="javascript:void(0)" title="<%=SystemEnv.getHtmlLabelName(126371, user.getLanguage()) %>" class="fmCommentDelete" onclick="deleteComment(this,'<%=comm_id%>','reply');return false;" ></a>
					       			 		<%}%>
					       			 		<a href="javascript:void(0)" title="<%=SystemEnv.getHtmlLabelName(675, user.getLanguage()) %>" class="fmCommentReply" onclick="showReplay('<%=id%>','reply','<%=comm_id%>','<%=comm_replyor%>');return false;"></a>	
					       			 	</div>
				       			 		<div class="fmClear"></div>
				       			  </div>
				       			  <div class="fmCommentContent">
				       			 	<%=comm_content%>
				       			  </div>
				       			  <table style="width:100%;margin:5px 0 5px 0;">
									  <col width="5px"/>
					                  <col width="*"/>
					                  <%if(comm_rdocumentList.size()!=0){%>
						                  <tr>
							                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</td>
							                    <td style="word-break:break-all;vertical-align: top">
							                    	<%for(int i=0;i<comm_rdocumentList.size();i++){%>
														<a href="/docs/docs/DocDsp.jsp?isrequest=1&id=<%=comm_rdocumentList.get(i).toString()%>&requestid=0&desrequestid=0&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId=<%=comm_rqmodeid%>&authorizeformmodebillId=<%=comm_rqid%>&authorizeformModeReplyid=<%=comm_id%>&authorizefMReplyFName=rdocument" target="_blank" class="fmRelatedLink">
														  <%=DocComInfo.getDocname(comm_rdocumentList.get(i).toString())%>
														</a>
													<%}%>
							                    </td>
		               	  				  </tr>
		               	  			  <%}%>
		               	  			  <%if(comm_rworkflowList.size()!=0){%> <!-- 相关流程 -->
						              	  <tr>
						                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%>：</td>
						                    <td style="word-break:break-all;vertical-align: top">
						                        <%for(int i=0;i<comm_rworkflowList.size();i++){%>
													<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=comm_rworkflowList.get(i).toString()%>');return false" class="fmRelatedLink">
														<%=RequestComInfo.getRequestname(comm_rworkflowList.get(i).toString())%>
													</a>
												<%}%>
						                    </td>
						               	  </tr>
	              					  <%}%>
	              					  <%if(comm_rcustomerList.size()!=0){%> <!-- 相关客户-->
						              	  <tr>
						                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
						                    <td style="word-break:break-all;vertical-align: top">
						                        <%for(int i=0;i<comm_rcustomerList.size();i++){%>
													<a href="/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID=<%=comm_rcustomerList.get(i).toString()%>&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId=<%=comm_rqmodeid%>&authorizeformmodebillId=<%=comm_rqid%>&authorizeformModeReplyid=<%=comm_id%>&authorizefMReplyFName=rcustomer" target="_blank" class="fmRelatedLink">
														<%=CustomerInfoComInfo.getCustomerInfoname(comm_rcustomerList.get(i).toString())%>
													</a>
												<%}%>
						                    </td>
						               	  </tr>
	              					   <%}%>
	              					   <%if(comm_rprojectList.size()!=0){%> <!-- 相关项目-->
						              	   <tr>
							                    <td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
							                    <td style="word-break:break-all;vertical-align: top">
							                       <%for(int i=0;i<comm_rprojectList.size();i++){%>
														<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=comm_rprojectList.get(i).toString()%>');return false" class="fmRelatedLink">
															<%=projectInfoComInfo.getProjectInfoname(comm_rprojectList.get(i).toString())%>
														</a>
												   <%}%>	
							                    </td>
						               		</tr>
	              						<%}%>
	              						<%if(!StringHelper.isEmpty(comm_rattach)){ 
									  		String attrStr = getAttrStr(comm_rqmodeid,comm_rqid,comm_id,user,comm_rattach);
									  	%>
									  	<tr>
					                    	<td style="white-space:nowrap;vertical-align: top;" class="fmCommentBcolor"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</td> <!-- 相关附件-->
					                    	<td style="word-break:break-all;vertical-align: top">
						                       <%=attrStr%>
						                    </td>
						             	 </tr>
						              <%}%>
						          </table>
				       		    </div> 
			       		   <%}%>
			            </div>
               		</td>
                  </tr>
                  <%}%>
				  <tr>
		           	 <td align="right" colspan="2">
	           			<div class="fmComentTime fmLeft" style="height: 32px; line-height: 32px; padding-left: 0px;"><%=replydate+" "+replytime%></div>
	           			<div align="right" class="fmOperations" style="border: 0px currentColor; background-color: rgb(255, 255, 255);">
	           				  <!-- 编辑 删除 权限 回复者本人提交的评论，只要没有引用或者没有回复 操作时间间隔小于10分 -->
	           				  <%if(isOptComPer){%>
		           			 	  <a href="javascript:void(0)" onclick="editComment('<%=id%>','<%=quotesid%>');return false;" class="fmEdit fmItem replayLink">
		           			 	  	<%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%> <!--修改 -->
		           			 	  </a>
		           				  <a href="javascript:void(0)" onclick="deleteComment(this,'<%=id%>','comment');return false;" class="fmDel fmItem replayLink">
		           				  	<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%> <!--删除-->
		           				  </a>
	           				  <%}%>
						      <a class="fmQuote fmItem fmReplayLink" onclick="showReplay('<%=id%>','quotes');return false;" href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(19422, user.getLanguage()) %></a><!-- 引用 -->
							  <a class="fmComment fmItem fmReplayLink" onclick="showReplay('<%=id%>','comment');return false;" href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(675, user.getLanguage()) %></a><!-- 回复 -->
	                 	</div>
		           	 </td>
				   </tr>
				   <tr id="replaytr_<%=id%>" style="display:none;">
				        <td colspan="2">
		           			<div class="fmReplaydiv" id="replay_364477" style="display: block;">
			    				<div id="tipcontent_<%=id%>"></div>
			    				<div style="margin: 3px 0px 3px 0px;">
			    					<iframe id="replyFrame_<%=id%>" name="replyFrame_<%=id%>" frameborder="0" style="width: 100%;" scrolling="no" src="" onload="showRemarkDiv('replyFrame_<%=id%>');setIframeHeight('replyFrame_<%=id%>');">
									
									</iframe>
			    				</div>
							</div>
		        		</td>
               	   </tr>
			</table>
		</div>
	</div>
<%}%>
<%!
private String getAttrStr(String rqmodeid,String rqid,String replyid,User user,String rattach){
	String attrStr = "";
	AttachFileUtil attachFileUtil = new AttachFileUtil();
	DocImageManager docImageManager = new DocImageManager();
	RecordSet attachRecordSet = new RecordSet();
	String selSql = "select id,docsubject,accessorycount,SecCategory from docdetail where id in(" + rattach + ") order by id asc";
	attachRecordSet.executeSql(selSql);
	while (attachRecordSet.next()) {
        try{
        	 String showid = Util.null2String(attachRecordSet.getString("id"));
    		 int accessoryCount=attachRecordSet.getInt(3);
    		 docImageManager.resetParameter();
             docImageManager.setDocid(Integer.parseInt(showid));
             docImageManager.selectDocImageInfo();
             String docImagefileid = "";
             long docImagefileSize = 0;
             String docImagefilename = "";
             String fileExtendName = "";
        	 if (docImageManager.next()) {
             	docImagefileid = docImageManager.getImagefileid();
                 docImagefileSize = docImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                 docImagefilename = docImageManager.getImagefilename();
                 fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".") + 1).toLowerCase();
             }
        	 if(accessoryCount>1){
                 fileExtendName ="htm"; 
             }
        	 String imgSrc = attachFileUtil.getImgStrbyExtendName(fileExtendName, 20);
        	 if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("ppt") || 
        			 fileExtendName.equalsIgnoreCase("pptx") || fileExtendName.equalsIgnoreCase("xls") || fileExtendName.equalsIgnoreCase("doc")
        			 ||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx"))){
        		 //attrStr=attrStr+"<a href='javascript:void(0)' onclick=\"opendoc('"+showid+"','"+docImagefileid+"');return false\" class='fmRelatedLink'>"+docImagefilename+"</a>";
        		 attrStr=attrStr+"<a href='/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId="+rqmodeid+"&authorizeformmodebillId="+rqid+"&authorizeformModeReplyid="+replyid+"&authorizefMReplyFName=rattach' target=\"_blank\" class='fmRelatedLink'>"+docImagefilename+"</a>";
        	 }else{
        		 //attrStr=attrStr+"<a href='javascript:void(0)' onclick=\"opendoc1('"+showid+"');return false\" class='fmRelatedLink'>"+docImagefilename+"</a>";
        		 attrStr=attrStr+"<a href='/docs/docs/DocDsp.jsp?isrequest=1&id="+showid+"&requestid=0&desrequestid=0&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId="+rqmodeid+"&authorizeformmodebillId="+rqid+"&authorizeformModeReplyid="+replyid+"&authorizefMReplyFName=rattach' target=\"_blank\" class=\"fmRelatedLink\">"+docImagefilename+"</a>";
        	 }
             if(accessoryCount==1){
             	attrStr=attrStr+"<a href='/weaver/weaver.file.FileDownload?fileid="+docImagefileid+"&download=1&requestid=-1&formmode_authorize=formmode_authorize&moduleid=formmode&authorizemodeId="+rqmodeid+"&authorizeformmodebillId="+rqid+"&authorizeformModeReplyid="+replyid+"&authorizefMReplyFName=rattach' class='fmRelatedLink'>"+SystemEnv.getHtmlLabelName(258,user.getLanguage())+"("+(docImagefileSize/1000.0)+"K)</a>";
             }
        }catch (Exception e){
        	e.printStackTrace();
        }
	}
	return attrStr;
}
%>