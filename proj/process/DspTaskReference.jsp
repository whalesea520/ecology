<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.SQLUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetReqWF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetReqDoc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="docrs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="docrs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String src = Util.null2String(request.getParameter("src"));
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));

String ProjID = Util.null2String(request.getParameter("ProjID"));
String parenthrmids = Util.null2String(request.getParameter("parenthrmids"));
String status_prj = Util.null2String(request.getParameter("status_prj"));
boolean ismanager=(""+user.getUID()).equals( ProjectInfoComInfo.getProjectInfomanager(ProjID));
String sql="";
String logintype = user.getLogintype();
String CurrentUser = ""+user.getUID();



/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

//4E8 项目任务权限等级(默认共享的值设置:成员可见0.5,项目经理2.5,项目经理上级2.1,项目管理员2.2;项目手动共享值设置:查看1,编辑2;任务负责人:2.8;项目任务手动共享值设置:查看0.8,编辑2.3;)
double ptype=Util.getDoubleValue( CommonShareManager.getPrjTskPermissionType("" + taskrecordid, user),0 );
if(ptype>=2.0){
    canedit=true;
    canview=true;
}else if(ptype>=0.5){
    canview=true;
}
if(ptype==2.5||ptype==2){
	ismanager=true;
}

boolean isResponser=false;
if( parenthrmids.indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
  isResponser=true;
}

