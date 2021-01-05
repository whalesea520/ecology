<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjTskCardGroupComInfo" scope="page" />

<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<style type="text/css">
.e8_os{width:30%!important;}
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>

<script type="text/javascript">
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


<script type="text/javascript">
var oUpload;
</script>

</HEAD>

<%
int ProjID = Integer.parseInt(Util.null2String(request.getParameter("templetid")));
int taskTempletId = Integer.parseInt(Util.null2String(request.getParameter("id")));
String loginType = ""+user.getLogintype();
/*权限－begin*/
boolean canMaint = false ;
if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
  canMaint = true ;
}
/*权限－end*/
%>

<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav = "1";
String needhelp = "";
String sql = "";

String taskName = "";
String taskManager = "";
String taskBeginDate = "";
String taskEndDate = "";
String taskWorkDay = "";
String taskBudget = "";
String taskBefTaskID = "";
String taskDesc = "";
String project_accessory = "";//相关附件
String sqlSelectTaskByID = " select t1.*,t2.proMember from Prj_TemplateTask t1 join Prj_Template t2 on t2.id=t1.templetId where t1.id="+taskTempletId;
RecordSet.executeSql(sqlSelectTaskByID);

String members ="-1";
if(RecordSet.next()){
	taskName = RecordSet.getString("taskName");
	taskManager = RecordSet.getString("taskManager");
	taskBeginDate = RecordSet.getString("beginDate");
	taskEndDate = RecordSet.getString("endDate");
	taskWorkDay = RecordSet.getString("workDay");
	taskBudget = RecordSet.getString("budget");
	taskBefTaskID = RecordSet.getString("befTaskId");
	taskDesc = RecordSet.getString("taskDesc");
	project_accessory = RecordSet.getString("accessory");
	members =Util.null2String( RecordSet.getString("proMember"));
	while(members.startsWith(",")){
		members=members.substring(1,members.length());
	}
	while(members.endsWith(",")){
		members=members.substring(0,members.length()-1);
	}
}


String beforeTaskName = "";
if(!taskBefTaskID.equals("0")){
    ArrayList taskBefTaskIDs = Util.TokenizerString(taskBefTaskID,",");
    int taskidnum = taskBefTaskIDs.size();
    for(int j=0;j<taskidnum;j++){
		 String sql_1="SELECT id,taskName FROM Prj_TemplateTask WHERE templetTaskId="+taskBefTaskIDs.get(j);
		 RecordSet2.executeSql(sql_1);
		 if(RecordSet2.next()){
			 beforeTaskName +="<a href=\"javascript:openFullWindowForXtable('/proj/Templet/TempletTaskView.jsp?id="+RecordSet2.getString("id") +"')\" >"+ RecordSet2.getString("taskName")+ "</a>" +" ";
		 }
    }
}

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canMaint){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/Templet/TempletTaskView.jsp?id="+taskTempletId+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmain" id="frmain" action="TempletTaskOperation.jsp" method="post">
<input type="hidden" name="accdocids" id="accdocids" value="">
<input type="hidden" name="method" value="edit">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="taskTempletID" value="<%=taskTempletId%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canMaint ){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%> " class="e8_btn_top" onclick="submitData(this)"/>
			<%
		}
		%>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" style="display:none;" id="advancedSearchDiv"></div>

<wea:layout>

<%

TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap();
CptCardGroupComInfo.setTofirstRow();
while(CptCardGroupComInfo.next()){
	String groupid=CptCardGroupComInfo.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
	
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		v.put("ismand","0");//模板任务字段不需要必填
		int fieldlabel=v.getInt("fieldlabel");
		String fieldName=v.getString("fieldname");
		
		String fieldid=v.getString("id");
		int fieldhtmltype=v.getInt("fieldhtmltype");
		String fielddbtype = v.getString("fielddbtype");
		int type=v.getInt("type");
		
		String fieldValue="";
		if("actualbegindate".equalsIgnoreCase(fieldName)
				||"actualenddate".equalsIgnoreCase(fieldName)
				||"realmandays".equalsIgnoreCase(fieldName)
				||"finish".equalsIgnoreCase(fieldName)
				||("parentid".equalsIgnoreCase(fieldName)&&Util.getIntValue(RecordSet.getString("parenttaskid")  ,0)<=0)
				||("accessory".equalsIgnoreCase(fieldName)&&(true||!PrjSettingsComInfo.getTsk_acc()))
				||"islandmark".equalsIgnoreCase(fieldName)
				||"prjid".equalsIgnoreCase(fieldName)
				
				){
			continue;
		}
		
		
%>
	<wea:item ><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item >
<%
		if("subject".equalsIgnoreCase(fieldName)){
%>			
			<INPUT class=inputstyle maxLength=80 size=40 name="subject" onChange="checkinput('subject','subjectspan')" value="<%=taskName%>">
			<span id=subjectspan></span>
<%
		}else if("hrmid".equalsIgnoreCase(fieldName)){
         	String hrmid=Util.null2String(taskManager);
			String browserurl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+hrmid;
         	String completeUrl="/data.jsp?type=1";
         	
         	String managername = "";
         	if(!"".equals(hrmid)){
         		String[] approves = hrmid.split(",");
         		for(int l=0;l<approves.length;l++){
         			managername+=ResourceComInfo.getResourcename(approves[l])+",";
         		}
         	}
%>			
			<brow:browser viewType="0" name="hrmid"
				browserValue='<%=hrmid %>' 
				browserSpanValue='<%=managername %>'
				browserUrl='<%=browserurl %>'
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
				completeUrl='<%=completeUrl %>'  />
<%
		}else if("parentid".equalsIgnoreCase(fieldName)){
%>			
			<%=Util.null2String( RecordSet.getString("parentname")) %>
<%
		}else if("begindate".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=Calendar bind='begindate' onclick="genDateAndWorkday(this,'begindate','enddate','workday')"></BUTTON>
         <SPAN id=begindatespan><%=taskBeginDate%></SPAN>
         <input type="hidden" name="begindate" id="begindate" value="<%=taskBeginDate%>">
<%
		}else if("enddate".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=Calendar bind='enddate' onclick="genDateAndWorkday(this,'begindate','enddate','workday')"></BUTTON>
         <SPAN id=enddatespan><%=taskEndDate%></SPAN>
         <input type="hidden" name="enddate" id="enddate" value="<%=taskEndDate%>">
<%
		}else if("workday".equalsIgnoreCase(fieldName)){
%>			
			<INPUT class=InputStyle style="width:80px!important;" maxLength=5 size=5 name="workday" id="workday"  value="<%=taskWorkDay%>"  bind="workday"  onblur="genDateAndWorkday(this,'begindate','enddate','workday')"
					onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
					onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >
<%
		}else if("fixedcost".equalsIgnoreCase(fieldName)){
%>			
			<INPUT class=InputStyle style="width:80px!important;" maxLength=20 size=20 name="fixedcost" value="<%=taskBudget%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")' >
<%
		}else if("prefinish".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=e8_browflow onclick="onShowMTask('taskids02span','taskids02','ProjID','taskTempletID')"></button>
			<input type=hidden name="taskids02" id="taskids02"  value="<%=taskBefTaskID%>">
			<span id="taskids02span"><%=beforeTaskName%></span>
<%
		}else if("accessory".equalsIgnoreCase(fieldName)){
			
%>			
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
					sql="select id,docsubject,accessorycount from docdetail where id in ("+project_accessory+")";
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
			if(!"".equals(PrjSettingsComInfo.getTsk_accsec ()) && Util.getIntValue(PrjSettingsComInfo.getTsk_accsize (),0)>0 ){
			%>
	        
	          <script type="text/javascript">
					window.onload = function() {
					  var settings = {
							flash_url : "/js/swfupload/swfupload.swf",
							upload_url: "/proj/data/uploadPrjAcc.jsp",
							post_params: {"method" : "uploadPrjAcc","secid":"<%=PrjSettingsComInfo.getTsk_accsec () %>"},
							file_size_limit : "<%=PrjSettingsComInfo.getTsk_accsize () %> MB",
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
				(<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=PrjSettingsComInfo.getTsk_accsize () %>M)
			<%}else{%>
			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
	       <%}%>
<%
		}else{
			fieldValue=Util.null2String( RecordSet.getString(fieldName));
		
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
				String showfieldname="field"+fieldid;
				
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
	<%}%>
	</wea:item>
<%}}%>
</wea:group>
	<%
}
%>


 	
</wea:layout>
<div style="height:100px!important;"></div>

</form>






<script language=javascript>

