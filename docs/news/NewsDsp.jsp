<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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

	String navName = "";
%>

<HEAD>

	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>红纺文化</title>
	<link rel="stylesheet" href="/mobile/plugin/shxiv/hfwh/css/qietu.css">
	<link rel="stylesheet" href="/mobile/plugin/shxiv/hfwh/css/swiper.min.css">
	<link rel="stylesheet" href="/mobile/plugin/shxiv/hfwh/css/style.css">

	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js">
	</script>
	<script type='text/javascript' src='/dwr/interface/DocDwrUtil.js'></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>
	<script type="text/javascript">
        var dialog = null;
        let userId="<%=user.getUID()%>";
        try{
            dialog = parent.parent.getDialog(parent);
        }catch(e){}

        function openSc() {
            window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainSc.jsp";
        }

        function openTk() {
            window.location.href="/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp";
        }

        function openMm() {
            window.location.href="/CRM/data/ManagerUpdatePassword.jsp?type=customer&crmid="+userId;
        }

	</script>
</head>


<%
	int id = Util.getIntValue(request.getParameter("id"),0);

	rs.executeSql("select publishtype from DocFrontpage where id = "+id);
	if(rs.next()){
		String publishType = rs.getString(1);
		if(publishType.equals("0")){
			response.sendRedirect("/pweb/index.jsp?id="+id);
			return;
		}
	}

	String checkOutMessage=Util.null2String(request.getParameter("checkOutMessage"));  //已被检出提示信息

	if(!checkOutMessage.equals("")){
%>
<SCRIPT LANGUAGE="JavaScript">
    top.Dialog.alert("<%=checkOutMessage%>");
</SCRIPT>
<%
	}

//如果该新闻页为外部新闻页时，跳转到外部新闻页显示页面
	if(DocNewsComInfo.getPublishtype(id+"").equals("0")){
		checkOutMessage=URLEncoder.encode(checkOutMessage);
		response.sendRedirect("/pweb/index.jsp?id="+id+"&checkOutMessage="+checkOutMessage);
		return;
	}
	int start= Util.getIntValue(request.getParameter("start"),1);
	int hstart = Util.getIntValue(request.getParameter("hstart"),1);
	int recordersize = 0;
	int perpage=0;
	int needtr = 1;
	String linkstr="";
	String usertype = "" ;
	boolean noNewsCategory= false;
	if(user.getLogintype().equals("1")) usertype = "1" ;
	else  usertype = ""+(-1*user.getType()) ;

	if(id == 0) {
		int i = 0 ;
		while(DocNewsComInfo.next(usertype) && i==0 ) {
			id = Util.getIntValue(DocNewsComInfo.getDocNewsid(),0) ;
			if(id!=0) i++ ;
		}
		if (i==0) noNewsCategory = true;
	}

	if (noNewsCategory) {
		navName = SystemEnv.getHtmlLabelName(16241,user.getLanguage());
%>
<TABLE class=ViewForm valign=top>
	<TBODY>
	<tr>
		<td clospan=2> <%=SystemEnv.getHtmlLabelName(16241,user.getLanguage())%> </td>
	</tr>
	</tbody>
</table>
<%} else {
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
	String importdocid = "" ;
	int headerdocid = 0 ;
	int footerdocid = 0 ;
	String secopt = "" ;
	int seclevelopt = 0;
	int departmentopt = 0;
	int dateopt = 0;
	int languageopt = 0 ;
	String clauseopt = "" ;
	String newsclause = "" ;
	int defaultimgid= 0 ;
	int defaultimgwidth=0;

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
		importdocid = DocNewsManager.getImportdocid();
		headerdocid = DocNewsManager.getHeaderdocid();
		footerdocid = DocNewsManager.getFooterdocid();
		secopt = DocNewsManager.getSecopt();
		seclevelopt = DocNewsManager.getSeclevelopt();
		departmentopt = DocNewsManager.getDepartmentopt();
		dateopt = DocNewsManager.getDateopt();
		languageopt = DocNewsManager.getLanguageopt();
		clauseopt = Util.toScreenToEdit(DocNewsManager.getClauseopt(),user.getLanguage());
		newsclause = DocNewsManager.getNewsclause();

		DocNewsManager.closeStatement();
		perpage = newsperpage;
	}

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
%>
<BODY>

<div class="header">
	<div class="header-logo">
		<a href="#"><img src="/mobile/plugin/shxiv/hfwh/imgs/logo.png"/></a>
	</div>
	<div class="header-nav">
		<ul>
			<li class="header-nav-item"><a href="/docs/news/NewsDsp.jsp"  style="font-size: 20px;">首页</a></li>
			<li class="header-nav-item"><a  href="javascript:void(0)" onclick="openTk()" style="font-size: 20px;">图库</a></li>
			<li class="header-nav-item"><a href="javascript:void(0)" onclick="openSc()" style="font-size: 20px;">图库收藏</a></li>
		</ul>
		<div class="icon-mima" onclick="openMm()"></div>
		<div class="icon-quit" onclick="window.location='/login/Logout.jsp'"></div>
	</div>
