<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageIdConst" %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.common.xtable.TableSql" %>
<%@ page import="java.sql.Timestamp" %>
<%@page import="weaver.common.util.taglib.ShowColUtil"%>
<%@ page import="weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sharemanager" class="weaver.share.ShareManager" scope="page" />

<%@ page import="weaver.common.xtable.*"%>
<%@ page import="weaver.general.TimeUtil" %>
<%
boolean useNewSearch = true;
boolean isoracle = RecordSet.getDBType().equalsIgnoreCase("oracle");
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);

String sessionId=Util.getEncrypt("xTableSql_"+Util.getRandom()); 
	ArrayList xTableColumnList = new ArrayList();
	ArrayList xTableOperationList = new ArrayList();
	ArrayList xTableToolBarList = new ArrayList();	
	TableSql xTableSql=new TableSql();
	Table xTable=new Table(request); 
	TableOperatePopedom xTableOperatePopedom=new TableOperatePopedom();
	
		//TableColumn xTableColumn_ID = new TableColumn();
		//xTableColumn_ID.setColumn("id");
		//xTableColumn_ID.setDataIndex("id");
		//xTableColumn_ID.setHeader("&nbsp;&nbsp;");
		//xTableColumn_ID.setSortable(false);
		//xTableColumn_ID.setHideable(false);
		//xTableColumn_ID.setWidth(0.0000001);
		//xTableColumnList.add(xTableColumn_ID);
	 //xTable.setColumnWidth(54);
	 xTableToolBarList.add("");
	 xTableToolBarList.add("");
	 xTableToolBarList.add("");
%>

<%
User user = HrmUserVarify.getUser (request , response) ;
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();
if(user==null){
	return;
}

String rid = user.getUID()+System.currentTimeMillis()+"";

/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
int showtype = Util.getIntValue(request.getParameter("showtype"),0);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
/* edited end */
String frompage=Util.null2String(request.getParameter("frompage"));//从哪个页面过来
////排序状态 0:默认排序 1:按文章分数排序  2:按文章打分人数排序 3:按文章的访问题排序
int sortState = Util.getIntValue(Util.null2String(request.getParameter("sortState")),0) ;
int srcsecid = Util.getIntValue(request.getParameter("srcsecid"), -1);
String docsubject = DocSearchComInfo.getDocsubject();
if(srcsecid>0){
docsubject = Util.null2String(request.getParameter("docsubject"));
}
String docsubject_temp = docsubject;
// docsubject = weaver.general.Escape.unescape(docsubject );
if("".equals(docsubject) && !"".equals(docsubject_temp))
	docsubject = docsubject_temp;

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
String doccreaterid2=Util.null2String(request.getParameter("doccreaterid2"));
if(doccreaterid2.equals("0")) doccreaterid2="";
if(!doccreaterid2.equals("")) {
	
	 doccreaterid=doccreaterid2;
}

String departmentid=Util.null2String(request.getParameter("departmentid"));
if(Util.getIntValue(departmentid,0)<=0) departmentid="";
String vdepartmentid=Util.null2String(request.getParameter("departmentid"));
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
String ownerid=Util.null2String(request.getParameter("ownerid"));
if(ownerid.equals("0")) ownerid="";
if(ownerid.equals("")) ownerid=Util.null2String(request.getParameter("owneridn"));
String ownerid2=Util.null2String(request.getParameter("ownerid2"));
if(ownerid2.equals("0")) ownerid2="";
if(!ownerid2.equals("")){
  ownerid=ownerid2;
} 

String ownerdepartmentid = Util.null2String(request.getParameter("ownerdepartmentid"));
if(ownerdepartmentid.equals("0"))ownerdepartmentid = "";

String ownersubcompanyid = Util.null2String(request.getParameter("ownersubcompanyid"));
if(ownersubcompanyid.equals("0"))ownersubcompanyid = "";

String creatersubcompanyid = Util.null2String(request.getParameter("creatersubcompanyid"));
if(creatersubcompanyid.equals("0"))creatersubcompanyid = "";

String isreply=Util.null2String(request.getParameter("isreply"));
String isNew=Util.null2String(request.getParameter("isNew"));
String loginType="";
if(request.getParameter("loginType")!=null){
	loginType = Util.null2String(request.getParameter("loginType"));
}
else{
	loginType =  user.getLogintype();
}
String isMainOrSub=Util.null2String(request.getParameter("isMainOrSub"));
String usertype =Util.null2String(request.getParameter("usertype"));

String docno = Util.null2String(request.getParameter("docno"));
String doclastmoddatefrom = Util.null2String(request.getParameter("doclastmoddatefrom"));
String doclastmoddateto = Util.null2String(request.getParameter("doclastmoddateto"));
String  doclastmoddateselect = Util.null2String(request.getParameter("doclastmoddateselect"));
if(!doclastmoddateselect.equals("") && !doclastmoddateselect.equals("0") && !doclastmoddateselect.equals("6")){
	doclastmoddatefrom = TimeUtil.getDateByOption(doclastmoddateselect,"0");
	doclastmoddateto = TimeUtil.getDateByOption(doclastmoddateselect,"1");
}

String docarchivedatefrom = Util.null2String(request.getParameter("docarchivedatefrom"));
String docarchivedateto = Util.null2String(request.getParameter("docarchivedateto"));
String  docarchivedateselect = Util.null2String(request.getParameter("docarchivedateselect"));
if(!docarchivedateselect.equals("") && !docarchivedateselect.equals("0") && !docarchivedateselect.equals("6")){
	docarchivedatefrom = TimeUtil.getDateByOption(docarchivedateselect,"0");
	docarchivedateto = TimeUtil.getDateByOption(docarchivedateselect,"1");
}

String doccreatedatefrom = Util.null2String(request.getParameter("doccreatedatefrom"));
String doccreatedateto = Util.null2String(request.getParameter("doccreatedateto"));
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0") && !doccreatedateselect.equals("6")){
	doccreatedatefrom = TimeUtil.getDateByOption(doccreatedateselect,"0");
	doccreatedateto = TimeUtil.getDateByOption(doccreatedateselect,"1");
}
String docapprovedatefrom = Util.null2String(request.getParameter("docapprovedatefrom"));
String docapprovedateto = Util.null2String(request.getParameter("docapprovedateto"));
String  docapprovedateselect = Util.null2String(request.getParameter("docapprovedateselect"));
if(!docapprovedateselect.equals("") && !docapprovedateselect.equals("0") && !docapprovedateselect.equals("6")){
	docapprovedatefrom = TimeUtil.getDateByOption(docapprovedateselect,"0");
	docapprovedateto = TimeUtil.getDateByOption(docapprovedateselect,"1");
}

String replaydoccountfrom = Util.null2String(request.getParameter("replaydoccountfrom"));
String replaydoccountto = Util.null2String(request.getParameter("replaydoccountto"));
String accessorycountfrom = Util.null2String(request.getParameter("accessorycountfrom"));
String accessorycountto = Util.null2String(request.getParameter("accessorycountto"));

String contentname = Util.null2String(request.getParameter("contentname"));

String doclastmoduserid = Util.null2String(request.getParameter("doclastmoduserid"));
if(doclastmoduserid.equals("0")) doclastmoduserid="";
String docarchiveuserid = Util.null2String(request.getParameter("docarchiveuserid"));
if(docarchiveuserid.equals("0")) docarchiveuserid="";
String docapproveuserid = Util.null2String(request.getParameter("docapproveuserid"));
if(docapproveuserid.equals("0")) docapproveuserid="";
String assetid = Util.null2String(request.getParameter("assetid"));
if(assetid.equals("0")) assetid="";
String treeDocFieldId = Util.null2String(request.getParameter("treeDocFieldId")).replaceAll("%2C", ",");
if(treeDocFieldId.equals("0")) treeDocFieldId="";


String noRead = Util.null2String(request.getParameter("noRead"));
String dspreply = Util.null2String(request.getParameter("dspreply"));
String date2during = Util.null2String(request.getParameter("date2during"));
String pop_state = Util.null2String(request.getParameter("pop_state"));
Date newdate = new Date();
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
//orderBy
	String urlType = Util.null2String(request.getParameter("urlType"));
	boolean isRanking = (urlType.equals("2")||urlType.equals("1")||urlType.equals("3")||urlType.equals("4"));
	String orderBy = "";
	String extraCond = "";
	if(isNew.equals("yes")){
		noRead = "1";
	}
	if(urlType.equals("0")){//最新文档
		orderBy = "doccreatedate,doccreatetime";
		isNew = "yes";
		noRead = "1";
	}else if(urlType.equals("1")){//最多阅读
		orderBy = "sumReadCount";
		extraCond = " sumReadCount>0 ";
	}else if(urlType.equals("2")){//最多回复
		orderBy = "replaydoccount";
		extraCond = " replaydoccount>0 ";
	}else if(urlType.equals("3")){//评分最高
		orderBy = "sumMark";
		extraCond = " sumMark>0 ";
	}else if(urlType.equals("4")){//下载量最高
		orderBy = "sumDownloadCount";
		if(RecordSet.getDBType().equals("oracle")){
			//extraCond = "nvl((select count(*) from downloadLog where docid=t1.id),0)>0";
		}else{
			//extraCond = "isnull((select count(*) from downloadLog where docid=t1.id),0)>0";
		}
		extraCond = "exists (select 1 from downloadLog where docid = t1.id)";
		//extraCond = " sumDownloadCount>0 ";
	}else if(urlType.equals("5")){//我的文档
		doccreaterid = user.getUID()+"";
		ownerid = user.getUID()+"";
		orderBy = "doclastmoddate,doclastmodtime";
	}else if(urlType.equals("6")){//查询文档
		orderBy = "doclastmoddate,doclastmodtime";
	}else{
		orderBy = "doclastmoddate,doclastmodtime";
	}    
