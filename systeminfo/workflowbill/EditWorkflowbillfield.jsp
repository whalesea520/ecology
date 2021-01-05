<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import = "weaver.systeminfo.workflowbill.WorkFlowBillUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page"/>

<%
WorkFlowBillUtil wf = new WorkFlowBillUtil();
if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageWorkflowbill.jsp");
}
%>

<html>
<head>
<LINK href="/css/BacoSystem_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC_wev8.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>编辑: 工作流单据字段</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=editfieldform method=post action="WorkflowbillOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <BUTTON class=btn id=btnBack accessKey=B name=btnBack onclick="back()"><U>D</U>-返回</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
          <TR class=Section>
            <TH colSpan=5>单据信息</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep1 colSpan=5></TD>
          </TR>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String indexdesc = Util.toScreen(request.getParameter("indexdesc"),user.getLanguage(),"0");
String sql = "select * from workflow_billfield where id = "+id;
rs.executeSql(sql);
while(rs.next()){
   int billid = Util.getIntValue(rs.getString("billid"),0);
   int label = Util.getIntValue(rs.getString("fieldlabel"),0);
   String name = rs.getString("fieldname");
   String dbtype = rs.getString("fielddbtype");
   String htmltype = rs.getString("fieldhtmltype");
   int ht = Util.getIntValue(htmltype,0);
   int type = Util.getIntValue(rs.getString("type"),0);
   int typeforview = wf.getType(ht,type);
   int dsporder = Util.getIntValue(rs.getString("dsporder"),0);
   int viewtype = Util.getIntValue(rs.getString("viewtype"),0);
%>

          <TR>
            <TD>字段ID</TD>
            <TD Class=Field><%=id%>
            <INPUT  type=hidden name="id" value=<%=id%>>
            </TD>
          </TR>
          <TR>
            <TD>单据ID</TD>
            <TD Class=Field><INPUT class=FieldxLong  name="billid" value="<%= billid%>"> </TD>
          </TR>
          <TR>
            <TD>字段名</TD>
            <TD Class=Field><INPUT  name="fieldname" value=<%=name%>></TD>
          </TR>
          <TR>
            <TD>字段显示名称</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=indexdesc value="<%= indexdesc%>"></TD>
            <TD><input type=hidden name=fieldlabel value="<%= label%>"></TD>
          </TR>
          <TR>
            <TD>字段数据库类型</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=fielddbtype value="<%= dbtype%>" onkeydown="viewDbType(this)"> </TD>
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
            <TD>字段页面类型</TD>
<!--            <TD Class=Field><INPUT class=FieldxLong  name=fieldhtmltype value="<%= htmltype%>"></TD>-->
           <TD Class=Field>
             <select name=fieldhtmltype onchange="showtype()">
                   <option value="1" <%if(htmltype.equals("1")){%>selected<%}%> > <%=Util.null2String(SystemEnv.getHtmlLabelName(688,user.getLanguage()))%> </option>
                   <option value="2" <%if(htmltype.equals("2")){%>selected<%}%> > <%=Util.null2String(SystemEnv.getHtmlLabelName(689,user.getLanguage()))%> </option>
                   <option value="3" <%if(htmltype.equals("3")){%>selected<%}%> > <%=Util.null2String(SystemEnv.getHtmlLabelName(695,user.getLanguage()))%> </option>
                   <option value="4" <%if(htmltype.equals("4")){%>selected<%}%> > <%=Util.null2String(SystemEnv.getHtmlLabelName(691,user.getLanguage()))%> </option>
                   <option value="5" <%if(htmltype.equals("5")){%>selected<%}%> > <%=Util.null2String(SystemEnv.getHtmlLabelName(690,user.getLanguage()))%> </option>
            </select>
          </TD>
          </TR>
          <TR>
            <TD>字段类型</TD>
            <input type=hidden name=fieldtype value="<%= type%>">
            <TD class = Field>
<%
  if(htmltype.equals("1")){

%>
               <select name = fieldtype1 style=display:'' onchange=typechange()>
<%
  }else{
%>
               <select name = fieldtype1 style=display:none onchange=typechange()>
<%
  }
%>
                 <option value = "0"<%if(htmltype.equals("1")&&type>3){%>selected<%}%>></option>
                 <option value = "1"<%if(htmltype.equals("1")&&type==1){%>selected<%}%>><%=Util.null2String(SystemEnv.getHtmlLabelName(608,user.getLanguage()))%> </option>
                 <option value = "2"<%if(htmltype.equals("1")&&type==2){%>selected<%}%>><%=Util.null2String(SystemEnv.getHtmlLabelName(696,user.getLanguage()))%></option>
                 <option value = "3"<%if(htmltype.equals("1")&&type==3){%>selected<%}%>><%=Util.null2String(SystemEnv.getHtmlLabelName(697,user.getLanguage()))%></option>
               </select>
<%
  if(htmltype.equals("3")){

%>
               <select name = fieldtype2 style=display:'' onchange=typechange()>
<%
  }else{
%>
               <select name = fieldtype2 style=display:none onchange=typechange()>
<%
  }
%>

<%
  sql = "select id ,labelid from workflow_browserurl order by id ";
  rst.executeSql(sql);
  while(rst.next()){
    int browserid = Util.getIntValue(rst.getString("id"),0);
    int labelid = Util.getIntValue(rst.getString("labelid"),0);
%>
                  <option value="<%=browserid%>" <%if(type == browserid){%>selected <%}%>><%=Util.null2String(SystemEnv.getHtmlLabelName(labelid,user.getLanguage()))%></option>
<%
  }
%>
               </select>
            </TD>

          </TR>
          <%--<TR>--%>
          <%--  <TD>字段显示顺序</TD>--%>
          <%--  <TD Class=Field><INPUT class=FieldxLong  name=fielddsporder value="<%= dsporder%>"></TD>--%>
          <%--</TR>--%>
          <INPUT type="hidden"  name=fielddsporder value="<%= dsporder%>">
          <TR>
            <TD>字段所属表类型</TD>
            <TD Class=Field>
            <select name=fieldviewtype>
                <option value="0" <%=viewtype==0?"selected":""%>>main table</option>
                <option value="1" <%=viewtype==1?"selected":""%>>detail table</option>
            </select>
            </TD>
          </TR>
<%
  }
%>
          </TBODY>
        </TABLE>
<input type="hidden" name="operation" value="editWorkflowbillfield">

      </FORM>
<script language="javascript">
  function showtype(){
    ht = document.editfieldform.fieldhtmltype.value;
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
     ht = document.editfieldform.fieldhtmltype.value;
     if(ht == 3){
       document.editfieldform.fieldtype.value=document.editfieldform.fieldtype2.value;
       return;
     }
     if(ht == 1){
       document.editfieldform.fieldtype.value=document.editfieldform.fieldtype1.value;
       return;
     }
     return;
  }
  function back(){
        location = "ViewWorkflowbillfield.jsp?id=<%=id%>";
    }
</script>

      </BODY>
      </HTML>
