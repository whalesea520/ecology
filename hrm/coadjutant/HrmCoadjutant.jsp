<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("subCompanyId"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+id);
String operation = Util.null2String(request.getParameter("operation"));
String sql="";
if(id<1)
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=SystemEnv.getHtmlLabelName(83469,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
if(operation.equals("save")){
    String[] departmentids=request.getParameterValues("departmentid");
    String[] coadjutants=request.getParameterValues("coadjutant");
    if(departmentids!=null&&departmentids.length>0){
        for(int i=0;i<departmentids.length;i++){
            sql="update hrmdepartment set coadjutant="+Util.getIntValue(Util.null2String(request.getParameter("coadjutant_"+departmentids[i])),0)+" where id="+departmentids[i];
            //System.out.println(sql);
            rs.executeSql(sql);
        }
        DepartmentComInfo.removeCompanyCache();
        DepartmentComInfo.getDepartmentInfo();
        msgid=1;
    }
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+subcompanyname;
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int sublevel=0;

if(detachable==1){
    sublevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmDepartmentAdd:Add",id);
}else{
    if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
        sublevel=2;
    }
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(sublevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="HrmCoadjutant.jsp?id=<%=id%>" method=post >

<%
if(msgid!=-1){
%>
<script type="text/javascript">
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
</script>
<%}%>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="40%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SubComanyComInfo.getSubCompanyname(""+id)%></TH>
  </TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%></TD>
    </TR>

<%
    int needchange = 0;
      while(DepartmentComInfo.next()){
      	String cursubcompanyid = DepartmentComInfo.getSubcompanyid1();
        String coadjutant=DepartmentComInfo.getCoadjutant();
        String deptid=DepartmentComInfo.getDepartmentid();
        String canceled = DepartmentComInfo.getDeparmentcanceled();

      	if(!cursubcompanyid.equals(""+id)|| "1".equals(canceled)) continue;
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=deptid%>" target="_black"><%=DepartmentComInfo.getDepartmentname()%></a>
    <INPUT id=departmentid type=hidden name=departmentid value="<%=deptid%>">
    </TD>
    <TD><%=DepartmentComInfo.getDepartmentmark()%>
    </TD>
    <TD>

        <INPUT class="wuiBrowser" id="coadjutant_<%=deptid%>" type=hidden name="coadjutant_<%=deptid%>" value="<%=coadjutant%>"
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=HrmDepartmentAdd:Add"
		_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}' target='_black'>#b{name}</A>"
		_displayText="<%=ResourceComInfo.getLastname(coadjutant)%>">
    </TD>
  </TR>
<%
    }
%>
 </TBODY></TABLE>
 <input class=inputstyle type=hidden name=operation value="save">
 <input class=inputstyle type=hidden name=subCompanyId value="<%=id%>">
 </form>
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

<script language=vbs>
sub onShowResource(spanname,fieldname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=HrmDepartmentAdd:Add")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"' target='_black'>"&id(1)&"</A>"
	fieldname.value=id(0)
	else
	spanname.innerHtml = ""
	fieldname.value=""
	end if
    else
	end if
end sub
</script>
 <script>
function onSave(obj) {
 frmMain.submit();
}
 </script>
</BODY>
</HTML>