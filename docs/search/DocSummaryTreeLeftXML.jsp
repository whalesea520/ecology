
<%@ page language="java" contentType="text/xml; charset=UTF-8" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.docs.category.security.*"%>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sharemanager" class="weaver.share.ShareManager" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String tables=sharemanager.getShareDetailTableByUser("doc",user);
String tablename=sharemanager.getTableNameByUser("doc",user);

String logintype = user.getLogintype();
//String owner=Util.null2String(request.getParameter("owner"));
//String departmentid=Util.null2String(request.getParameter("departmentid"));
//String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
//String todate=Util.fromScreen(request.getParameter("todate"),user.getLanguage());
//String publishtype=Util.fromScreen(request.getParameter("publishtype"),user.getLanguage());

String maincategory=Util.null2String(request.getParameter("maincategory"));
if(maincategory.equals("0")) maincategory="";
String subcategory=Util.null2String(request.getParameter("subcategory"));
if(subcategory.equals("0")) subcategory="";
String seccategory=Util.null2String(request.getParameter("seccategory"));
if(seccategory.equals("0")) seccategory="";

//String ownername=ResourceComInfo.getResourcename(owner);
//String departmentname=DepartmentComInfo.getDepartmentname(departmentid);
//String departmentmark=DepartmentComInfo.getDepartmentmark(departmentid);

int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
String tmpMaincategoryFromAdvancedMenuInfoId = Util.null2String(request.getParameter("maincategory_fromadvancedmenu_infoId_selectedContent"));
if(!tmpMaincategoryFromAdvancedMenuInfoId.equals("")){
	String tmppara[] = Util.TokenizerString2(tmpMaincategoryFromAdvancedMenuInfoId,"_");
	maincategory = tmppara[0];
	fromAdvancedMenu = Util.getIntValue(tmppara[1],0);
	infoId = Util.getIntValue(tmppara[2],0);
	if(tmppara.length>3)
		selectedContent = Util.null2String(tmppara[3]);
	
}

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

String whereclause="";
String sql="";

//if(!owner.equals("")){
	//whereclause+=" and ownerid="+owner;
//}
//if(!departmentid.equals("")){
	//whereclause+=" and docdepartmentid="+departmentid;
//}

//if(!fromdate.equals("")){
	//whereclause+=" and doccreatedate>='"+fromdate+"'";
//}
//if(!todate.equals("")){
	//whereclause+=" and doccreatedate<='"+todate+"'";
//}
//if(!publishtype.equals("")){
	//whereclause+=" and docpublishtype='"+publishtype+"'";
//}


if((fromAdvancedMenu==1)&&inMainCategoryStr!=null&&!"".equals(inMainCategoryStr))
	whereclause+=" and maincategory in (" + inMainCategoryStr + ") ";
if((fromAdvancedMenu==1)&&inSubCategoryStr!=null&&!"".equals(inSubCategoryStr))
	whereclause+=" and subcategory in (" + inSubCategoryStr + ") ";


ArrayList maincounts=new ArrayList();
ArrayList newmaincounts=new ArrayList();

ArrayList subcounts=new ArrayList();
ArrayList newsubcounts=new ArrayList();

ArrayList seccounts=new ArrayList();
ArrayList newseccounts=new ArrayList();

ArrayList mainids=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList secids=new ArrayList();


