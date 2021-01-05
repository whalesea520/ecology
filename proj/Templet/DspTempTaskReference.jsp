<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.SQLUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
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

<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String src = Util.null2String(request.getParameter("src"));

int ProjID = Util.getIntValue(request.getParameter("templetId"),0);
int taskTempletId = Util.getIntValue(request.getParameter("id"),0);
String taskrecordid = ""+taskTempletId;

String sql="";
String logintype = user.getLogintype();
String CurrentUser = ""+user.getUID();



/*权限－begin*/
boolean canMaint = false ;
if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
  canMaint = true ;
}

boolean canRef= canMaint;
boolean canRelated=canMaint ;
boolean ismanager=canMaint ;
/*权限－end*/
RecordSet.executeSql("SELECT 1 FROM  Prj_Template where id="+ProjID+" and status=2");
if(RecordSet.next()){
	canRef=false;
	canRelated=false;
	ismanager=false;
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


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY scroll=no>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(false&& canRelated){
	if("req".equalsIgnoreCase(src)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+",javascript:document.workflow1.submit(),_top} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else if("doc".equalsIgnoreCase(src)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1986,user.getLanguage())+",javascript:document.doc1.submit(),_top} " ;
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
if(false&&canRelated){
	if("req".equalsIgnoreCase(src)){
		%>
		<input type="button" value="<%=SystemEnv.getHtmlLabelName( 16392 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="document.workflow.submit()"/>
		<%
		
	}else if("doc".equalsIgnoreCase(src)){
		%>
		<input type="button" value="<%=SystemEnv.getHtmlLabelName( 1986 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="document.doc.submit()"/>
		<%
	}else{
		%>
		<input type="button" value="<%=SystemEnv.getHtmlLabelName( 611 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="addRef()"/>
		<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top"  onclick="onBatchdel()"/>
		<%
	}
}

%>		
		
		
			<input type="text" class="searchInput" name="flowTitle"  value="<%=nameQuery %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>





<%
int usertype = 0;
if(logintype.equals("2")) usertype= 1;

String topage="";




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
backfields =" id, workflowId,isNecessary ";
sqlwhere=" WHERE templetTaskId="+taskTempletId;
orderby=" id ";
fromSql  =" Prj_TempletTask_needwf ";

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
while(RecordSet.next()){
	reqWFId = RecordSet.getInt("workflowId");
	reqWFIsNecessary = RecordSet.getString("isNecessary");


%>    
    <tr style="vertical-align: middle; " class="">
        <td style="height: 30px; display: none; width: 4%; ">&nbsp;<input type="checkbox" style="display:none"
                                                                          id="value=undefined"></td>
        <td  style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; "
            align="left" title="">
           	<%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString("workflowId")),user.getLanguage())%>
        </td>
        <td style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; "
            align="left" title="">
            <input type="checkbox"  wfid="<%=reqWFId %>" name="necessaryWF<%=reqWFId %>" value="1" <%=ismanager?"":"disabled" %> <%="1".equals(reqWFIsNecessary)?"checked":"" %> onclick="switchNecessary(this)" >
        </td>
        
        <td class="hoverOptCell"  refid='<%=reqWFId %>' onmouseover="showHover(this)" onmouseout="hideHover(this)" style="text-align: center; vertical-align: middle; line-height: 30px; ">
<%
if(ismanager){
	%>
            <div class="e8operate">&nbsp;</div>
		    <div name='refoptdiv' class="hoverDiv" style="height: 29px; line-height: 30px;width:60px; margin-left: -25px; margin-top: -15px; margin-right: 0px; display: none;">
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
sql="SELECT docMainCategory,docSubCategory,docSecCategory,isNecessary FROM Prj_TempletTask_needdoc WHERE templetTaskId="+taskTempletId;

backfields ="id, docMainCategory,docSubCategory,docSecCategory,isNecessary ";
sqlwhere=" WHERE templetTaskId="+taskTempletId+"  ";
orderby=" id ";
fromSql  =" Prj_TempletTask_needdoc ";

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


%>    
    <tr style="vertical-align: middle; " class="">
        <td style="height: 30px; display: none; width: 4%; ">&nbsp;<input type="checkbox" style="display:none"
                                                                          id="value=undefined"></td>
        <td  style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; "
            align="left" title="">
           	<%=Util.toScreen(ProjectTransUtil.getDocCategoryFullname(reqDocSecCategory) , user.getLanguage()) %>
        </td>
        <td style="height: 30px; vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; "
            align="left" title="">
            <input type="checkbox"  wfid="<%=reqDocSecCategory %>" name="necessary<%=reqDocSecCategory %>" value="1" <%=ismanager?"":"disabled" %> <%="1".equals(reqIsNecessary)?"checked":"" %> onclick="switchNecessary(this)" >
        </td>
        
        <td class="hoverOptCell"  refid='<%=reqDocSecCategory %>' onmouseover="showHover(this)" onmouseout="hideHover(this)" style="text-align: center; vertical-align: middle; line-height: 30px; ">
<%
if(ismanager){
	%>
            <div class="e8operate">&nbsp;</div>
		    <div name='refoptdiv' class="hoverDiv" style="height: 29px; line-height: 30px; width:60px; margin-left: -25px;margin-top: -15px; margin-right: 0px; display: none;">
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

backfields ="a.seccategory, a.id, a.docsubject, a.ownerid, a.usertype, a.doccreatedate, a.doccreatetime ";
sqlwhere=" WHERE b.templetTaskId="+taskTempletId+" AND a.id=b.docid";
orderby=" a.id  ";
fromSql  =" DocDetail a, Prj_TempletTask_referdoc b  ";
sql="select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby;
//out.println("sql:\n"+sql);

tableString=""+
        "<table instanceid=\"CptCapitalAssortmentTable\"   tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
        //" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTask' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlprimarykey=\"a.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>"+                             
              "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelNames("229",user.getLanguage())+"\" column=\"docsubject\" orderkey=\"docsubject\" href='/docs/docs/DocDsp.jsp'  linkkey='id' linkvaluecolumn='id' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("92",user.getLanguage())+"\" column=\"seccategory\"  orderkey=\"seccategory\"  transmethod='weaver.proj.util.ProjectTransUtil.getDocCategoryFullname' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("1340",user.getLanguage())+"\" column=\"ownerid\"  orderkey=\"ownerid\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' />"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("722",user.getLanguage())+"\" column=\"doccreatedate\"  orderkey=\"doccreatedate\"  />"+
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
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("844",user.getLanguage())%>' attributes="">
	
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
				url="/proj/plan/TaskRelatedOperation.jsp?type=template&method=delRequiredWF&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&requiredWFID="+id;
				
			}else if('doc'==src){
				url="/proj/plan/TaskRelatedOperation.jsp?type=template&method=delRequiredDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&secID="+id;
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
function onDelRelated(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			var src='<%=src %>';
			var url="";
			if('req'==src){
				url="/proj/process/RequestOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id="+id;
			}else if('doc'==src){
				//del refdoc
				url="/proj/plan/TaskRelatedOperation.jsp?type=template&method=delReferencedDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&docID="+id;
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
						if(src=='req'){
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
			//del refdoc
			url="/proj/plan/TaskRelatedOperation.jsp?type=template&method=delReferencedDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&docID="+typeids;
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
					if(src=='req'){
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
	var chkname=$(obj).attr("name");
	var type="<%=src %>";
	
	var url="";
	if(type=="req"){
		url="/proj/plan/TaskRelatedOperation.jsp?type=template&method=modifyRequiredWFN&taskID=<%=taskrecordid%>&wfID="+wfid+"&isNecessary="+chkval;
	}else if(type=="doc"){
		url = "/proj/plan/TaskRelatedOperation.jsp?type=template&method=modifyRequiredDocN&taskID=<%=taskrecordid%>&secID="+wfid+"&isNecessary="+chkval;
	}
	jQuery.post(
		url,
		{},
		function(data){
		}
	);
}

function onShowDoc(spanname,inputename) {
    try{
    	var  wfIDs = $("input[name=flowTitle]");
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
		var url = "/proj/plan/TaskRelatedOperation.jsp?type=template&method=addReferencedDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&docIDs="+datas.id;
		jQuery.post(
			url,
			{},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83880",user.getLanguage())%>",function(){
					_table.reLoad();
					//window.location.reload();
				});
				
			}
		);
	}
}
function onSelectCategory(spanname,inputename) {
    try{
    	var  wfIDs = $("input[name=flowTitle]");
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
	      var url="/proj/plan/TaskRelatedOperation.jsp?type=template&method=addRequiredDoc&taskID=<%=taskrecordid%>&secID="+datas.id;
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
			var url="/proj/plan/TaskRelatedOperation.jsp?type=template&method=addRequiredWF&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&wfIDs="+datas.id;
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

function onShowRequest(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1");
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

function onShowCptRequest(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2");
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

function onShowMRequest(inputname,spanname){
	var tmpids =$("input[name="+inputname+"]").val();
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="+tmpids);
    if (datas) {
	    $("input[name="+inputname+"]").val(datas.id);
	    var shtml="";
	    var idarr=datas.id.split(",");
	    var namearr=datas.name.split(",");
	    for(var i=0;i<idarr.length;i++){
	    	shtml+="<a href=javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="+idarr[i]+"')>"+namearr[i]+"</a>&nbsp;";
	    }
	    $("#"+spanname).html(shtml);
    }
}
</script>

</BODY>
</HTML>
