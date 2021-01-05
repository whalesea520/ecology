
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.AttachFileUtil"%>
<%@ page import="weaver.general.IsGovProj" %>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="workPlanSetInfo"	class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<%
  //本文件为会议，日程共用相关交流列表数据源
  User user = HrmUserVarify.getUser(request,response);
  if(user == null)  return ;
	
  String userid=String.valueOf(user.getUID());

  int sortid=Util.getIntValue(request.getParameter("sortid"),0);
  String types=Util.null2String(request.getParameter("types"));
  String from=Util.null2String(request.getParameter("from"));
  String sqlstr=Util.null2String(request.getParameter("sqlstr"));

  int pagesize = 6;//讨论交流每页显示条数
  
  if("list".equals(from)){
  	  pagesize = 10;
  }
  
    int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。
  
  String isShowHead = "0";
  
  int currentpage = Util.getIntValue((String)request.getParameter("currentpage"), 1);
  
  int prepage=currentpage-1;
  
  int nextpage=currentpage+1;
  
  int totalsize =0;

  if("list".equals(from)){
  	RecordSet.executeSql("select count(*) from ( "+sqlstr+" ) t" );
  } else {
  	RecordSet.executeSql("select count(*) from Exchange_Info where sortid = "+sortid+" AND type_n='"+types+"'");
  }
  if(RecordSet.next()){
  	totalsize = Util.getIntValue(RecordSet.getString(1), 0);
  }
  if(totalsize > 0){
  	
	  int totalpage = totalsize / pagesize;
	  if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;
	  if(currentpage > totalpage){
	  	currentpage = totalpage;
	  }
	 
	  Date nowdate=new Date();
	  SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	  int iNextNum = currentpage * pagesize;
	  
	  String sql = "";
	  
	  int ipageset = pagesize;
		if(totalsize - iNextNum + pagesize < pagesize) ipageset = totalsize - iNextNum + pagesize;
		if(totalsize < pagesize) ipageset = totalsize;
	  
	  if((RecordSet.getDBType()).equals("oracle")){
	  	if("list".equals(from)){
			sql = "SELECT * FROM ( "+sqlstr+" ) t order by createDate desc, createTime desc " ;
	    } else {
			sql = "SELECT * FROM Exchange_Info where sortid = "+sortid+" AND type_n='"+types+"' order by createDate desc, createTime desc";
		}
		sql = "select t1.*,rownum rn from (" + sql + ") t1 where rownum <= " + iNextNum;
		sql = "select t2.* from (" + sql + ") t2 where rn > " + (iNextNum - pagesize);
	  } else {
	  	if("list".equals(from)){
			sql = "SELECT top "+iNextNum+" * FROM ( "+sqlstr+" ) t order by createDate desc, createTime desc " ;
	    } else {
	  		sql = "SELECT top "+iNextNum+" * FROM Exchange_Info where sortid = "+sortid+" AND type_n='"+types+"' order by createDate desc, createTime desc";
	  	}
	  	sql = "select top " + ipageset +" t1.* from (" + sql + ") t1 order by createDate, createTime";
		sql = "select top " + ipageset +" t2.* from (" + sql + ") t2 order by createDate desc, createTime desc";
	  }
	  //System.out.println("1111:"+sql);
	  RecordSet.executeSql(sql);
	  int cnt = 0;
	  boolean opflag = false;
	  while(RecordSet.next()){
	  	String creater = RecordSet.getString("creater");
	  	String discussid = RecordSet.getString("id");
	  	String createDate = RecordSet.getString("createDate");
	  	String createTime = RecordSet.getString("createTime");
		String remark2html = RecordSet.getString("remark");
		String sort_name = RecordSet.getString("sort_name");
		String sort_type = RecordSet.getString("sort_type");
		sortid = Util.getIntValue(RecordSet.getString("sortid"));
		//System.out.println(discussid+":"+remark2html);
		long timePass=100L;
		if(userid.equals(creater)){
            String dateStr="";
			if(createTime.length()==5)
				dateStr=createDate+" "+createTime+":00";
			else
				dateStr=createDate+" "+createTime;
		    Date discussDate=dateFormat.parse(dateStr);  //回复时间
		    timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
		}
		boolean canEdit=timePass<=10;
		if(cnt == 0) {
			%>
			<style type=text/css>
			/*分页*/
			.pagenav{background:#ffffff;color:#000;width: 100%;text-align:right;margin:5 0;vertical-align: middle;}
			.pagenav a.pageActive:link,.pagenav a.pageActive:visited{cursor:hand;TEXT-DECORATION:none;color:blue}
			.pagenav a.pageActive:hover{cursor:hand;TEXT-DECORATION:underline;color:blue}
		 	/*未读*/
			.norecord{margin-top: 20px;padding-bottom:20px;width: 100%;text-align:center}
			.discuss_div{width: 100%;padding-top: 7px;padding-bottom: 3px;} 
			.discuss{width: 100%;}
			.discuss .userHead{white-space: nowrap;vertical-align:top;background-image:url('/cowork/images/head-bg_wev8.png');background-repeat: no-repeat;float: left;width: 40px;height:37px;padding-top:1px;padding-left:2px;margin-left: 2px;}
			.discussLline{width:100%;;border-top:1px solid  #c8ebfd;line-height:1px}
			
			.discuss_div a {COLOR:#1D76A4 !important; TEXT-DECORATION: underline}

			.discuss_div a:hover{color:red !important;}
			
			td .Selected {background-color: #f6f6f6 !important;color: #000;}
			</style>
		
		
	<table width="100%" cellpadding="0" cellspacing="0" style="margin-top: 5px;margin-right: 10px">
	    <!-- 分页 -->
		<tr class="pagenav" style="<%if(totalsize <= pagesize){ %>display:none<%}%>;" >
		    <td>
		        <div align="right">
					<span style="TEXT-DECORATION:none;height:21px;padding-top:2px;"><%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalsize"><%=totalsize%></span><%=SystemEnv.getHtmlLabelName(24683,user.getLanguage())%> &nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%></span>&nbsp;&nbsp;
					<%if(currentpage > 1) {%>
						<span class="weaverTablePrevPage" style="width:21px;display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;" id="prePage" onclick="toPage(<%=prepage%>);return false;" onmouseover="pmouseoverN(this, true)" onmouseout="pmouseoverN(this, false)">&nbsp;</span>
						<a style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" id="firstPage" onclick="toPage(1);return false;">1</a>
					<%} else { %>
						<span class="weaverTablePrevPageOfDisabled" style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;width:21px;">&nbsp;</span>
						<a style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" id="firstPage" onclick="toPage(1);return false;" class="weaverTableCurrentPageBg">1</a>
					<%}%>
					<%if(totalpage > 1) {%>
						<%if(currentpage > 4) {%>
						<span style="display:inline-block;height:19px;text-align:center;">&nbsp;...&nbsp;</span>
						<%} 
						for(int i = ((currentpage-2)>2?(currentpage-2):2);(i <=(currentpage+2)&&i< totalpage );i++) {%>
							<%if(i == currentpage) {%>
							<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" onclick="toPage(<%=i %>);return false;" class="weaverTableCurrentPageBg"><%=i %></span>
							<%} else { %>
							<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" onclick="toPage(<%=i %>);return false;"><%=i %></span>
							<%} %>
						<%} %>
						<%if(currentpage + 2 < totalpage) {%>
						<span style="display:inline-block;height:19px;text-align:center;">&nbsp;...&nbsp;</span>
						<%}%>
						<%if(currentpage == totalpage) {%>
							<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" onclick="toPage(<%=totalsize %>);return false;" class="weaverTableCurrentPageBg"><%=totalpage %></span>
						<%} else { %>
							<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" onclick="toPage(<%=totalsize %>);return false;" ><%=totalpage %></span>
						<%} %>
					<%}%>
					<%if(currentpage == totalpage) {%>
						<span class="weaverTableNextPageOfDisabled" style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;width:21px;">&nbsp;</span>
					<%} else { %>
						<span class="weaverTableNextPage" style="width:21px;display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;"  onclick="toPage(<%=nextpage%>);return false;" onmouseover="pmouseoverN(this, true)" onmouseout="pmouseoverN(this, false)">&nbsp;</span>
					<%} %>
					<span style="TEXT-DECORATION:none;height:21px;line-height:21px;"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>&nbsp;</span>
					<input name='topagenum' id="topagenum" type="text" value="<%=currentpage %>" size="3" class="text" onmouseover="this.select()"  onkeyPress="if(event.keyCode==13){toGoPage(<%=totalpage%>,'topagenum');return false;}" style="width:20px;text-align:right;line-height:20px;height:20px;widht:30px;border:1px solid #6ec8ff;background:none;margin-right:5px;padding-right:2px;">
					<span style="TEXT-DECORATION:none;height:21px;line-height:21px;"><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%></span>&nbsp;
					<span  onclick="toGoPage(<%=totalpage%>,'topagenum')" style="display:inline-block;line-height:21px;cursor:pointer;background:url(/wui/theme/ecology7/skins/default/table/jump_wev8.png) no-repeat;height:21px;width:38px;margin-right:5px;text-align:center;border:none;"><%=SystemEnv.getHtmlLabelName(30911,user.getLanguage())%></span>
				 </div>
		    </td>
		 </tr>
	</table>
	
	<%
	}
  %>
  	
	<div id="discuss_div_<%=discussid%>" class="discuss_div">
	 <table class="discuss" id="discuss_table_<%=discussid%>" cellpadding="0" cellspacing="0">
     <tr> 
        <td valign="top" width="42px" class="userHeadTd" rowspan="2">
            <div class="userHead">
               <img src="<%=ResourceComInfo.getMessagerUrls(creater)%>" width="30" border="0" align="top"/>
            </div>
        </td>
        <td valign="middle" colspan="2" style="padding-bottom: 2px;height:30px" <%if(canEdit||"list".equals(from)) {%> class="thtd" <%} %>>
				    <span style="float: left;height: 30px;vertical-align: middle;line-height: 30px;">
                      <a href="javascript:void(0)" style="text-decoration:none" onclick="pointerXY(event);openhrm('<%=creater%>');return false;"><%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%></a>
                      <span style="color: #999999"><%=SystemEnv.getHtmlLabelName(23066,user.getLanguage())%>：<%=createDate%>&nbsp;<%=createTime%></span><!-- 发表时间 -->
                      <%if("list".equals(from)){ %>
                      	<span style="color: #999999"><%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>：</span>
                      	<A href='javascript:void();' onclick='javascript:view("<%=sortid %>","<%=sort_type %>");return false;'><%=Util.forHtml(sort_name) %></A>
                      <%} %>
                    </span>
                    
                    <div class="hoverDiv" style="float:right !important;position:static;height: 30px; line-height: 30px; display:none;">
                    &nbsp;&nbsp;&nbsp;
                    <%if("list".equals(from)){ %>
                    <a href='javascript:void();' onclick='javascript:view("<%=sortid %>","<%=sort_type %>","2");return false;' title="<%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%>"><span class="operHoverSpan operHover_hand">&nbsp;<%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%>&nbsp;</span></a>
                    <%}else{ %>
                    <a href="#" onclick="javascript:editDiscussNew(<%=discussid %>,'<%=sortid %>');return false;" title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"><span class="operHoverSpan operHover_hand">&nbsp;<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>&nbsp;</span></a>
                    <a href="#" onclick="javascript:deleteDiscuss(<%=discussid %>);return false;" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"><span class="operHoverSpan operHover_hand">&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>&nbsp;</span></a>
                    <%} %>
                    &nbsp;&nbsp;&nbsp;</div>
		</td>
      </tr>
       <tr id="tr_<%=discussid%>" > 
        <td valign="top" width="*" style="work-break:break-all;padding-left:3px" id="discussContentTd_<%=discussid%>">
            <table cellpadding="0" style="float: left;width: 100%" cellspacing="0" id="discuss_content_<%=discussid%>">
               <col width="3%"/>
               <col width="97%"/>
	           <!-- 内容 -->
               <tr>
	              <td colspan="2"  valign="top" class="discuss_content" style="padding-top: 0px">
	                  <%=remark2html%>
	               </td>
               </tr>
               <%if(meetingSetInfo.getDscsDoc() == 1 || !"MP".equals(types)) {%>
               <!-- 相关文档 -->
               <%
			        String docids_0=  Util.null2String(RecordSet.getString("docids"));
			        String docsname="";
			        if(!docids_0.equals("")){
			
			            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
			            int docsnum = docs_muti.size();
			
			            for(int i=0;i<docsnum;i++){
			                docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+("MP".equals(types)?"&meetingid="+sortid:"&workplanid="+sortid) +" target=\'_blank\'>"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a><br>" +" ";               
			            }
			        
			 %>
	               <tr>
	                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                        <%=docsname%>
	                    </td>
	               </tr>
	           		<%}%>
	           <%}%>
	            <%if(meetingSetInfo.getDscsWf() == 1|| !"MP".equals(types)) {%>
	             <!-- 相关流程 -->
			           <%
			           		String wfids=  Util.null2String(RecordSet.getString("relatedwf"));
			           		String fromModul="meeting";
			           		if("WP".equals(types)){
			           			wfids=  Util.null2String(RecordSet.getString("requestIds"));
			           			fromModul="workplan";
			           		}
			           		
			           		 String wfsname="";
			       			 if(!wfids.equals("")){
			       			 ArrayList wfids_muti = Util.TokenizerString(wfids,",");
			            %>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<wfids_muti.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?fromModul=<%=fromModul%>&modulResourceId=<%=sortid %>&requestid=<%=wfids_muti.get(i).toString()%>');return false" class="relatedLink">
											<%=RequestComInfo.getRequestname(wfids_muti.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
			       <%}%>
			       <%if(meetingSetInfo.getDscsCrm() == 1|| !"MP".equals(types)) {%>
			           <!-- 相关客户 -->
			            <%
			           		String relatedcus=  Util.null2String(RecordSet.getString("relatedcus"));
			           		 if("WP".equals(types)){
			           			relatedcus=  Util.null2String(RecordSet.getString("crmIds"));
			           		 }
			       			 if(isgoveproj==0&&!relatedcus.equals("")){
			       			 	String name="";
			       			 	ArrayList arrs = Util.TokenizerString(relatedcus,",");
			            %>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<arrs.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=arrs.get(i).toString()%>');return false" class="relatedLink">
											<%=CustomerInfoComInfo.getCustomerInfoname(arrs.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%} %>
	            	<%} %>
	            	<%if(meetingSetInfo.getDscsPrj() == 1|| !"MP".equals(types)) {%>
			           <!-- 相关项目 -->
			           <%
			           		String projectIDs=  Util.null2String(RecordSet.getString("projectIDs"));
			       			 if(isgoveproj==0&&!projectIDs.equals("")){
			       			 	String name="";
			       			 	ArrayList arrs = Util.TokenizerString(projectIDs,",");
			            %>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<arrs.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=arrs.get(i).toString()%>');return false" class="relatedLink">
											<%=ProjectInfoComInfo.getProjectInfoname(arrs.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
	           		<%}%>
	           		<%if(meetingSetInfo.getDscsTsk() == 1 && "MP".equals(types)) {%>
			           <!-- 相关任务 -->
			            <%
			           		String relatedprj=  Util.null2String(RecordSet.getString("relatedprj"));
			           		 
			       			 if(isgoveproj==0&&!relatedprj.equals("")){
			       			 	String name="";
			       			 	ArrayList arrs = Util.TokenizerString(relatedprj,",");
			            %>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<arrs.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=arrs.get(i).toString()%>');return false" class="relatedLink">
											<%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(arrs.get(i).toString()),user.getLanguage())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
	           		<%}%>
	           		<%if((meetingSetInfo.getDscsAttch() == 1&& "MP".equals(types))||(workPlanSetInfo.getDscsaccessory() == 1&& "WP".equals(types))) {%>
			           <!-- 相关附件 -->
			            <%
			           		String relateddoc=  Util.null2String(RecordSet.getString("relateddoc"));
			           		 //System.out.println("relateddoc["+relateddoc+"]");
			       			 if(isgoveproj==0&&!relateddoc.equals("")){
			       		%>
			               <tr>
			                    <td style="white-space:nowrap;vertical-align: top;"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
											<%
											ArrayList arrayaccessorys = Util.TokenizerString(relateddoc,",");
											for(int i=0;i<arrayaccessorys.size();i++)
											{
												String accessoryid = (String)arrayaccessorys.get(i);
												//System.out.println("accessoryid : "+accessoryid);
												if(accessoryid.equals(""))
												{
													continue;
												}
												rs.executeSql("select id,docsubject,accessorycount from docdetail where id="+accessoryid);
												int linknum=-1;
												if(rs.next())
												{
										  %>
										  <%
													linknum++;
													String showid = Util.null2String(rs.getString(1)) ;
													String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
													int accessoryCount=rs.getInt(3);
									
													DocImageManager.resetParameter();
													DocImageManager.setDocid(Integer.parseInt(showid));
													DocImageManager.selectDocImageInfo();
									
													String docImagefileid = "";
													long docImagefileSize = 0;
													String docImagefilename = "";
													String fileExtendName = "";
													int versionId = 0;
									
													if(DocImageManager.next())
													{
														//DocImageManager会得到doc第一个附件的最新版本
														docImagefileid = DocImageManager.getImagefileid();
														docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
														docImagefilename = DocImageManager.getImagefilename();
														fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
														versionId = DocImageManager.getVersionId();
													}
													if(accessoryCount>1)
													{
														fileExtendName ="htm";
													}
													//String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
											%>
													
													<%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("ppt")||fileExtendName.equalsIgnoreCase("pptx")||fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")))
													{
													%>
													<a style="cursor:hand" href='javascript:void(0)' onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp;
										  <%
													}
													else
													{
										  %>
													<a style="cursor:hand" href='javascript:void(0)' onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp;
										  <%
													}
													if(accessoryCount==1)
													{
										  %>
										  		   &nbsp;<a href='javascript:void(0)'  onclick="downloads('<%=docImagefileid%>');return false;" class='relatedLink'><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>(<%=(docImagefileSize/1000)%>K)</a></br>
											
										<%
													}
												}
											}
										%>
			                    </td>
			               </tr>
			           <%}%>
			         <%}%>
			         
            </table>
        </td>
     </tr>
     <%if(canEdit) {%>
     	<tr id="tr_edit" style="display:none">
     		<td>
     			<div id="edit_discuss"></div>
     		</td>
     	</tr>
	 <%} %>
  </table>
 </div> 
 <div class="discussLline"></div>
<%
	cnt++;
  }
  if(cnt > 0) {
	%>
   <table width="100%" cellpadding="0" cellspacing="0" style="margin-top: 5px;margin-right: 10px">
	    <!-- 分页 -->
		<tr class="pagenav" style="<%if(totalsize <= pagesize){ %>display:none<%}%>;" >
		    <td>
		    	<div align="right">
					<span style="TEXT-DECORATION:none;height:21px;padding-top:2px;"><%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalsize"><%=totalsize%></span><%=SystemEnv.getHtmlLabelName(24683,user.getLanguage())%> &nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%></span>&nbsp;&nbsp;
					<%if(currentpage > 1) {%>
						<span class="weaverTablePrevPage" style="width:21px;display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;" id="prePage" onclick="toPage(<%=prepage%>);return false;" onmouseover="pmouseoverN(this, true)" onmouseout="pmouseoverN(this, false)">&nbsp;</span>
						<a style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" id="firstPage" onclick="toPage(1);return false;">1</a>
					<%} else { %>
						<span class="weaverTablePrevPageOfDisabled" style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;width:21px;">&nbsp;</span>
						<a style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" id="firstPage" onclick="toPage(1);return false;" class="weaverTableCurrentPageBg">1</a>
					<%}%>
					<%if(totalpage > 1) {%>
						<%if(currentpage >= 4) {%>
						<span style="display:inline-block;height:19px;text-align:center;">&nbsp;...&nbsp;</span>
						<%} 
						for(int i = ((currentpage-2)>2?(currentpage-2):2);(i <=(currentpage+2)&&i< totalpage );i++) {%>
							<%if(i == currentpage) {%>
							<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" onclick="toPage(<%=i %>);return false;" class="weaverTableCurrentPageBg"><%=i %></span>
							<%} else { %>
							<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" onclick="toPage(<%=i %>);return false;"><%=i %></span>
							<%} %>
						<%} %>
						<%if(currentpage + 3 < totalpage) {%>
						<span style="display:inline-block;height:19px;text-align:center;">&nbsp;...&nbsp;</span>
						<%}%>
						<%if(currentpage == totalpage) {%>
							<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" onclick="toPage(<%=totalsize %>);return false;" class="weaverTableCurrentPageBg"><%=totalpage %></span>
						<%} else { %>
							<span style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;" onclick="toPage(<%=totalsize %>);return false;" ><%=totalpage %></span>
						<%} %>
					<%}%>
					<%if(currentpage == totalpage) {%>
						<span class="weaverTableNextPageOfDisabled" style="display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;width:21px;">&nbsp;</span>
					<%} else { %>
						<span class="weaverTableNextPage" style="width:21px;display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;"  onclick="toPage(<%=nextpage%>);return false;" onmouseover="pmouseoverN(this, true)" onmouseout="pmouseoverN(this, false)">&nbsp;</span>
					<%} %>
					<span style="TEXT-DECORATION:none;height:21px;line-height:21px;"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>&nbsp;</span>
					<input name='topagenum' id="topagenum" type="text" value="<%=currentpage %>" size="3" class="text" onmouseover="this.select()"  onkeyPress="if(event.keyCode==13){toGoPage(<%=totalpage%>,'topagenum');return false;}" style="width:20px;text-align:right;line-height:20px;height:20px;widht:30px;border:1px solid #6ec8ff;background:none;margin-right:5px;padding-right:2px;">
					<span style="TEXT-DECORATION:none;height:21px;line-height:21px;"><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%></span>&nbsp;
					<span  onclick="toGoPage(<%=totalpage%>,'topagenum')" style="display:inline-block;line-height:21px;cursor:pointer;background:url(/wui/theme/ecology7/skins/default/table/jump_wev8.png) no-repeat;height:21px;width:38px;margin-right:5px;text-align:center;border:none;"><%=SystemEnv.getHtmlLabelName(30911,user.getLanguage())%></span>
				 </div>
		    </td>
		 </tr>
	</table>
	<%
	}
} else{%>
     <div class="norecord"><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></div>
<%
}
%>
