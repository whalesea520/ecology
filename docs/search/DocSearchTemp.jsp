
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>

<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%
if(true){
	String isNew = Util.null2String(request.getParameter("isNew"));
	if(isNew.equalsIgnoreCase("yes")){
		response.sendRedirect("/docs/search/DocMain.jsp?urlType=0&"+request.getQueryString());
	}else{
		response.sendRedirect("/docs/search/DocMain.jsp?urlType=6&fromUrlType=1&"+request.getQueryString());
	}
	return;
}
boolean isoracle = RecordSet.getDBType().equalsIgnoreCase("oracle");
/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
int showtype = Util.getIntValue(request.getParameter("showtype"),0);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
/* edited end */
if(selectedContent!=null && selectedContent.startsWith("key_")){
		String menuid = selectedContent.substring(4);
		RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
		selectedContent = "";
		while(RecordSet.next()){
			String keyVal = RecordSet.getString(2);
			selectedContent += keyVal +"|";
		}
		if(selectedContent.indexOf("|")!=-1)
			selectedContent = selectedContent.substring(0,selectedContent.length()-1);
	}

String frompage=Util.null2String(request.getParameter("frompage"));//从哪个页面过来
////排序状态 0:默认排序 1:按文章分数排序  2:按文章打分人数排序 3:按文章的访问题排序
int sortState = Util.getIntValue(Util.null2String(request.getParameter("sortState")),0) ;

String docsubject = Util.null2String(request.getParameter("docsubject")) ;
String date2during = Util.null2String(request.getParameter("date2during")) ;
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
String ownerid=Util.null2String(request.getParameter("ownerid"));
if(ownerid.equals("0")) ownerid="";

String isreply=Util.null2String(request.getParameter("isreply"));
String isNew=Util.null2String(request.getParameter("isNew"));
String loginType=Util.null2String(request.getParameter("loginType"));
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
//默认不显示回复
if(dspreply.equals("")){
	dspreply="1";
}
//set DocSearchComInfo values------------------------------------

DocSearchComInfo.resetSearchInfo();

DocSearchComInfo.setContainreply(containreply);
DocSearchComInfo.setDocsubject(docsubject);
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
if ("1".equals(dspreply)) DocSearchComInfo.setContainreply("1");   //全部
else if("0".equals(dspreply)) DocSearchComInfo.setContainreply("0");   //非回复
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
String whereKeyStr="docsubject="+docsubject;
whereKeyStr+="^,^ownerid="+ownerid;
whereKeyStr+="^,^departmentid="+departmentid;
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

            whereKeyStr+="^,^tmpid="+tmpid;
            whereKeyStr+="~@~tmpcolname="+tmpcolname;
            whereKeyStr+="~@~tmphtmltype="+tmphtmltype;
            whereKeyStr+="~@~tmptype="+tmptype;
            whereKeyStr+="~@~tmpopt="+tmpopt;
            whereKeyStr+="~@~tmpvalue="+tmpvalue;
            whereKeyStr+="~@~tmpname="+tmpname;
            whereKeyStr+="~@~tmpopt1="+tmpopt1;
            whereKeyStr+="~@~tmpvalue1="+tmpvalue1;
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
            else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65")&& !tmptype.equals("162") ){
            	if(isoracle){
            		sqlwhere += "and ("+temOwner+"."+tmpcolname;
            	}else{
            		sqlwhere += "and (convert(varchar,"+temOwner+"."+tmpcolname+")";
            	}
            	
                if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
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
            else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65") || tmptype.equals("162"))){       // 对多人力资源，多客户，多文档的处理
				if(isoracle){
					sqlwhere += "and (','||"+temOwner+"."+tmpcolname+"||',' ";
				}else{
					sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
				}
                if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
                if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
            }

            sqlwhere +=") ";

        }

    }
	session.setAttribute(user.getUID()+"_"+seccategory+"whereKeyStr",whereKeyStr);

    //for debug
    //System.out.println(sqlwhere);
    if(!sqlwhere.equals("")){
        //去掉sql语句前面的and
        sqlwhere = sqlwhere.trim().substring(3);
        DocSearchComInfo.setCustomSqlWhere(sqlwhere);
    }else{
        DocSearchComInfo.setCustomSqlWhere("");
    }

//处理自定义条件 end


