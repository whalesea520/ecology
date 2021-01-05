<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetR" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="PrjTskFieldManager" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjTskCardGroupComInfo" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/xpSpin_wev8.css">
<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin_wev8.js"></script>
<style>
 .xpSpin  span{
   font-family: webdings !important;
   font-size: 9pt;
 }

</style>

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
if("<%=isclose%>"=="1" && "<%=isDialog %>"=="1" ){
	//parentWin.onBtnSearchClick();
	try{
		parentWin = parent.parent.getParentWindow(parent);
		parentDialog = parent.parent.getDialog(parent);
		parentDialog.close();
		parentWin._table.reLoad();
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
String taskrecordid = request.getParameter("taskrecordid");
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";



String userid = ""+user.getUID() ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%

//RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
String sql22="select t1.*,t2.subject as parentname,t3.members from Prj_TaskProcess t1 left outer join Prj_TaskProcess t2 on t1.parentid=t2.id left outer join prj_projectinfo t3 on t3.id=t1.prjid  where t1.id="+taskrecordid;
RecordSet.executeSql(sql22);
RecordSet.next();
String ProjID = RecordSet.getString("prjid");
String manager = ProjectInfoComInfo.getProjectInfomanager(ProjID);
String project_accessory = Util.null2String(RecordSet.getString("accessory"));//相关附件

//获取项目经理和是否跳过非工作时间
String mymanager ="";
String passnoworktime ="";
rs1.executeSql("select manager,passnoworktime from Prj_ProjectInfo where id = "+ProjID+"");
if(rs1.next()){
	mymanager = rs1.getString("manager");
	passnoworktime = rs1.getString("passnoworktime");
}


String members =Util.null2String( RecordSet.getString("members"));
while(members.startsWith(",")){
	members=members.substring(1,members.length());
}
while(members.endsWith(",")){
	members=members.substring(0,members.length()-1);
}

/*Add by Huang Yu ON April 22 ,2204##################START###########*/
/*如果状态为删除和新增时，不能再进行编辑*/
int status = RecordSet.getInt("status");
//System.out.println("status = "+status);
if(status ==1 || status == 3){
	response.sendRedirect("ViewTask.jsp?taskrecordid="+taskrecordid);
	return;
}

/*Add by Huang Yu ON April 22 ,2204##################END###########*/

String pretaskid=Util.null2String( RecordSet.getString("prefinish"));
//获取前置任务的index
String taskname="";
if(!pretaskid.equals("0")){
	String sql_1="select id,subject from Prj_TaskProcess where prjid="+Util.getIntValue(ProjID)+" AND taskIndex="+pretaskid+"";
    RecordSet3.executeSql(sql_1);
    if( RecordSet3.next()){
    	taskname +="<a href=\"javascript:openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid="+RecordSet3.getInt("id")+"')\" >"+RecordSet3.getString("subject")+"</a> ";
    	
    }
}



/*查看是否前置任务都已经完成，若有一个没有完成（100％）那么就不能对此任务进行编辑*/
String parentids= RecordSet.getString("parentids");
parentids = parentids.startsWith("'") ? parentids.substring(1,parentids.length()) : parentids;
parentids = parentids.endsWith("'") ? parentids.substring(0,parentids.length()-1) : parentids;
//==================================================================================
//modified by hubo,20060228,TD3741
int size_t = 0;
String temstr = "null";
if(!parentids.equals("")){
	size_t = parentids.length();
	temstr = parentids.substring (0,size_t-1);
}
String sql_Task="select prefinish from Prj_TaskProcess where id in (" + temstr +")";
RecordSet4.executeSql(sql_Task);
String PreTaskid="";
while(RecordSet4.next()){
    if(!((RecordSet4.getString("prefinish")).equals(""))){
        PreTaskid += RecordSet4.getString("prefinish") +",";
    }
}
int size_2 = 0;
String temstr_2 = "";
if(!PreTaskid.equals("")){
	size_2 = PreTaskid.length();
	temstr_2 = PreTaskid.substring (0,size_2-1);
}
//==================================================================================
boolean canedit_finish = true;

    /*查看前置任务的id是否全为零，若全为零说明没有前置任务*/
ArrayList task_0 = Util.TokenizerString(temstr_2,",");
boolean isallzero = true;
int task_size = task_0.size();
for(int j=0;j<task_size;j++ ){
    String is0 =""+ task_0.get(j);
    if(!is0.equals("0")){
        isallzero=false;
    }
}

if(!isallzero){//如果不全为零
//TD4408
//modified by hubo,2006-05-24
//String sql_preTask= "select finish from  Prj_TaskProcess where id in ( " +temstr_2 +")";

}
if("".equals(pretaskid)){
	pretaskid = "null";
}
String sql_preTask= "select finish,subject,status from  Prj_TaskProcess where taskindex in ( " +pretaskid+") AND prjid="+Util.getIntValue(ProjID)+"";
RecordSet4.executeSql(sql_preTask);
String presubject = "";
while(RecordSet4.next()){
	String bf_finish = Util.null2String(RecordSet4.getString("finish"));
    String bf_status = Util.null2String(RecordSet4.getString("status"));
    if(!(bf_finish.equals("100")&&bf_status.equals("0"))){
        canedit_finish= false;
    }
    presubject = RecordSet4.getString("subject");
}

//判断前置任务完毕！！！



//out.print(manager.equals(userid));
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

//4E8 项目任务权限等级(默认共享的值设置:成员可见0.5,项目经理2.5,项目经理上级2.1,项目管理员2.2;项目手动共享值设置:查看1,编辑2;任务负责人:2.8;项目任务手动共享值设置:查看0.8,编辑2.3;)
double ptype=Util.getDoubleValue( CommonShareManager.getPrjTskPermissionType(taskrecordid, user) ,0.0);
if(ptype>=2.0){
	canedit=true;
	canview=true;
}else if(ptype>=0.5){
	canview=true;
}


boolean isResponser=false;
if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
  isResponser=true;
}

if(!canedit && !isResponser){
	//response.sendRedirect("/notice/noright.jsp") ;
	//return ;
%>	
<script type="text/javascript">
window.location.href="/notice/noright.jsp";
</script>
<%
return;
}
/*权限－end*/
//System.out.println("ptype2==================================:"+ptype);
%>

<FORM id=frmain name=frmain action="/proj/process/TaskOperation.jsp" method=post enctype="multipart/form-data" >
<input type="hidden" name="accdocids" id="accdocids" value="">
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="isdialog" value="<%=isDialog %>">
  <input type="hidden" name="type" value="process">
  <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
  <input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
  <input type="hidden" name="parentids" value="<%=RecordSet.getString("parentids")%>">
  <input type="hidden" name="oldhrmid" value="<%=RecordSet.getString("hrmid")%>">
  <%if(!(manager.equals(userid))){%>
  <input type="hidden" name="submittype" value="0">
  <%}else{%>
  <input type="hidden" name="submittype" value="1">
  <%}%>
  
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
int prjstatus=Util.getIntValue( ProjectInfoComInfo.getProjectInfostatus(ProjID),0);

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
		if((("actualbegindate".equalsIgnoreCase(fieldName)||"actualenddate".equalsIgnoreCase(fieldName)
				||"realmandays".equalsIgnoreCase(fieldName))&&(prjstatus==0||prjstatus==6||prjstatus==7))
				||("finish".equalsIgnoreCase(fieldName)&&(prjstatus==0||prjstatus==6||prjstatus==7))
				||("parentid".equalsIgnoreCase(fieldName)&&Util.getIntValue(RecordSet.getString("parentid")  ,0)<=0)
				||("accessory".equalsIgnoreCase(fieldName)&&!PrjSettingsComInfo.getTsk_acc() )
				||("islandmark".equalsIgnoreCase(fieldName)&&RecordSet.getInt("level_n")>1 )){
			continue;
		}
		
		
		if(fieldlabel==1322){
			fieldlabel = 742;
		}else if(fieldlabel==741){
			fieldlabel = 743;
		}else if(fieldlabel==33351){
			fieldlabel = 24162;
		}else if(fieldlabel==24697){
			fieldlabel = 24163;
		}
		
%>
	<wea:item ><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item >
<%
		if("subject".equalsIgnoreCase(fieldName)){
%>			
			<INPUT class=inputstyle maxLength=80 size=40 name="subject" value="<%=Util.toScreen( RecordSet.getString("subject"),user.getLanguage()) %>" onChange="checkinput('subject','subjectspan')"> <span id=subjectspan></span>
<%
		}else if("hrmid".equalsIgnoreCase(fieldName)){
         	
         	String hrmid=Util.null2String(RecordSet.getString("hrmid"));
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
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl='<%=completeUrl %>'  />
<%
		}else if("parentid".equalsIgnoreCase(fieldName)){
%>			
			<%=Util.null2String( RecordSet.getString("parentname")) %>
<%
		}else if("prjid".equalsIgnoreCase(fieldName)&&canview){
%>			
			<%="<a href=\"javascript:openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID="+ProjID+"')\">"+ ProjectInfoComInfo.getProjectInfoname(ProjID)+"</a>" %>
<%
		}else if("begindate".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=Calendar bind='begindate' onclick="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=mymanager %>','<%=passnoworktime %>')"></BUTTON>
              <SPAN id=begindatespan >
				  <%if(!RecordSet.getString("begindate").equals("x")){%>
						<%=RecordSet.getString("begindate")%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="begindate" id="begindate" value="<%=Util.null2String( RecordSet.getString("begindate")) %>">
              
                <button type="button" class=Clock bind="begintime" onclick="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=mymanager %>','<%=passnoworktime %>')"></BUTTON>
           <SPAN id=begintimespan ><%=RecordSet.getString("begintime") %></SPAN>
           <input type="hidden" name="begintime" id="begintime" value="<%=RecordSet.getString("begintime") %>">
<%
		}else if("enddate".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=Calendar bind='enddate' onclick="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=mymanager %>','<%=passnoworktime %>')"></BUTTON>
              <SPAN id=enddatespan >
				  <%if(!RecordSet.getString("enddate").equals("-")){%>
						<%=RecordSet.getString("enddate")%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="enddate" id="enddate" value="<%=Util.null2String(RecordSet.getString("enddate")) %>">
              
              <button type="button" class=Clock bind="endtime" onclick="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=mymanager %>','<%=passnoworktime %>')"></BUTTON>
            <SPAN id=endtimespan ><%=RecordSet.getString("endtime") %></SPAN>
            <input type="hidden" name="endtime" id="endtime" value="<%=RecordSet.getString("endtime") %>"> 
<%
		}else if("workday".equalsIgnoreCase(fieldName)){
			
%>			
			<INPUT class=InputStyle style="width:80px!important;" maxLength=5 size=5 name="workday" id="workday" bind="workday" value="<%=RecordSet.getString("workday") %>"  
					onblur="genDateAndWorkday(this,'begindate','enddate','workday','begintime','endtime','<%=mymanager %>','<%=passnoworktime %>')"
										onKeyPress='ItemNum_KeyPress(this)'>
<%
		}else if("actualbegindate".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=Calendar bind='actualBeginDate' onclick="genDateAndWorkday(this,'actualBeginDate','actualEndDate','realmandays','actualBeginTime','actualEndTime','<%=mymanager %>','<%=passnoworktime %>')"></BUTTON>
	      	<SPAN id="actualBeginDatespan"><%=RecordSet.getString("actualBeginDate")%></SPAN>
	      	<input type="hidden" name="actualBeginDate" id="actualBeginDate" value="<%=RecordSet.getString("actualBeginDate")%>">
	      	
	      	<button type="button" class=Clock bind='actualBeginTime' onclick="genDateAndWorkday(this,'actualBeginDate','actualEndDate','realmandays','actualBeginTime','actualEndTime','<%=mymanager %>','<%=passnoworktime %>')"></BUTTON>
	      	<SPAN id="actualBeginTimespan"><%=RecordSet.getString("actualBeginTime")%></SPAN>
	      	<input type="hidden" name="actualBeginTime" id="actualBeginTime" value="<%=RecordSet.getString("actualBeginTime")%>">
<%
		}else if("actualenddate".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=Calendar bind='actualEndDate' onclick="genDateAndWorkday(this,'actualBeginDate','actualEndDate','realmandays','actualBeginTime','actualEndTime','<%=mymanager %>','<%=passnoworktime %>')"></BUTTON>
      		<SPAN id="actualEndDatespan"><%=RecordSet.getString("actualEndDate")%></SPAN>
      		<input type="hidden" name="actualEndDate" id="actualEndDate" value="<%=RecordSet.getString("actualEndDate")%>">
      		
      		<button type="button" class=Clock bind='actualEndTime' onclick="genDateAndWorkday(this,'actualBeginDate','actualEndDate','realmandays','actualBeginTime','actualEndTime','<%=mymanager %>','<%=passnoworktime %>')"></BUTTON>
      		<SPAN id="actualEndTimespan"><%=RecordSet.getString("actualEndTime")%></SPAN>
      		<input type="hidden" name="actualEndTime" id="actualEndTime" value="<%=RecordSet.getString("actualEndTime")%>">
<%
		}else if("realmandays".equalsIgnoreCase(fieldName)){
%>			
			<INPUT class=InputStyle style="width:80px!important;" maxLength=5 size=5 name="realmandays" id="realmandays" bind="realmandays" value="<%=RecordSet.getString("realManDays")%>" 
					onBlur="genDateAndWorkday(this,'actualBeginDate','actualEndDate','realmandays','actualBeginTime','actualEndTime','<%=mymanager %>','<%=passnoworktime %>')"
					onKeyPress='ItemNum_KeyPress(this)'>
<%
		}else if("fixedcost".equalsIgnoreCase(fieldName)){
%>			
			<INPUT class=InputStyle style="width:80px!important;" maxLength=20 size=20 name="fixedcost" value="<%=RecordSet.getString("fixedcost")%>" onKeyPress="ItemNum_KeyPress(this)" onBlur='checknumber("fixedcost")'>
<%
		}else if("finish".equalsIgnoreCase(fieldName)){
			String tfinish = RecordSet.getString("finish");
%>			
			<%if(canedit_finish){%>
				<%
				int max = 100;
				String imageStyle = "";
				boolean hasUnFinishedDoc = false;
				boolean hasUnFinishedWF = false;
				boolean hasUnNewFinishdedDoc = false;//判断文档状态
				String sql = "";
				
				sql =	 "SELECT docSecCategory FROM prj_task_needdoc ";
				sql += "WHERE taskid="+taskrecordid+" AND isNecessary=1 AND docSecCategory NOT IN(SELECT secid FROM prj_doc WHERE taskid="+taskrecordid+" AND secid IS NOT NULL)";	
				RecordSetR.executeSql(sql);
				if(RecordSetR.next())	hasUnFinishedDoc = true;

				sql = "select t1.docstatus t1 from DocDetail t1 ,prj_doc t2  ";
				sql +="where t2.taskid ="+taskrecordid+" and t1.id = t2.docid and t1.docstatus not in (1,2,5,7,8)";
				RecordSetR.executeSql(sql);
				if(RecordSetR.next())	hasUnNewFinishdedDoc = true;

				sql =	 "SELECT workflowid FROM prj_task_needwf ";
					
				sql += "WHERE taskid="+taskrecordid+" AND isNecessary=1 AND workflowid NOT IN("+
				"SELECT a.workflowid FROM prj_request a,workflow_requestbase b "+
                   "WHERE a.taskid ="+taskrecordid+
                     " AND a.workflowid IS NOT NULL "+
	     			 " and a.requestid=b.requestid)";	
				RecordSetR.executeSql(sql);
				if(RecordSetR.next())	hasUnFinishedWF = true;

				if(hasUnFinishedDoc || hasUnFinishedWF||hasUnNewFinishdedDoc){max=99;imageStyle="visible";}else{imageStyle="hidden";}
				if(max==99&&"100".equals(tfinish))
				{
					String updatetask = "update Prj_TaskProcess set finish=99 where id="+taskrecordid +" and finish=100";
					tfinish = "99";
					RecordSetR.executeSql(updatetask);
				}
				%>
				<input  class="spin height" type="text" style="width:50px!important;" onkeypress="ItemNum_KeyPress('finish')" onblur="checknumber('finish')" id="finish" name="finish"  min="0" max="<%=max%>" value="<%=tfinish%>">%
				<img src="/images/BacoError_wev8.gif" align="absmiddle" style="visibility:<%=imageStyle%>">
         <%}else{%>
         		<input type="hidden" name="finish" id="finish" value="<%=tfinish%>">
				<font class=fontred><%=tfinish%>% <%=SystemEnv.getHtmlLabelName(15277,user.getLanguage())%>(<%=presubject%>)</font>
         <%}%>
<%
		}else if("islandmark".equalsIgnoreCase(fieldName)){
%>			
			<INPUT type=checkbox name="islandmark" value=1  <%if(RecordSet.getString("islandmark").equals("1")){%> checked <%}%>  >
<%
		}else if("prefinish".equalsIgnoreCase(fieldName)){
%>			
			<button type="button" class=e8_browflow onclick="onShowMTask('taskids02span','taskids02','ProjID','taskrecordid')"></button>
			<input type=hidden name="taskids02" id="taskids02" value="<%=pretaskid%>">
			<span id="taskids02span"><%=taskname %></span>
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
				String isSingleStr = "true";//单选
			    if(type==162||type==257){
			    	isSingleStr = "false";
			    }
			    String isMustInput = "1" ; 
				if(ismand==1){
					isMustInput = "2";
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
<script language=javascript>
function checkvalue(prevalue){
    check_value=eval(toFloat(document.all("finish").value,0));

    if(check_value>100 ){
        alert("<%=SystemEnv.getHtmlLabelName(15278,user.getLanguage())%>！");
        document.all("finish").value=prevalue;
    }
}
function opendoc(showid,versionid,docImagefileid){
	openFullWindowForXtable("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&from=accessory&wpflag=workplan");
	
}
function opendoc1(showid){
	openFullWindowForXtable("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&wpflag=workplan");
}
function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}


</script>
<script language="javascript">
function submitData(obj){
   if (check_form(frmain,'<%=CptFieldComInfo.getMandFieldStr() %>')&&checkDateRange(frmain.begindate,frmain.enddate,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")) {
         obj.disabled = true;  
         document.body.onbeforeunload=null;
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

function goBack(){
	try{
		history.go(-1);
	}catch(e){}
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
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js?V=20161202"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT> 
</HTML>

<%@include file="/hrm/include.jsp"%>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData_wev8.js"></script>
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

function checkvalue(prevalue){
    check_value=eval(toFloat(document.all("finish").value,0));

    if(check_value>100 ){
        alert("<%=SystemEnv.getHtmlLabelName(15278,user.getLanguage())%>！");
        document.all("finish").value=prevalue;
    }
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
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


jQuery(document).ready(function(){
   jQuery(".spin").each(function(){
      var $this=jQuery(this);
      var min=$this.attr("min");
      var max=$this.attr("max");
      $this.spin({max:max,min:min});
      $this.blur(function(){
          var value=$this.val();
          if(isNaN(value))
            $this.val(max);
          else{
            value =parseInt(value); 
            if(value>max)
               $this.val(max);
            else if(value<0)
               $this.val(0);
            else
               $this.val(value); 
           if($this.val()=='NaN')
               $this.val(0);          
               
          }  
      });
   });
});

</script>
<script language=javascript src="/proj/js/common_wev8.js"></script>
<script>
function protectTask() {
	if(!checkDataChange())
  	event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
document.body.onbeforeunload=function () {protectTask();}
//difInput('finish','%');//finish的特殊用法
</script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
