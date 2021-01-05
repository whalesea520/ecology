<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.proj.Maint.*"%>

<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="PrjSettingsComInfo" class="weaver.proj.util.PrjSettingsComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<LINK href="/js/ecology8/base/jquery.ui.all_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/js/ecology8/base/jquery.ui.progressbar_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<style>
.progress-label {
     float: left;
     margin-left: 50%;
     margin-top: 5px;
     font-weight: bold;
     text-shadow: 1px 1px 0 #fff;
}
.ui-progressbar{ 
background : ; 
padding:1px; 
}	
.ui-progressbar-value{ 
background : #A5E994; 
} 
</style>
    

</HEAD>

<%
String nameQuery1 = Util.null2String(request.getParameter("nameQuery1"));
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String taskname = Util.null2String(request.getParameter("taskname"));
String planbegindate = Util.null2String(request.getParameter("planbegindate"));
String planbegindate1 = Util.null2String(request.getParameter("planbegindate1"));
String planenddate = Util.null2String(request.getParameter("planenddate"));
String planenddate1 = Util.null2String(request.getParameter("planenddate1"));
String actualbegindate = Util.null2String(request.getParameter("actualbegindate"));
String actualbegindate1 = Util.null2String(request.getParameter("actualbegindate1"));
String finish = Util.null2String(request.getParameter("finish"));
String finish1 = Util.null2String(request.getParameter("finish1"));
String taskstatus = Util.null2String(request.getParameter("taskstatus"));//审批类型
String hrmid = Util.null2String(request.getParameter("hrmid"));//任务负责人
String prjname = Util.null2String(request.getParameter("prjname"));
String manager = Util.null2String(request.getParameter("manager"));
String managerdept = Util.null2String(request.getParameter("managerdept"));

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(16411,user.getLanguage());
    String needfav ="1";
    String needhelp ="";


