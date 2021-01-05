<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%
//获取参数及设置基本变量
int id = Util.getIntValue(request.getParameter("id"),0);
int start= Util.getIntValue(request.getParameter("start"),1);
int hstart = Util.getIntValue(request.getParameter("hstart"),1);
int recordersize = 0;
int perpage=0;
String linkstr="";
String usertype = "" ;

String frontpagename = "" ;
String frontpagedesc = "" ;
String isactive = "" ;
int departmentid = 0 ;
String linktype = "" ;
String hasdocsubject = "" ;
String hasfrontpagelist = "" ;
int newsperpage = 0 ;
int titlesperpage = 0 ;
int defnewspicid = 0 ;
int backgroundpicid = 0 ;
int importdocid = 0 ;
int headerdocid = 0 ;
int footerdocid = 0 ;
String secopt = "" ;
int seclevelopt = 0;
int departmentopt = 0;
int dateopt = 0;
int languageopt = 0 ;
int languageid = 7 ;
String clauseopt = "" ;
String newsclause = "" ;
int defaultimgid= 0 ;
int defaultimgwidth=0;
int publishtype = 0;
//获取新闻页基本信息
if(id != 0) {
    DocNewsManager.resetParameter();
    DocNewsManager.setId(id);
    DocNewsManager.getDocNewsInfoById();
	publishtype = DocNewsManager.getPublishtype();
    frontpagename = DocNewsManager.getFrontpagename();
    frontpagedesc = DocNewsManager.getFrontpagedesc();
    isactive = DocNewsManager.getIsactive();
    departmentid = DocNewsManager.getDepartmentid();
    linktype = DocNewsManager.getLinktype();
    hasdocsubject = DocNewsManager.getHasdocsubject();
    hasfrontpagelist = DocNewsManager.getHasfrontpagelist();
    newsperpage = DocNewsManager.getNewsperpage();
    titlesperpage = DocNewsManager.getTitlesperpage();
    defnewspicid = DocNewsManager.getDefnewspicid();
    backgroundpicid = DocNewsManager.getBackgroundpicid();
    importdocid =  Util.getIntValue(DocNewsManager.getImportdocid());
    headerdocid = DocNewsManager.getHeaderdocid();
    footerdocid = DocNewsManager.getFooterdocid();
    secopt = DocNewsManager.getSecopt();
    seclevelopt = DocNewsManager.getSeclevelopt();
    departmentopt = DocNewsManager.getDepartmentopt();
    dateopt = DocNewsManager.getDateopt();
    languageopt = DocNewsManager.getLanguageopt();
    languageid = DocNewsManager.getLanguageid();
    clauseopt = Util.toScreenToEdit(DocNewsManager.getClauseopt(),languageid);
    newsclause = DocNewsManager.getNewsclause();
    DocNewsManager.closeStatement();
    perpage = newsperpage; 
}
String mainid = newsclause ;
if (!mainid.equals("")) {
	int indexTemp1 = mainid.indexOf("and") ;
	if (indexTemp1!=-1){
		mainid = mainid.substring(0,indexTemp1);
	}
	int indexTemp2 = mainid.indexOf("=") ;
	if (indexTemp2!=-1){
		mainid = mainid.substring(indexTemp2+1,mainid.length());
	}
	mainid=mainid.trim();
}
//out.print("---"+mainid+"---");
String secid = newsclause ;
if (secid.indexOf("seccategory")==-1) secid = "";
if (!secid.equals("")) {
	int indexTemp1 = secid.indexOf("and") ;
	if (indexTemp1!=-1){
		secid = secid.substring(indexTemp1+3,secid.length());
	}
	int indexTemp2 = secid.indexOf("(") ;
	if (indexTemp2!=-1){
		secid = secid.substring(indexTemp2+1,secid.length());
	}
	indexTemp2 = secid.indexOf(")") ;
	if (indexTemp2!=-1){
		secid = secid.substring(0,indexTemp2);
	}
	secid=secid.trim();
}
if (!secid.equals("")) secid = "," + secid + "," ;
//out.print("---"+secid+"---");
//out.print("---"+newsclause+"---");
//获取缺省图片信息
if(defnewspicid!=0){
    PicUploadManager.resetParameter();
    PicUploadManager.setId(defnewspicid);
    PicUploadManager.selectImageById();
    if(PicUploadManager.next()){
        defaultimgid = Util.getIntValue(PicUploadManager.getImagefileid());
        defaultimgwidth = PicUploadManager.getImagefilewidth();
    }
    int defwidth = Util.getIntValue(SysDefaultsComInfo.getFgpicwidth(),0);
    String deffix = Util.null2String(SysDefaultsComInfo.getFgpicfixtype());

    if(deffix.equals("2"))
        defaultimgwidth = defwidth;
    if(deffix.equals("3"))
        if(defaultimgwidth<defwidth)
            defaultimgwidth=defwidth;
    if(deffix.equals("4"))
        if(defaultimgwidth>defwidth)
            defaultimgwidth=defwidth;
    else if(defwidth != 0) 
        defaultimgwidth = defwidth;

    PicUploadManager.closeStatement();	
}

