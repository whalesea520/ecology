<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@page import="org.json.JSONObject"%>
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
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
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
String src = Util.null2String(request.getParameter("src"));//不同的标签页
String paraid = Util.null2String(request.getParameter("paraid"));//项目类型
String nameQuery = Util.null2String(request.getParameter("flowTitle"));
String worktype = Util.null2String(request.getParameter("WorkType"));
String procode = Util.null2String(request.getParameter("procode"));//项目编码
String planbegindate = Util.null2String(request.getParameter("planbegindate"));
String planbegindate1 = Util.null2String(request.getParameter("planbegindate1"));
String planenddate = Util.null2String(request.getParameter("planenddate"));
String planenddate1 = Util.null2String(request.getParameter("planenddate1"));
String actualbegindate = Util.null2String(request.getParameter("actualbegindate"));
String actualbegindate1 = Util.null2String(request.getParameter("actualbegindate1"));
String finish = Util.null2String(request.getParameter("finish"));
String finish1 = Util.null2String(request.getParameter("finish1"));
String prjstatus = Util.null2String(request.getParameter("prjstatus"));
String prjname = Util.null2String(request.getParameter("prjname"));
String manager = Util.null2String(request.getParameter("manager"));
String member = Util.null2String(request.getParameter("member"));//项目成员
String managerdept = Util.null2String(request.getParameter("managerdept"));
String managersubcom = Util.null2String(request.getParameter("managersubcom"));
String parentprj = Util.null2String(request.getParameter("parentprj"));
String parentprjtype=ProjectInfoComInfo.getProjectInfoprjtype(parentprj);
String crm = Util.null2String(request.getParameter("crm"));

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(16411,user.getLanguage());
    String needfav ="1";
    String needhelp ="";

    String pageId=Util.null2String(PropUtil.getPageId("prj_viewprojectsub"));
    


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
    double ptype=Util.getDoubleValue( CommonShareManager.getPrjPermissionType(""+parentprj, user),0 );
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
    
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
boolean addSubPrjOk= canedit &&!"4".equals( ProjectInfoComInfo.getProjectInfostatus(parentprj))&&!"6".equals( ProjectInfoComInfo.getProjectInfostatus(parentprj));
if(addSubPrjOk){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("83819",user.getLanguage())+",javascript:onNewSub("+parentprj+","+parentprjtype+");"+",_self}";
	RCMenuHeight += RCMenuHeightStep;
}


