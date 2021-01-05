<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<%
String isfromProjTab = Util.null2String(request.getParameter("isfromProjTab"));
String querystr=request.getQueryString();
if(!"1".equals(isfromProjTab)){
	response.sendRedirect("/proj/data/AddProjectTab.jsp"+"?"+querystr);
	return;
}
%>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_cus" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjCodeParaBean" class="weaver.proj.form.ProjCodeParaBean" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjCardGroupComInfo" scope="page" />
<%
String codeuse=CodeUtil.getPrjCodeUse();
//========================== 得到任务列表相关
String chkFields="";

boolean isOnly = Util.null2String(request.getParameter("isOnly")).equalsIgnoreCase("y") ? true : false;
String  templetName = SystemEnv.getHtmlLabelName(17907,user.getLanguage());

int templetId = Util.getIntValue(request.getParameter("templetId"));
int projTypeId = Util.getIntValue(request.getParameter("projTypeId"));   
String parentid = Util.null2String (request.getParameter("parentid"));   

    String  accids = "";
    String  templetDesc = "";
    String  workTypeId = "";
    String  proMember = "";
    String  isMemberSee = "";
    String  proCrm = "";
    String  isCrmSee = "";
    String  parentProId = "";
    String  commentDoc = "";
    String  confirmDoc = "";
    String  adviceDoc = "";
    String  Manager = "";
    String  relationXml="";
    if(templetId>0){
        String  strSql = "select * from Prj_Template where id="+templetId;
        RecordSet.executeSql(strSql);
        if (RecordSet.next()){
            templetName = Util.null2String(RecordSet.getString("templetName"));
            templetDesc = Util.null2String(RecordSet.getString("templetDesc"));

            if (projTypeId==-1){
                projTypeId = Util.getIntValue(RecordSet.getString("proTypeId"));
            }
            workTypeId = Util.null2String(RecordSet.getString("workTypeId"));
            proMember = Util.null2String(RecordSet.getString("proMember"));
            isMemberSee = Util.null2String(RecordSet.getString("isMemberSee"));
            proCrm = Util.null2String(RecordSet.getString("proCrm"));
            isCrmSee = Util.null2String(RecordSet.getString("isCrmSee"));
            parentProId = Util.null2String(RecordSet.getString("parentProId"));
            commentDoc = Util.null2String(RecordSet.getString("commentDoc"));
            confirmDoc = Util.null2String(RecordSet.getString("confirmDoc"));
            adviceDoc = Util.null2String(RecordSet.getString("adviceDoc"));
            Manager = Util.null2String(RecordSet.getString("Manager"));
            accids = Util.null2String(RecordSet.getString("accessory"));
//            relationXml = Util.null2String(RecordSet.getString("relationXml"));
        }
    }

//==========================
//==========================
String projTypeName = ProjectTypeComInfo.getProjectTypename(String.valueOf(projTypeId));
String projTypeCode = ProjectTypeComInfo.getProjectTypecode(String.valueOf(projTypeId));
String workTypeName = WorkTypeComInfo.getWorkTypename(workTypeId);
String proMemberName = ProjTempletUtil.getMemberNames(proMember);
String proCrmName = ProjTempletUtil.getCrmNames(proCrm);
String parentProName = ProjectInfoComInfo.getProjectInfoname(parentProId);
String commentDocName = DocComInfo.getDocname(commentDoc);
String confirmDocName = DocComInfo.getDocname(confirmDoc);
String adviceDocName = DocComInfo.getDocname(adviceDoc);

//判断当前分部是否有配工作时间(总部)
String schedulesql = " select * from HrmSchedule where scheduleType='3' ";
boolean hasschedule = false;
RecordSetFF.executeSql(schedulesql);
if(RecordSetFF.next()){
	hasschedule = true;
}

%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>

<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>

<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>

<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTask_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/projTask/temp/prjTask_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/jquery.z4x_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/ProjectAddTaskI2_wev8.js"></script>

<script type="text/javascript" src="/js/projTask/TaskUtil_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script src="/js/projTask/jquery.dragsort_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskDrag_wev8.js"></script>
 

