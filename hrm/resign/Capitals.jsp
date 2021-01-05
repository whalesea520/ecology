<%@ page import="weaver.general.Util,
                 weaver.hrm.resign.ResignProcess,
                 weaver.hrm.resign.CapitalDetail" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>



<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>


<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<%
String id=Util.null2String(request.getParameter("id"));
//当前用户为记录本人或者其上级或者具有“离职审批”权限则可查看此页面
String userId = "" + user.getUID();
String managerId = ResourceComInfo.getManagerID(id);
if(!userId.equals(id) && !userId.equals(managerId) && !HrmUserVarify.checkUserRight("Resign:Main", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17574,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%





boolean hasNextPage=false;


int total=Util.getIntValue(Util.null2String(request.getParameter("total")),1);
int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
ArrayList capitals=ResignProcess.getCapitalsDetail(id,start,perpage,user.getLanguage());
if(total>start*perpage){
	hasNextPage=true;
}


%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;"><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmmain method=post action="Capitals.jsp">
<input name=start type=hidden value="<%=start%>">
<input name=total type=hidden value="<%=total%>">
<input name=id type=hidden value="<%=id%>">
<input name=perpage type=hidden value="<%=perpage%>">
</form>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  
  <TR class=HeaderForXtalbe>
  <th ><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></th>
  <th ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th ><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></th>
  <th ><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></th>
  <th ><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%></th>
  <th ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></th>
  <th ><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
  <th ><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></th>
  </tr>
  <%
boolean islight=true;
int totalline=1;

Iterator iter=capitals.iterator();
while(iter.hasNext()){
        CapitalDetail capital=(CapitalDetail)iter.next();
	 String tempid = capital.getId();
         String tempmark = capital.getNo();
	String tempname = capital.getName();
	String tempcapitalspec = capital.getType();
	String tempcapitalgroupid = capital.getGroup();
	String tempresourceid = capital.getUserid();
	String tempdepartmentid = capital.getDeptid();
	String tempstateid =  capital.getStatus();
        String remark =  capital.getRemark();
	
	
%>
    <tr <%if(islight){%> class=DataLight <%} else {%> class=DataLight <%}%>>
    <td >
    <% if(!HrmUserVarify.checkUserRight("CptCapital:Discard",user)) {%>
	<%=Util.toScreen(tempmark,user.getLanguage()) %>
	<%}else{%>
	<a href="/cpt/capital/CptCapitalBack.jsp?capitalid=<%=tempid%>"><%=Util.toScreen(tempmark,user.getLanguage())%></a>
	
   <%}%>   
  </td>
  <td ><a href="/cpt/capital/CptCapital.jsp?id=<%=tempid%>"><%=Util.toScreen(tempname,user.getLanguage())%></a>
  </td>
  <td ><%=Util.toScreen(tempcapitalspec,user.getLanguage())%>
  </td>
  <td ><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(tempcapitalgroupid),user.getLanguage())%>
  </td>
  <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=tempresourceid%>">
	  <%=Util.toScreen(ResourceComInfo.getResourcename(tempresourceid),user.getLanguage())%></a></TD>
  <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=tempdepartmentid%>">
	 <%=Util.toScreen(DepartmentComInfo.getDepartmentname(tempdepartmentid),user.getLanguage())%></a></TD>
    <TD><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(tempstateid),user.getLanguage())%></TD>
    <TD><%=Util.toScreen(remark,user.getLanguage())%></TD>
  </tr>
  

<%
	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}
%>
  </tbody>
</table>


<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
   <%if(start>1){%>
   <%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:OnChangePage("+(start-1)+"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
     <%}%>
 <td><%if(hasNextPage){%>
      <%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:OnChangePage("+(start+1)+"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>     <%}

if(HrmUserVarify.checkUserRight("CptCapital:Discard",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(15305,user.getLanguage())+",javascript:jsCptCapitalBack(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  </td>
		</tr>
		</TABLE>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<SCRIPT language="javascript">
function OnChangePage(start){
        document.frmmain.start.value = start;
		document.frmmain.submit();
}

function returnMain(){
        window.location="/hrm/resign/Resign.jsp?resourceid=<%=id%>";
}

function jsCptCapitalBack(){
	openFullWindowHaveBar("/cpt/capital/CptCapitalBack.jsp");
}
</script>
</BODY></HTML>