if(logintype.equals("1")){ //内部用户的处理

	if("".equals(maincategory)&&"".equals(subcategory)){
	
	    //总的主目录下的文章
	    sql="select count(t1.id) count,t1.maincategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0) and t1.maincategory!=0  and  t1.subcategory!=0 and  t1.seccategory!=0 and t1.id=t2.sourceid";
	    sql+=whereclause;
	    sql+=" group by t1.maincategory order by t1.maincategory ";
	
	    RecordSet.executeSql(sql);
	
	    while(RecordSet.next()){
	        mainids.add(RecordSet.getString("maincategory"));
	        maincounts.add(RecordSet.getString("count"));
	
	        // 将未读的总数初始化为开始的总数
	        newmaincounts.add(RecordSet.getString("count")) ;
	    }
	    
	    //刘煜改为总的主目录 看过的文章
	    
	    sql = "select count(distinct t1.id) count,t1.maincategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on   t1.id=t2.docid where t1.id=t3.sourceid and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) ) ";
	    sql += whereclause;
	    sql += " group by t1.maincategory order by t1.maincategory ";

	    RecordSet.executeSql(sql);

	    while(RecordSet.next()){
	        String tempmainid = ""+Util.null2String( RecordSet.getString(2) ) ;
	        int mainidhasread = Util.getIntValue( RecordSet.getString(1) , 0) ;
	        int tempmainidindex = mainids.indexOf( tempmainid ) ;
	        if( tempmainidindex != -1 ) {
	            int mainallcount = Util.getIntValue((String)maincounts.get(tempmainidindex), 0) ;
	            int mainidhasnotread = mainallcount - mainidhasread ;

	            if(mainidhasnotread < 0) mainidhasnotread = 0 ;
	            newmaincounts.set( tempmainidindex , ""+mainidhasnotread ) ;
	        }
	    }
	
	} else if(!"".equals(maincategory)) {
    
	    //总的分目录下的文章
	    sql = "select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and t1.id=t2.sourceid and t1.maincategory="+maincategory+" ";
	    sql+=whereclause;
	    sql+=" group by t1.subcategory order by t1.subcategory ";
	
	    RecordSet.executeSql(sql);
	
	    while(RecordSet.next()){
	        subids.add(RecordSet.getString("subcategory"));
	        subcounts.add(RecordSet.getString("count"));
	
	        // 将未读的总数初始化为开始的总数
	        newsubcounts.add(RecordSet.getString("count")) ;
	    }
	    
	    //刘煜改为总的分目录 看过的文章 
	    sql = "select count(distinct t1.id) count,t1.subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on   t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+maincategory+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) )" ;
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
	    
    } else if(!"".equals(subcategory)){

	    //总的子目录目录下的文章
	    sql = "select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and t1.id=t2.sourceid and t1.subcategory="+subcategory+" ";
	    sql+=whereclause;
	    sql+=" group by t1.seccategory order by t1.seccategory ";
	    RecordSet.executeSql(sql);
	    while(RecordSet.next()){
	        secids.add(RecordSet.getString("seccategory"));
	        seccounts.add(RecordSet.getString("count"));
	
	        // 将未读的总数初始化为开始的总数
	        newseccounts.add(RecordSet.getString("count")) ;
	    }

	    //刘煜改为总的子目录 看过的文章 
	    sql = "select count(distinct t1.id) count,t1.seccategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on   t1.id=t2.docid where t1.id=t3.sourceid and t1.subcategory="+subcategory+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) )" ;
	    sql += whereclause;
	    sql += " group by t1.seccategory order by t1.seccategory ";
	
	    RecordSet.executeSql(sql);
	    while(RecordSet.next()){
	        String tempsecid = Util.null2String( RecordSet.getString("seccategory") ) ;
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

} else { //不用内部用户时的情况

	if("".equals(maincategory)&&"".equals(subcategory)){
		//总的主目录下的文章
	    sql="select count(t1.id) count,t1.maincategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.sourceid ";
	    sql+=whereclause;
	    sql+=" group by t1.maincategory order by t1.maincategory "; 
	    RecordSet.executeSql(sql);
	    while(RecordSet.next()){
	        mainids.add(RecordSet.getString("maincategory"));
	        maincounts.add(RecordSet.getString("count"));

	        // 将未读的总数初始化为开始的总数
	        newmaincounts.add(RecordSet.getString("count")) ;
	    }

	    //刘煜修改 总的主目录 看过的文章
	    sql = "select count(distinct t1.id) count,maincategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on  t1.id=t2.docid where t1.id=t3.sourceid and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) ) ";
	    sql+=whereclause;
	    sql+=" group by t1.maincategory order by t1.maincategory ";
	    RecordSet.executeSql(sql);
	    while(RecordSet.next()){
	        String tempmainid = Util.null2String( RecordSet.getString("maincategory") ) ;
	        int mainidhasread = Util.getIntValue( RecordSet.getString("count") , 0) ;
	        int tempmainidindex = mainids.indexOf( tempmainid ) ;
	        if( tempmainidindex != -1 ) {
	            int mainallcount = Util.getIntValue((String)maincounts.get(tempmainidindex), 0) ;
	            int mainidhasnotread = mainallcount - mainidhasread ;
	            if(mainidhasnotread < 0) mainidhasnotread = 0 ;
	            newmaincounts.set( tempmainidindex , ""+mainidhasnotread ) ;
	        }
	    }
	} else if(!"".equals(maincategory)) {
	    //总的分目录下的文章
	    sql="select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and t1.id=t2.sourceid  and t1.maincategory="+maincategory+" ";
	    sql += whereclause;
	    sql += " group by t1.subcategory order by t1.subcategory ";
	    RecordSet.executeSql(sql);
	    while(RecordSet.next()){
	        subids.add(RecordSet.getString("subcategory"));
	        subcounts.add(RecordSet.getString("count"));

	        // 将未读的总数初始化为开始的总数
	        newsubcounts.add(RecordSet.getString("count")) ;
	    }
		
	    //刘煜修改 总的分目录下 看过的文章
	    sql = "select count(distinct t1.id) count,t1.subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on   t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+maincategory+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) )" ;
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
	    
    } else if(!"".equals(subcategory)){
    	
        //总的子目录下的文章
        sql="select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and t1.id=t2.sourceid and t1.subcategory="+subcategory+" ";
        sql += whereclause;
        sql += " group by t1.seccategory order by t1.seccategory ";
        RecordSet.executeSql(sql);
        while(RecordSet.next()){
            secids.add(RecordSet.getString("seccategory"));
            seccounts.add(RecordSet.getString("count"));

            // 将未读的总数初始化为开始的总数
            newseccounts.add(RecordSet.getString("count")) ;
        }
		
        //刘煜改为总的子目录 看过的文章 
        sql = "select count(distinct t1.id) count,t1.seccategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on  t1.id=t2.docid where t1.id=t3.sourceid and t1.subcategory="+subcategory+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and (ishistory is null or ishistory = 0)  and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) )" ;
        sql += whereclause;
        sql += " group by t1.seccategory order by t1.seccategory ";

        RecordSet.executeSql(sql);
        while(RecordSet.next()){
            String tempsecid = Util.null2String( RecordSet.getString("seccategory") ) ;
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
}
%>
<tree>
<%
StringBuffer treeStr = new StringBuffer();