//set DocSearchComInfo values------------------------------------
String docsubject_rep = docsubject.replaceAll("'","''");
docsubject_rep = docsubject_rep.replaceAll("\"","&quot;");
DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.setContentname(contentname);
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
if(urlType.equals("5")){
	if(docstatus.equals("")){
		extraCond = " docstatus!=8 and docstatus!=9";
	}else{
		DocSearchComInfo.addDocstatus(docstatus);
	}
}else{
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
	    if(frompage.equals("") && !urlType.equals("1")&& !urlType.equals("2")&& !urlType.equals("3")&& !urlType.equals("4")&& !urlType.equals("0"))
	        DocSearchComInfo.addDocstatus("7");
	}
}

DocSearchComInfo.setKeyword(keyword);
DocSearchComInfo.setOwnerid(ownerid);
DocSearchComInfo.setDocSubDocstatus(docstatus);


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
               
                if(tmpopt.equals("1"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
                if(tmpopt.equals("2"))	sqlwhere+=" not like '%"+tmpvalue +"%'  or "+temOwner+"."+tmpcolname+" is null";
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
                if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" or "+temOwner+"."+tmpcolname+" is null";
            }
            else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65")&& !tmptype.equals("162")&& !tmptype.equals("278")&& !tmptype.equals("194") && !tmptype.equals("57")  ){
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
                    if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"'  or "+temOwner+"."+tmpcolname+" is null";

                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){
                    if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"'  or "+temOwner+"."+tmpcolname+" is null";
                }
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65")|| tmptype.equals("162")|| tmptype.equals("278")|| tmptype.equals("194")|| tmptype.equals("57")  )){       // 对多人力资源，多客户，多文档的处理
                //sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
				if(isoracle){
					sqlwhere += "and (','||"+temOwner+"."+tmpcolname+"||',' ";
				}else{
					sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
				}
                if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
                if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%'  or "+temOwner+"."+tmpcolname+" is null";
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

	
%>


<%

String sqlWhere="";
//查询设置
String userid=user.getUID()+"" ;
//String loginType = user.getLogintype() ;
String userSeclevel = user.getSeclevel() ;
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
char flag=2;
boolean shownewicon=false;
//String dspreply = DocSearchComInfo.getContainreply() ;
String tabletype="checkbox";
String browser="";



//String isreply=Util.null2String(request.getParameter("isreply"));
//String frompage=Util.null2String(request.getParameter("frompage"));
//String doccreatedatefrom=Util.null2String(request.getParameter("doccreatedatefrom"));
//String doccreatedateto=Util.null2String(request.getParameter("doccreatedateto"));
//String docpublishtype=Util.null2String(request.getParameter("docpublishtype"));

/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
//int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
//int showtype = Util.getIntValue(request.getParameter("showtype"),0);
//int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);//
//int infoId = Util.getIntValue(request.getParameter("infoId"),0);

String selectedContent = "";
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectedContent = info.getSelectedContent();
}else{
	selectedContent = Util.null2String(request.getParameter("selectedContent"));
}
String inMainCategoryStr = "";
String inSubCategoryStr = "";
String[] docCategoryArray = null;
String  advanids="";

if(fromAdvancedMenu==1){
	docCategoryArray = Util.TokenizerString2(selectedContent,"C");	
	if(docCategoryArray!=null&&docCategoryArray.length>0){
		for(int k=0;k<docCategoryArray.length;k++){
			if(advanids.equals("")){
			   advanids=docCategoryArray[k];
			}else{
			  advanids=advanids+","+docCategoryArray[k];
			
			}						
		}		

    }
}

int showTitle = Util.getIntValue(request.getParameter("showTitle"),0);
int showDocs = Util.getIntValue(request.getParameter("showDocs"),0);
//String maincategory=Util.null2String(request.getParameter("maincategory"));
//String subcategory=Util.null2String(request.getParameter("subcategory"));
//String seccategory=Util.null2String(request.getParameter("seccategory"));
String tseccategory = seccategory;
String tsubcategory = subcategory;
String tmaincategory = maincategory;
String tmaincategoryname = "";
String tsubcategoryname ="";
String tseccategoryname="";
if(!"".equals(tseccategory)) tsubcategory = SecCategoryComInfo.getSubCategoryid(tseccategory);
if(!"".equals(tsubcategory)) tmaincategory = SubCategoryComInfo.getMainCategoryid(tsubcategory);



/* edited end */

/* added by yinshun.xu 2006-07-19 按组织结构显示 */
//String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
//String departmentid=Util.null2String(request.getParameter("departmentid"));

/* added end */

/* added by fanggsh 2006-07-24 按树状字段显示 */

/* added end */






String tableString = "";
String tableInfo = "";


boolean isUsedCustomSearch = "true".equals(Util.null2String(request.getParameter("isUsedCustomSearch")))?true:false;

