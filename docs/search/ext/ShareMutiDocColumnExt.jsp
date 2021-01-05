
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="weaver.general.*"%>
<%@ page import="weaver.docs.docSubscribe.*"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.common.xtable.*"%>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />

<%
	String sessionId=Util.getEncrypt("xTableSql_"+Util.getRandom()); 

	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null){
		return;
	}
%>
<%@ include file="/docs/common.jsp" %>

<%

	//pagesize

	
	//operateString userType_userId_userSeclevel
	//String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
	//String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel";

	
	String sqlWhere="";
//查询设置
String userid=user.getUID()+"" ;
String userSeclevel = user.getSeclevel() ;
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
char flag=2;
boolean shownewicon=false;
String tabletype="checkbox";
String browser="";



/* added by yinshun.xu 2006-07-19 按组织结构显示 */
//String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
//String departmentid=Util.null2String(request.getParameter("departmentid"));

/* added end */




	String tableString = "";
	String tableInfo = "";

		String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
		if(RecordSet.getDBType().equals("oracle"))
		{
			outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
		}
		//backFields
		String backFields="t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname,t1.doccreaterid,";
		//from

		//where
		String self = Util.null2String(request.getParameter("self")) ;
String date2during =Util.null2String(request.getParameter("date2during"));
/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
int showtype = Util.getIntValue(request.getParameter("showtype"),0);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
/* edited end */
String frompage=Util.null2String(request.getParameter("frompage"));//从哪个页面过来
////排序状态 0:默认排序 1:按文章分数排序  2:按文章打分人数排序 3:按文章的访问题排序
int sortState = Util.getIntValue(Util.null2String(request.getParameter("sortState")),0) ;

String docsubject = Util.null2String(request.getParameter("docsubject")) ;
String doccontent = Util.null2String(request.getParameter("doccontent")) ;
String containreply = Util.null2String(request.getParameter("containreply")) ;
String maincategory=Util.null2String(request.getParameter("maincategory"));
if(maincategory.equals("0"))maincategory="";
String subcategory=Util.null2String(request.getParameter("subcategory"));
if(subcategory.equals("0"))subcategory="";
String seccategory=Util.null2String(request.getParameter("seccategory"));
if(seccategory.equals("0"))seccategory="";
String docid=Util.null2String(request.getParameter("docid"));
if(docid.equals("0"))docid="";
String doccreaterid=Util.null2String(request.getParameter("doccreaterid"));
if(doccreaterid.equals("0")) doccreaterid="";

String departmentid=Util.null2String(request.getParameter("departmentid"));
if(departmentid.equals("0")) departmentid="";
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
if(subcompanyid.equals("0")) subcompanyid="";

String doclangurage=Util.null2String(request.getParameter("doclangurage"));
if(doclangurage.equals("0"))doclangurage="";
String hrmresid=Util.null2String(request.getParameter("hrmresid"));
if(hrmresid.equals("0"))hrmresid="";
String itemid=Util.null2String(request.getParameter("itemid"));
if(itemid.equals("0"))itemid="";
String itemmaincategoryid=Util.null2String(request.getParameter("itemmaincategoryid"));
if(itemmaincategoryid.equals("0"))itemmaincategoryid="";
String crmid=Util.null2String(request.getParameter("crmid"));
if(crmid.equals("0"))crmid="";
String projectid=Util.null2String(request.getParameter("projectid"));
if(projectid.equals("0"))projectid="";
String financeid=Util.null2String(request.getParameter("financeid"));
if(financeid.equals("0"))financeid="";
String docpublishtype=Util.null2String(request.getParameter("docpublishtype")) ;
String docstatus=Util.null2String(request.getParameter("docstatus")) ;
String keyword=Util.null2String(request.getParameter("keyword"));
String contentname=Util.null2String(request.getParameter("contentname"));

String ownerid=Util.null2String(request.getParameter("ownerid"));
if(ownerid.equals("0")) ownerid="";

String isreply=Util.null2String(request.getParameter("isreply"));
String isNew=Util.null2String(request.getParameter("isNew"));
String loginType=user.getLogintype();//Util.null2String(request.getParameter("loginType"));
String isMainOrSub=Util.null2String(request.getParameter("isMainOrSub"));
String usertype =Util.null2String(request.getParameter("usertype"));

String docno = Util.null2String(request.getParameter("docno"));
String doclastmoddatefrom = Util.null2String(request.getParameter("doclastmoddatefrom"));
String doclastmoddateto = Util.null2String(request.getParameter("doclastmoddateto"));
String docarchivedatefrom = Util.null2String(request.getParameter("docarchivedatefrom"));
String docarchivedateto = Util.null2String(request.getParameter("docarchivedateto"));
String doccreatedatefrom = Util.null2String(request.getParameter("doccreatedatefrom"));
String doccreatedateto = Util.null2String(request.getParameter("doccreatedateto"));
String docapprovedatefrom = Util.null2String(request.getParameter("docapprovedatefrom"));
String docapprovedateto = Util.null2String(request.getParameter("docapprovedateto"));
String replaydoccountfrom = Util.null2String(request.getParameter("replaydoccountfrom"));
String replaydoccountto = Util.null2String(request.getParameter("replaydoccountto"));
String accessorycountfrom = Util.null2String(request.getParameter("accessorycountfrom"));
String accessorycountto = Util.null2String(request.getParameter("accessorycountto"));