%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
RCMenu += "{"+SystemEnv.getHtmlLabelNames("83212",user.getLanguage())+",javascript:batchApprove();,_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("83423",user.getLanguage())+",javascript:batchReject();,_self} " ;
RCMenuHeight += RCMenuHeightStep;
String pageId=Util.null2String(PropUtil.getPageId("prj_projecttaskapprovaltab"));
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="weaver" id="weaver" method="post"  action="">
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("83212",user.getLanguage())%>" class="e8_btn_top"  onclick="batchApprove()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("83423",user.getLanguage())%>" class="e8_btn_top"  onclick="batchReject()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:'';"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1352",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="taskname" id="taskname" value='<%=taskname %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83796",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planbegindate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="planbegindate" value="<%=planbegindate%>">
				  <input class=wuiDateSel  type="hidden" name="planbegindate1" value="<%=planbegindate1%>">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("22170",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planendate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="planenddate" value="<%=planenddate%>">
				  <input class=wuiDateSel  type="hidden" name="planenddate1" value="<%=planenddate1%>">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("33351",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="actualbegindate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="actualbegindate" value="<%=actualbegindate%>">
				  <input class=wuiDateSel  type="hidden" name="actualbegindate1" value="<%=actualbegindate1%>">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("15285",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="hrmid" 
				browserValue='<%=hrmid %>' 
				browserSpanValue='<%=ResourceComInfo.getResourcename (""+hrmid) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("19535",user.getLanguage())%></wea:item>
		<wea:item>
			<select name="taskstatus">
				<option value=""><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
				<option value="0" <%="0".equals(taskstatus)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("225",user.getLanguage())%></option>
				<option value="1" <%="1".equals(taskstatus)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%></option>
				<option value="2" <%="2".equals(taskstatus)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("103",user.getLanguage())%></option>
				<option value="3" <%="3".equals(taskstatus)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%></option>
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("1353",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="prjname" id="prjname" value='<%=prjname %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("16573",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" 
				browserValue='<%=manager %>' 
				browserSpanValue='<%=ResourceComInfo.getResourcename (""+manager) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("83797",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="managerdept" 
				browserValue='<%=managerdept %>' 
				browserSpanValue='<%=DepartmentComInfo.getDepartmentname(""+managerdept ) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=4"  />
		</wea:item>
	</wea:group>
	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
    	</wea:item>
    </wea:group>
    
</wea:layout>
</div>

</form>

<%

String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "prj_taskapprovelist");//操作项类型
operatorInfo.put("operator_num", 9);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);

String userid=""+user.getUID();
String sqlWhere = " where t1.prjid=t2.id and t1.isdelete =0 and t1.status  <>"+ProjectTask.APPROVED +" ";
if("2".equals( PrjSettingsComInfo.getTsk_approval_type())){
	if("oracle".equalsIgnoreCase(RecordSetV.getDBType())){
		sqlWhere+=" and ( exists(select 1 from Prj_TaskProcess t3 where t3.id=t1.parentid and ','||t3.hrmid||',' like '%,"+user.getUID()+",%' ) or ( t2.manager='"+userid+"' and t1.level_n=1) ) ";
	}else{
		sqlWhere+=" and ( exists(select 1 from Prj_TaskProcess t3 where t3.id=t1.parentid and ','+convert(varchar, t3.hrmid)+',' like '%,"+user.getUID()+",%' ) or ( t2.manager='"+userid+"' and t1.level_n=1) ) ";
	}
}else{
	sqlWhere+=" and t2.manager='"+userid+"' ";
}

if(!"".equals(nameQuery)){
	sqlWhere+=" and t1.subject like '%"+nameQuery+"%'";
}
if(!"".equals(nameQuery1)){
	sqlWhere+=" and t1.subject like '%"+nameQuery1+"%'";
}

String src = Util.null2String(request.getParameter("src"));
if("todo".equalsIgnoreCase(src)){
	sqlWhere+=" and t1.begindate>'"+CurrentDate+"' ";
}else if("doing".equalsIgnoreCase(src)){
	sqlWhere+=" and t1.begindate<='"+CurrentDate+"' and t1.enddate>='"+CurrentDate+"' ";
}else if("overtime".equalsIgnoreCase(src)){
	sqlWhere+=" and t1.enddate<'"+CurrentDate+"' ";
}



if(!"".equals(taskname)){
	sqlWhere+=" and t1.subject like '%"+taskname+"%' ";
}
if(!"".equals(planbegindate)){
	sqlWhere+=" and t1.begindate >='"+planbegindate+"' ";
}
if(!"".equals(planbegindate1)){
	sqlWhere+=" and t1.begindate <='"+planbegindate1+"' ";
}
if(!"".equals(planenddate)){
	sqlWhere+=" and t1.enddate >='"+planenddate+"' ";
}
if(!"".equals(planenddate1)){
	sqlWhere+=" and t1.enddate <='"+planenddate1+"' ";
}
if(!"".equals(actualbegindate)){
	sqlWhere+=" and t1.actualbegindate >='"+actualbegindate+"' ";
}
if(!"".equals(actualbegindate1)){
	sqlWhere+=" and t1.actualbegindate <='"+actualbegindate1+"' ";
}
if(!"".equals(finish)){
	sqlWhere+=" and t1.finish >='"+finish+"' ";
}
if(!"".equals(finish1)){
	sqlWhere+=" and t1.finish <='"+finish1+"' ";
}
if(!"".equals(taskstatus)){
	sqlWhere+=" and t1.status='"+taskstatus+"' ";
}
if(!"".equals(hrmid)){
	sqlWhere+=" and (t1.hrmid like '%,"+hrmid+",%' or t1.hrmid like '"+hrmid+",%' or t1.hrmid like '%,"+hrmid+"' or t1.hrmid = '"+hrmid+"') ";
}
if(!"".equals(prjname)){
	sqlWhere+=" and t2.name like '%"+prjname+"%' ";
}
if(!"".equals(manager)){
	sqlWhere+=" and t2.manager = '"+manager+"' ";
}
if(!"".equals(managerdept)){
	sqlWhere+=" and t2.department = '"+managerdept+"' ";
}



int perpage=10;                                 
String backfields = SQLUtil.filteSql(RecordSetV.getDBType(),  " t2.name,t1.hrmid,t1.id,t1.subject,t1.prjid,t1.begindate,t1.enddate,t1.actualbegindate,t1.finish,t1.status,t1.islandmark,dbo.getPrjEndDate(t1.prjid) as prjenddate ");
String fromSql  = " Prj_TaskProcess t1,Prj_ProjectInfo t2 ";
//String orderby =SQLUtil.filteSql(RecordSetV.getDBType(),  " dbo.getPrjEndDate(t1.prjid),t1.prjid,t1.id " );
String orderby =SQLUtil.filteSql(RecordSetV.getDBType(),  " prjenddate,t1.prjid,t1.taskindex " );


int totalCount=0;
String sqlV="select count(t1.id) as totalcount from "+fromSql+" "+sqlWhere;
RecordSetV.executeSql(sqlV);
if(RecordSetV.next()){
	totalCount=RecordSetV.getInt(1);
}

String tableString=""+
        "<table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"t1.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>"+                             
              "<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(1353,user.getLanguage())+"\" column=\"prjid\"  orderkey=\"name\" transmethod=\"weaver.general.TaskTransMethod.getPrjName\" />"+
              "<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(1352,user.getLanguage())+"\" column=\"id\" orderkey=\"subject\" transmethod=\"weaver.general.TaskTransMethod.getTaskName\" />"+
              "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15285,user.getLanguage())+"\" column=\"hrmid\" orderkey=\"hrmid\" transmethod='weaver.cpt.util.CommonTransUtil.getHrmNamesWithCard' />"+
              "<col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(84364,user.getLanguage())+")\" column=\"begindate\" orderkey=\"begindate\" otherpara='column:actualbegindate' transmethod='weaver.proj.util.ProjectTransUtil.getPrjTask2Date' />"+
              "<col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(84364,user.getLanguage())+")\" column=\"enddate\" orderkey=\"enddate\" otherpara='column:actualenddate' transmethod='weaver.proj.util.ProjectTransUtil.getPrjTask2Date' />"+
              "<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(847,user.getLanguage())+"\" column=\"finish\" orderkey=\"finish\" otherpara='column:enddate' showaspercent=\"true\" transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskProgressbar' />"+                             
              "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19535,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara='"+user.getLanguage()+"' transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskApproveTypeName' />"+
        "</head>"+
        "<operates width=\"5%\">"+
         "   <popedom column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.proj.util.ProjectTransUtil.getOperates'  ></popedom>"+
        "    <operate href=\"javascript:onNewCowork()\" text=\""+SystemEnv.getHtmlLabelName(18034,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
        "    <operate href=\"javascript:onNewWorkplan()\" text=\""+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
        "    <operate href=\"javascript:onEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
        "    <operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName( 91 ,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
        "    <operate href=\"javascript:onShare()\" text=\""+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+"\" target=\"_self\" index=\"4\"/>"+
        "    <operate href=\"javascript:onApprove()\" text=\""+SystemEnv.getHtmlLabelName(142,user.getLanguage())+"\" target=\"_self\" index=\"5\"/>"+
        "    <operate href=\"javascript:onReject()\" text=\""+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"\" target=\"_self\" index=\"6\"/>"+
        "    <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(618,user.getLanguage())+"\" target=\"_self\" index=\"7\"/>"+
        "    <operate href=\"javascript:onDiscuss()\" text=\""+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"\" target=\"_self\" index=\"8\"/>"+
        "</operates>"+
        "</table>"; 
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />



<script type="text/javascript">
function batchApprove(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83884",user.getLanguage())%>',function(){
		jQuery.ajax({
			url : "/proj/process/ProjectTaskApprovalOperation.jsp",
			type : "post",
			async : true,
			data : {"opt":"batchapprove","ids":typeids},
			dataType : "html",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83885",user.getLanguage())%>");
				_table.reLoad();
				
			}
		});
	});
}
function batchReject(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83886",user.getLanguage())%>',function(){
		jQuery.ajax({
			url : "/proj/process/ProjectTaskApprovalOperation.jsp",
			type : "post",
			async : true,
			data : {"opt":"batchreject","ids":typeids},
			dataType : "html",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83885",user.getLanguage())%>");
				_table.reLoad();
				
			}
		});
	});
}

