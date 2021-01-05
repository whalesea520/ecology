
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
if(true){
	response.sendRedirect("/docs/search/DocMain.jsp?urlType=6&"+request.getQueryString());
	return;
}
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(92,user.getLanguage());
String needfav ="1";
String needhelp ="";

String displayUsage=Util.null2o(request.getParameter("displayUsage"));
String showtype = Util.null2o(request.getParameter("showtype"));
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
String selectArr = "";
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
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectedContent = info.getSelectedContent();
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
%>
<BODY>

<%-- edited by wdl 2006-06-01 树型显示  --%>
<%if(showtype.equals("1")){%>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width=30%>
<IFRAME name=leftframe id=leftframe src="DocSummaryTreeLeft.jsp?displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width=1%>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width=70%>
<IFRAME name=contentframe id=contentframe src="DocSummaryList.jsp?showtype=1&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
<% 
	return;
}
%>
<%-- edited by wdl end --%>

<%-- edited by yinshun.xu 2006-07-18 按组织结构显示  --%>
<%if(showtype.equals("2")){%>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width=30%>
<IFRAME name=leftframe id=leftframe src="DocSearchByOrgLeft.jsp?rightStr=Car:Maintenance" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width=1%>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width=70%>
<IFRAME name=contentframe id=contentframe src="DocSearchTemp.jsp?list=all&showtype=2&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
<% 
	return;
}
%>
<%-- edited by yinshun.xu end --%>

<%-- edited by fanggsh 2006-07-23 for TD4707 按树状字段显示 begin  --%>
<%if(showtype.equals("3")){%>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width=30%>
<IFRAME name=leftframe id=leftframe src="DocSearchByTreeDocFieldLeft.jsp" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width=1%>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width=70%>
<IFRAME name=contentframe id=contentframe src="DocSearchTemp.jsp?list=all&showtype=3" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
<% 
	return;
}
%>
<%-- edited by fanggsh 2006-07-23 for TD4707 按树状字段显示 end --%>