if(DocSearchComInfo.getSeccategory()!=null&&!"".equals(DocSearchComInfo.getSeccategory())){
    isUsedCustomSearch = SecCategoryComInfo.isUsedCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
}
String strDummy=""; 
String strDummyEn="";
if(isUsedCustomSearch && urlType.equals("6")){
	
    String seccategoryid =  Util.null2String(request.getParameter("seccategory"));
    DocSearchComInfo.setSeccategory(seccategoryid);
    //backFields
	String backFields = "";
	//backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname");
	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	  if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		   belongtoids+=","+user.getUID();
	  outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid in("+belongtoids+") ),0) as readCount";
	  
	  }

	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	    if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			 belongtoids+=","+user.getUID();
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid in("+belongtoids+") ),0) as readCount";
		
		}
	}
	if(isRanking){
		outFields += ", 1 as ranking__";
	}
	backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.docvestin,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname,t1.doccreaterid");
	if((Util.getIntValue(DocSearchComInfo.getDate2during(),0)>0&&Util.getIntValue(DocSearchComInfo.getDate2during(),0)<37)||!UserDefaultManager.getHasoperate().equals("1"))
    {
    	backFields = getFilterBackFields(backFields,"t1.id,t1.seccategory,t1.docvestin,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid");
    }
    if(urlType.equals("4")){
		if(RecordSet.getDBType().equals("oracle")){
			backFields += ",nvl((select count(*) from downloadLog where docid=t1.id),0) as sumDownloadCount";
		}else{
			backFields += ",isnull((select count(*) from downloadLog where docid=t1.id),0) as sumDownloadCount";
		}
	}
    
	
	//where
	
	//String isNew
	isNew = DocSearchComInfo.getIsNew() ;
	
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	
	String detailwhere = " and " + DocSearchComInfo.FormatSQLSearch2(user.getLanguage());
	
	if(Util.getIntValue(ownerdepartmentid,0)>0){
		whereclause =whereclause+" and hr.id = t1.ownerid and hr.departmentid = " + ownerdepartmentid;
	}
	
	if(Util.getIntValue(creatersubcompanyid,0)>0){
		whereclause =whereclause+" and hr.id = t1.doccreaterid and hr.subcompanyid1 = " + creatersubcompanyid;
	}
	if(Util.getIntValue(creatersubcompanyid,0)<0||Util.getIntValue(vdepartmentid,0)<0){
		whereclause =whereclause+" and hr.id = t1.doccreaterid";

	}
	if(Util.getIntValue(ownersubcompanyid,0)>0){
		whereclause =whereclause+" and hr.id = t1.ownerid and hr.subcompanyid1 = " + ownersubcompanyid;
	}
	if(Util.getIntValue(ownersubcompanyid,0)<0||Util.getIntValue(ownerdepartmentid,0)<0){
		whereclause =whereclause+" and hr.id = t1.ownerid ";
	}
	
	if(!frompage.equals("")){
	 whereclause=whereclause+" and t1.docstatus in ('1','2','5') and t1.usertype=1";
	 detailwhere=detailwhere+" and t1.docstatus in ('1','2','5') and t1.usertype=1";
	 if(isreply.equals("0")){
	   whereclause+=" and (isreply='' or isreply is null) ";
	   detailwhere+=" and (t1.isreply='' or t1.isreply is null) ";
	 }
	 if(!doccreatedatefrom.equals("")){
	   whereclause+=" and doccreatedate>='"+doccreatedatefrom+"' ";
	   detailwhere+=" and t1.doccreatedate>='"+doccreatedatefrom+"' ";
	 }
     if(!doccreatedateto.equals("")){
       whereclause+=" and doccreatedate<='"+doccreatedateto+"' ";
       detailwhere+=" and t1.doccreatedate<='"+doccreatedateto+"' ";
     }
     if(docpublishtype.equals("1")){
      whereclause+=" and (docpublishtype='1'  or docpublishtype='' or docpublishtype is null ) ";
      detailwhere+=" and (t1.docpublishtype='1'  or t1.docpublishtype='' or t1.docpublishtype is null ) ";
     }
     if(docpublishtype.equals("2")||docpublishtype.equals("3")){
      whereclause+=" and docpublishtype="+docpublishtype;
      detailwhere+=" and t1.docpublishtype="+docpublishtype;
     }	 
	}
	/* added by wdl 2006-08-28 不显示历史版本 */
		if(!(urlType.equals("7")||urlType.equals("8")||urlType.equals("9"))){
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	detailwhere+=" and (t1.ishistory is null or t1.ishistory = 0) ";
		}
	/* added end */
	if(offical.equals("1")){
		String _sql = "";
		String secids = "";
		if(officalType==1){
			 _sql = "select distinct secCategoryId from Workflow_DocProp where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3))";
		}else if(officalType==2){
			_sql = "select distinct secCategoryId from Workflow_DocProp where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (2))";
		}
		RecordSet.executeSql(_sql);
		while(RecordSet.next()){
			if(secids.equals("")){
				secids = Util.null2String(RecordSet.getString(1));
			}else{
				secids = secids + ","+Util.null2String(RecordSet.getString(1));
			}
		}
		String defaultview=null;
		ArrayList defaultviewList=null;
		String defaultcategory=null;
		if(officalType==1){
			 _sql = "select distinct defaultview from workflow_createdoc where status='1' and wfstatus='1' and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3))";
		}else if(officalType==2){
			_sql = "select distinct defaultview from workflow_createdoc where status='1' and wfstatus='1' and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (2))";
		}
		RecordSet.executeSql(_sql);
		while(RecordSet.next()){
			defaultview=Util.null2String(RecordSet.getString(1));
			defaultviewList=Util.TokenizerString(defaultview,"||");
			if(defaultviewList!=null&&defaultviewList.size()>0){
				defaultcategory=""+defaultviewList.get(2);
			}
			if(!defaultcategory.trim().equals("")&&((","+secids+",").indexOf(","+defaultcategory+",")==-1)){
				if(secids.equals("")){
					secids = defaultcategory;
				}else{
					secids = secids + ","+defaultcategory;
				}
			}
		}
		if(officalType==1){
			 _sql = "select doccategory from workflow_selectitem where fieldid in(select flowdoccatfield  from workflow_createdoc where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3)))";
		}else if(officalType==2){
			_sql = "select doccategory from workflow_selectitem where fieldid in(select flowdoccatfield  from workflow_createdoc where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType =2))";
		}
		RecordSet.executeSql(_sql);
		while(RecordSet.next()){
			defaultview=Util.null2String(RecordSet.getString(1));
			defaultviewList=Util.TokenizerString(defaultview,",");
			if(defaultviewList!=null&&defaultviewList.size()>0){
				if(defaultviewList.size() == 1){
					defaultcategory=""+defaultviewList.get(0);
				}else{
					defaultcategory=""+defaultviewList.get(2);
				}
			}
			if(!defaultcategory.trim().equals("")&&((","+secids+",").indexOf(","+defaultcategory+",")==-1)){
				if(secids.equals("")){
					secids = defaultcategory;
				}else{
					secids = secids + ","+defaultcategory;
				}
			}
		}		
		secids = secids.replaceAll(",{2,}",",");
		if(secids.trim().equals("")){
			secids="-2";
		}
		whereclause += " and seccategory in ("+secids+")";
		detailwhere += " and t1.seccategory in ("+secids+")";
	}
	
	/* added by wdl 2006-06-13 left menu advanced menu */
	
	
		if((fromAdvancedMenu==1)&&!advanids.equals("")){
	  whereclause+=" and seccategory in (" + advanids + ") ";
	  detailwhere+=" and t1.seccategory in (" + advanids + ") ";
		}
	
	/* added end */
	//String tableInfo
	
	//tableInfo = "[<a href=\"/docs/search/DocSearch.jsp?from=docsubscribe\">"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"</a>]"+strDummy;
	//xTableToolBarList.set(0,"{text:'"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"',iconCls:'btn_rss',handler:function(){window.location = '/docs/search/DocSearch.jsp?from=docsubscribe'}}");
	
	//用于暂时屏蔽外部用户的订阅功能
	if (!"1".equals(loginType)){
	    tableInfo = "";
		xTableToolBarList.set(0,"");
	}
	
	
		
	
	whereclause += " and t1.id = tcm.docid ";
	
	
	
	
	
	sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);
	
	if(urlType.equals("0") || isNew.equalsIgnoreCase("yes")){
	 if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		  belongtoids+=","+user.getUID();
		sqlWhere += " and t1.doccreaterid not in( "+belongtoids+")";
		detailwhere += " and t1.doccreaterid not in( "+belongtoids+")";
	 }else{
	   sqlWhere += " and t1.doccreaterid <> "+user.getUID();
	   detailwhere += " and t1.doccreaterid <> "+user.getUID();
	 }
	}else if(urlType.equals("12")){//文档弹窗设置
		sqlWhere += " and t1.docextendname = 'html'";
		detailwhere += " and t1.docextendname = 'html'";
	}
	if(!extraCond.equals("")){
		sqlWhere += " and "+extraCond;
		detailwhere += " and "+extraCond;
	}
	
	String tables = "";
	if(!urlType.equals("11")&&!urlType.equals("7")&&!urlType.equals("99")){
	    if(useNewSearch){
	        tables = sharemanager.getShareListTableByUser("doc",user,detailwhere);
	    }else{
	        tables = sharemanager.getShareDetailTableByUser("doc",user);
	    }
	}
	
	//from
    String  sqlFrom = "DocDetail  t1 ";
    if(!urlType.equals("11")&&!urlType.equals("7")&&!urlType.equals("99")){
        sqlFrom += ","+tables+"  t2";
    }
    
    if(Util.getIntValue(ownerdepartmentid,0)>0|| Util.getIntValue(creatersubcompanyid,0)>0 || Util.getIntValue(ownersubcompanyid,0)>0){
        sqlFrom += " ,hrmresource hr";
    }
    if(Util.getIntValue(ownerdepartmentid,0)<0|| Util.getIntValue(creatersubcompanyid,0)<0|| Util.getIntValue(ownersubcompanyid,0)<0||Util.getIntValue(vdepartmentid,0)<0){
        sqlFrom += " ,(  select tv2.subcompanyid1 ,tv2.id,tv2.departmentid  from HrmResourceVirtual tv1,HrmResource tv2 where tv1.resourceid=tv2.id ";
        if(Util.getIntValue(vdepartmentid,0)<0){
         sqlFrom +=" and tv1.departmentid   = "+vdepartmentid;
        }
        if(Util.getIntValue(ownerdepartmentid,0)<0){
         sqlFrom +=" and tv1.departmentid   = "+ownerdepartmentid;
        }
        if(Util.getIntValue(creatersubcompanyid,0)<0){
         sqlFrom +=" and tv1.subcompanyid  = "+creatersubcompanyid;
        }
        if(Util.getIntValue(ownersubcompanyid,0)<0){
         sqlFrom +=" and tv1.subcompanyid  = "+ownersubcompanyid;
        }
         sqlFrom +=" ) hr ";
    }
    
    
    String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
    if(!strCustomSql.equals("")){
      sqlFrom += ", cus_fielddata tCustom ";
    }
    
    sqlFrom += ",(select ljt1.id as docid,ljt2.* from DocDetail ljt1 LEFT JOIN cus_fielddata ljt2 ON ljt1.id=ljt2.id and ljt2.scope='DocCustomFieldBySecCategory' and ljt2.scopeid="+DocSearchComInfo.getSeccategory()+") tcm";
	
	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";
	if(isRanking){
		colString += "<col labelid=\"19082\" text=\""+SystemEnv.getHtmlLabelName(19082,user.getLanguage())+"\" name=\"ranking__\" width=\"3%\"   align=\"center\" column=\"ranking__\"/>";
	}
	if(displayUsage==0){
		colString +="<col name=\"id\" width=\"3%\"   align=\"center\" text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"";
		if(!isRanking){
			colString += " orderkey=\"docextendname\"";
		}
		colString += "/>";
	}
	colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId90974\" otherpara=\""+userInfoForotherpara+"+column:doccreaterid+column:readCount+column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"";
	if(!isRanking){
		colString += " orderkey=\"docsubject\"";
	}
	colString += "/>";
	if (isNew.equals("yes")&&displayUsage==0) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是" 
	     
		tabletype="checkbox";
		tableInfo="";
		//xTableToolBarList.set(0,"");
		colString ="<col name=\"id\" width=\"3%\"   align=\"center\" text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"";
		if(!isRanking){
			colString += " orderkey=\"docextendname\"";
		}
		colString += "/>";
		colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew\" otherpara=\"column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"";
		if(!isRanking){
			colString += " orderkey=\"docsubject\"";
		}
		colString += "/>";
	}
	
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if(pagesize <2) pagesize=10;
	
	//operateString userType_userId_userSeclevel
 		String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
 		String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel+column:id";
 		String operateString = "";
 		if(!urlType.equals("99") && !urlType.equals("7")&&!urlType.equals("8") && !urlType.equals("9") && !urlType.equals("12")){
	 		if (true || UserDefaultManager.getHasoperate().equals("1")&&displayUsage==0) 
	 		{  
	 	 	   operateString= "<operates width=\"20%\">";
	 	       operateString+=" <popedom  transmethod=\"weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2\" otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomOtherpara2+"\"></popedom> ";
			   operateString+="     <operate href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"/docs/docs/DocEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:doMuliDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:doDocShare()\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>";
	 	       operateString+="     <operate href=\"javascript:doDocViewLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>";       
	 	       operateString+="</operates>";
	 	       
	 		}
 		}
	CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",Util.getIntValue(DocSearchComInfo.getSeccategory())); 
    SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(Util.getIntValue(DocSearchComInfo.getSeccategory()));
	RecordSet.executeSql("select * from DocSecCategoryCusSearch where secCategoryId = "+DocSearchComInfo.getSeccategory()+" order by viewindex");
	while(RecordSet.next()){
		int currId = RecordSet.getInt("id");
		int currDocPropertyId = RecordSet.getInt("docPropertyId");
		int currVisible = RecordSet.getInt("visible");
		
		int currType = Util.getIntValue(SecCategoryDocPropertiesComInfo.getType(currDocPropertyId+""));
		if(currType==1) continue;
		
		int currIsCustom = Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom(currDocPropertyId+""));
		
		int currLabelId = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
		String currCustomName = Util.null2String(SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+"",user.getLanguage()));
		
		String currName = (currCustomName.equals("")&&currLabelId>0)?SystemEnv.getHtmlLabelName(currLabelId, user.getLanguage()):currCustomName;
        
        if(currVisible==1&&displayUsage==0){
            if(currIsCustom==1){
                int tmpfieldid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getFieldId(currDocPropertyId+""));
                String tmpcustomName = SecCategoryDocPropertiesComInfo.getCustomName(currDocPropertyId+"",user.getLanguage());
                if ("oracle".equals(RecordSet.getDBType())){
                	backFields=getFilterBackFields(backFields,"tcm."+cfm.getFieldName(""+tmpfieldid));
                }else{
                	backFields=getFilterBackFields(backFields,"cast(tcm."+cfm.getFieldName(""+tmpfieldid)+" as varchar) as "+cfm.getFieldName(""+tmpfieldid));
                }
        	    colString +="<col width=\"10%\"  text=\""+tmpcustomName+"\" column=\""+cfm.getFieldName(""+tmpfieldid)+"\"   transmethod=\"weaver.docs.docs.CustomFieldSptmForDoc.getFieldShowName\" otherpara=\""+tmpfieldid+"+"+user.getLanguage()+"\"";
				if(!isRanking){
					colString += " orderkey=\""+cfm.getFieldName(""+tmpfieldid)+"\"";
				}
				colString += "/>";
            } else {
                if(currType==2){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docCode");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docCode\" ";
                	if(!isRanking){
						colString += " orderkey=\"docCode\"";
					}
					colString += "/>";
                } else if(currType==3){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docpublishtype");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPublicType\" otherpara=\""+user.getLanguage()+"\"";
                	if(!isRanking){
						colString += " orderkey=\"docpublishtype\"";
					}
					colString += "/>";
                } else if(currType==4){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docedition");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocVersion\"";
                	if(!isRanking){
						colString += " orderkey=\"docedition\"";
					}
					colString += "/>";
                } else if(currType==5){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docstatus");
            	    colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\" otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"";            	    
                	if(!isRanking){
						colString += " orderkey=\"docstatus\"";
					}
					colString += "/>";
                } else if(currType==6){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.maincategory");
            	    //colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"maincategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaincategory\"";
                	if(!isRanking){
					//	colString += " orderkey=\"maincategory\"";
					}
					//colString += "/>";
                } else if(currType==7){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.subcategory");
            	    //colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"subcategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubcategory\"";
                	if(!isRanking){
					//	colString += " orderkey=\"subcategory\"";
					}
					//colString += "/>";
                } else if(currType==8){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.seccategory");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"seccategory\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSeccategory\"";
                	if(!isRanking){
						colString += " orderkey=\"seccategory\"";
					}
					colString += "/>";
                } else if(currType==9){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docdepartmentid");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docdepartmentid\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDepartment\"";
              	    if(!isRanking){
						colString += " orderkey=\"docdepartmentid\"";
					}
					colString += "/>";
                } else if(currType==10){
                    
                    
                } else if(currType==11){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doclangurage");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclangurage\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocLangurage\"";
                	if(!isRanking){
						colString += " orderkey=\"doclangurage\"";
					}
					colString += "/>";
                } else if(currType==12){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.keyword");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"keyword\"";
                	if(!isRanking){
						colString += " orderkey=\"keyword\"";
					}
					colString += "/>";
                
                } else if(currType==13){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
                    backFields=getFilterBackFields(backFields,"t1.doccreatedate,t1.doccreatetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccreatedate\" ";
					if(!isRanking){
						colString += " orderkey=\"doccreatedate\"";
					}
					colString += "/>";
                } else if(currType==14){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doclastmoduserid,t1.doclastmoddate,t1.doclastmodtime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doclastmoddate\" ";
					if(!isRanking){
						colString += " orderkey=\"doclastmoddate,doclastmodtime\"";
					}
					colString += "/>";
                } else if(currType==15){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docapproveuserid,t1.docapprovedate,t1.docapprovetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docapprovedate\" ";
					if(!isRanking){
						colString += " orderkey=\"docapprovedate\"";
					}
					colString += "/>";
                } else if(currType==16){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docinvaluserid,t1.docinvaldate,t1.docinvaltime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docinvaldate\" ";
					if(!isRanking){
						colString += " orderkey=\"docinvaldate\"";
					}
					colString += "/>";
                } else if(currType==17){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.docarchiveuserid,t1.docarchivedate,t1.docarchivetime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"docarchivedate\" ";
					if(!isRanking){
						colString += " orderkey=\"docarchivedate\"";
					}
					colString += "/>";
                } else if(currType==18){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.doccanceluserid,t1.doccanceldate,t1.doccanceltime");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"doccanceldate\" ";
					if(!isRanking){
						colString += " orderkey=\"doccanceldate\"";
					}
					colString += "/>";
                } else if(currType==19){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.maindoc");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\" otherpara=\"column:maindoc+"+user.getLanguage()+"\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocMaindoc\"";
                	if(!isRanking){
						colString += " orderkey=\"maindoc\"";
					}
					colString += "/>";
                } else if(currType==20){
                    
                    
                } else if(currType==21){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.ownerid");
          	        colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"";
                	if(!isRanking){
						colString += " orderkey=\"ownerid\"";
					}
					colString += "/>";
                } else if(currType==22){
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.invalidationdate");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"invalidationdate\" ";
					if(!isRanking){
						colString += " orderkey=\"invalidationdate\"";
					}
					colString += "/>";
                }else if(currType==24){
                	int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
             	    
             	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"id\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDummyCategory\"";
					if(!isRanking){
						colString += " orderkey=\"id\"";
					}
					colString += "/>";
                }else if(currType==25){
                	
                    int tmplabelid = Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(currDocPropertyId+""));
            	    backFields=getFilterBackFields(backFields,"t1.canPrintedNum");
            	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(tmplabelid,user.getLanguage())+"\" column=\"canPrintedNum\" ";
					if(!isRanking){
						colString += " orderkey=\"canPrintedNum\"";
					}
					colString += "/>";
                }
                
                
            }
        }
    }
	
	
	
	
	
	
	
	//  用户自定义设置
	boolean dspcreater = false ;
	boolean dspcreatedate = false ;
	boolean dspmodifydate = false ;
	boolean dspdocid = false;
	boolean dspcategory = false ;
	boolean dspaccessorynum = false ;
	boolean dspreplynum = false ;
	
	if (UserDefaultManager.getHasdocid().equals("1")) {
	    dspdocid = true;
	}
	if (UserDefaultManager.getHasreplycount().equals("1")&&displayUsage==0) {  
	    dspreplynum = true ;
	    backFields=getFilterBackFields(backFields,"t1.replaydoccount");
	    colString +="<col width=\"6%\" display=\"false\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" labelid=\"18470\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";

	}
	if (UserDefaultManager.getHasaccessorycount().equals("1")&&displayUsage==0) {  
	    dspaccessorynum = true ;
	    backFields=getFilterBackFields(backFields,"t1.accessorycount");
	    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" labelid=\"2002\" column=\"accessorycount\" ";
		if(!isRanking){
			colString += " orderkey=\"accessorycount\"";
		}
		colString += "/>";
	}
	

	backFields=getFilterBackFields(backFields,"t1.sumReadCount,t1.docstatus,t1.sumMark");
	if(displayUsage==0) {
		colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" labelid=\"18469\" column=\"sumReadCount\" ";
		if(!isRanking){
			colString += " orderkey=\"sumReadCount\"";
		}
		colString += "/>";
		colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" labelid=\"15663\" column=\"sumMark\" ";
		if(!isRanking){
			colString += " orderkey=\"sumMark\"";
		}
		colString += "/>";
	}
	
	
	if(backFields.startsWith(",")) backFields=backFields.substring(1);
	if(backFields.endsWith(",")) backFields=backFields.substring(0,backFields.length()-1);
	
	
		
	//默认为按文档创建日期排序所以,必须要有这个字段
	//if (backFields.indexOf("doclastmoddate")==-1) {
	//    backFields+=",doclastmoddate";
	//}
	
	
	//eg. sqlwhere: where   docstatus in ('1','2','5')  and seccategory in (1033,1035,1036,1037)  and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.docid and t2.userid=67 and t2.usertype=1 
	if (isNew.equals("yes")) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是"      
	    primarykey="t1.id";
	    if ("oracle".equals(RecordSet.getDBType())) {    
		    //sqlFrom=" (select * from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";        
		    //sqlWhere="  b.docid is  null) table1";
		    //backFields="table1.*";
	    } else {
	        //sqlFrom="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";
		    //sqlWhere=" b.docid is  null";
		    //backFields="*";
	    }
	}
	
	if(displayUsage!=0){
		tabletype="thumbnail";
		browser="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"docId\" linkvaluecolumn=\"id\" />";
	}
	//用于暂时屏蔽外部用户的文档列表的多选框
	if (!"1".equals(loginType)){
		if("checkbox".equals(tabletype)){
			tabletype="checkbox";
		}else if("thumbnail".equals(tabletype)){
			tabletype="thumbnailNoCheck";
		}	
	}
	if(offical.equals("1")){
		tabletype = "officalDoc";
	}
	if(tabletype.equals("thumbnail")||tabletype.equals("thumbnailNoCheck")||tabletype.equals("officalDoc")){
		colString = "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" labelid=\"1341\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName1\"/>";
		if(tabletype.equals("officalDoc")){
			colString += "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(26609,user.getLanguage())+"\" labelid=\"26609\" column=\"id\" otherpara=\"column:seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNumber\"/>";
			colString += "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(26608,user.getLanguage())+"\" labelid=\"26608\" column=\"id\" otherpara=\"column:seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIsuser\"/>";
		}
	}
	//String tableString
	tableString="<table pageId=\""+PageIdConst.getPageId(urlType)+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.getPageId(urlType),user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\"  cssHandler=\"com.weaver.cssRenderHandler.doc.CheckboxColorRender\">";
	//String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
 	//String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel+column:id";
 	String popedomParam = popedomOtherpara+"+"+popedomOtherpara2;
	//tableString += "<checkboxpopedom showmethod=\"weaver.general.KnowledgeTransMethod.getDocCheckBox\" popedompara=\""+popedomParam+"\"  id=\"checkbox\" />"; //复选框全部默认显示，勾选后的操作权限在右键菜单中有判断
	tableString+=browser;
	outFields += ","+user.getUID() + " as currentuserid,"+loginType+" as currentusertype";
    if(isRanking){
		outFields += ", 1 as ranking__";
	}
    tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<head>"+colString+"</head>";
    tableString+=operateString;
    tableString+="</table>";  
    
    xTableSql.setBackfields(backFields);
    xTableSql.setOutfields(outFields);
	xTableSql.setPageSize(pagesize);
	xTableSql.setSqlform(sqlFrom);
	xTableSql.setSqlwhere(sqlWhere);
	xTableSql.setSqlgroupby("");
	xTableSql.setSqlprimarykey(primarykey);
	xTableSql.setSqlisdistinct("false");
	xTableSql.setDir(TableConst.DESC);
	xTableSql.setSort(orderBy); 

	TableSql xTableSql_2=new TableSql();
	xTableSql_2.setBackfields(backFields);
	xTableSql_2.setOutfields(outFields);
	xTableSql_2.setSqlwhere(sqlWhere);
	session.setAttribute(sessionId+"_sql",xTableSql_2);
      
} else {
	//from
	
	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	 if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
	  belongtoids+=","+user.getUID();
	 outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid in("+belongtoids+") ),0) as readCount";
	 }
	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	    if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			 belongtoids+=","+user.getUID();
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid in("+belongtoids+") ),0) as readCount";
		
		}
	}
	if(isRanking){
		outFields += ", 1 as ranking__";
	}
	//backFields
	String backFields="t1.id,t1.seccategory,t1.docvestin,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid,";
	if(!urlType.equals("11")&&!urlType.equals("7")&&!urlType.equals("99")){
		backFields += "t2.sharelevel,";
	}
	//from
	if((Util.getIntValue(DocSearchComInfo.getDate2during(),0)>0&&Util.getIntValue(DocSearchComInfo.getDate2during(),0)<37)||!UserDefaultManager.getHasoperate().equals("1"))
    {
		backFields="t1.id,t1.seccategory,t1.docvestin,t1.doclastmoddate,t1.doclastmodtime,t1.docsubject,t1.docextendname,t1.doccreaterid,";
    }
    if(urlType.equals("4")){
		if(RecordSet.getDBType().equals("oracle")){
			backFields += "nvl((select count(*) from downloadLog where docid=t1.id),0) as sumDownloadCount,";
		}else{
			backFields += "isnull((select count(*) from downloadLog where docid=t1.id),0) as sumDownloadCount,";
		}
	}
	
	//where
	
	
	
	//String isNew
	isNew = DocSearchComInfo.getIsNew() ;
	
	String detailwhere = " and " + DocSearchComInfo.FormatSQLSearch2(user.getLanguage());
	
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	if(urlType.equals("11")||urlType.equals("7")||urlType.equals("99")){
		whereclause = " where " + DocSearchComInfo.FormatSQLSearchSharing(user.getLanguage()) ;
		if(srcsecid>0){
		whereclause+=" and seccategory in("+srcsecid+")";
		detailwhere+=" and seccategory in("+srcsecid+")";
		}
	} 
	
	if(!frompage.equals("")){
	 whereclause=whereclause+" and t1.docstatus in ('1','2','5') and t1.usertype=1 ";
	 if(isreply.equals("0")){
	   whereclause+=" and (isreply='' or isreply is null) ";
	   detailwhere+=" and (isreply='' or isreply is null) ";
	 }
	 if(!doccreatedatefrom.equals("")){
	   whereclause+=" and doccreatedate>='"+doccreatedatefrom+"' ";
	   detailwhere+=" and doccreatedate>='"+doccreatedatefrom+"' ";
	 }
     if(!doccreatedateto.equals("")){
       whereclause+=" and doccreatedate<='"+doccreatedateto+"' ";
       detailwhere+=" and doccreatedate<='"+doccreatedateto+"' ";
     }
     if(docpublishtype.equals("1")){
      whereclause+=" and (docpublishtype='1'  or docpublishtype='' or docpublishtype is null ) ";
      detailwhere+=" and (docpublishtype='1'  or docpublishtype='' or docpublishtype is null ) ";
     }
     if(docpublishtype.equals("2")||docpublishtype.equals("3")){
      whereclause+=" and docpublishtype="+docpublishtype;
      detailwhere+=" and docpublishtype="+docpublishtype;
     }	 
	}
	
	if(Util.getIntValue(ownerdepartmentid,0)>0){
		whereclause =whereclause+" and hr.id = t1.ownerid and hr.departmentid = " + ownerdepartmentid;
	}	
	if(Util.getIntValue(creatersubcompanyid,0)>0){
		whereclause =whereclause+" and hr.id = t1.doccreaterid and hr.subcompanyid1 = " + creatersubcompanyid;
	}
	if(Util.getIntValue(creatersubcompanyid,0)<0||Util.getIntValue(vdepartmentid,0)<0){
		whereclause =whereclause+" and hr.id = t1.doccreaterid";
	}
	
	if(Util.getIntValue(ownersubcompanyid,0)>0){
		whereclause =whereclause+" and hr.id = t1.ownerid and hr.subcompanyid1 = " + ownersubcompanyid;
	}
	if(Util.getIntValue(ownersubcompanyid,0)<0||Util.getIntValue(ownerdepartmentid,0)<0){
		whereclause =whereclause+" and hr.id = t1.ownerid ";
	}
	
	
	/* added by wdl 2006-08-28 不显示历史版本 */
		if(!(urlType.equals("7")||urlType.equals("8")||urlType.equals("9"))){
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	detailwhere+=" and (ishistory is null or ishistory = 0) ";
		}
	/* added end */
	
	if(offical.equals("1")){
		String _sql = "";
		String secids = "";
		if(officalType==1){
			 _sql = "select distinct secCategoryId from Workflow_DocProp where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3))";
		}else if(officalType==2){
			_sql = "select distinct secCategoryId from Workflow_DocProp where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (2))";
		}
		RecordSet.executeSql(_sql);
		while(RecordSet.next()){
			if(secids.equals("")){
				secids = Util.null2String(RecordSet.getString(1));
			}else{
				secids = secids + ","+Util.null2String(RecordSet.getString(1));
			}
		}
		String defaultview=null;
		ArrayList defaultviewList=null;
		String defaultcategory=null;
		if(officalType==1){
			 _sql = "select distinct defaultview from workflow_createdoc where status='1' and wfstatus='1' and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3))";
		}else if(officalType==2){
			_sql = "select distinct defaultview from workflow_createdoc where status='1' and wfstatus='1' and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (2))";
		}
		RecordSet.executeSql(_sql);
		while(RecordSet.next()){
			defaultview=Util.null2String(RecordSet.getString(1));
			defaultviewList=Util.TokenizerString(defaultview,"||");
			if(defaultviewList!=null&&defaultviewList.size()>0){
				defaultcategory=""+defaultviewList.get(2);
			}
			if(!defaultcategory.trim().equals("")&&((","+secids+",").indexOf(","+defaultcategory+",")==-1)){
				if(secids.equals("")){
					secids = defaultcategory;
				}else{
					secids = secids + ","+defaultcategory;
				}
			}
		}
		if(officalType==1){
			 _sql = "select doccategory from workflow_selectitem where fieldid in(select flowdoccatfield  from workflow_createdoc where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3)))";
		}else if(officalType==2){
			_sql = "select doccategory from workflow_selectitem where fieldid in(select flowdoccatfield  from workflow_createdoc where workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType =2))";
		}
		RecordSet.executeSql(_sql);
		
		while(RecordSet.next()){
			defaultview=Util.null2String(RecordSet.getString(1));
			defaultviewList=Util.TokenizerString(defaultview,",");
			if(defaultviewList!=null&&defaultviewList.size()>0){
				if(defaultviewList.size() == 1){
					defaultcategory=""+defaultviewList.get(0);
				}else{
					defaultcategory=""+defaultviewList.get(2);
				}
			}
			if(!defaultcategory.trim().equals("")&&((","+secids+",").indexOf(","+defaultcategory+",")==-1)){
				if(secids.equals("")){
					secids = defaultcategory;
				}else{
					secids = secids + ","+defaultcategory;
				}
			}
		}		
		secids = secids.replaceAll(",{2,}",",");
		if(secids.trim().equals("")){
			secids="-2";
		}
		whereclause += " and seccategory in ("+secids+")";
		detailwhere += " and seccategory in ("+secids+")";
	}
	
	if(urlType.equals("10")){//批量共享
		whereclause+=" and t2.sharelevel=3 ";
		whereclause+=" and exists(select 1 from DocSecCategory where DocSecCategory.id=t1.secCategory and DocSecCategory.shareable='1') ";	
	}
	
	/* added by wdl 2006-06-13 left menu advanced menu */
	if((fromAdvancedMenu==1)&&!advanids.equals("")){
	  whereclause+=" and seccategory in (" + advanids + ") ";
	detailwhere+=" and seccategory in (" + advanids + ") ";
	}
	/* added end */
	
	
	//String tableInfo
	
	//tableInfo = "[<a href=\"/docs/search/DocSearch.jsp?from=docsubscribe\">"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"</a>]"+strDummy;
	//xTableToolBarList.set(0,"{text:'"+SystemEnv.getHtmlLabelName(21828,user.getLanguage())+"',iconCls:'btn_rss',handler:function(){window.location = '/docs/search/DocSearch.jsp?from=docsubscribe'}}");
	
	
	
	//用于暂时屏蔽外部用户的订阅功能
	if (!"1".equals(loginType)){
	    tableInfo = "";
	    xTableToolBarList.set(0,"");
	}
	sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);
	if(urlType.equals("11")||urlType.equals("7")||urlType.equals("99")){
		sqlWhere = whereclause;
	}
	if(urlType.equals("0") || isNew.equalsIgnoreCase("yes")){
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			 belongtoids+=","+user.getUID();
		sqlWhere += " and t1.doccreaterid not in( "+belongtoids+")";
		detailwhere += " and t1.doccreaterid not in( "+belongtoids+")";
		}else{
		sqlWhere += " and t1.doccreaterid <> "+user.getUID();
		detailwhere += " and t1.doccreaterid <> "+user.getUID();
		}
	}
	if(!extraCond.equals("")){
		sqlWhere += " and "+extraCond;
		detailwhere += " and "+extraCond;
	}
	
	
	String tables = "";
    if(!urlType.equals("11")&&!urlType.equals("7")&&!urlType.equals("99")){
        if(useNewSearch){
            tables = sharemanager.getShareListTableByUser("doc",user,detailwhere);
        }else{
            tables = sharemanager.getShareDetailTableByUser("doc",user);
        }
    }
	
	String  sqlFrom = "DocDetail  t1 ";
    if(!urlType.equals("11")&&!urlType.equals("7")&&!urlType.equals("99")){
        sqlFrom += ","+tables+"  t2";
    }
    if(Util.getIntValue(ownerdepartmentid,0)>0|| Util.getIntValue(creatersubcompanyid,0)>0 || Util.getIntValue(ownersubcompanyid,0)>0){
        sqlFrom += " ,hrmresource hr ";
    }
    if(Util.getIntValue(ownerdepartmentid,0)<0|| Util.getIntValue(creatersubcompanyid,0)<0|| Util.getIntValue(ownersubcompanyid,0)<0||Util.getIntValue(vdepartmentid,0)<0){
        sqlFrom += " ,(  select tv2.subcompanyid1 ,tv2.id,tv2.departmentid  from HrmResourceVirtual tv1,HrmResource tv2 where tv1.resourceid=tv2.id ";
        if(Util.getIntValue(vdepartmentid,0)<0){
         sqlFrom +=" and tv1.departmentid   = "+vdepartmentid;
        }
        if(Util.getIntValue(ownerdepartmentid,0)<0){
         sqlFrom +=" and tv1.departmentid   = "+ownerdepartmentid;
        }
        if(Util.getIntValue(creatersubcompanyid,0)<0){
         sqlFrom +=" and tv1.subcompanyid  = "+creatersubcompanyid;
        }
        if(Util.getIntValue(ownersubcompanyid,0)<0){
         sqlFrom +=" and tv1.subcompanyid  = "+ownersubcompanyid;
        }
         sqlFrom +=" ) hr ";
    }
    String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
    if(!strCustomSql.equals("")){
      sqlFrom += ", cus_fielddata tCustom ";
    }
	
	
	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";
	if(isRanking){
		colString += "<col labelid=\"19082\" text=\""+SystemEnv.getHtmlLabelName(19082,user.getLanguage())+"\" name=\"ranking__\" width=\"3%\"   align=\"center\" column=\"ranking__\"/>";
	}
	//orderBy
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if(pagesize <2) pagesize=10;
	
	//operateString userType_userId_userSeclevel
	String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
	String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel+column:id";
	String operateString = "";
	if(urlType.equals("7")){//订阅历史
		
	}else if(urlType.equals("8")){//订阅批准
		operateString= "<operates width=\"20%\">";
        operateString+=" <popedom async=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.getDocOpratePopedom\" otherpara=\""+urlType+"\"></popedom> ";
        operateString+="     <operate href=\"javascript:onAgree()\" text=\""+SystemEnv.getHtmlLabelName(142,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>";
        operateString+="     <operate href=\"javascript:onReject()\" text=\""+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>";
        operateString+="</operates>";
	}else if(urlType.equals("9")){//订阅收回
		operateString= "<operates width=\"20%\">";
        operateString+=" <popedom async=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.getDocOpratePopedom\"  otherpara=\""+urlType+"\"></popedom> ";
        operateString+="     <operate href=\"javascript:onGetBack()\" text=\""+SystemEnv.getHtmlLabelName(18666,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>";
        operateString+="</operates>";
	}else if(urlType.equals("12")){//文档弹窗设置
if(HrmUserVarify.checkUserRight("Docs:SetPopUp", user)){
		operateString= "<operates width=\"20%\">";
        operateString+=" <popedom async=\"false\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPouUpOperateNew\"  otherpara=\""+user.getLanguage()+"\"></popedom> ";
        operateString+="     <operate href=\"javascript:showDetailInfo()\" text=\""+SystemEnv.getHtmlLabelName(30747,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>";
        operateString+="</operates>";
}
	}else{
		if (!urlType.equals("99") && (true || UserDefaultManager.getHasoperate().equals("1")&&displayUsage==0)&&!urlType.equals("10") &&!urlType.equals("11")&&!urlType.equals("7")) 
		{	
		    operateString= "<operates width=\"20%\">";
	        operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForDoc.getDocOpratePopedom2\"  otherpara=\""+popedomOtherpara+"\" otherpara2=\""+popedomOtherpara2+"\"></popedom> ";
			operateString+="     <operate href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>";
	        operateString+="     <operate href=\"/docs/docs/DocEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>";
	        operateString+="     <operate href=\"javascript:doMuliDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>";
	        operateString+="     <operate href=\"javascript:doDocShare()\" text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>";
	        operateString+="     <operate href=\"javascript:doDocViewLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>";       
	        operateString+="</operates>";
	
		
		}
	}
	
	
		if(displayUsage==0){
			colString +="<col name=\"id\" width=\"3%\"   align=\"center\" text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"";
			if(!isRanking){
				colString += " orderkey=\"docextendname\"";
			}
			colString += "/>";
		}
	colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" labelid=\"58\" column=\"id\"  target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId90974\" otherpara=\""+userInfoForotherpara+"+column:doccreaterid+column:readCount+column:docsubject\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"";
		if(!isRanking){
			colString += " orderkey=\"docsubject\"";
		}
		colString += "/>";
		if (isNew.equals("yes")&&displayUsage==0) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是" 
		    
		     tabletype="checkbox";
		     tableInfo="";
		     //xTableToolBarList.set(0,"");
		     colString ="<col name=\"id\"  width=\"3%\"  align=\"center\" text=\""+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"";
			 if(!isRanking){
				colString += " orderkey=\"docextendname\"";
			}
			colString += "/>";
		     colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" labelid=\"58\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIconIsNew\" otherpara=\"column:docsubject\" ";
			 if(!isRanking){
				colString += " orderkey=\"docsubject\"";
			}
			colString += "/>";
		}
	
		
	
		
		//  用户自定义设置
		boolean dspcreater = false ;
		boolean dspcreatedate = false ;
		boolean dspmodifydate = false ;
		boolean dspdocid = false;
		boolean dspcategory = false ;
		boolean dspaccessorynum = false ;
		boolean dspreplynum = false ;
		
		
		if (UserDefaultManager.getHasdocid().equals("1")) {
		    dspdocid = true;    
		}
		if (true || displayUsage==0) {
		      dspcreater = true ;
		      backFields+="ownerid,t1.usertype,";
		      if(!urlType.equals("5")){
			      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" labelid=\"79\" column=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"";
				  if(!isRanking){
					colString += " orderkey=\"ownerid\"";
				  }
			}
			colString += "/>";
		}
		if (true ||displayUsage==0) { 
		    dspcreatedate = true ;
		    backFields+="doccreatedate,doccreatetime,";
		    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" labelid=\"722\" column=\"doccreatedate\"";
			if(!isRanking){
				colString += " orderkey=\"doccreatedate\"";
			}
			colString += "/>";
		}
		if (true || displayUsage==0) {
		    dspmodifydate = true ;
		    //backFields+="doclastmoddate,";
		    String display = "true";
		    if(urlType.equals("0")){
		    	display = "false";
		    }
		    colString +="<col display=\""+display+"\" width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" labelid=\"723\" column=\"doclastmoddate\" ";
			if(!isRanking){
				colString += " orderkey=\"doclastmoddate,doclastmodtime\"";
			}
			colString += "/>";
		}
		if (true || displayUsage==0) {   
		    dspcategory = true ;
		    //backFields+="seccategory,";
		    String display = "true";
		    if(urlType.equals("5") || urlType.equals("6") || urlType.equals("10")){
		    	display = "false";
		    	//display = UserDefaultManager.getHascategory().equals("1")?"true":"false";
		    }
		    colString +="<col pkey=\"allpath\" display=\""+display+"\" width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" labelid=\"92\" column=\"seccategory\" otherpara=\"column:docvestin+"+user.getUID()+"\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"";
			if(!isRanking){
				colString += " orderkey=\"seccategory\"";
			}
			colString += "/>";
		}
		if (true || displayUsage==0) {  
		    dspreplynum = true ;
		    backFields+="replaydoccount,";
		    String display = "true";
		    if(!urlType.equals("2")){
		    	display = "false";
		    	//display = UserDefaultManager.getHascategory().equals("1")?"true":"false";
		    }
		    colString +="<col display=\""+display+"\" width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" labelid=\"18470\" column=\"replaydoccount\" />";
		    //colString +="<col display=\"false\" width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" labelid=\"18470\" column=\"replaydoccount\" />";
			
		}
		if (true || displayUsage==0) {  
		    dspaccessorynum = true ;
		    backFields+="accessorycount,";
		    String display = "true";
		    if(urlType.equals("1") || urlType.equals("2") || urlType.equals("3")){
		    	display = "false";
		    	//display = UserDefaultManager.getHasaccessorycount().equals("1")?"true":"false";
		    }
		    colString +="<col display=\""+display+"\" width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" labelid=\"2002\" column=\"accessorycount\"";
			if(!isRanking){
				colString += " orderkey=\"accessorycount\"";
			}
			colString += "/>";
		}
		
		backFields+="sumReadCount,docstatus,sumMark";
		
		if(displayUsage==0) {
			if(urlType.equals("1")){
				colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" labelid=\"18469\" column=\"sumReadCount\" ";
				if(!isRanking){
					colString += " orderkey=\"sumReadCount\"";
				}
				colString += "/>";
			}
			if(urlType.equals("3")){
				colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" labelid=\"15663\" column=\"sumMark\" ";
				if(!isRanking){
					colString += " orderkey=\"sumMark\"";
				}
				colString += "/>";
			}
			if(urlType.equals("4")){
				colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(31623,user.getLanguage())+"\" labelid=\"31623\" column=\"sumDownloadCount\" ";
				if(!isRanking){
					colString += " orderkey=\"sumDownloadCount\"";
				}
				colString += "/>";
			}
			//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
			String display = "true";
		    if(urlType.equals("0") || urlType.equals("1") || urlType.equals("2") || urlType.equals("3") || urlType.equals("4")){
		    	display = "false";
		    }
			colString +="<col width=\"5%\" display=\""+display+"\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docStatus\" labelid=\"602\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\"  otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"";
			if(!isRanking){
				colString += " orderkey=\"docstatus\"";
			}
			colString += "/>";
		}
		
	//默认为按文档创建日期排序所以,必须要有这个字段
	//if (backFields.indexOf("doclastmoddate")==-1) {
	//    backFields+=",doclastmoddate";
	//}
	
	
	//eg. sqlwhere: where   docstatus in ('1','2','5')  and seccategory in (1033,1035,1036,1037)  and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.docid and t2.userid=67 and t2.usertype=1 
	if (isNew.equals("yes")) {  //isNew 表示的是不是察看的是自已没有看过的文档 "yes"表示"是"      
	    primarykey="t1.id";
	    if ("oracle".equals(RecordSet.getDBType())) {    
		   // sqlFrom=" (select * from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a ,(select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b ";        
		    //sqlWhere=" a.id=b.docid(+) and b.docid is  null) table1";
		    //backFields="table1.*";
	    } else {
	       // sqlFrom="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from docreadtag t3 where t3.userid="+userid+" and t3.usertype="+loginType+") b on a.id=b.docid ";
		   //// sqlWhere=" b.docid is  null";
		    //backFields="*";
	    }
	} 
	//虚拟目录
	if(showtype==3){
		primarykey="id";
	  
		sqlFrom="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   "+sqlWhere+" and  t1.doccreaterid!="+userid+") a left outer join (select docid from DocDummyDetail where catelogid="+Util.getIntValue(treeDocFieldId,0)+") b on a.id=b.docid ";
		sqlWhere=" b.docid is  null";
		backFields="*";
		tableInfo="";
		xTableToolBarList.set(0,"");
	}
	if(displayUsage!=0){
		tabletype="thumbnail";
		browser="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"docId\" linkvaluecolumn=\"id\" />";
	}
	//用于暂时屏蔽外部用户的文档列表的多选框
	if (!"1".equals(loginType)){
		if("checkbox".equals(tabletype)){
			tabletype="checkbox";
		}else if("thumbnail".equals(tabletype)){
			tabletype="thumbnailNoCheck";
		}	
	}
	if(offical.equals("1")){
		tabletype = "officalDoc";
	}
	if(tabletype.equals("thumbnail")||tabletype.equals("thumbnailNoCheck")||tabletype.equals("officalDoc")){
		colString = "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" labelid=\"1341\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName1\"/>";
		if(tabletype.equals("officalDoc")){
			colString += "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(26609,user.getLanguage())+"\" labelid=\"26609\" column=\"id\" otherpara=\"column:seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNumber\"/>";
			colString += "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(26608,user.getLanguage())+"\" labelid=\"26608\" column=\"id\" otherpara=\"column:seccategory\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIsuser\"/>";
		}
	}
	if(urlType.equals("7")){//订阅历史
		tabletype="none";
		sqlFrom += ",docsubscribe ds";
		sqlWhere += " and ds.docId = t1.id and ds.hrmId = "+user.getUID();
		orderBy="subscribedate";
		backFields ="ds.id,ds.docid,ds.subscribedate,ds.approvedate,ds.state,ds.ownerid,ds.othersubscribe,ds.subscribedesc,ds.ownerType";
		colString = //"<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
	        "<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" labelid=\"1341\" column=\"docid\" otherpara=\"column:state\" orderkey=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\"/>"+
			"<col width=\"4%\"  text=\""+SystemEnv.getHtmlLabelName(22186,user.getLanguage())+"\" labelid=\"22186\" column=\"docid\"  orderkey=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocVersion\"/>"+
	        "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18657,user.getLanguage())+"\" labelid=\"18657\" column=\"subscribedate\" orderkey=\"subscribedate\"/>"+
	        "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18658,user.getLanguage())+"\" labelid=\"18658\" column=\"approvedate\" orderkey=\"approvedate\"/>"+
	        "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" labelid=\"1929\" column=\"state\" orderkey=\"state\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubscribeStats\"  otherpara=\""+user.getLanguage()+"\"/>"+
	        "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(2094,user.getLanguage())+"\" labelid=\"2094\" column=\"ownerid\" orderkey=\"ownerid\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:ownerType\"/>"+
	        "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18663,user.getLanguage())+"\" labelid=\"18663\" column=\"othersubscribe\" otherpara=\"column:state\" orderkey=\"othersubscribe\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocSubscribes\"/>"+
	        "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(18664,user.getLanguage())+"\" labelid=\"18664\" column=\"subscribedesc\" orderkey=\"subscribedesc\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getSubscribedesc\" />";
	}else if(urlType.equals("12")){//文档弹窗设置
		if("2".equals(pop_state)){
		   sqlWhere=sqlWhere+" and t1.id in (select docid from DocPopUpInfo where pop_enddate < '"+CurrentDate+"' )";
		}
		if("1".equals(pop_state)){
		  sqlWhere=sqlWhere+" and t1.id in (select docid from DocPopUpInfo where pop_enddate >= '"+CurrentDate+"' )";
		}
		if("0".equals(pop_state)){
			sqlWhere=sqlWhere+" and t1.id not in (select docid from DocPopUpInfo)";
		}
		sqlWhere += " and t1.docextendname = 'html'";
	}else if(urlType.equals("8")){//订阅批准
		sqlFrom += ",docsubscribe ds";
		orderBy="subscribedate";
		backFields ="ds.id,ds.docid,ds.subscribedate,ds.approvedate,ds.searchcase,ds.othersubscribe,ds.subscribedesc,ds.hrmid, ds.subscribetype";
		sqlWhere += " and ds.docId = t1.id and ds.ownertype="+user.getLogintype()+" and ds.ownerId ="+user.getUID()+" and ds.state=1 ";
		browser = "<browser returncolumn=\"docid\"/>";
		colString = //"<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                    "<col width=\"27%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" labelid=\"1341\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"  target=\"_fullwindow\"   column=\"docid\" orderkey=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\"/>"+
                    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18657,user.getLanguage())+"\" labelid=\"18657\" column=\"subscribedate\" orderkey=\"subscribedate\"/>"+                                            
                    "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15774,user.getLanguage())+"\" labelid=\"15774\" column=\"searchcase\" orderkey=\"searchcase\"/>"+
                    "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18665,user.getLanguage())+"\" labelid=\"18665\" column=\"hrmid\" orderkey=\"hrmid\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:subscribetype\"/>"+
                    "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(18663,user.getLanguage())+"\" labelid=\"18663\" column=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.showOtherSubscribe\"/>"+
                    "<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(18664,user.getLanguage())+"\" labelid=\"18664\" column=\"subscribedesc\" orderkey=\"subscribedesc\"/>";
	}else if(urlType.equals("9")){//订阅收回
		sqlFrom += ",docsubscribe a";
		orderBy="subscribedate";
		primarykey = "a.id";
		sqlWhere += " and a.ownertype="+user.getLogintype()+" and a.ownerId ="+user.getUID()+" and a.state=2 and a.docId = t1.id ";
		backFields ="a.id,a.docid,a.subscribedate,a.approvedate,a.searchcase,a.othersubscribe,a.subscribedesc,a.hrmid, a.subscribetype,t1.id bid";
		browser = "<browser returncolumn=\"docid\"/>";
		colString = //"<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                    "<col width=\"27%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" labelid=\"1341\"  href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"  target=\"_fullwindow\" column=\"docid\" orderkey=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\"/>"+
                    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18657,user.getLanguage())+"\" labelid=\"18657\" column=\"approvedate\" orderkey=\"approvedate\"/>"+
                    "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18665,user.getLanguage())+"\" labelid=\"18665\" column=\"hrmid\" orderkey=\"hrmid\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:subscribetype\"/>"+
                    "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18664,user.getLanguage())+"\" labelid=\"18664\" column=\"subscribedesc\" orderkey=\"subscribedesc\"/>"+
                    "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15774,user.getLanguage())+"\" labelid=\"15774\" column=\"searchcase\" orderkey=\"searchcase\"/>"+
                    "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18663,user.getLanguage())+"\" labelid=\"18663\" column=\"othersubscribe\"  orderkey=\"othersubscribe\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNames\"/>";
	}else if(urlType.equals("11")){//批量调整共享
		
		String sharingsessionkey = "sqlsharing_" + user.getLoginid() ;	
		session.setAttribute(sharingsessionkey,sqlWhere);
		
	}else if(urlType.equals("16")){//文档中心
		
		String srcType = Util.null2String(request.getParameter("srcType"));
		String srcContent = Util.null2String(request.getParameter("srcContent")).replaceAll("%2C", ",");
		String srcReply = Util.null2String(request.getParameter("srcReply"));
		String negative = Util.null2String(request.getParameter("negative"));
		if(negative.equals("1")){
			sqlWhere += " and 1!=1";
		}else{
			if("1".equals(srcType)){
				String newsclause = "";
				dnm.resetParameter();
				dnm.setId(Util.getIntValue(srcContent));
				dnm.getDocNewsInfoById();
				newsclause = dnm.getNewsclause();
				dnm.closeStatement();
				String newslistclause = newsclause.trim();
				if (!newslistclause.equals(""))sqlWhere += " and (" + newslistclause+") ";
				sqlWhere += "  and docpublishtype in('2','3')";
			} else if("2".equals(srcType)){  //分目录
				if(",".equals(srcContent.substring(0,1))) srcContent=srcContent.substring(1);
				sqlWhere += "  and exists (select id from docseccategory where id = t1.seccategory and id in ("+srcContent+")) ";
			}else if("3".equals(srcType)){  //虚拟目录	
				if(",".equals(srcContent.substring(0,1))) srcContent=srcContent.substring(1);
				sqlWhere += "  and exists (select id from DocDummyDetail where docid = t1.id and catelogid in ("+srcContent+")) ";
			} else if("4".equals(srcType)){ //指定文档
				ArrayList docids=Util.TokenizerString(srcContent,",");
				String newDocids="";
				for(int i=0;i<docids.size();i++)	newDocids+=","+dm.getNewDocid((String)docids.get(i));
				if(newDocids.length()>0) newDocids=newDocids.substring(1);
				sqlWhere += " and t1.id in (" + newDocids+") ";
			}
		}
	}else if(urlType.equals("0")  &&  !"".equals(Util.null2String(request.getParameter("eid")))){
	
	    String srcType = Util.null2String(request.getParameter("srcType"));
		String srcContent = Util.null2String(request.getParameter("srcContent"));
		String srcReply = Util.null2String(request.getParameter("srcReply"));
		String negative = Util.null2String(request.getParameter("negative"));
     	Calendar now = Calendar.getInstance();

    	
        if (!"1".equals(srcReply))	sqlWhere+="  and (t1.isreply!=1 or  t1.isreply is null) ";

		if(negative.equals("1")){
			sqlWhere += " and 1!=1";
		}else{
			if("1".equals(srcType)){
				String newsclause = "";
				dnm.resetParameter();
				dnm.setId(Util.getIntValue(srcContent));
				dnm.getDocNewsInfoById();
				newsclause = dnm.getNewsclause();
				dnm.closeStatement();
				String newslistclause = newsclause.trim();
				if (!newslistclause.equals(""))sqlWhere += " and (" + newslistclause+") ";
				sqlWhere += "  and docpublishtype in('2','3')";
			} else if("2".equals(srcType)){  //分目录
				if(",".equals(srcContent.substring(0,1))) srcContent=srcContent.substring(1);
				sqlWhere += "  and seccategory!=0   and exists (select id from docseccategory where id = t1.seccategory and id in ("+srcContent+")) and not exists (select docid from docreadtag t3 where t3.userid="+user.getUID()+" and t3.usertype="+user.getLogintype()+" and t3.docid=t1.id)";
			}else if("3".equals(srcType)){  //虚拟目录	
				if(",".equals(srcContent.substring(0,1))) srcContent=srcContent.substring(1);
                sqlWhere += "  and seccategory!=0 ";
				sqlWhere += "  and exists (select id from DocDummyDetail where docid = t1.id and catelogid in ("+srcContent+"))  and  t1.doccreaterid!="+user.getUID()+" and not exists (select docid from docreadtag t3 where t3.userid="+user.getUID()+" and t3.usertype="+user.getLogintype()+" and t3.docid=t1.id) ";
        	} else if("7".equals(srcType)){ //所有文档
				sqlWhere = sqlWhere + " and seccategory!=0 and t1.id=t2.sourceid   and  t1.doccreaterid!="+user.getUID()+" and not exists (select docid from docreadtag t3 where t3.userid="+user.getUID()+" and t3.usertype="+user.getLogintype()+" and docid=t1.id ) ";
			}
		}
	
	}
	 //System.out.println("this is new"+urlType+"==="+!"".equals(Util.null2String(request.getParameter("eid"))));
	//String tableString
	tableString="<table pageId=\""+PageIdConst.getPageId(urlType)+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.getPageId(urlType),user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\"  cssHandler=\"com.weaver.cssRenderHandler.doc.CheckboxColorRender\">";
	String popedomParam =popedomOtherpara+"+"+popedomOtherpara2;
	if(urlType.equals("12")||urlType.equals("99")){//文档弹窗设置
		tableString += "<checkboxpopedom showmethod=\"weaver.general.KnowledgeTransMethod.getDocCheckBoxForPop\" popedompara=\"column:id\"  id=\"checkbox\" />";
	}else if(urlType.equals("0")||urlType.equals("6")||urlType.equals("8")||urlType.equals("9")||urlType.equals("10")||urlType.equals("11")||urlType.equals("14")){
		tableString += "";
	}else{
		tableString += "<checkboxpopedom showmethod=\"weaver.general.KnowledgeTransMethod.getDocCheckBox\" popedompara=\""+popedomParam+"\"  id=\"checkbox\" />";
	}
	tableString+=browser;
	outFields += ","+user.getUID() + " as currentuserid,"+loginType+" as currentusertype";
	if(isRanking){
		outFields += ", 1 as ranking__";
	}
	tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    if(urlType.equals("12")){
    	colString += "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(21886,user.getLanguage())+"\" column=\"id\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPouUpStatus\" otherpara=\""+user.getLanguage()+"\"/>";
    }
    tableString+="<head>"+colString+"</head>";
    if(!operateString.equals("")){
    	tableString+=operateString;
    }
    tableString+="</table>";    
	xTableSql.setBackfields(backFields);
	xTableSql.setOutfields(outFields);
	xTableSql.setPageSize(pagesize);
	xTableSql.setSqlform(sqlFrom);
	xTableSql.setSqlwhere(sqlWhere);
	xTableSql.setSqlgroupby("");
	xTableSql.setSqlprimarykey(primarykey);
	xTableSql.setSqlisdistinct("false");
	xTableSql.setDir(TableConst.DESC);
	xTableSql.setSort(orderBy);
	
	
	RecordSet.writeLog("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
	RecordSet.writeLog("sql=select " + backFields + " from " + sqlFrom + " " + sqlWhere + " order by " + orderBy.replace(","," desc,") + " desc");
	RecordSet.writeLog("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
	
	
	TableSql xTableSql_2=new TableSql();
	xTableSql_2.setBackfields(backFields);
	xTableSql_2.setSqlwhere(sqlWhere);
	xTableSql_2.setOutfields(outFields);
	session.setAttribute(sessionId+"_sql",xTableSql_2);   
}       
%>

					<% if(displayUsage==0){ 
							if(tabletype =="checkbox")
							{
								xTable.setTableGridType(TableConst.CHECKBOX);
							}
							else
							{
								xTable.setTableGridType(TableConst.NONE);
							}
							xTable.setTableNeedRowNumber(true);												
							xTable.setTableSql(xTableSql);
							xTable.setTableColumnList(xTableColumnList);
							xTable.setTableOperatePopedom(xTableOperatePopedom);
							xTable.setTableOperationList(xTableOperationList);
							xTable.setUser(user);
							xTable.setTableId("docsearch");
							String xTableToolBar = "";
							
							for(int i=0;i<xTableToolBarList.size();i++){
							
								if("".equals(xTableToolBarList.get(0))){
									break;
								}
								if(!"".equals(xTableToolBarList.get(i)))
									xTableToolBar+=xTableToolBarList.get(i).toString()+",'|',";
								
							}
							if(!xTableToolBar.equals("")){
								xTableToolBar = xTableToolBar.substring(0,xTableToolBar.length()-5);
							}
							xTableToolBar="["+xTableToolBar+"]";
							
							xTable.setTbar(xTableToolBar);
							
							
														
					%>		
										
					<% } else { %>
							
							
					<% }%> 
		



<%! 
private String getFilterBackFields(String oldbf,String addedbfs){
    String[] bfs = Util.TokenizerString2(addedbfs,",");
    String bf = "";
    for(int i=0;bfs!=null&&bfs.length>0&&i<bfs.length;i++){
        bf = bfs[i];
        if(oldbf.indexOf(","+bf+",")==-1){
            if(oldbf.endsWith(",")) oldbf+=bf+",";
            else oldbf+=","+bf+",";
        }
    }
    return oldbf;
}
%>

<%

if(displayUsage==0&&false){	
	out.println(xTable.toString2("_table")+"^^"+sessionId);
	
}else{
	session.setAttribute(sessionId,tableString);
	out.println("var tableString = '"+tableString+"'; var tableInfo = '"+tableInfo+"';var sessionId='"+sessionId+"';"); 
	
	//System.out.println("111111111111111111111111"); 
	//System.out.println("var tableString = '"+tableString+"'; var tableInfo = '"+tableInfo+"';"); 
	
}


return;
%>