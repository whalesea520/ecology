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
<%@page import="java.net.URLEncoder" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<%

String isfromProjTab = Util.null2String(request.getParameter("isfromProjTab"));
String querystr=request.getQueryString();
//System.out.println("querystr:"+querystr);

if(!"1".equals(isfromProjTab)){
	response.sendRedirect("/proj/Templet/ProjTempletEditTab.jsp"+"?"+querystr);
	return;
}
%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjCardGroupComInfo" scope="page" />
<%  
    //判断是否具有项目编码的维护权限
    boolean canMaint = false ;
    if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
        canMaint = true ;
    }
   
    

    String imagefilename = "/images/sales_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";//取得相应设置的值

    
    /*为了兼容项目自定义字段*/
    /**
    boolean hasFF = true;
    RecordSetFF.executeProc("Base_FreeField_Select","p1");
    if(RecordSetFF.getCounts()<=0)
        hasFF = false;
    else
        RecordSetFF.first(); **/

    int projTypeId = Util.getIntValue(request.getParameter("txtPrjType"));   
    int scopid = projTypeId ;
    String  prjid ="";
    String  crmid="";
    String  hrmid="";
    String docid="";
    String needinputitems = "";
   /*END*/

int templetId = Util.getIntValue(request.getParameter("templetId"));
if (templetId==-1) {
  //out.println("页面出现错误,请与管理员联系!");
  return ;
}
  
%>
<%
String chkFields="";
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
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

<SCRIPT language="javascript"  type='text/javascript' src="/js/weaver_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTask_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/projTask/temp/prjTask_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/jquery.z4x_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/ProjectAddTaskI2_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskDrag_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskUtil_wev8.js"></script>
<script src="/js/projTask/jquery.dragsort_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<%--
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
 --%>
 