function onShowMTask(spanname,inputename,prj,task) {
    try{
    	var inputid=$("#"+inputename).attr("id");
    	var ProjID = $("input[name="+prj+"]").val();
        var taskrecordid = $("input[name="+task+"]").val();
		var taskids = $("input[name="+inputename+"]").val();
		showModalDialogForBrowser(event,
				"/systeminfo/BrowserMain.jsp?url=/proj/Templet/SingleTaskBrowser.jsp?taskids="+taskids+"&ProjID="+ProjID+"&taskrecordid="+taskrecordid, '#', inputid, true, 2, '', 
				{name:inputid,hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onShowMTask_callback}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onShowMTask_callback(p1,datas,fieldname,p4,p5){
	if (datas&&fieldname) {
	    var spanname="taskids02span";
	    if(datas.id){
			task_ids = datas.id.split(",");
			taskname = datas.name.split(",");
			var sHtml="";
			for(var i=0;i<task_ids.length;i++){
				if(task_ids[i]){
					sHtml = sHtml+"<a href=/proj/Templet/TempletTaskView.jsp?id="+task_ids[i]+">"+taskname[i]+"</a>&nbsp";
				}
			}
			$("#"+spanname).html( sHtml);
			$("input[name="+fieldname+"]").val(datas.id);
		}else{
			$("#"+spanname).html( "");
			$("input[name="+fieldname+"]").val("");
		}
	    
    }
}



function submitData(){
	//frmain.submit();
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

function msg(){
	o = document.getElementsByName("referdocs");
	var para = "";
	if(o!=null){
		for(j=0;j<o.length;j++){
			para += o(j).value + ",";
		}
	}
	alert(para);
}

function delRequiredWF(){
	
	var obj = $.event.fix(getEvent()).target;
	while(obj.tagName!="TR")	obj = obj.parentNode;
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.getElementById("tblRequiredWF").deleteRow(obj.rowIndex);
	}
}


function deleteReferDocRow(){
	var oTbl = document.getElementById("tblRefDoc");
	el = $.event.fix(getEvent()).target;
	if(el==null) return false;
	while(el.tagName!="TR"){
		el = el.parentElement;
	}
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		oTbl.deleteRow(el.rowIndex);
	}
}


function deleteRequiredDocRow(){
	var oTbl = document.getElementById("tblRequiredDoc");
	el = $.event.fix(getEvent()).target;
	if(el==null) return false;
	while(el.tagName!="TR"){
		el = el.parentElement;
	}
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		oTbl.deleteRow(el.rowIndex);
	}
}




function onSelectCategory() {
	var oTbl = document.getElementById("tblRequiredDoc");
	/* returnValue = Array(1, id, path, mainid, subid); */
    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
	if (datas) {
	   if (datas.id!=""&&datas.id>0)  {
	        //location = "TempletTaskOperation.jsp?method=addneeddoc&taskTempletID=<%=taskTempletId%>&secid="+result[1];
			row = oTbl.insertRow(oTbl.rows.length);
			row.className =  "DataDark";
			col = row.insertCell(0);
			col.innerHTML = datas.path;
			col = row.insertCell(1);
			col.style.textAlign = "center";
			col.innerHTML = "<input type='checkbox' name='necessary"+datas.id+"' value='1'>";
			col = row.insertCell(2);
			col.innerHTML = "<a href='javascript:void(0)' onclick='deleteRequiredDocRow()'><%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%></a><input type='checkbox' name='requireddocs_mainid' value='"+datas.mainid+"' style='visibility:hidden' checked><input type='checkbox' name='requireddocs_subid' value='"+datas.subid+"' style='visibility:hidden' checked><input type='checkbox' name='requireddocs_secid' value='"+datas.id+"' style='visibility:hidden' checked>"
    	}
	}
}


function onWorkDayChange(workLongObj,beginDateObj,spanBeginDateObj,endDateObj,spanEndDateObj){
	workLong = document.all(workLongObj).value
	beginDate = document.all(beginDateObj).value
	endDate = document.all(endDateObj).value
	
	if(workLong!=""&&beginDate!=""){
		newDate = getAddNewDateStr(beginDate,workLong);
		document.all(spanEndDateObj).innerHTML=newDate;
		document.all(endDateObj).value=newDate;
		return;
	}

	if (workLong!=""&&endDate!=""){
		newDate = getSubtrNewDateStr(endDate,workLong);
		document.all(spanBeginDateObj).innerHTML=newDate;
		document.all(beginDateObj).value=newDate;
		return;
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
</script>
</BODY>
<SCRIPT language="javascript"  src="/js/datetime_wev8.js"></script>
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
</HTML>
