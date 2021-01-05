<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>



<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="PrjTskFieldManager" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjTskCardGroupComInfo" scope="page" />

<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskUtil_wev8.js"></script>
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
var parentDialog;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	try{
		
		parentWin = parent.parent.getParentWindow(parent);
		parentDialog = parent.parent.getDialog(parent);
		parentDialog.close();
		//parentWin._table.reLoad();
		parentWin.reloadPage();
	}catch(e){}
		
}
</script>


<script type="text/javascript">
var oUpload;
</script>
</HEAD>
<%

if("1".equals(isclose)){
	return;
}

int sign = Util.getIntValue(request.getParameter("sign"),-1);
String ProjID = Util.null2String(request.getParameter("ProjID"));
String taskrecordid="";

//获取项目经理和是否跳过非工作时间
String manager ="";
String passnoworktime ="";
RecordSet.executeSql("select manager,passnoworktime from Prj_ProjectInfo where id = "+ProjID+"");
if(RecordSet.next()){
	manager = RecordSet.getString("manager");
	passnoworktime = RecordSet.getString("passnoworktime");
}
/*项目状态*/
RecordSet rs2 = new RecordSet();
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID+"order by id";
rs2.executeSql(sql_tatus);
rs2.next();
String isCurrentActived=rs2.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status,members from Prj_ProjectInfo where id = "+ProjID;
rs2.executeSql(sql_prjstatus);
rs2.next();
String status_prj=rs2.getString("status");
String members =Util.null2String( rs2.getString("members"));
while(members.startsWith(",")){
	members=members.substring(1,members.length());
}
while(members.endsWith(",")){
	members=members.substring(0,members.length()-1);
}
//System.out.println("isactived:"+isCurrentActived);
//System.out.println("status_prj:"+status_prj);
if(isCurrentActived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4"))){//项目冻结或者项目完成
	response.sendRedirect("ViewProcess.jsp?ProjID="+ProjID);
}
String parentid = Util.null2String(request.getParameter("parentid"));
//System.out.println("parentid333333:" + parentid);
String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

//4E8 项目权限等级(默认共享的值设置:项目成员0.5,项目经理2.5,项目经理上级3,项目管理员4;手动共享值设置:查看1,编辑2)
double ptype=Util.getDoubleValue( CommonShareManager.getPrjPermissionType(""+ProjID, user),0 );
if(ptype==2.5||ptype==2){
	canview=true;
	canedit=true;
	ismanager=true;
}else if (ptype==3){
	canview=true;
	canedit=true;
	ismanagers=true;
}else if (ptype==4){
	canview=true;
	canedit=true;
	isrole=true;
}else if (ptype==0.5){
	canview=true;
	ismember=true;
}else if (ptype==1){
	canview=true;
	isshare=true;
}
//4E8 项目任务权限等级(默认共享的值设置:成员可见0.5,项目经理2.5,项目经理上级2.1,项目管理员2.2;项目手动共享值设置:查看1,编辑2;任务负责人:2.8;项目任务手动共享值设置:查看0.8,编辑2.3;)
ptype=Util.getDoubleValue( CommonShareManager.getPrjTskPermissionType(parentid, user) ,0.0);
if(ptype>=2.0){
	canedit=true;
	canview=true;
}else if(ptype>=0.5){
	canview=true;
}


/*权限－end*/
	boolean isResponser=false;


String begindate = "";
String enddate = "";
String workday = "";
String parentids = "";
String parenthrmids = "";
String fixedcost = "";
String hrmid = "";
String pretask="";
String parentname="";

String realManDays = "";

int level = 0;

