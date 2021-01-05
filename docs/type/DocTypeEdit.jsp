<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
	
<jsp:useBean id="DocTypeManager" class="weaver.docs.type.DocTypeManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
	DocTypeManager.setId(id);
	DocTypeManager.selectTypeInfoByid();
	id=DocTypeManager.getId();
	String typename =Util.toScreenToEdit(DocTypeManager.getTypename(),user.getLanguage());
	String isactive =Util.toScreen(DocTypeManager.getIsactive(),user.getLanguage());
	String hasaccessory =Util.toScreen(DocTypeManager.getHasaccessory(),user.getLanguage());
	int accessorynum = DocTypeManager.getAccessorynum();
	String hasitems =Util.toScreen(DocTypeManager.getHasitems(),user.getLanguage());
	String itemclause =Util.toScreenToEdit(DocTypeManager.getItemclause(),user.getLanguage());
	String itemlabel =Util.toScreenToEdit(DocTypeManager.getItemlabel(),user.getLanguage());
	String hasitemmaincategory =Util.toScreen(DocTypeManager.getHasitemmaincategory(),user.getLanguage());
	String itemmaincategorylabel =Util.toScreenToEdit(DocTypeManager.getItemmaincategorylabel(),user.getLanguage());
	String hashrmres =Util.toScreen(DocTypeManager.getHashrmres(),user.getLanguage());
	String hrmresclause =Util.toScreenToEdit(DocTypeManager.getHrmresclause(),user.getLanguage());
	String hrmreslabel =Util.toScreenToEdit(DocTypeManager.getHrmreslabel(),user.getLanguage());
	String hascrm =Util.toScreen(DocTypeManager.getHascrm(),user.getLanguage());
	String crmclause =Util.toScreenToEdit(DocTypeManager.getCrmclause(),user.getLanguage());
	String crmlabel =Util.toScreenToEdit(DocTypeManager.getCrmlabel(),user.getLanguage());
	String hasproject =Util.toScreen(DocTypeManager.getHasproject(),user.getLanguage());
	String projectclause =Util.toScreenToEdit(DocTypeManager.getProjectclause(),user.getLanguage());
	String projectlabel =Util.toScreenToEdit(DocTypeManager.getProjectlabel(),user.getLanguage());
	String hasfinance =Util.toScreen(DocTypeManager.getHasfinance(),user.getLanguage());
	String financeclause =Util.toScreenToEdit(DocTypeManager.getFinanceclause(),user.getLanguage());
	String financelabel =Util.toScreenToEdit(DocTypeManager.getFinancelabel(),user.getLanguage());
	String hasrefence1 =Util.toScreen(DocTypeManager.getHasrefence1(),user.getLanguage());
	String hasrefence2 =Util.toScreen(DocTypeManager.getHasrefence2(),user.getLanguage());
	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+typename;
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
<FORM id=Baco action="DocTypeOperation.jsp" name=frmMain method=post>
<DIV style="display:none">
 <%