<script type="text/javascript">
var oUpload;
function impProjBase(){
	with(document.frmain){
     
		$("PrjTypeSpan").html("<%=projTypeName%>");
		$("input[name=PrjType]").val('<%=projTypeId%>');
   
        if ("<%=workTypeId%>">"0"){        
        	$("#WorkTypeSpan").html('<%=workTypeName%>');
    		$("input[name=WorkType]").val('<%=workTypeId%>');
        }
        if ("<%=proMember%>"!=""){
    		//hrmids02Span.innerHTML = '<%=proMemberName%>';
    		hrmids02.value = '<%=proMember%>';		
        }
        
         if ("<%=proCrm%>"!=""){
            PrjDescspan.innerHTML = '<a href=""><%=proCrmName%></a>';
            PrjDesc.value = '<%=proCrm%>';
        }       
		//ParentIDSpan.innerHTML = '<a href="/proj/data/ViewProject.jsp?ProjID=<%=parentProId%>"><%=parentProName%></a>';
		//ParentID.value = '<%=parentProId%>';
		//EnvDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=commentDoc%>"><%=commentDocName%></a>';
		//EnvDoc.value = '<%=commentDoc%>';
		//ConDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=confirmDoc%>"><%=confirmDocName%></a>';
		//ConDoc.value = '<%=confirmDoc%>';
		//ProDocSpan.innerHTML = '<a href="/docs/docs/DocDsp.jsp?id=<%=adviceDoc%>"><%=adviceDocName%></a>';
		//ProDoc.value = '<%=adviceDoc%>';
		<%if(isMemberSee.equals("1")){%>
		MemberOnly.checked = true;
		<%}else{%>
		MemberOnly.checked = false;
		<%}%>
		<%if(isCrmSee.equals("1")){%>
		ManagerView.checked = true;
		<%}else{%>
		ManagerView.checked = false;
		<%}%>
	}
}
</script>
<style>

	.spanSwitch{cursor:pointer;font-weight:bold}
	#tblTask table td{padding:0;}
</style>

<style type="text/css">
.e8_os{width:30%!important;}
select.InputStyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>
</HEAD>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY  style="overflow: hidden;" id="myBody" onbeforeunload="protectProj(event)" >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 400px !important">
			
			<input id="taskIframeAddRowBtn" type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top middle" style="display:none;" onclick="frames['taskDataIframe'].addRow();"/>
			<input id="taskIframeDelRowBtn" type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" style="display:none;" onclick="frames['taskDataIframe'].delRows();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="submitData(this)"/>
			<span
				title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
				class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv">
	<span style="width:10px"></span>
	<span id="hoverBtnSpan" class="hoverBtnSpan">
	</span>
</div>

<div class="zDialog_div_content" style="overflow:auto;">

<FORM id=frmain name=frmain action="/proj/data/ProjectOperation.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="frompage" value="<%=Util.null2String( request.getParameter("from")) %>">
<input type="hidden" name="method" value="add">
<input type="hidden" name="accdocids" id="accdocids" value="<%=accids %>">
<INPUT class=inputstyle maxLength=3 size=3 name="SecuLevel" value=10 type=hidden />

<!-- 项目信息 -->
<div id="nomalDiv">

<%
//项目类型自定义字段
if(templetId>0){
	String  sql_cus = "select * from prj_fielddata where id='"+templetId+"' and scope='ProjCustomField' and scopeid='"+projTypeId+"' ";
	RecordSet_cus.executeSql(sql_cus);
	RecordSet_cus.next();
}

//int fieldcount=0;//用来定位字段
//int fieldsize=0;//用来定位字段数量
int groupcount=0;//用来定位组
String needHideField="status,prjtype,department,";//用来隐藏字段
//必填字段控制
String[]mandStr= Util.TokenizerString2(CptFieldComInfo.getMandFieldStr(""+projTypeId),",") ;
String checkStr="";
if(mandStr!=null&&mandStr.length>0){
	for(int i=0;i<mandStr.length;i++){
		if(mandStr[i].equals("procode")){
			continue;
		}
		if((","+needHideField).indexOf(","+mandStr[i]+",")>=0){
			continue;
		}
		if(mandStr[i].equals("members")){
			mandStr[i]="hrmids02";
		}
		checkStr+=mandStr[i]+",";
	}
}
%>

<wea:layout attributes="{'expandAllGroup':'true'}">

<%


TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(""+projTypeId);
CptCardGroupComInfo.setTofirstRow();
while(CptCardGroupComInfo.next()){
	String groupid=CptCardGroupComInfo.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
	groupcount++;
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
if(!openfieldMap.isEmpty()){
	//fieldsize=openfieldMap.size();
	//fieldcount=0;
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		//fieldcount++;
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		//JSONObject v= (JSONObject)entry.getValue().clone() ;
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldlabel=v.getInt("fieldlabel");
		String fieldid=v.getString("id");
		String fieldName=v.getString("fieldname");
		int fieldhtmltype=v.getInt("fieldhtmltype");
		String fielddbtype = v.getString("fielddbtype");
		int type=v.getInt("type");
		int ismand=v.getInt("ismand");
		int issystem=v.getInt("issystem");
				
		String templeteFieldName=fieldName;
		
		if("procode".equals(fieldName)&&!"2".equals(codeuse)){//非手动编码
			continue;
		}else if("prjtype".equals(fieldName)){//字段名称和项目卡片里的不一致,手动调整
			templeteFieldName="protypeid";
		}else if("worktype".equals(fieldName)){
			templeteFieldName="worktypeid";
		}else if("description".equals(fieldName)){
			templeteFieldName="procrm";
		}else if("managerview".equals(fieldName)){
			templeteFieldName="iscrmsee";
		}else if("parentid".equals(fieldName)){
			templeteFieldName="parentproid";
		}else if("members".equals(fieldName)||"hrmids02".equals(fieldName)){
			templeteFieldName="promember";
		}else if("isblock".equals(fieldName)){
			templeteFieldName="ismembersee";
		}else if("envaluedoc".equals(fieldName)){
			templeteFieldName="commentdoc";
		}else if("proposedoc".equals(fieldName)){
			templeteFieldName="advicedoc";
		}else if("protemplateid".equals(fieldName)){//模板字段只需显示
			//if(templetId<=0){
			//	continue;
			//}
			templeteFieldName="templetname";
		}else if("department".equals(fieldName)){//部门字段不需要
			continue;
		}else if("status".equals(fieldName)){//状态字段不需要
			continue;
		}
		
		String fieldkind=v.getString("fieldkind");
		
		
		
		String fieldValue="";
		
		if("2".equals(fieldkind)){
			fieldName="customfield"+fieldid.replace("prjtype_", "");
			v.put("id", fieldid.replace("prjtype_", ""));
		}
		if(templetId>0){
			if("2".equals(fieldkind)){
				fieldValue=Util.null2String(RecordSet_cus.getString(templeteFieldName));
			}else{
				fieldValue=Util.null2String(RecordSet.getString(templeteFieldName));
			}
		}
		
		
		if("manager".equalsIgnoreCase(fieldName)&&Util.getIntValue( fieldValue)<=0){
			fieldValue=user.getUID()+"";
		}
		
		if("members".equals( fieldName)){//项目成员原有特殊逻辑,不能改原来展现的元素名
			fieldName="hrmids02";
			v.put("fieldname", fieldName);
		}
		String hideField="{}";
		if(needHideField.indexOf(","+fieldName+",")!=-1){
			hideField="{'samePair':'hideField'}";
		}
		
		
		
		
	%>
	<wea:item attributes='<%=hideField %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=hideField %>'>
		<%
		if("name".equalsIgnoreCase(fieldName)){%>
			<INPUT class=inputstyle maxLength=500 size=500 id="name" name="name" onblur="checkLength()" onchange='checkinput("name","PrjNameimage")'>
			<SPAN id=PrjNameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
			<span id="remind" style="cursor:hand" title='<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>500(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)'>
			<img src="/images/remind_wev8.png" align="absmiddle"  /></span>
		<%}else if("parentid".equalsIgnoreCase(fieldName)&&Util.getIntValue( parentid)>0){
			String tmpname=Util.null2String(ProjectInfoComInfo.getProjectInfoname(parentid));
			%>
			<%=tmpname %>
			<input type="hidden" name=parentid value="<%=parentid %>" />
			<%
		}else if("protemplateid".equals(fieldName)){
			if(templetId>0){
				String tmpname=Util.null2String(RecordSet.getString(templeteFieldName));
				%>
				<%=tmpname %>
				<input type="hidden" name=protemplateid value="<%=templetId %>" />
				<%
			}
			
		}else if("prjtype".equals(fieldName)){
			%>
			<%=ProjectTypeComInfo.getProjectTypename(""+projTypeId) %>
			<input type="hidden" name=prjtype value="<%=projTypeId %>" />
			<%
		}else if("passnoworktime".equals(fieldName)){
			%>
			<input type="checkbox" name=passnoworktime1 id="passnoworktime1" onclick="getPassnoworktime()"/>
			<input type="hidden" name=passnoworktime id="passnoworktime" value="0" />
			<%
		}else if("manager".equals(fieldName)){
			%>
			<brow:browser viewType="0" name="manager" browserValue='<%=""+user.getUID()%>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(""+user.getUID()),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' 
			    _callback="getPassnoworktime"
				completeUrl="/data.jsp"  />
			<% 
		}else{
			if(fieldhtmltype==3&&(type==161||type==162||type==256||type==257)){
				String showname = "";
				String urls= "";
				if(type==161||type==162){
					showname=PrjFieldManager.getBrowserFieldvalue(user,fieldValue, type, fielddbtype,false);
					urls=BrowserComInfo.getBrowserurl(""+type)+"?type="+fielddbtype;     // 浏览按钮弹出页面的
				}else{
					CustomTreeUtil customTreeUtil = new CustomTreeUtil();
			   	  	showname = customTreeUtil.getTreeFieldShowName(fieldValue,fielddbtype);
			   	  	urls=BrowserComInfo.getBrowserurl(""+type)+"?type="+fielddbtype+"_"+type;     // 浏览按钮弹出页面的url
				}
				String andChar="?";
				String isMustInput = "1" ; 
				if(ismand==1){
					isMustInput = "2";
				}
				String isSingleStr = "true";//单选
			    if(type==162||type==157){
			    	isSingleStr = "false";
			    }
				String showfieldname=1==issystem?fieldid:"field"+fieldid;
				if("2".equals(fieldkind)){//项目类型自定义字段的元素名
					showfieldname="customfield"+fieldid.replace("prjtype_", "");
				}
				String browserOnClick = "onShowBrowserCustom('"+showfieldname+"','"+urls+"','"+type+"','"+isMustInput+"')";
			%>
				<brow:browser viewType="0" name='<%=showfieldname%>' browserValue='<%=fieldValue%>' 
							 completeUrl='' width="500px" 
							browserOnClick="<%=browserOnClick%>" hasInput="true" isSingle="<%=isSingleStr%>" hasBrowser = "true" isMustInput="<%=isMustInput%>"
							idSplitFlag="," nameSplitFlag=","
							browserSpanValue='<%=showname%>'>
						</brow:browser>
						<input type=hidden name="<%=showfieldname%>_name" value="<%=showname%>">
			<%}else{%>
				<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
			<%}%>
			<%
		}
		%>
		
	</wea:item>
	<%
	}
}
%>
<%
	if(groupcount==1 && PrjSettingsComInfo.getPrj_acc() ){//附件位置
		String accsec=PrjSettingsComInfo.getPrj_accsec();
		String accsize=PrjSettingsComInfo.getPrj_accsize();
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
	<wea:item>
			
			<script type="text/javascript">
				var oUpload;
				
				window.onload = function() {
				  var settings = {
						flash_url : "/js/swfupload/swfupload.swf",
						upload_url: "/proj/data/uploadPrjAcc.jsp",	// Relative to the SWF file
						post_params: {"method" : "uploadPrjAcc","secid":"<%=accsec %>"},
						file_size_limit : "<%=accsize %> MB",
						file_types : "*.*",
						file_types_description : "All Files",
						file_upload_limit : 100,
						file_queue_limit : 0,
						custom_settings : {
							progressTarget : "fsUploadProgress",
							cancelButtonId : "btnCancel"
						},
						debug: false,
						 

						// Button settings
						
						button_image_url : "/js/swfupload/add_wev8.png",	// Relative to the SWF file
						button_placeholder_id : "spanButtonPlaceHolder",
		
						button_width: 100,
						button_height: 18,
						button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
						button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
						button_text_top_padding: 0,
						button_text_left_padding: 18,
							
						button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
						button_cursor: SWFUpload.CURSOR.HAND,
						
						// The event handler functions are defined in handlers.js
						file_queued_handler : fileQueued,
						file_queue_error_handler : fileQueueError,
						file_dialog_complete_handler : fileDialogComplete_1,
						upload_start_handler : uploadStart,
						upload_progress_handler : uploadProgress,
						upload_error_handler : uploadError,
						upload_success_handler : uploadSuccess,
						upload_complete_handler : uploadComplete,
						queue_complete_handler : queueComplete	// Queue plugin event
					};

					
					
					try{
						oUpload = new SWFUpload(settings);
					} catch(e){alert(e)}
				}
		
				function fileDialogComplete_1(){
					document.getElementById("btnCancel1").disabled = false;
					fileDialogComplete
				}
				function uploadSuccess(fileObj,serverdata){
					var data=eval(serverdata);
					//alert(data);
					if(data){
						var a=data;
						if(a>0){
							jQuery("#accdocids").val(jQuery("#accdocids").val()+","+a);
						}
					}
				}
		
				function uploadComplete(fileObj) {
					try {
						/*  I want the next upload to continue automatically so I'll call startUpload here */
						if (this.getStats().files_queued === 0) {
							frmain.submit();
							document.getElementById(this.customSettings.cancelButtonId).disabled = true;
						} else {	
							this.startUpload();
						}
					} catch (ex) { this.debug(ex); }
		
				}
			</script>
			<div>
				<span> 
					<span id="spanButtonPlaceHolder"></span><!--选取多个文件-->
				</span>
				&nbsp;&nbsp;
				<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload.cancelQueue();" id="btnCancel1">
					<span><img src="/js/swfupload/delete_wev8.gif"  border="0"></span>
					<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
				</span>
			</div>
			<div class="fieldset flash" id="fsUploadProgress"></div>
			<div id="divStatus"></div>
			
            <input class=inputstyle style="display:none;" type=file name="accessory1" onchange='accesoryChanage(this)' style="width:100%">
		    <span id="shfj_span"></span>
		    (<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=accsize %>M)
		    <button type="button" class=AddDoc style="display:none;" name="addacc" onclick="addannexRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
		    <input type=hidden name=accessory_num value="1">
			
		</wea:item>
	<%
	}
	%>