if(parentid.equals("")) {
	parentid="0";
} else {
	RecordSet.executeProc("Prj_TaskProcess_SelectByID",parentid);
	if(RecordSet.next()){
		begindate = RecordSet.getString("begindate");
		enddate = RecordSet.getString("enddate");
		workday = RecordSet.getString("workday");
		parentids = RecordSet.getString("parentids");
		parenthrmids = RecordSet.getString("parenthrmids");
		hrmid = RecordSet.getString("hrmid");
		level = RecordSet.getInt("level_n");
        realManDays = RecordSet.getString("realManDays");
        parentname = Util.null2String( RecordSet.getString("subject"));

		if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
		  isResponser=true;
		}
		
		if((""+user.getUID()).equals(hrmid) ){
			canedit=true;
		}
		
	}

    //  新建子任务的时候计算workday
    try {
        int i;
        int frombackyear = Util.getIntValue(begindate.substring(0,4)) ; //开始的年份
        int frombackmonth = Util.getIntValue(begindate.substring(5,7)) ; //开始的月份
        int frombackday = Util.getIntValue(begindate.substring(8,10)); //开始的天数

        if(enddate.compareTo(begindate)==0){
            i=1;
        }else{

            Calendar thedate1 = Calendar.getInstance ();
            thedate1.set(frombackyear,frombackmonth-1,frombackday) ;
            for(i=1;;i++){
                thedate1.add(Calendar.DATE, 1) ; //增加天数
                String forecastStartDate = Util.add0(thedate1.get(Calendar.YEAR), 4) +"-"+
                           Util.add0(thedate1.get(Calendar.MONTH) + 1, 2) +"-"+
                           Util.add0(thedate1.get(Calendar.DAY_OF_MONTH), 2) ;
                if(enddate.compareTo(forecastStartDate) <=0)
                    break;
            }
            i=i+1;
        }
        workday= "" + i;
    } catch (Exception e) {
        //do nothing
    }
}
if(level==0){
	level=1;
}
else {
	level += 1;
}


