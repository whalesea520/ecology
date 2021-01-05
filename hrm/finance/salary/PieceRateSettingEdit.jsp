
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean hasright=true;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"PieceRate:setting",subcompanyid);
    if(subcompanyid!=0 && operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}
if(!HrmUserVarify.checkUserRight("PieceRate:setting", user) && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19376,user.getLanguage())+":"+SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",PieceRateSetting.jsp?subCompanyId="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<FORM id=weaver name=frmMain action="PieceRateSetOperation.jsp" method=post enctype="multipart/form-data" >
<input type="hidden" id="option" name="option" value="">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=file  name="pieceratefile" size=40>&nbsp;&nbsp;<button Class=AddDoc type=button onclick="loadexcel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></button></TD>
   </TR>
   <TR class= Spacing><TD class=Line colSpan=2></TD></TR>
  <tr>
    <td colSpan=2><a href="PieceratesetExcel.xls"><%=SystemEnv.getHtmlLabelName(18616,user.getLanguage())%></a></td>
 </tr>
 <tr>
<td id="msg" align="center" colspan="2"><font size="2" color="#FF0000">
<%
String msg=Util.null2String(request.getParameter("msg"));
String msg1=Util.null2String(request.getParameter("msg1"));
String msg2=Util.null2String(request.getParameter("msg2"));
String msg3=Util.null2String(request.getParameter("msg3"));
int    dotindex=0;
int    cellindex=0;
int    msgsize;
msgsize=Util.getIntValue(request.getParameter("msgsize"),0);

if (msg.equals("success")){
    msg=SystemEnv.getHtmlLabelName(19391,user.getLanguage());
    out.println(msg);
}else{
    for (int i=0;i<msgsize;i++){
        dotindex=msg1.indexOf(",");
        cellindex=msg2.indexOf(",");
        out.println(msg1.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg2.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+SystemEnv.getHtmlLabelName(19327,user.getLanguage())+"<br>");

         msg1=msg1.substring(dotindex+1,msg1.length());
         msg2=msg2.substring(cellindex+1,msg2.length());
    }
}
if(!msg3.trim().equals("")){
    out.println("<br>"+SystemEnv.getHtmlLabelName(19383,user.getLanguage())+msg3+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+","+SystemEnv.getHtmlLabelName(19393,user.getLanguage()));
}
%>
 </font>
 </td>
 </tr>
 <TR class= Spacing><TD class=Line1 colSpan=2></TD></TR>
 </TBODY></TABLE>

 <br>
