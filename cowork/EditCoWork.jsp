
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.cowork.*" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CoTypeRight" class="weaver.cowork.CoTypeRight" scope="page"/>
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="CoworkService" class="weaver.cowork.CoworkService" scope="page" />
<HTML>
<%	
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);  
int id=Util.getIntValue(request.getParameter("id"),0);
String from = Util.null2String(request.getParameter("from"));
int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);

String levelvalue="";
String typeid="";
String begindate="";
String beingtime="";
String enddate="";
String endtime="";
String relatedprj="";
String relatedcus="";
String relatedwf="";
String relateddoc="";
String remark="";
String remarkhtml="";
String creater="";
String name="";
String relatedacc="";
String mutil_prjsid = "";//td11838
String principal="";
String isAnonymous="";
String isApproval="";
String status="";
String isApply="";

ArrayList relatedprjList = new ArrayList();
ArrayList relatedcusList = new ArrayList();
ArrayList relatedwfList = new ArrayList();
ArrayList relateddocListTemp = new ArrayList();
ArrayList relateddocList = new ArrayList();
ArrayList mutilPrjsList = new ArrayList();//td11838
ArrayList relatedaccList = new ArrayList();
ConnStatement statement=new ConnStatement();
String sql = "select * from cowork_items where id = "+id;
boolean ismanager = false;
try{
	statement.setStatementSql(sql);
	statement.executeQuery();
	if(statement.next()){
		name = Util.toScreenToEdit(statement.getString("name"),user.getLanguage());
		typeid = statement.getString("typeid");
		levelvalue = statement.getString("levelvalue");
		creater = statement.getString("creater");
        
		begindate = statement.getString("begindate");
		beingtime = statement.getString("beingtime");
		enddate = statement.getString("enddate");
		endtime = statement.getString("endtime");		
		relatedprj = statement.getString("relatedprj");
		if(relatedprj.equals("0"))relatedprj="";//防止旧的数据为0的情况
		relatedprjList = Util.TokenizerString(relatedprj,",");
		relatedcus = statement.getString("relatedcus");
		if(relatedcus.equals("0"))relatedcus="";
		relatedcusList = Util.TokenizerString(relatedcus,",");
		relatedwf = statement.getString("relatedwf");
		if(relatedwf.equals("0"))relatedwf="";
		relatedwfList = Util.TokenizerString(relatedwf,",");
		relateddoc = statement.getString("relateddoc");
		if(relateddoc.equals("0"))relateddoc="";
		relateddocListTemp = Util.TokenizerString(relateddoc,",");//here relateddoc like 1780|8
		
		mutil_prjsid = statement.getString("mutil_prjs");//td11838
		if(mutil_prjsid.equals("0")) mutil_prjsid = "";
		mutilPrjsList = Util.TokenizerString(mutil_prjsid,",");
		
		relateddoc = "";//for TD2533
		for(int i=0;i<relateddocListTemp.size();i++){
				String temp = relateddocListTemp.get(i).toString();
			if(temp.indexOf("|")!=-1){
				relateddocList.add(temp.substring(0,temp.indexOf("|")));
				relateddoc += ","+temp.substring(0,temp.indexOf("|"));//for TD2533
			}
		}
		if(relateddocListTemp.size()>0)//for TD2533
			relateddoc = relateddoc.substring(1);//for TD2533
		
		remark = statement.getString("remark");
		//String remarkhtml = Util.StringReplace(Util.toHtml(remark.trim()),"\n","<br>");
		remarkhtml = Util.StringReplace(remark,"<br>","\n");
		remarkhtml=remarkhtml.replaceAll("&lt;","&amp;lt;");
		remarkhtml=remarkhtml.replaceAll("&gt;","&amp;gt;");
		relatedacc = Util.null2String(statement.getString("accessory"));
		principal = Util.null2String(statement.getString("principal"));
		relatedaccList=Util.TokenizerString(relatedacc,",");
		isAnonymous=Util.null2String(statement.getString("isAnonymous"));
		isApproval=Util.null2String(CoTypeComInfo.getIsApprovals(typeid));
		isApply=Util.null2String(statement.getString("isApply"));
	}
}finally{
	statement.close();
}

if (typeid.equals(""))
{
typeid="0";
}

