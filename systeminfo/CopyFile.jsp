<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>



<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "文件移动设置" ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<DIV class=HdrProps>
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>文件复制</TH>
    </TR>
    </TBODY> 
  </TABLE>
</DIV>


<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CopyFileOperation.jsp">
<div>
<BUTTON class=btn id=btnCopy accessKey=C name=btnSave type=submit onSubmit="return check_form(this,'Needmovefilelist,NEWFILEPATH,SYSFILEPATH')"><U>C</U>-复制</BUTTON> 
<BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重置</BUTTON> 
</div>    <br>
   
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>复制文件列表</td>
      <td class=Field> 
        <input name=Needmovefilelist  size=80 value="" type='file'  onchange='checkinput("Needmovefilelist","Needmovefilelistimage")'>
        <SPAN id=Needmovefilelistimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
      </td>
    </tr>
    <tr> 
      <td>源文件根目录</td>
      <td class=Field> 
        <input name=NEWFILEPATH  size=80 value="" type='file' onchange='checkinput("NEWFILEPATH","NEWFILEPATHimage")'>
        <SPAN id=NEWFILEPATHimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
      </td>
    </tr>
    <tr> 
      <td>目标文件根目录</td>
      <td class=Field> 
        <input name=SYSFILEPATH  size=80 value="" type='file' onchange='checkinput("SYSFILEPATH","SYSFILEPATHimage")'>
        <SPAN id=SYSFILEPATHimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
      </td>
    </tr>
</BODY>
</HTML>
