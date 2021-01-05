<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.*" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<html>
<%
if(!HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body>
<%
int userid = user.getUID();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(172,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15775,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contract/HrmContract.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
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
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>   
    <COL width="30%">
    <COL width="30%"> 
    <COL width="40%"> 
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></TH>
  </TR>
  
  <TR class=Header>
  
    <TD><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15786,user.getLanguage())%></TD>    
      
    <TD><%=SystemEnv.getHtmlLabelName(15787,user.getLanguage())%></TD>        
  </TR>  
 
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
  String  departmentid = Util.null2String(request.getParameter("departmentid"));
  String subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
  int needchange = 0;
  String sql = "";
  String temp = "";
  if(detachable==1){
  		sql = "select type.id,type.typename,type.saveurl,type.contracttempletid,type.ishirecontract,type.remindaheaddate,template.templetname,template.templetdocid from HrmContractType type,HrmContractTemplet template WHERE type.contracttempletid = template.ID and type.subcompanyid = "+subcmpanyid1+" order by type.id";  
  }else{
  		sql = "select type.id,type.typename,type.saveurl,type.contracttempletid,type.ishirecontract,type.remindaheaddate,template.templetname,template.templetdocid from HrmContractType type,HrmContractTemplet template WHERE type.contracttempletid = template.ID order by type.id";  
	}
  String id="";
  String typename="";
  String saveurl="";
  String templetid="";
  String templetname="";
  String templetdocid ="";
  int ishire,aheaddate;
  
  int pathNumber;
  String path;

  rs.executeSql(sql);
  while(rs.next()){
    id = Util.null2String(rs.getString("id"));
    typename  = Util.null2String(rs.getString("typename"));
    saveurl  = Util.null2String(rs.getString("saveurl"));  

	pathNumber = Util.getIntValue(saveurl,-1);
	path = CategoryUtil.getCategoryPath(pathNumber);

    templetid  = Util.null2String(rs.getString("contracttempletid"));
	templetname =Util.null2String(rs.getString("templetname"));
	templetdocid = Util.null2String(rs.getString("templetdocid"));
    if(needchange%2==0){
      
%>  
    <TR class=datalight>
<%
    }else{    
%>
    <TR class=datadark>
<%
}
%>    

    <td><a href="HrmContractAdd.jsp?id=<%=id%>&templetdocid=<%=templetdocid%>&subcompanyid=<%=subcmpanyid1%>"><%=typename%></a></td> 
    <td>

    <a href="/docs/mouldfile/DocMouldDsp.jsp?id=<%=templetdocid%>&urlfrom=hr&subcompanyid=<%=subcmpanyid1%>"><%=templetname%></a>
   
    </td>
      
    <td><%=path.equals("/")?"":"/"+path%></td>
<%
  needchange++;
  }
%>  
</tbody>      
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</body>
</html>