boolean canEdit = false;
canEdit=CoworkShareManager.isCanEdit(""+id,""+userid,"all");
if (!canEdit)
{
response.sendRedirect("/notice/noright.jsp") ;
return;
}

Map appStatusMap=CoworkService.getAppStatus();

%>
<HEAD>
<title><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>:<%=name%></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="js/cowork_wev8.js"></script>
<link rel="stylesheet" href="/cowork/css/cowork_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<link rel=stylesheet type="text/css" href="/cowork/css/coworkNew_wev8.css"/>

<style>
  TABLE.ke-container TR {height:auto !important;}
  table.ke-toolbar-table td{padding:0px;}
</style>
</head>
<jsp:include page="CoworkUtil.jsp"></jsp:include>
<%@ include file="/cowork/uploader.jsp" %>
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("93,17855",user.getLanguage())%>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:450px;">
<form name="frmmain" method="post" action="CoworkOperation.jsp"  enctype="multipart/form-data">
<input type=hidden name="method" value="edit">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="from" value="<%=from%>">
<input type=hidden name="status" id="status" value="<%=status%>"/>
<input type=hidden name="isApproval" id="isApproval" value="0"/>
<%String defaultCoType = "";//初始协作区类型 %>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item attributes="{'customAttrs':'vertical-align=true'}"><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="namespan" required="true">
				<input class=inputstyle type=text name="name" value="<%=name%>" 
					onkeydown="if(window.event.keyCode==13) return false;" onChange="checkinput('name','namespan')" 
					style="width:45%" onblur="checkLength('name',100,'<%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')">
        	</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(33867,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="typeid" size=1 onChange="onShowneedinput();onShowCoTypeAccessory(this.value);getTypeSet(this.value)" style="width:150px;">
			<%
	            
	        	int index = 0;
	        	  
	            while(CoTypeComInfo.next()){
	                index++;
	                String tmptypeid=CoTypeComInfo.getCoTypeid();
	                String typename=CoTypeComInfo.getCoTypename();                
	                String typemanager=CoTypeComInfo.getCoTypemanagerid();                
	                String typemembers=CoTypeComInfo.getCoTypemembers();
									
					int tempsharelevel = CoTypeRight.getRightLevelForCowork(""+userid,tmptypeid);
					if(tempsharelevel==0) continue;
									
	               	if(index==1) defaultCoType = tmptypeid;//初始协作区类型默认为选项中的第一个
	               	if(tmptypeid.equals(""+typeid)) defaultCoType = tmptypeid;//如果设置了默认协作区类型，更新初始协作区类型
	        %>
	          <option value="<%=tmptypeid%>" <%if(tmptypeid.equals(""+typeid)){%> selected <%}%> ><%=typename%></option>
	        <%
	            }
	        %>
	        </select>
	        <span id="subtypespan"></span>
      		<input type=hidden name="creater" value=<%=creater%>>
		
		</wea:item>
		
		<wea:item attributes="{'samePair':'isAnonymous_tr'}"><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'isAnonymous_tr'}">
			<input type="checkbox" tzCheckbox="true" name="isAnonymous" <%=isAnonymous.equals("1")?"checked=checked":""%> id="isAnonymous" value="1">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(33868,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isApply" id="isApply" value="1"
				<%=isApply.equals("1")?"checked=checked":""%>>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
		<wea:item>
				<brow:browser viewType="0" name="txtPrincipal" browserValue='<%=""+principal%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp" width="50%"  _callback="markChange"
								browserSpanValue='<%=ResourceComInfo.getResourcename(""+principal)%>'>
				</brow:browser>
			
		</wea:item>
	</wea:group>
	
	<wea:group context="参与条件">
		<wea:item type="groupHead">
			<input type="button" class="addbtn" onclick="addUser()" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"/>
    		<input type="button" class="delbtn" onclick="delUser()" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"/>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17689,user.getLanguage())%></wea:item>
		<wea:item attributes="{'id':'coworkshare_tr'}"></wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16169,user.getLanguage())%>' attributes="{'itemAreaDisplay':'none'}">	
	
		<wea:item><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=calendar  onclick="gettheDate(begindate,begindatespan)"></BUTTON>
			<SPAN id=begindatespan ><%=begindate%></SPAN>
			<input type="hidden" name="begindate" id="begindate" value=<%=begindate%>>  
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17690,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=Clock onClick="onShowTime(begintimespan,beingtime)"></BUTTON>
			<SPAN id=begintimespan><%=beingtime%></span>
			<input type="hidden" name="beingtime" id="beingtime" <%if(!beingtime.trim().equals("")){%>value="<%=beingtime%>"<%}%>>   
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=calendar  onclick="gettheDate(enddate,enddatespan)"></BUTTON>
			<SPAN id=enddatespan ><%=enddate%></SPAN>
			<input type="hidden" name="enddate" id="enddate" value='<%=enddate%>'> 
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=Clock onClick="onShowTime(endtimespan,endtime)"></BUTTON>
			<SPAN id=endtimespan><%=endtime%></span>
			<input type="hidden" name="endtime" id="endtime" <%if(!endtime.trim().equals("")){%>value="<%=endtime%>"<%}%>>   
		</wea:item>
	
		<%if(appStatusMap.containsKey("doc")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></wea:item>
		<wea:item>
			
			<%
              	 String docNames="";
	   			 for(int i=0;i<relateddocList.size();i++){
	   				docNames+=","+DocComInfo.getDocname(relateddocList.get(i).toString());
				 }
	   			 docNames=docNames.length()>0?docNames.substring(1):"";
            %>
            <brow:browser viewType="0" name="relateddoc" browserValue='<%=relateddoc%>'
			               	browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
			               	linkUrl="/docs/docs/DocDsp.jsp?id=" 
			               	completeUrl="/data.jsp?type=9"
			               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="60%" browserSpanValue='<%=docNames%>'> 
            </brow:browser>
			
		</wea:item>
		<%} %>
		<%if(appStatusMap.containsKey("workflow")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></wea:item>
		<wea:item>
			
			<%
               	 String wfNames="";
	   			 for(int i=0;i<relatedwfList.size();i++){
	   				wfNames+=","+RequestComInfo.getRequestname(relatedwfList.get(i).toString());
				 }
	   			 wfNames=wfNames.length()>0?wfNames.substring(1):"";
             %>
              	<brow:browser viewType="0" name="relatedwf" browserValue='<%=relatedwf%>'
			               	browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp"
			               	linkUrl="/workflow/request/ViewRequest.jsp?requestid=" 
			               	completeUrl="/data.jsp??type=152"
			               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="60%" browserSpanValue='<%=wfNames%>'> 
              	</brow:browser>
		</wea:item>
		<%} %>
		<%if(appStatusMap.containsKey("crm")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
		<wea:item>
			
			<%
              	String cusNames="";
	   			 for(int i=0;i<relatedcusList.size();i++){
	   				cusNames+=","+CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString());
				 }
	   			cusNames=cusNames.length()>0?cusNames.substring(1):"";
             %>
             <brow:browser viewType="0" name="relatedcus" browserValue='<%=relatedcus%>'
			               	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"
			               	linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=" 
			               	completeUrl="/data.jsp??type=7"
			               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="60%" browserSpanValue='<%=cusNames%>'> 
             </brow:browser>
		</wea:item>
		<%}%>
		
		<%if(appStatusMap.containsKey("project")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
		<wea:item>
			
			<%
              	 String prjNames="";
	   			 for(int i=0;i<mutilPrjsList.size();i++){
	   				prjNames+=","+projectInfoComInfo.getProjectInfoname(mutilPrjsList.get(i).toString());
				 }
	   			 prjNames=prjNames.length()>0?prjNames.substring(1):"";
            %>
            <brow:browser viewType="0" name="projectIDs" browserValue='<%=mutil_prjsid%>'
			               	browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp"
			               	linkUrl="/proj/data/ViewProject.jsp?ProjID=" 
			               	completeUrl="/data.jsp?type=8"
			               	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="60%" browserSpanValue='<%=prjNames%>'> 
             </brow:browser>
		</wea:item>
		<%}%>
		
		<%if(appStatusMap.containsKey("task")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></wea:item>
		<wea:item>
			
			<%
               	String prjNames="";
		   		for(int i=0;i<relatedprjList.size();i++){
		   				prjNames+=","+ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString());
				}
		   		prjNames=prjNames.length()>0?prjNames.substring(1):"";
             %>
              <brow:browser viewType="0" name="relatedprj" browserValue='<%=relatedprj%>'
				               	browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp"
				               	linkUrl="/proj/process/ViewTask.jsp?taskrecordid=" 
				               	completeUrl="/data.jsp?type=prjtsk"
				               	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' width="60%" browserSpanValue='<%=prjNames%>'> 
              </brow:browser>
		</wea:item>
		<%}%>
		
		</wea:group>
		
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></wea:item>
			<wea:item>
				<textarea class=InputStyle name="remark" id="remark" style="width:100%" rows=5><%=remarkhtml%></textarea>
			</wea:item>
			<%if(appStatusMap.containsKey("attachment")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="hidden" id="relatedacc" name="relatedacc" value="<%=relatedacc%>">
				<input type="hidden" id="delrelatedacc" name="delrelatedacc" value="">
				<%
	    		if(!relatedacc.equals("")) {
					for(int i=0;i<relatedaccList.size();i++){
						String accid=(String)relatedaccList.get(i);	
						sql="select id,docsubject,accessorycount from docdetail where id="+accid+"";
						rs.executeSql(sql);
						int linknum=-1;
						while(rs.next()){
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
	             			<div>
	            			 <%=imgSrc%>
				             <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx"))){%>
				               <a  style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
				             <%}else{%>
				               <a style="cursor:hand" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp
				             <%}%>
				              <a href="javascript:void(0)" onclick="onDeleteAcc(this,'<%=showid%>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
	             			 </div>
	           			<%}%>
	          		<%}
				}%> 
				
	            <!--上传附件 -->
	  			<%
					CoworkDAO dao = new CoworkDAO();
					Map dirMap=dao.getAccessoryDir(defaultCoType);
					String secId = (String)dirMap.get("secId");
					String maxsize = (String)dirMap.get("maxsize");
					if(!secId.equals("")){
				%>
						<div id="uploadDiv" mainId="" subId="" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
				<%}else{%>
						<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
				<%}%>
			</wea:item>
			<%}%>
		</wea:group>
