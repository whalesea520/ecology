<%@ page import="weaver.join.news.*"%>
<%@ page import="java.text.*" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="oracle.sql.CLOB"%> 
<%@ page import="java.io.BufferedReader"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="rs_doc" class="weaver.conn.RecordSet" scope="page" />

<link href="/js/homepage/tabs/css/e8tabs_wev8.css" type="text/css" rel=stylesheet>

<%
	String tabId = Util.null2String(request.getParameter("tabId"));
	String updateSql =""; 
	if(loginuser != null){
		updateSql = "update  hpcurrenttab set currenttab =? where eid=? and userid=? and usertype=?";
		rs_doc.executeUpdate(updateSql,tabId,eid,loginuser.getUID(),loginuser.getType());
	}
	String showtitle = (String)valueList.get(nameList.indexOf("showtitle"));
	String showauthor = (String)valueList.get(nameList.indexOf("showauthor"));
	String showpubdate = (String)valueList.get(nameList.indexOf("showpubdate"));
	String showpubtime = (String)valueList.get(nameList.indexOf("showpubtime"));
	
	int showColCount = 0;
	if("7".equals(showtitle))
	{ 
		showColCount++;
	}
	if("8".equals(showauthor))
	{
		showColCount++;
	}
	if("9".equals(showpubdate))
	{
		showColCount++;
	}
	if("10".equals(showpubtime))
	{
		showColCount++;
	}
	String wordcount = (String)valueList.get(nameList.indexOf("wordcount"));
	String listType = (String)valueList.get(nameList.indexOf("listType"));
	String whereKey = "";
	int imagesize = Util.getIntValue((String)valueList.get(nameList.indexOf("imagesize")));
	String newstemplateid="";
	
	rs_doc.executeQuery("select sqlwhere,tabtitle from hpnewstabinfo where eid=? and tabid=?",eid,tabId);
    if(rs_doc.next()){ 
    	whereKey=rs_doc.getString("sqlWhere");
    }
    
	rs_Setting.executeQuery("select newstemplate from hpElement where id=?",eid);
	if(rs_Setting.next()){
		newstemplateid = rs_Setting.getString("newstemplate");	
	}
	String requesturl = request.getHeader("Host");
	String ecologyurl = pc.getConfig().getString("ecology.url");
	NewsUtil newsf = new NewsUtil(ecologyurl,requesturl);
	
	NewsPageBean newsp = newsf.getNewsPageBean(whereKey, "0", ""+perpage, "1", "1");
	ArrayList newsitems = newsp.getNewsItemList();
	
	
