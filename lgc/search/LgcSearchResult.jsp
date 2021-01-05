
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LgcSearchComInfo" class="weaver.lgc.search.LgcSearchComInfo" scope="session" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="AssetTypeComInfo" class="weaver.lgc.maintenance.AssetTypeComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid = ""+user.getUID();
RecordSet.executeProc("LgcSearchDefine_SelectByID",userid);
RecordSet.next() ;
int perpage= RecordSet.getInt("perpage");
String assetcolname[] = new String[6] ;
String assetcolvalue[] = new String[6] ;
for(int i=1 ; i<7 ; i++) {
String tempstr = Util.null2String(RecordSet.getString("assetcol"+i));
if(tempstr.equals("")) {
	assetcolname[i-1]="";
	assetcolvalue[i-1]="";
	continue ;
}
String tempcol[] = Util.TokenizerString2(tempstr,"|");
assetcolname[i-1] = tempcol[0] ;
assetcolvalue[i-1] = tempcol[1] ;
}

String imagefilename = "/images/hdLOGSearch_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(535,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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
		<td valign="top"><DIV>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:window.location='LgcSearch.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",javascript:window.location='LgcSearchDefine.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>


</DIV>

	  <TABLE class=ListStyle cellspacing=1>
        <TBODY>
	    <TR class=Header>
			<%int colNum=0;
            for(int i=0 ; i<6 ; i++) {
				if(assetcolname[i].equals("")) continue ;
                else
                    colNum++;
			%>
			<th><%=SystemEnv.getHtmlLabelName(Util.getIntValue(assetcolname[i]),user.getLanguage())%></th>
		    <%}%>
	    </TR>
<TR class=Line><TD colSpan=<%=colNum%>></TD></TR>

<%
boolean isLight = false;
int start=Util.getIntValue(request.getParameter("start"),0);

if(perpage<=1 )	perpage=10;

String tablename = "lgctemptable"+ Util.getNumberRandom() ;

String sqlstr = "select LgcAsset.id,assetmark,barcode,seclevel,assetimageid,assettypeid,"+
						"assetunitid,assetversion,counttypeid,assortmentid,assetname,assetcountyid,"+
						"startdate,enddate,departmentid,resourceid,assetremark,currencyid,"+
						"salesprice,costprice,createrid,createdate,lastmoderid,lastmoddate " +
						"into "+tablename+" from LgcAsset,LgcAssetCountry " + LgcSearchComInfo.FormatSQLSearch() ;
                

RecordSet.executeSql(sqlstr);

RecordSet.executeSql(" select count(id) from "+ tablename );
RecordSet.next() ;
int recordersize = RecordSet.getInt(1) ;

String sqltemp="delete from "+tablename+" where id in(select top "+(start-1)+" id from "+ tablename+ ")";
RecordSet.executeSql(sqltemp);
sqltemp="select top "+perpage+" * from "+ tablename;
RecordSet.executeSql(sqltemp);
RecordSet.executeSql("drop table "+ tablename);

while(RecordSet.next())
{
if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%	}else{%>
	<TR CLASS=DataLight>
<%}

int thefirst = 0 ;

for(int i=0; i<6 ; i++ ) {
	if(assetcolvalue[i].equals("")) continue ;
	String theassetid = RecordSet.getString("id") ;
	String thecountry = RecordSet.getString("assetcountyid") ;
	String thevalue = Util.toScreen(RecordSet.getString(assetcolvalue[i]),user.getLanguage()) ;
	if(thefirst == 0) 
		thevalue="<a href='/lgc/asset/LgcAsset.jsp?paraid="+theassetid+"&assetcountryid="+thecountry+"'>"+thevalue+"</a>";
	if(assetcolvalue[i].equals("assetimageid")) {
		if(!thevalue.equals("0")) thevalue="<img src='/weaver/weaver.file.FileDownload?fileid="+Util.getFileidOut(thevalue)+"'> " ;
		else thevalue= "" ;
	}
	if(assetcolvalue[i].equals("assettypeid")) 
		thevalue= Util.toScreen(AssetTypeComInfo.getAssetTypename(thevalue),user.getLanguage()) ;
	if(assetcolvalue[i].equals("assetunitid")) 
		thevalue= Util.toScreen(AssetUnitComInfo.getAssetUnitname(thevalue),user.getLanguage()) ;
	if(assetcolvalue[i].equals("assortmentid")) 
		thevalue= Util.toScreen(AssetAssortmentComInfo.getAssortmentName(thevalue),user.getLanguage()) ;
	if(assetcolvalue[i].equals("assetcountyid")) 
		thevalue= Util.toScreen(CountryComInfo.getCountrydesc(thevalue),user.getLanguage());
	if(assetcolvalue[i].equals("departmentid")) 
		thevalue= "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+thevalue+"'>" +
				  Util.toScreen(DepartmentComInfo.getDepartmentname(thevalue),user.getLanguage())+"</a>" ;
	if(assetcolvalue[i].equals("resourceid")) 
		thevalue= "<a href='/hrm/resource/HrmResource.jsp?id="+thevalue+"'>"+
				  Util.toScreen(ResourceComInfo.getResourcename(thevalue),user.getLanguage())+"</a>" ;
	if(assetcolvalue[i].equals("currencyid")) 
		thevalue= Util.toScreen(CurrencyComInfo.getCurrencyname(thevalue),user.getLanguage()) ;
	if(assetcolvalue[i].equals("createrid")) 
		thevalue= "<a href='/hrm/resource/HrmResource.jsp?id="+thevalue+"'>"+
				  Util.toScreen(ResourceComInfo.getResourcename(thevalue),user.getLanguage())+"</a>" ;
	if(assetcolvalue[i].equals("lastmoderid")) 
		thevalue= "<a href='/hrm/resource/HrmResource.jsp?id="+thevalue+"'>"+
				  Util.toScreen(ResourceComInfo.getResourcename(thevalue),user.getLanguage())+"</a>" ;
	
	thefirst ++ ;
%>
			<td><%=thevalue%></td>
<%}%>
    </tr>
<%	
	isLight = !isLight;
}%>

   <TR class=header> 
    <%
    String linkstr = "LgcSearchResult.jsp?perpage="+perpage;
    %>
    <TD colspan=<%=colNum%> align=center noWrap style="FONT-SIZE: 7pt"><%=Util.makeNavbar(start, recordersize , perpage, linkstr)%></TD>
  </TR>      
      </TBODY>

	  </TABLE>
	  </TABLE>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
</html>