function onApprove(id){
	if(id){
		var url="/proj/process/ProjectTaskApprovalOperation.jsp";
		jQuery.post(
			url,
			{"method":"approve","TaskID":id},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83885",user.getLanguage())%>",function(){
					_table.reLoad();
				});
			}
		);
	}
}
function onReject(id){
	if(id){
		var url="/proj/process/ProjectTaskApprovalOperation.jsp";
		jQuery.post(
			url,
			{"method":"refuse","TaskID":id},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83885",user.getLanguage())%>",function(){
					_table.reLoad();
				});
			}
		);
	}
}

function onNewCowork(id){
	if(id){
		var hiddenpara_span=$("#"+"hiddenpara_"+id);
		var begindate="";
		var enddate="";
		var prjid="";
		if(hiddenpara_span){
			begindate=hiddenpara_span.attr("begindate");
			enddate=hiddenpara_span.attr("enddate");
			prjid=hiddenpara_span.attr("prjid");
		}
		var url="/cowork/AddCoWork.jsp?taskrecordid="+id+"&begindate="+begindate+"&enddate="+enddate+"&projectid="+prjid+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("18034",user.getLanguage())%>";
		openDialog(url,title,1000,720);
	}
}
function onNewWorkplan(id){
	if(id){
		var hiddenpara_span=$("#"+"hiddenpara_"+id);
		var begindate="";
		var enddate="";
		var prjid="";
		if(hiddenpara_span){
			begindate=hiddenpara_span.attr("begindate");
			enddate=hiddenpara_span.attr("enddate");
			prjid=hiddenpara_span.attr("prjid");
		}
		var url="/workplan/data/WorkPlanAdd.jsp?taskrecordid="+id+"&begindate="+begindate+"&enddate="+enddate+"&projectid="+prjid+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("18481",user.getLanguage())%>";
		openDialog(url,title,1000,720);
	}
}
function onEdit(id){
	if(id){
		var hiddenpara_span=$("#"+"hiddenpara_"+id);
		var begindate="";
		var enddate="";
		var prjid="";
		if(hiddenpara_span){
			begindate=hiddenpara_span.attr("begindate");
			enddate=hiddenpara_span.attr("enddate");
			prjid=hiddenpara_span.attr("prjid");
		}
		var url="/proj/process/EditTask.jsp?taskrecordid="+id+"&ProjID="+prjid+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("15284",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}
function onDel(id){
	if(id){
		var hiddenpara_span=$("#"+"hiddenpara_"+id);
		var begindate="";
		var enddate="";
		var prjid="";
		if(hiddenpara_span){
			begindate=hiddenpara_span.attr("begindate");
			enddate=hiddenpara_span.attr("enddate");
			prjid=hiddenpara_span.attr("prjid");
		}
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/proj/process/TaskOperation.jsp",
				{"method":"del","taskrecordid":id,"ProjID":prjid},
				function(data){
					Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
					});
				}
			);
			
		});
	}
}
function onShare(id){
	if(id){
		var url="/proj/task/PrjTaskAddShare.jsp?isdialog=1&taskrecordid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83799",user.getLanguage())%>";
		openDialog(url,title,500,260);
	}
}
function onDiscuss(id){
	if(id){
		var url="/proj/process/ViewPrjDiscuss.jsp?types=PT&isdialog=1&sortid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83800",user.getLanguage())%>";
		openDialog(url,title,800,550,true,true);
	}
}
function onLog(id){
	if(id){
		var url="/proj/task/PrjTaskModifyView.jsp?isdialog=1&taskrecordid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83905",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}


$(function(){
	var src='<%=src %>';
	var totalCount='<%=totalCount %>';
	if('todo'==src){
		parent.$(".e8_box").Tabs({method:"set",todoNum_span:totalCount});
	}else if('doing'==src){
		parent.$(".e8_box").Tabs({method:"set",doingNum_span:totalCount});
	}else if('overtime'==src){
		parent.$(".e8_box").Tabs({method:"set",overtimeNum_span:totalCount});
	}else{
		parent.$(".e8_box").Tabs({method:"set",allNum_span:totalCount});
	}
});

function initProgressbar(){
	//console.log("initProgressbar");	
	$(".progressbar").each(function(i){
		var rate=parseInt($(this).attr("rate"));
		var status=parseInt($(this).attr("status"));
		$(this).find("div.progress-label").text(rate+"%");
		$(this).progressbar({value:rate});
		if(status===1){//overtime task
			$(this).find( ".ui-progressbar-value" ).css({'background':'#F9A9AA'});
		}
		
	});
}
//列表数据刷新后触发
function afterDoWhenLoaded(){
	//initProgressbar();
}

function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});

setInterval("updateHandleRequest(38)",2000);//审批任务的数值

function updateHandleRequest(levelid){
	if(levelid){
		try{
			jQuery.ajax({
		            url: "/workflow/request/menuCount.jsp?levelid="+levelid+"&userid=<%=user.getUID()%>&usertype=<%=user.getLogintype().equals("2")?1:0%>&lftmn" + new Date().getTime() + "=",
		            dataType: "json", 
		            contentType : "charset=UTF-8", 
		            error:function(ajaxrequest){
						
					}, 
		            success:function(content){
		            	try{
							var json = content; 
							for(var key in json){
								jQuery("#"+key,parent.parent.document).html("<span style='padding-left:5px;padding-right:5px;'>"+json[key]+"</span>");
							}
						}catch(e){
							if(window.console)console.log(e);
						}
					}
			});
			
		}catch(e){}
	}
	
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>

</HTML>