<TABLE class=ListStyle cellspacing=1 id="oTable" >
  <COLGROUP>
  <COL width="5%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="20%">
  <TBODY>
  <TR>
    <TD colSpan=2 ><b><%=SystemEnv.getHtmlLabelName(19376,user.getLanguage())%></b></TD>
    <TD colSpan=4 align="right">
    <button Class=btnNew type=button onclick="addrow()"><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></button>
    <button Class=btnDelete type=button onclick="delrow()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
    </TD></TR>
  <TR class=Header >
  <TH><input type='checkbox' class=inputstyle name='checkall' onclick="selectall()"></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19383,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19384,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(19385,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></TH>
  <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
  </TR>
  <%
  String checkfield="";
  RecordSet.executeSql("select * from HRM_PieceRateSetting where subcompanyid="+subcompanyid+" order by id");
  int i=0;
  while(RecordSet.next()){
      checkfield+="PieceRateNo_"+i+",";
  %>
  <TR CLASS="DataDark">
      <TD><input type='checkbox' class=inputstyle name='check_node' value='<%=i%>'></TD>
      <TD><input type='text' class=inputstyle size=15 name='PieceRateNo_<%=i%>' value="<%=RecordSet.getString("PieceRateNo")%>" onchange="checkinput('PieceRateNo_<%=i%>','PieceRateNospan_<%=i%>')" maxlength=30><SPAN id="PieceRateNospan_<%=i%>"></SPAN></TD>
      <TD><input type='text' class=inputstyle size=15 name='PieceRateName_<%=i%>' value="<%=RecordSet.getString("PieceRateName")%>" maxlength=50></TD>
      <TD><input type='text' class=inputstyle size=15 name='workingpro_<%=i%>' value="<%=RecordSet.getString("workingpro")%>" maxlength=100></TD>
      <TD><input type='text' class=inputstyle size=10 name='price_<%=i%>' value="<%=RecordSet.getString("price")%>" maxlength=13 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></TD>
      <TD><input type='text' class=inputstyle size=15 name='memo_<%=i%>' value="<%=RecordSet.getString("memo")%>" maxlength=500></TD>
  </TR>
  <%i++;}%>
 </TBODY></TABLE>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<input type='hidden' id="rownum" name="rownum" value="<%=i%>">
<input type='hidden' id="indexnum" name="indexnum" value="<%=i%>">
<input type='hidden' id="subcompanyid" name="subcompanyid" value="<%=subcompanyid%>">
<input type='hidden' id="checkfield" name="checkfield" value="<%=checkfield%>">
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
<script language=javascript>
function save(obj) {
 if(check_form(frmMain,frmMain.checkfield.value)){
    frmMain.option.value="edit";
    obj.disabled=true;
    frmMain.submit();
 }
}
function selectall(){
    len = document.frmMain.elements.length;
    var i=0;
    for(i=len-1; i >= 0;i--) {
       if (document.frmMain.elements[i].name=='check_node'){
           document.frmMain.elements[i].checked=document.frmMain.checkall.checked;
       }
    }
}
function loadexcel(obj) {
 if (frmMain.pieceratefile.value=="" || frmMain.pieceratefile.value.toLowerCase().indexOf(".xls")<0){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
     frmMain.pieceratefile.value="";
}else{
    if(confirm("<%=SystemEnv.getHtmlLabelName(19392,user.getLanguage())%>")){
    frmMain.option.value="loadfile";
    var showTableDiv  = document.getElementById('_xTable');
	var message_table_Div = document.createElement("div");
	message_table_Div.id="message_table_Div";
	message_table_Div.className="xTable_message";
	showTableDiv.appendChild(message_table_Div);
	var message_table_Div  = document.getElementById("message_table_Div");
	message_table_Div.style.display="inline";
	message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19390,user.getLanguage())%>";
	var pTop= document.body.offsetHeight/2-60;
	var pLeft= document.body.offsetWidth/2-100;
	message_table_Div.style.position="absolute";
	message_table_Div.style.posTop=pTop;
	message_table_Div.style.posLeft=pLeft;
    obj.disabled=true;
    frmMain.submit();
    }
 }
}
function addrow(){
    var oTable=document.all('oTable');
    var curindex=parseInt(document.all('rownum').value);
    var rowindex=parseInt(document.all('indexnum').value);
    var oRow = oTable.insertRow();
    var oCell = oRow.insertCell();

    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<input type='checkbox' class=inputstyle name='check_node' value='"+rowindex+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<input type='text' class=inputstyle size=15 id='PieceRateNo_"+rowindex+"' name='PieceRateNo_"+rowindex+"' maxlength=30 onchange='checkinput(\"PieceRateNo_"+rowindex+"\",\"PieceRateNospan_"+rowindex+"\")'><SPAN id=PieceRateNospan_"+rowindex+" name=PieceRateNospan_"+rowindex+"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>";
    oDiv.innerHTML = sHtml
    oCell.appendChild(oDiv);
    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<input type='text' class=inputstyle size=15 name='PieceRateName_"+rowindex+"' maxlength=50>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<input type='text' class=inputstyle size=15 name='workingpro_"+rowindex+"' maxlength=100>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<input type='text' class=inputstyle size=10 name='price_"+rowindex+"' maxlength=13 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<input type='text' class=inputstyle size=15 name='memo_"+rowindex+"' maxlength=500>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    document.all("rownum").value = curindex+1 ;
    document.all('indexnum').value = rowindex+1;
    document.all('checkfield').value = document.all('checkfield').value+"PieceRateNo_"+rowindex+",";
}
function delrow(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
        var oTable=document.all('oTable');
        curindex=parseInt(document.all("rownum").value);
        len = document.frmMain.elements.length;
        var i=0;
        var rowsum1 = 0;
        for(i=len-1; i >= 0;i--) {
            if (document.frmMain.elements[i].name=='check_node')
                rowsum1 += 1;
        }
        for(i=len-1; i >= 0;i--) {
            if (document.frmMain.elements[i].name=='check_node'){
                if(document.frmMain.elements[i].checked==true) {
                    oTable.deleteRow(rowsum1+1);
                    curindex--;
                    document.all('checkfield').value = (document.all('checkfield').value+",").replace("PieceRateNo_"+document.frmMain.elements[i].value+",","");
                }
                rowsum1 -=1;
            }
        }
        document.all("rownum").value=curindex;
    }
}
</script>
</BODY>
</HTML>