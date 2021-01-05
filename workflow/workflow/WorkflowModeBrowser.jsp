<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<style type="text/css">
Table.ListStyle TR.Selected td {
	color: #000;
	background:#f5fafb;
}

</style>
</HEAD>
<%
int formid=Util.getIntValue(request.getParameter("formid"));
int isprint=Util.getIntValue(request.getParameter("isprint"));
int isbill=Util.getIntValue(request.getParameter("isbill"),0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
String nodename = Util.null2String(request.getParameter("nodename"));
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";
ArrayList modeidlist=new ArrayList();
ArrayList modenamelist=new ArrayList();
ArrayList modeisform=new ArrayList();
ArrayList nodenamelist=new ArrayList();
ArrayList workflownames=new ArrayList();
String id="0";
String modename="";
if(workflowid <=0 && "".equals(nodename)){
	if(isprint==1){
	    RecordSet.executeSql("select id,modename from workflow_formmode where isprint='1' and formid="+formid+" and isbill='"+isbill+"'");
	    if(RecordSet.next()){
	        id=RecordSet.getString("id");
	        modename=RecordSet.getString("modename");
	        if(modename==null || modename.equals("")){
	            modename=SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
	        }
	        modeidlist.add(id);
	        modenamelist.add(modename);
	        modeisform.add("1");
	        nodenamelist.add("");
	        workflownames.add("");
	    }else{
	        RecordSet.executeSql("select id,modename from workflow_formmode where isprint='0' and formid="+formid+" and isbill='"+isbill+"'");
	        if(RecordSet.next()){
	            id=RecordSet.getString("id");
	            modename=RecordSet.getString("modename");
	            if(modename==null || modename.equals("")){
	                modename=SystemEnv.getHtmlLabelName(16450,user.getLanguage());
	            }
	            modeidlist.add(id);
	            modenamelist.add(modename);
	            modeisform.add("1");
	            nodenamelist.add("");
	            workflownames.add("");
	        }
	    }
	}else{
	    RecordSet.executeSql("select id,modename from workflow_formmode where isprint='"+isprint+"' and formid="+formid+" and isbill='"+isbill+"'");
	    if(RecordSet.next()){
	        id=RecordSet.getString("id");
	        modename=RecordSet.getString("modename");
	        if(modename==null || modename.equals("")){
	            modename=SystemEnv.getHtmlLabelName(16450,user.getLanguage());
	        }
	        modeidlist.add(id);
	        modenamelist.add(modename);
	        modeisform.add("1");
	        nodenamelist.add("");
	        workflownames.add("");
	    }
	}
}
String sqlExt = "";
if(workflowid > 0){
	sqlExt += " and workflow_base.id="+workflowid+" ";
}
if(!"".equals(nodename)){
	sqlExt += " and workflow_nodebase.nodename like '%"+Util.convertInput2DB(nodename)+"%' ";
}
RecordSet.executeSql("select workflow_nodemode.id,modename,nodename,isprint,workflowname from workflow_nodemode,workflow_nodebase,workflow_base where (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode!='1') and workflow_nodemode.workflowid=workflow_base.id and workflow_nodemode.nodeid=workflow_nodebase.id and workflow_nodemode.formid="+formid+" and isbill='"+isbill+"' "+sqlExt+" order by workflow_nodemode.workflowid,nodeid");
while(RecordSet.next()){
    id=RecordSet.getString("id");
    modename=RecordSet.getString("modename");
    int tisprint=Util.getIntValue(RecordSet.getString("isprint"),0);
    String nodename_tmp = RecordSet.getString("nodename");
    if(isprint<1 && tisprint==1){
        continue;
    }
    if(modename==null || modename.equals("")){
        if(tisprint==0){
            modename=nodename_tmp+SystemEnv.getHtmlLabelName(16450,user.getLanguage());
        }else{
            modename=nodename_tmp+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
        }
    }
    modeidlist.add(id);
    modenamelist.add(modename);
    modeisform.add("0");
    nodenamelist.add(nodename_tmp);
    workflownames.add(RecordSet.getString("workflowname"));
}
String isframe=Util.null2String(request.getParameter("isframe"),"n");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(!"y".equals(isframe)){ %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage()) %>"/>
</jsp:include>
<%} %>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0" ></table>
<FORM id="SearchForm" name="SearchForm" action="WorkflowModeBrowser.jsp" method="post">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="isprint" name="isprint" value="<%=isprint%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="isframe" name="isframe" value="<%=isframe%>">
<wea:layout type="2col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%></wea:item>
		<wea:item>
		<brow:browser viewType="0" name="workflowid" browserValue='<%=""+workflowid%>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isWorkflowDoc=1"
			                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="false"
			                language='<%=""+user.getLanguage() %>'
			                completeUrl="/data.jsp?type=workflowBrowser&isWorkflowDoc=1"  temptitle='<%= SystemEnv.getHtmlLabelName(33806,user.getLanguage())%>'
			                browserSpanValue='<%=workflowComInfo.getWorkflowname(""+workflowid)%>'>
			        </brow:browser>
			<%--<button type='button' id="showChildFieldBotton" class=Browser onClick="onShowWorkflowBrowse('workflowidspan', 'workflowid')"></button>
			<span id="workflowidspan"><%=workflowComInfo.getWorkflowname(""+workflowid)%></span> 
			<input type="hidden" value="<%=workflowid%>" name="workflowid" id="workflowid">	--%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="nodename" name="nodename" value='<%=nodename%>'></wea:item>
		<wea:item attributes="{'isTableList':'true','colspan':'2'}">
			<table id=BrowseTable class="ListStyle"  cellspacing="0"  width="100%">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="20%">
					<col width="30%">
				</colgroup>
				<tr class=header>
					<th width=10%><%=SystemEnv.getHtmlLabelName(31186,user.getLanguage())%>ID</th>
					<th width=40%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
					<th width=20%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></th>
					<th width=30%><%=SystemEnv.getHtmlLabelName(18499,user.getLanguage()) + SystemEnv.getHtmlLabelName(33439,user.getLanguage())%></th>
				</tr>
				<%
				for(int j=0;j<modeidlist.size();j++){
				%>
				<tr>
					<td><%=modeidlist.get(j) %></td>
				    <td><%=modenamelist.get(j)%></td>
					<td><%=nodenamelist.get(j)%></td>
				    <td><%=workflownames.get(j)%></td>
					<td style="display:none"><%=modeisform.get(j)%></td>
				</tr>
				<tr class="Spacing" style="height:1px!important;"><td colspan="3" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
				<%}%>
				
			 	
			</table>		
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
</BODY>
</HTML>
<script type="text/javascript">
var parentWin;
var dialog;
if("y"=="<%=isframe %>"){
	parentWin = parent.parent.parent.getParentWindow(parent.parent);
	dialog = parent.parent.parent.getDialog(parent.parent);
}else{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}

