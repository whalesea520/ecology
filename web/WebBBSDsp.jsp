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
int newsid = Util.getIntValue(request.getParameter("newsid"),0);
int subid =  Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+id),0);
int mainid = Util.getIntValue(request.getParameter("mainid"),0);
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
if(newsid != 0) {
    DocNewsManager.resetParameter();
    DocNewsManager.setId(newsid);
    DocNewsManager.getDocNewsInfoById();
	publishtype = DocNewsManager.getPublishtype();
    newsperpage = DocNewsManager.getNewsperpage();
    languageopt = DocNewsManager.getLanguageopt();
    languageid = DocNewsManager.getLanguageid();
    DocNewsManager.closeStatement();
    perpage = newsperpage; 
}

newsclause = " maincategory="+mainid+" and seccategory in("+id+")";

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
	<td>
		<TABLE class=form valign=top width="100%">
		<tr> 
			<td>
			:: <a href="WebBBS.jsp?id=<%=newsid%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></a>	> <%=SecCategoryComInfo.getSecCategoryname(""+id)%>
			</td>
			<td align="right">
			<a href="/web/DocAdd.jsp?newsid=<%=newsid %>&mainid=<%=mainid%>&subid=<%=subid%>&secid=<%=id%>">
			<img src="/web/images/bbs_button_newpost_wev8.gif" border="0"></a>
			</td>
		</tr>
		</table>
	</td>
	</tr>
    <tr> 	
	  <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" valign=top>
          <tr>
            <td width="100%" valign=top> 
				  <!--主题新闻显示:begin-->
				  <table class=form valign=top>
						  <tr bgcolor="229CC4">
						  <td><font color="#FFFFFF">人气</font></td>
						  <td><font color="#FFFFFF">主题</font></td>
						  <td><font color="#FFFFFF">作者</font></td>
						  <td><font color="#FFFFFF">回复</font></td>
						  <td><font color="#FFFFFF">发表日期</font></td>
						  </tr>
						  <!--根据条件设置自动提取地主题新闻显示:begin-->
						  <%
							boolean isDark=false;
							int docidPre = 0 ;
							int needtr = 0;
							int currec = 0;
							String whereOrAnd = "" ;
							if (publishtype ==0 ) whereOrAnd =" where " ; //0为发布类型为外部的不需要判断权限
							else whereOrAnd =" and " ;
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
								DocManager.selectNewsDocInfo(newslistclause,user);
							}
							while(DocManager.next()){
								int docid = DocManager.getDocid();
								if (docidPre==docid) continue;
								if(docid == importdocid) continue;
								recordersize += 1;
								currec +=1;
								if(currec < start) continue;
								if(currec >= start + perpage) continue;
								needtr +=1;								
								String docsubject=DocManager.getDocsubject();
								String doccontent=DocManager.getDoccontent();
								String doclastmoddate=DocManager.getDoclastmoddate();	
								String ownertype=DocManager.getUsertype();
								String username="";
								String isreply="";
								int ownerid=DocManager.getOwnerid();
								int replaydoccount=DocManager.getReplaydoccount();
								/********取出文章被阅读的次数begin***********/
								int readCount_int = 0 ;
								String sql_readCount ="select sum(readCount) from docreadtag where docid =" + docid ;
								rs.execute(sql_readCount);
								if(rs.next()) readCount_int = Util.getIntValue(rs.getString(1),0) ;
								/********取出文章被阅读的次数end***********/
								isreply=DocManager.getIsreply();//如果为0代表它不是一篇回复的文档
						if (!isreply.equals("1")){
							if(isDark){%>								
							<tr bgcolor="#F3F3F3">
							<%}else{%>
							<tr bgcolor="#FFFFFF">
							<%}
							isDark=!isDark;
							%>	
							  <td><%=readCount_int%></td>		
							  <td>
								  <a href="/web/WebBBSDetailDsp.jsp?newsid=<%=newsid%>&mainid=<%=mainid%>&secid=<%=id%>&id=<%=docid%>&languageid=<%=languageid%>">
								   <%=docsubject%>
								  </a>
							  </td>
							  <td> 
							  <%if(ownertype.equals("1"))						   username=Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),7);
							  else								username=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),7);
							  out.print(username);%>
							  </td>
							  <td> 
							  <%=replaydoccount%>	
							  </td>
							  <td><%=doclastmoddate%></td>
							</tr>
						<%} docidPre = docid ;
							}
							DocManager.closeStatement();
						%>
						  <!--根据条件设置自动提取地主题新闻显示:end-->

					
				  </table>
				  <!--主题新闻显示:end-->
            </td>
          </tr>
          
          </tr>
		  <tr><td>&nbsp</td><td></td></tr>
          <tr>
			  <!--主题新闻分页导航:begin-->
			  <td align=center  noWrap > 
					<%linkstr = "/web/WebBBSDsp.jsp?id="+id+"&hstart="+hstart;%>
					<%=Util.makeNavbar(start, recordersize , perpage, linkstr)%> 
			  </td>
			  <!--主题新闻分页导航:end-->			 
          </tr>
        </table>
      </td>
    </tbody> 
  </table>
<!--页脚内容:begin-->
  <TABLE class=form valign=top>
    <TBODY> 
              <%
                if(footerdocid!=0){
                    DocManager.resetParameter();
                    DocManager.setId(footerdocid);
                    DocManager.getDocInfoById();
                    String footerdoccontent=DocManager.getDoccontent();
                    DocManager.closeStatement();
              %>
            <tr>
				<td clospan=2> <%=footerdoccontent%> </td>
            </tr>
            <%}%>
    </tbody> 
  </table>
<!--页脚内容:end-->

</FORM>
</body>