User user = new User() ;
if(publishtype != 0) { //如publishtype不为0则需要判断权限
	//相当于init.jsp--begin
	user = HrmUserVarify.checkUser(request , response) ;
	if (user==null)
	{
	user = new User() ;
	user.setUid(0);
	user.setLanguage(7);
	user.setLogintype("2");
	}
	//相当于init.jsp--end
}
String bgcolor = Util.null2String(request.getParameter("bgcolor"));
if (bgcolor.equals("")) bgcolor = "#FFFFFF" ;
%>
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/web/css/style_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY bgcolor="<%=bgcolor%>">
<FORM id=form1 name=form1  method="post"  action="/web/WebBBSDsp.jsp?id=<%=id%>">
  <TABLE class=form valign=top>
    <TBODY> 
    <tr> 
    <tr> 
	<td>  
		  <table bgcolor="D8D8D8" valign=top border="0" cellspacing="1" cellpadding="0" width="100%">
		  <COLGROUP> 
		  <COL width=5%> 
		  <COL width=65%>			
		  <COL width=15%>
		  <COL width=15%>
		  <tr bgcolor="229CC4">
		  <td></td>
		  <td><font color="#FFFFFF"><b>讨论区</b></font></td>
		  <td><font color="#FFFFFF"><b>主题</b></font></td>
		  <td><font color="#FFFFFF"><b>回复</b></font></td>
		  </tr>
		  <%
			boolean isDark=false;
			String tempsubidTemp = "";
			String sqlStr ="select * from DocSecCategory order by subcategoryid";
			rs.executeSql(sqlStr);
	  		while(rs.next()){
			String isselect = "";
			String curid = rs.getString("id");
			String curname = rs.getString("categoryname");
			String tempsubid=rs.getString("subcategoryid");
			String tempmainid=SubCategoryComInfo.getMainCategoryid(tempsubid);
			if(!mainid.equals(tempmainid)){
					continue;
			}
			if(!secid.equals("")){
				if(secid.indexOf(","+curid+",")==-1)
					continue;
			}
			String docCount = "0" ;
			sqlStr = "select count(id) from DocDetail where isreply<>'1' and seccategory = " + curid;
			RecordSet.executeSql(sqlStr);
			if (RecordSet.next()) docCount=RecordSet.getString(1);
			String replyDocCount = "0" ;
			sqlStr = "select count(id) from DocDetail where isreply='1' and seccategory = " + curid;
			RecordSet.executeSql(sqlStr);
			if (RecordSet.next()) replyDocCount=RecordSet.getString(1);

			if(!tempsubidTemp.equals(tempsubid)){%>								
			<tr bgcolor="#F3F3F3">
			<td colspan="4"><b><%=SubCategoryComInfo.getSubCategoryname(tempsubid)%></b></td>
			<%}%>
			<tr bgcolor="#FFFFFF">
			<td><img src="/web/images/forum_wev8.gif" ></td>
			<td><a href="/web/WebBBSDsp.jsp?newsid=<%=id%>&mainid=<%=mainid%>&id=<%=curid%>"><%=curname%></a></td>
			<td><%=docCount%></td>
			<td><%=replyDocCount%></td>
			</tr>	
		    <%
			tempsubidTemp = tempsubid;
			}
			%>
			</table> 
      </td>
    </tbody> 
  </table>

</FORM>
</body>