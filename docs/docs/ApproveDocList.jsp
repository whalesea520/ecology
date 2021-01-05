
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<HTML><HEAD>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docSearchExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
</head>


<%
String hasTab = Util.null2String(request.getParameter("hasTab"));
if(hasTab.equals("")){
	response.sendRedirect("/docs/search/DocSearchTab.jsp?_fromURL=1&"+request.getQueryString());
	return;
}
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2069,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1009,user.getLanguage())+",javascript:onBatchApprove(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1010,user.getLanguage())+",javascript:onReject(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>


<%
String approveType = Util.null2String(request.getParameter("approveType"));
String docsubject = Util.null2String(request.getParameter("docsubject"));
//if(approveType.equals("")){//审批类型默认为文档生效审批
//	approveType="1";
//}

%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" id="flowTitle" class="searchInput" name="flowTitle" value="<%= docsubject %>" onchange="setKeyword('flowTitle','docsubject','frmmain');"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<FORM id=weaver name=frmmain method=post action="ApproveDocOperation.jsp">

<input type=hidden name=multiRequestId >
<input type=hidden name=src >


<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item><input class=InputStyle type="text"  name="docsubject" id="docsubject" value='<%=docsubject%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19535,user.getLanguage())%></wea:item>
		<wea:item>
			<select type="select" size=1  class=InputStyle name=approveType  onchange="onChangeApproveType(this.value)">
				<option value="" <% if(approveType.equals("")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></option>
				<option value="1" <% if(approveType.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19536,user.getLanguage())%></option>
				<option value="2" <% if(approveType.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19537,user.getLanguage())%></option>
			 </select>
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>



</form>
</div>

 <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_APPROVEDOCLIST %>"/>
<%

String userId=user.getUID()+"" ;
int userType = 0;
String loginType = ""+user.getLogintype();
if(loginType.equals("2")) userType= 1;

int perpage=10;

String orderby=" t3.doccreatedate ,t3.docCreateTime ";


String tableString = "";
                              
//String backfields = " t1.requestid,t1.requestname,t3.id as docId,t3.docsubject,t3.doccreaterid,t3.ownerid,t3.doccreatedate,t3.doclastmoddate,t3.docCreateTime,t3.docStatus,t3.userType ";
String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.docid and userid="+user.getUID()+"),0) as readCount";
if("oracle".equals(RecordSet.getDBType()))
{
	outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.docid and userid="+user.getUID()+"),0) as readCount";
}
String backfields = " t1.requestid,t1.requestname,t3.id as docId,t3.docsubject,t3.seccategory,t3.doccreaterid,t3.ownerid,t3.doccreatedate,t3.doclastmoddate,t3.docCreateTime,t3.docStatus,t3.userType ";

//String fromSql  = " DocApproveWf t4,workflow_requestbase t1,workflow_currentoperator t2, DocDetail t3 ";
String fromSql ="";
if(approveType.equals("1")||approveType.equals("2")){
	fromSql  = " DocApproveWf t4,workflow_requestbase t1,workflow_currentoperator t2, DocDetail t3 ";
}else{
	fromSql  = " bill_Approve t4,workflow_requestbase t1,workflow_currentoperator t2,DocDetail t3 ";
}


StringBuffer sqlWhereSb=new StringBuffer();
if(approveType.equals("1")||approveType.equals("2")){
	sqlWhereSb.append(" where t4.requestid=t1.requestid ")
          .append("   and t1.requestid=t2.requestid ")
		  .append("   and t4.docId=t3.id ")
		  .append("   and t2.userid= ").append(userId)
		  .append("   and t2.usertype= ").append(userType)
//		  .append("   and t4.status='0' ")
		  .append("   and t2.isremark in( '0','1') ")
		  .append("   and (t1.deleted=0 or t1.deleted is null) ")
		  .append("   and t1.currentnodetype <> 3 ")
		  .append("   and t4.approveType='").append(approveType).append("'")
		  //add by wdl 2006-8-28 只能显示非历史版本
		  .append(" and (t3.ishistory is null or t3.ishistory = 0) ")
		  ;
}else{
	sqlWhereSb.append(" where t4.requestid=t1.requestid ")
          .append("   and t1.requestid=t2.requestid ")
		  .append("   and t4.approveid=t3.id ")
		  .append("   and t2.userid= ").append(userId)
		  .append("   and t2.usertype= ").append(userType)
		  .append("   and t4.status='0' ")
		  .append("   and t2.isremark in( '0','1') ")
		  .append("   and (t1.deleted=0 or t1.deleted is null) ")
		  .append("   and t1.currentnodetype <> 3 ")
		  ;
}

if(!docsubject.equals("")){
	sqlWhereSb.append(" and t3.docsubject like '%"+docsubject.trim()+"%' ");
}

String sqlWhere = sqlWhereSb.toString() ;


String userInfoForotherpara =loginType+"+"+userId;

tableString =   " <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_APPROVEDOCLIST,user.getUID(),PageIdConst.DOC)+"\" >"+
                "       <sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"docId\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.docs.docs.DocApproveWfTransMethod.getDocNameAndIsNewByDocId90974\" otherpara=\""+userInfoForotherpara+"+"+"column:requestid+column:docsubject+column:doccreaterid+column:readCount"+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"doccreaterid\" orderkey=\"doccreaterid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus4\" otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>"+
                "       </head>"+
                " </table>";
%>

            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />


<table align=right>
   <tr>
    <td>&nbsp;</td>
    <td>
    <%
    RecordSet.executeSql(" select count(t1.requestid) as nums from " + fromSql + sqlWhere);
    if(RecordSet.next() && RecordSet.getInt("nums")>0 ){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    </td>
    <td>&nbsp;</td>
   </tr>
</TABLE>


</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>

</html>

<SCRIPT language="javascript">

function onBtnSearchClick(){
	document.frmmain.action = "ApproveDocList.jsp";
	document.frmmain.submit();
}

function onBatchApprove(){

    document.frmmain.multiRequestId.value = _xtable_CheckedCheckboxId();
	if(_xtable_CheckedCheckboxId()!=null&&_xtable_CheckedCheckboxId()!=""){
		document.frmmain.src.value="submit";
		document.frmmain.submit();
	}

}

function onReject(){

    document.frmmain.multiRequestId.value = _xtable_CheckedCheckboxId();
	if(_xtable_CheckedCheckboxId()!=null&&_xtable_CheckedCheckboxId()!=""){
		document.frmmain.src.value="reject";
		document.frmmain.submit();
	}

}

function onChangeApproveType(objValue){

    //location='ApproveDocList.jsp?approveType='+objValue;

}

</script>

