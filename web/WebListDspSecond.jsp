<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init1.jsp" %>
<%@ include file="/web/inc/WebServer.jsp" %>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetImg" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />

<%
//获取参数及设置基本变量
int id = Util.getIntValue(request.getParameter("id"),0);
int start= Util.getIntValue(request.getParameter("start"),1);
int hstart = Util.getIntValue(request.getParameter("hstart"),1);
int journalListID = Util.getIntValue(request.getParameter("journalListID"),0);
int recordersize = 0;
int perpage=0;
String linkstr="";
String usertype = "" ;
String isTime=""+Util.getIntValue(request.getParameter("isTime"),0);
String isPageNo=""+Util.getIntValue(request.getParameter("isPageNo"),0);

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
//perpage = 500 ;
//out.print(newsclause);
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
ArrayList journalIDList = new ArrayList() ;
if (!secid.equals("")) 
{	
	String secidStrTemp = secid + ",";
	String secidTemp = "" ;
	while ((secidStrTemp.indexOf(",")+1)!=secidStrTemp.length())
	{
		secidTemp =	secidStrTemp.substring(0,secidStrTemp.indexOf(",")) ;	
		journalIDList.add(secidTemp) ;
		secidStrTemp= secidStrTemp.substring(secidStrTemp.indexOf(",")+1,secidStrTemp.length()) ;
	}
	secidTemp =	secidStrTemp.substring(0,secidStrTemp.indexOf(",")) ;	
	journalIDList.add(secidTemp) ;
	if (journalListID == 0) journalListID = Util.getIntValue(secidTemp,0);
	String tempsubid=SecCategoryComInfo.getSubCategoryid(""+journalListID);
	String tempmainid=SubCategoryComInfo.getMainCategoryid(tempsubid);	
	newsclause = " maincategory="+tempmainid+" and seccategory in("+journalListID+")";
}


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
String remindMsg = "" ;

String bgcolor = Util.null2String(request.getParameter("bgcolor"));
if (bgcolor.equals("")) bgcolor = "#FFFFFF" ;
%>
<HTML><HEAD>
<script language="JavaScript">
function click() {
if (event.button==2) {return false //alert('信息查看')
}
}
document.onmousedown=click

