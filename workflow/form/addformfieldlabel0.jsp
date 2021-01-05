<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="FormFieldlabelMainManager" class="weaver.workflow.form.FormFieldlabelMainManager" scope="page" />
<%FormFieldlabelMainManager.resetParameter();%>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
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
	if (!HrmUserVarify.checkUserRight(formRightStr, user) || operateLevel < 0) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

    String ajax=Util.null2String(request.getParameter("ajax"));
    String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isValue = Util.null2String(request.getParameter("isValue"));
	String formname="";
	String formdes="";
    int subCompanyId2 = -1;
    int subCompanyId= -1;
    String subCompanyId3 = "";
	
	
	RecordSet.executeSql("select * from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
		formdes = RecordSet.getString("formdes");
		formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
		formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	  subCompanyId2 = RecordSet.getInt("subcompanyid");
	  subCompanyId3 = RecordSet.getString("subcompanyid3");
	  subCompanyId = subCompanyId2;
		formdes = Util.StringReplace(formdes,"\n","<br>");
	}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(176,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";

    if(isFromMode==1){
    	detachable=Util.getIntValue(String.valueOf(session.getAttribute("fmdetachable")),0);
    }
    int operatelevel=0;

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
    
    ArrayList fieldids = new ArrayList();
    ArrayList fieldnames = new ArrayList();
    ArrayList fieldlables = new ArrayList();
    ArrayList fieldlablenames = new ArrayList();
    ArrayList fieldlablenamesE = new ArrayList();
    ArrayList fieldlablenamesT = new ArrayList();
    ArrayList viewtypes = new ArrayList();
    if(formid!=0)
    	RecordSet.executeSql("select id,fieldname,fieldlabel,viewtype from workflow_billfield where billid="+formid+" order by viewtype,detailtable,dsporder");
  	while(RecordSet.next()){//取得表单的所有字段及字段显示名
    	int tempFieldLableId = RecordSet.getInt("fieldlabel");
    	fieldids.add(RecordSet.getString("id"));
    	fieldnames.add(RecordSet.getString("fieldname"));
    	fieldlables.add(""+tempFieldLableId);
    	fieldlablenames.add(SystemEnv.getHtmlLabelName(tempFieldLableId,7));
    	fieldlablenamesE.add(SystemEnv.getHtmlLabelName(tempFieldLableId,8));
    	fieldlablenamesT.add(SystemEnv.getHtmlLabelName(tempFieldLableId,9));
    	viewtypes.add(RecordSet.getString("viewtype"));
    }
%>
<script>
rowindex = 0;
</script>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
%>
	  <%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self}" ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldlablesall0(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
%>

<%
if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addform.jsp?src=editform&formid="+formid+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(82022, user.getLanguage())%>"/>
</jsp:include>
<%}%>
<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="/workflow/form/form_operation.jsp">
<input type="hidden" value="editfieldlabel" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="<%=isFromMode %>" name="isFromMode">
<input type="hidden" value="" name="changefieldids">
<input type="hidden" value="" name="checkitems">
<input type="hidden" value="<%=dialog %>" name="dialog">
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel>0){%>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top"  onclick="javascript:fieldlablesall0()">
    			<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table> 
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%>'>
    	<wea:item attributes="{'isTableList':'true'}">
			<table cols=4 id="oTable" class=ListStyle cellspacing=0   width="100%">
				<colgroup>
					<col width="10%">
					<col width="30%">
					<col width="28%">			 
					<%if(GCONST.getZHTWLANGUAGE()==1){ %>
					<col width="32%">
					<%} %>
				</colgroup>
				<tr class=header>
					<th><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)</th>
					<th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(English)</th>
					<%if(GCONST.getZHTWLANGUAGE()==1){ %>
					<th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(33598,user.getLanguage())%>)</th>
					<%} %>
				</tr>
				<%
				int colorcount1 = 1;
				
				for(int tmpcount=0; tmpcount< fieldids.size(); tmpcount++){
					String id = (String)fieldids.get(tmpcount);
					String fieldname = (String)fieldnames.get(tmpcount);
					String fieldlablename = (String)fieldlablenames.get(tmpcount);
					String fieldlablenameE = Util.null2String((String)fieldlablenamesE.get(tmpcount));
					String fieldlablenameT = Util.null2String((String)fieldlablenamesT.get(tmpcount));
					String viewtype = (String)viewtypes.get(tmpcount);
				%>
				<tr class="DataLight">
					<td>
					<%=fieldname%>       
					<%if(viewtype.equals("1")){%>
					<%="["+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+"]"%>
					<%}%>
					</td>
					<td>
						<input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_CN" value="<%=fieldlablename%>" onchange="checkinput('field_<%=id%>_CN','field_<%=id%>_CN_span');setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"><span id=field_<%=id%>_CN_span></span>
					</td>
					<td><input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_En" value="<%=fieldlablenameE%>" onchange="setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></td>
					<%if(GCONST.getZHTWLANGUAGE()==1){ %>
					<td><input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_TW" value="<%=fieldlablenameT%>" onchange="setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></td>
					<%} %>
				</tr>
				<%}%>
			</table>    	
    	</wea:item>
    </wea:group>
</wea:layout>
</form>
<%if("1".equals(dialog)){ %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 50px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
</body>
</html>
<script type="text/javascript">

if("<%=dialog%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	function btn_cancle(){
		parentWin.closeDialog();
	}
}

if("<%=isclose%>"==1){
        alert(12);
		var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
		alert(34);
		if("<%=isValue%>" == 1){
		 parentWin.location="/workflow/form/editformfield.jsp?formid="+<%=formid%>+"&ajax=0";
		}
		//parent.parentWin.closeDialog();
		dialog.close();
}

jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});
function fieldlablesall0(){
	var checks = document.all("checkitems").value;
	if(check_form(fieldlabelfrm,checks)){
		fieldlabelfrm.submit();
	}else{
		return;
	}		
}

function setChange(fieldid){
	document.all("checkitems").value += "field_"+fieldid+"_CN,"
	var changefieldids = document.all("changefieldids").value;
	if(changefieldids.indexOf(fieldid)<0)
		document.all("changefieldids").value = changefieldids + fieldid + ",";
}
</script>
