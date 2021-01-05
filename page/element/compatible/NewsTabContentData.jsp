
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="dc" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="sod" class="weaver.synergy.SynergyOperatDoc" scope="page"/>
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
		String esc.getIconEsymbol(pc.getStyleid(eid)) 列首图标
		class='sparator' 行分隔线 
	*/
%>

<%
String returnStr = "";

//更新当前tab信息
String tabid = Util.null2String(request.getParameter("tabId"));
String updateSql = "update  hpcurrenttab set currenttab ='"+tabid+"' where eid="
	+ eid
	+ " and userid="
	+ user.getUID()
	+ " and usertype="
	+ user.getType();
rs.execute(updateSql);

//图片大小
int imgWidth=120;
int imgHeight = 108;
String topDocIds="";//置顶文档ID
int topDocCount = 0;//置顶文档数目
String tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" and tabId="+tabid;
rs.execute(tabSql);
if(rs.next()){
	strsqlwhere = rs.getString("sqlWhere");
}

if(strsqlwhere.indexOf("^topdoc^")!=-1){
	strsqlwhere = Util.StringReplace(strsqlwhere, "^topdoc^","#");
	String[] temp = Util.TokenizerString2(strsqlwhere, "#");
	strsqlwhere = Util.null2String(temp[0]);
	if(temp.length>1){
		topDocIds = Util.null2String(temp[1]);
	}
}
boolean isNewReply = weaver.docs.docs.reply.DocReplyUtil.isUseNewReply();	//是否启用新的文档回复
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

String newstemplateid="";
String newstemplatetype="";
String imgType="";
String imgSrc="";

rs.execute("select newstemplate,imgtype,imgsrc from hpFieldLength where eid="+eid+" and usertype=3 order by id desc");
if(rs.next()){
	//newstemplateid = Util.null2String(rs.getString("newstemplate"));
	imgType = rs.getString("imgtype");
	imgSrc = rs.getString("imgsrc");
}
rs.execute("select newstemplate from hpElement where id="+eid);
if(rs.next()){
	newstemplateid = Util.null2String(rs.getString("newstemplate"));
}

if(!"".equals(newstemplateid)){
	rs.execute("select templatetype from pagenewstemplate where id="+newstemplateid);
	if(rs.next()){
		newstemplatetype = rs.getString("templatetype"); 
	}else{
		rs.execute("update hpElement set newstemplate = '' where id="+eid);
		newstemplateid = "";
		newstemplatetype = "";
	}
}

ArrayList docSrcList=Util.TokenizerString(""+newsId, "|");
if (docSrcList.size()>0) srcType=(String)docSrcList.get(0);
if (docSrcList.size()>1) srcContent=(String)docSrcList.get(1);
if (docSrcList.size()>2) srcReply=(String)docSrcList.get(2);


if("0".equals(srcContent)) return ;
String strAccess="";
if("1".equals(srcOpenFirstAccess)) strAccess="&isOpenFirstAss=1";
else strAccess="&isOpenFirstAss=0";
		
String rollDirection="";
if(strsqlwheres.length<=2)  rollDirection="None";
else  rollDirection=strsqlwheres[2];
%>


