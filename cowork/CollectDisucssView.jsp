
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@page import="java.util.*"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
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
<jsp:useBean id="settingComInfo" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<jsp:useBean id="CoworkTransMethod" class="weaver.general.CoworkTransMethod" scope="page" />
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<%

  User user = HrmUserVarify.getUser(request,response);
  if(user == null)  return ;

  String userid=String.valueOf(user.getUID());
	
  int type=Util.getIntValue(request.getParameter("type"),0);
  
  String typeid=Util.null2String(request.getParameter("typeid"));
  

  String discussids=Util.null2String(request.getParameter("discussids"));
  
  int id=Util.getIntValue(request.getParameter("id"),0);
  
  String recordType=Util.null2String(request.getParameter("recordType"));
 
  String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(userid));
  
  int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0：非政务系统。2：政务系统。
  
  String logintype = user.getLogintype();
  
  CoworkDAO dao = new CoworkDAO(id);
	
  int pagesize = 20;//讨论交流每页显示条数
  
  int currentpage = Util.getIntValue((String)request.getParameter("currentpage"), 1);
  
  int prepage=currentpage-1;
  
  int nextpage=currentpage+1;
  
  int totalsize =0;
  ArrayList list=new ArrayList();
  
  String srchcontent =Util.null2String(request.getParameter("srchcontent"));
  String startdate =Util.null2String(request.getParameter("startdate"));
  String enddate =Util.null2String(request.getParameter("enddate"));
  String par_discussant =Util.null2String(request.getParameter("discussant"));
  String srchFloorNum =Util.null2String(request.getParameter("srchFloorNum"));
  String isReplay =Util.null2String(request.getParameter("isReplay"));
  boolean isManager =CoworkShareManager.isCanEdit(""+id,""+userid,"all");
  String datetype =Util.null2String(request.getParameter("datetype")); //回复相关日期
  String isCoworkManager =Util.null2String(request.getParameter("isCoworkManager")); //是否具有管理协作权限
  String isShowApproval=Util.null2String(request.getParameter("isShowApproval"));
  String discussRecordid=Util.null2String(request.getParameter("discussRecordid"));
  String searchStr = "";
  if (!"".equals(srchcontent)) {
	  searchStr += " and remark like '%" + srchcontent + "%'";
  }
  if (!"".equals(startdate)) {
	  searchStr += " and createdate >= '" + startdate + "'";
  }
  if (!"".equals(enddate)) {
	  searchStr += " and createdate <= '" + enddate + "'";
  }
  if (!"".equals(par_discussant)) {
	  searchStr += " and discussant = '" + par_discussant + "'";
  }
  if (!"".equals(srchFloorNum)) { //按照楼号搜索
	  searchStr += " and floorNum = " + srchFloorNum + "";
  }
  if (!"".equals(isReplay)) {     //显示非回复内容
	  searchStr += " and replayid = 0";
  }
  if (!"".equals(isShowApproval)) {     //显示需要审批内容
	  searchStr += " and approvalAtatus = 1 ";
  }
  
  //获取指定记录的留言内容，请他查询条件清空
  if (!"".equals(discussRecordid)) {     
	  searchStr=" and id = "+discussRecordid;
  }
  if(recordType.equals("")){
	  totalsize =dao.getDiscussVOListCount(searchStr);
	  list = dao.getCollectDiscussVOList(currentpage, pagesize, searchStr,discussids);
  }if(recordType.equals("relatedme")){
	  totalsize =dao.getDiscussReplayListCount(userid,""+id,"");
	  list = dao.getDiscussReplayList(currentpage, pagesize, userid,""+id,"");
  }else if(recordType.equals("replay")){
      totalsize =dao.getDiscussReplayListCount(userid,"",datetype);
	  list = dao.getDiscussReplayList(currentpage, pagesize, userid,"",datetype);
  }
  
  int totalpage = totalsize / pagesize;
  if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;
  
  String maxdiscussid=dao.getMaxDiscussid(""+id);
		
  Date nowdate=new Date();
  
  SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

  //讨论记录
  if(list.size()>0){
  for(int k=0;k<list.size();k++){
	  
		CoworkDiscussVO vo = (CoworkDiscussVO)list.get(k);
		String coworkid=vo.getCoworkid();                          //协作Id
		String discussant = Util.null2String(vo.getDiscussant());  //回复人id
		String createdate = Util.null2String(vo.getCreatedate());  //创建日期
		String createtime = Util.null2String(vo.getCreatetime());  //创建时间
		String remark2 = Util.null2String(vo.getRemark());         //回复内容 
		String remark2html = Util.StringReplace(remark2.trim(),"\r\n",""); 
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
		
		//新添加字段
		String discussid=vo.getId();
		String floorNum=vo.getFloorNum();
		String replayid=Util.null2String(vo.getReplayid());
		String commentid=vo.getCommentid();
		String topdiscussid=vo.getTopdiscussid();
		String istop=vo.getIstop();
		String approvalAtatus=vo.getApprovalAtatus();
		String isAnonymous=vo.getIsAnonymous();
		String isDel=vo.getIsDel(); //是否已经删除
		
		long timePass=100L;
		if(maxdiscussid.equals(discussid)&&userid.equals(discussant)){
            String dateStr="";
			if(createtime.length()==5)
				dateStr=createdate+" "+createtime+":00";
			else
				dateStr=createdate+" "+createtime;
		    Date discussDate=dateFormat.parse(dateStr);  //回复时间
		    timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
		}
        
		boolean canEdit=userid.equals(discussant)&&maxdiscussid.equals(discussid);
		 //获取协作基础配置信息(删除交流内容时间)
        RecordSet1.execute("select * from cowork_base_set");
        int basedeletetime;//设置时间//0-表示提交后不能再修改；空-表示提交后一直可修改
        if(RecordSet1.next()){
            basedeletetime=RecordSet1.getInt("dealchangeminute");
        }else{
            basedeletetime=10;
        }
        if(basedeletetime==0){
             canEdit=false;
        }else if(basedeletetime==-1){
             canEdit=userid.equals(discussant)&&maxdiscussid.equals(discussid);
        }else{
             canEdit=userid.equals(discussant)&&maxdiscussid.equals(discussid)&&timePass<=basedeletetime;
        }
        
      //获取默认楼层点赞数
        RecordSet1.execute("select * from cowork_votes where itemId="+coworkid+" and discussid="+discussid+" and status = 0");
        int initagree= RecordSet1.getCounts();
        RecordSet1.execute("select * from cowork_votes where itemId="+coworkid+" and discussid="+discussid+" and status = 0 and userid="+userid);
        int useragree= RecordSet1.getCounts();
      
     //判断是否收藏
        RecordSet1.execute("select * from cowork_collect where itemId="+coworkid+" and discussid="+discussid+"  and userid="+userid);
        int collectcount= RecordSet1.getCounts();
	%>
	<div id="discuss_div_<%=discussid%>" class="discuss_item" _discussid="<%=discussid%>">
	 <div class="discussdiv">
	 <div class="discuss_arrow"></div>
	 <table class="discuss" id="discuss_table_<%=discussid%>" cellpadding="0" cellspacing="0">
     <tr> 
        <td valign="top" width="35px" class="userHeadTd" style="<%if(isCoworkHead.equals("0")){%>display:none<%}%>">
            <div class="userHead">
               <img src="<%=isAnonymous.equals("0")?ResourceComInfo.getMessagerUrls(discussant):"/messager/images/icon_m_wev8.jpg"%>" width="30" border="0" align="top"/>
            </div>
        </td>
        <td valign="top" width="*" style="work-break:break-all;padding-left:3px" id="discussContentTd_<%=discussid%>">
            <table cellpadding="0" style="float: left;width: 100%;TABLE-LAYOUT: fixed;" cellspacing="0" id="discuss_content_<%=discussid%>">
               <col width="65px"/>
               <col width="*"/>
               <tr>
                  <td colspan="2" style="padding-bottom: 2px">
				    <div style="width:360px;float: left">
                      <%if(!"replay".equals(recordType)&&isManager){%>
                      	<span><input type="checkbox" name="discuss_check" style="border:0px;height:13px;line-height:13px;" value="<%=discussid%>"></span>
                      <%}%>
                      <%if(isAnonymous.equals("0")){%>
                      	<a href="javascript:void(0)" class="name" onclick="pointerXY(event);openhrm('<%=discussant%>');return false;"><%=Util.toScreen(ResourceComInfo.getResourcename(discussant),user.getLanguage())%></a>
                      <%}else{%>
                      	<a href="javascript:void(0)" class="name"><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%></a>
                      <%}%>
                      <%if("replay".equals(recordType)){
                    	String coworkName=dao.getCoworkName(coworkid);
                      %>
                      <span style="color: #999999;margin-left: 8px;"><%=SystemEnv.getHtmlLabelName(83258,user.getLanguage())%>：</span><a style="color:#6699ff" target="_blank" href="/cowork/ViewCoWork.jsp?id=<%=coworkid%>"><%=coworkName%></a>
                    <%}%>
                    </div>
                       
	                    <div class="right">
							<span class="time right">#<%=floorNum%></span>
                        </div>
                        
						<div class="clear"></div>
                    
				 </td>
               </tr>
               
               <!-- 被回复内容 -->
               <%if(replayid!=null&&!"0".equals(replayid)&&!"".equals(replayid)){
	              CoworkDiscussVO discussvo=dao.getCoworkDiscussVO(replayid);
	              if(discussvo!=null){
			      String preremark = Util.StringReplace(discussvo.getRemark().trim(),"\n","<br>");
			      ArrayList relatedprjList2=discussvo.getRelatedprjList();       
			      ArrayList relatedcusList2=discussvo.getRelatedcusList();
			      ArrayList relatedwfList2=discussvo.getRelatedwfList();
			      ArrayList relateddocList2=discussvo.getRelateddocList();
			      ArrayList relatedaccList2=discussvo.getRelatedaccList();
			      ArrayList relatemutilprjsList2=discussvo.getRelatemutilprjsList();
				  String isReplyAnonymous=Util.null2String(discussvo.getIsAnonymous()); 
	           %>
	           <tr>
	           <td colspan="2" style="border: 1px solid #dadada;background-color:#f7fcfd;padding: 5px 5px 2px 5px">
                      <table cellpadding="0" cellspacing="0" style="width: 100%;TABLE-LAYOUT: fixed;">
                         <col width="65px"/>
                         <col width="*"/>
                         <tr>
                             <td colspan="2">
                                <span style="color: #999999"><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%>&nbsp;<%=discussvo.getFloorNum()%>#</span>&nbsp;&nbsp;
								
								<%if(isReplyAnonymous.equals("0")){%>
									<a href="javascript:void(0)" onclick="pointerXY(event);openhrm('<%=discussvo.getDiscussant()%>');return false;" class="name"><%=Util.toScreen(ResourceComInfo.getResourcename(discussvo.getDiscussant()),user.getLanguage())%></a>
								  <%}else{%>
									<a href="javascript:void(0)" class="name"><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%></a>
								<%}%>

                                <span class="time"><%=CoworkTransMethod.getFormateDate(discussvo.getCreatedate(),discussvo.getCreatetime()) %></span>  
                             </td>
                         </tr>
                         <tr>
                             <td colspan="2" class="discuss_replayContent" style="color:#666;">
                                 <div style="overflow: auto;">
                                 	<%=preremark%>
                                 </div>
                                 <div style="margin-top:8px;margin-bottom:8px;">
                                 	<%=dao.showRelatedaccList(relatedaccList2,user,id)%>
                                 </div>
                             </td>
                         </tr>
                         <%if(relateddocList2.size()!=0){ //文档%>
				          <tr>
			                 <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</td>
			                 <td style="word-break:break-all">
			                    <%for(int i=0;i<relateddocList2.size();i++){%>
								  <a href="javascript:void(0)" onclick="opendoc2('<%=relateddocList2.get(i).toString()%>',<%=id%>);return false" class="relatedLink">
									<%=DocComInfo.getDocname(relateddocList2.get(i).toString())%>
								  </a>
								<%}%>
			                    </td>
		                     </tr>
			             <%} %>
			             
			             <!-- 相关流程 -->
			           <%if(relatedwfList2.size()!=0){%>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<relatedwfList2.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList2.get(i).toString()%>');return false" class="relatedLink">
											<%=RequestComInfo.getRequestname(relatedwfList2.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
			           <!-- 相关客户 -->
			           <%if(isgoveproj==0&&relatedcusList2.size()!=0){ %>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<relatedcusList2.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?moduleid=cowork&coworkid=<%=id%>&CustomerID=<%=relatedcusList2.get(i).toString()%>');return false" class="relatedLink">
											<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList2.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%} %>
	           
			           <!-- 相关项目 -->
			           <%if(isgoveproj==0&&relatemutilprjsList2.size()!=0){%>
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<relatemutilprjsList2.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=relatemutilprjsList2.get(i).toString()%>');return false" class="relatedLink">
											<%=projectInfoComInfo.getProjectInfoname(relatemutilprjsList2.get(i).toString())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
	           
			           <!-- 相关任务 -->
			           <%if(isgoveproj==0&&relatedprjList2.size()!=0){%>    
			              <tr>
			                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>：</td>
			                    <td style="word-break:break-all">
			                       <%for(int i=0;i<relatedprjList2.size();i++){%>
										<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList2.get(i).toString()%>');return false" class="relatedLink">
											<%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList2.get(i).toString()),user.getLanguage())%>
										</a>
								   <%}%>	
			                    </td>
			               </tr>
			           <%}%>
	           
                      </table>
                  </td>  
               </tr>
	           <%}}%>
	           <!-- 被回复的内容 -->
               <tr>
	              <td colspan="2"  valign="top" style="padding-top: 8px">
	              	<div class="discuss_content" style="overflow: auto;">
	              		<%if(approvalAtatus.equals("0")||isManager||discussant.equals(userid)){%>
	              			<%=remark2html%>
	              		<%}%>
	              	</div>
	              	<div style="margin-top:8px;margin-bottom:8px;">
	              		<%=dao.showRelatedaccList(relatedaccList,user,id)%>
	              	</div>
	               </td>
               </tr>
               
               <!-- 相关文档 -->
               <%if(relateddocList.size()!=0){%>
	               <tr>
	                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                        <%for(int i=0;i<relateddocList.size();i++){%>
								<a href="javascript:void(0)" onclick="opendoc2('<%=relateddocList.get(i).toString()%>',<%=id%>);return false" class="relatedLink">
								  <%=DocComInfo.getDocname(relateddocList.get(i).toString())%>
								</a>
							<%}%>
	                    </td>
	               </tr>
	           <%}%>
	           <!-- 相关流程 -->
	           <%if(relatedwfList.size()!=0){%>
	              <tr>
	                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%for(int i=0;i<relatedwfList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>');return false" class="relatedLink">
									<%=RequestComInfo.getRequestname(relatedwfList.get(i).toString())%>
								</a>
						   <%}%>	
	                    </td>
	               </tr>
	           <%}%>
	           <!-- 相关客户 -->
	           <%if(isgoveproj==0&&relatedcusList.size()!=0){ %>
	              <tr>
	                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%for(int i=0;i<relatedcusList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?moduleid=cowork&coworkid=<%=id%>&CustomerID=<%=relatedcusList.get(i).toString()%>');return false" class="relatedLink">
									<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())%>
								</a>
						   <%}%>	
	                    </td>
	               </tr>
	           <%} %>
	           
	           <!-- 相关项目 -->
	           <%if(isgoveproj==0&&relatemutilprjsList.size()!=0){%>
	              <tr>
	                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%for(int i=0;i<relatemutilprjsList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID=<%=relatemutilprjsList.get(i).toString()%>');return false" class="relatedLink">
									<%=projectInfoComInfo.getProjectInfoname(relatemutilprjsList.get(i).toString())%>
								</a>
						   <%}%>	
	                    </td>
	               </tr>
	           <%}%>
	           
	           <!-- 相关任务 -->
	           <%if(isgoveproj==0&&relatedprjList.size()!=0){%>    
	              <tr>
	                    <td style="white-space:nowrap;vertical-align: top;" class="bcolor"><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>：</td>
	                    <td style="word-break:break-all;vertical-align: top">
	                       <%for(int i=0;i<relatedprjList.size();i++){%>
								<a href="javascript:void(0)" onclick="openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>');return false" class="relatedLink">
									<%=Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString()),user.getLanguage())%>
								</a>
						   <%}%>	
	                    </td>
	               </tr>
	           <%}%>
	           
	           <%if(approvalAtatus.equals("1")){%>
	           	   <tr>
	                    <td colspan="2" style="white-space:nowrap;vertical-align: top;" class="bcolor">
	                    	<span style="color: red;">[<%=SystemEnv.getHtmlLabelName(83261,user.getLanguage())%>]</span>
	                    </td>
	               </tr>
	           <%}%>
	           
	           <!-- 评论列表 -->
               <%
               	List commentList=dao.getCommentList(discussid);
               %>
               <tr class="commenttr" id="commenttr_<%=discussid%>" style="display:<%=commentList.size()>0?"":"none"%>">
               		<td colspan="2">
               			<div class="commentlist">
			       		   <%
			       		   for(int i=0;i<commentList.size();i++){ 
			       		     CoworkDiscussVO commentvo=(CoworkDiscussVO)commentList.get(i);
			       		     String commentdiscussant=commentvo.getDiscussant();
			       		     String commentdiscussid=commentvo.getId();
			       		     String commentuserid=Util.null2String(commentvo.getCommentuserid());
			       		     String comemntremark=commentvo.getRemark();
			       		     String isCommentAnonymous=Util.null2String(commentvo.getIsAnonymous());
							 String commentid1 = Util.null2String(commentvo.getCommentid());
							 CoworkDAO coworkDAO = new CoworkDAO();
							 CoworkDiscussVO commentvo1= coworkDAO.getCoworkDiscussVO(commentid1);
                             
							 if(commentvo1!=null){
    							 String topdiscussid1 = commentvo1.getTopdiscussid();
    							 String discusantid1 = commentvo1.getDiscussant();
                                 String isAnonymous1 = commentvo1.getIsAnonymous();
			       		   %>
				       		   <div class="commentitem <%=i==(commentList.size()-1)?"":"commentline"%>">	 
				       			 <div>
				       			 	<div class="left">
				       			 		<%if(isCommentAnonymous.equals("0")){%>
				       			 			<a href="javascript:void(0)" class="name" onclick="pointerXY(event);openhrm('<%=commentdiscussant%>');return false;"><%=Util.toScreen(ResourceComInfo.getResourcename(commentdiscussant),user.getLanguage())%></a>
				       			 		<%}else{%>
				       			 			<a href="javascript:void(0)" class="name"><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%></a>
				       			 		<%}%>
										<%if(!topdiscussid1.equals("0")){%>
											<%if("1".equals(isAnonymous1)){%>
												<span class="time"><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></span>&nbsp;
												<a href="javascript:void(0)" class="name"><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%></a>
											<%}else{%>
												<span class="time"><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></span>&nbsp;
												<a href="javascript:void(0)" class="name" onclick="pointerXY(event);openhrm('<%=discusantid1%>');return false;"><%=ResourceComInfo.getResourcename(discusantid1)%></a>
											<%}%>
										<%}%>
				       			 		&nbsp;&nbsp;<span class="time"><%=CoworkTransMethod.getFormateDate(commentvo.getCreatedate(),commentvo.getCreatetime())%></span>
				       			 	</div>
				       			 	<div class="clear"></div>
				       			 </div>
				       			 <div class="content discuss_commentContent">
				       			 	<%=comemntremark%>
				       			 </div>
				       		  </div> 
							<%}%>
			       		  <%}%>
			            </div>
               		</td>
               </tr>
               <!-- 评论列表 -->
               
	           
	           <tr id="replaytr_<%=discussid%>">
		        <td colspan="2">
		           <div id="replay_<%=discussid%>" class="replaydiv" ></div>
		        </td>
               </tr>
               
            </table>
        </td>
     </tr>
  </table>
  </div>
 </div> 
<%}%>
<style>
.fieldName{padding-left:0px !important;}
.paddingLeft18{padding-left:5px !important;}
</style>

<%}else{%>
     <div class="norecord"><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></div>
<%}%>