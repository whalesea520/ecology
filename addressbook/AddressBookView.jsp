
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String sqlwhere = " where (status = 0 or status = 1 or status = 2 or status = 3) and status != 10 ";

String organizationtype = Util.null2String(request.getParameter("organizationtype"));
String organizationid = Util.null2String(request.getParameter("organizationid"));

if("1".equals(organizationtype)){
	
	sqlwhere += " and subcompanyid1 = " + organizationid + " ";
	
} else if("2".equals(organizationtype)){
	
	sqlwhere += " and departmentid = " + organizationid + " ";
	
}


int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();

RecordSet.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(RecordSet.next()){
	perpage =Util.getIntValue(RecordSet.getString(36),-1);
}

if(perpage<=1 )	perpage=10;

String backfields = "hrmresource.id,lastname,workcode,departmentid,email,telephone,mobile,jobtitle,managerid,dsporder,subcompanyid1,accounttype";
String sqlWhere = " "+sqlwhere;
String fromSql  = " from HrmResource left join cus_fielddata on hrmresource.id=cus_fielddata.id and cus_fielddata.scopeid=1 ";
String orderby = " dsporder,lastname" ;
String tableString = "";
boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",user.getUID()+"");

tableString =" <table instanceid=\"hrmDetailTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"hrmresource.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
"			<head>"+
"				<col width=\"100%\" text=\"\" column=\"id\" transmethod=\"weaver.addressbook.AddressBookUtil.getAddressBookUserInfo\" />"+
"			</head>"+
" </table>";
			 
String sql = "SELECT " + backfields + " " + fromSql + " " + sqlWhere + " ORDER BY " + orderby;

%>


<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">

    <tr><td height="10" colspan="3"></td></tr>
    <tr>
        <td ></td>
        <td valign="top">
        <TABLE class=Shadow>
            <tr>
                <td valign="top">
                    <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" />
                    <FORM id=weaver name=frmMain action="AddressBookView.jsp" method=post>
                        <input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>" >
                    </FORM>
                </td>
            </tr>
        </TABLE>
        </td>
        <td></td>
    </tr>
    <tr><td height="10" colspan="3"></td></tr>
</table>



</body>
</html>