</wea:group>
	<%
}
%>	
 	
 	
</wea:layout>





</div>
<!-- 任务列表 -->
<div id="agendaDiv" style="display:none;margin-left:0px!important;margin-top:0px!important;">
  
  <iframe id="taskDataIframe" name="taskDataIframe" src="/proj/data/AddProjectData.jsp?templetId=<%=""+templetId %>" class="flowFrame" frameborder="0" scrolling="auto" height="500px" width="100%"></iframe>
  
  <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
   <div id="divTaskList" style="display:none;"></div>
  
  
  
  
  
  
</div>
<div id="temp_seleBeforeTask_DIV" style="display:none"><select name='temp_seleBeforeTask' class='inputStyle'><option value='0'></option></select></div>
<div style="height:100px!important;"></div>
</FORM>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">

				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language=javascript>

function checkDateValidity(begindate,begintime,enddate,endtime,errormsg){
	var isValid = true;
	if(compareDate(begindate,begintime,enddate,endtime) == 1){
		Dialog.alert(errormsg);
		isValid = false;
	}
	return isValid;
}


/*Check Date */
function compareDate(date1,time1,date2,time2){

	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0] + " " +time1;
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0] + " " +time2;

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}



function ItemCount_KeyPress_Plus()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57))
	{
		window.event.keyCode = 0;
	}
}
</script>