//一般的文档搜索会先显示文档的目录结构
if(request.getParameter("toView")!=null && Util.getIntValue(request.getParameter("toView"))==1){
    response.sendRedirect("DocSearchView.jsp?from="+request.getParameter("from")+"&date2during="+request.getParameter("date2during")+"&showtype="+showtype+"&docpublishtype="+docpublishtype+"&isreply="+isreply+"&frompage="+frompage+"&doccreatedatefrom="+doccreatedatefrom+"&doccreatedateto="+doccreatedateto+"&displayUsage="+displayUsage+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&isMainOrSub="+isMainOrSub+"&isNew="+isNew+"&ownerid="+ownerid+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&containreply="+containreply+"&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&dspreply="+dspreply);
    return;
}


//如果是从left页面过来的则不显示目录列表而直接显示文档
if (Util.null2String(request.getParameter("list")).equals("all") || !docid.equals("")) {
    response.sendRedirect("DocSearchView.jsp?from="+request.getParameter("from")+"&date2during="+request.getParameter("date2during")+"&showtype="+showtype+"&displayUsage="+displayUsage+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&isMainOrSub="+isMainOrSub+"&isNew="+isNew+"&ownerid="+ownerid+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&containreply="+containreply+"&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&dspreply="+dspreply);
    return ;
}
if (Util.null2String(request.getParameter("fromlogin")).equals("true")) {
    response.sendRedirect("DocSearchView1.jsp?from="+request.getParameter("from")+"&date2during="+request.getParameter("date2during")+"&displayUsage="+displayUsage+"&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&isMainOrSub="+isMainOrSub+"&isNew="+isNew+"&ownerid="+ownerid+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&containreply="+containreply+"&maincategory="+maincategory+"&subcategory="+subcategory+"&seccategory="+seccategory+"&dspreply="+dspreply);
    return ;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(356,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

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

<table class=ViewForm>
<%
String logintype = user.getLogintype();

String whereclause="  and (ishistory is null or ishistory = 0) and "+DocSearchComInfo.FormatSQLSearch(user.getLanguage());
String where2="  and (ishistory is null or ishistory = 0)  and "+DocSearchComInfo.FormatSQLSearch(user.getLanguage());


String sql="";
Calendar now = Calendar.getInstance();
String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+
	Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
int year=now.get(Calendar.YEAR);
int month=now.get(Calendar.MONTH);
int day=now.get(Calendar.DAY_OF_MONTH);
now.clear();
now.set(year,month,day-1);
String lastday=Util.add0(now.get(Calendar.YEAR), 4) +"-"+
	Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;

ArrayList maincounts=new ArrayList();
ArrayList newmaincounts=new ArrayList();
ArrayList subcounts=new ArrayList();
ArrayList newsubcounts=new ArrayList();
ArrayList mainids=new ArrayList();
ArrayList newmainids=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList newsubids=new ArrayList();
/*
TD8562 显示3层文档结构
*/
ArrayList seccounts=new ArrayList();
ArrayList newseccounts=new ArrayList();
ArrayList secids=new ArrayList();
ArrayList newsecids=new ArrayList();

if(logintype.equals("1")){
sql="select count(*) count,maincategory from DocDetail  t1, "+tables+"  t2 where  t1.id=t2.sourceid ";
sql+=whereclause;
sql+=" group by maincategory order by maincategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	mainids.add(RecordSet.getString("maincategory"));
	maincounts.add(RecordSet.getString("count"));
}

sql="select count(*) count,subcategory from DocDetail  t1, "+tables+"  t2 where  t1.id=t2.sourceid  ";
sql+=whereclause;
sql+=" group by subcategory order by subcategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	subids.add(RecordSet.getString("subcategory"));
	subcounts.add(RecordSet.getString("count"));
}

sql="select count(*) count,seccategory from DocDetail  t1, "+tables+"  t2 where  t1.id=t2.sourceid  ";
sql+=whereclause;
sql+=" group by seccategory order by seccategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	secids.add(RecordSet.getString("seccategory"));
	seccounts.add(RecordSet.getString("count"));
}

sql="select count(*) count,maincategory from DocDetail  t1, "+tables+"  t2 where  t1.id=t2.sourceid and   doccreatedate>='"+lastday+"' and doccreatedate<='"+today+"' ";
sql+=where2;
sql+=" and not exists (select * from docdetaillog where docid=t1.id and operateuserid="+user.getUID()+" and usertype="+logintype+") ";
sql+=" group by maincategory order by maincategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	newmainids.add(RecordSet.getString("maincategory"));
	newmaincounts.add(RecordSet.getString("count"));
}

