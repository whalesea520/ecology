<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<style type="text/css">
TH.efftfth {
	width:30px!important;
}
</style>

<%
String formRightStr = "FormManage:All";
int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
if(isFromMode==1){
	formRightStr = "FORMMODEFORM:ALL";
}

int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),-1);
int operateLevel = UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,formRightStr,formid,isbill);
if(!HrmUserVarify.checkUserRight(formRightStr, user) || operateLevel < 0){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int isformadd = Util.getIntValue(request.getParameter("isformadd"),0);
    if(!ajax.equals("1")){
			%>
			<script language=javascript src="/js/weaver_wev8.js"></script>
			<%
    }
%>

</head>
<%

	String type="";
	String formname="";
	String formdes="";
	String tablename="";
    int subCompanyId2 = -1;
    String subCompanyId3 = "";
	
	RecordSet.executeSql("select isvirtualform from ModeFormExtend where formid="+formid);
	int isvirtualform = 0;
	if(RecordSet.next()){
		isvirtualform = RecordSet.getInt("isvirtualform");
	}
	
    if(isFromMode==1){
    	detachable=Util.getIntValue(String.valueOf(session.getAttribute("fmdetachable")),0);
    }
    int subCompanyId= -1;
    int operatelevel=0;

RecordSet.executeSql("select * from workflow_bill where id="+formid);
if(RecordSet.next()){
	tablename = RecordSet.getString("tablename");
	formname = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
	formdes = RecordSet.getString("formdes");
    if(formname != null){
        formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
    }
    if(formdes != null){
        formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
    }
	subCompanyId = RecordSet.getInt("subcompanyid");
	subCompanyId3 = RecordSet.getString("subcompanyid3");
	subCompanyId2 = subCompanyId;
	formdes = Util.StringReplace(formdes,"\n","<br>");
}
    if(detachable==1){  
        //subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(isFromMode==1){
	        if(subCompanyId3.equals("")){
	        	subCompanyId3 = ""+user.getUserSubCompany1();
	        }
	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),formRightStr,Util.getIntValue(subCompanyId3,-1));
        }else{
	        if(subCompanyId == -1){
	            subCompanyId = user.getUserSubCompany1();
	        }
	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),formRightStr,subCompanyId);
        }
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }
	
    subCompanyId2 = subCompanyId;

boolean canDelete = true;
String sql_tmp = "";
if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
	sql_tmp = "select * from "+tablename+" where rownum<2";
}else{
	sql_tmp = "select top 1 * from "+tablename;
}
RecordSet.executeSql(sql_tmp);//如果表单已使用，则表单字段不能删除
if(RecordSet.next()) canDelete = false;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":";
String needfav ="";
if(!ajax.equals("1")){
	needfav ="1";
}
String needhelp ="";
titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());