boolean canRef=(ismanager&&!status_prj.equals("4")) ;
boolean canRelated=(!status_prj.equals("4") && (canedit || isResponser)) ;
/*权限－end*/
if(!canview&&!isResponser){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
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
</HEAD>
<%

String topage="";
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY scroll=no>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canRelated){
	if("req".equalsIgnoreCase(src)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+",javascript:addNewReq(),_top} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else if("doc".equalsIgnoreCase(src)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1986,user.getLanguage())+",javascript:addNewDoc(),_top} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addRef(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:onBatchdel(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<%
if(canRelated){
	if("req".equalsIgnoreCase(src)){
		%>
<%
topage=URLEncoder.encode( "/proj/process/RequestOperation.jsp?method=add&ProjID="+ProjID+"&type=2&taskid="+taskrecordid);
//topage="/proj/process/RequestOperation.jsp?method=add&ProjID="+ProjID+"&type=2&taskid="+taskrecordid;
%>
<form name=workflow1  method=get action="/workflow/request/RequestType.jsp" target="_blank;">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	<input type=hidden name=taskrecordid value='<%=taskrecordid %>'>
</form>		
		<input type="button" value="<%=SystemEnv.getHtmlLabelName( 16392 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="addNewReq()"/>
		<%
		
	}else if("doc".equalsIgnoreCase(src)){
		%>
<%
//topage=URLEncoder.encode( "/proj/process/DocOperation.jsp?method=add&ProjID="+ProjID+"&type=2&taskid="+taskrecordid);
topage= "/proj/process/DocOperation.jsp?method=add&ProjID="+ProjID+"&type=2&taskid="+taskrecordid;
%>
<form name=doc1  method=get action="/docs/docs/DocList.jsp" target="_blank;">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	<input type=hidden name=taskrecordid value='<%=taskrecordid %>'>
</form>		
		<input type="button" value="<%=SystemEnv.getHtmlLabelName( 1986 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="addNewDoc()"/>
		<%
	}else{
		%>
		<input type="button" value="<%=SystemEnv.getHtmlLabelName( 611 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="addRef()"/>
		<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top"  onclick="onBatchdel()"/>
		<%
	}
}

%>		
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>


<%
String topage1= URLEncoder.encode("/proj/plan/ViewTask.jsp?ProjID="+ProjID+"&taskrecordid="+taskrecordid+"&src="+src);
%>


<%
int usertype = 0;
if(logintype.equals("2")) usertype= 1;


int perpage=10;
String backfields ="";
String sqlwhere="";
String orderby="";
String fromSql  ="";
String tableString="";

if("req".equalsIgnoreCase (src)){
	%>




<!--RequiredWF Begin-->
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83870",user.getLanguage())%>' attributes="" >
<%
if(canRef ){
	%>
		<wea:item attributes="{'colspan':'full'}" type="groupHead">
			<span style='float:right!important;'>
				<input type="button" class="addbtn" style="margin-top:5px!important;" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="onShowWorkflow();"/>
			</span>
		</wea:item>
	<%
}
%>
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
			


<%

backfields =" a.id, a.workflowname, b.isNecessary, b.isTempletTask,c.requiredWFCount,b.taskId ";
sqlwhere=" WHERE b.taskId="+Integer.parseInt(taskrecordid)+" AND a.id=b.workflowid ";
orderby=" a.id ";
fromSql  =" workflow_base a ";
fromSql+= " left outer join ( select t1.workflowid, count(distinct t1.requestid) as requiredWFCount from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 "
    +" where t1.requestid = t2.requestid  and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" group by t1.workflowid ) c on c.workflowid=a.id ";
fromSql+=" ,Prj_task_needwf b ";

sql="select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby;



%>

<%
RecordSet.executeSql(sql);
%>


<div class="table" id="refDiv">
<table style="table-layout: fixed; " cellspacing="0" class="ListStyle" id="refTb">
    <colgroup>
        <col style="width: 30%; ">
        <col style="width: 15%; ">
        
        <col style="width: 2%; ">
    </colgroup>
    <thead>
    <tr class="HeaderForXtalbe">
        <th style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: none; "
            align="left"></th>
        <th style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; width: 30%; "
            id="workflowname" title="" align="left"><%=SystemEnv.getHtmlLabelNames("16579",user.getLanguage())%>&nbsp;</th>
        <th style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; width: 15%; "
            id="isNecessary" title="" align="left"><%=SystemEnv.getHtmlLabelNames("17906",user.getLanguage())%>&nbsp;</th>
        <th class="Header" style="width: 2%; " title=""></th>
    </tr>
    </thead>
    <tbody>
<%
int reqWFId = 0;
String reqWFName="";
String reqWFIsNecessary="";
String reqWFIsTemplet = "";
int requiredWFCount = 0;
String taskId = "";
while(RecordSet.next()){
	reqWFId = RecordSet.getInt("id");
	reqWFName = RecordSet.getString("workflowname");
	reqWFIsNecessary = RecordSet.getString("isNecessary");
	requiredWFCount =Util.getIntValue( RecordSet.getString("requiredWFCount"),0);
	taskId = RecordSet.getString("taskId");


%>    
    <tr style="vertical-align: middle; " class="">
        <td style="height: 30px; display: none; width: 4%; ">&nbsp;<input type="checkbox" style="display:none"
                                                                          id="value=undefined"></td>
        <td  style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; "
            align="left" title="">
           	<%=ProjectTransUtil.getPrjTaskNeedWf(""+reqWFId,reqWFName+"+"+reqWFIsNecessary+"+"+requiredWFCount+"+"+taskId+"+"+ProjID) %>
        </td>
        <td style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; "
            align="left" title="">
            <input type="checkbox" wfcnt='<%=requiredWFCount %>' wfid="<%=reqWFId %>" name="needwfchk_<%=reqWFId %>" value="1" <%=ismanager?"":"disabled" %> <%="1".equals(reqWFIsNecessary)?"checked":"" %> onclick="switchNecessary(this)" >
        </td>
        
        <td class="hoverOptCell"  refid='<%=reqWFId %>' onmouseover="showHover(this)" onmouseout="hideHover(this)" style="text-align: center; vertical-align: middle; line-height: 30px; ">
<%
if(ismanager){
	%>
            <div class="e8operate">&nbsp;</div>
		    <div name='refoptdiv' class="hoverDiv" style="height: 29px;width:60px; line-height: 30px; margin-left: -25px;margin-top: -15px; margin-right: 0px; display: none;">
			    &nbsp;&nbsp;&nbsp;<a href="#" onclick="javascript:onDel(<%=reqWFId %>,this);return false;" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>"><span class="operHoverSpan operHover_hand">&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>&nbsp;</span></a>&nbsp;&nbsp;&nbsp;
			  </div>
	<%
}
%>            
        </td>
	
    </tr>
    <tr class="Spacing" style="height:1px!important;"><td colspan="3" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>
<%
}
%>    
    </tbody>
</table>
</div>


			
			
			
		</wea:item>
	</wea:group>
</wea:layout>

<!--RequiredWF End-->
<!--RelatedWF Start-->
<%
backfields =" t1.requestid, t1.createdate, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t1.status,t3.id ";
sqlwhere=" where t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" ";
orderby=" t3.id,t1.requestid ";
fromSql  =" workflow_requestbase t1, Prj_Request t3 ";
sql="select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby;
//out.println("sql:\n"+sql);

tableString=""+
        "<table instanceid=\"CptCapitalAssortmentTable\"   tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlprimarykey=\"t3.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"false\" />"+
        "<head>"+                             
              "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelNames("229",user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" href='/proj/RequestView.jsp'  linkkey='requestid' linkvaluecolumn='requestid' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("63",user.getLanguage())+"\" column=\"workflowid\"  orderkey=\"workflowid\" transmethod='weaver.workflow.workflow.WorkflowComInfo.getWorkflowname' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("882",user.getLanguage())+"\" column=\"creater\"  orderkey=\"creater\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("722",user.getLanguage())+"\" column=\"createdate\"  orderkey=\"createdate\"  />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("1335",user.getLanguage())+"\" column=\"status\"  orderkey=\"status\"  />"+
        "</head>"+
        "<operates width=\"5%\">";
if(canRelated){
	tableString+=
        "    <operate href=\"javascript:onDelRelated()\" text=\""+SystemEnv.getHtmlLabelName( 91 ,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>";
}
tableString+=""+
        "</operates>"+
        "</table>";

%>




<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1044",user.getLanguage())%>' attributes="">
	
		<wea:item attributes="{'colspan':'full'}" type="groupHead">
<%

if(canRelated ){
	%>
			<span style='float:right!important;'>
				<input type="button" class="addbtn" style="margin-top:5px!important;" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="onShowRequest();"/>
				<input type="button" class="delbtn" style="margin-top:5px!important;" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="onBatchdel();"/>
			</span>
	<%
}
%>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
<!--RelatedWF End-->

	
	<%
	
	
}else if("doc".equalsIgnoreCase (src)){
	%>

<!--RequiredDoc Begin-->
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83873",user.getLanguage())%>' attributes="" >
<%
if(canRef ){
	%>
		<wea:item attributes="{'colspan':'full'}" type="groupHead">
			<span style='float:right!important;'>
				<input type="button" class="addbtn" style="margin-top:5px!important;" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="onSelectCategory();"/>
			</span>
		</wea:item>
	<%
}
%>
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
			


<%

backfields =" docMainCategory,docSubCategory,docSecCategory,isNecessary,isTempletTask ";
sqlwhere=" WHERE taskId="+Integer.parseInt(taskrecordid)+"  ";
orderby=" id ";
fromSql  =" Prj_task_needdoc ";

sql="select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby;



%>

<%
RecordSet.executeSql(sql);
%>


<div class="table" id="refDiv">
<table style="table-layout: fixed; " cellspacing="0" class="ListStyle" id="refTb">
    <colgroup>
        <col style="width: 30%; ">
        <col style="width: 15%; ">
        
        <col style="width: 2%; ">
    </colgroup>
    <thead>
    <tr class="HeaderForXtalbe">
        <th style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: none; "
            align="left"></th>
        <th style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; width: 30%; "
            id="workflowname" title="" align="left"><%=SystemEnv.getHtmlLabelNames("16398",user.getLanguage())%>&nbsp;</th>
        <th style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; width: 15%; "
            id="isNecessary" title="" align="left"><%=SystemEnv.getHtmlLabelNames("17906",user.getLanguage())%>&nbsp;</th>
        <th class="Header" style="width: 2%; " title=""></th>
    </tr>
    </thead>
    <tbody>
<%
String reqDocMainCategory="";
String reqDocSubCategory="";
String reqDocSecCategory = "";
String reqIsNecessary = "";
String reqIsTempletTask = "";
int requiredDocCount = 0;
while(RecordSet.next()){
	reqDocMainCategory = RecordSet.getString("docMainCategory");
	reqDocSubCategory = RecordSet.getString("docSubCategory");
	reqDocSecCategory = RecordSet.getString("docSecCategory");
	reqIsNecessary = RecordSet.getString("isNecessary");
	reqIsTempletTask = RecordSet.getString("isTempletTask");


%>    
    <tr style="vertical-align: middle; " class="">
        <td style="height: 30px; display: none; width: 4%; ">&nbsp;<input type="checkbox" style="display:none"
                                                                          id="value=undefined"></td>
        <td  style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; "
            align="left" title="">
           	
           	<a href="javascript:openFullWindowHaveBar('/docs/docs/DocAdd.jsp?prjid=<%=ProjID%>&mainid=<%=reqDocMainCategory%>&subid=<%=reqDocSubCategory%>&secid=<%=reqDocSecCategory%>&topage=<%=URLEncoder.encode(URLEncoder.encode(topage))%>&prjid=<%=ProjID %>&taskrecordid=<%=taskrecordid %>')">
           	<%=Util.toScreen(ProjectTransUtil.getDocCategoryFullname(reqDocSecCategory) , user.getLanguage()) %>
           	<%
			sql="SELECT COUNT(*) AS requiredDocCount FROM DocDetail  t1, Prj_Doc t3 ";
			sqlwhere=" where t1.id = t3.docid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" AND t3.secid="+Util.getIntValue(reqDocSecCategory);	
			sql=sql+sqlwhere;
			RecordSetReqDoc.executeSql(sql);
			if(RecordSetReqDoc.next())
				requiredDocCount = RecordSetReqDoc.getInt("requiredDocCount");
			%></a> 
			(<%=requiredDocCount%>)
			<%if(requiredDocCount==0 && reqIsNecessary.equals("1"))	out.println("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");%>
           	
        </td>
        <td style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; "
            align="left" title="">
            <input type="checkbox" wfcnt='<%=requiredDocCount %>' wfid="<%=reqDocSecCategory %>" name="needdocchk_<%=reqDocSecCategory %>" value="1" <%=ismanager?"":"disabled" %> <%="1".equals(reqIsNecessary)?"checked":"" %> onclick="switchNecessary(this)" >
        </td>
        
        <td class="hoverOptCell"  refid='<%=reqDocSecCategory %>' onmouseover="showHover(this)" onmouseout="hideHover(this)" style="text-align: center; vertical-align: middle; line-height: 30px; ">
<%
if(ismanager){
	%>
            <div class="e8operate">&nbsp;</div>
		    <div name='refoptdiv' class="hoverDiv" style="height: 29px; line-height: 30px;width:60px; margin-left: -25px;margin-top: -15px; margin-right: 0px; display: none;">
			    &nbsp;&nbsp;&nbsp;<a href="#" onclick="javascript:onDel(<%=reqDocSecCategory %>,this);return false;" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>"><span class="operHoverSpan operHover_hand">&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>&nbsp;</span></a>&nbsp;&nbsp;&nbsp;
			  </div>
	<%
}
%>            
        </td>
	
    </tr>
    <tr class="Spacing" style="height:1px!important;"><td colspan="3" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>
<%
}
%>    
    </tbody>
</table>
</div>


			
			
			
		</wea:item>
	</wea:group>
</wea:layout>

<!--RequiredDoc End-->
<!--RelatedDoc Start-->
<%
//参考文档
String backfields_ref =" 'ref' as type_,t1.seccategory,t1.id as subjectid, t1.docsubject, t1.ownerid, t1.usertype, t1.doccreatedate, t1.doccreatetime,t3.id as realid ";
String sqlwhere_ref=" WHERE t1.id = t3.docid and t3.taskId="+Integer.parseInt(taskrecordid)+"  ";
String fromSql_ref  =" DocDetail t1, Prj_task_referdoc t3 ";
String sql_ref="select "+backfields_ref+" from "+fromSql_ref+" "+sqlwhere_ref;
//out.println("ref_sql:\n"+sql_ref);

//相关文档
String backfields_rlt =" 'rlt' as type_,t1.seccategory, t1.id as subjectid, t1.docsubject, t1.ownerid, t1.usertype, t1.doccreatedate, t1.doccreatetime,t3.id as realid ";
String sqlwhere_rlt=" WHERE t1.docstatus in ('0','1','2','5') and t1.id = t3.docid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" " ;
String fromSql_rlt  =" DocDetail  t1, Prj_Doc t3 ";
String sql_rlt="select "+backfields_rlt+" from "+fromSql_rlt+" "+sqlwhere_rlt;
//out.println("rlt_sql:\n"+sql_rlt);
backfields =" tt1.type_,tt1.seccategory, tt1.subjectid, tt1.docsubject, tt1.ownerid, tt1.usertype, tt1.doccreatedate, tt1.doccreatetime,tt1.realid ";
sqlwhere=" WHERE 1=1 ";
orderby=" tt1.subjectid  ";
fromSql="( ("+sql_ref+") union ("+sql_rlt+") ) tt1 ";
sql="select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby;
//out.println("sql:\n"+sql);


tableString=""+
        "<table instanceid=\"CptCapitalAssortmentTable\"   tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlprimarykey=\"tt1.realid\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>"+                             
              "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelNames("229",user.getLanguage())+"\" column=\"docsubject\" orderkey=\"docsubject\" href='/proj/DocView.jsp'  linkkey='id' linkvaluecolumn='subjectid' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("92",user.getLanguage())+"\" column=\"seccategory\"  orderkey=\"seccategory\"  transmethod='weaver.proj.util.ProjectTransUtil.getDocCategoryFullname' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("1340",user.getLanguage())+"\" column=\"ownerid\"  orderkey=\"ownerid\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("722",user.getLanguage())+"\" column=\"doccreatedate\"  orderkey=\"doccreatedate\"  />"+
        "</head>"+
        "<operates width=\"5%\">";
if(canRelated){
	tableString+=
        "    <operate href=\"javascript:onDelRelated()\" otherpara='column:type_+column:realid' text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>";
}
tableString+=""+
        "</operates>"+
        "</table>";

%>




<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("857",user.getLanguage())%>' attributes="">
	
		<wea:item attributes="{'colspan':'full'}" type="groupHead">
<%

if(canRelated ){
	%>
			<span style='float:right!important;'>
				<input type="button" class="addbtn" style="margin-top:5px!important;" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="onShowDoc();"/>
				<input type="button" class="delbtn" style="margin-top:5px!important;" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="onBatchdel();"/>
			</span>
	<%
}
%>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
<!--RelatedDoc End-->

	
	<%
	
	
}else if("crm".equalsIgnoreCase (src)){
	%>


<!--RelatedCrm Start-->
<%



backfields =" t1.id,t1.prjid,t1.taskid,t1.customerid,t1.reasondesc,t2.manager ";
sqlwhere=" WHERE t1.prjid= "+ProjID+" and t1.taskid = "+taskrecordid+" and t1.customerid=t2.id " ;
orderby=" t1.id  ";
fromSql  =" Prj_Customer t1,CRM_CustomerInfo t2 ";
sql="select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby;
//out.println("sql:\n"+sql);

tableString=""+
        "<table instanceid=\"CptCapitalAssortmentTable\"   tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlprimarykey=\"t1.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>"+                             
              "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelNames("1268",user.getLanguage())+"\" column=\"customerid\" orderkey=\"customerid\" href='/crm/data/ViewCustomer.jsp'  linkkey='CustomerID' linkvaluecolumn='customerid' transmethod='weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("433",user.getLanguage())+"\" column=\"reasondesc\"  orderkey=\"reasondesc\"  />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("1278",user.getLanguage())+"\" column=\"manager\"  orderkey=\"manager\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' />"+
        "</head>"+
        "<operates width=\"5%\">";
if(canRelated){
	tableString+=
        "    <operate href=\"javascript:onEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
        "    <operate href=\"javascript:onDelRelated()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>";
}
tableString+=""+
        "</operates>"+
        "</table>";

%>




<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("783",user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
	
		<wea:item attributes="{'isTableList':'true'}">
			<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
<!--RelatedCrm End-->

	
	<%
	
	
}else if("cpt".equalsIgnoreCase (src)){
	%>


<!--RelatedCpt Start-->
<%


backfields =" t2.id,t1.id as cptid,t1.mark,t1.name,t1.resourceid,t1.departmentid,t1.stateid,t1.capitalspec ";
sqlwhere=" t1.id = t2.requestid  and t2.prjid="+ProjID+" and t2.taskid = "+taskrecordid+" ";
orderby=" t1.id  ";
fromSql  =" CptCapital t1 ,Prj_Cpt t2 ";
sql="select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby;
//out.println("sql:\n"+sql);

tableString=""+
        "<table instanceid=\"CptCapitalAssortmentTable\"   tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlprimarykey=\"t2.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>"+                             
              "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelNames("1445",user.getLanguage())+"\" column=\"name\" orderkey=\"name\" href='/cpt/capital/cptcapital.jsp'  linkkey='id' linkvaluecolumn='cptid'  />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("903",user.getLanguage())+"\" column=\"mark\"  orderkey=\"mark\"  />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("904",user.getLanguage())+"\" column=\"capitalspec\"  orderkey=\"capitalspec\"  />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("602",user.getLanguage())+"\" column=\"stateid\"  orderkey=\"stateid\" transmethod='weaver.cpt.maintenance.CapitalStateComInfo.getCapitalStatename' />"+
        "</head>"+
        "<operates width=\"5%\">";
if(canRelated){
	tableString+=
        "    <operate href=\"javascript:onDelRelated()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>";
}
tableString+=""+
        "</operates>"+
        "</table>";

%>




<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("858",user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
	
		<wea:item attributes="{'isTableList':'true'}">
			<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
<!--RelatedCpt End-->

	
	<%
	
	
}



%>


<script type="text/javascript">
$(function(){
	$("#refTb").bind("mouseout",function(){
		$(this).find("tr").removeClass("Selected");
	});
	
});

function showHover(obj){
	$("#refTb").find("tr").removeClass("Selected");
	var refid=$(obj).attr("refid");
	$(obj).find(".e8operate").hide();
	$(obj).find(".hoverDiv").show();
	$(obj).parents("tr").first().addClass("Selected");
}
function hideHover(obj){
	$(obj).find(".e8operate").show();
	$(obj).find(".hoverDiv").hide();
	$("#refTb").find("tr").removeClass("Selected");
}


function addRef(){
	var src='<%=src %>';
	var url="";
	var title="";
	if('crm'==src){
		url="/proj/process/AddPrjCustomer.jsp?ProjID=<%=ProjID%>&taskrecordid=<%=taskrecordid%>&type=2&method=add&isdialog=1";
		title="<%=SystemEnv.getHtmlLabelNames("83878",user.getLanguage())%>";
		openDialog(url,title,400,250);
	}else if('cpt'==src){
		onShowCptRequest();
	}
}
function onEdit(id){
	if(id){
		var src='<%=src %>';
		var url="";
		var title="";
		if('crm'==src){
			url="/proj/process/EditPrjCustomer.jsp?ProjID=<%=ProjID%>&taskrecordid=<%=taskrecordid%>&type=2&method=edit&isdialog=1&id="+id;
			title="<%=SystemEnv.getHtmlLabelNames("83879",user.getLanguage())%>";
		}
		openDialog(url,title,400,250);
	}
}


function onDel(id,obj){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			var src='<%=src %>';
			var url="";
			if('req'==src){
				url="/proj/process/TaskRelatedOperation.jsp?method=delRequiredWF&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&requiredWFID="+id;
				
			}else if('doc'==src){
				url="/proj/process/TaskRelatedOperation.jsp?method=delRequiredDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&secID="+id;
			}
			jQuery.post(
				url,
				{},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						if($(obj)){
							$(obj).parents("tr").first().remove();
						}
					});
				}
			);
			
		});
	}
}
function onDelRelated(id,para2){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			var src='<%=src %>';
			var url="";
			if('req'==src){
				url="/proj/process/RequestOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+id;
			}else if('doc'==src){
				if(para2){
					var a=para2.split("+");
					if(a[0]&&a[0]=="ref"){
						//del refdoc
						url="/proj/process/TaskRelatedOperation.jsp?method=delReferencedDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&docID="+id;
					}else if(a[1]){
						//del relateddoc
						url="/proj/process/DocOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+a[1];
					}
				}
				
			}else if('crm'==src){
				url="/proj/process/PrjCustomerOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+id;
			}else if('cpt'==src){
				url="/proj/process/CptOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+id;
			}
			jQuery.post(
				url,
				{},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						if(src=='doc'||src=='req'){
							window.location.reload();
						}else{
							_table.reLoad();
						}
					});
				}
			);
			
		});
	}
}