<%
String  userid1=""+user.getUID();
String ownerid=userid1;
String strImg="";
ArrayList docIdList=new ArrayList();
ArrayList docsubjectList=new ArrayList();
ArrayList doclastmoddateList=new ArrayList();
ArrayList doclastmodtimeList=new ArrayList();
ArrayList docContentList=new ArrayList();
ArrayList doccreateridList = new ArrayList();
ArrayList readCountList = new ArrayList();
String andSql="";
//String invalidStr = " or docstatus = 7 and  (sharelevel>1" + ((userid1!=null&&!"".equals(userid1))?" or (doccreaterid=" + userid1 + ((ownerid!=null&&!"".equals(ownerid))?" or ownerid=" + ownerid:"") + ")":"") + ") ";
//String strStatus=" and (docstatus='1' or docstatus='2' or docstatus='5' "+invalidStr+")";
String invalidStr = " or (docstatus = 7 and  (sharelevel>1" + ((userid1!=null&&!"".equals(userid1))?" or (doccreaterid=" + userid1 + ((ownerid!=null&&!"".equals(ownerid))?" or ownerid=" + ownerid:"") + ")":"") + ")) ";
String strStatus=" and (((docstatus='1' or docstatus='2' or docstatus='5') and sharelevel>0) "+invalidStr+")";
//在协同中，获取参数并拼接条件
String newsfrom = "";
if(Util.getIntValue(hpid) < 0)
{
	int docid = Util.getIntValue(request.getParameter("requestid"),-1);
	String syparaSql = sod.getDocAndSql(eid,docid,Util.getIntValue(hpid),user);
	newsfrom = sod.getDocFromSql(eid);
	strStatus += syparaSql;
}
String topDocWhere="";
/**文档置顶*/
if(!topDocIds.equals("")){
	ArrayList docids=Util.TokenizerString(topDocIds,",");
	String newDocids="";
	 for(int i=0;i<docids.size();i++)	newDocids+=","+(String)docids.get(i);
	if(newDocids.length()>0) newDocids=newDocids.substring(1);
	
	andSql=" and t1.id in("+newDocids+") "+strStatus;
	topDocWhere = " and t1.id  not in("+newDocids+") ";
	//在协同中，获取参数并拼接条件
	if(Util.getIntValue(hpid) < 0)
	{
		dm.selectNewsDocInfo4Synergy(newsfrom,andSql, user,perpage, 1);
	}else
		dm.selectNewsDocInfo(andSql, user,perpage, 1);
	while (dm.next()) {
		docIdList.add(""+dm.getDocid());
		docsubjectList.add(""+dm.getDocsubject()) ;
		doclastmoddateList.add(""+dm.getDoclastmoddate()) ;
		doclastmodtimeList.add(""+dm.getDoclastmodtime()) ;
		docContentList.add(dm.getDoccontent());
		doccreateridList.add(""+dm.getDoccreaterid());
		readCountList.add(""+dm.getReadCount());
	}
	//topDocCount = docids.size();
	//perpage = perpage-docids.size();
	topDocCount = dm.getCount();
	//perpage = perpage-topDocCount;
	if(perpage<0){
		perpage = 0;
	}
}
strStatus = strStatus+topDocWhere;