if(HrmUserVarify.checkUserRight("DocTypeEdit:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON type='button' class=btnSave accessKey=S onclick="onSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
}if(HrmUserVarify.checkUserRight("DocTypeAdd:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocTypeAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' language=VBS class=BtnNew id=button1 accessKey=N name=button1 onclick="location='DocTypeAdd.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
<%
}if(HrmUserVarify.checkUserRight("DocTypeEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%
}if(HrmUserVarify.checkUserRight("DocMainCategory:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=66&sqlwhere="+xssUtil.put("where operateitem=4 and relatedid="+id)+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=BtnLog id=button2 accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?secid=66&sqlwhere=<%=xssUtil.put("where operateitem=4 and relatedid="+id%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON> </DIV>
<%
}
%>
 </DIV>
 
  <TABLE class=ViewForm width="100%">
    <TBODY> 
    <TR> 
      <TD colSpan=4 height=13><B><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line colSpan=4></TD></TR>
    <TR> 
      <TD width="20%" height=19><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
      <TD class=Field width="55%" height=19> 
        <INPUT class=InputStyle maxLength=60 size=55 name=typename value="<%=typename%>" onChange="checkinput('typename','typenamespan')">
        <input type=hidden name=id value=<%=id%>>
        <span id=typenamespan><%if(typename.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span></td>
      <TD width="5%" height=19><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></TD>
      <TD class=Field width="20%" height=19> 
      <%
      String ischecked = "";
      if(isactive.equals("1")) ischecked=" checked";
      %>
        <INPUT class=InputStyle name=isactive value=1 type=checkbox <%=ischecked%>></TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=23><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=23> 
      <%
      ischecked = "";
      if(hasaccessory.equals("1")) ischecked=" checked";
      %>
        <INPUT class=InputStyle name=hasaccessory value=1 type=checkbox  <%=ischecked%>> <%=SystemEnv.getHtmlLabelName(115,user.getLanguage())%> </TD>
      <TD width="18%" height=23><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(158,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=23> 
        <input class=InputStyle maxlength=2 size=15 name=accessorynum  value="<%=accessorynum%>">
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
      <%
      String ischecked0="";
      String ischecked1="";
      String ischecked2="";
      if(hasitems.equals("0")) ischecked0=" selected";
      if(hasitems.equals("1")) ischecked1=" selected";
      if(hasitems.equals("2")) ischecked2=" selected";
      %>
        <SELECT class=InputStyle name=hasitems>
          <OPTION value=0 <%=ischecked0%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1 <%=ischecked1%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2 <%=ischecked2%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
     <!-- <TD width="16%" height=2><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD class=Field width="35%" height=2>
        <select class=InputStyle name=It_Status>
          <option value="" selected> 
          <option value=A><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></option>
          <option value=F><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%> + <%=SystemEnv.getHtmlLabelName(170,user.getLanguage())%></option>
        </select>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=itemclause value="<%=itemclause%>">
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>: Items.IsSalesItem = 1</SPAN> 
      </TD>
  --></TR><tr><td class=Line colspan=4></td></tr>  <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60   size=60 name=itemlabel value="<%=itemlabel%>">
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
      <%
      ischecked0="";
      ischecked1="";
      ischecked2="";
      if(hasitemmaincategory.equals("0")) ischecked0=" selected";
      if(hasitemmaincategory.equals("1")) ischecked1=" selected";
      if(hasitemmaincategory.equals("2")) ischecked2=" selected";
      %>
        <SELECT class=InputStyle name=hasitemmaincategory>
          <OPTION value=0 <%=ischecked0%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1 <%=ischecked1%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2 <%=ischecked2%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
      </TR><tr><td class=Line colspan=4></td></tr>
      <tr>
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60   size=60 name=itemmaincategorylabel value="<%=itemmaincategorylabel%>">
      </TD>
      </TR><tr><td class=Line colspan=4></td></tr>
    </TR>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <%
      ischecked0="";
      ischecked1="";
      ischecked2="";
      if(hashrmres.equals("0")) ischecked0=" selected";
      if(hashrmres.equals("1")) ischecked1=" selected";
      if(hashrmres.equals("2")) ischecked2=" selected";
      %>
      <SELECT class=InputStyle name=hashrmres>
          <OPTION value=0 <%=ischecked0%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1 <%=ischecked1%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2 <%=ischecked2%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
   <!--   <TD width="16%" height=2><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD class=Field width="35%" height=2>
        <select class=InputStyle name=It_Status>
          <option value="" selected> 
          <option value=A><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></option>
          <option value=F><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%> + <%=SystemEnv.getHtmlLabelName(181,user.getLanguage())%></option>
        </select>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=hrmresclause value="<%=hrmresclause%>">
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>: humres.comp IN ('001','002') </SPAN> 
      </TD>
 --></TR><tr><td class=Line colspan=4></td></tr>   <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colspan=3> 
        <INPUT class=InputStyle maxLength=60  size=60  name=hrmreslabel value="<%=hrmreslabel%>">
      </TD>
    
 <!--     <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2> 
        <select class=InputStyle id=Re_Type name=cusertype>
                      <option value="" selected> 
                      <option value=A><%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
                      <option value=F><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></option>
                      <option value=H><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></option>
                      <option value=D><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
                      </select>
      </TD>
--></TR><tr><td class=Line colspan=4></td></tr>    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></B></TD>
    </TR>
    
<TR><TD class=Line colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <%
      ischecked0="";
      ischecked1="";
      ischecked2="";
      if(hascrm.equals("0")) ischecked0=" selected";
      if(hascrm.equals("1")) ischecked1=" selected";
      if(hascrm.equals("2")) ischecked2=" selected";
      %>
        <SELECT class=InputStyle name=hascrm>
          <OPTION value=0 <%=ischecked0%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1 <%=ischecked1%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2 <%=ischecked2%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
    <!--  <TD width="16%" height=2><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
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
        <INPUT class=InputStyle maxLength=255  size=60  name=crmclause value="<%=crmclause%>">
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>:  c.cmp_fctry IN ('US', 'NL') </SPAN> 
      </TD>
  --></TR><tr><td class=Line colspan=4></td></tr>  <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60  size=60  name=crmlabel value="<%=crmlabel%>">
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <%
      ischecked0="";
      ischecked1="";
      ischecked2="";
      if(hasproject.equals("0")) ischecked0=" selected";
      if(hasproject.equals("1")) ischecked1=" selected";
      if(hasproject.equals("2")) ischecked2=" selected";
      %>
        <SELECT class=InputStyle name=hasproject>
          <OPTION value=0 <%=ischecked0%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1 <%=ischecked1%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2 <%=ischecked2%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
  <!--  <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=projectclause value="<%=projectclause%>">
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>: p.Division IN ('003') </SPAN> 
      </TD>
 -->   <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60  size=60  name=projectlabel value="<%=projectlabel%>">
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <TR> 
      <TD colSpan=4 height=26><BR>
        <B><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></B></TD>
    </TR>
<TR><TD class=Line colSpan=4></TD></TR>
    <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=2 colspan=3> 
        <%
      ischecked0="";
      ischecked1="";
      ischecked2="";
      if(hasfinance.equals("0")) ischecked0=" selected";
      if(hasfinance.equals("1")) ischecked1=" selected";
      if(hasfinance.equals("2")) ischecked2=" selected";
      %>
      <SELECT class=InputStyle name=hasfinance>
          <OPTION value=0 <%=ischecked0%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1 <%=ischecked1%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2 <%=ischecked2%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
  <!--  <TR> 
      <TD width="18%" height=2><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
      <TD class=Field colSpan=3 height=2> 
        <INPUT class=InputStyle maxLength=255  size=60  name=financeclause value="<%=financeclause%>">
        <BUTTON class=Btn name=ShowIt_Selection><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></BUTTON> <BR>
        <SPAN class=Mini><%=SystemEnv.getHtmlLabelName(174,user.getLanguage())%>: g.CompanyCode IN ('001', '002')  </SPAN> 
      </TD>
 -->   <TR> 
      <TD width="18%"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TD>
      <TD class=Field colSpan=3> 
        <INPUT class=InputStyle maxLength=60  size=60  name=financelabel value="<%=financelabel%>">
      </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
 <!--   <TR> 
      <TD width="18%" height=23><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=23 colspan=3> 
       <%
      ischecked0="";
      ischecked1="";
      ischecked2="";
      if(hasrefence1.equals("0")) ischecked0=" selected";
      if(hasrefence1.equals("1")) ischecked1=" selected";
      if(hasrefence1.equals("2")) ischecked2=" selected";
      %> <SELECT class=InputStyle name=hasrefence1>
          <OPTION value=0 <%=ischecked0%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1 <%=ischecked1%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2 <%=ischecked2%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
        </TR><tr><td class=Line colspan=4></td></tr>
        <tr>
      <TD width="18%" height=23><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%></TD>
      <TD class=Field width="31%" height=23 colspan=3> 
        <%
      ischecked0="";
      ischecked1="";
      ischecked2="";
      if(hasrefence2.equals("0")) ischecked0=" selected";
      if(hasrefence2.equals("1")) ischecked1=" selected";
      if(hasrefence2.equals("2")) ischecked2=" selected";
      %><SELECT class=InputStyle name=hasrefence2>
          <OPTION value=0 <%=ischecked0%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(165,user.getLanguage())%>)</OPTION>
          <OPTION value=1 <%=ischecked1%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%>)</OPTION>
          <OPTION value=2 <%=ischecked2%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(168,user.getLanguage())%>)</OPTION>
        </SELECT>
    </TR><tr><td class=Line colspan=4></td></tr>
 -->   </TBODY> 
  </TABLE>


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
  <input type=hidden name="operation">

      <script>
function onSave(){
	if(check_form(document.frmMain,'typename')){
	document.frmMain.operation.value="edit";
	document.frmMain.submit();}
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}
}
</script>
</FORM></DIV></BODY></HTML>
