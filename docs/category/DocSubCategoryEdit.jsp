
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:pointer;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{background-image:url(/images/tab2_wev8.png);cursor:pointer;text-align:center;border-bottom:1px solid #879293;}
.cycleTDCurrent{padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:pointer;text-align:center;}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(66,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
int reftree = Util.getIntValue(request.getParameter("reftree"),0);
int tab = Util.getIntValue(request.getParameter("tab"),0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0" id="tabPane">
<input type="hidden" name="id" value="<%=id%>">
	<colgroup>
	<col width="79"></col>
	<col width="79"></col>
	<col width="*"></col>
	</colgroup>
	<TBODY>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr align=left height="22">
		<td class="cycleTDCurrent" name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2_wev8.png" width=79px  align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(0)" title="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></span></td>
		<td class="cycleTD" name="oTDtype_1"  id="oTDtype_1" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(1)" title="<%=SystemEnv.getHtmlLabelName(19174,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;float:left;width:79px;"><%=SystemEnv.getHtmlLabelName(19174,user.getLanguage())%></span></td>
		<td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" style="padding:0;">
		<iframe src="DocSubCategoryBaseInfoEdit.jsp?id=<%=id%><%=(errorcode>0?"&errorcode="+errorcode:"")%><%=(messageid>0?"&message="+messageid:"")%>" ID="iframeAlert" name="iframeAlert" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"></iframe>
		</td>
	</tr>
	</TBODY>
</table>
<SCRIPT language="javascript">
function resetbanner(objid){
	for(i=0;i<2;i++){
		document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
		document.all("oTDtype_"+i).className="cycleTD";
	}
	//jQuery("#oTDtype_"+objid).css("background","/images/tab.active2_wev8.png");
	//jQuery("#oTDtype_"+objid).addClass("cycleTDCurrent");
	document.all("oTDtype_"+objid).background="/images/tab.active2_wev8.png";
	document.all("oTDtype_"+objid).className="cycleTDCurrent";
	var o = document.getElementById("iframeAlert");
	if(objid==0){
		o.src="DocSubCategoryBaseInfoEdit.jsp?id=<%=id%><%=(errorcode>0?"&errorcode="+errorcode:"")%><%=(messageid>0?"&message="+messageid:"")%>";
	}else if(objid==1){
		o.src="DocSubCategoryRightEdit.jsp?id=<%=id%>";
	}
}
if("<%=reftree%>"==1) window.parent.frames["leftframe"].document.location.reload();
if("<%=tab%>"!="0") resetbanner(<%=tab%>);
</script>
</BODY>
</HTML>
<%--

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryManager" class="weaver.docs.category.SubCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String categoryname=SubCategoryComInfo.getSubCategoryname(""+id);
String coder = SubCategoryComInfo.getCoder(""+id);
int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+id),0);
int fathersubid = Util.getIntValue(SubCategoryComInfo.getFatherSubCategoryid(""+id),-1);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
boolean canEdit = false;
boolean canAdd = false;
boolean canDelete = false;
boolean canLog = false;
boolean hasSubManageRight = false;
AclManager am = new AclManager();

/* 以下通过结合旧类型的edit权限和新类型的CREATEDIR权限来设定是否可以编辑 */
//hasSubManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:edit", user) || hasSubManageRight) {
    canEdit = true;
}

//if (HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user)) {
//    canAdd = true;
//} else {
//    if (fathersubid < 0) {
//        canAdd = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
//    } else {
//        canAdd = am.hasPermission(fathersubid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
//    }
//}

if (HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user) || hasSubManageRight) {
    canAdd = true;
}