%>



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="weaver" id="weaver" method="post"  action="">
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<input type="hidden" name="paraid" value="<%=paraid %>" >
<input type="hidden" name="parentprj" value="<%=parentprj %>" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<%
if(addSubPrjOk){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("83819",user.getLanguage())%>" class="e8_btn_top"  onclick="onNewSub('<%=parentprj %>','<%=parentprjtype %>')"/>
	<%
}
%>		
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:'';"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1353",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="prjname" id="prjname" value='<%=prjname %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("17852",user.getLanguage())%></wea:item>
		<wea:item><input class="InputStyle" name="procode" id="procode" value='<%=procode %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
		<wea:item>
			<Select class="InputStyle" name="WorkType">
				<option value=""></option>
				<%while(WorkTypeComInfo.next()){%>
					<option value="<%=WorkTypeComInfo.getWorkTypeid()%>"
					<%if(worktype.equals(WorkTypeComInfo.getWorkTypeid())){%> selected="true"<%}%>
					>
					<%=WorkTypeComInfo.getWorkTypename()%></option>
				<%}%>
			</Select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18628",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="member" 
				browserValue='<%=member %>' 
				browserSpanValue='<%=ResourceComInfo.getResourcename (""+member) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("847",user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle style="width:60px!important;" maxlength=2 size=5 value="<%=finish%>" name="finish" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
			-<input class=InputStyle style="width:60px!important;" maxlength=2 size=5 value="<%=finish1%>" name="finish1" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
			%
		</wea:item>
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
		<wea:item><%=SystemEnv.getHtmlLabelNames("636",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="parentprj" 
				browserValue='<%=parentprj %>' 
				browserSpanValue='<%=ProjectInfoComInfo.getProjectInfoname  (""+parentprj) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
				hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='0'
				completeUrl="/data.jsp?type=8"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("783",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="crm" 
				browserValue='<%=crm %>' 
				browserSpanValue='<%=CustomerInfoComInfo.getCustomerInfoname  (""+crm) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
				hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=7"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
		<wea:item>
			<Select class="InputStyle" name="prjstatus">
				<option value=""><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
				<%while(ProjectStatusComInfo.next()){%>
					<option value="<%=ProjectStatusComInfo.getProjectStatusid ()%>"
					<%if(prjstatus.equals(ProjectStatusComInfo.getProjectStatusid())){%> selected="true"<%}%>
					>
					<%=ProjectStatusComInfo.getProjectStatusdesc ()%></option>
				<%}%>
			</Select>
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
operatorInfo.put("operatortype", "prj_prjsublist");//操作项类型
operatorInfo.put("operator_num", 8);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);

String userid=""+user.getUID();
String sqlWhere = " where 1=1 ";
if(!"".equals(paraid)){
	sqlWhere+=" and t1.prjtype = '"+paraid+"' ";
}
String sqlWhere2=sqlWhere;

if("all".equalsIgnoreCase(src)){
	//sqlWhere+=" and t1.status='5' ";
}else if("frozen".equalsIgnoreCase(src)){
	sqlWhere+=" and t1.status='4' ";
}else if("complete".equalsIgnoreCase(src)){
	sqlWhere+=" and t1.status='3' ";
}else{
//	sqlWhere+=" and t1.status in(0,1,2,5,6,7) ";//未完成
}

if(!"".equals(prjstatus)){
	sqlWhere+=" and t1.status='"+prjstatus+"' ";
}

//sqlWhere+=" and dbo.getPrjFinish(t1.id)<100 and ( t1.manager='"+userid+"' or ','+t1.members+',' like '%,"+userid+",%' ) ";

if(!"".equals(planbegindate)){
	sqlWhere+=" and dbo.getPrjBeginDate(t1.id) >='"+planbegindate+"' ";
}
if(!"".equals(planbegindate1)){
	sqlWhere+=" and dbo.getPrjBeginDate(t1.id) <='"+planbegindate1+"' ";
}
if(!"".equals(planenddate)){
	sqlWhere+=" and dbo.getPrjEndDate(t1.id) >='"+planenddate+"' ";
}
if(!"".equals(planenddate1)){
	sqlWhere+=" and dbo.getPrjEndDate(t1.id) <='"+planenddate1+"' ";
}
if(!"".equals(finish)){
	sqlWhere+=" and dbo.getPrjFinish(t1.id) >='"+finish+"' ";
}
if(!"".equals(finish1)){
	sqlWhere+=" and dbo.getPrjFinish(t1.id) <='"+finish1+"' ";
}
if(!"".equals(member)){
	sqlWhere+=" and  ','+t1.members+',' like '%,"+member+",%' ";
}

sqlWhere=SQLUtil.filteSql(RecordSetV.getDBType(), sqlWhere);



if(!"".equals(prjname)){
	sqlWhere+=" and t1.name like '%"+prjname+"%' ";
	
}else if(!"".equals(nameQuery)){
	sqlWhere+=" and t1.name like '%"+nameQuery+"%' ";
}

if(!"".equals(procode)){
	sqlWhere+=" and t1.procode like '%"+procode+"%' ";
}
if(!"".equals(manager)){
	sqlWhere+=" and t1.manager = '"+manager+"' ";
}
if(!"".equals(managerdept)){
	sqlWhere+=" and t1.department = '"+managerdept+"' ";
}
if(!"".equals(managersubcom)){
	sqlWhere+=" and t1.subcompanyid1 = '"+managersubcom+"' ";
}
if(!"".equals(parentprj)){
	sqlWhere+=" and t1.parentid = '"+parentprj+"' ";
}
if(!"".equals(crm)){
	sqlWhere+=" and t1.description = '"+crm+"' ";
}
if(!"".equals(worktype)){
	sqlWhere+=" and t1.worktype = '"+worktype+"' ";
}



int perpage=10;                                 
String backfields = " t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,t1.members ";
backfields+=SQLUtil.filteSql(RecordSetV.getDBType(), ",dbo.getPrjBeginDate(t1.id) as begindate,dbo.getPrjEndDate(t1.id) as enddate,dbo.getPrjFinish(t1.id) as finish ");
String fromSql  = " Prj_ProjectInfo t1 ";
String orderby =" enddate,t1.id ";

String tableString=""+
        "<table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"none\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"t1.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>"+                             
              "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1353,user.getLanguage())+"\" column=\"id\" orderkey=\"name\" otherpara=\"column:name+column:status+"+user.getLanguage()+"+column:begindate+column:enddate\"  transmethod='weaver.proj.util.ProjectTransUtil.getPrjName' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17852,user.getLanguage())+"\" column=\"procode\"  orderkey=\"procode\"/>"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(22170,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\"/>"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16573,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename'/>";
      	tableString+=""+
              "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(847,user.getLanguage())+"\" column=\"finish\" orderkey=\"finish\" otherpara='column:enddate' showaspercent=\"true\" transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskProgressbar' />";                           
        tableString+=""+      
        "</head>"+
        "<operates width=\"5%\">"+
         "   <popedom column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.proj.util.ProjectTransUtil.getOperates'  ></popedom>"+
        "    <operate href=\"javascript:onNormal()\" text=\""+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
        "    <operate href=\"javascript:onOver()\" text=\""+SystemEnv.getHtmlLabelName( 2244 ,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
        "    <operate href=\"javascript:onFinish()\" text=\""+SystemEnv.getHtmlLabelName(555,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
        "    <operate href=\"javascript:onFrozen()\" text=\""+SystemEnv.getHtmlLabelName( 1232 ,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
        "    <operate href=\"javascript:onEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"4\"/>"+
        "    <operate href=\"javascript:onListTask()\" text=\""+SystemEnv.getHtmlLabelName(18505,user.getLanguage())+"\" target=\"_self\" index=\"5\"/>"+
        "    <operate href=\"javascript:onShare()\" text=\""+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+"\" target=\"_self\" index=\"6\"/>"+
        "    <operate href=\"javascript:onDiscuss()\" text=\""+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"\" target=\"_self\" index=\"7\"/>"+
        "</operates>"+
        "</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />



<script type="text/javascript">
function onNormal(id){
	if(id){
		var url="/proj/plan/PlanOperation.jsp";
		jQuery.post(
			url,
			{"method":"normal","ProjID":id},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16746",user.getLanguage())%>",function(){
					_table.reLoad();
				});
			}
		);
	}
}
function onOver(id){
	if(id){
		var url="/proj/plan/PlanOperation.jsp";
		jQuery.post(
			url,
			{"method":"delay","ProjID":id},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16746",user.getLanguage())%>",function(){
					_table.reLoad();
				});
			}
		);
	}
}
function onFinish(id){
	if(id){
		var url="/proj/plan/PlanOperation.jsp";
		jQuery.post(
			url,
			{"method":"complete","ProjID":id},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16746",user.getLanguage())%>",function(){
					_table.reLoad();
				});
			}
		);
	}
}
function onFrozen(id){
	if(id){
		var url="/proj/plan/PlanOperation.jsp";
		jQuery.post(
			url,
			{"method":"freeze","ProjID":id},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16746",user.getLanguage())%>",function(){
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
		var url="/proj/data/EditProject.jsp?ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("83808",user.getLanguage())%>";
		openDialog(url,title,1000,720,true);
	}
}
function onNewSub(id,prjtypeid){
	if(id){
		var url="/proj/data/AddProject.jsp?projTypeId="+prjtypeid+"&parentid="+id+"&isdialog=1&from=viewprojectsub";
		var title="<%=SystemEnv.getHtmlLabelNames("83819",user.getLanguage())%>";
		openDialog(url,title,1000,720,false,true);
	}
}
function onListTask(id){
	if(id){
		var url="/proj/process/ViewProcess.jsp?log=n&ProjID="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("18505",user.getLanguage())%>";
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
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
					});
				}
			);
			
		});
	}
}
function onShare(id){
	if(id){
		//var url="/proj/data/PrjShareAdd.jsp?isdialog=1&taskrecordid="+id;
		var url="/proj/data/PrjShareDsp.jsp?isdialog=1&ProjID="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83809",user.getLanguage())%>";
		openDialog(url,title,680,500,false,true);
	}
}
function onDiscuss(id){
	if(id){
		var url="/proj/process/ViewPrjDiscuss.jsp?types=PP&isdialog=1&sortid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83810",user.getLanguage())%>";
		openDialog(url,title,800,550,true,true);
	}
}

function getTabNum(type,src,sqlwhere,sqlwhere2){
	jQuery.ajax({
		url : "/proj/data/PrjGetTabNumAjax.jsp",
		type : "post",
		async : true,
		processData : true,
		data : {type:type,src:src,sqlwhere:sqlwhere,sqlwhere2:sqlwhere2},
		dataType : "json",
		success: function do4Success(data){
			if(data){
				parent.$(".e8_box").Tabs({method:"set",allNum_span:data.totalCount1});
				parent.$(".e8_box").Tabs({method:"set",todoNum_span:data.totalCount2});
				parent.$(".e8_box").Tabs({method:"set",frozenNum_span:data.totalCount3});
				parent.$(".e8_box").Tabs({method:"set",completeNum_span:data.totalCount4});
			}
		}
	});
}


//列表数据刷新后触发
function afterDoWhenLoaded(){
	//initProgressbar();
}



function initProgressbar(){
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
function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>

</HTML>
