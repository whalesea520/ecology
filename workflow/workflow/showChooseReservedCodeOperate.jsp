
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<%

boolean canEdit=false;
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	canEdit=true;
}

int design = Util.getIntValue(request.getParameter("design"),0);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
String isBill = Util.null2String(request.getParameter("isBill"));
String yearId = Util.null2String(request.getParameter("yearId"));
String monthId = Util.null2String(request.getParameter("monthId"));
String dateId = Util.null2String(request.getParameter("dateId"));
String fieldId = Util.null2String(request.getParameter("fieldId"));
String fieldValue = Util.null2String(request.getParameter("fieldValue"));
String supSubCompanyId = Util.null2String(request.getParameter("supSubCompanyId"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String departmentId = Util.null2String(request.getParameter("departmentId"));

int recordId = Util.getIntValue(request.getParameter("recordId"),0);
int sequenceId=1;
if(recordId<=0){
	int tempWorkflowId=-1;
	int tempFormId=-1;
	String tempIsBill="0";
	String tempYearId="-1";
	String tempMonthId="-1";
	String tempDateId="-1";
	
	String tempFieldId="-1";
	String tempFieldValue="-1";
	
	String tempSupSubCompanyId="-1";
	String tempSubCompanyId="-1";
	String tempDepartmentId="-1";
	
	int tempRecordId=-1;
	int tempSequenceId=1;
	
	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	
	String workflowSeqAlone=cb.getWorkflowSeqAlone();
	String dateSeqAlone=cb.getDateSeqAlone();
	String dateSeqSelect=cb.getDateSeqSelect();
	String fieldSequenceAlone=cb.getFieldSequenceAlone();
	String struSeqAlone=cb.getStruSeqAlone();
	String struSeqSelect=cb.getStruSeqSelect();
	
	if("1".equals(workflowSeqAlone)){
		tempWorkflowId=workflowId;
	}else{
		tempFormId=formId;
	    tempIsBill=isBill;
	}
	
	if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){
		tempYearId=yearId;
	}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){
		tempYearId=yearId;
		tempMonthId=monthId;						
	}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){
		tempYearId=yearId;						
		tempMonthId=monthId;	
		tempDateId=dateId;							
	}
					
	if("1".equals(fieldSequenceAlone)&&!fieldId.equals("-1") ){
		tempFieldId=fieldId;
		tempFieldValue=fieldValue;
	}
					
	if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){
		tempSupSubCompanyId=supSubCompanyId;
		tempSubCompanyId="-1";
		tempDepartmentId="-1";						
	}
	if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){
		tempSupSubCompanyId="-1";
		tempSubCompanyId=subCompanyId;
		tempDepartmentId="-1";						
	}
	if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){
		tempSupSubCompanyId="-1";
		tempSubCompanyId="-1";
		tempDepartmentId=departmentId;						
	}

	RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);
//System.out.println("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);
	if(RecordSet.next()){
		tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	}

    if(tempRecordId>0){
		recordId = tempRecordId;
		sequenceId = tempSequenceId;
	}
}else{
	RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

	if(RecordSet.next()){
		sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	}
}

String src = Util.null2String(request.getParameter("src"));

if(src.equals("delete")){
	String[] checkids = request.getParameterValues("check_node");
	if(checkids!=null){
		for(int i=0;i<checkids.length;i++){
			RecordSet.executeSql("update workflow_codeSeqReserved set hasDeleted=1  where id="+checkids[i]);
		}
	}
}

