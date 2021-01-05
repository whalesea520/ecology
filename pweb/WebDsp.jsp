
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%!private boolean isInThisArray(String[] Arrary,int x) {
      boolean returnTag = false ;
      for(int i=0;i<Arrary.length;i++){
          if (Arrary[i].equals(""+x))  {
              returnTag = true ;          
              break ;
          }
      }
      return returnTag ;      
}
%>
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" type="text/javascript" src="/FCKEditor/swfobject_wev8.js"></script>
</head>
<%
int id = 0;
String isrequest = Util.null2String(request.getParameter("isrequest"));//判断是否是左边链接进入的页面。
if(isrequest.equals("Y")){
   id = Util.getIntValue(request.getParameter("id"),0);
}else{
while(DocNewsComInfo.next()) {
    
	String statuscd = DocNewsComInfo.getDocNewsstatus();
	String publishtypecd = DocNewsComInfo.getPublishtype();
	//if(!publishtypecd.equals("0")) continue;
	//if(!statuscd.equals("1")) continue;
	if(publishtypecd.equals("0") && statuscd.equals("1")){
		id= Integer.parseInt(DocNewsComInfo.getDocNewsid()); 
	}
}
}

//获取参数及设置基本变量
int start= Util.getIntValue(request.getParameter("start"),1);
int hstart = Util.getIntValue(request.getParameter("hstart"),1);
int recordersize = 0;
int perpage=0;
int needtr = 1;
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
//int importdocid = 0 ;
String importdocid = "";
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
int publishtype=-1;
//获取新闻页基本信息
if(id != 0) {
    DocNewsManager.resetParameter();
    DocNewsManager.setId(id);
    DocNewsManager.getDocNewsInfoById();

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
    //importdocid = Util.getIntValue(DocNewsManager.getImportdocid());
	importdocid = DocNewsManager.getImportdocid();
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
	publishtype=DocNewsManager.getPublishtype();

    DocNewsManager.closeStatement();
    perpage = newsperpage;
}


if(publishtype!=0){
	//out.println("对不起,您无权访问此新闻页!");
	response.sendRedirect("/notice/noright.jsp");
	return;
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
    PicUploadManager.closeStatement();
}

int defwidth = Util.getIntValue(SysDefaultsComInfo.getFgpicwidth(),0);
String deffix = Util.null2String(SysDefaultsComInfo.getFgpicfixtype());

int showimgwidth = defwidth;

//搜索条件处理
String searchvalue1 = Util.fromScreen(request.getParameter("searchvalue"),languageid);
String searchvalue2 = Util.fromScreen2(request.getParameter("searchvalue"),languageid);
if(!searchvalue2.equals("")){
    newsclause += " and ( docsubject like '%"+searchvalue2+"%' or doccontent like '%"+searchvalue2+"%' ) " ;
}
if(languageid==0)languageid=7;
%>
<BODY bgcolor=#e7e7e7>
<FORM id=form1 name=form1  method="post"  action="/pweb/WebDsp.jsp?id=<%=id%>">
<BR>

<!--页眉内容:begin-->
  <TABLE class=form valign=top>
    <TBODY>
    <tr>
		<%
		if(headerdocid!=0){
			DocManager.resetParameter();
			DocManager.setId(headerdocid);
			DocManager.getDocInfoById();
			String headerdoccontent=DocManager.getDoccontent();
			int tmppos = headerdoccontent.indexOf("!@#$%^&*");
							if(tmppos!=-1)
								headerdoccontent = headerdoccontent.substring(0,tmppos);
			DocManager.closeStatement();
		%>
			  <!--如果设置了页眉，则显示页眉内容-->
			  <td valign=top> <%=headerdoccontent%> </td>
			  <%}
		else if(hasdocsubject.equals("1")){
		%>
			  <!--如果没有设置页眉，则显示新闻页标题-->
			  <td  align=center valign=top>
				<H2> <%=frontpagename%> </h2>
			  </td>
			  <td width=20%>&nbsp</td>
		<%}%>
    </tr>
	</tbody>
  </table>
