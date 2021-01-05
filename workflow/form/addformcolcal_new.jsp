<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LabelInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<HTML><HEAD>

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
	String dialog = Util.null2String(request.getParameter("dialog"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver_wev8.js"></script>
<script  type="text/javascript">
function afterDoWhenLoaded(){
	jQuery(".sbSelector").closest("td").removeAttr("title");
	jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   	jQuery(this).tzCheckbox({labels:['','']});
	  }
	});
}
</script>
</head>

<%
	String formname="";
	String formdes="";
	String createtype = Util.null2String(request.getParameter("createtype")) ;	
    int subCompanyId2 = -1;
    String subCompanyId3 = "";
    int subCompanyId= -1;
	if(formid!=0)
		RecordSet.executeSql("select * from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
		formdes = RecordSet.getString("formdes");
		formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
		formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	  subCompanyId = RecordSet.getInt("subcompanyid");
	  subCompanyId3 = RecordSet.getString("subcompanyid3");
	  subCompanyId2 = subCompanyId;
		formdes = Util.StringReplace(formdes,"\n","<br>");
	}


    String colcalstr = "";
    String maincalstr = "";
    ArrayList mainid = new ArrayList();
    ArrayList mainlable = new ArrayList();
    String sql = "select * from workflow_formdetailinfo where formid ="+formid;
    if(formid!=0) RecordSet.executeSql(sql);
    if(RecordSet.next()){
        colcalstr = RecordSet.getString("colcalstr");
        maincalstr = RecordSet.getString("maincalstr");
    }

    sql = "select * from workflow_billfield where viewtype=0 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid+" order by id";
    if(formid!=0) RecordSet.executeSql(sql);
    while(RecordSet.next()){
        mainid.add(RecordSet.getString("id"));
        mainlable.add(SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage()));
    }

    sql = "select * from workflow_billfield where viewtype=1 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid+" order by detailtable, dsporder, id";
    if(formid!=0) RecordSet.executeSql(sql);

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

%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6074,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(18369,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";
boolean canEdit = false;
%>





<body onclick="window_onload()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(operatelevel>0){
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveRole(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:colsaveRole(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;

if(!ajax.equals("1")){
if(createtype.equals("2")) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",FormDesignMain.jsp?src=editform&formid="+formid+",_self}" ;
}
else {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addform.jsp?src=editform&formid="+formid+",_self}" ;
}

RCMenuHeight += RCMenuHeightStep ;
}
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
<form name="colcalfrm" method="post" action="/workflow/form/formrole_operation0.jsp" >
<input type="hidden" value="colcalrole" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=isFromMode %>" name="isFromMode">
<input type="hidden" value="<%=createtype%>" name="createtype">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" name="isView" value="1"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel>0){ %>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top"  onclick="javascript:colsaveRole()">
    			<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())+SystemEnv.getHtmlLabelName(579,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<table class="ListStyle" cellspacing=0 id="oTable" style="height:400;overflow-x:hidden;overflow-y:auto;">
				<colgroup>
					<col width="35%">
					<col width="20%">
					<col width="35%">
				</colgroup>
				<tr class=header>
					<th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(18746,user.getLanguage())%></th>
				</tr>
				<%
				while(RecordSet.next()){
				%>
				<tr class="DataLight">
					<td><%=SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage())%></td>
					<td>
						<input type="checkbox" name="sumcol_<%=RecordSet.getString("id")%>" tzCheckbox="true" value="<%=RecordSet.getString("id")%>" <%=(colcalstr.indexOf("detailfield_"+RecordSet.getString("id"))==-1?"":"checked")%>>
					</td>
					<td>
						<input type="hidden" name="detailfield" value="<%=RecordSet.getString("id")%>">
						<select name="mainfield<%=RecordSet.getString("id")%>" style="width:60%">
						<option value="">
						<%
						for(int i=0; i<mainid.size();i++){
						%>
						<option value="<%=mainid.get(i)%>" <%=(maincalstr.indexOf("mainfield_"+mainid.get(i)+"=detailfield_"+RecordSet.getString("id"))==-1?"":"selected")%>><%=mainlable.get(i)%>
						<%}%>
						</select>
					</td>
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
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 50px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%}%>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function saveRole(){
    colcalfrm.submit();
}
</script>
<%}else{%>
<script type="text/javascript">
	function colsaveRole(){
    jQuery("select").each(function(){
        $(this).removeAttr("disabled");
    });
    colcalfrm.submit();
   }
</script>
<%} %>
</body>
</html>