</wea:layout>
	
</form> 
<br>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<script language=javascript>

var isApproval="<%=isApproval%>";
var isAnonymous="<%=isAnonymous%>";
var isCoworkAnonymous="<%=CoTypeComInfo.getIsAnonymouss(defaultCoType)%>"; //协作是否允许匿名

jQuery(document).ready(function(){

	//加载条件
	$.post("/cowork/CoworkShareManager.jsp?from=edit&id=<%=id%>",null,function(data){
		$("#coworkshare_tr").html(data);
	});

	highEditor("remark");
	
   //绑定附件上传
   if(jQuery("#uploadDiv").length>0)
      bindUploaderDiv(jQuery("#uploadDiv"),"newrelatedacc"); 
   
  //左侧下拉框处理
  if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
  
  if(isApproval=="1")
	   jQuery("#rightMenuIframe").contents().find("#menuItemDivId0 button").html("<%=SystemEnv.getHtmlLabelName(15143,user.getLanguage())%>");
  else
	   jQuery("#rightMenuIframe").contents().find("#menuItemDivId0 button").html("<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>");
  
  if(isCoworkAnonymous=="1"){
  		showEle("isAnonymous_tr");
		jQuery("#isAnonymous_tr").show();
		jQuery("#isAnonymous_line").show();
  }else{
  		hideEle("isAnonymous_tr");
		jQuery("#isAnonymous_tr").hide();
		jQuery("#isAnonymous_line").hide();
   }
  
});