</div>


<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;

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


								<%
									String imagefilename = "";
									String titlename ="";
									String needfav ="1";
									String needhelp ="";
								%>
								<FORM id=weaver name=weaver>
									<BR>
									<TABLE class=ViewForm valign=top>
										<TBODY>
										<tr>
											<%
												if(headerdocid!=0){
													DocManager.resetParameter();
													DocManager.setId(headerdocid);
													DocManager.getDocInfoById();
													String headerdoccontent=DocManager.getDoccontent();
													int tmppos = headerdoccontent.indexOf("!@#$%^&*");
													if(tmppos!=-1){
														headerdoccontent = headerdoccontent.substring(tmppos+8,headerdoccontent.length());
													}
													DocManager.closeStatement();

											%>
											<td valign=top> <%=headerdoccontent%> </td>
											<%navName = headerdoccontent;}
											else if(hasdocsubject.equals("1")){
												navName = frontpagename;
											%>
											<td  align=center valign=top>
												<H2> <%=frontpagename%> </h2>
											</td>
											<%}%>
										</tr>
										</tbody>
									</table>
									<TABLE class=ViewForm valign=top>
										<TBODY>
										<tr>
										<tr>
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
												<table width="100%" border="0" cellspacing="0" cellpadding="0" valign=top>
													<tr>
														<td width="80%" valign=top>
															<table class=ViewForm valign=top>
																<%
																	if(!"".equals(importdocid)){
																		String[] tempdocids = Util.TokenizerString2(importdocid.trim(),",");
																		for(int i=0;i<tempdocids.length;i++){
																			if (importdocid.equals("0")) break ;
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
																				<td colspan=2  valign=top> <li><a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=tempdocids[i]%>"><%=importdocsubject%></a>&nbsp;&nbsp;[<%=SystemEnv.getHtmlLabelName(322,user.getLanguage())%>]
																				</td>
																			</tr>
																			<tr class=Spacing style="height: 1px!important;">
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
																				<td width=40%> <a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=tempdocids[i]%>">
																					<img border=0 <%if(showimgwidth>-1){%>width="<%=showimgwidth%>"<%}%> src="/weaver/weaver.file.FileDownload?fileid=<%=tmppicid%>">
																				</a> </td>
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
																				<td width=40% valign=top> <a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=tempdocids[i]%>">
																					<img border=0 <%if(showimgwidth>-1){%>width="<%=showimgwidth%>"<%}%> src="/weaver/weaver.file.FileDownload?fileid=<%=defaultimgid%>">
																				</a> </td>
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
																				<td valign=top><%=importdoccreatedate%>&nbsp; <%=disptmp%><a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=tempdocids[i]%>">&nbsp<%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
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
																	//DocManager.setSql_where(newslistclause);
																	DocManager.selectNewsDocIdInfo(newslistclause,user);
																	List tmpIds = new ArrayList();
																	while(DocManager.next()){
																		int docid = DocManager.getDocid();
																		tmpIds.add(new Integer(docid));
																	}

																	for(int i=0;i<tmpIds.size();i++){
																		int docid=((Integer)tmpIds.get(i)).intValue();
																		String[] docidArrary = Util.TokenizerString2(importdocid,",");
																		if (isInThisArray(docidArrary,docid)) continue;

																		recordersize += 1;
																		currec +=1;
																		if(currec < start) continue;
																		if(currec >= start + perpage) continue;

																		DocManager.resetParameter();
																		DocManager.setId(docid);
																		DocManager.getDocInfoById();

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
																				<td colspan=2  valign=top> <li><a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=docid%>"><%=docsubject%></a>
																				</td>
																			</tr>
																			<tr class=Spacing style="height: 1px!important;">
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
																				<td width=40% valign=top> <a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=docid%>">
																					<img border=0 <%if(showimgwidth>-1){%>width="<%=showimgwidth%>"<%}%> src="/weaver/weaver.file.FileDownload?fileid=<%=tmppicid%>">
																				</a> </td>
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
																				<td width=40% valign=top> <a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=docid%>">
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
																				<td  valign=top><%=doccreatedate%>&nbsp;<%=disptmp%>&nbsp<a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=docid%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
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
															<table class=ViewForm valign=top>
																<tr>
																	<td valign="top" align="right">
																		<%
																			if(hasfrontpagelist.equals("1")){
																		%>
																		<select class=InputStyle  name="id" onchange="location='/docs/news/NewsDsp.jsp?id='+this.value;">
																			<%
																				rs.executeSql("select a.id,a.frontpagename from  DocFrontpage a ,CRM_CustomerType b where a.isactive=1 and a.publishtype < 1 and( ABS(a.publishtype) = b.id or a.publishtype=0) and b.id ="+user.getType());
																				while(rs.next()){

																					String curselect = "";
																					String curid = Util.null2String(rs.getString("id"));
																					String curname =Util.null2String(rs.getString("frontpagename"));

																					if(Util.getIntValue(curid,0)==id) curselect=" selected";
																			%>
																			<option value="<%=curid%>" <%=curselect%>><%=curname%></option>
																			<%}%>
																		</select>
																	</td>
																</tr>
																<!--
			<tr><td>&nbsp;</td></tr>

			<tr><td align=center><b><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></b></td></tr>
	-->
																<tr><td>&nbsp;</td></tr>
																<%}%>
																<!--  //标题新闻显示开始 -->
																<%
																	int headernews = 0;
																	int totalnews=0;
																%>
																<%
																	DocManager.resetParameter();
																	String newslistclause1=newsclause.trim();
																	if(!newslistclause1.equals(""))  newslistclause1 = " and " + newslistclause1 ;
																	newslistclause1 = newslistclause1 + " and docpublishtype='3' and docstatus in('1','2','5') ";
																	//DocManager.setSql_where(newslistclause1);
																	DocManager.selectNewsDocIdInfo(newslistclause1,user);

																	List tmpIds2 = new ArrayList();
																	while(DocManager.next()){
																		int docid = DocManager.getDocid();
																		tmpIds2.add(new Integer(docid));
																	}

																	for(int i=0;i<tmpIds2.size();i++){
																		int docid=((Integer)tmpIds2.get(i)).intValue();


																		if(docid == Util.getIntValue(importdocid)) continue;
																		headernews += 1;
																		totalnews +=1;
																		if(headernews < hstart) continue;
																		if(headernews >= hstart + titlesperpage) continue;

																		DocManager.resetParameter();
																		DocManager.setId(docid);
																		DocManager.getDocInfoById();
																		String docsubject=DocManager.getDocsubject();
																%>
																<tr>
																	<td>
																		<li><a target="_blank" href="/docs/docs/DocDsp.jsp?id=<%=docid%>"><%=docsubject%></a>
																	</td></tr>
																<tr><td height=5></td></tr>

																<%}%>


																<!--  //标题新闻显示结束 -->
															</table>
														</td>
													</tr>

													</tr>
													<tr>
														<td align=center  noWrap >
															<%
																linkstr = "/docs/news/NewsDsp.jsp?id="+id+"&hstart="+hstart;
															%>
															<%=Util.makeNavbari18n(user.getLanguage(),start, recordersize , perpage, linkstr)%>

														</td>
														<td align=center>
															<%
																totalnews ++;
																if(hstart==1 && (hstart+titlesperpage)>= totalnews){
															%>

															<%}
															else if(hstart>=titlesperpage && (hstart + titlesperpage) < totalnews){
															%>
															<img border="0" src="/images/b0_wev8.gif" onclick="location='/docs/news/NewsDsp.jsp?id=<%=id%>&start=<%=start%>&hstart=<%=hstart-titlesperpage%>'" style="CURSOR:HAND"><img border="0" src="/images/g0_wev8.gif"  onclick="location='/docs/news/NewsDsp.jsp?id=<%=id%>&start=<%=start%>&hstart=<%=hstart+titlesperpage%>'" style="CURSOR:HAND">
															<%}
															else if(hstart>=titlesperpage && (hstart + titlesperpage) >= totalnews){
															%>
															<img border="0" src="/images/b0_wev8.gif" onclick="location='/docs/news/NewsDsp.jsp?id=<%=id%>&start=<%=start%>&hstart=<%=hstart-titlesperpage%>'" style="CURSOR:HAND"><img border="0" src="/images/g1_wev8.gif">
															<%}
															else if(hstart==1 && (hstart + titlesperpage) < totalnews){
															%>
															<img border="0" src="/images/b1_wev8.gif"><img border="0" src="/images/g0_wev8.gif"  onclick="location='/docs/news/NewsDsp.jsp?id=<%=id%>&start=<%=start%>&hstart=<%=hstart+titlesperpage%>'" style="CURSOR:HAND">
															<%}%>

														</td>
													</tr>


												</table>
											</td>
										</tbody>
									</table>
									<TABLE class=ViewForm valign=top>
										<TBODY>
										<%
											if(footerdocid!=0){
												DocManager.resetParameter();
												DocManager.setId(footerdocid);
												DocManager.getDocInfoById();
												String footerdoccontent=DocManager.getDoccontent();
												int tmppos = footerdoccontent.indexOf("!@#$%^&*");
												if(tmppos!=-1){
													footerdoccontent = footerdoccontent.substring(tmppos+8,footerdoccontent.length());
												}
												DocManager.closeStatement();
										%>
										<tr>
											<td clospan=2> <%=footerdoccontent%> </td>
										</tr>
										<%}%>
										</tbody>
									</table>
								</FORM>
								<%}%>

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
</div>
<%--
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
--%>
<script type="text/javascript">
    jQuery(document).ready(function(){
        resizeDialog(document);
    });
</script>

</body>

<script language="javascript" type="text/javascript">


    try{
        parent.setTabObjName("<%= navName %>");
    }catch(e){}
    function onCheckIn(id){
        DocDwrUtil.checkInNewsDsp(id,
            {callback:function(result){
                if(result){
                    window.location.reload();
                }
            }
            }
        )
    }

</script>