function onBatchdel(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83601",user.getLanguage())%>',function(){
		var src='<%=src %>';
		var url="";
		if('req'==src){
			url="/proj/process/RequestOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+typeids;
		}else if('doc'==src){
			url="/proj/process/DocOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+typeids;
		}else if('crm'==src){
			url="/proj/process/PrjCustomerOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+typeids;
		}else if('cpt'==src){
			url="/proj/process/CptOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+typeids;
		}
		jQuery.post(
			url,
			{},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
					if(src=='doc'||src=='req'){
						window.location.reload();
					}else{
						_table.reLoad();
					}
				});
			}
		);
		
	});
}


function switchNecessary(obj){
	var chkval=$(obj).attr("checked")==true?"1":"0";
	var wfid=$(obj).attr("wfid");
	var wfcnt=$(obj).attr("wfcnt");
	var chkname=$(obj).attr("name");
	var type="";
	if(chkname.indexOf("needwfchk_")>-1){
		type="req";
	}else if(chkname.indexOf("needdocchk_")>-1){
		type="doc";
	}
	
	var url="";
	if(type=="req"){
		url="/proj/process/TaskRelatedOperation.jsp?method=modifyRequiredWFN&taskID=<%=taskrecordid%>&wfID="+wfid+"&isNecessary="+chkval;
	}else if(type=="doc"){
		url = "/proj/process/TaskRelatedOperation.jsp?method=modifyRequiredDocN&taskID=<%=taskrecordid%>&secID="+wfid+"&isNecessary="+chkval;
	}
	jQuery.post(
		url,
		{},
		function(data){
			//_table.reLoad();
			var musttag="<img src='/images/BacoError_wev8.gif' align='absmiddle'>";
			var preTd=$(obj).parents("td").first().prev("td");
			if(chkval=="1"){
				if(wfcnt=="0" && chkval=="1"){
					preTd.append(musttag);
				}
			}else{
				preTd.find("img").remove();
			}
		}
	);
}

