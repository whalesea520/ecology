
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.cowork.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.util.*"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.file.Prop"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="settingComInfo" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<jsp:useBean id="CoworkTransMethod" class="weaver.general.CoworkTransMethod" scope="page" />
<jsp:useBean id="CoworkService" class="weaver.cowork.CoworkService" scope="page" />

<%
		User user = HrmUserVarify.getUser(request,response);
		if(user == null)  return ;
		String userid=String.valueOf(user.getUID());;
		String operation=request.getParameter("operation");
		
		String discussid=request.getParameter("discussid");
		
		int isgoveproj = Util.getIntValue(request.getParameter("isgoveproj"),0);//0：非政务系统。2：政务系统。
		
		String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(userid));//是否显示缩略图
		
		String logintype = user.getLogintype();
		
		String disType=Util.null2String((String)session.getAttribute("disType")); //协作讨论显示方式，tree为树形
		
		SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date nowdate=new Date();
		
		boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1"); //是否启用了message
		
		//编辑讨论
		if("edit".equals(operation)){
		
		String typeid=request.getParameter("typeid");
        
        CoworkDAO dao=new CoworkDAO();
		CoworkDiscussVO vo2=(CoworkDiscussVO)dao.getCoworkDiscussVO(discussid);
		String coworkid=vo2.getCoworkid();
		String discussant = Util.null2String(vo2.getDiscussant());
		
		String createdate = Util.null2String(vo2.getCreatedate());
		String createtime = Util.null2String(vo2.getCreatetime());
		
		String maxdiscussid=dao.getMaxDiscussid(""+coworkid);//最大讨论记录id

		boolean result=true;
		long timePass=100L;
		
		String dateStr="";
		if(createtime.length()==5)
			dateStr=createdate+" "+createtime+":00";
		else
			dateStr=createdate+" "+createtime;
		Date discussDate=dateFormat.parse(dateStr);  //回复时间
		timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
        
        //获取协作基础配置信息(删除交流内容时间)Start
      
        RecordSet1.execute("select * from cowork_base_set");
        int basedeletetime;//设置时间//0-表示提交后不能再修改；空-表示提交后一直可修改
        if(RecordSet1.next()){
            basedeletetime=RecordSet1.getInt("dealchangeminute");
        }else{
            basedeletetime=10;
        }
	    if(!maxdiscussid.equals(discussid)){
			out.println("1");
		    result=false;
		}else if(basedeletetime==0){
            out.println("3");
            result=false;
        }   else if(timePass>basedeletetime&&basedeletetime!=-1){
			out.println("2");
		    result=false;
		}	
        //-----------------------------------------end
        
		if(result){
		String remark2 = Util.null2String(vo2.getRemark());
		String remark2html = Util.StringReplace(remark2,"\r\n","");
		remark2html=remark2html.replaceAll("&lt;","&amp;lt;");
		remark2html=remark2html.replaceAll("&gt;","&amp;gt;");
		String relatedprj = Util.null2String(vo2.getRelatedprj());
		String relatedcus = Util.null2String(vo2.getRelatedcus());
		String relatedwf = Util.null2String(vo2.getRelatedwf());
		String relateddoc = Util.null2String(vo2.getRelateddoc());
		String relatedmutilPrj=Util.null2String(vo2.getRelatedmutilprj());
		
		
		ArrayList relatedprjList = vo2.getRelatedprjList();
		ArrayList relatedcusList = vo2.getRelatedcusList();
		ArrayList relatedwfList = vo2.getRelatedwfList();
		ArrayList relateddocList = vo2.getRelateddocList();
		
		ArrayList relatedaccList = vo2.getRelatedaccList();
		
		String relatedacc=vo2.getRelatedacc();
		
		ArrayList relatemutilprjsList = vo2.getRelatemutilprjsList();
		
		//新添加字段
		String floorNum=vo2.getFloorNum();
		String replayid=vo2.getReplayid();
		
		Map appStatusMap=CoworkService.getAppStatus();
		
%>
   
    <div id="editdiv">
      <table style="width:100%">
        <tr>
        <td valign="top" class="userHeadTd">
        <div class="userHead" style="<%if(isCoworkHead.equals("0")){%>display:none<%}%>" align="left">
           <img src="<%=ResourceComInfo.getMessagerUrls(discussant)%>" width="30" border="0" align="top"/>
        </div>
        </td>
        <td>
        <div class="discussContent" style="width:98%">
         <input type=hidden name="discussid" id="discussid" value="<%=discussid%>">
         <input type="hidden" name="id" value="<%=coworkid%>">
		 <textarea name="remark_content" _editorName="remark_content" style="width:100%;height:80px;border:1px solid #C7C7C7;" class="replayContent" ><%=remark2html%></textarea>
		 
		 <div class="discussOperation" align="left">
		     <div style="padding:5px 0 5px 0;border-bottom:1px solid #dadada;">
		     	<div class="left">
					<button type="button" onclick="doSave(this,'editdiscuss')"  id="btnSubmit" class="submitBtn"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
					<button type="button" onclick="cancelReply(this,'edit');return false"  id="btnSubmit" class="cancelBtn"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
				</div>
				<%if(appStatusMap.size()>0){%>
					<div class="right">
						<div onclick="showExternal(this)" class="extendbtn" id="extendbtn"><%=SystemEnv.getHtmlLabelName(26165,user.getLanguage())%></div>
					</div>
				<%}%>
				<div class="clear"></div>
             </div>
         </div>
		 
		 <div id="editExternal" class="externalDiv" style="width: 100%">
		 <wea:layout type="2col" attributes="{'layoutTableId':'table1'}">
	   		<wea:group context="" attributes="{'groupDisplay':'none'}">
	   			<!-- 相关文档 -->
	   			<%if(appStatusMap.containsKey("doc")){%>
	   			<wea:item>
	   				<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>
	   			</wea:item>
	   			<wea:item>
	   				<%
               	     String docNames="";
		   			 for(int i=0;i<relateddocList.size();i++){
		   				docNames+=","+DocComInfo.getDocname(relateddocList.get(i).toString());
					 }
		   			 docNames=docNames.length()>0?docNames.substring(1):"";
               	   %>
               	   <brow:browser viewType="0" name="edit_relateddoc" browserValue='<%=relateddoc%>'
				               	browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
				               	linkUrl="/docs/docs/DocDsp.jsp?id=" 
				               	completeUrl="/data.jsp?type=9"
				               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue='<%=docNames%>'> 
               	   </brow:browser>
	   			</wea:item>
	   			<%}%>
	   			<!-- 相关流程 -->
	   			<%if(appStatusMap.containsKey("workflow")){%>
	   			<wea:item>
	   				<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>
	   			</wea:item>
	   			<wea:item>
	   				<%
               	     String wfNames="";
		   			 for(int i=0;i<relatedwfList.size();i++){
		   				wfNames+=","+RequestComInfo.getRequestname(relatedwfList.get(i).toString());
					 }
		   			 wfNames=wfNames.length()>0?wfNames.substring(1):"";
               	   %>
               	   <brow:browser viewType="0" name="edit_relatedwf" browserValue='<%=relatedwf%>'
				               	browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp"
				               	linkUrl="/workflow/request/ViewRequest.jsp?requestid=" 
				               	completeUrl="/data.jsp??type=152"
				               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue='<%=wfNames%>'> 
               	   </brow:browser>
	   			</wea:item>
	   			<%} %>
	   			<!-- 相关客户 -->
	   			<%if(appStatusMap.containsKey("crm")){%>
		   			<wea:item>
		   				<%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>
		   			</wea:item>
		   			<wea:item>
		   				<%
	               	     String cusNames="";
			   			 for(int i=0;i<relatedcusList.size();i++){
			   				cusNames+=","+CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString());
						 }
			   			cusNames=cusNames.length()>0?cusNames.substring(1):"";
	               	   %>
	               	   <brow:browser viewType="0" name="edit_relatedcus" browserValue='<%=relatedcus%>'
					               	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
					               	linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=" 
					               	completeUrl="/data.jsp??type=7"
					               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue='<%=cusNames%>'> 
	               	   </brow:browser>
		   			</wea:item>
	   			<%}%>
	   			<!-- 相关项目 -->
	   			<%if(appStatusMap.containsKey("project")){%>
		   			<wea:item>
		   				<%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>
		   			</wea:item>
		   			<wea:item>
		   				<%
	               	     String prjNames="";
			   			 for(int i=0;i<relatemutilprjsList.size();i++){
			   				prjNames+=","+projectInfoComInfo.getProjectInfoname(relatemutilprjsList.get(i).toString());
						 }
			   			 prjNames=prjNames.length()>0?prjNames.substring(1):"";
	               	   %>
	               	   <brow:browser viewType="0" name="edit_projectIDs" browserValue='<%=relatedmutilPrj%>'
					               	browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp"
					               	linkUrl="/proj/data/ViewProject.jsp?ProjID=" 
					               	completeUrl="/data.jsp?type=8"
					               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue='<%=prjNames%>'> 
	               	   </brow:browser>
		   			</wea:item>
	   			<%}%>
	   			
	   			<!-- 相关项目任务 -->
	   			<%if(appStatusMap.containsKey("task")){%>
		   			<wea:item>
		   				<%=SystemEnv.getHtmlLabelName(522,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>
		   			</wea:item>
		   			<wea:item>
		   				<%
	               	     String prjNames="";
			   			 for(int i=0;i<relatedprjList.size();i++){
			   				prjNames+=","+ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString());
						 }
			   			 prjNames=prjNames.length()>0?prjNames.substring(1):"";
	               	   %>
	               	   <brow:browser viewType="0" name="edit_relatedprj" browserValue='<%=relatedmutilPrj%>'
					               	browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp"
					               	linkUrl="/proj/process/ViewTask.jsp?taskrecordid=" 
					               	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue='<%=prjNames%>'> 
	               	   </brow:browser>
		   			</wea:item>
	   			<%}%>
	   			
	   			<!-- 相关附件 -->
	   			<%if(appStatusMap.containsKey("attachment")){%>
	   			<wea:item>
	   				<%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>
	   			</wea:item>
	   			<wea:item>
	   				<%
		            //附件上传目录
					Map dirMap=dao.getAccessoryDir(typeid);
				    String mainId =(String)dirMap.get("mainId");
				    String subId = (String)dirMap.get("subId");
				    String secId = (String)dirMap.get("secId");
				    String maxsize = (String)dirMap.get("maxsize");
			         %>
			         <input type="hidden" name="newrelateacc" id="newrelateacc" value=""/>
				     <input type="hidden" id="edit_relatedacc" name="edit_relatedacc" value="<%=relatedacc%>"/>
				     <input type="hidden" id="delrelatedacc" name="delrelatedacc" value=""/>	
			         <%
			         int linknum=-1;
			         for(int i=0;i<relatedaccList.size();i++){
			            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+relatedaccList.get(i));
			            
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
							<div>
								<%=imgSrc%>
								<%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx"))){%>
						            <a  style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>');return false"><%=docImagefilename%></a>&nbsp
						        <%}else{%>
						            <a style="cursor:hand" onclick="opendoc1('<%=showid%>');return false"><%=tempshowname%></a>&nbsp;
								<%}%>
                             	<a href="javascript:void(0)" onclick="onDeleteAcc(this,'<%=showid%>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
                            </div> 	
							<%}
			          	}%>
						<div id="edit_uploadDiv" class="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>" style="margin-top: 0px"></div>
	   			</wea:item>
	   			<%}%>
	   		</wea:group>
	   	</wea:layout>
	   	
      </div>
         </div>   
      </td>
        </tr>
      </table>           
	 </div>
