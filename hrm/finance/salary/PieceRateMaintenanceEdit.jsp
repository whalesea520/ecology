
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean hasright=true;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
int isedit=Util.getIntValue(request.getParameter("isedit"));
String currentyear =Util.null2String(request.getParameter("PieceYear"));
String currentmonth =Util.null2String(request.getParameter("PieceMonth"));
//获得当前的年月
if(currentyear.trim().equals("") || currentmonth.trim().equals("")){
Calendar today = Calendar.getInstance();
currentyear = Util.add0(today.get(Calendar.YEAR), 4);
currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2);
}
String showname="";
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"PieceRate:maintenance",subcompanyid);
    if(subcompanyid!=0 && operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}
if(!HrmUserVarify.checkUserRight("PieceRate:maintenance", user) && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
if(departmentid>0){
    showname=DepartmentComInfo.getDepartmentname(""+departmentid);
}else if(subcompanyid>0){
    showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
}else{
    hasright=false;
}
String sqlwhere = "";
String sqlwhere_1 = "";
if(subcompanyid > 0){
    sqlwhere += " and subcompanyid1="+subcompanyid;
	sqlwhere_1 += " and subcompanyid="+subcompanyid;
}
if(departmentid > 0) {
    sqlwhere += " and departmentid="+departmentid;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19377,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",PieceRateMaintenance.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+",_self} " ;
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
<FORM id=weaver name=frmMain action="PieceRateMaintOperation.jsp" method=post enctype="multipart/form-data" >
<input type="hidden" id="option" name="option" value="">
<TABLE class=viewform width="100%">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(19399,user.getLanguage())%></TH></TR>
  <TR class=spacing style='height: 1px;'>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></TD>
          <TD class=Field><%=showname%><input class=inputstyle type="hidden"  name="subcompanyid" value="<%=subcompanyid%>">
              <input class=inputstyle type="hidden"  name="departmentid" value="<%=departmentid%>"></TD>
   </TR>
   <TR class= Spacing style='height: 1px;'><TD class=Line colSpan=2></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19400,user.getLanguage())%></TD>
          <TD class=Field>
          <%
          if(isedit!=1){
          %>
              <select class=inputstyle   name="PieceYear" >
        <%
            // 查询选择框的所有可以选择的值
            int defaultsel=Util.getIntValue(currentyear,2006);
            for(int y=defaultsel-50;y<defaultsel+50;y++){
	   %>
	    <option value="<%=y%>" <%if(defaultsel==y){%>selected<%}%>><%=y%></option>
	   <%
            }
       %>
          </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
              <select class=inputstyle   name="PieceMonth" >
                  <option value="01" <%if(currentmonth.equals("01")){%>selected<%}%>>01</option>
                  <option value="02" <%if(currentmonth.equals("02")){%>selected<%}%>>02</option>
                  <option value="03" <%if(currentmonth.equals("03")){%>selected<%}%>>03</option>
                  <option value="04" <%if(currentmonth.equals("04")){%>selected<%}%>>04</option>
                  <option value="05" <%if(currentmonth.equals("05")){%>selected<%}%>>05</option>
                  <option value="06" <%if(currentmonth.equals("06")){%>selected<%}%>>06</option>
                  <option value="07" <%if(currentmonth.equals("07")){%>selected<%}%>>07</option>
                  <option value="08" <%if(currentmonth.equals("08")){%>selected<%}%>>08</option>
                  <option value="09" <%if(currentmonth.equals("09")){%>selected<%}%>>09</option>
                  <option value="10" <%if(currentmonth.equals("10")){%>selected<%}%>>10</option>
                  <option value="11" <%if(currentmonth.equals("11")){%>selected<%}%>>11</option>
                  <option value="12" <%if(currentmonth.equals("12")){%>selected<%}%>>12</option>
              </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
          <%
              }else{
          %>
          <%=currentyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=currentmonth%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
          <input type="hidden" name="PieceYear" value="<%=currentyear%>">
          <input type="hidden" name="PieceMonth" value="<%=currentmonth%>">
          <%
              }
          %>
          </TD>
   </TR>
   <%
      if(departmentid<1){
  %>
   <TR class= Spacing style='height: 1px;'><TD class=Line colSpan=2></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=file  name="pieceratefile" size=40>&nbsp;&nbsp;<button Class=AddDoc type=button onclick="loadexcel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></button></TD>
   </TR>
   <TR class= Spacing style='height: 1px;'><TD class=Line colSpan=2></TD></TR>
  <tr>
    <td colSpan=2><a href="PiecerateMaintExcel.xls"><%=SystemEnv.getHtmlLabelName(18616,user.getLanguage())%></a></td>
 </tr>
 <%
     }
 %>
 <tr>