<script language='javaScript'>
/**************
 * 改进列表任务加载性能  for td:9891 by cyril on 2009-01-12
 */
//初始化所有前置任务
var temp_seleBeforeTask = document.getElementById("temp_seleBeforeTask");
<%
String beforTaskStr = ProjTempletUtil.getBeforeTaskStr();                               
String outStr = "var seleBefTaskObj=temp_seleBeforeTask;"+beforTaskStr+"";
out.println(outStr);
%>
var seleBeforeTask_TD = document.getElementsByName('seleBeforeTask_TD');
var temp_seleBeforeTask_DIV = document.getElementById('temp_seleBeforeTask_DIV').innerHTML;
for(i=0; i<seleBeforeTask_TD.length; i++) {
	temp_seleBeforeTask.name = 'seleBeforeTask';
	temp_seleBeforeTask.id = 'seleBeforeTask_'+(i+1);
	seleBeforeTask_TD[i].innerHTML = replaceStr(i);
}

//拼成SELECT
function replaceStr(id) {
	id++;
	var str = temp_seleBeforeTask_DIV;
	var len = str.length;
	var spchar = 'temp_seleBeforeTask';
	var sp = str.indexOf(spchar);
	str = str.substring(0, sp)+str.substring(sp+5, len);
	str = str.substring(0, 7)+' id=seleBeforeTask_'+id+' onchange=onBeforeTaskChange(this,'+id+') '+str.substring(7, len);
	return str;
}