function onShowDoc(spanname,inputename) {
    try{
    	var  wfIDs = $("input[name=taskrecordid]");
		showModalDialogForBrowser(null,
				"/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp", '#', wfIDs.attr("name"), true, 2, '', 
				{name:wfIDs.attr("name"),hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onShowDoc_callback}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onShowDoc_callback(p1,datas,fieldname,p4,p5){
	if (datas&&datas.id){
		var url = "/proj/process/DocOperation.jsp?method=add&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&docid="+datas.id;
		jQuery.post(
			url,
			{},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83880",user.getLanguage())%>",function(){
					//_table.reLoad();
					window.location.reload();
				});
				
			}
		);
	}
}

function onSelectCategory(spanname,inputename) {
    try{
    	var  wfIDs = $("input[name=taskrecordid]");
		showModalDialogForBrowser(null,
				"/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp", '#', wfIDs.attr("name"), true, 2, '', 
				{name:wfIDs.attr("name"),hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onSelectCategory_callback}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onSelectCategory_callback(p1,datas,fieldname,p4,p5){
	if (datas&&datas.id>0) {
	      var url="TaskRelatedOperation.jsp?method=addRequiredDoc&taskID=<%=taskrecordid%>&secID="+datas.id;
			jQuery.post(
				url,
				{},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83880",user.getLanguage())%>",function(){
						//_table.reLoad();
						window.location.reload();
					});
					
				}
			);
	}
}
function onShowWorkflow(spanname,inputename) {
    try{
    	var  wfIDs = $("input[name=requiredWFIDs]");
    	var tmpIds="";
    	if (wfIDs.length>0 ){
    		for (var i=0 ;i< wfIDs.length;i++){
    			tmpIds = tmpIds + wfIDs[i].value + ","
    		}
    		
    		tmpIds = tmpIds.substr(1);
    	}

    	tmpIds2 = "," + tmpIds + ",";
		showModalDialogForBrowser(null,
				"/workflow/WFBrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+tmpIds, '#', wfIDs.attr("name"), true, 2, '', 
				{name:wfIDs.attr("name"),hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onShowWorkflow_callback}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onShowWorkflow_callback(p1,datas,fieldname,p4,p5){
	if (datas){
		if(datas.id!=""&&datas.id!="0"){
			var url="/proj/plan/TaskRelatedOperation.jsp?method=addRequiredWF&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&wfIDs="+datas.id;
			jQuery.post(
				url,
				{},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83880",user.getLanguage())%>",function(){
						//_table.reLoad();
						window.location.reload();
					});
					
				}
			);
		}
	}
}

function onShowRequest(spanname,inputename) {
    try{
    	var  wfIDs = $("input[name=taskrecordid]");
		showModalDialogForBrowser(null,
				"/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1", '#', wfIDs.attr("name"), true, 2, '', 
				{name:wfIDs.attr("name"),hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onShowRequest_callback}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onShowRequest_callback(p1,datas,fieldname,p4,p5){
	if (datas){
		if(datas.id!=""&&datas.id!="0"){
			var url="/proj/process/RequestOperation.jsp?method=add&ProjID=<%=ProjID%>&type=1&taskid=<%=taskrecordid%>&requestid=" +datas.id;
			jQuery.post(
				url,
				{},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83880",user.getLanguage())%>",function(){
						//_table.reLoad();
						window.location.reload();
					});
					
				}
			);
		}
	}
}

function onShowCptRequest(spanname,inputename) {
    try{
    	var  wfIDs = $("input[name=taskrecordid]");
		showModalDialogForBrowser(null,
				"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2", '#', wfIDs.attr("name"), true, 2, '', 
				{name:wfIDs.attr("name"),hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onShowCptRequest_callback}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onShowCptRequest_callback(p1,datas,fieldname,p4,p5){
	if (datas&&datas.id){
		var url="/proj/process/CptOperation.jsp?method=add&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&requestid="+datas.id;
		jQuery.post(
			url,
			{},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83880",user.getLanguage())%>",function(){
					_table.reLoad();
				});
				
			}
		);
	}
}
/**
function addNewDoc(){
	var url="/docs/docs/DocList.jsp";
	var topage=encodeURIComponent(jQuery("form[name='doc1']").find("input[name='topage'").val());
	var prjid=jQuery("form[name='doc1']").find("input[name='prjid'").val();
	var taskrecordid=jQuery("form[name='doc1']").find("input[name='taskrecordid'").val();
	openFullWindowForXtable(url+"?topage="+topage);
}**/
function addNewDoc(){
	var url="/docs/docs/DocList.jsp";
	var prjid=jQuery("form[name='doc1']").find("input[name='prjid'").val();
	var taskrecordid=jQuery("form[name='doc1']").find("input[name='taskrecordid'").val();
	var topage=encodeURIComponent(jQuery("form[name='doc1']").find("input[name='topage'").val());
	openFullWindowForXtable(url+"?isOpenNewWind=0&topage="+topage+"&prjid="+prjid+"&taskrecordid="+taskrecordid);
}

function addNewReq(){
	var url="/workflow/request/RequestType.jsp";
	var prjid=jQuery("form[name='workflow1']").find("input[name='prjid'").val();
	var taskrecordid=jQuery("form[name='workflow1']").find("input[name='taskrecordid'").val();
	var topage=encodeURIComponent(jQuery("form[name='workflow1']").find("input[name='topage'").val());
	openFullWindowForXtable(url+"?topage="+topage+"&prjid="+prjid+"&taskrecordid="+taskrecordid);
}

</script>

</BODY>
</HTML>
