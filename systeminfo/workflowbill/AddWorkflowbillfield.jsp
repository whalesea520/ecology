<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/BacoSystem_wev8.css" type=text/css rel=STYLESHEET>
<%
    String ht = "";
    int billid = Util.getIntValue(request.getParameter("id"),0);
    String dsporder = "0";
    String fieldviewtype = "0";
    if(session.getAttribute("current_fieldviewtype")!=null){
        fieldviewtype = session.getAttribute("current_fieldviewtype")+"";
    }
    rs.executeSql("select max(dsporder)+1 from workflow_billfield where billid="+billid);
    if(rs.next()){
        dsporder = rs.getString(1);
    }
%>

<script language="javascript">
  function showtype(){
    ht = document.addfieldform.fieldhtmltype.value;
    if(ht == 3){
       document.all("fieldtype1").style.display='none';
       document.all("fieldtype2").style.display='';
       return;
    }
    if(ht == 1){
       document.all("fieldtype1").style.display='';
       document.all("fieldtype2").style.display='none';
       return;
    }
    document.all("fieldtype1").style.display='none';
    document.all("fieldtype2").style.display='none';
    return;
  }
  function typechange(){
     ht = document.addfieldform.fieldhtmltype.value;
     if(ht == 3){
       document.addfieldform.fieldtype.value=document.addfieldform.fieldtype2.value;
       return;
     }
     if(ht == 1){
       document.addfieldform.fieldtype.value=document.addfieldform.fieldtype1.value;
       return;
     }
     return;
  }
  function back(){
        location = "ViewWorkflowbill.jsp?id=<%=billid%>";
    }
</script>
</head>
<body>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC_wev8.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>添加: 工作流单据字段</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=addfieldform method=post action="WorkflowbillOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <BUTTON class=btn id=btnBack accessKey=B name=btnBack onclick="back()"><U>D</U>-返回</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
          <TR class=Section>
            <TH colSpan=5>字段信息</TH>
          </TR>
<%
String errorMsg=Util.null2String(request.getParameter("errorMsg"));
if(errorMsg.equals("1")) {
%>
          <TR class=Section>
            <TH colSpan=5>单据ID已经被占用,请重新选择</TH>
          </TR>
          <%}%>
          <TR class=Separator>
            <TD class=sep1 colSpan=5></TD>
          </TR>
                    <TR>
            <TD>单据ID</TD>
<%
int id_1= 0;
String maxIdSql = "";
if(rs.getDBType().equals("oracle")){
maxIdSql="select id from (select id from workflow_billfield order by id desc) where rownum=1 ";
}else{
maxIdSql = "select top 1 id  from workflow_billfield order by id desc";
}
rs.executeSql(maxIdSql);
if(rs.next()){
id_1= Util.getIntValue(rs.getString("id"),0);
}
id_1=id_1+1;
%>
            <TD Class=Field><%=id_1%>
            <INPUT  type=hidden name="fieldid" value=<%=id_1%>>
            </TD>
          </TR>
          <TR>
            <TD>字段名称</TD>
            <TD Class=Field><INPUT class=text accessKey=Z name=fieldname></TD>
          </TR>
          <TR>
            <TD>字段显示</TD>
            <TD Class=Field><INPUT class=text accessKey=Z name=fielddesc></TD>
          </TR>
          <TR>
            <TD>字段数据库类型</TD>
            <TD Class=Field><INPUT class=text accessKey=Z name=fielddbtype  onkeydown="viewDbType(this)"></TD>
            <script language="javascript">
                var ary = new Array();
                ary[0]="int";
                ary[1]="varchar(50)";
                ary[2]="char(1)";
                ary[3]="char(10)";
                ary[4]="char(8)";
                ary[5]="decimal(15,3)";
                var dbTypeIndex;
                dbTypeIndex = 5;
                function viewDbType(obj){
                    //alert(window.event.keyCode);
                    if(window.event.keyCode=="38"){
                        //alert("up");
                        dbTypeIndex--;
                        if(dbTypeIndex < 0){
                            dbTypeIndex = 5;
                            obj.value = ary[dbTypeIndex];
                        }else{
                            obj.value = ary[dbTypeIndex];
                        }
                        if(obj.value=="varchar(50)"){
                            window.event.keyCode=37;
                        }
                    }else if(window.event.keyCode == "40"){
                        //alert("down");
                        dbTypeIndex++;
                        if(dbTypeIndex > 5){
                            dbTypeIndex = 0;
                            obj.value = ary[dbTypeIndex];
                        }else{
                            obj.value = ary[dbTypeIndex];
                        }
                        if(obj.value=="varchar(50)"){
                            window.event.keyCode=37;
                        }
                    }

                }
            </script>
          </TR>
          <TR>
            <TD>字段显示类型</TD>
