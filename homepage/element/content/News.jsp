
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="dc" class="weaver.docs.docs.DocComInfo" scope="page"/>
<%@ page import="weaver.systeminfo.SystemEnv"%>
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
String returnStr = "";


//图片大小
int imgWidth=120;
int imgHeight = 108;

// 得到新闻页ID以及相关的展现方式
if(strsqlwhere.length()<3) return;
if("^,^".equals(strsqlwhere.substring(0,3)))  return ;
try {
	strsqlwhere = Util.StringReplace(strsqlwhere, "^,^","&");
} catch (Exception e) {					
	e.printStackTrace();
}
String srcOpenFirstAccess="0" ;
String[] strsqlwheres = Util.TokenizerString2(strsqlwhere, "&");
String newsId = Util.null2String(strsqlwheres[0]);
int showModeId = Util.getIntValue(strsqlwheres[1]);
if (strsqlwheres.length>3) srcOpenFirstAccess=strsqlwheres[3];
//System.out.println("strsqlwhere:"+strsqlwhere);
//System.out.println("newsId:"+newsId);
String srcType="0";
String srcContent="0";
String srcReply="0";

ArrayList docSrcList=Util.TokenizerString(""+newsId, "|");
if (docSrcList.size()>0) srcType=(String)docSrcList.get(0);
if (docSrcList.size()>1) srcContent=(String)docSrcList.get(1);
if (docSrcList.size()>2) srcReply=(String)docSrcList.get(2);


if("0".equals(srcContent)) return ;
String strAccess="";
if("1".equals(srcOpenFirstAccess)) strAccess="&isOpenFirstAss=1";	
		
String rollDirection="";
if(strsqlwheres.length<=2)  rollDirection="None";
else  rollDirection=strsqlwheres[2];

if("Left".equals(rollDirection)||"Right".equals(rollDirection)||"Up".equals(rollDirection)||"Down".equals(rollDirection)) out.println("<MARQUEE DIRECTION="+rollDirection+"  id=\"webjx_"+eid+"\" onmouseover=\"webjx_"+eid+".stop()\" onmouseout=\"webjx_"+eid+".start()\"  SCROLLDELAY=200>");
%>

<div class='tab2'>
	<table height='32'  cellspacing='0' cellpadding='0' border='0'>
		<tr>
			<td class='tab2selected' onclick=""><%=SystemEnv.getHtmlLabelName(19744,user.getLanguage())%></td>
			<td class='tab2unselected' onclick=""><%=SystemEnv.getHtmlLabelName(83669,user.getLanguage())%></td>
			<td class='tab2unselected' onclick=""><%=SystemEnv.getHtmlLabelName(83670,user.getLanguage())%></td>
		</tr>
	</table>
</div>

<TABLE  style="color:<%=hpsb.getEcolor()%>" id="_contenttable_<%=eid%>" class=Econtent  width=100%>
   <TR>
	 <TD width=1px></TD>
	 <TD width='*' valign="top">

<%
String  userid1=""+user.getUID();
String ownerid=userid1;

String andSql="";
String invalidStr = " or docstatus = 7 and  (sharelevel>1" + ((userid1!=null&&!"".equals(userid1))?" or (doccreaterid=" + userid1 + ((ownerid!=null&&!"".equals(ownerid))?" or ownerid=" + ownerid:"") + ")":"") + ") ";
String strStatus=" and (docstatus='1' or docstatus='2' or docstatus='5' "+invalidStr+")";
if("1".equals(srcType)){
	String newsclause = "";

	dnm.resetParameter();
	dnm.setId(Util.getIntValue(srcContent));
	dnm.getDocNewsInfoById();
	newsclause = dnm.getNewsclause();
	dnm.closeStatement();

	String newslistclause = newsclause.trim();
	if (!newslistclause.equals("")) 	newslistclause = " and (" + newslistclause+") ";
	andSql = newslistclause	+ "  and (ishistory is null or ishistory = 0)  and docpublishtype='2' "+strStatus;
	dm.selectNewsDocInfo(andSql, user,perpage, 1);
} else if("2".equals(srcType)){  //分目录
	if(",".equals(srcContent.substring(0,1))) srcContent=srcContent.substring(1);
	andSql="  and (ishistory is null or ishistory = 0)  and seccategory in("+srcContent+") "+strStatus;
    if (!"1".equals(srcReply))	andSql+=" and (isreply!=1 or  isreply is null) ";
	dm.selectNewsDocInfo(andSql, user,perpage, 1);
		
} else if("3".equals(srcType)){  //虚拟目录	
	andSql=" and (ishistory is null or ishistory = 0)  "+strStatus;
	if (!"1".equals(srcReply))	andSql+=" and (isreply!=1 or  isreply is null)";
	dm.selectNewsDocInfo(andSql, user,perpage, 1,srcContent);

} else if("4".equals(srcType)){ //指定文档
	ArrayList docids=Util.TokenizerString(srcContent,",");
	String newDocids="";
    for(int i=0;i<docids.size();i++)	newDocids+=","+dm.getNewDocid((String)docids.get(i));
	if(newDocids.length()>0) newDocids=newDocids.substring(1);
	
	andSql=" and id in("+newDocids+") "+strStatus;
	dm.selectNewsDocInfo(andSql, user,perpage, 1);

}else if("5".equals(srcType)){ //搜索模板

}else if("6".equals(srcType)){ //搜索条件
//预留
}



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