<%}
}else if("getComment".equals(operation)){
	 CoworkDAO dao=new CoworkDAO();
	 CoworkDiscussVO commentvo=(CoworkDiscussVO)dao.getCoworkDiscussVO(discussid);
	 String commentdiscussant=commentvo.getDiscussant();
     String commentdiscussid=commentvo.getId();
     String commentuserid=commentvo.getCommentuserid();
     String comemntremark=commentvo.getRemark();
     String topdiscussid=commentvo.getTopdiscussid();
     String isCommentAnonymous=Util.null2String(commentvo.getIsAnonymous());
	 String commentid1 = Util.null2String(commentvo.getCommentid());
	 CoworkDAO coworkDAO = new CoworkDAO();
	 CoworkDiscussVO commentvo1= coworkDAO.getCoworkDiscussVO(commentid1);
	 if(commentvo1!=null){
         String topdiscussid1 = commentvo1.getTopdiscussid();
    	 String discusantid1 = commentvo1.getDiscussant();
    	 String isAnonymous1 = commentvo1.getIsAnonymous();
%>  
  <div class="commentitem">	 
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
	 	<div class="right">
	 		<a href="javascript:void(0)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="delete" onclick="delComment('<%=commentdiscussid%>',this);return false;" ></a>
	 		<a href="javascript:void(0)" title="<%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%>" class="reply" onclick="showReplay(this,'<%=commentdiscussid%>','comment','<%=commentdiscussant%>','<%=topdiscussid%>');return false;"></a>
	 	</div>
	 	<div class="clear"></div>
	 </div>
	 <div class="content discuss_commentContent">
	 	<%=comemntremark%>
	 </div>
  </div> 
  <%}%>
<%}%>