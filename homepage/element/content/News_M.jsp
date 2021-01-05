
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="dci" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		String strsqlwhere 格式为 条件1^,^条件2...
		int perpage  显示页数
		String linkmode 查看方式  1:当前页 2:弹出页

		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList

		样式信息
		----------------------------------------
		String hpsb.getEsymbol() 列首图标
		String hpsb.getEsparatorimg()   行分隔线 
	*/

%>

<%
String  strNews="";
String  moreUrl="";

//图片大小
int imgWidth=120;
int imgHeight = 108;

if(!"".equals(strsqlwhere)){
	int tempPos=strsqlwhere.indexOf("^,^");
	if(tempPos!=-1){
	  strNews=strsqlwhere.substring(0,tempPos);
	  moreUrl=strsqlwhere.substring(tempPos+3,strsqlwhere.length());
	} else {
		return ;
	}
}
ArrayList tmpIdList = Util.TokenizerString(strNews,";");
ArrayList newsidList= new ArrayList();

for(int i=0;i<tmpIdList.size();i++){
	String tmpid=(String)tmpIdList.get(i);
	if(dci.getDocNewsIdIsExsit(tmpid)){
		newsidList.add(tmpid);
	}
}

if(newsidList==null || newsidList.size()==0) return;
%>
<TABLE  style="color:<%=hpsb.getEcolor()%>" id="_contenttable_<%=eid%>" class=Econtent  width=100%>
   <TR>
	 <TD width=1px></TD>
	 <TD width='*' valign="top">
		<table  width="100%">
		<%
		for(int i=0;i<newsidList.size();i++){
			String newsid=(String)newsidList.get(i);
			
			dnm.resetParameter();
			dnm.setId(Util.getIntValue(newsid));
			dnm.getDocNewsInfoById();
			String newsclause = dnm.getNewsclause();
			dnm.closeStatement();

			String newslistclause = newsclause.trim();
			if (!newslistclause.equals("")) {
				newslistclause = " and " + newslistclause;
			}
			newslistclause = newslistclause	+ " and docpublishtype='2' and docstatus in('1','2') ";
			dm.selectNewsDocInfo(newslistclause,user,perpage,1);

			ArrayList docIdList=new ArrayList();
			ArrayList docsubjectList=new ArrayList();
			ArrayList doclastmoddateList=new ArrayList();
			ArrayList doclastmodtimeList=new ArrayList();
			ArrayList docContentList=new ArrayList();
			
			while (dm.next()) {
				
				docIdList.add(""+dm.getDocid());
				docsubjectList.add(""+dm.getDocsubject()) ;
				doclastmoddateList.add(""+dm.getDoclastmoddate()) ;
				doclastmodtimeList.add(""+dm.getDoclastmodtime()) ;
				docContentList.add(dm.getDoccontent());
			}
			
			int index = fieldColumnList.indexOf("img");

			if(index!=-1){
				String imgfieldId = (String)fieldIdList.get(index);
				String sql = "";
				
				if(hpc.getIsLocked(hpid).equals("1")) {
					sql="select imgsize from hpFieldLength where eid="+ eid + " and efieldid=" + imgfieldId+"" +" and userid="+hpc.getCreatorid(hpid)+" and usertype="+hpc.getCreatortype(hpid);
				}else{
			    	sql="select imgsize from hpFieldLength where eid="+ eid + " and efieldid=" + imgfieldId+"" +" and userid="+hpu.getHpUserId(hpid,""+subCompanyId,user)+" and usertype="+hpu.getHpUserType(hpid,""+subCompanyId,user);
				}

			    rs.execute(sql);
			    if (rs.next()){
						String imgSize = Util.null2String(rs.getString("imgsize"));
						
						if(!"".equals(imgSize)){
							ArrayList imgSizeAry = Util.TokenizerString(imgSize,"*");
							imgWidth = Util.getIntValue((String)imgSizeAry.get(0),imgWidth);
							imgHeight = Util.getIntValue((String)imgSizeAry.get(1),imgHeight);
						}
			    }
			    
			}
		%>
			<tr>
				<td>
					<table width="100%"  cellspacing="0" cellpadding="0">
					<tr>

						<td valign="top">
							<table  cellspacing="0" cellpadding="0"><tr><TD valign="top">
							<%if(fieldColumnList.contains("img") && docIdList.size()>0) out.println(hpes.getImgPlay(request,docIdList,docContentList,imgWidth,imgHeight,styleid,eid));%>
							</TD></tr></table>
						</td>

						<td width="100%" valign="top">
							<TABLE  width="100%"  cellspacing="1" cellpadding="2">
								<%
									 for (int k=0;k<docIdList.size();k++) {
										int docid = Util.getIntValue((String)docIdList.get(k));

										String docsubject = (String)docsubjectList.get(k);
										String doccontent = (String)docContentList.get(k);
										String doclastmoddate =  (String)doclastmoddateList.get(k);
										String doclastmodtime =  (String)doclastmodtimeList.get(k);

								%>
									<TR height=18px>
										<%	
											String imgSymbol="";
											if (!"".equals(hpsb.getEsymbol())) imgSymbol="<img name='esymbol' src='"+hpsb.getEsymbol()+"'>";

											out.println("<TD width=\"8\">"+imgSymbol+"</TD>\n");
											int colcounts=fieldIdList.size();
											for (int j = 0; j <colcounts; j++) {
												String fieldId = (String) fieldIdList.get(j);
												String columnName = (String) fieldColumnList.get(j);
												String strIsDate = (String) fieldIsDate.get(j);
												String fieldwidth = (String) fieldWidthList.get(j);
												String isLimitLength = (String) isLimitLengthList.get(j);


												String cloumnValue = docsubject;
												String titleValue = cloumnValue;						

												 if ("docdocsubject".equals(columnName)) {
													int wordLength = 8;
													if ("1".equals(isLimitLength))	cloumnValue = hpu.getLimitStr(eid, fieldId,cloumnValue,user,hpid,subCompanyId);

													String showValue = "";
													if ("1".equals(linkmode)) {
														showValue = "<a href='/docs/docs/DocDsp.jsp?id="+ docid	+ "' target='_self'>"+ cloumnValue + "</a>\n";
													} else {
														showValue = "<a href=\"javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+ docid+ "')\">"+ cloumnValue+ "</a>\n";
													}

													out.println("<td width='" + fieldwidth+ "' title='" + titleValue + "'>"+ showValue + "</td>\n");
												} else if ("doclastmoddate".equals(columnName)) {
													out.println("<td  width='" + fieldwidth + "'>"+ doclastmoddate + "</td>\n");
												} else if ("doclastmodtime".equals(columnName)) {
													out.println("<td  width='" + fieldwidth + "'>"+ doclastmodtime + "</td>\n");
												}
											}

										%>					

									</TR>
									<%if(k+1<docIdList.size()){%>
									<TR style="background:url('<%=hpsb.getEsparatorimg()%>')" height=1px><td  colspan="<%=colcounts+1%>"></td></TR>
									<%}%>
									<%
									}	
									%>
							</TABLE>
						 </td>
					 </tr>
					 </table>		
				</td>
			</tr>
			<%if(i+1<newsidList.size()){%>
				<TR style="background:url('<%=hpsb.getEsparatorimg()%>')" height=1px><td></td></TR>
			<%}%>
		<%	
		}
		%>
		</table>
	</TD>    
	<TD width=1px></TD>
  </TR>
</TABLE>