//处理前置任务
var befTaskObj = document.getElementsByName('seleBeforeTask');
<%
ArrayList befTaskSeleList =  ProjTempletUtil.getBefTaskSeleList();
for (int k=0;k<befTaskSeleList.size();k++){
    String[] paras = (String[])befTaskSeleList.get(k);
    String rowIndex = paras[0];
    String befTaskValue = paras[1];
    String outStr2 = "befTaskObj["+k+"].value='"+befTaskValue+"'";
    out.println(outStr2);
}
%>
//初始化任务负责人多选框
var objManagers = document.getElementsByName("txtManager");
for (i=0;i<objManagers.length;i++){
	var objManager=objManagers[i];
<%
    String[]  members = Util.TokenizerString2(proMember,",");
    for (int h=0;h<members.length;h++) {
        String member = members[h];
         String outStr3 = "objManager.options.add(new Option('"+ResourceComInfo.getLastname(member)+"','"+member+"'))";
         out.println(outStr3);
    }
%>
}
//处理负责人数据
var taskObj = document.getElementsByName("txtManager");
<%	
    ArrayList taskManagerList =  ProjTempletUtil.getTaskManagerList();
  
    for (int j=0;j<taskManagerList.size();j++){
        String[] paras = (String[])taskManagerList.get(j);
        String rowIndex = paras[0];
        String taskManagerValue = paras[1];
        String outStr4 = "taskObj["+j+"].value='"+taskManagerValue+"'";
         out.println(outStr4);
    }
%>
</script>


<script language="javaScript">
//此处为合并时需要注意的地方
var ptu = null;
var iRowIndex = null;
var RowindexNum = null;

function init_ptu() {
    //初始化input框 的宽度
    iRowIndex = document.getElementById("task_iRowIndex").value;
    RowindexNum = document.getElementById("task_RowindexNum").value;
} 
   
function checkLength(){
	tmpvalue = $("input[name=PrjName]").val();
	if(realLength(tmpvalue)>50){
		while(true){
			tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
			if(realLength(tmpvalue)<=50){
				$("input[name=PrjName]").val(tmpvalue);
				return;
			}
		}
	}
}


function submitData(obj){
	var value = $("#name").val();
	var returnValue = "";
	 var msg="<%=SystemEnv.getHtmlLabelNames("1353,18082",user.getLanguage())%>";
	 var URL = "/proj/data/CheckPrjName.jsp?prjName="+value+"&type=add&prjtypeid=<%=projTypeId%>&time="+new Date();
	 URL = encodeURI(URL);
	    var flag=false;
	    jQuery.ajax({
       url: URL,
       type: "post",
       async: false,
       success: function(data){
	    	returnValue = jQuery.trim(data);
          if('1'==returnValue) {
        	  window.top.Dialog.alert(msg);
			        flag=false;
			        $("#name").val("");
			        checkinput("name","PrjNameimage");
	    		}
	    		else{
	    		    flag=true;
	    		}
       }
   });
    if(flag){
		    
    var chkFields = '<%=checkStr %>';
    if("<%=codeuse %>"=="2"){
    	chkFields+=",procode";
	}
    if(!check_form(frmain,chkFields)) return false;
   	$("#taskDataIframe")[0].contentWindow.reloadTaskTree();
   	var taskinfo= $("#taskDataIframe").contents().find("#divTaskList").html();
   	$("#divTaskList").html(taskinfo);
   	
   	
    obj.disabled = true;
 	/**var xmlDoc=document.createElement("rootTask");
 	var docDom=generaDomJson();
 	$.toXml(docDom,xmlDoc);
    document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";
    **/
    myBody.onbeforeunload=null;
    if(!oUpload){
     	frmain.submit();
     }else{
     	try {
     		if(oUpload.getStats().files_queued === 0){
             	frmain.submit();
             }else {
             	oUpload.startUpload();
             }
		} catch (e) {
			frmain.submit();
		}
     }
    }
}