<!--            <TD Class=Field><INPUT class=text accessKey=Z name=fieldhtmltype></TD>-->
            <TD Class = Field>
                 <select name = fieldhtmltype onchange= showtype()>
                   <option value="0"> </option>
                   <option value="1"><%=Util.null2String(SystemEnv.getHtmlLabelName(688,user.getLanguage()))%> </option>
                   <option value="2"><%=Util.null2String(SystemEnv.getHtmlLabelName(689,user.getLanguage()))%> </option>
                   <option value="3"><%=Util.null2String(SystemEnv.getHtmlLabelName(695,user.getLanguage()))%></option>
                   <option value="4"><%=Util.null2String(SystemEnv.getHtmlLabelName(691,user.getLanguage()))%></option>
                   <option value="5"><%=Util.null2String(SystemEnv.getHtmlLabelName(690,user.getLanguage()))%></option>
                 </select>
              </TD>
          </TR>
          <input type=hidden name=fieldtype>
          <TR>
            <TD>字段类型</TD>
<!--            <TD Class=Field><INPUT class=text accessKey=Z name=fieldtype></TD>-->
            <TD class = Field>
               <select name = fieldtype1 style=display:none onchange=typechange()>
                 <option value= "0"></option>
                 <option value = "1"><%=Util.null2String(SystemEnv.getHtmlLabelName(608,user.getLanguage()))%></option>
                 <option value = "2"><%=Util.null2String(SystemEnv.getHtmlLabelName(696,user.getLanguage()))%></option>
                 <option value = "3"><%=Util.null2String(SystemEnv.getHtmlLabelName(697,user.getLanguage()))%></option>
               </select>
               <select name = fieldtype2 style=display:none onchange=typechange()>
               <option value= "0"></option>
<%
  String sql = "select id ,labelid from workflow_browserurl order by id ";
  rs.executeSql(sql);
  while(rs.next()){
    int id = Util.getIntValue(rs.getString("id"),0);
    int labelid = Util.getIntValue(rs.getString("labelid"),0);
%>
                 <option value="<%=id%>"><%=Util.null2String(SystemEnv.getHtmlLabelName(labelid,user.getLanguage()))%></option>
<%
  }
%>
               </select>
            </TD>

          </TR>
          <TR>
            <TD>字段显示顺序</TD>
            <TD Class=Field><INPUT class=text accessKey=Z name=fielddsporder value="<%=dsporder%>"></TD>
          </TR>
          <TR>
            <TD>字段所属表类型</TD>
            <TD Class=Field>
            <select name=fieldviewtype>
                <option value="0" <%=fieldviewtype.equals("0")?"selected":""%>>main table</option>
                <option value="1" <%=fieldviewtype.equals("1")?"selected":""%>>detail table</option>
            </select>
            </TD>
          </TR>
          </TBODY>
        </TABLE>
<input type="hidden" name="operation" value="addWorkflowbillfield">
<input type=hidden name=id value="<%= billid%>">
      </FORM>

</body>
</html>