<td id="msg" align="center" colspan="2"><font size="2" color="#FF0000">
<%
String msg=Util.null2String(request.getParameter("msg"));
String msg1=Util.null2String(request.getParameter("msg1"));
String msg2=Util.null2String(request.getParameter("msg2"));
String msg3=Util.null2String(request.getParameter("msg3"));
String msg4=Util.null2String(request.getParameter("msg4"));
int    dotindex=0;
int    cellindex=0;
int    msgsize;
msgsize=Util.getIntValue(request.getParameter("msgsize"),0);

if (msg.equals("success")){
    msg=SystemEnv.getHtmlLabelName(19403,user.getLanguage());
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
    out.println("<br>"+SystemEnv.getHtmlLabelName(19401,user.getLanguage())+msg3.substring(0,msg3.length()-1)+SystemEnv.getHtmlLabelName(19327,user.getLanguage()));
}
if(!msg4.trim().equals("")){
    out.println("<br>"+SystemEnv.getHtmlLabelName(19383,user.getLanguage())+msg4.substring(0,msg4.length()-1)+SystemEnv.getHtmlLabelName(19327,user.getLanguage()));
}
%>
 </font>
 </td>
 </tr>
 <TR class= Spacing style='height: 1px;'><TD class=Line1 colSpan=2></TD></TR>
 </TBODY></TABLE>

 <br>
<TABLE class=ListStyle cellspacing=1 id="oTable" width="100%">
  <COLGROUP>
  <COL width="5%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="20%">
  <TBODY>
  <TR>
    <TD colSpan=2><b><%=SystemEnv.getHtmlLabelName(19377,user.getLanguage())%></b></TD>
    <TD colSpan=4 align="right">
    <button Class=btnNew type=button onclick="addrow()" size=20><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></button>
    <button Class=btnDelete type=button onclick="delrow()" size=20><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
    </TD></TR>
  <TR class=Header >
  <TH width="5%"><input type='checkbox' class=inputstyle name='checkall' onclick="selectall()"></TH>
  <TH width="20%"><%=SystemEnv.getHtmlLabelName(19401,user.getLanguage())%></TH>
  <TH width="20%"><%=SystemEnv.getHtmlLabelName(19383,user.getLanguage())%></TH>
  <TH width="20%"><%=SystemEnv.getHtmlLabelName(16221,user.getLanguage())%></TH>
  <TH width="15%"><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TH>
  <TH width="20%"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
  </TR>
  <%
  String checkfield="";
  String sql="";
  int i=0;
  if(isedit==1){
  if(departmentid>0){
      sql="select * from HRM_PieceRateInfo where subcompanyid="+subcompanyid+" and departmentid="+departmentid+" and PieceYear="+Util.getIntValue(currentyear)+" and PieceMonth="+Util.getIntValue(currentmonth)+" order by UserCode";
  }else if(subcompanyid>0){
      sql="select * from HRM_PieceRateInfo where subcompanyid="+subcompanyid+" and PieceYear="+currentyear+" and PieceMonth="+Util.getIntValue(currentmonth)+" order by UserCode";
  }
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
      checkfield+="UserCode_"+i+",PieceRateNo_"+i+",PieceNum_"+i+",";
	  String userCodetmp = RecordSet.getString("UserCode");
	  String pieceRateNotmp = RecordSet.getString("PieceRateNo");
  %>
  <TR CLASS="DataDark">
      <TD  width="5%"><input type='checkbox' class=inputstyle name='check_node' value='<%=i%>'></TD>
      <TD  width="20%">
	  <button type="button" class=Browser onclick="onShowUserCode('UserCode_<%=i%>','UserCodespan_<%=i%>')"></button>
	  <input type='hidden' id='UserCode_<%=i%>' name='UserCode_<%=i%>' value="<%=userCodetmp%>">
	  <SPAN id="UserCodespan_<%=i%>"><%=userCodetmp%></SPAN>
	  </TD>
      <TD width="20%">
	  <button type="button" class=Browser onclick="onShowPieceRateNo('PieceRateNo_<%=i%>','PieceRateNospan_<%=i%>')"></button>
	  <input type='hidden' id='PieceRateNo_<%=i%>' name='PieceRateNo_<%=i%>' value="<%=pieceRateNotmp%>">
	  <SPAN id="PieceRateNospan_<%=i%>"><%=pieceRateNotmp%></SPAN>
	  </TD>
      <TD width="20%"><button type="button" class=Browser onclick="getDate(PieceRateDatespan_<%=i%>,PieceRateDate_<%=i%>)"></button><SPAN id="PieceRateDatespan_<%=i%>"><%=RecordSet.getString("PieceRateDate")%></SPAN><input type='hidden' class=inputstyle name='PieceRateDate_<%=i%>' value="<%=RecordSet.getString("PieceRateDate")%>"></TD>
      <TD width="15%"><input type='text' class=inputstyle size=10 name='PieceNum_<%=i%>' value="<%=RecordSet.getString("PieceNum")%>" maxlength=13 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' onchange="checkinput('PieceNum_<%=i%>','PieceNumspan_<%=i%>')"><SPAN id="PieceNumspan_<%=i%>"></SPAN></TD>
      <TD width="20%"><input type='text' class=inputstyle size=15 name='memo_<%=i%>' value="<%=RecordSet.getString("memo")%>" maxlength=500></TD>
  </TR>
  <%i++;}}%>
 </TBODY></TABLE>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<input type='hidden' id="rownum" name="rownum" value="<%=i%>">