<script type="text/javascript">
var oUpload;
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
<style type="text/css">
.spanSwitch{cursor:pointer;font-weight:bold}
#tblTask table td{padding:0;}
.e8_os{width:30%!important;}
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>
</HEAD>
<%
    String templetName = "";
    String templetDesc = "";
    String workTypeId = "";
    String proMember = "";
    String isMemberSee = "";
    String proCrm = "";
    String isCrmSee = "";
    String parentProId = "";
    String commentDoc = "";
    String confirmDoc = "";
    String adviceDoc = "";
    String Manager = "";
    String relationXml = "";
    String project_accessory = "";//相关附件
    String currenttab=Util.null2String(request.getParameter("currentTab"));
    String strSql = "select * from Prj_Template where id=" + templetId;
    RecordSet.executeSql(strSql);
    if (RecordSet.next()) {
        templetName = Util.null2String(RecordSet.getString("templetName"));
        templetDesc = Util.null2String(RecordSet.getString("templetDesc"));

        if (projTypeId == -1) {
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
        relationXml = Util.null2String(RecordSet.getString("relationXml"));
        project_accessory = Util.null2String(RecordSet.getString("accessory"));
    }
    String proMembername = "";
    ArrayList Members_proj = Util.TokenizerString(proMember, ",");
    String[] proMembers = proMember.split(",");
    for (int i = 0; i < Members_proj.size(); i++) {
        proMembername += "<a href=/hrm/resource/HrmResource.jsp?id="+proMembers[i]+">"+ResourceComInfo.getResourcename( ""+ Members_proj.get(i))+"</a>&nbsp;";
    }
%>
<BODY  style="overflow: hidden;" id="myBody" >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
	
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(320,user.getLanguage())+",javascript:location='ProjTempletList.jsp',_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;

	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
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
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSave(this)"/>
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

<Form name="frmain"  method="post"  action="ProjTempletOperate.jsp">
        <input type="hidden" name="method" value="edit">
        <input type="hidden" name="templetId" value="<%=templetId%>">
		<input type="hidden" name="accdocids" id="accdocids" value="">
		<input type="hidden" name="isdialog" id="isdialog" value="<%=isDialog %>">
		<input type="hidden" name="currenttab" id="currenttab" value="<%=currenttab %>">
<!-- 项目信息 -->
<div id="nomalDiv">
<%
//项目类型自定义字段
String  sql_cus = "select * from prj_fielddata where id='"+templetId+"' and scope='ProjCustomField' and scopeid='"+projTypeId+"' ";
RecordSet_cus.executeSql(sql_cus);
RecordSet_cus.next();

int fieldcount=0;//用来定位字段
int fieldsize=0;//用来定位字段数量
int groupcount=0;//用来定位组
String needHideField=",passnoworktime,";//用来隐藏字段
%>
<wea:layout attributes="{'expandAllGroup':'true'}">
<%

TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(projTypeId+"");
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
	fieldsize=openfieldMap.size();
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		fieldcount++;
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		//JSONObject v= (JSONObject)entry.getValue().clone() ;
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldlabel=v.getInt("fieldlabel");
		String fieldid=v.getString("id");
		int fieldhtmltype=v.getInt("fieldhtmltype");
		String fielddbtype = v.getString("fielddbtype");
		int type=v.getInt("type");
		int ismand=v.getInt("ismand");
		int issystem=v.getInt("issystem");
		String fieldName=v.getString("fieldname");
		if(!"name".equalsIgnoreCase(fieldName)){
			v.put("ismand", "0");
		}
		if("name".equals(fieldName)){//字段名称和项目卡片里的不一致,手动调整
			fieldName="templetname";
		}else if("prjtype".equals(fieldName)){
			fieldName="protypeid";
		}else if("worktype".equals(fieldName)){
			fieldName="worktypeid";
		}else if("description".equals(fieldName)){
			fieldName="procrm";
		}else if("managerview".equals(fieldName)){
			fieldName="iscrmsee";
		}else if("parentid".equals(fieldName)){
			fieldName="parentproid";
		}else if("members".equals(fieldName)||"hrmids02".equals(fieldName)){
			fieldName="promember";
			v.put("fieldname", "hrmids02");
		}else if("isblock".equals(fieldName)){
			fieldName="ismembersee";
		}else if("envaluedoc".equals(fieldName)){
			fieldName="commentdoc";
		}else if("proposedoc".equals(fieldName)){
			fieldName="advicedoc";
		}else if("protemplateid".equals(fieldName)){//模板字段不需要
			continue;
		}else if("department".equals(fieldName)){//部门字段不需要
			continue;
		}else if("procode".equals(fieldName)){//项目编码字段不需要
			continue;
		}else if("status".equals(fieldName)){//项目编码字段不需要
			continue;
		}
		
		String fieldkind=v.getString("fieldkind");
		String fieldValue="";
		if("2".equals(fieldkind)){
			fieldValue= RecordSet_cus.getString(fieldName);
			fieldName="customfield"+fieldid.replace("prjtype_", "");
			v.put("id", fieldid.replace("prjtype_", ""));
		}else{
			fieldValue= RecordSet.getString(fieldName);
		}
		String hideField="{}";
		if(needHideField.indexOf(","+fieldName+",")!=-1){
			hideField="{'samePair':'hideField'}";
		}
		
		
		
		
	%>
	<wea:item attributes='<%=hideField %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=hideField %>'>
		<%
		if("protypeid".equals(fieldName)){
			%>
			<%=ProjectTypeComInfo.getProjectTypename(""+ projTypeId) %>
			<input type="hidden" name=prjtype value="<%=projTypeId %>" />
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
				String isSingleStr = "true";//单选
			    if(type==162||type==257){
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
			<%}else{ %>
				<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
			<%}%>
			<%
		}
		%>
		
	</wea:item>


<%
if(false&&PrjSettingsComInfo.getPrj_acc() && fieldcount==fieldsize && groupcount==1){//项目卡片附件
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
		<wea:item>
			<%
			  String display = "0";
			  if(!project_accessory.equals("")) {
					display = "1";
					if(project_accessory.startsWith(",")){
						project_accessory= project_accessory.substring(1,project_accessory.length());
					}
					if(project_accessory.endsWith(",")){
						project_accessory= project_accessory.substring(0,project_accessory.length()-1);
					}
					String sql="select id,docsubject,accessorycount from docdetail where id in ("+project_accessory+")";
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
	            <input type=hidden name="field_del_<%=linknum%>" value="0" >
	              <%=imgSrc%>
	              <%if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc"))){%>
	                <a style="cursor:hand" onclick="opendoc('<%=showid%>','<%=versionId%>','<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
	              <%}else{%>
	                <a style="cursor:hand" onclick="opendoc1('<%=showid%>')"><%=tempshowname%></a>&nbsp
	              <%}%>
	              <input type=hidden name="field_id_<%=linknum%>" value=<%=showid%>>
				    <button type="button" class=btnFlow accessKey=1 onclick='onChangeSharetype("span_id_<%=linknum%>","field_del_<%=linknum%>","<%=0%>")'>
					<u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
					<span id="span_id_<%=linknum%>" name="span_id_<%=linknum%>" style="visibility:hidden">
	                    <B><FONT COLOR="#FF0033">√</FONT></B>
	                </span>
	          <%}%>
	            <input type=hidden name="field_idnum" value=<%=linknum+1%>>
	            <input type=hidden name="field_idnum_1" value=<%=linknum+1%>>
	        <%}%> 
			<%  
			if(!"".equals(PrjSettingsComInfo.getPrj_accsec()) && Util.getIntValue(PrjSettingsComInfo.getPrj_accsize(),0)>0 ){
			%>
	        
	          <script type="text/javascript">
					window.onload = function() {
					  var settings = {
							flash_url : "/js/swfupload/swfupload.swf",
							upload_url: "/proj/data/uploadPrjAcc.jsp",
							post_params: {"method" : "uploadPrjAcc","secid":"<%=PrjSettingsComInfo.getPrj_accsec() %>"},
							file_size_limit : "<%=PrjSettingsComInfo.getPrj_accsize() %> MB",
							file_types : "*.*",
							file_types_description : "All Files",
							file_upload_limit : 100,
							file_queue_limit : 0,
							custom_settings : {
								progressTarget : "fsUploadProgress",
								cancelButtonId : "btnCancel"
							},
							debug: false,
							button_image_url : "/js/swfupload/add_wev8.png",
							button_placeholder_id : "spanButtonPlaceHolder",
			
							button_width: 100,
							button_height: 18,
							button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
							button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
							button_text_top_padding: 0,
							button_text_left_padding: 18,
								
							button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
							button_cursor: SWFUpload.CURSOR.HAND,
							
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
						if(data){
							var a=data;
							if(a>0){
								jQuery("#accdocids").val(jQuery("#accdocids").val()+","+a);
							}
						}
					}
			
					function uploadComplete(fileObj) {
						try {
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
				(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=PrjSettingsComInfo.getPrj_accsize() %>M)
			<%}else{%>
			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
	       <%}%>
		</wea:item>
	
	<%
	}
	%>
	
	<%
	}
}