function goBack(){
     window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&id=<%=id%>"
   }
//附件删除
function onDeleteAcc(obj,delid){
	    var delrelatedacc=jQuery("#delrelatedacc").val();
        var relatedacc=jQuery("#relatedacc").val();
	    relatedacc=","+relatedacc;
	    delrelatedacc=","+delrelatedacc;
	    
		delrelatedacc=delrelatedacc+delid+",";
		var index=relatedacc.indexOf(","+delid+",");
		relatedacc=relatedacc.substr(0,index+1)+relatedacc.substr(index+delid.length+2);
		
		jQuery("#relatedacc").val(relatedacc.substr(1,relatedacc.length));
		jQuery("#delrelatedacc").val(delrelatedacc.substr(1,delrelatedacc.length));
		
		$(obj).parent().remove();
} 

function doSave(obj){
	
	if(check_formM(document.frmmain,'name,typeid,txtPrincipal')&&checkDateTime()){
		//obj.disabled = true;
		
		var oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];
	    try{
	       if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
	         doSaveAfterAccUpload();  //保存协作
	       else 
	     	 oUploader.startUpload();
		}catch(e){
		     doSaveAfterAccUpload(); //保存协作
		 }
	}
}

function doSaveAfterAccUpload(){
   
	if(isApproval==1)
		jQuery("#status").val("-1");//需要审批
	
	jQuery("#isApproval").val(isApproval);	
	
	var remarkValue=getRemarkHtml("remark");
	$("textarea[name=remark]").val(remarkValue);
	
   document.frmmain.submit();

}

