<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
String url = Util.null2String(request.getParameter("url"));
String urlType = Util.null2String(request.getParameter("urlType"));
String displayUsage=Util.null2o(request.getParameter("displayUsage"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String docstatus = "'1','2','5'";

if(urlType.equals("5")){
	docstatus += ",'0','3','4','6','7'";
}


String logintype = user.getLogintype();
String mainid=Util.null2String(request.getParameter("mainid"));
String mainname=MainCategoryComInfo.getMainCategoryname(mainid);
String owner=Util.null2String(request.getParameter("owner"));
String departmentid=Util.null2String(request.getParameter("departmentid"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String todate=Util.fromScreen(request.getParameter("todate"),user.getLanguage());
String publishtype=Util.fromScreen(request.getParameter("publishtype"),user.getLanguage());

String ownername=ResourceComInfo.getResourcename(owner);
String departmentname=DepartmentComInfo.getDepartmentname(departmentid);
String departmentmark=DepartmentComInfo.getDepartmentmark(departmentid);
String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
String isShow = Util.null2String(request.getParameter("isShow"));
String dspreply = Util.null2String(request.getParameter("dspreply"));

if(urlType.equals("5")){
	doccreaterid = ""+user.getUID();
}

int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);

String selectArr = "";
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectArr = info.getSelectedContent();
}
if(!"".equals(selectedContent))
{
	selectArr = selectedContent;
}
selectArr+="|";

String inMainCategoryStr = "";
String inSubCategoryStr = "";
String[] docCategoryArray = null;
if(fromAdvancedMenu==1){
	docCategoryArray = Util.TokenizerString2(selectArr,"|");
	if(docCategoryArray!=null&&docCategoryArray.length>0){
		for(int k=0;k<docCategoryArray.length;k++){
			if(docCategoryArray[k].indexOf("M")>-1)
				inMainCategoryStr += "," + docCategoryArray[k].substring(1);
			if(docCategoryArray[k].indexOf("S")>-1)
				inSubCategoryStr += "," + docCategoryArray[k].substring(1);
		}
		if(inMainCategoryStr.substring(0,1).equals(",")) inMainCategoryStr=inMainCategoryStr.substring(1);
		if(inSubCategoryStr.substring(0,1).equals(",")) inSubCategoryStr=inSubCategoryStr.substring(1);
	}
}
%>
<%@ include file="/docs/common.jsp" %>

<%
String whereclause="";
String sql="";

if(!doccreaterid.equals("")&&!doccreaterid.equals("0")){
	whereclause+=" and doccreaterid="+doccreaterid;
}

if(!owner.equals("")){
	whereclause+=" and ownerid="+owner;
}
if(!departmentid.equals("")){
	whereclause+=" and docdepartmentid="+departmentid;
}

if(!fromdate.equals("")){
	whereclause+=" and doccreatedate>='"+fromdate+"'";
}
if(!todate.equals("")){
	whereclause+=" and doccreatedate<='"+todate+"'";
}
if(!publishtype.equals("")){
	whereclause+=" and docpublishtype='"+publishtype+"'";
}

if(urlType.equals("0")){
	whereclause+=" and  NOT EXISTS (select 1 from docReadTag where userid="
						+ user.getUID() + " and usertype=" + logintype + " AND docid=T1.ID)  and t1.doccreaterid <> "+user.getUID();
}

/* added by wdl 2006-08-28 不显示历史版本 */
whereclause+=" and (ishistory is null or ishistory = 0) ";
/* added end */

if(offical.equals("1")){//发文/收文库
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
	secids = secids.replaceAll(",{2,}",",");
	if(secids.trim().equals("")){
		secids="-2";
	}
	whereclause += " and seccategory in ("+secids+")";
}

if(urlType.equals("10")){//批量共享
	whereclause+=" and sharelevel=3 ";
	whereclause+=" and exists(select 1 from DocSecCategory where DocSecCategory.id=t1.secCategory and DocSecCategory.shareable='1') ";	
}

if(urlType.equals("11")){//批量调整共享

}

/* added by wdl 2006-06-16 left menu advanced menu */
if((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))
	whereclause+=" and maincategory in (" + inMainCategoryStr + ") ";
if((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))
	whereclause+=" and subcategory in (" + inSubCategoryStr + ") ";
/* added end */


ArrayList subcounts=new ArrayList();
ArrayList newsubcounts=new ArrayList();
ArrayList seccounts=new ArrayList();
ArrayList newseccounts=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList secids=new ArrayList();

if(logintype.equals("1")){  //内部用户的处理

    //总的分目录下的文章
    sql = "select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ("+docstatus+")) and t1.id=t2.sourceid and t1.maincategory="+mainid+" ";
    sql+=whereclause;
    sql+=" group by t1.subcategory order by t1.subcategory ";
    RecordSet.executeSql(sql);

    while(RecordSet.next()){
        subids.add(RecordSet.getString("subcategory"));
        subcounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newsubcounts.add(RecordSet.getString("count")) ;
    }

    //总的子目录目录下的文章
    sql = "select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ("+docstatus+")) and t1.id=t2.sourceid  and t1.maincategory="+mainid+" ";
    sql+=whereclause;
    sql+=" group by t1.subcategory order by t1.subcategory ";
    
    
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        secids.add(RecordSet.getString("subcategory"));
        seccounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newseccounts.add(RecordSet.getString("count")) ;
    }

    //刘煜改为总的分目录 看过的文章 
    sql = "select count(distinct t1.id) count,t1.subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+mainid+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ("+docstatus+")) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) )" ;
    sql += whereclause;
    sql += " group by t1.subcategory order by t1.subcategory ";

    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        String tempsubid = Util.null2String( RecordSet.getString("subcategory") ) ;
        int subidhasread = Util.getIntValue( RecordSet.getString("count") , 0 ) ;
        int tempsubidindex = subids.indexOf( tempsubid ) ;
        if( tempsubidindex != -1 ) {
            int suballcount = Util.getIntValue((String)subcounts.get(tempsubidindex), 0) ;
            int subidhasnotread = suballcount - subidhasread ;
            if(subidhasnotread < 0) subidhasnotread = 0 ;
            newsubcounts.set( tempsubidindex , ""+subidhasnotread ) ;
        }
    }


    //刘煜改为总的子目录 看过的文章 
	
	sql="select count(t1.id) count,t1.subcategory from DocDetail  t1";
    if(!urlType.equals("11")){
    	sql += ", "+tables+"  t2";
    }
    sql += " where  t1.maincategory="+mainid+" and ((docstatus = 7 ";
    if(!urlType.equals("11")){
    	sql += "and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))";
    }
    sql += ") or docstatus in ("+docstatus+"))";
    if(!urlType.equals("11")){
    	sql+= "   and t1.id=t2.sourceid";
    }
    if(dspreply.equals("0")||dspreply.equals("1")){
    	sql+= "   and t1.isreply="+dspreply;
    }
	sql+=whereclause;
    sql+=" group by t1.subcategory order by t1.subcategory ";
	
	
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        String tempsecid = Util.null2String( RecordSet.getString("subcategory") ) ;
        int secidhasread = Util.getIntValue( RecordSet.getString("count") , 0 ) ;
        int tempsecidindex = secids.indexOf( tempsecid ) ;
        if( tempsecidindex != -1 ) {
            int secallcount = Util.getIntValue((String)seccounts.get(tempsecidindex), 0) ;
            int secidhasnotread = secallcount - secidhasread ;
            if(secidhasnotread < 0) secidhasnotread = 0 ;
            newseccounts.set( tempsecidindex , ""+secidhasnotread ) ;
        }
    }
}
else{

    //总的分目录下的文章
    sql="select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and t1.id=t2.sourceid  and t1.maincategory="+mainid+" ";
    sql += whereclause;
    sql += " group by t1.subcategory order by t1.subcategory ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        subids.add(RecordSet.getString("subcategory"));
        subcounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newsubcounts.add(RecordSet.getString("count")) ;
    }

    //总的字目录下的文章
    sql="select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and t1.id=t2.sourceid and t1.maincategory="+mainid+" ";
    sql += whereclause;
    sql += " group by t1.subcategory order by t1.subcategory ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        secids.add(RecordSet.getString("subcategory"));
        seccounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newseccounts.add(RecordSet.getString("count")) ;
    }


    //刘煜改为总的分目录 看过的文章 
    sql = "select count(distinct t1.id) count,t1.subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+mainid+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) )" ;
    sql += whereclause;
    sql += " group by t1.subcategory order by t1.subcategory ";

    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        String tempsubid = Util.null2String( RecordSet.getString("seccategory") ) ;
        int subidhasread = Util.getIntValue( RecordSet.getString("count") , 0 ) ;
        int tempsubidindex = subids.indexOf( tempsubid ) ;
        if( tempsubidindex != -1 ) {
            int suballcount = Util.getIntValue((String)subcounts.get(tempsubidindex), 0) ;
            int subidhasnotread = suballcount - subidhasread ;
            if(subidhasnotread < 0) subidhasnotread = 0 ;
            newsubcounts.set( tempsubidindex , ""+subidhasnotread ) ;
        }
    }


    //刘煜改为总的子目录 看过的文章 
    sql = "select count(distinct t1.id) count,t1.subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on  t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+mainid+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) )" ;
    sql += whereclause;
    sql += " group by t1.seccategory order by t1.subcategory ";

    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        String tempsecid = Util.null2String( RecordSet.getString("subcategory") ) ;
        int secidhasread = Util.getIntValue( RecordSet.getString("count") , 0 ) ;
        int tempsecidindex = secids.indexOf( tempsecid ) ;
        if( tempsecidindex != -1 ) {
            int secallcount = Util.getIntValue((String)seccounts.get(tempsecidindex), 0) ;
            int secidhasnotread = secallcount - secidhasread ;
            if(secidhasnotread < 0) secidhasnotread = 0 ;
            newseccounts.set( tempsecidindex , ""+secidhasnotread ) ;
        }
    }
}