sql="select count(*) count,subcategory from DocDetail  t1, "+tables+"  t2 where  t1.id=t2.sourceid and  doccreatedate>='"+lastday+"' and doccreatedate<='"+today+"' ";
sql+=where2;
sql+=" and not exists (select * from docdetaillog where docid=t1.id and operateuserid="+user.getUID()+" and usertype="+logintype+") ";
sql+=" group by subcategory order by subcategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	newsubids.add(RecordSet.getString("subcategory"));
	newsubcounts.add(RecordSet.getString("count"));
}

sql="select count(*) count,seccategory from DocDetail  t1, "+tables+"  t2 where  t1.id=t2.sourceid and  doccreatedate>='"+lastday+"' and doccreatedate<='"+today+"' ";
sql+=where2;
sql+=" and not exists (select * from docdetaillog where docid=t1.id and operateuserid="+user.getUID()+" and usertype="+logintype+") ";
sql+=" group by seccategory order by seccategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	newsecids.add(RecordSet.getString("seccategory"));
	newseccounts.add(RecordSet.getString("count"));
}

}
else{
sql="select count(*) count,maincategory from DocDetail  t1, "+tables+"  t2 where   t1.id=t2.sourceid  ";
sql+=whereclause;
sql+=" group by maincategory order by maincategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	mainids.add(RecordSet.getString("maincategory"));
	maincounts.add(RecordSet.getString("count"));
}
sql="select count(*) count,subcategory from DocDetail  t1, "+tables+"  t2 where  t1.id=t2.sourceid  ";
sql+=whereclause;
sql+=" group by subcategory order by subcategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	subids.add(RecordSet.getString("subcategory"));
	subcounts.add(RecordSet.getString("count"));
}
sql="select count(*) count,seccategory from DocDetail  t1, "+tables+"  t2 where  t1.id=t2.sourceid  ";
sql+=whereclause;
sql+=" group by seccategory order by seccategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	secids.add(RecordSet.getString("seccategory"));
	seccounts.add(RecordSet.getString("count"));
}

sql="select count(*) count,maincategory from DocDetail  t1, "+tables+"  t2 where   t1.id=t2.sourceid and  doccreatedate>='"+lastday+"' and doccreatedate<='"+today+"' ";
sql+=where2;
sql+=" group by maincategory order by maincategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	newmainids.add(RecordSet.getString("maincategory"));
	newmaincounts.add(RecordSet.getString("count"));
}

sql="select count(*) count,subcategory from DocDetail  t1, "+tables+"  t2 where   t1.id=t2.sourceid and  doccreatedate>='"+lastday+"' and doccreatedate<='"+today+"' ";
sql+=where2;
sql+=" group by subcategory order by subcategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	newsubids.add(RecordSet.getString("subcategory"));
	newsubcounts.add(RecordSet.getString("count"));
}

sql="select count(*) count,seccategory from DocDetail  t1, "+tables+"  t2 where   t1.id=t2.sourceid and  doccreatedate>='"+lastday+"' and doccreatedate<='"+today+"' ";
sql+=where2;
sql+=" group by seccategory order by seccategory ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	newsecids.add(RecordSet.getString("seccategory"));
	newseccounts.add(RecordSet.getString("count"));
}
}

int maincate = MainCategoryComInfo.getMainCategoryNum();
int rownum = (maincate+1)/2;
%>
  <tr class=Title><th colspan=2><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></th></tr>