//检查协作时间
function checkDateTime(){
   var begindateStr=document.getElementById("begindate").value.split("-");
   var enddateStr=document.getElementById("enddate").value.split("-");
   
   var begindate,enddate;
   
   var beingtimeStr=document.getElementById("beingtime").value.split(":");
   var endtimeStr=document.getElementById("endtime").value.split(":");
   if(beingtimeStr.length==2)
       begindate=new Date(begindateStr[0],begindateStr[1]-1,begindateStr[2],beingtimeStr[0],beingtimeStr[1]);
   else
       begindate=new Date(begindateStr[0],begindateStr[1]-1,begindateStr[2]);
   
   if(endtimeStr.length==2)
       enddate=new Date(enddateStr[0],enddateStr[1]-1,enddateStr[2],endtimeStr[0],endtimeStr[1]);
   else
       enddate=new Date(enddateStr[0],enddateStr[1]-1,enddateStr[2]); 
       
   if(begindate>enddate){
       alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
       return false;
   }else
       return true;    
}

function changeView(viewFlag,accepterspan){
	document.all(viewFlag).style.display='none';
	document.all(accepterspan).style.display='';
}
 function onChangeSharetype(delspan,delid,ismand){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
    if(document.all(delspan).style.visibility=='visible'){
      document.all(delspan).style.visibility='hidden';
      document.all(delid).value='0';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)+1;
    }else{
      document.all(delspan).style.visibility='visible';
      document.all(delid).value='1';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)-1;
    }
  }
function opendoc(showid,versionid,docImagefileid)
{
openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&from=accessory&wpflag=workplan");
}
function opendoc1(showid)
{
openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&wpflag=workplan");
}

  function check_formM(thiswins,items)
{
	thiswin = thiswins
	items = ","+items + ",";
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="coworkers"){
		if(tmpvalue == 0){
			alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}


function onShowCoTypeAccessory(CoType){
   jQuery.post("CoworkAccessory.jsp?CoType="+CoType,{},function(data){
       jQuery("#divAccessory").html(data);
       //绑定附件上传
       if(jQuery("#uploadDiv").length>0)
          bindUploaderDiv(jQuery("#uploadDiv"),"newrelatedacc");
   });
}

function onShowneedinput(){
   if(jQuery("#typeid").val()=="")
      jQuery("#subtypespan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
   else
      jQuery("#subtypespan").html("");    
}

function getTypeSet(typeid){
	jQuery.post("CoworkOperation.jsp?method=getTypeSet&typeid="+typeid,{},function(data){
		data=eval("("+data+")");
		isApproval=data.isApproval;
		isAnonymous=data.isAnonymous;
		
		if(isApproval==1)
		   jQuery("#rightMenuIframe").contents().find("#menuItemDivId0 button").html("<%=SystemEnv.getHtmlLabelName(15143,user.getLanguage())%>");
		else
		   jQuery("#rightMenuIframe").contents().find("#menuItemDivId0 button").html("<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>");
		
		jQuery("#isAnonymous").attr("checked",false);
		if(isAnonymous=="1"){
			showEle("isAnonymous_tr");
		}else{
			hideEle("isAnonymous_tr");
		}
	});
}

jQuery(function(){
	checkinput('name','namespan');
	//hideEle("topTeam",true);
});

function markChange(event,datas,name){
	jQuery('#isChangeCoworker').val(1);
}

</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
