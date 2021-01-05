<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("TargetTypeInfo:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18086,user.getLanguage());
String id=Util.null2String(request.getParameter("id"));
String needfav ="1";
String needhelp ="";
String tName="";
rs.execute("select targetName from HrmPerformanceTargetType where id="+id);
if (rs.next())
{
tName=Util.null2String(rs.getString("targetName"));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<FORM name=resource id=resource action="TargetTypeOperation.jsp" method=post>
<input type=hidden name=inserttype value=detail >
<input type=hidden name=mainid  value=<%=id%> >
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name=targetName  onchange='checkinput("targetName","nameimage")'>
			<SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle name=targetCode  size=10 maxLength=10>
			
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></TD>
            <TD class=Field> 
           
              <%=Util.toScreen(tName,user.getLanguage())%>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
            <TD class=Field> 
              <select class=inputStyle id=type_1 
              name=type_1>
                
                <option value=0  selected ><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                <option value=2 ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value=3 ><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
             </select>
               <!--0:公司 1：分部，2：部门，3：个人-->
      
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></TD>
            <TD class=Field> 
               <select class=inputStyle id=cycle 
              name=cycle>
                
                <option value=3  selected ><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option>
                <option value=2 ><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>
                <option value=0 ><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>
             </select>
               <!--0:月 1：季度，2：年中，3：年--> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></TD>
            <TD class=Field> 
               <select class=inputStyle id=type_t 
              name=type_t onchange="show()">
                
                <option value=0  selected ><%=SystemEnv.getHtmlLabelName(18090,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(18089,user.getLanguage())%></option>
                
             </select>
               <!--0:定性1:定量-->
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        

         <tr><td colSpan=2>
         <div id=ration style="display:none">
         <table width="100%"> <COLGROUP> <COL width=10%> <COL width=70%> <TBODY>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></TD>
            <TD class=Field> 
               <select class=inputStyle id=unit 
              name=unit> 
              <%rs1.execute("select * from HrmPerformanceCustom where status='0' order by id desc");
              while (rs1.next())
              {
              %>    
                <option value="<%=rs1.getString("id")%>" ><%=rs1.getString("unitName")%></option>
               
             <%}%>
             </select>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18087,user.getLanguage())%></TD>
            
            <TD class=Field> 
              <input class=inputstyle name=targetValue  size=10 maxLength=10 onchange='checknumber("targetValue")'>
			
            </TD>
          </TR>  
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
           
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18088,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle name=previewValue  size=10 maxLength=10 onchange='checknumber("previewValue")'>
			
            </TD>
          </TR>
       
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         </table>
        </div>
        </td></tr>
              <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18075,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle name=memo  size=50 maxLength=50>
			
            </TD>
          </TR>
          
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
  </FORM>
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


<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.resource,"targetName"))
	{	
		document.resource.submit();
		enablemenu();
	}
}
function show()
{

if (document.all.type_t.options[document.all.type_t.selectedIndex].value=="1")
{
document.all("ration").style.display="";
}
else
{
document.all("ration").style.display="none";
}

}
</script>
</BODY>
</HTML>