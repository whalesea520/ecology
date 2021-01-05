<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<FORM name=resource id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
	
<input type=hidden name=operation value="addresource">

<DIV><BUTTON class=btnSave accessKey=S type=button onClick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> </DIV>
  <table class=Form>
    <tbody> 
    <tr> 
      <td valign=top> 
        <table width="100%">
          <colgroup> <col width=10%> <col width=30%> <col width=10%> <col width=16%> 
          <col width=10%> <col width=24%><tbody> 
          <tr class=Section> 
            <th colspan=6><%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%></th>
          </tr>
          <tr class=Separator> 
            <td class=Sep1 colspan=6></td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=30 name="lastname" size=28 >
              </td>
            <td><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
            <td class=Field> 
              <select class=saveHistory id=sex 
              name=sex>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
                <option value=1><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
                <option value=2><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%></option>
              </select>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(1884,user.getLanguage())%></td>
            <td class=Field><button class=Calendar type="button" id=selectbirthday onClick="getbirthdayDate()"></button> 
              <span id=birthdayspan ></span> 
              <input type="hidden" name="birthday">
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1885,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=60 size=28 
            name=birthplace>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=30 size=15 
            name=folk>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></td>
            <td class=Field> 
              <select class=saveHistory id=maritalstatus name=maritalstatus>
                <option value=""> 
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></option>
                <option value=1><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></option>
                <option value=2><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%></option>
                <option value=3><%=SystemEnv.getHtmlLabelName(473,user.getLanguage())%></option>
              </select>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></td>
            <td class=Field colspan="3"> 
              <input class=saveHistory maxlength=60 size=62
            name=certificatenum>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(1901,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=30 size=15 
            name=policy>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=60 size=28 
            name=residentplace>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=15 size=15 
            name=residentphone>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(1899,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=8 size=15 
            name=residentpostcode onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("residentpostcode")'>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1900,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=60 size=28 
            name=homeaddress>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=15 size=15 
            name=homephone>
            </td>
            <td><%=SystemEnv.getHtmlLabelName(1899,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=8 size=15 
            name=homepostcode onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("homepostcode")'>
            </td>
          </tr>
		  		  <%
boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();
	
if(hasFF)
{
    %>
	<TR>
    <%
	int i =1;
	if(RecordSet.getString(i*2+21).equals("1")) {
		 %>
       
          <TD><%=Util.toScreen(RecordSet.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field  colspan=3>
		  <INPUT class=saveHistory maxLength=100 size=62 name="tff0<%=i%>">
		  </TD>
        
		<%}
	i=2;
	if(RecordSet.getString(i*2+21).equals("1")) {
		 %>
       
          <TD><%=Util.toScreen(RecordSet.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field>
		  <INPUT class=saveHistory maxLength=100 size=15 name="tff0<%=i%>">
		  </TD>
        
		<%}
	
    %>
	</TR>
    <%
}
%>
          </tbody> 
        </table>
      </td>
    </tr>
    </tbody> 
  </table>
</FORM>
<script language=javascript>
function doSave() {
	document.resource.submit() ;
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
