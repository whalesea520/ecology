
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.common.xtable.TableSql" %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="sharemanager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	return;
}
String self = Util.null2String(request.getParameter("self")) ;
String docstatus=Util.null2String(request.getParameter("docstatus")) ;
String frompage=Util.null2String(request.getParameter("frompage"));//从哪个页面过来
if("true".equals(self)){
/* edited by wdl 2006-05-24 left menu new requirement DocView.jsp?displayUsage=1 */
int displayUsage = Util.getIntValue(request.getParameter("displayUsage"),0);
int showtype = Util.getIntValue(request.getParameter("showtype"),0);
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
/* edited end */
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
String date2during =Util.null2String(request.getParameter("date2during"));
if(treeDocFieldId.equals("0")) treeDocFieldId="";


String noRead = Util.null2String(request.getParameter("noRead"));
String dspreply = Util.null2String(request.getParameter("dspreply"));
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
if ("0".equals(dspreply)) DocSearchComInfo.setContainreply("1");   //全部
else if("1".equals(dspreply)) DocSearchComInfo.setContainreply("0");   //非回复
else if ("2".equals(dspreply)) DocSearchComInfo.setIsreply("1");  //仅回复

if(docpublishtype.equals("1")||docpublishtype.equals("2")||docpublishtype.equals("3")||docpublishtype.equals("5")){
	DocSearchComInfo.setDocpublishtype(docpublishtype);
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
DocSearchComInfo.setDate2during(date2during);
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
    String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;	
    DocSubscribe ds = new DocSubscribe(whereclause,user);
    int pagesize = UserDefaultManager.getNumperpage();
    if(pagesize <2) pagesize=10;                       
    
    String backFields ="t1.id, t1.docsubject,t1.doccreaterid,t1.doccreatedate,t1.doclastmoddate,t1.replaydoccount,t1.docstatus,t1.ownerId";
     
    String sqlFrom = " from docdetail t1 left join "+ShareManager.getShareDetailTableByUser("doc",user)+" t2  on t1.id=t2.sourceid ";
	
	 String strCustomSql=DocSearchComInfo.getCustomSqlWhere();
		if(!strCustomSql.equals("")){
		  sqlFrom += " left join cus_fielddata tCustom on t1.id=tCustom.id ";
		}
    String sqlWhere = whereclause+" and t1.orderable = '1'  and t2.sourceid is null and not exists(select 1 from docsubscribe where docid=t1.id and state in('1','2') and hrmId="+user.getUID()+")";

    %>
    <% String sqlInfo ="";
    String sessionId=Util.getEncrypt("xTableSql_"+Util.getRandom()); 
    sqlInfo = "var sqlInfo = {sessionId:\""+sessionId+"\",orderby:\"doccreatedate\",pagesize:\""+pagesize+"\"}";
    out.println(sqlInfo);
    
    
    TableSql xTableSql=new TableSql();
    xTableSql.setBackfields(backFields);
    xTableSql.setSqlform(sqlFrom);
    xTableSql.setSqlwhere(sqlWhere);
    xTableSql.setSqlisdistinct("true");
    xTableSql.setSqlprimarykey("t1.id");

    session.setAttribute(sessionId,xTableSql);
    %>
  