
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CompensationTargetMaint" class="weaver.hrm.finance.compensation.CompensationTargetMaint" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
boolean hasright=true;
boolean canEdit=true;
if(!HrmUserVarify.checkUserRight("Compensation:Maintenance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
String currentyear =Util.null2String(request.getParameter("CompensationYear"));
String currentmonth =Util.null2String(request.getParameter("CompensationMonth"));

String showname="";
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Maintenance",subcompanyid);
    if(operatelevel<0){
        hasright=false;
    }
    if(operatelevel<1) canEdit=false;
    }else{
       hasright=false;
    }
}
//判断是否为部门级权限
int maxlevel=0;
RecordSet.executeSql("select c.rolelevel from SystemRightDetail a, SystemRightRoles b,HrmRoleMembers c where b.roleid=c.roleid and a.rightid = b.rightid and a.rightdetail='Compensation:Maintenance' and c.resourceid="+user.getUID()+" order by c.rolelevel");
while(RecordSet.next()){
    int rolelevel=RecordSet.getInt(1);
    if(maxlevel<rolelevel) maxlevel=rolelevel;
    if(rolelevel==0){
        if(user.getUserDepartment()!=departmentid)
        hasright=false;
        else
        hasright=true;
    }
}
if(maxlevel<1 && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
ArrayList targetlist=new ArrayList();
ArrayList targetnamelist=new ArrayList();
String subcomidstr=subcompanyid+"";
if(subcompanyid>0){
    showname=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
    String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Maintenance", -1);
    ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
    subcomidstr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
}
if(departmentid>0)
    showname+="/"+DepartmentComInfo.getDepartmentname(""+departmentid);
CompensationTargetMaint.getDepartmentTarget(subcompanyid,departmentid,user.getUID(),"Compensation:Maintenance", -1,true);
targetlist=CompensationTargetMaint.getTargetlist();
targetnamelist=CompensationTargetMaint.getTargetnamelist();
if(departmentid<1){
    //hasright=false;
}
int cols=4+targetlist.size();
if(departmentid<1)
cols=cols+2;
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
function showdeptCompensation(deptid,xuhao){
    var ajax=ajaxinit();
    ajax.open("POST", "CompensationTargetViewAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subCompanyId=<%=subcompanyid%>&departmentid="+deptid+"&xuhao="+xuhao+"&CompensationYear=<%=currentyear%>&CompensationMonth=<%=currentmonth%>&userid=<%=user.getUID()%>&showdept=<%=departmentid%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("div"+deptid).innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19430,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",CompensationTargetMaintEdit.jsp?isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&CompensationYear="+currentyear+"&CompensationMonth="+currentmonth+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:ondelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CompensationTargetMaint.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+",_self} " ;
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
<FORM id=weaver name=frmMain action="CompansationTargetMaintOperation.jsp" method=post enctype="multipart/form-data" >
<input type="hidden" id="option" name="option" value="">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(19464,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></TD>
          <TD class=Field><%=showname%><input class=inputstyle type="hidden"  name="subcompanyid" value="<%=subcompanyid%>">
              <input class=inputstyle type="hidden"  name="departmentid" value="<%=departmentid%>"></TD>
   </TR>
   <TR class= Spacing><TD class=Line colSpan=2></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19465,user.getLanguage())%></TD>
          <TD class=Field>
          <%=currentyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=currentmonth%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
          <input type="hidden" name="CompensationYear" value="<%=currentyear%>">
          <input type="hidden" name="CompensationMonth" value="<%=currentmonth%>">
          </TD>
   </TR>
 <TR class= Spacing><TD class=Line1 colSpan=2></TD></TR>
 </TBODY></TABLE>

 <br>
<%
    int widthint=450;
    if(departmentid<1){
        widthint+=400;
    }
    for(int i=0;i<targetlist.size();i++){
        widthint+=100;
    }
%>
<table width="<%=widthint%>">
  <TR style="HEIGHT: 30px ;BORDER-Spacing:1pt;word-wrap:break-word; word-break:break-all;">
    <TH colSpan="<%=cols%>" style="COLOR: #003366 ;TEXT-ALIGN:left;TEXT-VALIGN:middle"><%=SystemEnv.getHtmlLabelName(19454,user.getLanguage())%></TH>
  </TR>
</table>
<TABLE class=ListStyle cellspacing=1 id="oTable" width="<%=widthint%>">
  <TR class=header style="HEIGHT: 30px ;BORDER-Spacing:1pt;word-wrap:break-word; word-break:break-all;">
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="50"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
  <%if(departmentid<1){%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></TH>
  <%}%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=SystemEnv.getHtmlLabelName(19401,user.getLanguage())%></TH>
  <%for(int i=0;i<targetlist.size();i++){%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="100"><%=targetnamelist.get(i)%></TH>
  <%}%>
  <TH style="TEXT-ALIGN:center;TEXT-VALIGN:middle" width="200"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
  </TR>
  <tr>
       <td colspan="<%=cols%>">
  <%
  String sql="";
  int i=0;
  if(departmentid>0){
      sql="select a.departmentid,count(a.id) from hrmresource a left join HRM_CompensationTargetInfo b on a.id=b.Userid and b.CompensationYear="+currentyear+" and b.CompensationMonth="+Util.getIntValue(currentmonth)+" where a.subcompanyid1="+subcompanyid+" and a.departmentid="+departmentid+" and a.status in(0,1,2,3) group by a.departmentid";
  }else{
      sql="select a.departmentid,count(a.id) from hrmresource a left join HRM_CompensationTargetInfo b on a.id=b.Userid and b.CompensationYear="+currentyear+" and b.CompensationMonth="+Util.getIntValue(currentmonth)+" where a.subcompanyid1 in("+subcomidstr+") and a.status in(0,1,2,3) group by a.departmentid order by a.departmentid";
  }
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
      int viewdeptid=RecordSet.getInt(1);
      int rows=RecordSet.getInt(2);
      if(rows>0){
  %>
  <div id="div<%=viewdeptid%>"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
  <script>showdeptCompensation("<%=viewdeptid%>","<%=i%>");</script>
  </div>
  <%
          i+=rows;
      }
  }
  %>
  </td>
   </tr>
</TABLE>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
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
function ondelete(obj){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
        frmMain.option.value="delete";
        obj.disabled=true;
        frmMain.submit();
    }
}
</script>
</BODY>
</HTML>