%>
<%
	String listShow ="";
	int rowcount=0;
	String imgSymbol="";
	if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
	
	%>
	<TABLE id=newscontent_<%=eid%> style="" width="100%">
	<TBODY>
		<TR>
			<TD vAlign=top width=*>
		
	<%

	if(listType.equals("2")){
		listShow += "<TABLE  width=\"100%\"";	
		listShow += " cellPadding='0' cellSpacing='0' style='table-layout:fixed' >\n";
	
	
	
		for(int i=0; i<newsitems.size();i++){
			NewsItemBean newsitem = (NewsItemBean)newsitems.get(i);
			String newsid = newsitem.getNewsid();
			String docid =newsid;
			if(newsid.indexOf("&")!=-1){
				docid = newsid.substring(0,newsid.indexOf("&"));
			}
			String newsContent = newsitem.getContent();
			String newstitle = newsitem.getTitle();
			String nnewstitle=Util.getMoreStr(newstitle,Util.getIntValue(wordcount,8),"...");
			String strmemo = Util.getMoreStr(newsitem.getDescription(),80,"...");
			String newsauthor = newsitem.getAuthor();
			String newspubdate = newsitem.getPubDate();
			String strSql_DocContent="";
			ConnStatement statement=new ConnStatement();
			try{
			if(("oracle").equals(rs_doc.getDBType())){
				
				strSql_DocContent="select doccontent from docdetail d1,docdetailcontent d2 where d1.id=d2.docid and d1.id="+docid;
				statement.setStatementSql(strSql_DocContent, false);
				statement.executeQuery();
				if(statement.next()) {
				  CLOB theclob = statement.getClob("doccontent");
				  String readline = "";
				  StringBuffer clobStrBuff = new StringBuffer("");
				  BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
				  while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
				  clobin.close() ;
				  newsContent = clobStrBuff.toString();
				}	
			} else{
				strSql_DocContent="select doccontent from docdetail where id="+docid;
				statement.setStatementSql(strSql_DocContent, false);
				statement.executeQuery();
				if(statement.next()) newsContent=statement.getString("doccontent");
			}
			}finally{
				statement.close();
			}
			
			newspubdate = newspubdate.trim();
			int indexpos = newspubdate.indexOf(" ");
			String pubdate = "";
			String pubtime = "";
			if(indexpos>0)
			{
				pubdate = newspubdate.substring(0,indexpos);
				pubtime = newspubdate.substring(indexpos,newspubdate.length());
			}
			String newslink = newsitem.getLink();
			String iconImg=esc.getIconEsymbol(hpec.getStyleid(eid));
			listShow += "<TR height=18px>\n";
			
			listShow += "	<TD width=\"8\">"+imgSymbol+"</TD>\n";
			
			String strImg="";
			
		
			strImg = hpes.getImgPlay(request,newsid,newsContent,imagesize,0,hpc.getStyleid(hpid),eid);
			
			if("1".equals(linkmode)){
				if("".equals(newstemplateid)){
					
					newstitle="<span class='ellipsis'>"+nnewstitle+"</span>";
					
				}else{
					
					newstitle ="<A class='ellipsis' href=\"/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid="+newstemplateid+"&docid="+newsid+"\"><font class=\"font\">"+nnewstitle+"</font></A>";
					
				}
			}else{
				
				if("".equals(newstemplateid)){
					
					newstitle="<span class='ellipsis'>"+nnewstitle+"</span>";
					
				}else{
					
					newstitle="<a class='ellipsis' href=\"javascript:openFullWindowForXtable('/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid="+newstemplateid+"&docid="+newsid+"')\"><font class=\"font\">"+nnewstitle+"</font></A>";
					
				}
			} 
			
					if("".equals(newstitle )) imgSymbol="";
			listShow += "<TD colspan=" + 4+ ">";
			 listShow += "<TABLE   width='100%'>";
			 listShow += "<TR>" ;
			listShow +=  "	<TD  rowspan=4 align=left valign=top>"+ strImg + "</TD>" ;
			  listShow += "	<TD  width='100%'  valign=top>";
				listShow += "		<table width='100%'   valign=top>";
			   listShow += "		<tr>";
			   int temp=0;
			if("7".equals(showtitle)){    
				temp++;
				listShow +="<td>"+imgSymbol+ "<font class=\"font\">"+newstitle+ "</font>"+"</td>";
			}
			if("8".equals(showauthor)){ 
				temp++;
				listShow+="<TD width=76><font class=\"font\">"+newsauthor+"</font></TD>";
			} 
			if("9".equals(showpubdate)){ 
				temp++;
				listShow+="<TD width=80><font class=\"font\">"+pubdate+"</font></TD>";
			} 
			if("10".equals(showpubtime)){ 
				temp++;
				listShow+="<TD width=80><font class=\"font\">"+pubtime+"</font></TD>";
			} 
			if(temp==0){
				listShow+="<td></td>";
			}
				
			  listShow +=  "		</tr>";
			
						   
		    if(!"".equals(pubdate)||!"".equals(pubtime))	
		    	//listShow += "<tr><td>"+ "<font class=font>"+pubdate+ "&nbsp;" + pubtime+"</font>"+"</td></tr>" ;
		    	listShow += "</table></TD></TR></TABLE></TD>";
			
		}
		out.print(listShow);
	}else if(listType.equals("3")){
		ArrayList docIdList=new ArrayList();
		ArrayList docContentList=new ArrayList();
		for(int i=0; i<newsitems.size();i++){
			NewsItemBean newsitem = (NewsItemBean)newsitems.get(i);
			String newsid = newsitem.getNewsid();
			String docid =newsid;
			if(newsid.indexOf("&")!=-1){
				docid = newsid.substring(0,newsid.indexOf("&"));
			}
			String newsContent = newsitem.getContent();
			docIdList.add(docid);
			String strSql_DocContent="";
			ConnStatement statement=new ConnStatement();
			try{
				if(("oracle").equals(rs_doc.getDBType())){

					strSql_DocContent="select doccontent from docdetail d1,docdetailcontent d2 where d1.id=d2.docid and d1.id='"+docid+"'";
					statement.setStatementSql(strSql_DocContent, false);
					statement.executeQuery();
					if(statement.next()) {
						CLOB theclob = statement.getClob("doccontent");
						String readline = "";
						StringBuffer clobStrBuff = new StringBuffer("");
						BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
						while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
						clobin.close() ;
						newsContent = clobStrBuff.toString();
					}
				} else{
					strSql_DocContent="select doccontent from docdetail where id='"+docid+"'";
					statement.setStatementSql(strSql_DocContent, false);
					statement.executeQuery();
					if(statement.next()) newsContent=statement.getString("doccontent");
				}
				docContentList.add(newsContent);
			}finally{
				statement.close();
			}
		}
		int imgWidth=imagesize;
		int imgHeight =0;
		String strImg = hpes.getImgPlay(request,docIdList,docContentList,imgWidth,imgHeight,hpec.getStyleid(eid),eid);

		listShow += "<TABLE  width=\"100%\" cellPadding='0' cellSpacing='0' style='table-layout:fixed' >\n";
		listShow += "<tr><td valign='top' width='"+imgWidth+"px'>"
				+"<table style='margin-top:6px' cellPadding='0' cellSpacing='0'>" +
				"<tr><TD  height='112' valign='top'>"+strImg+"</TD></tr>" +
				"</table></td>";
		listShow += "<td width=5px>&nbsp;</td>" +
				"<td width=\"100%\" valign=\"top\">";
		listShow += "<TABLE class='elementdatatable'  width=\"100%\">";
		for(int i=0; i<newsitems.size();i++){
			NewsItemBean newsitem = (NewsItemBean)newsitems.get(i);
			String newsid = newsitem.getNewsid();
			String docid =newsid;
			if(newsid.indexOf("&")!=-1){
				docid = newsid.substring(0,newsid.indexOf("&"));
			}
			String newsContent = newsitem.getContent();
			String newstitle = newsitem.getTitle();
			String nnewstitle=Util.getMoreStr(newstitle,Util.getIntValue(wordcount,8),"...");
			String strmemo = Util.getMoreStr(newsitem.getDescription(),80,"...");
			String newsauthor = newsitem.getAuthor();
			String newspubdate = newsitem.getPubDate();
			newspubdate = newspubdate.trim();
			int indexpos = newspubdate.indexOf(" ");
			String pubdate = "";
			String pubtime = "";
			if(indexpos>0)
			{
				pubdate = newspubdate.substring(0,indexpos);
				pubtime = newspubdate.substring(indexpos,newspubdate.length());
			}
			String newslink = newsitem.getLink();
			String iconImg=esc.getIconEsymbol(hpec.getStyleid(eid));

			if("1".equals(linkmode)){
				if("".equals(newstemplateid)){

					newstitle="<span class='ellipsis'>"+nnewstitle+"</span>";

				}else{

					newstitle ="<A class='ellipsis' href=\"/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid="+newstemplateid+"&docid="+newsid+"\"><font class=\"font\">"+nnewstitle+"</font></A>";

				}
			}else{

				if("".equals(newstemplateid)){

					newstitle="<span class='ellipsis'>"+nnewstitle+"</span>";

				}else{

					newstitle="<a class='ellipsis' href=\"javascript:openFullWindowForXtable('/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid="+newstemplateid+"&docid="+newsid+"')\"><font class=\"font\">"+nnewstitle+"</font></A>";

				}
			}

			if("".equals(newstitle )) imgSymbol="";
			//listShow += "		<table width='100%'   valign=top>";
			listShow += "		<tr>";
			int temp=0;
			if("7".equals(showtitle)){
				temp++;
				listShow +="<td>"+imgSymbol+ "<font class=\"font\">"+newstitle+ "</font>"+"</td>";
			}
			if("8".equals(showauthor)){
				temp++;
				listShow+="<TD width=76><font class=\"font\">"+newsauthor+"</font></TD>";
			}
			if("9".equals(showpubdate)){
				temp++;
				listShow+="<TD width=80><font class=\"font\">"+pubdate+"</font></TD>";
			}
			if("10".equals(showpubtime)){
				temp++;
				listShow+="<TD width=80><font class=\"font\">"+pubtime+"</font></TD>";
			}
			if(temp==0){
				listShow+="<td></td>";
			}
			listShow +=  "		</tr>";
		}
		listShow += "</table></TD></TR>";
		listShow +="</TABLE></TD>";
		out.print(listShow);
	}else{
	
%>
		<TABLE width="100%" style='table-layout:fixed'>
				
					<TBODY>
						<%
							
							if(!"".equals(whereKey)&&(!"".equals(showtitle)||!"".equals(showauthor)||!"".equals(showpubdate)||!"".equals(showpubtime)))
							{
								
								for (int i = 0;i<newsitems.size();i++)
								{
									NewsItemBean newsitem = (NewsItemBean)newsitems.get(i);
									String newsid = newsitem.getNewsid();
									String newstitle = newsitem.getTitle();
									String nnewstitle=newstitle;//Util.getMoreStr(newstitle,Util.getIntValue(wordcount,8),"...");
									String newsauthor = newsitem.getAuthor();
									String newspubdate = newsitem.getPubDate();
									newspubdate = newspubdate.trim();
									int indexpos = newspubdate.indexOf(" ");
									String pubdate = "";
									String pubtime = "";
									if(indexpos>0)
									{
										pubdate = newspubdate.substring(0,indexpos);
										pubtime = newspubdate.substring(indexpos,newspubdate.length());
									}
									String newslink = newsitem.getLink();
									String iconImg="";
						%>
						<TR height=18>
						<%
						if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
						%>
							<TD width=8><%=imgSymbol %></TD>
							<%
							if("7".equals(showtitle))
							{ 
								if("1".equals(linkmode)){
									if("".equals(newstemplateid)){
										%>
										<TD title=<%=newstitle%> width=*><%="<font class=\"font ellipsis\">"+nnewstitle+"</font>" %></TD>
										<%
									}else{
										%>
										<TD title=<%=newstitle%> width=*><A class='ellipsis' href="/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid=<%=newstemplateid%>&docid=<%=newsid%>"><%="<font class=\"font\">"+nnewstitle+"</font>" %></A></TD>
										<%
									}
								}else{
									if("".equals(newstemplateid)){
										%>
										<TD title=<%=newstitle%> width=*><%="<font class=\"font ellipsis\">"+nnewstitle+"</font>" %></TD>
										<%
									}else{
										%>
										<TD title=<%=newstitle%> width=*><a class='ellipsis'  href="javascript:openFullWindowForXtable('/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid=<%=newstemplateid%>&docid=<%=newsid%>')"><%="<font class=\"font\">"+nnewstitle+"</font>" %></A></TD>
										<%
									}
								} 
							}
							%>
							<%
							if("8".equals(showauthor))
							{ 
							%>
							<TD width=76><%="<font class=\"font\">"+newsauthor+"</font>"%></TD>
							<%
							} 
							%>
							<%
							if("9".equals(showpubdate))
							{ 
							%>
							<TD width=80><%="<font class=\"font\">"+pubdate+"</font>"%></TD>
							<%
							} 
							%>
							<%
							if("10".equals(showpubtime))
							{ 
							%>
							<TD width=70><%="<font class=\"font\">"+pubtime+"</font>"%></TD>
							<%
							} 
							%>
						</TR>
						<TR  class="sparator" style='height:1px' height=1>
							<TD colSpan=<%=showColCount+1 %> style='padding:0px'></TD>
						</TR>
						<%
								}
							}
						%>
					</TBODY>
				</TABLE>
				<%} %>
			</TD>
		</TR>
	</TBODY>