%>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(22785,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>

<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

//if(design==1) {
//	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
//	RCMenuHeight += RCMenuHeightStep;
//}
//else {
//RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
//}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showViewReservedCodeOperate.jsp" method="post">

<input type="hidden" value="" name="src">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" value="<%=workflowId%>" name="workflowId">
<input type="hidden" value="<%=formId%>" name="formId">
<input type="hidden" value="<%=isBill%>" name="isBill">
<input type="hidden" value="<%=recordId%>" name="recordId">



<wea:layout type="twoCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(22785,user.getLanguage())%>'>
		<wea:item attributes="{\"colspan\":\"full\",\"isTableList\":\"true\"}">
			<table width="100%"  ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0">
           
            <TR class=DataHeader>
               <TH style="display:none"></TH>
  	           <TH><%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%></TH>
  	           <TH><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
  	        </tr>
  	        <tr class="Line"><TH colspan="3"> </TH></tr>
<%
    String trClass="DataLight";

    int id=-1;
	int reservedId=-1;
	String reservedCode=null;
	String reservedDesc=null;
	StringBuffer codeSeqReservedSb=new StringBuffer();
	if(recordId<=0) recordId = 0;
	codeSeqReservedSb.append(" select * ")
	                 .append("   from workflow_codeSeqReserved  ")
					 .append("  where codeSeqId= ").append(recordId)
					 .append("    and (hasUsed is null or hasUsed='0') ")
					 .append("    and (hasDeleted is null or hasDeleted='0') ")
					 .append("  order by reservedId asc,id asc ")
					 ;
    RecordSet.executeSql(codeSeqReservedSb.toString());
    //System.out.println(codeSeqReservedSb.toString());
    while(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString("id"),-1);
		reservedId=Util.getIntValue(RecordSet.getString("reservedId"),-1);
		reservedCode=Util.null2String(RecordSet.getString("reservedCode"));
		reservedDesc=Util.null2String(RecordSet.getString("reservedDesc"));
%>
	    <tr  class="<%=trClass%>">
		    <td width=0% style="display:none"><A HREF=#><%=id%></A></td>
            <td  height="23" align="left"><%=reservedCode%></td>
            <td  height="23" align="left"><%=reservedDesc%></td>
	    </tr>
<%
		if(trClass.equals("DataLight")){
			trClass="DataDark";
		}else{
			trClass="DataLight";
		}
	}
%>
<tr></tr>
<tr></tr>
            </table>
		</wea:item>
	</wea:group>
</wea:layout>

</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>

<script language=javascript>

var parentWin = window.parent.parent.getParentWindow(parent);
var dialog = window.parent.parent.getDialog(parent);

function onClose(){
	if(dialog){
	    dialog.close();
	}else{  
	    window.parent.close();
	}
	//window.parent.close();
}

//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('showViewReservedCodeOperate');
}
</script>




<script type="text/javascript">
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
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	//var e=e||event;
	//var target=e.srcElement||e.target;
	//if( target.nodeName =="TD"||target.nodeName =="A"  ){
	//	var curTr=jQuery(target).parents("tr")[0];
	//	window.parent.returnValue = jQuery(curTr.cells[0]).text()+"_"+(jQuery(curTr.cells[1]).text());
	//	window.parent.close();
	//}
	
	 var e=e||event;
	   var target=e.srcElement||e.target;

		if( target.nodeName =="TD"||target.nodeName =="A"  ){
			var pNode = target.parentNode;
			if(pNode.nodeName!="TR"){
				pNode = pNode.parentNode;
			}
			var returnjson = {
				id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),
				name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),
				desc:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()
			};
			if(dialog){
				 try{
				     dialog.callback(returnjson);
				 }catch(e){}
				 
				 try{
				     dialog.close(returnjson);
				 }catch(e){}
			    
			}else{  
				window.parent.returnValue=returnjson;
				window.parent.close();
			}
		}
}

function btnclear_onclick(){
	//window.parent.parent.returnValue = {id:"",name:""};
	//window.parent.parent.close();
	
	var returnjson = {id:"",name:""};
	if(dialog){
			 try{
			     dialog.callback(returnjson);
			 }catch(e){}
			 
			 try{
			     dialog.close(returnjson);
			 }catch(e){}
		    
	}else{  
		window.parent.returnValue=returnjson;
		window.parent.close();
	}
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
});
</script>