int seccate = 0;
while(SubCategoryComInfo.next()){
	String curmainid=SubCategoryComInfo.getMainCategoryid();
	if(selectArr.indexOf("M"+curmainid+"|")==-1 && fromAdvancedMenu==1) continue;
	if(mainid.equals(curmainid))
		seccate++;
}
SubCategoryComInfo.setTofirstRow();
int rownum = (seccate+1)/2;
%>

 [ 
 <%
 	int i=0;
 	int needtd=rownum;
 	//保存缓存中最后一个有文档的小分类
 	String lastSecid = "";
 	while(SubCategoryComInfo.next()){
 		String tempmainid=SubCategoryComInfo.getMainCategoryid();
 		if(!tempmainid.equals(mainid)) continue;
 		String secname=SubCategoryComInfo.getSubCategoryname();
 		String secid = SubCategoryComInfo.getSubCategoryid();
 		
        /* added by wdl 2006-06-16 left menu advanced menu */
	 	if(selectArr.indexOf("M"+mainid+"|")==-1 && fromAdvancedMenu==1) continue;
	 	/* added end */
 		
 		String seccount="0";
        int thesecidindex = secids.indexOf( secid ) ;
        if( thesecidindex != -1 ) seccount  = ""+Util.getIntValue((String)seccounts.get(thesecidindex),0);
        if(seccount.equals("0")){continue;}
        lastSecid = secid;
	}
	SubCategoryComInfo.setTofirstRow();
 	while(SubCategoryComInfo.next()){
 		String tempmainid=SubCategoryComInfo.getMainCategoryid();
 		if(!tempmainid.equals(mainid)) continue;
 		String secname=SubCategoryComInfo.getSubCategoryname();
 		String secid = SubCategoryComInfo.getSubCategoryid();
 		
        /* added by wdl 2006-06-16 left menu advanced menu */
	 	if(selectArr.indexOf("M"+mainid+"|")==-1 && fromAdvancedMenu==1) continue;
	 	/* added end */
 		String seccount="0";
 		String newseccount="0";
 		needtd--;

        int thesecidindex = secids.indexOf( secid ) ;
        if( thesecidindex != -1 ) seccount  = ""+Util.getIntValue((String)seccounts.get(thesecidindex),0);
        if(!seccount.equals("0")){
            if( thesecidindex != -1 ) newseccount  = ""+Util.getIntValue((String)newseccounts.get(thesecidindex),0);
            else newseccount = seccount;
            if(urlType.equals("5")){
				newseccount = "0";
			}
%>
{"name": "<%=Util.toScreen(secname,user.getLanguage())%>",
 "hasChildren":true,
 "isOpen":false,
  "numbers":{
  	"docNew":"<%=Util.toScreen(newseccount,user.getLanguage())%>",
  	"docAll":"<%=Util.toScreen(seccount,user.getLanguage())%>"
  },
  "attr":{
  	"urlSum":"DocSummary3New.jsp?offical=<%=offical%>&officalType=<%=officalType%>&urlType=<%=urlType%>&dspreply=<%=dspreply%>&url=<%=url%>&loginType=<%=logintype%>&owner=<%=owner%>&fromdate=<%=fromdate%>&todate=<%=todate%>&departmentid=<%=departmentid%>&publishtype=<%=publishtype%>&mainid=<%=mainid%>&subid=<%=secid%>&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>",
  	"urlAll":"<%=url%>?offical=<%=offical%>&officalType=<%=officalType%>&ishow=false&_reply=<%=dspreply%>&subcategory=<%=secid%>&maincategory=<%=mainid%>&urlType=<%=urlType%>&loginType=<%=logintype%>&toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&maincategory=<%=mainid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>&<%=logintype.equals("1")?"doccreaterid="+doccreaterid:"doccreaterid2="+doccreaterid%>&ishow=<%=isShow%>",
  	"urlNew":"<%=url%>?offical=<%=offical%>&officalType=<%=officalType%>&ishow=false&&_reply=<%=dspreply%>subcategory=<%=secid%>&maincategory=<%=mainid%>&urlType=<%=urlType%>&loginType=<%=logintype%>&isMainOrSub=main&isNew=yes&toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&maincategory=<%=mainid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>&<%=logintype.equals("1")?"doccreaterid="+doccreaterid:"doccreaterid2="+doccreaterid%>&ishow=<%=isShow%>"
  }
 }<%=lastSecid.equals(secid)?"":","%>
<%
        }
	}
%>
]