</TABLE>

<script>
	function initDocPicSlide(eid) {
		var n = 0;
		var count = $('#banner_'+eid+' a').length;
		//$('#banner_'+eid+' a').css('z-index','100')
		$('#banner_'+eid).css('border','1px solid #707070')
		$('#banner_'+eid+' .slidebox_list a:not(:first-child)').hide();

		$('#banner_'+eid+' .navitem').eq(0).toggleClass('on1');

		$('#banner_'+eid+' .navitem').click(function() {
			var i = $(this).attr('_index') - 1;
			n = i;
			if (i >= count) return;
			$('#banner_'+eid+' a').filter(':visible').fadeOut(500).parent().children().eq(i).fadeIn(500);

			$('#banner_'+eid+' .navitem').eq(i).toggleClass('on1');
			$(this).siblings().removeClass('on1');
		});
	}
	function showAuto(eid) {
		if($('#banner_'+eid+' a').length == 1){
			return;
		}
		var n = $('#banner_'+eid+' .navitem.on1').attr('_index') - 1;
		if(!n){
			n = 0;
		}
		n = n >= ($('#banner_'+eid+' a').length - 1) ? 0 : ++n;
		$('#banner_'+eid+' .navitem').eq(n).trigger('click');
	}

	$(document).ready(function() {
		<%if(listType.equals("3")){
			String outEid = eid+"_";
		%>
			try {
				clearInterval(t_<%=outEid%>);
				t_<%=outEid%>=null;
			}
			catch (e) {
				t_<%=outEid%>=null;
			}
			initDocPicSlide('<%=outEid%>');
			t_<%=outEid%>=setInterval(function(){showAuto('<%=outEid%>')}, 2000);
			$("#banner_<%=outEid%>").hover(function() {
				clearInterval(t_<%=outEid%>)
			}, function() {
				t_<%=outEid%> = setInterval(function(){showAuto('<%=outEid%>')}, 2000);
			});
			<%}%>
	});
</script>