if(showModeId == 4){
	String strImg="";
	if (fieldColumnList.contains("img")) {
		strImg = hpes.getImgPlay(request,docIdList,docContentList,imgWidth,imgHeight,hpc.getStyleid(hpid),eid);
	}
	returnStr +="<table width=\"100%\"  cellPadding='0' cellSpacing='0'><tr><td valign=\"top\"><table cellPadding='0' cellSpacing='0'><tr><TD  height=\"112\" valign=\"top\">"+strImg+"</TD></tr></table></td>\n";
	returnStr +="<td width=1px>&nbsp;</td><td width=\"100%\" valign=\"top\">" ;
}
returnStr += "<TABLE  width=\"100%\"";
//System.out.println("showModeId:"+showModeId);
if (showModeId == 3 || showModeId == 2 || showModeId == 24){ //左图式 or 上图式 or 多图式
	returnStr += " cellPadding='0' cellSpacing='0' >\n";
} else {
	returnStr += " >\n";
}
int rowcount=0;
String imgSymbol="";

if (!"".equals(esc.getIconEsymbol(eStyleid))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(eStyleid)+"'>&nbsp;";



for (int i=0;i<docIdList.size();i++) {
	int docid = Util.getIntValue((String)docIdList.get(i));
	String docId=(String)docIdList.get(i);
	String docsubject = (String)docsubjectList.get(i);
	String doccontent = (String)docContentList.get(i);
	String doclastmoddate =  (String)doclastmoddateList.get(i);
	String doclastmodtime =  (String)doclastmodtimeList.get(i);

	returnStr += "<TR height=18px>\n";
	if(showModeId == 1||showModeId == 4){
		returnStr += "	<TD width=\"8\">"+imgSymbol+"</TD>\n";
	}

	int size = fieldIdList.size();
	for (int j = 0; j < size; j++) {
		String fieldId = (String) fieldIdList.get(j);
		String columnName = (String) fieldColumnList.get(j);
		String strIsDate = (String) fieldIsDate.get(j);
		String fieldwidth = (String) fieldWidthList.get(j);
		String isLimitLength = (String) isLimitLengthList.get(j);

		String cloumnValue = docsubject;
		String titleValue = cloumnValue;
		
		if (showModeId == 1 || showModeId == 4) {// 列表式
			 if ("docdocsubject".equals(columnName)) {
				int wordLength = 8;
				if ("1".equals(isLimitLength))
					cloumnValue = hpu.getLimitStr(eid, fieldId,cloumnValue,user,hpid,subCompanyId);

					String imgNew="<IMG src='/images/BDNew_wev8.gif' border=0 align='absbottom'>";
				    if(!dc.getIsNewDoc(docId, user.getLogintype(), ""+user.getUID())) imgNew="";


				String showValue = "";
				
				if ("1".equals(linkmode)) {
					showValue = "<a href='/docs/docs/DocDsp.jsp?id="
							+ docid+strAccess
							+ "' target='_self'>"
							+ cloumnValue + "</a>\n";
				} else {
					showValue = "<a href=\"javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="
							+ docid+strAccess
							+ "')\">"
							+ cloumnValue
							+ "</a>\n";
				}

				returnStr += "<td width='" + fieldwidth
						+ "' title='" + titleValue + "'>"
						+ showValue +imgNew+ "</td>\n";
			} else if ("doclastmoddate".equals(columnName)) {
				returnStr += "<td  width='" + fieldwidth + "'>"
						+ doclastmoddate + "</td>\n";
			} else if ("doclastmodtime".equals(columnName)) {
				returnStr += "<td  width='" + fieldwidth + "'>"
						+ doclastmodtime + "</td>\n";
			}
		} else {

			String newTitle = hpu.getLimitStr(eid, fieldId,
					cloumnValue,user,hpid,subCompanyId);
			String strmemo = "";
			int tmppos = doccontent.indexOf("!@#$%^&*");
			if (tmppos != -1) strmemo = doccontent.substring(0, tmppos);
			
			if (!fieldColumnList.contains("docdocsubject")){
				newTitle = "";
			} else {
				int tempPos=fieldColumnList.indexOf("docdocsubject");
				String tempFiledId=(String)fieldIdList.get(tempPos);
				newTitle = hpu.getLimitStr(eid, tempFiledId,newTitle,user,hpid,subCompanyId);

				String imgNew="<IMG src='/images/BDNew_wev8.gif' border=0 align='absbottom'>";
				if(!dc.getIsNewDoc(docId, user.getLogintype(), ""+user.getUID())) imgNew="";
				
				if ("1".equals(linkmode)) {
					newTitle = "<a href='/docs/docs/DocDsp.jsp?id="+ docid+strAccess+ "' target='_self'>"+ newTitle +imgNew+ "</a>\n";
				} else {
					newTitle = "<a href=\"javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+ docid+strAccess+ "')\">"+ newTitle +imgNew+ "</a>\n";
				}
			}
			if (!fieldColumnList.contains("doclastmoddate"))
				doclastmoddate = "";
			if (!fieldColumnList.contains("doclastmodtime"))
				doclastmodtime = "";
			if (!fieldColumnList.contains("summary")){
				strmemo = "";
			} else {							
				int tempPos=fieldColumnList.indexOf("summary");
				String tempFiledId=(String)fieldIdList.get(tempPos);					
				
				strmemo = hpu.getLimitStr(eid, tempFiledId,strmemo,user,hpid,subCompanyId);
				if ("1".equals(linkmode)) {
					strmemo = "<a href='/docs/docs/DocDsp.jsp?id="+ docid	+ strAccess+"' target='_self'>"+ strmemo + "</a>\n";
				} else {
					strmemo = "<a href=\"javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+ docid+strAccess+ "')\">"+ strmemo+ "</a>\n";
				}
			}

			if(perpage!=1) size=size - 1;
			if (showModeId == 2) { // 上图式
				 //得到图片播放
				String strImg="";
				if (fieldColumnList.contains("img")) {
					strImg = hpes.getImgPlay(request,docId,doccontent,imgWidth,imgHeight,hpc.getStyleid(hpid),eid);
					
				}
				if("".equals(newTitle )) imgSymbol="";
				returnStr += "<TD colspan=" + size+ " valign=top align=center>"+
								"<TABLE valign=top align=center cellPadding='0' cellSpacing='0'>" +
								"	<TR><TD  valign=top align=center>" + strImg+ "</TD></TR>" +
								"	<TR><TD  align=center>"+imgSymbol+ newTitle+ "</TD></TR>" +
								"	<TR><TD valign=top  align=center>" + strmemo+"</TD></TR>";
				if(!"".equals(doclastmoddate)||!"".equals(doclastmodtime))							
					returnStr+= "<TR><TD valign=top  align=center>" + doclastmoddate + "&nbsp;"+ doclastmodtime+"</TD></TR>";
				returnStr+= "</TABLE></TD>";
				break;
			} else { // 左图式
				  //得到图片播放
				String strImg="";
			
				if (fieldColumnList.contains("img")) {
					strImg = hpes.getImgPlay(request,docId,doccontent,imgWidth,imgHeight,hpc.getStyleid(hpid),eid);
				}
				
				if("".equals(newTitle )) imgSymbol="";
				returnStr += "<TD colspan=" + size+ ">"+
							   "<TABLE   width='100%'>" + 
							   "<TR>" + 
							   "	<TD  rowspan=4 align=left valign=top>"+ strImg + "</TD>" +
							   "	<TD  width='100%'  valign=top>"+
								"		<table width='100%'   valign=top>"+
							   "		<tr>"+
								"			<td>"+imgSymbol+ newTitle+ "</td>"+
							   "		</tr>"+
							   "		<tr height=1px bgcolor=\""+hpsb.getEbordercolor()+"\">"+
								"			<td></td>"+
							   "		</tr>"+
							   "		<tr>"+
								"			<td>"+ strmemo+"</td>"+
							   "		</tr>";
							   
			    if(!"".equals(doclastmoddate)||!"".equals(doclastmodtime))	
					returnStr += "<tr><td>"+ doclastmoddate+ "&nbsp;" + doclastmodtime+"</td></tr>" ;
				returnStr += "</table></TD></TR></TABLE></TD>";
				break;
			}

		}
	}

	returnStr += "</TR>\n";
	rowcount++;
	if(perpage!=1&&rowcount<perpage)
		returnStr += "<TR  class='sparator' height=1px><td  colspan=" + (size + 1)
			+ "></td></TR>\n";				
}
returnStr += "</TABLE>\n";
if(showModeId == 4) {
		  returnStr +="     </td></tr></table>\n";
}
out.println(returnStr);
%>
	</table>
	</TD>    
	<TD width=1px></TD>
  </TR>
</TABLE>
<%
	if("Left".equals(rollDirection)||"Right".equals(rollDirection)||"Up".equals(rollDirection)||"Down".equals(rollDirection)) out.println("</MARQUEE>");
%>