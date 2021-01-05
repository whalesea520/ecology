
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("PieceRate:maintenance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
String title="";
String sqlwhere=" where 1=2" ;
if(subcompanyid>0){
    title=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
    sqlwhere=" where subcompanyid="+subcompanyid;
}
if(departmentid>0){
    title=DepartmentComInfo.getDepartmentname(""+departmentid);
    subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
    sqlwhere=" where departmentid="+departmentid;
}
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"PieceRate:maintenance",subcompanyid);
    if(operatelevel==-1){
            response.sendRedirect("/notice/noright.jsp");
            return;
    }
    if(operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}

String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19377,user.getLanguage())+"："+title;
String needfav ="1";
String needhelp ="";
ArrayList yearslist=new ArrayList();
ArrayList [] monthlist=null;
rs.executeSql("select PieceYear from HRM_PieceRateInfo "+sqlwhere+" group by PieceYear");
if(rs.next()){
    if(rs.getCounts()>0){
    monthlist=new ArrayList[rs.getCounts()];
    }
}
if(monthlist!=null){
for(int i=0;i<monthlist.length;i++){
    monthlist[i]=new ArrayList();
}
}
rs.executeSql("select PieceYear,PieceMonth from HRM_PieceRateInfo "+sqlwhere+" group by PieceYear,PieceMonth order by PieceYear desc,PieceMonth desc");
while(rs.next()){
    String tempyear=Util.add0(rs.getInt("PieceYear"),4);
    String tempmonth=Util.add0(rs.getInt("PieceMonth"),2);
    if(yearslist.indexOf(tempyear)==-1) {
        yearslist.add(tempyear);
    }
    monthlist[yearslist.size()-1].add(tempmonth);
}
int rownum=(yearslist.size()+2)/3;
//System.out.println("rownum:"+rownum);
%>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",PieceRateMaintenanceEdit.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+",_self} " ;
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
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class="ViewForm">

   <tr class=field>
        <td width="30%" align=left valign=top>
<%
    int index=0;
    for(int i=0;i<3;i++){
     %>
 	<table class="ViewForm">
		<tr>
		  <td>
 	<%
     for(int k=1;k<=rownum;k++){
     if(yearslist.size()>((k-1)*3+i)){
    %>
	<ul><li><b><%=yearslist.get(index)%><%=SystemEnv.getHtmlLabelName(17138,user.getLanguage())%></b>
	<%
         if(monthlist.length>index){
         for(int m=0;m<monthlist[index].size();m++){
	%>
		<ul><li><a href="javascript:onlinks('<%=yearslist.get(index)%>','<%=monthlist[index].get(m)%>');">
		<%=monthlist[index].get(m)%><%=SystemEnv.getHtmlLabelName(19398,user.getLanguage())%></a></ul></li>
	<%
        }
        }
    %>
		</ul></li>
    <%
    if(k<rownum-1){
    %>
    </td></tr><tr><td>
    <%
        }
        index++;
        }
        }
    %>
    </td></tr>
    </table>
	</td><td width="30%" align=left valign=top>
	<%
	}
	%>
	</td>
  </tr>
</table>
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

</body>
<script language="javascript">
function onlinks(years,months){
	location="PieceRateMaintenanceView.jsp?subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&PieceYear="+years+"&PieceMonth="+months;
}
</script>
</html>