String paramessage=Util.null2String(request.getParameter("message"));
if(paramessage.equals("nodelete")) paramessage = SystemEnv.getHtmlLabelName(22410,user.getLanguage());
if(paramessage.equals("nodeleteForSubWf")) paramessage = SystemEnv.getHtmlLabelName(24311,user.getLanguage());
if(paramessage.equals("modifyFieldtypeError")) paramessage = SystemEnv.getHtmlLabelName(129055, user.getLanguage());
%>  
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<form name="editformfieldtab" method="post" action="/workflow/form/form_operation.jsp" >
<input type="hidden" value="listDelete" name="src">
<input type="hidden" value="" name="deleteids">
<input type="hidden" value="<%=isFromMode %>" name="isFromMode">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_FORM_EDITFORMFIELD %>"/>
<%
    if(operatelevel>0){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(17998,user.getLanguage())+",javascript:addField(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(17998,user.getLanguage())+",javascript:batchAddField(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:editorField(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
    }
	if(operatelevel>0){
	    if(isvirtualform==0){
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteData(),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
	    }
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<font color="red"><%=paramessage%></font>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<% if(operatelevel>0){%>
	    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(83476, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="addField()">
	    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(25055, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="batchAddField()">				
	    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(26473, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="editorField()">
				<%} %>
    			<%if(operatelevel>0&&isvirtualform==0){ %>				
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="deleteData()">
    			<%} %>				
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<wea:layout type="twoCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
		<%
		String backfields = " id,fieldname,fieldlabel,viewtype,fieldhtmltype,type,dsporder,detailtable ";
		String sqlFrom = " workflow_billfield ";
		String sqlWhere = "";
		if(isFromMode == 1){
			sqlWhere = " where billid="+formid+" and fieldhtmltype <>'9' ";
			if(formid==0) sqlWhere =  " where 1=2  and fieldhtmltype <>'9' ";
		}else{
			sqlWhere = " where billid="+formid+" ";
			if(formid==0) sqlWhere =  " where 1=2  ";
		}
		String orderby  = " viewtype,detailtable,dsporder ";
		String tabletype = "checkbox";
		//if(canDelete) tabletype = "checkbox";
		String tableString=""+
		    "<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FORM_EDITFORMFIELD,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
		    " <checkboxpopedom    popedompara=\"column:fieldname+column:viewtype+column:fieldhtmltype+column:detailtable+"+formid+"+column:type\" showmethod=\"weaver.general.FormFieldTransMethod.getCanCheckBox\" />"+
		    "<sql backfields=\"" + backfields + "\" sqlisdistinct=\"true\" sqlform=\"" + sqlFrom + "\" sqlprimarykey=\"id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
		    "<head>"+
		    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\" orderkey=\"fieldname\" transmethod=\"weaver.general.FormFieldTransMethod.getFieldDetail\" otherpara=\"column:id+"+formid+"+"+isFromMode+"\" />"+
		    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"fieldlabel\" orderkey=\"fieldlabel\" transmethod=\"weaver.general.FormFieldTransMethod.getFieldname\" otherpara=\""+user.getLanguage()+"\" />"+
		    "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\" column=\"viewtype\" orderkey=\"viewtype\" transmethod=\"weaver.general.FormFieldTransMethod.getViewType\" otherpara=\""+user.getLanguage()+"\" />"+		
		    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"fieldhtmltype\" orderkey=\"fieldhtmltype\" transmethod=\"weaver.general.FormFieldTransMethod.getHTMLType\" otherpara=\""+user.getLanguage()+"\" />"+	
		    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" transmethod=\"weaver.general.FormFieldTransMethod.getFieldType\" otherpara=\"column:fieldhtmltype+column:id+"+user.getLanguage()+"\" />"+		
		    "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\"  />"+	    
		    "</head>"+
		    "</table>";
		%>			
		<wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>		
		</wea:item>
	</wea:group>    
</wea:layout>
</form>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function submitData(obj)
{
	if (check_form(addformtabf,'formname,subcompanyid')){
		addformtabf.submit();
        obj.disabled=true;
    }
}
function deleteData(){
    if(_xtable_CheckedCheckboxId()==""){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
        return;
    }else{
    	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
    		top.Dialog.confirm(str, function (){
    		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22288,user.getLanguage())%>", function (){
            	document.all("deleteids").value = _xtable_CheckedCheckboxId();
                editformfieldtab.submit();
            }, function () {}, 320, 90,true);	
    	}, function () {}, 320, 90,true);	
    }
}

	function adfonShowSubcompany(){
		 datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids="+$GetEle("subcompanyid").value);
		 issame = false;
		 if(datas){
		 if(datas.id!="0"&&datas.id!=""){
			 if(datas.id ==  $GetEle("subcompanyid").value){
			   issame = true;
			 }
			// document.getElementById("subcompanyspan1").innerHtml = datas.name;
			 $GetEle("subcompanyspan1").innerHTML = datas.name;
			  $GetEle("subcompanyid").value=datas.id;
			 }else{
				 $GetEle("subcompanyspan1").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				 $GetEle("subcompanyid").value="";
			 }
		 }
	}
	
function addField(){
  displaywindow("<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>","/workflow/field/addfield0.jsp?formid="+<%=formid%>+"&dialog=1&isFromMode=<%=isFromMode%>");
}
function batchAddField(){
  displaywindow("<%=SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>","/workflow/form/addfieldbatch.jsp?formid="+<%=formid%>+"&dialog=1&isFromMode=<%=isFromMode%>");
}
function editorField(){
  displaywindow("<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>","/workflow/form/editfieldbatch.jsp?formid="+<%=formid%>+"&dialog=1&isFromMode=<%=isFromMode%>");
}

function displaywindow(title,url){
     diag_vote = new window.top.Dialog();
     diag_vote.currentWindow = window;	
     diag_vote.Width = 1020;
     diag_vote.Height = 580;
     diag_vote.Modal = true;
     diag_vote.Title = title
	 diag_vote.URL = url;
	 diag_vote.isIframe=false;
	 diag_vote.maxiumnable = true;
	 diag_vote.show();
}	
</script>
<!--  <script language="VBScript">
sub adfonShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids="&addformtabf.subcompanyid.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = addformtabf.subcompanyid.value then
		issame = true
	end if
	subcompanyspan1.innerHtml = id(1)
	addformtabf.subcompanyid.value=id(0)
	else
	subcompanyspan1.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	addformtabf.subcompanyid.value=""
	end if
	end if
end sub
</script>-->
<%}%>
</body>
</html>
