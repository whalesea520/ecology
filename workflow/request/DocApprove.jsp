<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid=user.getUID()+"";
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"-"+ResourceComInfo.getResourcename(userid);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
String sql="select * from docdetail where docstatus='3' order by doccreatedate desc,doccreatetime desc";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	int seccategory = RecordSet.getInt("seccategory");
	int ownerid=RecordSet.getInt("ownerid");
	int docdepartmentid=RecordSet.getInt("docdepartmentid");
	//子目录信息
   SecCategoryManager.setId(seccategory);
   SecCategoryManager.getCategoryInfoById();
    String  ausertype=Util.null2String(""+SecCategoryManager.getAusertype());
    String  aroleid1=Util.null2String(""+SecCategoryManager.getAroleid1());
    String  arolelevel1=Util.null2String(""+SecCategoryManager.getArolelevel1());
    String  aroleid2=Util.null2String(""+SecCategoryManager.getAroleid2());
    String  arolelevel2=Util.null2String(""+SecCategoryManager.getAcrolelevel2());
    String  aroleid3=Util.null2String(""+SecCategoryManager.getAroleid3());
    String  arolelevel3=Util.null2String(""+SecCategoryManager.getArolelevel3());
    SecCategoryManager.closeStatement();
    
    int canapprove = 0;
//批准：满足子目录下定义的批准人条件并且文档处于待批准状态
	if(ausertype.equals("RM")){
		if(user.getUID() == Util.getIntValue(ResourceComInfo.getManagerID(""+ownerid),0))
			canapprove = 1;
	}
	if(ausertype.equals("IM")){
		
	}
	if(ausertype.equals("CM")){
		if(user.getUID() == Util.getIntValue(CustomerInfoComInfo.getCustomerInfomanager(""+ownerid),0))
			canapprove = 1;
	}
	if(ausertype.equals("PM")){
		if(user.getUID() == Util.getIntValue(ProjectInfoComInfo.getProjectInfomanager(""+ownerid),0))
			canapprove = 1;
	}
	if(!aroleid1.equals("")){
		if(CheckUserRight.checkUserRight(""+user.getUID(),aroleid1,arolelevel1))
			canapprove=1;
	}
	if(!aroleid2.equals("")){
		if(CheckUserRight.checkUserRight(""+user.getUID(),aroleid2,arolelevel2))
			canapprove=1;
	}
	if(!aroleid3.equals("")){
		if(CheckUserRight.checkUserRight(""+user.getUID(),aroleid3,arolelevel3))
			canapprove=1;
	}
//(如果子目录下的审批人没有,将由满足条件的文档管理员审批)
if(HrmUserVarify.checkUserRight("DocDsp:Approve",user,docdepartmentid))
			canapprove =1;
	
	if(canapprove==1){
		String maincategory=RecordSet.getString("maincategory");
		String subcategory=RecordSet.getString("subcategory");
		%>
		<UL style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 1px; MARGIN-LEFT: 25px">
  <LI style="MARGIN-BOTTOM: 3px"><NOBR><%=RecordSet.getString("doclastmoddate")%> <%=RecordSet.getString("doclastmodtime")%>&nbsp;<A 
  href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("id")%>"><B><%=RecordSet.getString("docsubject")%></B></A>, 
  &nbsp; </NOBR>
  <DIV ><NOBR>
  <DIV style="MARGIN-LEFT: 126px"><%=MainCategoryComInfo.getMainCategoryname(maincategory)%>/<%=SubCategoryComInfo.getSubCategoryname(subcategory)%>/<%=SecCategoryComInfo.getSecCategoryname(seccategory+"")%>  
  <a href="javaScript:openhrm(<%=ownerid%>);" onclick='pointerXY(event);'>
  <%=Util.toScreen(ResourceComInfo.getResourcename(ownerid+""),user.getLanguage())%></a>
  <%=RecordSet.getString("doccreatedate")%>  
  <%=RecordSet.getString("doccreatetime")%> 
  <%=Util.add0(Util.getIntValue(RecordSet.getString("id"),0),12)%>
  </DIV></NOBR></DIV>	
		</li></ul>
		<%
	}
}
%>