String doclastmoduserid = Util.null2String(request.getParameter("doclastmoduserid"));
if(doclastmoduserid.equals("0")) doclastmoduserid="";
String docarchiveuserid = Util.null2String(request.getParameter("docarchiveuserid"));
if(docarchiveuserid.equals("0")) docarchiveuserid="";
String docapproveuserid = Util.null2String(request.getParameter("docapproveuserid"));
if(docapproveuserid.equals("0")) docapproveuserid="";
String assetid = Util.null2String(request.getParameter("assetid"));
if(assetid.equals("0")) assetid="";
String treeDocFieldId = Util.null2String(request.getParameter("treeDocFieldId"));
if(treeDocFieldId.equals("0")) treeDocFieldId="";


String noRead = Util.null2String(request.getParameter("noRead"));
String dspreply = Util.null2String(request.getParameter("dspreply"));
//set DocSearchComInfo values------------------------------------

DocSearchComInfo.resetSearchInfo();
String docsubject_rep = docsubject.replaceAll("'","''");
docsubject_rep = docsubject_rep.replaceAll("\"","&quot;");
DocSearchComInfo.setContainreply(containreply);
DocSearchComInfo.setDocsubject(docsubject_rep);
DocSearchComInfo.setDoccontent(doccontent);
DocSearchComInfo.setMaincategory(maincategory);
DocSearchComInfo.setSubcategory(subcategory);
DocSearchComInfo.setSeccategory(seccategory);
DocSearchComInfo.setDocid(docid);
DocSearchComInfo.setDoccreaterid(doccreaterid);
DocSearchComInfo.setDocdepartmentid(departmentid);
DocSearchComInfo.setDoclanguage(doclangurage);
DocSearchComInfo.setHrmresid(hrmresid);
DocSearchComInfo.setItemid(itemid);
DocSearchComInfo.setItemmaincategoryid(itemmaincategoryid);
DocSearchComInfo.setCrmid(crmid);
DocSearchComInfo.setProjectid(projectid);
DocSearchComInfo.setFinanceid(financeid);
DocSearchComInfo.setUsertype(usertype);
DocSearchComInfo.setUserID(""+user.getUID());
DocSearchComInfo.setIsreply(isreply) ;
DocSearchComInfo.setIsNew(isNew) ;
DocSearchComInfo.setIsMainOrSub(isMainOrSub) ;
DocSearchComInfo.setLoginType(loginType) ;
DocSearchComInfo.setNoRead(noRead) ;
DocSearchComInfo.setDate2during(date2during);
if ("0".equals(dspreply)) DocSearchComInfo.setContainreply("1");   //全部
else if("1".equals(dspreply)) DocSearchComInfo.setContainreply("0");   //非回复
else if ("2".equals(dspreply)) DocSearchComInfo.setIsreply("1");  //仅回复

if(docpublishtype.equals("1")||docpublishtype.equals("2")||docpublishtype.equals("3")||docpublishtype.equals("5")){
	DocSearchComInfo.setDocpublishtype(docpublishtype);
}

if(docstatus.equals("1")||docstatus.equals("5")||docstatus.equals("7")){

	if(docstatus.equals("1")){
		DocSearchComInfo.addDocstatus("1");
		DocSearchComInfo.addDocstatus("2");
	}
	else
		DocSearchComInfo.addDocstatus(docstatus);
}
else{
	DocSearchComInfo.addDocstatus("1");
	DocSearchComInfo.addDocstatus("2");
    DocSearchComInfo.addDocstatus("5");
    if(frompage.equals(""))
    DocSearchComInfo.addDocstatus("7");
}

DocSearchComInfo.setKeyword(keyword);
DocSearchComInfo.setOwnerid(ownerid);
DocSearchComInfo.setContentname(contentname);

DocSearchComInfo.setDocno(docno);
DocSearchComInfo.setDoclastmoddateFrom(doclastmoddatefrom);
DocSearchComInfo.setDoclastmoddateTo(doclastmoddateto);
DocSearchComInfo.setDocarchivedateFrom(docarchivedatefrom);
DocSearchComInfo.setDocarchivedateTo(docarchivedateto);
DocSearchComInfo.setDoccreatedateFrom(doccreatedatefrom);
DocSearchComInfo.setDoccreatedateTo(doccreatedateto);
DocSearchComInfo.setDocapprovedateFrom(docapprovedatefrom);
DocSearchComInfo.setDocapprovedateTo(docapprovedateto);
DocSearchComInfo.setReplaydoccountFrom(replaydoccountfrom);
DocSearchComInfo.setReplaydoccountTo(replaydoccountto);
DocSearchComInfo.setAccessorycountFrom(accessorycountfrom);
DocSearchComInfo.setAccessorycountTo(accessorycountto);
DocSearchComInfo.setDoclastmoduserid(doclastmoduserid);
DocSearchComInfo.setDocarchiveuserid(docarchiveuserid);
DocSearchComInfo.setDocapproveuserid(docapproveuserid);
DocSearchComInfo.setAssetid(assetid);
DocSearchComInfo.setTreeDocFieldId(treeDocFieldId);