if(!canedit && !isResponser){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(canedit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",ViewProcess.jsp?log=n&ProjID="+ProjID+",_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmain name=frmain action="/proj/process/TaskOperation.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="accdocids" id="accdocids" value="">
  <input type="hidden" name="method" value="add">
    <input type="hidden" name="type" value="process">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
  <input type="hidden" name="parentid" value="<%=parentid%>">
  <input type="hidden" name="parentids" value="<%=parentids%>">
  <input type="hidden" name="parenthrmids" value="<%=parenthrmids%>">
  <input type="hidden" name="level" value="<%=level%>">
    <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
    <input type="hidden" name="isResponser" value="<%=isResponser%>">
    
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canedit){
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
		int fieldlabel=v.getInt("fieldlabel");
		String fieldid=v.getString("id");
		String fieldName=v.getString("fieldname");
		int fieldhtmltype=v.getInt("fieldhtmltype");
		String fielddbtype = v.getString("fielddbtype");
		int type=v.getInt("type");
		int ismand=v.getInt("ismand");
		int issystem=v.getInt("issystem");
		String fieldkind=v.getString("fieldkind");
		String fieldValue="";
		if("actualbegindate".equalsIgnoreCase(fieldName)||"actualenddate".equalsIgnoreCase(fieldName)
				||"realmandays".equalsIgnoreCase(fieldName)||"finish".equalsIgnoreCase(fieldName)
				||("islandmark".equalsIgnoreCase(fieldName)&&Util.getIntValue( parentid,0)>0)
				||("accessory".equalsIgnoreCase(fieldName)&&!PrjSettingsComInfo.getTsk_acc() )){
			continue;
		}
		
		
		if(fieldlabel==1322){
			fieldlabel = 742;
		}else if(fieldlabel==741){
			fieldlabel = 743;
		}
		
		
		
%>
	<wea:item ><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item >
<%
		if("subject".equalsIgnoreCase(fieldName)){
%>			
			<INPUT class=inputstyle maxLength=80 size=40 name="subject" value="" onChange="checkinput('subject','subjectspan')"> <span
            id=subjectspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
<%
		}else if("hrmid".equalsIgnoreCase(fieldName)){
			String browserurl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?";
         	String completeUrl="/data.jsp?type=1";
%>			
			<brow:browser viewType="0" name="hrmid"
				browserValue="" 
				browserSpanValue=""
				browserUrl='<%=browserurl %>'
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl='<%=completeUrl %>'  />	 
<%
		}else if("parentid".equalsIgnoreCase(fieldName)){
			if(Util.getIntValue( parentid,0)>0){
%>				
			<%=parentname %>
<%
			}else{
				String parenttaskbrowserurl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?prjid="+ProjID+"%26browtype=single%26taskrecordid=-1%26from=addtask";
				String parenttaskcompleteurl="/data.jsp?type=prjtsk&whereClause=t1.id="+ProjID+" ";
%>			
			<brow:browser viewType="0" name="parentid" 
				browserValue="" 
				browserSpanValue="" 
				browserUrl='<%=parenttaskbrowserurl %>'
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl='<%=parenttaskcompleteurl %>'  />	
<%
			}
%>			
<%
		}else if("prjid".equalsIgnoreCase(fieldName)&&canview){
%>			
			<%="<a href=\"javascript:openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID="+ProjID+"')\">"+ ProjectInfoComInfo.getProjectInfoname(ProjID)+"</a>" %>
<%
		}else if("begindate".equalsIgnoreCase(fieldName)){
%>			

			<button type="button" class=Calendar bind="begindate" onclick="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=manager %>','<%=passnoworktime %>')"></BUTTON>
              <SPAN id=begindatespan ></SPAN>
              <input type="hidden" name="begindate" id="begindate" value="">
              
           <button type="button" class=Clock bind="begintime" onclick="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=manager %>','<%=passnoworktime %>')"></BUTTON>
           <SPAN id=begintimespan >00:00</SPAN>
           <input type="hidden" name="begintime" id="begintime" value="00:00">
           
<%
		}else if("enddate".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=Calendar bind="enddate" onclick="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=manager %>','<%=passnoworktime %>')"></BUTTON>
              <SPAN id=enddatespan ></SPAN>
              <input type="hidden" name="enddate" id="enddate" value="">
             
           <button type="button" class=Clock bind="endtime" onclick="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=manager %>','<%=passnoworktime %>')"></BUTTON>
            <SPAN id=endtimespan >23:59</SPAN>
            <input type="hidden" name="endtime" id="endtime" value="23:59"> 
<%
		}else if("workday".equalsIgnoreCase(fieldName)){
%>			<!-- 
			<INPUT  class=InputStyle style="width:80px!important;" maxLength=5 size=5 name="workday" id="workday" bind="workday" value="" 
			onblur="genDateAndWorkday(this,'begindate','enddate','workday')"
					onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
					onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^0-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}" >
			 -->		
			 
			 <INPUT  class=InputStyle style="width:80px!important;" maxLength=5 size=5 name="workday" id="workday" bind="workday" value="" 
				onblur="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=manager %>','<%=passnoworktime %>')" 
				onKeyPress='ItemNum_KeyPress(this)'>
<%
		}else if("fixedcost".equalsIgnoreCase(fieldName)){
%>			
			<INPUT class=InputStyle style="width:80px!important;" maxLength=20 size=20 name="fixedcost" value="" onKeyPress="ItemNum_KeyPress(this)" onBlur='checknumber("fixedcost")'>
<%
		}else if("islandmark".equalsIgnoreCase(fieldName)){
%>			
			<INPUT type=checkbox name="islandmark" value=1    >
<%
		}else if("prefinish".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=e8_browflow onclick="onShowMTask('taskids02span','taskids02','ProjID','taskrecordid')"></button>
			<input type=hidden name="taskids02"  id="taskids02"  value="">
			<span id="taskids02span">
<%
		}else if("accessory".equalsIgnoreCase(fieldName)){
			String accsec=PrjSettingsComInfo.getTsk_accsec ();
			String accsize=PrjSettingsComInfo.getTsk_accsize();
			
%>			
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
							    (<%=SystemEnv.getHtmlLabelName(18642,user.getLanguage())%>:<%=accsize%>M)
							    <input type=hidden name=accessory_num value="1">
<%
		}else{
			if(fieldhtmltype==3&&(type==161||type==162||type==256||type==257)){
				String showname="";
				String urls= "";
				if(type==161||type==162){
					showname=PrjTskFieldManager.getBrowserFieldvalue(user,fieldValue, type, fielddbtype,false);
					urls=BrowserComInfo.getBrowserurl(""+type)+"?type="+fielddbtype;     // 浏览按钮弹出页面的
				}else{
					CustomTreeUtil customTreeUtil = new CustomTreeUtil();
			   	  	showname = customTreeUtil.getTreeFieldShowName(fieldValue,fielddbtype);
			   	  	urls=BrowserComInfo.getBrowserurl(""+type)+"?type="+fielddbtype+"_"+type;     // 浏览按钮弹出页面的url
				}
				
				String isMustInput = "1" ; 
				if(ismand==1){
					isMustInput = "2";
				}
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
	}
}

%>
</wea:group>
	<%
}
%>

	
</wea:layout>