<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.frmmain.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(19253,user.getLanguage())+",javascript:treeView(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(19466,user.getLanguage())+",javascript:viewbyOrganization(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

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

<%
String logintype = user.getLogintype();
String owner=Util.null2String(request.getParameter("owner"));
String departmentid=Util.null2String(request.getParameter("departmentid"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String todate=Util.fromScreen(request.getParameter("todate"),user.getLanguage());
String publishtype=Util.fromScreen(request.getParameter("publishtype"),user.getLanguage());

String ownername=ResourceComInfo.getResourcename(owner);
String departmentname=DepartmentComInfo.getDepartmentname(departmentid);
String departmentmark=DepartmentComInfo.getDepartmentmark(departmentid);
%>

<form name=frmmain method=post action="DocSummary.jsp">
<input type="hidden" name="displayUsage" value="<%=displayUsage%>">
<input type="hidden" name="showtype" value="<%=showtype%>">
<input type="hidden" name="fromadvancedmenu" value="<%=fromAdvancedMenu%>">
<input type="hidden" name="selectedContent" value="<%=selectedContent%>">
<input type="hidden" name="infoId" value="<%=infoId%>">

<table width="100%" CLASS="ViewForm">
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="10%">
  <col width="20%">
  <col width="10%">
  <col width="30%">
  <tr class=Title><th colspan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th></tr>
<TR style="height:1px;"><TD class=Line1 colSpan=6></TD></TR>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></td>
     <td class=field>
     <select name=publishtype size=1 class=InputStyle>
     <option value="">&nbsp;</option>
     <option value="1" <%if(publishtype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
     <option value="2" <%if(publishtype.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></option>
     <option value="3" <%if(publishtype.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
     </select>
     </td>
     <td><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></td>
     <td class=field><button type="button"  class=calendar onclick="getfromDate()"></button>
     <span id=fromdatespan><%=Util.toScreen(fromdate,user.getLanguage())%></span><input type=hidden name="fromdate" value="<%=fromdate%>"></td>
     <td><%=SystemEnv.getHtmlLabelName(617,user.getLanguage())%></td>
     <td class=field><button type="button"  class=calendar onclick="gettoDate()"></button>
     <span id=todatespan><%=Util.toScreen(todate,user.getLanguage())%></span><input type=hidden name="todate" value="<%=todate%>"></td>
  </tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
     <td class=field>
      <input type=hidden class="wuiBrowser" name="departmentid" value="<%=departmentid%>" 
      _displayText="<%=(!departmentid.equals(""))?Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid+""),user.getLanguage()):""%>" 
      _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="></td>
	 <!--部门-->
     <td><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></td>
     <td class=field>
     	
	     <input type=hidden  class="wuiBrowser" name="owner" id="owner" 
	     	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	     	_displayText="<%=Util.toScreen(ownername,user.getLanguage()) %>"
	     	 value="<%=owner%>"/>
	     
     </td>
     

</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
<%}%>
</table>
</form>
<br>
<table class=ViewForm> 
<%
String whereclause="";
String sql="";
        
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

/* added by wdl 2006-08-28 不显示历史版本 */
whereclause+=" and (ishistory is null or ishistory = 0) ";
/* added end */

/* added by wdl 2006-06-16 left menu advanced menu */
if((fromAdvancedMenu==1)&&!advanids.equals(""))
	whereclause+=" and seccategory in (" + advanids + ") ";

/* added end */

ArrayList maincounts=new ArrayList();
ArrayList newmaincounts=new ArrayList();
ArrayList subcounts=new ArrayList();
ArrayList newsubcounts=new ArrayList();
ArrayList mainids=new ArrayList();
ArrayList subids=new ArrayList();

ArrayList maniread=new ArrayList();
ArrayList subread=new ArrayList();

if(logintype.equals("1")){ //内部用户的处理



 //用户的未读文档
	//sql="select  distinct docid,(select maincategory  from docdetail where id=docid) as mm,(select subcategory  from docdetail where id=docid)  as tt from docReadTag  where userid= "+user.getUID()+" and usertype=1 union select id,maincategory as mm ,subcategory as tt from docdetail where doccreaterid =  "+user.getUID()+" and usertype ='1' ";

	sql="select count(distinct t1.id),t1.maincategory,t1.subcategory from (select a.*, tt.sharelevel from docdetail a, "+tables+" tt where a.id=tt.sourceid) t1 left join docReadTag t2 on t1.id=t2.docid where ((docstatus = 7 and ( (t1.sharelevel>1 or doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) )   " ;
	sql+=whereclause;
    sql+=" group by t1.maincategory,t1.subcategory order by t1.maincategory,t1.subcategory ";
   //out.print(sql);
	RecordSet.executeSql(sql);
	 while(RecordSet.next())
	{
     
	 

		//分目录的文档
        subread.add(RecordSet.getString("subcategory"));
        newsubcounts.add(RecordSet.getString(1));
        //主目录的文档
		String tempmainid = ""+Util.null2String( RecordSet.getString(2) ) ; 
	    String maincount = ""+Util.null2String( RecordSet.getString(1) ) ; 
	    int tempmainidindex = maniread.indexOf( tempmainid ) ;
		if (tempmainidindex==-1)
		{
		maniread.add(tempmainid);
		newmaincounts.add(maincount);
		}
		else
		{
		int mainallcount = Util.getIntValue((String)newmaincounts.get(tempmainidindex), 0)+Util.getIntValue(maincount,0) ;
		newmaincounts.set(tempmainidindex,""+mainallcount);
		
		}

	 
	 }


    //目录下的文章
    sql="select count(t1.id) count,t1.maincategory,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5'))   and t1.id=t2.sourceid";
	sql+=whereclause;
    sql+=" group by t1.maincategory,t1.subcategory order by t1.maincategory,t1.subcategory ";


    RecordSet.executeSql(sql);

    while(RecordSet.next()){
       //分目录的文档
    	if(RecordSet.getInt("maincategory")==0){ //过滤错误数据 
 			continue;
 		}
        subids.add(RecordSet.getString("subcategory"));
        subcounts.add(RecordSet.getString("count"));
        //主目录的文档
		String tempmainid = ""+Util.null2String( RecordSet.getString(2) ) ; 
	    String maincount = ""+Util.null2String( RecordSet.getString(1) ) ; 
	    int tempmainidindex = mainids.indexOf( tempmainid ) ;
		if (tempmainidindex==-1)
		{
		mainids.add(tempmainid);
		maincounts.add(maincount);
		}
		else
		{
		int mainallcount = Util.getIntValue((String)maincounts.get(tempmainidindex), 0)+Util.getIntValue(maincount,0) ;
		maincounts.set(tempmainidindex,""+mainallcount);
		
		}
    
    }

    //总的分目录下的文章
   /* sql = "select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and t1.maincategory!=0  and  t1.subcategory!=0 and  t1.seccategory!=0 and t1.id=t2.sourceid";
    sql+=whereclause;
    sql+=" group by t1.subcategory order by t1.subcategory ";

    RecordSet.executeSql(sql);

    while(RecordSet.next()){
        subids.add(RecordSet.getString("subcategory"));
        subcounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newsubcounts.add(RecordSet.getString("count")) ;
    }
    

    //刘煜改为总的主目录 看过的文章
    
    sql = "select count(distinct t1.id) count,t1.maincategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on t1.id=t2.docid where t1.id=t3.sourceid and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) ) ";
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

    //刘煜改为总的分目录 看过的文章 
    sql = "select count(distinct t1.id) count,subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on  t1.id=t2.docid where t1.id=t3.sourceid and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) ) ";

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
*/
} else { //不用内部用户时的情况

    //总的主目录下的文章
    sql="select count(t1.id) count,t1.maincategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.sourceid ";
    sql+=whereclause;
    sql+=" group by t1.maincategory order by t1.maincategory "; 
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        mainids.add(RecordSet.getString("maincategory"));
        maincounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newmaincounts.add(RecordSet.getString("count")) ;
    }

    //总的分目录下的文章
    sql="select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.sourceid";
    sql += whereclause;
    sql += " group by t1.subcategory order by t1.subcategory ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        subids.add(RecordSet.getString("subcategory"));
        subcounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newsubcounts.add(RecordSet.getString("count")) ;
    }

    
    //刘煜修改 总的主目录 看过的文章
  /*  sql = "select count(distinct t1.id) count,maincategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on  t1.id=t2.docid where t1.id=t3.sourceid and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) ) ";
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
    
    //刘煜修改 总的分目录下 看过的文章
    sql = "select count(distinct t1.id) count,subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on  t1.id=t2.docid where t1.id=t3.sourceid and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and   ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) ) ";

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
	*/

	//sql="select  distinct docid,(select maincategory  from docdetail where id=docid) as mm,(select subcategory  from docdetail where id=docid)  as tt from docReadTag  where userid= "+user.getUID()+" and usertype=1 union select id,maincategory as mm ,subcategory as tt from docdetail where doccreaterid =  "+user.getUID()+" and usertype ='1' ";

	sql="select count(distinct t1.id),t1.maincategory,t1.subcategory from DocDetail  t1 left join docReadTag t2 on t1.id=t2.docid where ((docstatus = 7 and ( (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) )   and t1.id in (select sourceid from "+tables+" tt)" ;
	sql+=whereclause;
    sql+=" group by t1.maincategory,t1.subcategory order by t1.maincategory,t1.subcategory ";
   //out.print(sql);
	RecordSet.executeSql(sql);
	 while(RecordSet.next())
	{
     
	 

		//分目录的文档
        subread.add(RecordSet.getString("subcategory"));
        newsubcounts.add(RecordSet.getString(1));
        //主目录的文档
		String tempmainid = ""+Util.null2String( RecordSet.getString(2) ) ; 
	    String maincount = ""+Util.null2String( RecordSet.getString(1) ) ; 
	    int tempmainidindex = maniread.indexOf( tempmainid ) ;
		if (tempmainidindex==-1)
		{
		maniread.add(tempmainid);
		newmaincounts.add(maincount);
		}
		else
		{
		int mainallcount = Util.getIntValue((String)newmaincounts.get(tempmainidindex), 0)+Util.getIntValue(maincount,0) ;
		newmaincounts.set(tempmainidindex,""+mainallcount);
		
		}

	 
	 }

}

int maincate = 0;//MainCategoryComInfo.getMainCategoryNum();
while(MainCategoryComInfo.next()){
	String curmainid=MainCategoryComInfo.getMainCategoryid();
	if(selectArr.indexOf("M"+curmainid+"|")==-1 && fromAdvancedMenu==1) continue;
	if(mainids.indexOf(curmainid)==-1) continue;
	maincate++;
}
MainCategoryComInfo.setTofirstRow();

int rownum = (maincate+1)/2;
%>

  <tr class=Title><th colspan=2><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></th></tr>
<TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR>
  <tr>
    <td width="50%" align=left valign=top>
 <%
 	int i=0;
 	int needtd=rownum;
 	while(MainCategoryComInfo.next()){
 		String mainname=MainCategoryComInfo.getMainCategoryname();
 		String mainid = MainCategoryComInfo.getMainCategoryid();
 		
        /* added by wdl 2006-06-16 left menu advanced menu */
	 	if(selectArr.indexOf("M"+mainid+"|")==-1 && fromAdvancedMenu==1) continue;
	 	/* added end */
	 	if(mainids.indexOf(mainid)==-1) continue;

	 	String maincount="0";
 		String newmaincount="0";
 		needtd--;
 %>
 	<!-- table -->
 	    <UL>
 <%
        int themainidindex = mainids.indexOf( mainid ) ;
        if( themainidindex != -1 ) maincount  = ""+Util.getIntValue((String)maincounts.get(themainidindex),0);
         	  
 	  //如果没有文档主类也不显示  
        if(!maincount.equals("0")){
 	    
 %>
        <LI><a href="DocSummary2.jsp?loginType=<%=logintype%>&owner=<%=owner%>&fromdate=<%=fromdate%>&todate=<%=todate%>&departmentid=<%=departmentid%>&publishtype=<%=publishtype%>&mainid=<%=mainid%>&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>"><%=Util.toScreen(mainname,user.getLanguage())%></a>
 	    (<a href="DocSearchTemp.jsp?loginType=<%=logintype%>&toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&maincategory=<%=mainid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>"><%=Util.toScreen(maincount,user.getLanguage())%> Docs</a>) 
<%      
        
            //if( themainidindex != -1 ) newmaincount  = ""+Util.getIntValue((String)newmaincounts.get(themainidindex),0);
 			int tempmainidindexs = maniread.indexOf( mainid ) ;
            if( tempmainidindexs != -1 ) newmaincount  = ""+(Util.getIntValue(maincount,0)-Util.getIntValue((String)newmaincounts.get(tempmainidindexs),0));
		  	else newmaincount=maincount;
 	        if(!newmaincount.equals("0")){
%>
        <font color=red><a href="DocSearchTemp.jsp?loginType=<%=logintype%>&isMainOrSub=main&isNew=yes&toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&maincategory=<%=mainid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>"><%=Util.toScreen(newmaincount,user.getLanguage())%></a></font><IMG src="/images/BDNew_wev8.gif" align=absbottom>
<%          }   %>
 	    <UL>
<%
			while(SubCategoryComInfo.next()){
                String curmainid = SubCategoryComInfo.getMainCategoryid();
                if(!curmainid.equals(mainid)) continue;

 	    		String subname=SubCategoryComInfo.getSubCategoryname();
                String subid = SubCategoryComInfo.getSubCategoryid();
                String subcount="0";
                String newsubcount="0";
                
	 	        /* added by wdl 2006-06-16 left menu advanced menu */
        	 	if(selectArr.indexOf("S"+subid+"|")==-1 && fromAdvancedMenu==1) continue;
        	 	/* added end */

        	 	int thesubidindex = subids.indexOf( subid ) ;
                if( thesubidindex != -1 ) subcount  = ""+Util.getIntValue((String)subcounts.get(thesubidindex),0);
	 	        if(!subcount.equals("0")){
%>
        <LI><a href="DocSummary3.jsp?loginType=<%=logintype%>&owner=<%=owner%>&fromdate=<%=fromdate%>&todate=<%=todate%>&departmentid=<%=departmentid%>&publishtype=<%=publishtype%>&mainid=<%=mainid%>&subid=<%=subid%>&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>"><%=Util.toScreen(subname,user.getLanguage())%></a>
	 	(<a href="DocSearchTemp.jsp?loginType=<%=logintype%>&toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&subcategory=<%=subid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>"><%=Util.toScreen(subcount,user.getLanguage())%> Docs</a>)
<%
                   // if( thesubidindex != -1 ) newsubcount  = ""+Util.getIntValue((String)newsubcounts.get(thesubidindex),0);
		            int temptempidindexs = subread.indexOf( subid ) ;
                    if( temptempidindexs != -1 ) newsubcount  = ""+(Util.getIntValue(subcount,0)- Util.getIntValue((String)newsubcounts.get(temptempidindexs),0));
					else newsubcount=subcount;
                    if(!newsubcount.equals("0")){
%>
        <font color=red><a href="DocSearchTemp.jsp?loginType=<%=logintype%>&isMainOrSub=sub&isNew=yes&toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&subcategory=<%=subid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>"><%=Util.toScreen(newsubcount,user.getLanguage())%></a></font><IMG src="/images/BDNew_wev8.gif" align=absbottom>
<%
                    }
                }
 	    	}
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

<script language="JavaScript">

function onShowDepartment(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$("input[name=departmentid]").val());
	if (datas) {
        if (datas.id!=""){
			$("#departmentspan").html(datas.name);
			$("input[name=departmentid]").val(datas.id);
        }
		else{
			$("#departmentspan").html("");
			$("input[name=departmentid]").val("");
		}
	}
}
function onShowResource(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(datas){
        if( datas.id!= "" ){
        	
			$("#ownerspan").html( "<a href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</a>");
			$("#owner").val(datas.id);
        }else{
        	$("#ownerspan").html("");
			$("#owner").val("");
		}
	}
}

function treeView(){
	location.href="/docs/search/DocSummary.jsp?showtype=1&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
}

function viewbyOrganization(){
	location.href="/docs/search/DocSummary.jsp?showtype=2&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
}

function viewByTreeDocField(){
	location.href="/docs/search/DocSummary.jsp?showtype=3";
}

</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>