//-->
</script>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY bgcolor="<%=bgcolor%>">

  <TABLE class=form valign=top>
    <TBODY> 
    <tr> 
    <tr> 
	<!--是否设置了页面背景图片:begin-->
    <%
    if(backgroundpicid!=0){    
    	String imgid="";
    	int imgwidth=0;
    	PicUploadManager.resetParameter();
	    PicUploadManager.setId(backgroundpicid);
	    PicUploadManager.selectImageById();
	    if(PicUploadManager.next()){
            imgid = PicUploadManager.getImagefileid();
            imgwidth = PicUploadManager.getImagefilewidth();
	    }
	    PicUploadManager.closeStatement();
    %>
      <td background = "/weaver/weaver.file.FileDownload?fileid=<%=imgid%>">
    <%}else{%>
	  <td>
    <%}%>
	<!--是否设置了页面背景图片:end-->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" valign=top>
          <tr>
            <td width="100%" valign=top> 
				  <table width="100%" >
				  <form id="journalForm" name="journalForm" action="/web/WebListDspSecond.jsp">
				  <input name="id" type="hidden" value="<%=id%>">
				  <input name="isTime" type="hidden" value="<%=isTime%>">
				  <tr>
					
                  <td width="70%"> 
                    <div align="right">请查看:</div>
                  </td>
                  <td width="30%"> 
                    <div align="right">
                      <select name="journalListID" onchange="javascript:journalForm.submit();">
                        <%
					String journalIDTep = "0" ;
					for (int i=journalIDList.size()-1;i>=0;i--) { 
					journalIDTep = (String)journalIDList.get(i) ;
					%>
                        <option value="<%=journalIDTep%>" <%if(journalListID==Util.getIntValue(journalIDTep,0)) {%>	
					selected
					<%}%>
					> <%=SecCategoryComInfo.getSecCategoryname(journalIDTep)%> 
                        </option>
                        <%}%>
                      </select>
                    </div>
                  </td>
				  </tr>
				  <tr> 
					<td height="1" colspan="2" background="/web/images/bg_hdotline_wev8.gif" class="p9grey"><img src="/web/images/spacer_wev8.gif" width="1" height="1"></td>
				  </tr>
				  </form>
				  </table><BR>
				  <!--主题新闻显示:begin-->
				  <table class=form valign=top>					 
						  <!--根据条件设置自动提取地主题新闻显示:begin-->
						  <%
							boolean isDark = false ;
							int needtr = 0;
							int currec = 0;
							String whereOrAnd = "" ;
							//if (publishtype ==0 ) whereOrAnd =" where " ; //0为发布类型为外部的不需要判断权限
							whereOrAnd =" and " ;
							String newslistclause=newsclause.trim();					
							if(!newslistclause.equals(""))  newslistclause = whereOrAnd + newslistclause ;
							newslistclause = newslistclause + " and docpublishtype='2' and docstatus in('1','2') order by doclastmoddate desc, doclastmodtime desc";
							if (publishtype ==0 )//0为发布类型为外部的不需要判断权限
							{
								DocManager.setSql_where(newslistclause);
								DocManager.selectDocInfo();
							}
							else 
							{
								if (userid==0) 
								{
									DocManager.closeStatement();
									response.sendRedirect("/web/login/noLogin.jsp");
									return;
								}
								DocManager.selectNewsDocInfo(newslistclause,user);
							}

							if (DocManager.getCount()==0) 
								{
									remindMsg = SystemEnv.getHtmlLabelName(23275,user.getLanguage()) +"!";
								}

							while(DocManager.next()){
								int docid = DocManager.getDocid();
								if(docid == importdocid) continue;
								recordersize += 1;
								currec +=1;
								if(currec < start) continue;
								if(currec >= start + perpage) continue;
								needtr +=1;
								
								String docsubject=DocManager.getDocsubject();
								String doccontent=DocManager.getDoccontent();
								String doclastmoddate=DocManager.getDoclastmoddate();
								RecordSetImg.executeSql("select imagefileid from DocImageFile where docid = " + docid + " and docfiletype = '1' ");
								int curimgid = 0 ;
								if (RecordSetImg.next())
								curimgid = Util.getIntValue(RecordSetImg.getString("imagefileid"),0);
						%>
						<tr>						 
							 <td width="15" valign="top"><img src="/web/images/i_wev8.gif" align="right"></td>
							 <td width="" class="p91" valign="top">
							 <a href="<%=webServer%>/web/WebDetailDsp.jsp?id=<%=docid%>&languageid=<%=languageid%>&isTime=<%=isTime%>" target="_blank">
							 <%=docsubject%>
							 </a>								 
							 </td>
							 <td width="80" valign="right" nowrap><%if(isTime.equals("1")){%>[<%=doclastmoddate%>]<%}%>
							 </td>
						</tr>

						<%
							}
							DocManager.closeStatement();
						%>
						  <!--根据条件设置自动提取地主题新闻显示:end-->

				<%if (!remindMsg.equals("")) {%>
					 <tr>
					 <td width=100% height=100% align=center valign=middle style="color:red"> 
					 <%=remindMsg%>
					 </td>
					 </tr>
				 <%}%>

				  </table>
				  <!--主题新闻显示:end-->
            </td>
          </tr>
		  <tr><td>&nbsp;</td><td></td></tr>
		  <%if (!remindMsg.equals("")) {%>
          <tr>
			  <!--主题新闻分页导航:begin-->
			  <td align=center  noWrap > 
					<%linkstr = "/web/WebListDspSecond.jsp?id="+id+"&hstart="+hstart+"&journalListID="+journalListID+"&isTime="+isTime;%>
					<%=Util.makeNavbar4(start, recordersize , perpage, linkstr)%> 
			  </td>
			  <!--主题新闻分页导航:end-->			 
          </tr>
		  <%}%>	
        </table>
      </td>
    </tbody> 
  </table>

</body>