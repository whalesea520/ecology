<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
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

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(341,user.getLanguage())+"-"+Util.toScreen(mainname,user.getLanguage());
String needfav ="1";
String needhelp ="";

String displayUsage=Util.null2o(request.getParameter("displayUsage"));
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
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:frmmain.reset(),_top} " ;
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


<form name=frmmain method=post action="DocSummary2.jsp">
<input type=hidden name=mainid value="<%=mainid%>">
<input type="hidden" name="displayUsage" value="<%=displayUsage%>">
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
<TR><TD class=Line1 colSpan=6></TD></TR>
     <td><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></td>
     <td class=field>
     <select name=publishtype size=1 class=InputStyle>
     <option value="">&nbsp;</option>
     <option value="1" <%if(publishtype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1984,user.getLanguage())%></option>
     <option value="2" <%if(publishtype.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></option>
     <option value="3" <%if(publishtype.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
     </select>
     </td>
     <td><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></td>
     <td class=field><button type='button' class=calendar onclick="getfromDate()"></button>
     <span id=fromdatespan><%=Util.toScreen(fromdate,user.getLanguage())%></span><input type=hidden name="fromdate" value="<%=fromdate%>"></td>
     <td><%=SystemEnv.getHtmlLabelName(617,user.getLanguage())%></td>
     <td class=field><button type='button' class=calendar onclick="gettoDate()"></button>
     <span id=todatespan><%=Util.toScreen(todate,user.getLanguage())%></span><input type=hidden name="todate" value="<%=todate%>"></td>
  </tr>
<TR><TD class=Line colSpan=6></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
     <td class=field><button type='button' class=browser onclick="onShowDepartment()"></button>
     <span id=departmentspan><%=Util.toScreen((departmentmark+"-"+departmentname),user.getLanguage())%></span><input type=hidden name="departmentid" value="<%=departmentid%>"></td>
     <td><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></td>
     <td class=field><button type='button' class=browser onclick="onShowResource()"></button>
     <span id=ownerspan><a href="javaScript:openhrm(<%=owner%>);" onclick='pointerXY(event);'>
     <%=Util.toScreen(ownername,user.getLanguage())%></a></span><input type=hidden name="owner" value="<%=owner%>"></td>


</tr>
<TR><TD class=Line colSpan=6></TD></TR>
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

ArrayList maniread=new ArrayList();
ArrayList subread=new ArrayList();
if(logintype.equals("1")){  //内部用户的处理



//用户的未读文档
	//sql="select  distinct docid,(select maincategory  from docdetail where id=docid) as mm,(select subcategory  from docdetail where id=docid)  as tt from docReadTag  where userid= "+user.getUID()+" and usertype=1 union select id,maincategory as mm ,subcategory as tt from docdetail where doccreaterid =  "+user.getUID()+" and usertype ='1' ";

	sql="select count(distinct t1.id),t1.subcategory,t1.seccategory  from DocDetail  t1 left join docReadTag t2 on t1.id=t2.docid where t1.maincategory="+mainid+" and ((docstatus = 7 and ( (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) )   and t1.id in (select sourceid from "+tables+" tt)" ;
	sql+=whereclause;
    sql+=" group by t1.subcategory,t1.seccategory order by t1.subcategory,t1.seccategory";
   //out.print(sql);
	RecordSet.executeSql(sql);
	 while(RecordSet.next())
	{
     
	 

		//子目录的文档
        subread.add(RecordSet.getString("seccategory"));
        newseccounts.add(RecordSet.getString(1));
        //分目录的文档
		String tempmainid = ""+Util.null2String( RecordSet.getString(2) ) ; 
	    String maincount = ""+Util.null2String( RecordSet.getString(1) ) ; 
	    int tempmainidindex = maniread.indexOf( tempmainid ) ;
		if (tempmainidindex==-1)
		{
		maniread.add(tempmainid);
		newsubcounts.add(maincount);
		}
		else
		{
		int mainallcount = Util.getIntValue((String)newsubcounts.get(tempmainidindex), 0)+Util.getIntValue(maincount,0) ;
		newsubcounts.set(tempmainidindex,""+mainallcount);
		
		}

	 
	 }


    //目录下的文章
    sql="select count(t1.id) count,t1.subcategory,t1.seccategory from DocDetail  t1, "+tables+"  t2 where t1.maincategory="+mainid+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5'))   and t1.id=t2.sourceid";
	sql+=whereclause;
    sql+=" group by t1.subcategory,t1.seccategory order by t1.subcategory,t1.seccategory ";


    RecordSet.executeSql(sql);

    while(RecordSet.next()){
       //子目录的文档
        secids.add(RecordSet.getString("seccategory"));
        seccounts.add(RecordSet.getString("count"));
        //分目录的文档
		String tempmainid = ""+Util.null2String( RecordSet.getString(2) ) ; 
	    String maincount = ""+Util.null2String( RecordSet.getString(1) ) ; 
	    int tempmainidindex = subids.indexOf( tempmainid ) ;
		if (tempmainidindex==-1)
		{
		subids.add(tempmainid);
		subcounts.add(maincount);
		}
		else
		{
		int mainallcount = Util.getIntValue((String)subcounts.get(tempmainidindex), 0)+Util.getIntValue(maincount,0) ;
		subcounts.set(tempmainidindex,""+mainallcount);
		
		}
    
    }

   /* //总的分目录下的文章
    sql = "select count(t1.id) count,t1.subcategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and t1.id=t2.sourceid and t1.maincategory="+mainid+" ";
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
    sql = "select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and t1.id=t2.sourceid  and t1.maincategory="+mainid+" ";
    sql+=whereclause;
    sql+=" group by t1.seccategory order by t1.seccategory ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        secids.add(RecordSet.getString("seccategory"));
        seccounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newseccounts.add(RecordSet.getString("count")) ;
    }

    //刘煜改为总的分目录 看过的文章 
    sql = "select count(distinct t1.id) count,t1.subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+mainid+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) )" ;
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
    sql = "select count(distinct t1.id) count,t1.seccategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on   t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+mainid+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='1')  or ( t2.userid="+user.getUID()+" and t2.usertype=1 ) )" ;
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
    }*/
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
    sql="select count(t1.id) count,t1.seccategory from DocDetail  t1, "+tables+"  t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and t1.id=t2.sourceid and t1.maincategory="+mainid+" ";
    sql += whereclause;
    sql += " group by t1.seccategory order by t1.seccategory ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        secids.add(RecordSet.getString("seccategory"));
        seccounts.add(RecordSet.getString("count"));

        // 将未读的总数初始化为开始的总数
        newseccounts.add(RecordSet.getString("count")) ;
    }


    //刘煜改为总的分目录 看过的文章 
  /*  sql = "select count(distinct t1.id) count,t1.subcategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+mainid+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) )" ;
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
    sql = "select count(distinct t1.id) count,t1.seccategory from "+tables+"  t3 , DocDetail  t1 left join docReadTag t2 on  t1.id=t2.docid where t1.id=t3.sourceid and t1.maincategory="+mainid+" and ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) )" ;
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
	*/

	//sql="select  distinct docid,(select maincategory  from docdetail where id=docid) as mm,(select subcategory  from docdetail where id=docid)  as tt from docReadTag  where userid= "+user.getUID()+" and usertype=1 union select id,maincategory as mm ,subcategory as tt from docdetail where doccreaterid =  "+user.getUID()+" and usertype ='1' ";

	sql="select count(distinct t1.id),t1.subcategory,t1.seccategory  from DocDetail  t1 left join docReadTag t2 on t1.id=t2.docid where t1.maincategory="+mainid+" and ((docstatus = 7 and ( (doccreaterid="+user.getUID()+" or ownerid="+user.getUID()+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+user.getUID()+" and t1.usertype ='2')  or ( t2.userid="+user.getUID()+" and t2.usertype=2 ) )   and t1.id in (select sourceid from "+tables+" tt)" ;
	sql+=whereclause;
    sql+=" group by t1.subcategory,t1.seccategory order by t1.subcategory,t1.seccategory";
   //out.print(sql);
	RecordSet.executeSql(sql);
	 while(RecordSet.next())
	{
     
	 

		//子目录的文档
        subread.add(RecordSet.getString("seccategory"));
        newseccounts.add(RecordSet.getString(1));
        //分目录的文档
		String tempmainid = ""+Util.null2String( RecordSet.getString(2) ) ; 
	    String maincount = ""+Util.null2String( RecordSet.getString(1) ) ; 
	    int tempmainidindex = maniread.indexOf( tempmainid ) ;
		if (tempmainidindex==-1)
		{
		maniread.add(tempmainid);
		newsubcounts.add(maincount);
		}
		else
		{
		int mainallcount = Util.getIntValue((String)newsubcounts.get(tempmainidindex), 0)+Util.getIntValue(maincount,0) ;
		newsubcounts.set(tempmainidindex,""+mainallcount);
		
		}

	 
	 }
}


int subcate = 0;
while(SubCategoryComInfo.next()){
	String curmainid=SubCategoryComInfo.getMainCategoryid();
	String cursubid = SubCategoryComInfo.getSubCategoryid();
	if(selectArr.indexOf("S"+cursubid+"|")==-1 && fromAdvancedMenu==1) continue;
	if(mainid.equals(curmainid))
		subcate++;
}
SubCategoryComInfo.setTofirstRow();
int rownum = (subcate+1)/2;
%>

  <tr class=Title><th colspan=2><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%>:<%=Util.toScreen(mainname,user.getLanguage())%></th></tr>
<TR><TD class=Line1 colSpan=6></TD></TR>
  <tr>
    <td width="50%" align=left valign=top>
 <%
 	int i=0;
 	int needtd=rownum;
 	while(SubCategoryComInfo.next()){
 		String tempmainid=SubCategoryComInfo.getMainCategoryid();
 		if(!tempmainid.equals(mainid))	continue;
 		String subname=SubCategoryComInfo.getSubCategoryname();
 		String subid = SubCategoryComInfo.getSubCategoryid();
 		
        /* added by wdl 2006-06-16 left menu advanced menu */
	 	if(selectArr.indexOf("S"+subid+"|")==-1 && fromAdvancedMenu==1) continue;
	 	/* added end */
 		
 		String subcount="0";
 		String newsubcount="0";
 		needtd--;

        int thesubidindex = subids.indexOf( subid ) ;
        if( thesubidindex != -1 ) subcount  = ""+Util.getIntValue((String)subcounts.get(thesubidindex),0);
        if(!subcount.equals("0")){
 %>
 	<!-- table -->

 	    <UL><LI><a href="DocSummary3.jsp?loginType=<%=logintype%>&owner=<%=owner%>&fromdate=<%=fromdate%>&todate=<%=todate%>&departmentid=<%=departmentid%>&publishtype=<%=publishtype%>&mainid=<%=mainid%>&subid=<%=subid%>&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent %>"><%=Util.toScreen(subname,user.getLanguage())%></a>

        <!-- fixed by dongping for TD1422 (去掉了 "containreply=1")-->
        (<a href="DocSearchTemp.jsp?toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&subcategory=<%=subid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent %>"><%=Util.toScreen(subcount,user.getLanguage())%> Docs</a>)
<%
            //if( thesubidindex != -1 ) newsubcount  = ""+Util.getIntValue((String)newsubcounts.get(thesubidindex),0);
			int temptempidindexs = maniread.indexOf( subid ) ;
            if( temptempidindexs != -1 ) newsubcount  = ""+(Util.getIntValue(subcount,0)-Util.getIntValue((String)newsubcounts.get(temptempidindexs),0));
			else newsubcount=subcount;
            if(!newsubcount.equals("0")) {
%>
        <font color=red><a href="DocSearchTemp.jsp?toView=1&isNew=yes&containreply=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&subcategory=<%=subid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent %>"><%=Util.toScreen(newsubcount,user.getLanguage())%></a></font>
 	    <IMG src="/images/BDNew_wev8.gif" align=absbottom>
<%          }   %>
 	    <UL>
<%
			while(SecCategoryComInfo.next()){
                String cursubid = SecCategoryComInfo.getSubCategoryid();
                if(!cursubid.equals(subid)) continue;
 	    		String secname=SecCategoryComInfo.getSecCategoryname();
                String secid = SecCategoryComInfo.getSecCategoryid();
                String seccount="0";
                String newseccount="0";

	            int thesecidindex = secids.indexOf( secid ) ;
                if( thesecidindex != -1 ) seccount  = ""+Util.getIntValue((String)seccounts.get(thesecidindex),0);
	 	        if(!seccount.equals("0")){

%>
        <LI><a href="DocSearchTemp.jsp?toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&seccategory=<%=secid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent %>"><%=Util.toScreen(secname,user.getLanguage())%></a>
	 	(<a href="DocSearchTemp.jsp?toView=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&seccategory=<%=secid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent %>"><%=Util.toScreen(seccount,user.getLanguage())%> Docs</a>)
<%
                    //if( thesecidindex != -1 ) newseccount  = ""+Util.getIntValue((String)newseccounts.get(thesecidindex),0);
					int tempmainidindexs = subread.indexOf( secid ) ;
				    if( tempmainidindexs != -1 ) newseccount  = ""+(Util.getIntValue(seccount,0)-Util.getIntValue((String)newseccounts.get(tempmainidindexs),0));
					else newseccount=seccount;
                    if(!newseccount.equals("0")){
%>
        <font color=red><a href="DocSearchTemp.jsp?toView=1&isNew=yes&containreply=1&ownerid=<%=owner%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=departmentid%>&docpublishtype=<%=publishtype%>&seccategory=<%=secid%>&docstatus=6&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent %>"><%=Util.toScreen(newseccount,user.getLanguage())%></a></font>
	 	    <IMG src="/images/BDNew_wev8.gif" align=absbottom>
<%                  }
	 	        }
 	    	}
%>
 	    </ul>
	</ul>

 	<!-- /table -->	
<%
        }
 	    SecCategoryComInfo.setTofirstRow();
%>

<%
		if(needtd==0){
			needtd=subcate/2;
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>