<!--页眉内容:end-->

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
				<td width="80%" valign=top>
				  <table class=ViewForm valign=top>					
					  <%		                        
						if(!"".equals(importdocid)){							
                            String[] tempdocids = Util.TokenizerString2(importdocid.trim(),",");    
                            String Docsid = "";
                            for(int i=0;i<tempdocids.length;i++){   
                                if (importdocid.equals("0")) break ;
                                Docsid = (String)tempdocids[i];
                                DocManager.resetParameter();
                                DocManager.setId(Util.getIntValue(tempdocids[i]));
                                DocManager.getDocInfoById();
                                String importdocsubject=DocManager.getDocsubject();
                                String importdoccontent=DocManager.getDoccontent();
                                String importdoccreatedate=DocManager.getDoccreatedate();
                                DocManager.closeStatement();                                   
                                if (needtr%2==1){%>
                                  <tr>                                  
                                <% 
                                    }
                                    
                                %>
                                  <td width=50%  valign=top>
                                        <table valign=top width=97%>
                                          <tr>
                                            <td colspan=2  valign=top> <li><a href="/pweb/WebDetailDsp.jsp?id=<%=Docsid%>&newsid=<%=id %>"><%=importdocsubject%></a>
                                            </td>
                                          </tr>
                                          <tr class=Spacing>
                                            <td class=Line1 colspan=2></td>
                                          </tr>
                                          <tr>
                                            <%
                                                int curpos = importdoccontent.indexOf("/weaver/weaver.file.FileDownload?fileid=");
                                                if(curpos!=-1){
                                                    curpos =  importdoccontent.indexOf("?fileid=",curpos);
                                                    int endpos = importdoccontent.indexOf("\"",curpos);
                                                    String tmppicid = importdoccontent.substring(curpos+8,endpos);
                                                    
                                                    showimgwidth = defwidth;
                                                    int tmpwidth = DocImageManager.getImageWidth(Util.getIntValue(tempdocids[i]),Util.getIntValue(tmppicid));
                                                    if(tmpwidth>0&&deffix.equals("1")) {
                                                    	showimgwidth = -1;
                                                    } else if(tmpwidth>0&&deffix.equals("2")) {
                                                        showimgwidth = defwidth;
                                                    } else if(tmpwidth>0&&deffix.equals("3")) {
                                                        if(tmpwidth>showimgwidth)
                                                            showimgwidth=tmpwidth;
                                                    } else if(tmpwidth>0&&deffix.equals("4")) {
                                                        if(tmpwidth<showimgwidth)
                                                            showimgwidth=tmpwidth;
                                                    }
                                            %>
                                              <td width=40%> <a href="/pweb/WebDetailDsp.jsp?id=<%=Docsid%>&newsid=<%=id %>">
								  <img border=0 <%if(showimgwidth>-1){%>width="<%=showimgwidth%>"<%}%> src=			 "/weaver/weaver.file.FileDownload?fileid=<%=tmppicid%>">
								  </a></td>
                                                <%
                                                }
                                            else if(defaultimgid!=0){
                                            	showimgwidth = defwidth;
                                                if(defaultimgwidth>0&&deffix.equals("1")) {
                                                	showimgwidth = -1;
                                                } else if(defaultimgwidth>0&&deffix.equals("2")) {
                                                    showimgwidth = defwidth;
                                                } else if(defaultimgwidth>0&&deffix.equals("3")) {
	                                                if(showimgwidth<defaultimgwidth)
	                                                    showimgwidth=defaultimgwidth;
	                                            } else if(defaultimgwidth>0&&deffix.equals("4")) {
	                                                if(showimgwidth>defaultimgwidth)
	                                                    showimgwidth=defaultimgwidth;
	                                            }	
                                            %>
                                            <td width=40% valign=top> <a href="/pweb/WebDetailDsp.jsp?id=<%=Docsid%>&newsid=<%=id %>">
								  <img border=0 <%if(showimgwidth>-1){%>width="<%=showimgwidth%>"<%}%> src="/weaver/weaver.file.FileDownload?fileid=<%=defaultimgid%>">
								  </a></td>
                                            <%}
                                            else{%>
                                            <td width=3% valign=top></td>
                                            <%}%>
                                            <%

                                                String disptmp = "";
                                                int tmppos = importdoccontent.indexOf("!@#$%^&*");
                                                if(tmppos!=-1)
                                                    disptmp = importdoccontent.substring(0,tmppos);

                                            %>
                                            <td valign=top><%=importdoccreatedate%>&nbsp; <%=disptmp%><a href="/pweb/WebDetailDsp.jsp?id=<%=Docsid%>&newsid=<%=id %>">&nbsp<%=SystemEnv.getHtmlLabelName(361,languageid)%></a>
                                            </td>
                                        </table>
                                  </td>
<%                              if (needtr%2==0){
%>
                                  </tr>                                  
<%                              }   
                                needtr++;
%>
<%                           }
%>
<%                        }                               
                  
						int currec = 0;
						//DocManager.resetParameter();
						String newslistclause=newsclause.trim();
						if(!newslistclause.equals(""))  newslistclause = " and " + newslistclause ;
						newslistclause = newslistclause + " and docpublishtype='2' and docstatus in('1','2','5') ";


						session.putValue("newslistclause",newslistclause);


						DocManager.setSql_where(newslistclause);
						DocManager.selectDocInfo();
						while(DocManager.next()){
							int docid = DocManager.getDocid();

                            String[] docidArrary = Util.TokenizerString2(importdocid,",");
                            if (isInThisArray(docidArrary,docid)) continue;                              

							recordersize += 1;
							currec +=1;
							if(currec < start) continue;
							if(currec >= start + perpage) continue;                              

							String docsubject=DocManager.getDocsubject();
							String doccontent=DocManager.getDoccontent();
							String doccreatedate=DocManager.getDoccreatedate();
                             if (needtr%2==1){
					%>
                            <tr>   
                    <%}%>
					  <td width=50% valign=top>
						<table valign=top width=97%>
						  <tr>
							<td colspan=2  valign=top> <li><a href="/pweb/WebDetailDsp.jsp?id=<%=docid%>&languageid=<%=languageid%>&newsid=<%=id %>"><%=docsubject%></a>
							</td>
						  </tr>
						  <tr class=Spacing>
							<td class=Line1 colspan=2></td>
						  </tr>
						  <tr>
							<%
								int curpos = doccontent.indexOf("/weaver/weaver.file.FileDownload?fileid=");
								if(curpos!=-1){
									curpos =  doccontent.indexOf("?fileid=",curpos);
									int endpos = doccontent.indexOf("\"",curpos);
									String tmppicid = doccontent.substring(curpos+8,endpos);
                                    
                                    showimgwidth = defwidth;
                                    int tmpwidth = DocImageManager.getImageWidth(docid,Util.getIntValue(tmppicid));
                                    if(tmpwidth>0&&deffix.equals("1")) {
                                    	showimgwidth = -1;
                                    } else if(tmpwidth>0&&deffix.equals("2")) {
                                        showimgwidth = defwidth;
                                    } else if(tmpwidth>0&&deffix.equals("3")) {
                                        if(tmpwidth>showimgwidth)
                                            showimgwidth=tmpwidth;
                                    } else if(tmpwidth>0&&deffix.equals("4")) {
                                        if(tmpwidth<showimgwidth)
                                            showimgwidth=tmpwidth;
                                    }
							%>
							<td width=40% valign=top> <a href="/pweb/WebDetailDsp.jsp?id=<%=docid%>&languageid=<%=languageid%>&newsid=<%=id %>">
								  <img border=0 <%if(showimgwidth>-1){%>width="<%=showimgwidth%>"<%}%> src="/weaver/weaver.file.FileDownload?fileid=<%=tmppicid%>">
								  </a></td>
								<%
								}
								else if(defaultimgid!=0){
                                	showimgwidth = defwidth;
                                    if(defaultimgwidth>0&&deffix.equals("1")) {
                                    	showimgwidth = -1;
                                    } else if(defaultimgwidth>0&&deffix.equals("2")) {
                                        showimgwidth = defwidth;
                                    } else if(defaultimgwidth>0&&deffix.equals("3")) {
                                        if(showimgwidth<defaultimgwidth)
                                            showimgwidth=defaultimgwidth;
                                    } else if(defaultimgwidth>0&&deffix.equals("4")) {
                                        if(showimgwidth>defaultimgwidth)
                                            showimgwidth=defaultimgwidth;
                                    }	
							%>
							<td width=40% valign=top> <a href="/pweb/WebDetailDsp.jsp?id=<%=docid%>&languageid=<%=languageid%>&newsid=<%=id %>">
								  <img border=0 <%if(showimgwidth>-1){%>width="<%=showimgwidth%>"<%}%> src="/weaver/weaver.file.FileDownload?fileid=<%=defaultimgid%>">
								  </a> </td>
							<%}
							else{%>
							<td width=3% valign=top></td>
							<%}%>
							<%

							String disptmp = "";
							int tmppos = doccontent.indexOf("!@#$%^&*");
							if(tmppos!=-1)
								disptmp = doccontent.substring(0,tmppos);
							%>
							<td  valign=top><%=doccreatedate%>&nbsp;<%=disptmp%>&nbsp;<a href="/pweb/WebDetailDsp.jsp?id=<%=docid%>&languageid=<%=languageid%>&newsid=<%=id %>"><%=SystemEnv.getHtmlLabelName(361,languageid)%></a>
								</td>
						</table>
					  </td>
					  <%
					if(needtr%2==0){%>
					    </tr>                      
<%                       
                    }
                        needtr++;     
					}
					DocManager.closeStatement();
					%>
					</tr>

				  </table>
				  </td>
				  <td width="20%" valign="top">
				  <!--搜索框:begin-->
				  <table class=form valign=top>
					<tr>
						<td width=70%><input type="text" name="searchvalue" class="submit" style="width:100%" value=<%=searchvalue1%>></td>
						<td>&nbsp <img alt="Search" src="/images_frame/search_dot_wev8.gif" border="0" onClick="form1.submit()" style="CURSOR:HAND"></td>
					</tr>
				  </table>
				  <!--搜索框:end-->
				<!--  //标题新闻显示开始 -->
				  <table class=form valign=top>
					<tr>
					<td valign="top" align="right">

				   
			   <%
			   int headernews = 0;
			   int totalnews=0;
			   %>
			   <%
				DocManager.resetParameter();
				String newslistclause1=newsclause.trim();
				if(!newslistclause1.equals(""))  newslistclause1 = " and " + newslistclause1 ;
				newslistclause1 = newslistclause1 + " and docpublishtype='3' and docstatus in('1','2','5') ";
				DocManager.setSql_where(newslistclause1);
				DocManager.selectDocInfo();
				while(DocManager.next()){
					int docid = DocManager.getDocid();
					String docsubject=DocManager.getDocsubject();
					if(docid == Util.getIntValue(importdocid)) continue;
					headernews += 1;
					totalnews +=1;
					if(headernews < hstart) continue;
					if(headernews >= hstart + titlesperpage) continue;

				 %>
				 <tr>
				 <td>
				 <li><a href="/pweb/WebDetailDsp.jsp?id=<%=docid%>&languageid=<%=languageid%>&newsid=<%=id %>"><%=docsubject%></a>
				 </td></tr>
				 <tr><td height=5></td></tr>

				<%}%>
				</table>
			   <!--  //标题新闻显示结束 -->
				
				</td>
			  </tr>

			  </tr>
			  <tr><td>&nbsp;</td><td></td></tr>
			  <tr>
					  <td align=center  noWrap >
						<%linkstr = "/pweb/WebDsp.jsp?id="+id+"&isrequest=Y&hstart="+hstart;%>
					<%=Util.makeNavbar(start, recordersize , perpage, linkstr)%>
			  </td>
			  <td align=center>
					<%
					if(hstart==1 && (hstart+titlesperpage)>= totalnews){
					%>
					<%}
					else if(hstart>=titlesperpage && (hstart + titlesperpage) < totalnews){
					%>
					<img border="0" src="/images/b0_wev8.gif" onClick="location='/pweb/WebDsp.jsp?id=<%=id%>&start=<%=start%>&hstart=<%=hstart-titlesperpage%>'" style="CURSOR:HAND"><img border="0" src="/images/g0_wev8.gif"  onclick="location='/pweb/WebDsp.jsp?id=<%=id%>&start=<%=start%>&hstart=<%=hstart+titlesperpage%>'" style="CURSOR:HAND">
					<%}
					else if(hstart>=titlesperpage && (hstart + titlesperpage) >= totalnews){
					%>
					<img border="0" src="/images/b0_wev8.gif" onClick="location='/pweb/WebDsp.jsp?id=<%=id%>&start=<%=start%>&hstart=<%=hstart-titlesperpage%>'" style="CURSOR:HAND"><img border="0" src="/images/g1_wev8.gif">
					<%}
					else if(hstart==1 && (hstart + titlesperpage) < totalnews){
					%>
					<img border="0" src="/images/b1_wev8.gif"><img border="0" src="/images/g0_wev8.gif"  onclick="location='/pweb/WebDsp.jsp?id=<%=id%>&start=<%=start%>&hstart=<%=hstart+titlesperpage%>'" style="CURSOR:HAND">
					<%}%>
			  </td>
			 


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
					int tmppos = footerdoccontent.indexOf("!@#$%^&*");
							if(tmppos!=-1)
								footerdoccontent = footerdoccontent.substring(0,tmppos);
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