<div style="height:100px!important;"></div>

</FORM>
<script type="text/javascript">

function onShowMTask(spanname,inputename,prj,task) {
    try{
    	var inputid=$("#"+inputename).attr("id");
    	var ProjID = $("input[name="+prj+"]").val();
        var taskrecordid = $("input[name="+task+"]").val();
		var taskids = $("input[name="+inputename+"]").val();
		showModalDialogForBrowser(null,
				"/systeminfo/BrowserMain.jsp?url=/proj/process/SingleTaskBrowser.jsp?taskids="+taskids+"&ProjID="+ProjID+"&taskrecordid="+taskrecordid, '#', inputid, true, 2, '', 
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
					sHtml = sHtml+taskname[i]+"&nbsp";
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
 <script language="javascript">
oldbegindate="";
oldenddate="";
//setTimeout("CaculateWorkDay();",50);
function CaculateWorkDay(){
	begindate = document.all("begindate").value;
	enddate = document.all("enddate").value;
	if((begindate!=oldbegindate||enddate!=oldenddate)&&begindate!=""&&enddate!="" && begindate != null && enddate != null){
		oldbegindate = begindate;
		oldenddate = enddate;
		begindateY = begindate.substring(0,begindate.indexOf("-"));
		begindateM = begindate.substring(begindate.indexOf("-")+1,begindate.lastIndexOf("-"))-1;
		begindateD = begindate.substring(begindate.lastIndexOf("-")+1);
		enddateY = enddate.substring(0,enddate.indexOf("-"));
		enddateM = enddate.substring(enddate.indexOf("-")+1,enddate.lastIndexOf("-"))-1;
		enddateD = enddate.substring(enddate.lastIndexOf("-")+1);
		bd = new Date(begindateY,begindateM,begindateD);
		ed = new Date(enddateY,enddateM,enddateD);
		diffdays = Math.floor((ed.valueOf()-ed.getTimezoneOffset()*60000)/(3600*24000))-Math.floor((bd.valueOf()-bd.getTimezoneOffset()*60000)/(3600*24000))+1;
		document.all("workday").value = diffdays;
	}
	//setTimeout("CaculateWorkDay();",50);
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
function submitData()
{
	if (check_form(frmain,'<%=CptFieldComInfo.getMandFieldStr() %>')&&checkDateRange(frmain.begindate,frmain.enddate,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")) {
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
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
</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.closeByHand();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT> 
</HTML>
<%@include file="/hrm/include.jsp"%>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script>
function protectTask() {
	if(!checkDataChange())
  	event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
document.body.onbeforeunload=function () {protectTask();}
</script>
<script language=javascript src="/js/checkData_wev8.js"></script>
<script language=javascript src="/proj/js/common_wev8.js"></script>
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
<!-- end by cyril on 2008-06-13 for TD:8828 -->