%>
</wea:group>
	<%
}
%>
 	
</wea:layout>




</div>
<!-- 任务列表 -->
<div id="agendaDiv" style="display:none;">
  
  <iframe  id="taskDataIframe" name="taskDataIframe" src="/proj/Templet/ProjTempletEditData.jsp?templetId=<%=""+templetId %>" class="flowFrame" frameborder="0" scrolling="auto" height="500px" width="100%"></iframe>
  
  <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
   <div id="divTaskList" style="display:none;"></div>
  
  
  
  
  
</div>
<div id="temp_seleBeforeTask_DIV" style="display:none"><select name='temp_seleBeforeTask' class='inputStyle'><option value='0'></option></select></div>
</FORM>

</div>

<%
if("1".equals(isDialog) ){
	%>
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
	<%
}

%>

<script language=javascript>
function opendoc(showid,versionid,docImagefileid){
	openFullWindowForXtable("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&from=accessory&wpflag=workplan");
	
}
function opendoc1(showid){
	openFullWindowForXtable("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&wpflag=workplan");
}
function checkDateValidity(begindate,begintime,enddate,endtime,errormsg){
	var isValid = true;
	if(compareDate(begindate,begintime,enddate,endtime) == 1){
		window.top.Dialog.alert(errormsg);
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



<script language="javaScript">
	var ptu = null;
	var iRowIndex = null;
	var RowindexNum = null;
	
	function init_ptu() {
		    iRowIndex = document.getElementById("task_iRowIndex").value;
		    RowindexNum = document.getElementById("task_RowindexNum").value;
	}
	
    function doSave(obj){
	   	if(!check_form(frmain,'name,prjtype')) return false;
		myBody.onbeforeunload=null;
 		obj.disabled = true;
 		
 		var levelflag = $("#taskDataIframe")[0].contentWindow.reloadTaskTree();
 		if("overlevel"==levelflag){
 			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125271, user.getLanguage()) %>");
 			obj.disabled = false;
 		}else{
 			var taskinfo= $("#taskDataIframe").contents().find("#divTaskList").html();
 	 	   	$("#divTaskList").html(taskinfo);
 	 	   	
 	 		/**var xmlDoc=document.createElement("rootTask");
 	 		var docDom=generaDomJson();
 		 	$.toXml(docDom,xmlDoc);
 		    document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";
 		    **/
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
	   try {
	 	   	var taskArr = new Array();
	 	   	var txtTaskNames = document.getElementsByName("txtTaskName");
	 	   	for (i=1;i<=txtTaskNames.length;i++){
	 	   		taskArr[i-1] = txtTaskNames[i-1].value;
	 	   	}
	 	   	var seleBeforeTasks = document.getElementsByName("seleBeforeTask");
	 	   	for (i=1;i<=seleBeforeTasks.length;i++){
		 	   	try {
	 	   			if(seleBeforeTasks[i-1].value!='' && seleBeforeTasks[i-1].value!='0') {
	 	   				document.getElementById('seleBeforeTaskSpan_'+i).innerHTML = taskArr[document.getElementById('templetTaskId_'+seleBeforeTasks[i-1].value).value];
	 	   				seleBeforeTasks[i-1].value = document.getElementById('templetTaskId_'+seleBeforeTasks[i-1].value).value*1+1;
	 	   			}
		 	   	}catch(e){
		 	   		seleBeforeTasks[i-1].value;
			 	}
	 	   	}
	   }catch(e){}
    }


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
   	    ajax.open("POST", "ProjTempletEditData.jsp?templetId=<%=templetId%>", true);
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
   	   	            //alert("=========================================");
   	            	//alert(e.description);
   	                return false;
   	            }
   	        }
   	    }
   	}
   	