<TR><TD class=Line1 colSpan=2></TD></TR>
  <tr>
    <td width="50%" align=left valign=top>
 <%
 	int i=0;
 	int needtd=rownum;
 	while(MainCategoryComInfo.next()){
 		String mainname=MainCategoryComInfo.getMainCategoryname();
 		String mainid = MainCategoryComInfo.getMainCategoryid();
 		String maincount="0";
 		String newmaincount="0";
 		needtd--;
 %>
 	<!-- table -->
 	    <UL>
 	    <%for(int a=0;a<mainids.size();a++){
 	    	String tempid=(String)mainids.get(a);
 	    	if(tempid.equals(mainid)){
 	    		maincount=(String)maincounts.get(a);
 	    		break;
 	    	}
 	    }

 	  //如果没有文档主类也不显示
if(!maincount.equals("0")){

 	    %><LI><%=Util.toScreen(mainname,user.getLanguage())%>
 	    (<a href="DocSearchTemp.jsp?toView=1&docpublishtype=<%=docpublishtype%>&isreply=<%=isreply%>&frompage=<%=frompage%>&doccreatedatefrom=<%=doccreatedatefrom%>&doccreatedateto=<%=doccreatedateto%>&maincategory=<%=mainid%>&docstatus=6&ownerid=<%=ownerid%>&departmentid=<%=departmentid%>&doccreaterid=<%=doccreaterid%>&hrmresid=<%=hrmresid%>&itemid=<%=itemid%>&crmid=<%=crmid%>&projectid=<%=projectid%>&financeid=<%=financeid%>&assetid=<%=assetid%>"><%=maincount%> Docs<%if(!maincount.equals("0")){%></a><%}%>)

<% } %>


 	    <%
 	    for(int a=0;a<newmainids.size();a++){
 	    	String tempid=(String)newmainids.get(a);
 	    	if(tempid.equals(mainid)){
 	    		newmaincount=(String)newmaincounts.get(a);
 	    		break;
 	    	}
 	    }
 	    if(!newmaincount.equals("0")){
 	    %><font color=red><a href="DocSearchTemp.jsp?toView=1&docpublishtype=<%=docpublishtype%>&isreply=<%=isreply%>&frompage=<%=frompage%>&doccreatedatefrom=<%=doccreatedatefrom%>&doccreatedateto=<%=doccreatedateto%>&maincategory=<%=mainid%>&docstatus=6&doccreatedatefrom=<%=lastday%>&doccreatedateto=<%=today%>&ownerid=<%=ownerid%>&departmentid=<%=departmentid%>&doccreaterid=<%=doccreaterid%>&hrmresid=<%=hrmresid%>&itemid=<%=itemid%>&crmid=<%=crmid%>&projectid=<%=projectid%>&financeid=<%=financeid%>&assetid=<%=assetid%>"><%=newmaincount%></a></font>
 	    <IMG src="/images/BDNew_wev8.gif" align=absbottom><%}%>
 	    <UL>
		<%
			while(SubCategoryComInfo.next()){
 	    		String subname=SubCategoryComInfo.getSubCategoryname();
	 		String subid = SubCategoryComInfo.getSubCategoryid();
	 		String curmainid = SubCategoryComInfo.getMainCategoryid();
	 		String subcount="0";
 			String newsubcount="0";
	 		if(!curmainid.equals(mainid)) continue;

		for(int a=0;a<subids.size();a++){
	 		String tempid=(String)subids.get(a);
	 	   	if(tempid.equals(subid)){
	 	   		subcount=(String)subcounts.get(a);
	 	   		break;
	 	   	}
	 	}
	 	if(!subcount.equals("0")){
	 	%><LI><%=Util.toScreen(subname,user.getLanguage())%>
	 	(<a href="DocSearchTemp.jsp?toView=1&docpublishtype=<%=docpublishtype%>&isreply=<%=isreply%>&frompage=<%=frompage%>&doccreatedatefrom=<%=doccreatedatefrom%>&doccreatedateto=<%=doccreatedateto%>&subcategory=<%=subid%>&docstatus=6&ownerid=<%=ownerid%>&departmentid=<%=departmentid%>&doccreaterid=<%=doccreaterid%>&hrmresid=<%=hrmresid%>&itemid=<%=itemid%>&crmid=<%=crmid%>&projectid=<%=projectid%>&financeid=<%=financeid%>&assetid=<%=assetid%>"><%=subcount%> Docs</a>)<%}
	 	for(int a=0;a<newsubids.size();a++){
	 	    	String tempid=(String)newsubids.get(a);
	 	    	if(tempid.equals(subid)){
	 	    		newsubcount=(String)newsubcounts.get(a);
	 	    		break;
	 	    	}
	 	}
	 	    if(!newsubcount.equals("0")){
	 	    %><font color=red><a href="DocSearchTemp.jsp?toView=1&docpublishtype=<%=docpublishtype%>&isreply=<%=isreply%>&frompage=<%=frompage%>&doccreatedatefrom=<%=doccreatedatefrom%>&doccreatedateto=<%=doccreatedateto%>&subcategory=<%=subid%>&docstatus=6&doccreatedatefrom=<%=lastday%>&doccreatedateto=<%=today%>&ownerid=<%=ownerid%>&departmentid=<%=departmentid%>&doccreaterid=<%=doccreaterid%>&hrmresid=<%=hrmresid%>&itemid=<%=itemid%>&crmid=<%=crmid%>&projectid=<%=projectid%>&financeid=<%=financeid%>&assetid=<%=assetid%>"><%=newsubcount%></a></font>
	 	    <IMG src="/images/BDNew_wev8.gif" align=absbottom><%
	 	    }
			%>
			<UL>
			<%
			while(SecCategoryComInfo.next()){
				String secname=SecCategoryComInfo.getSecCategoryname();
	 			String secid = SecCategoryComInfo.getSecCategoryid();
	 			String cursubid = SecCategoryComInfo.getSubCategoryid();
	 			String seccount="0";
 				String newseccount="0";
	 			if(!cursubid.equals(subid)) continue;

				for(int a=0;a<secids.size();a++){
	 				String tempid=(String)secids.get(a);
	 	   			if(tempid.equals(secid)){
	 	   				seccount=(String)seccounts.get(a);
	 	   			break;
	 	   			}
	 			}
	 	if(!seccount.equals("0")){
	 	%><LI><%=Util.toScreen(secname,user.getLanguage())%>
	 	(<a href="DocSearchTemp.jsp?toView=1&docpublishtype=<%=docpublishtype%>&isreply=<%=isreply%>&frompage=<%=frompage%>&doccreatedatefrom=<%=doccreatedatefrom%>&doccreatedateto=<%=doccreatedateto%>&seccategory=<%=secid%>&docstatus=6&ownerid=<%=ownerid%>&departmentid=<%=departmentid%>&doccreaterid=<%=doccreaterid%>&hrmresid=<%=hrmresid%>&itemid=<%=itemid%>&crmid=<%=crmid%>&projectid=<%=projectid%>&financeid=<%=financeid%>&assetid=<%=assetid%>"><%=seccount%> Docs</a>)<%}
	 	for(int a=0;a<newsecids.size();a++){
	 	    	String tempid=(String)newsecids.get(a);
	 	    	if(tempid.equals(secid)){
	 	    		newseccount=(String)newseccounts.get(a);
	 	    		break;
	 	    	}
	 	}
	 	    if(!newseccount.equals("0")){
	 	    %><font color=red><a href="DocSearchTemp.jsp?toView=1&docpublishtype=<%=docpublishtype%>&isreply=<%=isreply%>&frompage=<%=frompage%>&doccreatedatefrom=<%=doccreatedatefrom%>&doccreatedateto=<%=doccreatedateto%>&seccategory=<%=secid%>&docstatus=6&doccreatedatefrom=<%=lastday%>&doccreatedateto=<%=today%>&ownerid=<%=ownerid%>&departmentid=<%=departmentid%>&doccreaterid=<%=doccreaterid%>&hrmresid=<%=hrmresid%>&itemid=<%=itemid%>&crmid=<%=crmid%>&projectid=<%=projectid%>&financeid=<%=financeid%>&assetid=<%=assetid%>"><%=newsubcount%></a></font>
	 	    <IMG src="/images/BDNew_wev8.gif" align=absbottom><%
	 	    }
 	    	}
 	    	SecCategoryComInfo.setTofirstRow();
 	    %>

			</UL>
			<%
 	    	}
 	    	SubCategoryComInfo.setTofirstRow();
 	    %>

 	    </ul>
	</ul>

 	<!-- /table -->
 	<%
		if(needtd==0){
			needtd=maincate/2;
	%>
		</td><td align=left valign=top>
	<%
		}
	}
	%>
  </tr>
</table>


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

<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		departmentspan.innerHtml = id(1)
		frmmain.departmentid.value=id(0)
		else
		departmentspan.innerHtml = empty
		frmmain.departmentid.value=""
		end if
	end if
end sub
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		ownerspan.innerHtml = "<a href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</a>"
		frmmain.owner.value=id(0)
		else
		ownerspan.innerHtml = empty
		frmmain.owner.value=""
		end if
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>