function onShowWorkflowBrowse(spanname, inputname) {
	var urls = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
	//var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	var dialognew = new window.top.Dialog();
	dialognew.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialognew.URL = urls;
	dialognew.callbackfun = function (paramobj, datas) {
		if (datas){
			if (datas.id!=""){
				$("#"+inputname).val(datas.id);
				$("#"+spanname).html(datas.name);			
			}else{
				$("#"+spanname).html( "");
				$("#"+inputname).val( "");
			}
		}
	} ;
	dialognew.Title = "<%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%>";
	dialognew.Modal = true;
	dialognew.Width = 450 ;
	dialognew.Height = 500 ;
	dialognew.isIframe=false;
	dialognew.show();
}

function btnclear_onclick(){
	var returnjson = {belmodetype:"1",modeid:"",modename:"",isForm:""};
 	if(dialog){
 		try{
  			dialog.callback(returnjson);
  		}catch(e){}
  	    dialog.close(returnjson);
	}else{
	   	window.parent.returnValue  = returnjson;
	   	window.parent.close();
	}
}


 function BrowseTable_onmouseover(e){
 	e=e||event;
    var target=e.srcElement||e.target;
    if("TD"==target.nodeName){
 		jQuery(target).parents("tr")[0].className = "Selected";
 		//jQuery(target).parents("tr")[0].addClass("Selected");
    }else if("A"==target.nodeName){
 		jQuery(target).parents("tr")[0].className = "Selected";
 		//jQuery(target).parents("tr")[0].addClass("Selected");
    }
 }
 function BrowseTable_onmouseout(e){
 	var e=e||event;
    var target=e.srcElement||e.target;
    var p;
    if("TD"==target.nodeName){
 		jQuery(target).parents("tr")[0].className = " ";
 		//jQuery(target).parents("tr")[0].removeClass("Selected");
    }else if("A"==target.nodeName){
 		jQuery(target).parents("tr")[0].className = " ";
 		//jQuery(target).parents("tr")[0].removeClass("Selected");
    }
 	//if(target.nodeName == "TD" || target.nodeName == "A" ){
    //   p=jQuery(target).parents("tr")[0];
    //   if( p.rowIndex % 2 ==0){
    //      p.className = "DataDark"
    //   }else{
    //      p.className = "DataLight"
    //   }
    //}
 }
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})

function BrowseTable_onclick(e){
    var e=e||event;
    var target=e.srcElement||e.target;
    if( target.nodeName =="TD"||target.nodeName =="A"){
		var returnjson = {belmodetype:"1",modeid:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),modename:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),
			isForm:jQuery(jQuery(target).parents("tr")[0].cells[4]).text()};
		if(dialog){
			try{
				dialog.callback(returnjson);
			}catch(e){}
			dialog.close(returnjson);
	   	}else{
	   	    window.parent.returnValue  = returnjson;
	   	 	window.parent.close();
	   	}
	}
}

 function submitData()
 {btnok_onclick();
 }
function onSearch(){
	SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

</script>
