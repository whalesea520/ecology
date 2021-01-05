
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>

<HTML><HEAD>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
</head>
<%
if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";

String typename=Util.null2String(request.getParameter("typename"));
String departmentid=Util.null2String(request.getParameter("departmentid"));
String isApproval=Util.null2String(request.getParameter("isApproval"));
String isAnonymous=Util.null2String(request.getParameter("isAnonymous"));

String tableString = "";
int perpage=10;                                 
String backfields = " id,typename,departmentid,isApproval,isAnonymous ";
String fromSql  = " cowork_types ";
String sqlWhere = " 1=1 ";
String orderby = " id ";


if(!typename.equals(""))
	sqlWhere=sqlWhere+" and typename like '%"+typename+"%' ";
if(!departmentid.equals(""))
	sqlWhere=sqlWhere+" and departmentid="+departmentid;
if(!isApproval.equals(""))
	sqlWhere=sqlWhere+" and isApproval="+isApproval;
if(!isAnonymous.equals(""))
	sqlWhere=sqlWhere+" and isAnonymous="+isAnonymous;

tableString = " <table tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
			  " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getResultCheckBox\" />"+
			  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
              " <head>"+
              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" orderkey=\"typename\" column=\"typename\" linkvaluecolumn=\"id\" href=\"javascript:editCoworkType('{0}')\"/>"+
              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(178,user.getLanguage())+"\" orderkey=\"departmentid\" column=\"departmentid\" transmethod=\"weaver.cowork.CoMainTypeComInfo.getCoMainTypename\"/>"+
              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(31449,user.getLanguage())+"\" orderkey=\"isApproval\" column=\"isApproval\" transmethod=\"weaver.general.CoworkTransMethod.getIsApproval\" />"+
              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18576,user.getLanguage())+"\" orderkey=\"isAnonymous\" column=\"isAnonymous\" transmethod=\"weaver.general.CoworkTransMethod.getIsAnonymous\" />"+
              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17694,user.getLanguage())+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" defaultLinkText=\""+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"\" linkvaluecolumn=\"id\" href=\"javascript:showShareEdit('{0}','manager')\"/>"+
              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17855,user.getLanguage())+SystemEnv.getHtmlLabelName(271,user.getLanguage())+"\" defaultLinkText=\""+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"\" linkvaluecolumn=\"id\" href=\"javascript:showShareEdit('{0}','members')\"/>"+
              "	</head>"+ 
              "</table>";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:doReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:newCoworkType(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="mainfrom" action="CoworkType.jsp" method="post">
    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
			
			<TABLE class=viewform width=100% id=oTable1>
			    <COLGROUP>
			    <COL width="20%">
			    <COL width="30%">
			    <COL width="20%">
			    <COL width="30%">
			    <TBODY>
			      <tr>
			        <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
			        <td class=field>
			        <input class=inputstyle type=text name="typename" id="typename" value="<%=typename%>" style="width:90%" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
			        </td> 
			        <td><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
			        <td class=field>
				        <select name=departmentid id=departmentid>
				        	<option value="">&nbsp;&nbsp;&nbsp;&nbsp;</option>
				            <%while(CoMainTypeComInfo.next()){%>
				            <option value="<%=CoMainTypeComInfo.getCoMainTypeid()%>" <%=CoMainTypeComInfo.getCoMainTypeid().equals(departmentid)?"selected=selected":""%>><%=CoMainTypeComInfo.getCoMainTypename()%></option>
				            <%}%>
				        </select>      
			        </td>
			      </tr>
			      <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR>
			      <tr>
			        <td><%=SystemEnv.getHtmlLabelName(31449,user.getLanguage())%></td>
			        <td class=field>
			        	<select style="width:80px;" name="isApproval" id="isApproval">
			        	   <option value="">&nbsp;&nbsp;&nbsp;&nbsp;</option>
				           <option value="1" <%=isApproval.equals("1")?"selected=selected":""%>><%=SystemEnv.getHtmlLabelName(82677,user.getLanguage())%></option>
				           <option value="0" <%=isApproval.equals("0")?"selected=selected":""%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
				        </select>      
			        </td> 
			        <td><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></td>
			        <td class=field>
				        <select style="width:80px;" name="isAnonymous" id="isAnonymous">
				           <option value=""></option>
				           <option value="1" <%=isAnonymous.equals("1")?"selected=selected":""%>><%=SystemEnv.getHtmlLabelName(82677,user.getLanguage())%></option>
				           <option value="0" <%=isAnonymous.equals("0")?"selected=selected":""%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
				        </select>      
			        </td>
			      </tr>
			      <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
			    </TBODY>
		    </table>
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
                <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</td>
			</tr>
			</TABLE>
			
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
</form>	
<script>
function doSearch(){
	jQuery("#mainfrom").submit();
}
function doReset(){
	jQuery("#typename").val("");
	jQuery("#departmentid").val("");
	jQuery("#isApproval").val("");
	jQuery("#isAnonymous").val("");
}

function newCoworkType(){
	
	var diag=getCoworkDialog("<%=SystemEnv.getHtmlLabelNames("82,17694",user.getLanguage())%>",550,400);
	diag.URL = "CoworkTypeAdd.jsp";
	diag.ShowButtonRow=true;
	
	diag.OKEvent = function(){
		diag.innerFrame.contentWindow.doSubmit();
	};
	diag.show();
	
	diag.okButton.value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>";
	
	diag.cancelButton.value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";
	diag.CancleEvent = function(){
		diag.close();
	};
	document.body.click();
} 

function editCoworkType(id){
	var diag=getCoworkDialog("<%=SystemEnv.getHtmlLabelNames("93,17694",user.getLanguage())%>",550,400);
	diag.URL = "CoworkTypeEdit.jsp?id="+id;
	diag.ShowButtonRow=true;
	
	diag.OKEvent = function(){
		diag.innerFrame.contentWindow.onDelete();
	};
	diag.show();
	
	diag.okButton.value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>";
	
	diag.cancelButton.value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";
	diag.CancleEvent = function(){
		diag.close();
	};
	
	diag.addButton("<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>",function(){
		diag.innerFrame.contentWindow.onSave();
	})
}

function showShareEdit(id,settype){
	
    var title="<%=SystemEnv.getHtmlLabelNames("17694,68",user.getLanguage())%>:";
    title+=settype=="manager"?"<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>":"<%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%>";
	var diag=getCoworkDialog(title,550,400);
	diag.URL = "CoworkTypeShareEdit.jsp?cotypeid="+id+"&settype="+settype;
	diag.ShowButtonRow=false;
	
	diag.OKEvent = function(){
		diag.innerFrame.contentWindow.doSubmit();
	};
	diag.show();
	
	$(diag.okButton).hide();
	
	diag.cancelButton.value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>";
	diag.CancleEvent = function(){
		diag.close();
	};
	document.body.click();
} 

function getCoworkDialog(title,width,height){

    var diag = new Dialog();
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:680;
	diag.Height =height?height:420;
	diag.ShowButtonRow=false;
	diag.Title = title;
	return diag;
 }
 
 function doDelete(){
	 var ids=_xtable_CheckedCheckboxId();
	 if(ids.length==0){
		alert("<%=SystemEnv.getHtmlLabelName(30568,user.getLanguage())%>");
	 }else{
		 ids=ids.substr(0,ids.length-1);
		 alert(ids);
		 if(confirm("<%=SystemEnv.getHtmlLabelName(83062,user.getLanguage())%>")){
			 $.post("TypeOperation.jsp?operation=delete&ids="+ids,{},function(){
				 _table.reLoad();	
			 })
		 }
	 }
	 
 }
 
</script>
</BODY>
</HTML>
