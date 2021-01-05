
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.util.*"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="settingComInfo" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="WorkPlanSetInfo"	class="weaver.WorkPlan.WorkPlanSetInfo" scope="page" />
<%  //本文件为会议，日程共用相关交流编辑主页面 %>
<%
		User user = HrmUserVarify.getUser(request,response);
		if(user == null)  return ;
		String userid=String.valueOf(user.getUID());
		FileUpload fu = new FileUpload(request);
		String operation=fu.getParameter("operation");
		
		String discussid=Util.null2String(fu.getParameter("discussid"));
		String types=Util.null2String(fu.getParameter("types"));
		
		int isgoveproj = Util.getIntValue(request.getParameter("isgoveproj"),0);//0：非政务系统。2：政务系统。
		
		String isCoworkHead=settingComInfo.getIsCoworkHead(settingComInfo.getId(userid));//是否显示缩略图
		
		String logintype = user.getLogintype();
		
		String disType=Util.null2String((String)session.getAttribute("disType")); //协作讨论显示方式，tree为树形
		
		SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date nowdate=new Date();
		
		//编辑讨论
		if("edit".equals(operation)){
		String sql = "SELECT * FROM Exchange_Info where id = "+discussid;
		RecordSet.executeSql(sql);
		String creater = "";
	  	//String discussid = "";
	  	String createDate = "";
	  	String createTime = "";
		String remark2html = "";
		String docids_0=  "";
		String relateddoc=  "";
		String relatedprj=  "";
		String projectIDs=  "";
		String relatedcus=  "";
		String wfids=  "";
		String crmids="";
		String requestids="";
		if(RecordSet.next()){
			creater = RecordSet.getString("creater");
		  	//discussid = RecordSet.getString("id");
		  	createDate = RecordSet.getString("createDate");
		  	createTime = RecordSet.getString("createTime");
			remark2html = Util.StringReplace(RecordSet.getString("remark"),"<br>","\n");
			docids_0=  Util.null2String(RecordSet.getString("docids"));
			relateddoc=  Util.null2String(RecordSet.getString("relateddoc"));
			relatedprj=  Util.null2String(RecordSet.getString("relatedprj"));
			projectIDs=  Util.null2String(RecordSet.getString("projectIDs"));
			relatedcus=  Util.null2String(RecordSet.getString("relatedcus"));
			wfids=  Util.null2String(RecordSet.getString("relatedwf"));
			if("WP".equals(types)){
				relatedcus=  Util.null2String(RecordSet.getString("crmIds"));
				wfids=  Util.null2String(RecordSet.getString("requestIds"));
			}
		}
		
%>
   <%if("-1".equals(discussid) || "".equals(discussid)){ %>
		<input type='hidden' name='method1' value='add'>
   <%} else {%>
		<input type='hidden' name='method1' value='edit'>
	<%}%>
    <input type='hidden' name='discussid' value='<%=discussid %>'>
	<input type='hidden' name='types' value='<%=types%>'>	
	<TABLE style='WIDTH: 100%;border: 0;margin: 0;border-collapse: collapse;' cellspacing=1  >
	<colgroup>
	<col width='10'>
	<col width=''>
	<col width='10'>
    <TR >
		<td></td>
        <TD class=Field>
        <div style='width: 99%;margin-top: 2px;' align='center'>
        <TEXTAREA class=InputStyle NAME=ExchangeInfo id=ExchangeInfo ROWS=3 STYLE='width:100%'><%=remark2html %></TEXTAREA>
		</div>
		</td>
		<td></td>
	<TR >
		<td></td>
        <TD class=Field>		
		<div id="othbtndiv" style='width: 99%;margin-top: 3px;height: 25px;'>
			<div style='padding: 0px 0px 3px 0px;'>
				<div style='float: left;' align='center'> 
					<input type='button' onclick='exchangeSubmit(this);'  id='btnSubmit' class='e8_btn_submit'  value='<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>'>
				</div><!-- 提交 -->
				<%if(("MP".equals(types)&&(meetingSetInfo.getDscsDoc()==1||meetingSetInfo.getDscsWf() == 1||meetingSetInfo.getDscsCrm() == 1||meetingSetInfo.getDscsPrj() == 1||meetingSetInfo.getDscsTsk() == 1||meetingSetInfo.getDscsAttch() == 1))
						||("WP".equals(types)&&(WorkPlanSetInfo.getDscsDoc()==1||WorkPlanSetInfo.getDscsWf()==1||WorkPlanSetInfo.getDscsCrm()==1||WorkPlanSetInfo.getDscsPrj()==1||WorkPlanSetInfo.getDscsaccessory()==1))){ %>
				
				<div  align='right' style='float:right;padding-top:5px'>
					<img src='/images/ecology8/meeting/edit_down_wev8.png' id='external_img' align='absmiddle' style='margin-right:-3px;margin-top:-2px'/><a href='javascript:void(0)' onclick="external('external');return false;" class='externalBtn'>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(26165,user.getLanguage())%></a>&nbsp;&nbsp;<!-- 附加功能 -->
				</div>
				<%} %>
			</div>
		</div>
		</TD>
		<td></td>
    </TR>
	<TR style="height:2px">
        <TD class=Field colSpan="3" height="2px">
		</TD>
    </TR>
	<%if("-1".equals(discussid) || "".equals(discussid)){ %>
	<TR id="external" style="display:none;">
   <%} else {%>
	<TR id="external" style="display:;">
	<%}%>
		<td></td>
        <TD class=Field >	
       <wea:layout type="2col">
			<wea:group context="" attributes="{'groupDisplay':\"none\"}" >
			<%if((meetingSetInfo.getDscsDoc() == 1 &&"MP".equals(types)) || WorkPlanSetInfo.getDscsDoc()==1&&"WP".equals(types) || (!"MP".equals(types)&&!"WP".equals(types)) ) {%>
               <!-- 相关文档 -->
               <wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
               <wea:item>
              	<%  
			        String docsname="";
			        if(!docids_0.equals("")){
			
			            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
			            int docsnum = docs_muti.size();
			
			            for(int i=0;i<docsnum;i++){
			                docsname= docsname+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"," ;               
			            }
			        }
			      %>
				  <brow:browser viewType="0" name="docids" browserValue='<%=docids_0 %>' 
					browserOnClick="" browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px" 
					completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp?id=" 
					browserSpanValue='<%=docsname %>'></brow:browser>
              </wea:item>
           <%} %>
           <%if((meetingSetInfo.getDscsWf() == 1&&"MP".equals(types)) || WorkPlanSetInfo.getDscsWf()==1&&"WP".equals(types)|| (!"MP".equals(types)&&!"WP".equals(types))) {%>
               <!-- 相关流程 -->
               <wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item>
               <wea:item>
               	   <%
			       	
			      	String wfsname="";
			       	if(!wfids.equals("")){
						ArrayList wfids_muti = Util.TokenizerString(wfids,",");
						for(int i=0;i<wfids_muti.size();i++){
							wfsname += RequestComInfo.getRequestname(wfids_muti.get(i).toString()) + ",";
						}
					}%>
				  <brow:browser viewType="0" name="relatedwf" browserValue='<%=wfids %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
					hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px" 
					completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
					browserSpanValue='<%=wfsname%>'></brow:browser>
              </wea:item>
           <%} %>
           <%if((meetingSetInfo.getDscsCrm() == 1&&"MP".equals(types)) || WorkPlanSetInfo.getDscsCrm()==1&&"WP".equals(types)|| (!"MP".equals(types)&&!"WP".equals(types))) {%>
               <!-- 相关客户 -->
              <wea:item attributes="{'display':\"<%if(isgoveproj!=0){ %>none<%}%>\"}" ><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
                <wea:item attributes="{'display':\"<%if(isgoveproj!=0){ %>none<%}%>\"}" >
               	  <%
			      	
					String crmNames = "";
			     	if(!relatedcus.equals("")){
			       		ArrayList arrs = Util.TokenizerString(relatedcus,",");
				  		for(int i=0;i<arrs.size();i++){
							crmNames += CustomerInfoComInfo.getCustomerInfoname(arrs.get(i).toString()) + ",";
							
						}
					}%>	
				  <brow:browser viewType="0" name="relatedcus" browserValue='<%=relatedcus %>' 
					browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="%>'
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
					completeUrl="/data.jsp?type=18" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
					browserSpanValue='<%=crmNames%>'></brow:browser>
               </wea:item>
            <%} %>
           <%if((meetingSetInfo.getDscsPrj() == 1&&"MP".equals(types)) || WorkPlanSetInfo.getDscsPrj()==1&&"WP".equals(types)|| (!"MP".equals(types)&&!"WP".equals(types))) {%>
              <!-- 相关项目 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
                <wea:item>
               	 <%
			     	
					String prjnames = "";
					if(!projectIDs.equals("")){
			       		ArrayList arrs = Util.TokenizerString(projectIDs,",");
				  		for(int i=0;i<arrs.size();i++){
							prjnames += ProjectInfoComInfo.getProjectInfoname(arrs.get(i).toString()) + ",";
						}
					}%>
				  <brow:browser viewType="0" name="projectIDs" browserValue='<%=projectIDs%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
					completeUrl="/data.jsp?type=8" linkUrl="/proj/data/ViewProject.jsp?ProjID=#id#&id=#id#" 
					browserSpanValue='<%=prjnames%>'></brow:browser>
                </wea:item>
            <%} %>
           <%if(meetingSetInfo.getDscsTsk() == 1 && "MP".equals(types)) {%>
               <!-- 相关项目任务 -->
				<wea:item attributes="{'display':\"<%if(isgoveproj!=0){ %>none<%}%>\"}" ><%=SystemEnv.getHtmlLabelNames("522,1332",user.getLanguage())%></wea:item>
				<wea:item attributes="{'display':\"<%if(isgoveproj!=0){ %>none<%}%>\"}" >
               	<%
			    	
					String relatedprjnames = "";
					if(isgoveproj==0&&!relatedprj.equals("")){
			       		ArrayList arrs = Util.TokenizerString(relatedprj,",");
				  		for(int i=0;i<arrs.size();i++){
							relatedprjnames += Util.toScreen(ProjectTaskApprovalDetail.getTaskSuject(arrs.get(i).toString()),user.getLanguage()) + ",";
						}
					}%>
				 <brow:browser viewType="0" name="relatedprj" browserValue='<%=relatedprj %>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids="
					hasInput="false"  isSingle="false" hasBrowser = "true" isMustInput='1' width="300px"
					completeUrl="/data.jsp?type=NO" linkUrl="/proj/process/ViewTask.jsp?taskrecordid=#id#&id=#id#" 
					browserSpanValue='<%=relatedprjnames%>'></brow:browser>
                </wea:item>
            <%} %>
           <%if((meetingSetInfo.getDscsAttch() == 1 && "MP".equals(types))||(WorkPlanSetInfo.getDscsaccessory()==1&&"WP".equals(types))) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
               <%
					if((!meetingSetInfo.getDscsAttchCtgry().equals("")&& "MP".equals(types))||(!WorkPlanSetInfo.getDscsaccessorydir().equals("")&&"WP".equals(types))){//如果设置了目录，则取值
					    
					    ArrayList arrayaccessorys = Util.TokenizerString(relateddoc,",");
					    String mainId = "";
				        String subId = "";
				        String secId = "";
					if("MP".equals(types)){
						 String[] categoryArr = Util.TokenizerString2(meetingSetInfo.getDscsAttchCtgry(),",");
							
							if(categoryArr.length >= 3){
								mainId = categoryArr[0];
								subId = categoryArr[1];
								secId = categoryArr[2];
							}
					}else if("WP".equals(types)){
						
						mainId = "-1";
						subId = "-1";
						secId = WorkPlanSetInfo.getDscsaccessorydir();
					}
				       
				        String maxsize = "";
				        RecordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
					    RecordSet.next();
					    maxsize = Util.null2String(RecordSet.getString(1));
						
						if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
						%>
						<wea:item>
					     <input type="hidden" id="edit_relatedacc" name="edit_relatedacc" value="<%=relateddoc%>"/>
					     <input type="hidden" id="delrelatedacc" name="delrelatedacc" value=""/>	
				         <%int linknum=-1;
				         for(int i=0;i<arrayaccessorys.size();i++){
				            rs.executeSql("select id,docsubject,accessorycount from docdetail where id="+arrayaccessorys.get(i));
				            
				          	if(rs.next()){
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
				            <a  style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>');return false"><%=docImagefilename%></a>&nbsp
				          <%}else{%>
				            <a style="cursor:hand" onclick="opendoc1('<%=showid%>');return false"><%=tempshowname%></a>&nbsp
									<%}
				          if(accessoryCount==1){%>
				              <span id = "selectDownload">
				                <%
				                  //boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Integer.parseInt(showid));
				                  //if(!isLocked){
				                %>
									<input type="button" class="e8_btn_cancel" accessKey=1  onclick='onDeleteAcc("span_id_<%=linknum%>","<%=showid%>")' value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"/>
					                  <span id="span_id_<%=linknum%>" name="span_id_<%=linknum%>" style="display: none">
					                    <B><FONT COLOR="#FF0033">√</FONT></B>
					                  </span>
	                             
				                <%//}%>
				              </span>
								<%}%>
								<br>
								<%}
				          	}%>
								<div id="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>" style="margin-top: 0px"></div>
							</wea:item>
						<%} else {%>
						<wea:item><font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font></wea:item>
						<%}
					}else{%>
					 <wea:item><font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font></wea:item>
					<%}%> 
		   <%} %>
			</wea:group>
		</wea:layout>
		</TD>
		<td></td>
    </TR>

	</TABLE>
<%
		}%>