if("1".equals(srcType)){//新闻中心
	
	String newsclause = "";

	dnm.resetParameter();
	dnm.setId(Util.getIntValue(srcContent));
	dnm.getDocNewsInfoById();
	newsclause = dnm.getNewsclause();
	dnm.closeStatement();

	String newslistclause = newsclause.trim();
	if (!newslistclause.equals("")) 	newslistclause = " and (" + newslistclause+") ";
	andSql = newslistclause	+ "  and (ishistory is null or ishistory = 0)  and docpublishtype in('2','3') "+strStatus;
	//在协同中，获取参数并拼接条件
	if(Util.getIntValue(hpid) < 0)
	{
		dm.selectNewsDocInfo4Synergy(newsfrom,andSql, user,perpage, 1);
	}else
		dm.selectNewsDocInfo(andSql, user,perpage, 1);
} else if("2".equals(srcType)){  //文档目录
	if(",".equals(srcContent.substring(0,1))) srcContent=srcContent.substring(1);
	andSql="  and (ishistory is null or ishistory = 0)  and exists (select id from docseccategory where id = seccategory and id in ("+srcContent+")) "+strStatus;
    if (isNewReply || !"1".equals(srcReply))	andSql+=" and (isreply!=1 or  isreply is null) ";
  //在协同中，获取参数并拼接条件
	if(Util.getIntValue(hpid) < 0)
	{
		dm.selectNewsDocInfo4Synergy(newsfrom,andSql, user,perpage, 1);
	}else
		dm.selectNewsDocInfo(andSql, user,perpage, 1);
		
} else if("3".equals(srcType)){  //虚拟目录	
	andSql=" and (ishistory is null or ishistory = 0)  "+strStatus;
	if (isNewReply || !"1".equals(srcReply) )	andSql+=" and (isreply!=1 or  isreply is null)";
	//dm.selectNewsDocInfo(andSql, user,perpage, 1,srcContent);
	//在协同中，获取参数并拼接条件
	if(Util.getIntValue(hpid) < 0)
	{
		dm.selectNewsDocInfoForHpSynergy(newsfrom,andSql, user,perpage, 1,srcContent);
	}else
		dm.selectNewsDocInfoForHp(andSql, user,perpage, 1,srcContent);

} else if("4".equals(srcType)){ //指定文档
	ArrayList docids=Util.TokenizerString(srcContent,",");
	String newDocids="";
    for(int i=0;i<docids.size();i++)	newDocids+=","+dm.getNewDocid((String)docids.get(i));
	if(newDocids.length()>0) newDocids=newDocids.substring(1);
	
	andSql=" and id in("+newDocids+") "+strStatus;
	//在协同中，获取参数并拼接条件
	if(Util.getIntValue(hpid) < 0)
	{
		dm.selectNewsDocInfo4Synergy(newsfrom,andSql, user,perpage, 1);
	}else
		dm.selectNewsDocInfo(andSql, user,perpage, 1);

}else if("5".equals(srcType)){ //搜索模板

}else if("6".equals(srcType)){ //搜索条件
//预留
}

//得到去掉top的几条数据，余下的显示的条数
int temp_perpage=perpage-topDocCount;
int temp_js=0;
while (dm.next()) {
	//System.out.println(topDocIds+"文档的id"+dm.getDocid());
	//排除重复的文档的id
	if((","+topDocIds+",").indexOf(","+dm.getDocid()+",")==-1&&temp_js<temp_perpage){
		temp_js++;
		docIdList.add(""+dm.getDocid());
		docsubjectList.add(""+dm.getDocsubject()) ;
		doclastmoddateList.add(""+dm.getDoclastmoddate()) ;
		doclastmodtimeList.add(""+dm.getDoclastmodtime()) ;
		docContentList.add(dm.getDoccontent());
		doccreateridList.add(""+dm.getDoccreaterid());
		readCountList.add(""+dm.getReadCount());
	}
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
	strImg="";
	if(imgType.equals("0")||imgType.equals("")){
		if (fieldColumnList.contains("img")) {
	strImg = hpes.getImgPlay(request,docIdList,docContentList,imgWidth,imgHeight,hpec.getStyleid(eid),eid);
		}
	}else{
		strImg = "<img src="+imgSrc+" height = "+imgHeight+" width="+imgWidth+" />";
	}
	returnStr +="<table width=\"100%\"  cellPadding='0' cellSpacing='0'><tr><td valign=\"top\"><table style='margin-top:6px' cellPadding='0' cellSpacing='0'><tr><TD  height=\"112\" valign=\"top\">"+strImg+"</TD></tr></table></td>\n";
	returnStr +="<td width=1px>&nbsp;</td><td width=\"100%\" valign=\"top\">" ;
}
returnStr += "<TABLE class='elementdatatable'  width=\"100%\"";
//System.out.println("showModeId:"+showModeId);
if (showModeId == 3 || showModeId == 2 ){ //左图式 or 上图式 or 多图式
	returnStr += " cellPadding='0' cellSpacing='0' >\n";
} else {
	returnStr += " >\n";
}
int rowcount=0;
String imgSymbol="";
if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";

String docshowlink = "";//文档打开方式
if("".equals(newstemplateid)){//默认文档显示页面
	docshowlink= "/docs/docs/DocDsp.jsp?id=";
}else{//文档显示模版
	docshowlink = "/page/maint/template/news/newstemplate.jsp?templatetype="+newstemplatetype+"&templateid="+newstemplateid+"&docid=";
}

