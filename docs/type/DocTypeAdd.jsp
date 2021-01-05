<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("DocTypeAdd:add", user)){
    		response.sendRedirect("/notice/noright.jsp");
}
%>    		
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
<FORM id=Baco action="DocTypeOperation.jsp?operation=add" name=frmMain method=post onSubmit="return check_form(this,'typename')">
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:Baco.mysave.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
 <BUTTON class=btnSave accessKey=S id=mysave type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
 </DIV>
 
  <TABLE class=ViewForm width="100%">
    <TBODY> 
    <TR> 
      <TD colSpan=4 height=13><B><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></B></TD>
    </TR>
    <TR> 
      <TD class=Line1 colSpan=4 height=13></TD>
    </TR>
    <TR> 
      <TD width="20%" height=19><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
      <TD class=Field width="55%" height=19> 
        <INPUT class=InputStyle maxLength=60 size=55 name=typename onChange="checkinput('typename','typenamespan')">
        <span id=typenamespan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span></td>
      <TD width="5%" height=19><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></TD>
      <TD class=Field width="20%" height=19> 
        <INPUT class=InputStyle name=isactive value=1 type=checkbox checked></TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line1 colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=23><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=23> 
        <INPUT class=InputStyle name=hasaccessory value=1 type=checkbox CHECKED> <%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%> </TD>
      <TD width="18%" height=23><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(158,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=23> 
        <input class=InputStyle maxlength=2 size=15 name=accessorynum>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line1 colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <SELECT class=InputStyle name=hasitems>
          <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
<!--      <TD width="16%" height=2><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD class=Field width="35%" height=2>
        <select class=InputStyle name=It_Status>
          <option value="" selected> 
          <option value=A><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></option>
          <option value=F><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%> + <%=SystemEnv.getHtmlLabelName(170,user.getLanguage())%></option>
        </select>
      </TD>
   </TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=itemclause>
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>: Items.IsSalesItem = 1</SPAN> 
      </TD>
  -->
  </tr>   <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60   size=60 name=itemlabel>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line1 colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <SELECT class=InputStyle name=hasitemmaincategory>
          <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
      </TR><tr><td class=Line colspan=4></td></tr>
      <tr>
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60   size=60 name=itemmaincategorylabel>
      </TD>
      </TR><tr><td class=Line colspan=4></td></tr>
    </TR>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line1 colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <SELECT class=InputStyle name=hashrmres>
          <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
 <!--     <TD width="16%" height=2><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD class=Field width="35%" height=2>
        <select class=InputStyle name=It_Status>
          <option value="" selected> 
          <option value=A><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></option>
          <option value=F><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%> + <%=SystemEnv.getHtmlLabelName(181,user.getLanguage())%></option>
        </select>
      </TD>
    </TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=hrmresclause>
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>: humres.comp IN ('001','002') </SPAN> 
      </TD>
  --></tr>  <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colspan=3> 
        <INPUT class=InputStyle maxLength=60  size=60  name=hrmreslabel>
      </TD>
    
    <!--  <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2> 
        <select class=InputStyle id=Re_Type name=cusertype>
                      <option value="" selected> 
                      <option value=A><%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
                      <option value=F><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></option>
                      <option value=H><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></option>
                      <option value=D><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
                      </select>
      </TD>
   --></TR><tr><td class=Line colspan=4></td></tr> <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></B></TD>
    </TR>
    
<TR><TD class=Line1 colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <SELECT class=InputStyle name=hascrm>
          <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
  <!--    <TD width="16%" height=2><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
      <TD class=Field width="35%" height=2>
        <SELECT class=InputStyle name=Ac_Type>
          <OPTION value="" selected> 
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(182,user.getLanguage())%></OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(183,user.getLanguage())%></OPTION>
          <OPTION value=3><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></OPTION>
          <OPTION value=4><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></OPTION>
          <OPTION value=5><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></OPTION>
          <OPTION value=6><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%></OPTION>
        </SELECT>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=crmclause>
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>:  c.cmp_fctry IN ('US', 'NL') </SPAN> 
      </TD>
--></TR><tr><td class=Line colspan=4></td></tr>    <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60  size=60  name=crmlabel>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line1 colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <SELECT class=InputStyle name=hasproject>
          <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
 <!--     <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=projectclause>
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>: p.Division IN ('003') </SPAN> 
      </TD>
  -->  <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60  size=60  name=projectlabel>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line1 colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <SELECT class=InputStyle name=hasfinance>
          <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
<!--    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=financeclause>
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>: g.CompanyCode IN ('001', '002')  </SPAN> 
      </TD>
 -->   <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60  size=60  name=financelabel>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
  <!--  <TR> 
      <TD width="18%" height=23><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=23 colspan=3> 
        <SELECT class=InputStyle name=hasrefence1>
          <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
        </tr>
        <tr>
      <TD width="18%" height=23><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=23 colspan=3> 
        <SELECT class=InputStyle name=hasrefence2>
          <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
    </TR>
 -->   </TBODY> 
  </TABLE>
</FORM></DIV>

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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY></HTML>