//showdata();
</script>


<script type="text/javascript">
$(function(){
	try{
		parent.setTabObjName("<%=templetName %>");
	}catch(e){}
});
</script>

</body>
</html>
<script type="text/javascript">
<!--
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

//项目类型
function onShowPrjTypeID(txtObj,spanObj,spanImgObj,method,templetId){   
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp?sqlwhere=Where wfid<>0 ")
	if (datas){
        if(datas.id){
            spanObj.innerHtml = datas.name
            txtObj.value=datas.id
			if (method=="add"){
				location = "ProjTempletAdd.jsp?txtPrjType="+datas.id;
			}else{
				location = "ProjTempletEdit.jsp?txtPrjType="+datas.id+"&templetId="+templetId
			}
			$(spanImgObj).html("");
        } else {
            $(spanObj).html("");           
			$(spanImgObj).html("<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>");
            $(txtObj).val("");
        }
	}
}
//td71102
$(function(){
	var crmnames='<%=ProjTempletUtil.getCrmNames(proCrm) %>';
	$("#areaAboutMCrmSpan").html(crmnames);
});

//-->
</script>

<script type="text/javascript">
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


</script>
<script type="text/javascript">
jQuery(function(){
	hideEle('hideField');
});
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<script language=javascript src="/proj/js/common_wev8.js"></script>