%>

	
	<%
int height = docIdList.size()*23;
	int tabsize = Util.getIntValue(request.getParameter("tabsize"),1);
	int eHeight=Util.getIntValue(hpec.getHeight(eid),0);

	if(eHeight>0&&height<eHeight){
		if(tabsize>1){
			height = eHeight-36;
		}else{
			height = eHeight-4;
		}
	}
if("Up".equals(rollDirection)||"Down".equals(rollDirection)) {
	if((showModeId==2||showModeId==3||showModeId==4)&&height<156) height = 156;
	out.println("<MARQUEE DIRECTION="+rollDirection.toLowerCase()+"  id=\"webjx_"+eid+"\" onmouseover=\"webjx_"+eid+".stop()\" onmouseout=\"webjx_"+eid+".start()\"  SCROLLDELAY=200 height="+height+">");
}else if("Left".equals(rollDirection)||"Right".equals(rollDirection)) {
	out.println("<MARQUEE DIRECTION="+rollDirection.toLowerCase()+"  id=\"webjx_"+eid+"\" onmouseover=\"webjx_"+eid+".stop()\" onmouseout=\"webjx_"+eid+".start()\"  SCROLLDELAY=200>");
}
%>
<TABLE  id="_contenttable_<%=eid%>" class=Econtent  width=100%>
   <TR>
	 <TD width=1px></TD>
	 <TD width='*' valign="top">
	 
	 <%
		 