<input type='hidden' id="indexnum" name="indexnum" value="<%=i%>">
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
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function save(obj) {
 if(check_form(frmMain,frmMain.checkfield.value)){
    <%if(isedit==1){%>
    frmMain.option.value="edit";
    obj.disabled=true;
    frmMain.submit();
    <%}else{%>
    var ajax=ajaxinit();
    ajax.open("POST", "PieceRateCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&PieceYear="+frmMain.PieceYear.value+"&PieceMonth="+frmMain.PieceMonth.value);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            if(ajax.responseText!=1){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19409,user.getLanguage())%>");
                return false;
            }else{
                frmMain.option.value="add";
                obj.disabled=true;
                frmMain.submit();
            }
            }catch(e){
                return false;
            }
        }
    }
    <%}%>
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
    <%if(isedit!=1){%>
     var ajax=ajaxinit();
    ajax.open("POST", "PieceRateCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&PieceYear="+frmMain.PieceYear.value+"&PieceMonth="+frmMain.PieceMonth.value);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            if(ajax.responseText!=1){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19409,user.getLanguage())%>");
                return false;
            }else{
                frmMain.option.value="loadfile";
                var showTableDiv  = document.getElementById('_xTable');
                var message_table_Div = document.createElement("<div>");
                message_table_Div.id="message_table_Div";
                message_table_Div.className="xTable_message";
                showTableDiv.appendChild(message_table_Div);
                var message_table_Div  = document.getElementById("message_table_Div");
                message_table_Div.style.display="inline";
                message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19402,user.getLanguage())%>";
                var pTop= document.body.offsetHeight/2-60;
                var pLeft= document.body.offsetWidth/2-100;
                message_table_Div.style.position="absolute";
                message_table_Div.style.posTop=pTop;
                message_table_Div.style.posLeft=pLeft;
                obj.disabled=true;
                frmMain.submit();
            }
            }catch(e){
                return false;
            }
        }
    }
    <%}else{%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(19404,user.getLanguage())%>")){
    frmMain.option.value="loadfile";
    var showTableDiv  = document.getElementById('_xTable');
	var message_table_Div = document.createElement("<div>");
	message_table_Div.id="message_table_Div";
	message_table_Div.className="xTable_message";
	showTableDiv.appendChild(message_table_Div);
	var message_table_Div  = document.getElementById("message_table_Div");
	message_table_Div.style.display="inline";
	message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19402,user.getLanguage())%>";
	var pTop= document.body.offsetHeight/2-60;
	var pLeft= document.body.offsetWidth/2-100;
	message_table_Div.style.position="absolute";
	message_table_Div.style.posTop=pTop;
	message_table_Div.style.posLeft=pLeft;
    obj.disabled=true;
    frmMain.submit();
    }
    <%}%>
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
    var sHtml = "<button type='button' class=Browser onclick=\"onShowUserCode('UserCode_"+rowindex+"','UserCodespan_"+rowindex+"')\"></button><SPAN id=UserCodespan_"+rowindex+"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type='hidden' id='UserCode_"+rowindex+"' name='UserCode_"+rowindex+"' >";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<button type='button' class=Browser onclick=\"onShowPieceRateNo('PieceRateNo_"+rowindex+"','PieceRateNospan_"+rowindex+"')\"></button><SPAN id=PieceRateNospan_"+rowindex+" name=PieceRateNospan_"+rowindex+"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type='hidden' id='PieceRateNo_"+rowindex+"' name='PieceRateNo_"+rowindex+"'>";
    oDiv.innerHTML = sHtml
    oCell.appendChild(oDiv);

    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<button type='button' class=Browser onclick=\"getDate('PieceRateDatespan_"+rowindex+"','PieceRateDate_"+rowindex+"')\"></button><SPAN id=\"PieceRateDatespan_"+rowindex+"\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><input type='hidden' class=inputstyle name='PieceRateDate_"+rowindex+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#E7E7E7";
    var oDiv = document.createElement("div");
    var sHtml = "<input type='text' class=inputstyle size=10 name='PieceNum_"+rowindex+"' maxlength=13 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' onchange=\"checkinput('PieceNum_"+rowindex+"','PieceNumspan_"+rowindex+"')\"><SPAN id=\"PieceNumspan_"+rowindex+"\"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>";
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
    document.all('checkfield').value = document.all('checkfield').value+"UserCode_"+rowindex+",PieceRateNo_"+rowindex+",PieceNum_"+rowindex+",";
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
                    document.all('checkfield').value = (document.all('checkfield').value+",").replace("UserCode_"+document.frmMain.elements[i].value+",","");
                    document.all('checkfield').value = (document.all('checkfield').value+",").replace("PieceRateNo_"+document.frmMain.elements[i].value+",","");
                    document.all('checkfield').value = (document.all('checkfield').value+",").replace("PieceNum_"+document.frmMain.elements[i].value+",","");
                }
                rowsum1 -=1;
            }
        }
        document.all("rownum").value=curindex;
    }
}
</script>
<SCRIPT LANGUAGE=VBScript>
sub onShowUserCode1(inputename,spanname)
	idtmp = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/PieceRateUserCodeBrowser.jsp?sqlwhere=<%=sqlwhere%>")
	if (Not IsEmpty(idtmp)) then
		if idtmp<> "" then
			document.all(spanname).innerHtml = idtmp
			document.all(inputename).value = idtmp
		else
			document.all(spanname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			document.all(inputename).value = ""
		end if
	end if
end sub

sub onShowPieceRateNo1(inputename,spanname)
	idtmp = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/PieceRateNoBrowser.jsp?sqlwhere=<%=sqlwhere_1%>")
	if (Not IsEmpty(idtmp)) then
		if idtmp<> "" then
			document.all(spanname).innerHtml = idtmp
			document.all(inputename).value = idtmp
		else
			document.all(spanname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			document.all(inputename).value = ""
		end if
	end if
end sub
</script>
<script type="text/javascript">
function onShowUserCode(inputename,spanname){
	idtmp = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/PieceRateUserCodeBrowser.jsp?sqlwhere=<%=sqlwhere%>");
	if (idtmp) {
		if(idtmp){
			$G(spanname).innerHTML = idtmp.name;
			$G(inputename).value = idtmp.id;
		}else{
			$G(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			$G  (inputename).value = "";
		}
	}
}

function onShowPieceRateNo(inputename,spanname){
	idtmp = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/PieceRateNoBrowser.jsp?sqlwhere=<%=sqlwhere_1%>")
	if (idtmp){
		if (idtmp.id!="") {
			$G(spanname).innerHTML = idtmp.name;
			$G(inputename).value = idtmp.id;
		}else{
			$G(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			$G(inputename).value = "";
		}
	}
}

</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>