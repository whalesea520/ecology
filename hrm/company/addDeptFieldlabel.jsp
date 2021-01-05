
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%--<jsp:useBean id="FormManager1" class="weaver.hrm.company.FormManager" scope="session"/>--%>
<jsp:useBean id="DeptFieldManager1" class="weaver.hrm.company.DeptFieldManager" scope="session"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>

<%
	if(!HrmUserVarify.checkUserRight("DeptDefineInfo1:DeptMaintain1", user)){
		response.sendRedirect("/notice/noright.jsp");	
		return;
	}	
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#fieldlabelfrm").submit();
}
function setChange(fieldid){
	$G("checkitems").value += "field_"+fieldid+"_CN,"
	var changefieldids = $G("changefieldids").value;
	if(changefieldids.indexOf(fieldid)<0)
		$G("changefieldids").value = changefieldids + fieldid + ",";
}
function fieldlablesall0(){
	fieldlabelfrm.action="/hrm/company/deptFieldOperation.jsp";
	var checks = $G("checkitems").value;
	if(check_form(fieldlabelfrm,checks)){
		fieldlabelfrm.submit();
	}else{
		return;
	}		
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
	int formid=0;
    int subCompanyId= -1;
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	
	String fieldname_kwd = Util.null2String(request.getParameter("fieldname_kwd"));
	String fieldlabel_kwd = Util.null2String(request.getParameter("fieldlabel_kwd"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124, user.getLanguage())+SystemEnv.getHtmlLabelName(17088, user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(176, user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int operatelevel=0;

    if(detachable==1){  
        //subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DeptDefineInfo1:DeptMaintain1",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("DeptDefineInfo1:DeptMaintain1", user))
            operatelevel=2;
    }
    
    ArrayList fieldids = new ArrayList();
    ArrayList fieldnames = new ArrayList();
    ArrayList fieldlables = new ArrayList();
    ArrayList fieldlablenames = new ArrayList();
    ArrayList fieldlablenamesE = new ArrayList();
    ArrayList fieldlablenamesT = new ArrayList();
    ArrayList viewtypes = new ArrayList();
    
    String sql = "select id,fieldname,fieldlabel,viewtype from departmentDefineField where 1=1 " ;
  			if(fieldname_kwd.length()>0){
  				sql +=" and fieldname like '%"+fieldname_kwd+"%' ";
  			} 
  			
  			if(fieldlabel_kwd.length()>0){
  				sql +=" and exists (select * from HtmlLabelInfo where fieldlabel = indexid and labelname like '%"+fieldlabel_kwd+"%' )";
  			} 
  			sql += " order by viewtype,dsporder";
    RecordSet.executeSql(sql);
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldlablesall0(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
*/
%>

<%if(!ajax.equals("1")||1==1){%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="/hrm/company/addDeptFieldlabel.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="fieldlablesall0();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type="hidden" value="editfieldlabel" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="" name="changefieldids">
<input type="hidden" value="" name="checkitems">
<%
if(fieldids.size()==0){
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(31417,user.getLanguage())%></font></DIV>
</form>
<script>
function selectall(){
	window.document.fieldlabelfrm.submit();
}
</script>
</body>
</html>
<%
	return;
}
%>
<wea:layout type="table" attributes="{'cols':'4','cws':'10%,30%,30%,30%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
  <wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("15024,685",user.getLanguage())%></wea:item>
  <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)</wea:item>
<%if(GCONST.getENLANGUAGE()==1){ %>  
  <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(English)</wea:item>
<%} %>  
  <%if(GCONST.getZHTWLANGUAGE()==1){ %>
  <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=LanguageComInfo.getLanguagename("9")%>)</wea:item>
  <%} %>
<%
for(int tmpcount=0; tmpcount< fieldids.size(); tmpcount++){
	String id = (String)fieldids.get(tmpcount);
	String fieldname = (String)fieldnames.get(tmpcount);
	String fieldlablename = (String)fieldlablenames.get(tmpcount);
	String fieldlablenameE = Util.null2String((String)fieldlablenamesE.get(tmpcount));
	String fieldlablenameT = Util.null2String((String)fieldlablenamesT.get(tmpcount));
	String viewtype = (String)viewtypes.get(tmpcount);
%>
<wea:item><%=fieldname%></wea:item>
<wea:item>
	<input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_CN" value="<%=fieldlablename%>" onchange="checkinput('field_<%=id%>_CN','field_<%=id%>_CN_span');setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"><span id=field_<%=id%>_CN_span></span>
</wea:item>
<%if(GCONST.getENLANGUAGE()==1){ %>
<wea:item><input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_En" value='<%=fieldlablenameE%>' onchange="setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></wea:item>
<%
}
%>
<%if(GCONST.getZHTWLANGUAGE()==1){ %>
  <wea:item>
	<input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_TW" value="<%=fieldlablenameT%>" onchange="setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></wea:item>
<%} %>
<%
}
%>
</wea:group>
</wea:layout>
</body>

</html>
