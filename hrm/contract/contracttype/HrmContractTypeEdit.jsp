<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<html>
<%
if(!HrmUserVarify.checkUserRight("HrmContractTypeView:View", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<%
String id = Util.null2String(request.getParameter("id"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(716,user.getLanguage());
String needfav ="1";
String needhelp ="";

String typename = "";
int saveurl = -1;
String templetid = "";
String ishirecontract = "";
String remindaheaddate = "";
String remindman = "";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String usertype = user.getLogintype();
String mainid=Util.null2String(request.getParameter("mainid"));
String subid=Util.null2String(request.getParameter("subid"));
int secid = 0;
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"));
String sql = "select * from HrmContractType where id = "+id;
rs.executeSql(sql);
while(rs.next()){    
     typename  = Util.null2String(rs.getString("typename"));
     saveurl  = Util.getIntValue(rs.getString("saveurl"),-1);
     templetid  = Util.null2String(rs.getString("contracttempletid"));
     ishirecontract = Util.null2String(rs.getString("ishirecontract"));
     remindaheaddate = Util.null2String(rs.getString("remindaheaddate"));
     remindman = Util.null2String(rs.getString("remindman"));
}    

String path = "";
if (saveurl != -1) {
    path = "/"+CategoryUtil.getCategoryPath(saveurl);
}%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmContractTypeEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmContractType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+81+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contracttype/HrmContractType.jsp?subcompanyid1="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

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

<FORM id=contracttype name=contracttype action="HrmConTypeOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<TABLE class=ViewForm>
  <COLGROUP>   
    <COL width="15%">
    <COL width="85%">     
  <TBODY>
  <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%></TH>
  </TR>
  <TR class= Spacing style="height:2px">
    <TD class=Line1 colSpan=3 ></TD>
  </TR>
<%
%>  
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%> </TD>
    <td class=Field>
       <%=typename%>
    </td>
  </tr>   
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%if(detachable==1){%>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
<td width=85% class=field>
<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>
</td>
</tr>
<%}%>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <TD><%=SystemEnv.getHtmlLabelName(15786,user.getLanguage())%></TD>  
    <td class=Field>
<%
  sql = "select templetname from HrmContractTemplet where id = "+templetid;
  
  rs2.executeSql(sql);
  String templetname = "";
  while(rs2.next()){
    templetname = rs2.getString("templetname");
  }  
%>     
        <%=templetname%>
    </td>  
  </TR>  
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15791,user.getLanguage())%> </TD>        
    <td class=Field>
     <%if(ishirecontract.equals("0")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
     <%if(ishirecontract.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
    </td>
  </tr> 
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelNames("20920,15792",user.getLanguage())%></TD>    
    <td class=Field><%=remindaheaddate%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></td>
  </tr> 
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15793,user.getLanguage())%> </TD>    
    <td class=Field>      
      <%=ResourceComInfo.getMulResourcename(remindman)%>      
    </td>
  </tr> 
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>  
  <tr>
    <td ><%=SystemEnv.getHtmlLabelName(15787,user.getLanguage())%></td>
    <td class=field>        
        <%=path%>
    </td>
</tr>
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
 <script language=vbs>
 sub onShowTemplet()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/contract/contracttemplet/HrmConTempletBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	templetidspan.innerHtml = id(1)
	contracttype.contracttempletid.value=id(0)
	else
	templetidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	contracttype.contracttempletid.value=""
	end if
	end if
end sub

sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub
</script>
<script language=javascript>
  function dosave(){
   location="HrmContractTypeEditDo.jsp?id=<%=id%>&subcompanyid=<%=subcompanyid%>";
  }
  function dodelete(){
    if(confirm("Are you sure to delete?")){
      document.contracttype.operation.value = "delete";
      document.contracttype.submit();
    }
  }
  function mainchange(){
    document.contracttype.action="HrmContractTypeEdit.jsp";
    document.contracttype.submit();
  }
  function subchange(){
    document.contracttype.action="HrmContractTypeEdit.jsp";
    document.contracttype.submit();
  }
function submitData() {
 contracttype.submit();
}
</script>
</body>
</html>