for (int i=0;i<docIdList.size();i++) {
	int docid = Util.getIntValue((String)docIdList.get(i));
	String docId=(String)docIdList.get(i);
	String docsubject = (String)docsubjectList.get(i);
	String doccontent = (String)docContentList.get(i);
	String doclastmoddate =  (String)doclastmoddateList.get(i);
	String doclastmodtime =  (String)doclastmodtimeList.get(i);
	String doccreaterid = (String)doccreateridList.get(i);
	int readCount = Util.getIntValue((String)readCountList.get(i),0);

	//
	
	
	if(showModeId==5){
		if(i%2==0){
	returnStr+="<tr>";
	
		}
		returnStr += "	<TD width=\"8\">"+imgSymbol+"</TD>\n";
		//returnStr+=""
	}else{
		returnStr += "<TR>\n";
	}

	if(showModeId == 1||showModeId == 4){
		
		returnStr += "	<TD width=\"8\">"+imgSymbol+"</TD>\n";
	}
	int size = fieldIdList.size();
	if (fieldColumnList.contains("img")) {
		size--;
	}
	 boolean isOnlyImg = false;
	for (int j = 0; j <  fieldIdList.size(); j++) {
		String fieldId = (String) fieldIdList.get(j);
		String columnName = (String) fieldColumnList.get(j);
		String strIsDate = (String) fieldIsDate.get(j);
		String fieldwidth = (String) fieldWidthList.get(j);
		String isLimitLength = (String) isLimitLengthList.get(j);

		String cloumnValue = docsubject;
		String titleValue = cloumnValue;
		
		if (showModeId == 1 || showModeId == 4||showModeId==5) {// 列表式
	
			//todo
	 if ("docdocsubject".equals(columnName)) {
		int wordLength = 8;
		//if ("1".equals(isLimitLength))
			//cloumnValue = hpu.getLimitStr(eid, fieldId,cloumnValue,user,hpid,subCompanyId);

			String imgNew="<IMG id='doclist_"+docId+"img' src='/images/ecology8/statusicon/BDNew_wev8.png' title='"+SystemEnv.getHtmlLabelName(18441,user.getLanguage())+"' class='wfremindimg' border=0 align='absbottom'>";
			if(i<topDocCount){
		imgNew="<IMG src='/images/BDTop_wev8.gif' border=0 align='absbottom'>";
			}else if(!dc.getIsNewDoc(docId, user.getLogintype(), ""+user.getUID(),doccreaterid,readCount)){ 
		imgNew="";
			}

		String showValue = "";
		
		if ("1".equals(linkmode)) {
			showValue = "<a class='ellipsis'  href='"+docshowlink
			+ docid+strAccess
			+ "' target='_self'>"
			+ "<font class='font docnamedetail'>"+cloumnValue+"</font>" + "</a>\n";
		} else {
			showValue = "<a class='ellipsis'  href=\"javascript:openFullWindowForDoc('"+docshowlink
			+ docid+strAccess
			+ "','"+docid+"')\">"
			+ "<font class='font docnamedetail' >"+cloumnValue+"</font>"
			+ "</a>\n";
		}
		
		returnStr += "<td class='docdetail' width='" + fieldwidth
		+ "' title='" + titleValue + "'>"
		+ showValue +imgNew+ "</td>\n";
	}else if("summary".equals(columnName)){
		String newTitle = cloumnValue;
			//hpu.getLimitStr(eid, fieldId,
			//	cloumnValue,user,hpid,subCompanyId);
		String strmemo = "";
		int tmppos = doccontent.indexOf("!@#$%^&*");
		if (tmppos != -1) strmemo = doccontent.substring(0, tmppos);
		
		if (!fieldColumnList.contains("docdocsubject")){
			newTitle = "";
		} else {
			int tempPos=fieldColumnList.indexOf("docdocsubject");
			String tempFiledId=(String)fieldIdList.get(tempPos);
			//newTitle = hpu.getLimitStr(eid, tempFiledId,newTitle,user,hpid,subCompanyId);

			String imgNew="<IMG id='doclist_"+docId+"img' src='/images/ecology8/statusicon/BDNew_wev8.png' title='"+SystemEnv.getHtmlLabelName(18441,user.getLanguage())+"' class='wfremindimg' border=0 align='absbottom'>";
			if(i<topDocCount){
				imgNew="<IMG src='/images/BDTop_wev8.gif' border=0 align='absbottom'>";
			}else if(!dc.getIsNewDoc(docId, user.getLogintype(), ""+user.getUID(),doccreaterid,readCount)){ 
				imgNew="";
			}
			
			if ("1".equals(linkmode)) {
				newTitle = "<a class='ellipsis'  href='"+docshowlink+ docid+strAccess+ "' target='_self'>"+"<font class=font>"+newTitle+"</font>" +imgNew+ "</a>\n";
			} else {
				newTitle = "<a  class='ellipsis'  href=\"javascript:openFullWindowForDoc('"+docshowlink+ docid+strAccess+ "','"+docid+"')\">"+ "<font class=font>"+newTitle+"</font>" +imgNew+ "</a>\n";
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
			
			//strmemo = hpu.getLimitStr(eid, tempFiledId,strmemo,user,hpid,subCompanyId);
			if ("1".equals(linkmode)) {
				strmemo = "<a class='ellipsis'  href='"+docshowlink+ docid+ strAccess+"' target='_self'><font class=font>"+ strmemo + "</font></a>\n";
			} else {
				strmemo = "<a class='ellipsis'  href=\"javascript:openFullWindowForXtable('"+docshowlink+docid+strAccess+ "')\"><font class=font> "+ strmemo+ "</font></a>\n";
			}
		}
		returnStr += "<td  width='" + fieldwidth + "'>"
		+ "<font class=font>"+strmemo+"</font>" + "</td>\n";
		
	} else if ("doclastmoddate".equals(columnName)) {
		returnStr += "<td  width='" + fieldwidth + "'>"
		+ "<font class=font>"+doclastmoddate+"</font>" + "</td>\n";
	} else if ("doclastmodtime".equals(columnName)) {
		returnStr += "<td  width='" + fieldwidth + "'>"
		+ "<font class=font>"+doclastmodtime+"</font>" + "</td>\n";
	}
		 	
		} else {

	String newTitle =cloumnValue;
	//hpu.getLimitStr(eid, fieldId,
	//		cloumnValue,user,hpid,subCompanyId);
	String strmemo = "";
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if (tmppos != -1) strmemo = doccontent.substring(0, tmppos);
	
	if (!fieldColumnList.contains("docdocsubject")){
		newTitle = "";
	} else {
		int tempPos=fieldColumnList.indexOf("docdocsubject");
		String tempFiledId=(String)fieldIdList.get(tempPos);
		//newTitle = hpu.getLimitStr(eid, tempFiledId,newTitle,user,hpid,subCompanyId);

		String imgNew="<IMG id='doclist_"+docId+"img' src='/images/ecology8/statusicon/BDNew_wev8.png' title='"+SystemEnv.getHtmlLabelName(18441,user.getLanguage())+"'  class='wfremindimg' border=0 align='absbottom'>";
		if(i<topDocCount){
			imgNew="<IMG src='/images/BDTop_wev8.gif'  border=0 align='absbottom'>";
		}else if(!dc.getIsNewDoc(docId, user.getLogintype(), ""+user.getUID(),doccreaterid,readCount)){ 
			imgNew="";
		}
		
		if ("1".equals(linkmode)) {
			newTitle = "<a class='ellipsis'  href='"+docshowlink+ docid+strAccess+ "' target='_self'>"+"<font class=font>"+newTitle+"</font>" +imgNew+ "</a>\n";
		} else {
			newTitle = "<a class='ellipsis'  href=\"javascript:openFullWindowForDoc('"+docshowlink+ docid+strAccess+ "','"+docid+"')\">"+ "<font class=font>"+newTitle+"</font>" +imgNew+ "</a>\n";
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
		
		//strmemo = hpu.getLimitStr(eid, tempFiledId,strmemo,user,hpid,subCompanyId);
		if ("1".equals(linkmode)) {
			strmemo = "<a class='ellipsis'  href='"+docshowlink+ docid+ strAccess+"' target='_self'><font class=font>"+ strmemo + "</font></a>\n";
		} else {
			strmemo = "<a class='ellipsis'  href=\"javascript:openFullWindowForXtable('"+docshowlink+docid+strAccess+ "')\"><font class=font> "+ strmemo+ "</font></a>\n";
		}
	}
	if(perpage!=1) size=size - 1;
	if (showModeId == 2) { // 上图式
		 //得到图片播放
		
		if(imgType.equals("0")||imgType.equals("")){
			if (fieldColumnList.contains("img")) {
		strImg = hpes.getImgPlay(request,docId,doccontent,imgWidth,imgHeight,hpec.getStyleid(eid),eid);
			}
		}else{
			strImg = "<img src="+imgSrc+" height = "+imgHeight+" width="+imgWidth+" />";
		}
		if("".equals(newTitle )) imgSymbol="";
		returnStr += "<TD colspan=" + size+ " valign=top align=center>"+
				"<TABLE valign=top align=center cellPadding='0' cellSpacing='0'>" +
				"	<TR><TD  valign=top align=center>" + strImg+ "</TD></TR>" +
				"	<TR><TD  align=center>"+imgSymbol+ newTitle+ "</TD></TR>" +
				"	<TR><TD valign=top  align=center>" + strmemo+"</TD></TR>";
		if(!"".equals(doclastmoddate)||!"".equals(doclastmodtime))			
			returnStr+= "<TR><TD valign=top  align=center>" + "<font class=font>"+doclastmoddate + "&nbsp;"+ doclastmodtime+"</font>"+"</TD></TR>";
		returnStr+= "</TABLE></TD>";
		break;
	} else if (showModeId == 3){ // 左图式
		  //得到图片播放
		strImg="";
	
		if(imgType.equals("0")||imgType.equals("")){
			if (fieldColumnList.contains("img")) {
		strImg = hpes.getImgPlay(request,docId,doccontent,imgWidth,imgHeight,hpec.getStyleid(eid),eid);
			}
		}else{
			strImg = "<img src="+imgSrc+" height = "+imgHeight+" width="+imgWidth+" />";
		}
		
		if("".equals(newTitle )) imgSymbol="";
		returnStr += "<TD colspan=" + size+ ">"+
			   "<TABLE   width='100%'>" + 
			   "<TR>" + 
			   "	<TD  rowspan=4 align=left valign=top>"+ strImg + "</TD>" +
			   "	<TD  width='100%'  valign=top>"+
				"		<table width='100%'   valign=top>"+
			   "		<tr>"+
				"	<td>"+imgSymbol+ newTitle+ "</td>"+
			   "		</tr>"+
			   "		<tr height=1px class='sparator' style='height:1px'>"+
				"	<td style='padding:0px'></td>"+
			   "		</tr>"+
			   "		<tr>"+
				"	<td>"+ strmemo+"</td>"+
			   "		</tr>";
			   
	    if(!"".equals(doclastmoddate)||!"".equals(doclastmodtime))	
			returnStr += "<tr><td>"+ "<font class=font>"+doclastmoddate+ "&nbsp;" + doclastmodtime+"</font>"+"</td></tr>" ;
		returnStr += "</table></TD></TR></TABLE></TD>";
		break;
	}
	
		}
		
	}
	if(showModeId==5){
		
		if(i==docIdList.size()-1){
	returnStr+="</tr>";
		}else{
	if(i%2==1){
		returnStr+="</tr>";
		returnStr += "<TR class='sparator' style='height:1px' height=1px><td style='padding:0px' colspan=" + (size + 1)*2
		+ "></td></TR>\n";	
	}else{
		//returnStr+="</tr>";
	}
		}
	}else{
		returnStr += "</TR>\n";
		rowcount++;
		if(perpage!=1&&rowcount<perpage+topDocCount)
	returnStr += "<TR class='sparator' style='height:1px' height=1px><td style='padding:0px' colspan=" + ((showModeId==2 || showModeId==3)?size:(size + 1))
		+ "></td></TR>\n";	//上图式 左图式没有小圆点列 跨列不加1
	}
	//returnStr += "</TR>\n";
		
}
returnStr += "</TABLE>\n";
if(showModeId == 4) {
		  returnStr +="     </td></tr></table>\n";
}
if(showModeId == 4) {
	if(fieldColumnList.size()==1&&fieldColumnList.indexOf("img")!=-1){
		returnStr = strImg;
	}
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

<script>
    //处理
	var isremind='<%=isremind%>';
	//设置提示样式
	if(isremind!==''){
     	setRemindInfo("<%=eid%>", isremind,"docdetail","docnamedetail");
	}
	
	function initDocPicSlide(eid) {
		var n = 0;
		var count = $('#banner_'+eid+' a').length;
		//$('#banner_'+eid+' a').css('z-index','100')
		$('#banner_'+eid).css('border','1px solid #707070')
		$('#banner_'+eid+' .slidebox_list a:not(:first-child)').hide();
		
		$('#banner_'+eid+' .navitem').eq(0).toggleClass('on1');
		
		$('#banner_'+eid+' .navitem').click(function(e) {
			var i = $(this).attr('_index') - 1; 
			n = i;
			if (i >= count) return;
			$('#banner_'+eid+' a').filter(':visible').fadeOut(500).parent().children().eq(i).fadeIn(500);
			
			$('#banner_'+eid+' .navitem').eq(i).toggleClass('on1');
			$(this).siblings().removeClass('on1');
			var event = $.event.fix(e);
			event.stopPropagation();
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
		<%if(showModeId == 2 ||showModeId == 3 ){
				for (int i=0;i<docIdList.size();i++) {
					String outEid = eid+"_"+Util.null2String(docIdList.get(i));
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
		<%}
		}else if(showModeId == 4){
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