DocSearchComInfo.setDocSubCompanyId(subcompanyid);
String strShowType="";
if(showtype==0){
	strShowType="";
}else{
	strShowType=String.valueOf(showtype);
}
DocSearchComInfo.setShowType(strShowType);

//处理自定义条件 begin
    String[] checkcons = request.getParameterValues("check_con");
    String sqlwhere = "";
    String sqlrightwhere = "";
    String temOwner = "";

    if(checkcons!=null){
        for(int i=0;i<checkcons.length;i++){
            String tmpid = ""+checkcons[i];
            String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
            String tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
            String tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
            String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
            String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
            String tmpname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_name"));
            String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
            String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));

            //生成where子句

            temOwner = "tCustom";

            if((tmphtmltype.equals("1")&& tmptype.equals("1"))||tmphtmltype.equals("2")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
                if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
                if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
            }else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){
                    if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";

                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){
                    if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
                }
            }
            else if(tmphtmltype.equals("4")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
                else sqlwhere +="='1' ";
            }
            else if(tmphtmltype.equals("5")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
            }
            else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65") ){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){ // 对日期处理
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){
                    if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";

                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){
                    if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
                }
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65") )){       // 对多人力资源，多客户，多文档的处理
                sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
                if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
                if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
            }

            sqlwhere +=") ";

        }

    }
    
    //for debug
  
    if(!sqlwhere.equals("")){
        //去掉sql语句前面的and
        sqlwhere = sqlwhere.trim().substring(3);
        DocSearchComInfo.setCustomSqlWhere(sqlwhere);
    }else{
        DocSearchComInfo.setCustomSqlWhere("");
    }

	String  sqlFrom = "DocDetail  t1, "+tables+"  t2";  
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	whereclause+=" and t2.sharelevel=3 ";
	whereclause+=" and exists(select 1 from DocSecCategory where DocSecCategory.id=t1.secCategory and DocSecCategory.shareable='1') ";
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if(pagesize <2) pagesize=10;
	String orderBy = "doclastmoddate,doclastmodtime";    
	//primarykey
	String primarykey = "t1.id";
	sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);
	
		
		//operateString userType_userId_userSeclevel
		String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
		String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel";

		
		//  用户自定义设置
		boolean dspcreater = false ;
		boolean dspcreatedate = false ;
		boolean dspmodifydate = false ;
		boolean dspdocid = false;
		boolean dspcategory = false ;
		boolean dspaccessorynum = false ;
		boolean dspreplynum = false ;
		
		String userInfoForotherpara =loginType+"+"+userid;
		String colString ="";

		colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
		
		colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId90974\" otherpara=\""+userInfoForotherpara+"+column:doccreaterid+column:readCount+column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
		
		
		if (UserDefaultManager.getHasdocid().equals("1")) {
		    dspdocid = true;    
		}
		if (UserDefaultManager.getHascreater().equals("1")) {
		      dspcreater = true ;
		      backFields+="ownerid,t1.usertype,";
		      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
		}
		if (UserDefaultManager.getHascreatedate().equals("1")) { 
		    dspcreatedate = true ;
		    backFields+="doccreatedate,";
		    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
		}
		if (UserDefaultManager.getHascreatetime().equals("1")) {
		    dspmodifydate = true ;
		    backFields+="doclastmoddate,";
		    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
		}
		if (UserDefaultManager.getHascategory().equals("1")) {   
		    dspcategory = true ;
		    backFields+="maincategory,";
		    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
		}
		if (UserDefaultManager.getHasreplycount().equals("1")) {  
		    dspreplynum = true ;
		    backFields+="replaydoccount,";
		    colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
		}
		if (UserDefaultManager.getHasaccessorycount().equals("1")) {  
		    dspaccessorynum = true ;
		    backFields+="accessorycount,";
		    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
		}
		
		backFields+="sumReadCount,docstatus,sumMark";
		

			colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
			colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"sumMark\" orderkey=\"sumMark\"/>";
			//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
			//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\"  otherpara=\""+user.getLanguage()+"\"/>";
			colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\"  otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";

			
		//默认为按文档创建日期排序所以,必须要有这个字段
		if (backFields.indexOf("doclastmoddate")==-1) {
		    backFields+=",doclastmoddate";
		}

		//String tableString
		tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
		tableString+=browser;
	    //tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
	    tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
	    tableString+="<head>"+colString+"</head>";
	    tableString+="</table>";   
%>
<%
	session.setAttribute(sessionId,tableString);
	out.println("var tableString = '"+tableString+"'; var tableInfo = '"+tableInfo+"';var sessionId='"+sessionId+"';"); 

	return;
%>