//初始化前置任务值
function init_beforTaskStr() {
	var taskArr = new Array();
	var txtTaskNames = document.getElementsByName("txtTaskName");
	for (i=1;i<=txtTaskNames.length;i++){
		taskArr[i-1] = txtTaskNames[i-1].value;
	}
	var seleBeforeTasks = document.getElementsByName("seleBeforeTask");
	for (i=1;i<=seleBeforeTasks.length;i++){
		try {
			if(seleBeforeTasks[i-1].value!=""&&seleBeforeTasks[i-1].value!="0") {

				document.getElementById('seleBeforeTaskSpan_'+i).innerHTML = taskArr[$('input[name=templetTaskId_'+seleBeforeTasks[i-1].value+"]").val()];
	   			seleBeforeTasks[i-1].value = $('input[name=templetTaskId_'+seleBeforeTasks[i-1].value+"]").val()*1+1;
	   			
			}
		}catch(e){
		}
	}
}
function getPassnoworktime(){
	var temp = "0";
	var tobj = document.getElementById("passnoworktime1");
	if(tobj.checked==true){
		if("<%=hasschedule%>"=="true"){
			temp = "1";
		}else{
			var manager = $("#manager").val();
			if(""==manager){
				temp = "0";
				//jNiceChecked
				$("#passnoworktime1").next().attr("class","jNiceCheckbox");
				$("#passnoworktime1").attr("checked",'false');
				window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("125389,16573",user.getLanguage())%>');
			}else{
				var msg="<%=SystemEnv.getHtmlLabelName(84409,user.getLanguage())%>";
				var URL = "/proj/data/CheckSchedule.jsp?manager="+manager+"&time="+new Date();
			    var flag=false;
			    jQuery.ajax({
		        url: URL,
		        type: "post",
		        async: false,
		        success: function(data){
			    	returnValue = jQuery.trim(data);
		            if('1'==returnValue) {
		            	temp = "1";
			    	}else{
		    			temp = "0";
						//jNiceChecked
						$("#passnoworktime1").next().attr("class","jNiceCheckbox");
						$("#passnoworktime1").attr("checked",'false');
		    			window.top.Dialog.alert(msg);
			    	}
		        	}
			    });
			}
		}
	}
	
	$("#passnoworktime").val(temp);
	//alert($("#passnoworktime").val());
	
}
$(function(){
	//impProjBase();
});
</script>





</body>
</html>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(){
    var ajax=ajaxinit();
    ajax.open("POST", "AddProjectData.jsp?templetId=<%=templetId%>", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send(null);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.getElementById('TaskDataDIV').innerHTML = ajax.responseText;
                initPrjTaskObj();
                init_beforTaskStr();
                init_ptu();
                taskDragSort();
            }catch(e){
                return false;
            }
        }
    }
}


//showdata();

</script>

<script type="text/javascript">

//选择负责人
function onSelectManager(spanname,inputename){
	tmpids = $("input[name=hrmids02]").val();
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectManagerBrowser.jsp?Members="+tmpids);
	if (datas){
		if(datas.id!=""){
			$(spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$(inputename).val(datas.id);
		}else {
			$(spanname).html( "");
			$(inputename).val("");
		}
	}
}

//判断SecuLevel 和LabourP input框中是否输入的是数字
//added by hubo, 2005/08/31
//edit by zfh,20111212
function onShowPrjTemplet(){
	var currentProjType = document.getElementById("PrjType");
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Templet/TempletBrowser.jsp?projTypeID="+$(currentProjType).val(),"dialogArguments=342342");
	if (datas){
		if(datas.id!=""){
			templetID = datas.id;
			templetName = datas.name;
			location.href = "/proj/data/AddProject.jsp?projTypeId="+$(currentProjType).val()+"&templetId="+templetID;
		}
	}
}
function ItemCount_KeyPress_SandL()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
  {
     window.event.keyCode=0;
  }
}

