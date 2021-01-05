
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
%>
<%
    RecordSet.executeSql("select filerealpath from imagefile where mouldtype = 2 or  mouldtype = 3");
    if (RecordSet.next()) out.println("<br>文件当前全部路径为："+Util.null2String(RecordSet.getString(1)));
    RecordSet.executeSql("select mouldpath from DocMouldFile where id = "+1);
    if (RecordSet.next()) out.println("<br>模板当前全部路径为："+Util.null2String(RecordSet.getString(1)));
    out.println("<br>以上仅做参考！");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>

<BODY>
<DIV class=HdrProps>
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>数据库文件路径更换</TH>
    </TR>
    </TBODY> 
  </TABLE>
</DIV>
<FORM style="MARGIN-TOP: 0px" id=frmMain name=frmMain method=post action="SystemFilePathChangeOperation.jsp">
<div>
<BUTTON class=btn id=btnSave accessKey=S name=btnSave type=button  onClick="onSubmit(this)"><U>S</U>-提交</BUTTON> 
<BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重置</BUTTON> 
</div>    <br>
<TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>   
    <div>
       &nbsp;&nbsp;&nbsp; <font color="red">请注意: 源路径中的大小写必须与数据库的设置一致!否则执行无效</font>
    </div><br>
    <tr> 
      <td>源路径(如: D:\fileSystem\)</td>
      <td class=Field> 
        <input accesskey=Z name="srcPath"  maxlength="30">
      </td>
    </tr>
    <tr> 
      <td>目标路径(如: f:\xyzfileSystem\)</td>
      <td class=Field> 
        <input name="targetPath"  maxlength="30">
      </td>
    </tr>
    </TBODY> 
  </TABLE>
 </FORM>
</BODY>
</HTML>
<script language="javaScript">
    function onSubmit(obj){        
        if (document.frmMain.srcPath.value !='' || document.frmMain.targetPath.value != '') {  
              obj.disabled = true ;
              frmMain.submit();
        } else {
              alert("请填写好源路径与目标路径后再提交!")  ;
        }
    }
</script>