if("".equals(maincategory)&&"".equals(subcategory)){
	
	MainCategoryComInfo.setTofirstRow();
	
 	while(MainCategoryComInfo.next()){
 		treeStr = new StringBuffer();
 		
 		String mainname=MainCategoryComInfo.getMainCategoryname();
 		String mainid = MainCategoryComInfo.getMainCategoryid();
 		
	 	if(selectArr.indexOf("M"+mainid+"|")==-1 && fromAdvancedMenu==1) continue;
 		
 		String maincount="0";
 		String newmaincount="0";

 		int themainidindex = mainids.indexOf( mainid ) ;
        if( themainidindex != -1 ) maincount  = ""+Util.getIntValue((String)maincounts.get(themainidindex),0);
        if( themainidindex != -1 ) newmaincount  = ""+Util.getIntValue((String)newmaincounts.get(themainidindex),0);
		
        if(Util.getIntValue(maincount)==0) continue;
        
        //主目录
        treeStr.append("<tree ");
        //text
        treeStr.append("text=\"");
        treeStr.append(
        		Util.replace(
           		Util.replace(
    			Util.replace(
      			Util.replace(
      			Util.replace(
   				Util.toScreen(mainname,user.getLanguage())
           		,"<","&lt;",0)
           		,">","&gt;",0)
           		,"&","&amp;",0)
           		,"'","&apos;",0)
           		,"\"","&quot;",0)
        );
        //text(文档数)
       	treeStr.append("&lt;/span&gt;");
        treeStr.append(" (");
        
        if(Util.getIntValue(newmaincount)>0){
        	treeStr.append("&lt;span onclick='javascript:onClickNewDocNumber("+mainid+","+0+");' style='cursor:hand;color=#0000FF' onmouseover='javascript:onOverNewDocNumber(this);' onmouseout='javascript:onOutNewDocNumber(this);' &gt;");
        }
        treeStr.append(Util.toScreen(newmaincount,user.getLanguage()));
	if(Util.getIntValue(newmaincount,0)>0)
        treeStr.append("&lt;img src='/images/BDNew_wev8.gif' align=absbottom &gt;");
       	treeStr.append("&lt;/span&gt;");
       	
       	treeStr.append(" / ");
       	
        if(Util.getIntValue(maincount)>0){
        	treeStr.append("&lt;span onclick='javascript:onClickDocNumber("+mainid+","+0+");' style='cursor:hand;color=#0000FF' onmouseover='javascript:onOverNewDocNumber(this);' onmouseout='javascript:onOutNewDocNumber(this);' &gt;");
        }
        treeStr.append(Util.toScreen(maincount,user.getLanguage()));
        
       	treeStr.append("&lt;/span&gt;");
        treeStr.append(" Docs");
        treeStr.append(") &lt;span&gt;");
        treeStr.append("\" ");
        //action
        treeStr.append("action=\"");
        treeStr.append("javascript:onClickCategory("+mainid+","+0+");");
        treeStr.append("\" ");
        //icon
        treeStr.append("icon=\"/images/xp/folder_wev8.png\" ");
        //openIcon
        treeStr.append("openIcon=\"/images/xp/openfolder_wev8.png\" ");
        //target
        treeStr.append("target=\"_self\" ");
        //src
        treeStr.append("src=\"DocSummaryTreeLeftXML.jsp?maincategory_fromadvancedmenu_infoId_selectedContent="+mainid+"_"+fromAdvancedMenu+"_"+infoId+"_"+selectedContent+"\" ");
        
        treeStr.append(" />");
        
        out.println(treeStr.toString());
 	}

} else if(!"".equals(maincategory)) {
	
	SubCategoryComInfo.setTofirstRow();
	
	while(SubCategoryComInfo.next()){
 		treeStr = new StringBuffer();
 		
 		String tempmainid=SubCategoryComInfo.getMainCategoryid();
 		if(!tempmainid.equals(maincategory))
 			continue;
 		String subname=SubCategoryComInfo.getSubCategoryname();
 		String subid = SubCategoryComInfo.getSubCategoryid();
 		
	 	if(selectArr.indexOf("S"+subid+"|")==-1 && fromAdvancedMenu==1) continue;
 		
 		String subcount="0";
 		String newsubcount="0";

        int thesubidindex = subids.indexOf( subid ) ;
        if( thesubidindex != -1 ) subcount  = ""+Util.getIntValue((String)subcounts.get(thesubidindex),0);
        if( thesubidindex != -1 ) newsubcount  = ""+Util.getIntValue((String)newsubcounts.get(thesubidindex),0);

        if(Util.getIntValue(subcount)==0) continue;
        
        //分目录
        treeStr.append("<tree ");
        //text
        treeStr.append("text=\"");
		 subname=Util.replace(subname,"&quot;","\"",0);
        subname=Util.replace(subname,"&lt;","<",0);
        subname=Util.replace(subname,"&gt;",">",0);
		subname=Util.replace(subname,"&apos;","'",0);
        treeStr.append(
        		subname
        );
        //text(文档数)
       	treeStr.append("&lt;/span&gt;");
        treeStr.append(" (");
        
        if(Util.getIntValue(newsubcount)>0){
        	treeStr.append("&lt;span onclick='javascript:onClickNewDocNumber("+subid+","+1+");' style='cursor:hand;color=#0000FF' onmouseover='javascript:onOverNewDocNumber(this);' onmouseout='javascript:onOutNewDocNumber(this);' &gt;");
        }
        treeStr.append(Util.toScreen(newsubcount,user.getLanguage()));
	if(Util.getIntValue(newsubcount,0)>0)
        treeStr.append("&lt;img src='/images/BDNew_wev8.gif' align=absbottom &gt;");
       	treeStr.append("&lt;/span&gt;");
       	
       	treeStr.append(" / ");
       	
        if(Util.getIntValue(subcount)>0){
        	treeStr.append("&lt;span onclick='javascript:onClickDocNumber("+subid+","+1+");' style='cursor:hand;color=#0000FF' onmouseover='javascript:onOverNewDocNumber(this);' onmouseout='javascript:onOutNewDocNumber(this);' &gt;");
        }
        treeStr.append(Util.toScreen(subcount,user.getLanguage()));

       	treeStr.append("&lt;/span&gt;");
        treeStr.append(" Docs");
        treeStr.append(") &lt;span&gt;");
        treeStr.append("\" ");
        //action
        treeStr.append("action=\"");
        treeStr.append("javascript:onClickCategory("+subid+","+1+");");
        treeStr.append("\" ");
        //icon
        treeStr.append("icon=\"/images/xp/folder_wev8.png\" ");
        //openIcon
        treeStr.append("openIcon=\"/images/xp/openfolder_wev8.png\" ");
        //target
        treeStr.append("target=\"_self\" ");
        //src
        treeStr.append("src=\"DocSummaryTreeLeftXML.jsp?subcategory="+subid+"\" ");
        
        treeStr.append(" />");
        
        out.println(treeStr.toString());
 	}
	
} else if(!"".equals(subcategory)){
	
	SecCategoryComInfo.setTofirstRow();
	
	while(SecCategoryComInfo.next()){
 		treeStr = new StringBuffer();
 		
        String cursubid = SecCategoryComInfo.getSubCategoryid();
        if(!cursubid.equals(subcategory))
			continue;
        
 		String secname=SecCategoryComInfo.getSecCategoryname();
        String secid = SecCategoryComInfo.getSecCategoryid();
        String seccount="0";
        String newseccount="0";

        int thesecidindex = secids.indexOf( secid ) ;
        if( thesecidindex != -1 ) seccount  = ""+Util.getIntValue((String)seccounts.get(thesecidindex),0);
        if( thesecidindex != -1 ) newseccount  = ""+Util.getIntValue((String)newseccounts.get(thesecidindex),0);
		
        if(Util.getIntValue(seccount)==0) continue;

        //分目录
        treeStr.append("<tree ");
        //text
        treeStr.append("text=\"");
		secname=Util.replace(secname,"&quot;","\"",0);
        secname=Util.replace(secname,"&lt;","<",0);
        secname=Util.replace(secname,"&gt;",">",0);
		secname=Util.replace(secname,"&apos;","'",0);
        treeStr.append(
        		secname
        );
        //text(文档数)
       	treeStr.append("&lt;/span&gt;");
        treeStr.append(" (");
        
        if(Util.getIntValue(newseccount)>0){
        	treeStr.append("&lt;span onclick='javascript:onClickNewDocNumber("+secid+","+2+");' style='cursor:hand;color=#0000FF' onmouseover='javascript:onOverNewDocNumber(this);' onmouseout='javascript:onOutNewDocNumber(this);' &gt;");
        }
        treeStr.append(Util.toScreen(newseccount,user.getLanguage()));
	if(Util.getIntValue(newseccount,0)>0)
        treeStr.append("&lt;img src='/images/BDNew_wev8.gif' align=absbottom &gt;");
       	treeStr.append("&lt;/span&gt;");
       	
       	treeStr.append(" / ");
       	
        if(Util.getIntValue(seccount)>0){
        	treeStr.append("&lt;span onclick='javascript:onClickDocNumber("+secid+","+2+");' style='cursor:hand;color=#0000FF' onmouseover='javascript:onOverNewDocNumber(this);' onmouseout='javascript:onOutNewDocNumber(this);' &gt;");
        }
        treeStr.append(Util.toScreen(seccount,user.getLanguage()));
        
       	treeStr.append("&lt;/span&gt;");
        treeStr.append(" Docs");
        treeStr.append(") &lt;span&gt;");
        treeStr.append("\" ");
        //action
        treeStr.append("action=\"");
        treeStr.append("javascript:onClickCategory("+secid+","+2+");");
        treeStr.append("\" ");
        //icon
        treeStr.append("icon=\"/images/xp/folder_wev8.png\" ");
        //openIcon
        treeStr.append("openIcon=\"/images/xp/openfolder_wev8.png\" ");
        //target
        treeStr.append("target=\"_self\" ");
        //src
        //treeStr.append("src=\"DocSummaryTreeLeftXML.jsp?seccategory="+secid+"\" ");
        
        treeStr.append(" />");
        
        out.println(treeStr.toString());
	}
	
}
%>
</tree>