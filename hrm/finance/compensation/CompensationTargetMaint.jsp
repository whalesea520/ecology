
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("Compensation:Maintenance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
String title="";
String sqlwhere=" where 1=2" ;
String subcomidstr = "";
if(subcompanyid>0){
    title=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
    String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Maintenance",-1);
    ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
    subcomidstr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
    sqlwhere=" where subcompanyid in("+subcomidstr+")";
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
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Maintenance",subcompanyid);
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
//判断是否为部门级权限
int maxlevel=0;
rs.executeSql("select c.rolelevel from SystemRightDetail a, SystemRightRoles b,HrmRoleMembers c where b.roleid=c.roleid and a.rightid = b.rightid and a.rightdetail='Compensation:Maintenance' and c.resourceid="+user.getUID()+" order by c.rolelevel");
while(rs.next()){
    int rolelevel=rs.getInt(1);
    if(maxlevel<rolelevel) maxlevel=rolelevel;
    if(rolelevel==0){
        if(user.getUserDepartment()!=departmentid)
        hasright=false;
        else
        hasright=true;
    }
}
if(user.getUID()==1){
	hasright=true;
}
if(maxlevel<1 && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19430,user.getLanguage())+"："+title;
String needfav ="1";
String needhelp ="";
ArrayList yearslist=new ArrayList();
ArrayList [] monthlist=null;
rs.executeSql("select CompensationYear from HRM_CompensationTargetInfo "+sqlwhere+" group by CompensationYear");
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
rs.executeSql("select CompensationYear,CompensationMonth from HRM_CompensationTargetInfo "+sqlwhere+" group by CompensationYear,CompensationMonth order by CompensationYear desc,CompensationMonth desc");
while(rs.next()){
    String tempyear=Util.add0(rs.getInt("CompensationYear"),4);
    String tempmonth=Util.add0(rs.getInt("CompensationMonth"),2);
    if(yearslist.indexOf(tempyear)==-1) {
        yearslist.add(tempyear);
    }
    monthlist[yearslist.size()-1].add(tempmonth);
}
int rownum=(yearslist.size()+2)/3;
//System.out.println("rownum:"+rownum);
%>
<body>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=CompensationTargetMaintEdit&isdialog=1&subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&isedit=0";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(33371,user.getLanguage())%>";
	dialog.maxiumnable=true;
	dialog.Width = 900;
	dialog.Height = 800;
	//dialog.DefaultMax=true;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

jQuery(document).ready(function(){
<%if(title.length()>0){%>
 parent.setTabObjName('<%=title%>')
 <%}%>
});
</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasright && subcompanyid>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="searchfrm" id="searchfrm" action="CompensationTargetMaint.jsp">
<input name="subCompanyId" type="hidden" value="<%=subcompanyid %>">
<input name="departmentid" type="hidden" value="<%=departmentid %>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true', 'needImportDefaultJsAndCss':'false'}">
<%
    int index=0;
    for(int i=0;i<3;i++){
     %>
 	<table width="100%">
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
		<ul><li style="padding-left:12px;line-height: 30px "><a href="javascript:onlinks('<%=yearslist.get(index)%>','<%=monthlist[index].get(m)%>');">
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
	<%
	}
	%>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
<script language="javascript">
function onlinks(years,months){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(33371,user.getLanguage())%>";
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=CompensationTargetMaintEdit&isdialog=1&subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&CompensationYear="+years+"&CompensationMonth="+months;
	dialog.Width = 900;
	dialog.Height = 800;
	dialog.maxiumnable=true;
	//dialog.DefaultMax=true;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</html>