if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:Delete", user) || hasSubManageRight) {
    canDelete = true;
}
if (HrmUserVarify.checkUserRight("DocSubCategory:log", user) || hasSubManageRight) {
    canLog = true;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(66,user.getLanguage())+":"+categoryname;
String needfav ="1";
String needhelp ="";
CategoryManager cm = new CategoryManager();
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
<%
if(messageid !=0) {
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%></font></DIV>
<%}%>
<%
if(errorcode == 10) {
%>
<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
<%}%>
<FORM id=weaver name=frmMain action="SubCategoryOperation.jsp" method=post>
<DIV>
<%
//if(HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)){
if (canEdit) {
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canAdd){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocSubCategoryAdd.jsp?id="+mainid+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canDelete){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canLog){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=66&sqlwhere="+xssUtil.put("where operateitem=2 and relatedid="+id)+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="55%">
  <COL width="45%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
            <td align=right>
                <A href="DocMainCategory.jsp"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></A> >
            	<A href="DocMainCategoryEdit.jsp?id=<%=mainid%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></A>
<%              RecordSet rs = cm.getSuperiorSubCategoryList(id, AclManager.CATEGORYTYPE_SUB);
                while (rs.next()) {         %>
                     >
                    <A href="DocSubCategoryEdit.jsp?id=<%=rs.getInt("subcategoryid")%>"><%=Util.toScreen(rs.getString("subcategoryname"), user.getLanguage())%></A>
<%              }                           %>
            </td>

          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="id" value="<%=id%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></TD>
        </TR>
<TR><TD class=Line colSpan=2></TD></TR>
<%      if (fathersubid >= 0) {   %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="subid" value="<%=fathersubid%>"><%=SubCategoryComInfo.getSubCategoryname(""+fathersubid)%></TD>
        </TR>
<TR><TD class=Line colSpan=2></TD></TR>
<%      }                   %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="mainid" value="<%=mainid%>"><%=id%></TD>
        </TR>
<TR><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT class=InputStyle maxLength=60 size=50 name="categoryname" value="<%=categoryname%>"
          onChange="checkinput('categoryname','categorynamespan')"><%}else{%><%=categoryname%><%}%>
          <span id=categorynamespan><%if(categoryname.equals("")){%><IMG src="../../images/BacoError_wev8.gif" align=absMiddle><%}%></span>
          <INPUT type=hidden maxLength=60 size=50 name="srccategoryname" value="<%=categoryname%>">
          </TD>
        </TR>
<TR><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19388,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=20 size=20 class=InputStyle name="coder" value="<%=coder%>"><%}else{%><%=coder%><%}%></TD>
         </TR>
<TR><TD class=Line colSpan=2></TD></TR>
        </TBODY></TABLE></TD>
        <TD vAlign=top>
<%
   int[] labels = {92,633,385};
   int operationcode = AclManager.OPERATION_CREATEDIR;
   int categorytype = AclManager.CATEGORYTYPE_SUB;
%>
<%@ include file="/docs/category/PermissionList.jsp" %>
        </TD>
        </TR></TBODY></TABLE>

<input type=hidden name="operation">
<!-- 分目录列表 -->
<!-- 因多级目录还未做完, 这里将分目录列表和在分目录下创建分目录屏蔽, 谭小鹏 2003-06-17
<TABLE class=ListStyle>
  <COLGROUP>
	<COL width="30%">
	<COL width="70%">
  <TBODY>
  <TR class=Title>
    <TD><B><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></B></TD>
    <TD align=right><A
      href="DocSubCategoryAdd.jsp?id=<%=mainid%>&subid=<%=id%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A></TD></TR>
  <TR class=Spacing>
    <TD class=Sep2 colSpan=2></TD></TR>
  <TR class=Header>
      <TD colSpan=2><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
    </TR>
    <%
  SubCategoryManager.selectCategoryInfo(id);
  int i=0;
  while(SubCategoryManager.next()){
  	int subid = SubCategoryManager.getCategoryid();
  	String name = SubCategoryManager.getCategoryname();
  	if(i==0){
  		i=1;
  %>
  <TR class=datalight>
  <%}else{
  		i=0;
  %>
  <TR class=datadark>
  <% }%>
  <td><%=subid%></td>
  <td> <a href="DocSubCategoryEdit.jsp?id=<%=subid%>"><%=name%></a></td></tr>
  <%
  }
  SubCategoryManager.closeStatement();
  %>
</TBODY></TABLE>
-->
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
	<COL width="30%">
	<COL width="70%">
  <TBODY>
  <TR class=header>
    <TD><B><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></B></TD>
    <TD align=right><A
      href="DocSecCategoryAdd.jsp?id=<%=id%>&mainid=<%=mainid%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A></TD></TR>
  <TR class=Header>
      <TD colSpan=2><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD>
    </TR>
<TR class=Line><TD colSpan=2></TD></TR>
    <%
SecCategoryManager.setSubcategoryid(id);
SecCategoryManager.selectCategoryInfo();
  i=0;
  while(SecCategoryManager.next()){
  	int secid = SecCategoryManager.getId();
  	String name = SecCategoryManager.getCategoryname();
  	if(i==0){
  		i=1;
  %>
  <TR class=datalight>
  <%}else{
  		i=0;
  %>
  <TR class=datadark>
  <% }%>
  <td><%=secid%></td>
  <td> <a href="DocSecCategoryEdit.jsp?id=<%=secid%>"><%=name%></a></td></tr>
  <%
  }
  SecCategoryManager.closeStatement();
  %>
</TBODY></TABLE>

<script>
function onSave(){
	if(check_form(document.frmMain,'categoryname')){
		document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {

		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}
}
</script>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
--%>