function checknumber_SandL(objectname)
{	
	valuechar = document.all(objectname).value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	if(isnumber) document.all(objectname).value = "" ;
}
</script>

<script language="javascript">



function onShowProjectID(objval){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (datas){
		if(datas.id){
			$("#projectidspan").html("<A href='/proj/data/ViewProject.jsp?ProjID="+datas.id+"' target=_blank>"+datas.name+"</A>");
			frmain.projectid.value=datas.id;
		}else{ 
			if(objval=="2"){
				$("#projectidspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
				$("#projectidspan").html("");
			}
			frmain.projectid.value="0";
		}
	}
}

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowBrowserCustom(id, url, type1,isMustInput) {
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle(id).value;
		url = url + "&selectedids=" + tmpids;
		url+="&iscustom=1";
	}else{
		tmpids = $GetEle(id).value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		url+="&iscustom=1";
	}
	var dialogurl = url;
	var prjdialog = new window.top.Dialog();
	prjdialog.currentWindow = window;
	prjdialog.URL = dialogurl;
	prjdialog.callbackfun = function (paramobj, id1) {
	
		if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				$G(id + "span").innerHTML = wrapshowhtml("<a title='" + names + "'>" + names + "</a>&nbsp",ids,1);
				$G(id).value = ids;
				$G(id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split(",");
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}

					sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
				}

				$G(id + "span").innerHTML = sHtml;
				$G(id).value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G(id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			if (type1 == 256||type1 == 257) {
				$G(id + "span").innerHTML =  names ;
				$G(id).value = ids;
				$G(id + "_name").value = names;
			}
			if (isMustInput == 2) {
				jQuery("#"+id+"spanimg").html("");
			}
		} else {
			$G(id + "span").innerHTML = "";
			$G(id).value = "";
			$G(id + "_name").value = "";
			if(isMustInput == 2){
				jQuery("#"+id+"spanimg").html("<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
			}
		}
	}
		
	hoverShowNameSpan(".e8_showNameClass");
	   
	};
	
	prjdialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	prjdialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		prjdialog.Width=648; 
	}
	prjdialog.Height = 600;
	prjdialog.Drag = true;
	prjdialog.show();

}

function wrapshowhtml(ahtml, id,ismast) {
	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	var mastinput = 1;//2：必须输入 ；1：可编辑
	if(ismast){
		mastinput = ismast;
	}
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this,"+mastinput+",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function openHrefWithChinese(url){
    url = dealChineseOfFieldParams(url);
    window.open(url);
}

//encodeURIComponent
function dealChineseOfFieldParams(url){
	if(url.indexOf("/workflow/request/AddRequest.jsp")==-1 && url.indexOf("/formmode/view/AddFormMode.jsp") != 0) {
		return url;
	}
	var params = "";
	var path = url.substring(0,url.indexOf("?")+1);
	var filedparams = url.substring(url.indexOf("?")+1);
	var fieldparam = filedparams.split("&");
	 for(var i=0;i<fieldparam.length;i++) {
		var tmpindex = fieldparam[i].indexOf("=");
		if(tmpindex != -1) {
			var key = fieldparam[i].substring(0, tmpindex);
			var value = encodeURIComponent(fieldparam[i].substring(tmpindex+1));
			params+="&"+key+"="+value
		}
	} 
	return path+params.substring(1);
}

function btn_cancle(){
		window.parent.closeDialog();
	}
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<script type="text/javascript">
function onShowTime(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	/*var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}*/
	
	var th = $ele4p(spanname);
	var ttop  = $ele4p(spanname).offsetTop; 
	var thei  = $ele4p(spanname).clientHeight;
	var tleft = $ele4p(spanname).offsetLeft; 
	var ttyp  = $ele4p(spanname).type;    
	while (spanname = $ele4p(spanname).offsetParent){
		ttop += $ele4p(spanname).offsetTop; 
		tleft += $ele4p(spanname).offsetLeft;
	}
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei - 50)+"px";
	dads.top = (jQuery(th).offset().top+8)+"px";
	//dads.left = (tleft - 5)+"px";
	dads.left = jQuery(th).offset().left+"px";
	
	
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei + 22)+"px";
	//dads.left = tleft+"px";
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}
</script>
<script language=javascript src="/proj/js/common_wev8.js"></script>