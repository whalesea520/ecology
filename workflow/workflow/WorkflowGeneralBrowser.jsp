
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
Table.ListStyle TR.Selected td {
	color: #000;
	background:#f5fafb;
}

</style>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
int formid = Util.getIntValue(request.getParameter("formid"));
int isbill = Util.getIntValue(request.getParameter("isbill"),0);
int noclean = Util.getIntValue(request.getParameter("noclean"),0);
String sqlStr = "";
ArrayList modeidlist=new ArrayList();
ArrayList modenamelist=new ArrayList();
ArrayList modeisform=new ArrayList();
ArrayList nodenamelist=new ArrayList();
ArrayList workflownames=new ArrayList();
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";
String id="0";
String layoutname = Util.null2String(request.getParameter("layoutname"));
if(!layoutname.equals(""))
{
	sqlStr+=" and l.modename like'%"+layoutname+"%' ";
}
String modename="";
//添加and (b.isFreeNode != '1' OR b.isFreeNode IS null)条件, 限制查询条件不包括自由流转中的节点
RecordSet.executeSql("select l.id, l.modename, n.nodename, b.workflowname from wfnodegeneralmode l, workflow_base b, workflow_nodebase n where l.nodeid=n.id and l.wfid=b.id and (n.isFreeNode != '1' OR n.isFreeNode IS null) and l.formid="+formid+" and l.isbill="+isbill+sqlStr+" order by l.nodeid");
while(RecordSet.next()){
    id=RecordSet.getString("id");
    modename=RecordSet.getString("modename");
    int tisprint=Util.getIntValue(RecordSet.getString("type"),0);
    String nodename=RecordSet.getString("nodename");
    modeidlist.add(id);
    modenamelist.add(modename);
    modeisform.add("0");
    nodenamelist.add(nodename);
    workflownames.add(RecordSet.getString("workflowname"));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit();,_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if (noclean != 1) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage()) %>"/>
</jsp:include>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0" ></table>
<FORM name="SearchForm" STYLE="margin-bottom:0" action="WorkflowGeneralBrowser.jsp" method="post">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<wea:layout type="2col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" class="inputstyle" id="layoutname" name="layoutname" >		
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<table id=BrowseTable class="ListStyle"  cellspacing="0"  width="100%">
				<colgroup>
					<col width="15%">
					<col width="40%">
					<col width="15%">
					<col width="30%">
				</colgroup>
				<tr class=header>
					<th width=15%><%=SystemEnv.getHtmlLabelName(31186,user.getLanguage())%>ID</th>
					<th width=40%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
					<th width=15%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></th>
					<th width=30%><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></th>
				</tr>
				<%
				for(int j=0;j<modeidlist.size();j++){
				%>
				<tr>
					<td><%=modeidlist.get(j)%></td>
				    <td><%=modenamelist.get(j)%></td>
					<td><%=nodenamelist.get(j)%></td>
				    <td><%=workflownames.get(j)%></td>
				</tr>
				<tr class="Spacing" style="height:1px!important;"><td colspan="4" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
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
  var parentWin = parent.parent.getParentWindow(parent);
  var dialog = parent.parent.getDialog(parent);
 </script>
<script type="text/javascript">

function btnclear_onclick(){
	var returnjson = {modeid:"",modename:"",isForm:"",name:""};
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
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
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
    //  p=jQuery(target).parents("tr")[0];
    //  if( p.rowIndex % 2 ==0){
    //     p.className = "DataDark"
    //  }else{
    //     p.className = "DataLight"
    //  }
   }

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     var returnjson = {modeid:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),modename:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),isForm:jQuery(jQuery(target).parents("tr")[0].cells[2]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[3]).text()};
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


function onSearch(){
	SearchForm.submit();
}
function submitData(){
	btnok_onclick();
}

function submitClear(){
	btnclear_onclick();
}

</script>