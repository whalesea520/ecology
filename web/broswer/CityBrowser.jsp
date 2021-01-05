<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("493",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->CityBrowser.jsp");
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}
		catch(e){}
	</script>
    </HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(493,user.getLanguage());
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
String needfav ="1";
String needhelp ="";
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String countryid = Util.null2String(request.getParameter("countryid"));
if (countryid.equals("") ){
countryid = user.getCountryid();
}
String provinceid = Util.null2String(request.getParameter("provinceid"));
if (provinceid.equals("") ){
provinceid = ""+user.getProvince();
}
String cityname = Util.null2String(request.getParameter("cityname"));
String sqlwhere = " ";
boolean isOracleCity = rs.getDBType().equals("oracle");

if(!sqlwhere1.equals("")){
    if(isOracleCity) {
	    sqlwhere += " and nvl(canceled,0) <> 1";
    }else{
        sqlwhere += " and ISNULL(canceled,0) <> 1";
    }
}else{
    if(isOracleCity) {
	    sqlwhere = " where nvl(canceled,0) <> 1";
    }else{
        sqlwhere = " where ISNULL(canceled,0) <> 1";
    }
}
if(!countryid.equals("") && !countryid.equals("0")){
		sqlwhere += " and countryid = ";
		sqlwhere += Util.fromScreen2(countryid,user.getLanguage());
}
if(!provinceid.equals("") && !provinceid.equals("0")){
		sqlwhere += " and provinceid = ";
		sqlwhere += Util.fromScreen2(provinceid,user.getLanguage());
}
if(!cityname.equals("")){
		sqlwhere += " and cityname like '%";
		sqlwhere += Util.fromScreen2(cityname,user.getLanguage());
		sqlwhere += "%'";
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CityBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum %>" />
 <DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:refresh(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnCancel_Onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onblur="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>	
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="country" name=countryid size=1 class=inputstyle onChange="refresh();" width=10 style="width:140px">
		     <option value=""></option>
		     <%-- <%while(CountryComInfo.next()){
		     	String selected="";
		     	String curcountryid=CountryComInfo.getCountryid();
		     	String curcountryname=CountryComInfo.getCountryname();
		     	if(curcountryid.equals(countryid+""))	selected="selected";
		     %> --%>
		     <%
		        boolean isOracleCountry = rs.getDBType().equals("oracle");
		        String countrySql = "";
		        if(isOracleCountry){
		        	countrySql = "select * from HrmCountry where nvl(canceled,0) <> 1";
		        }else{
		     		countrySql = "select * from HrmCountry where ISNULL(canceled,0) <> 1";
		     	}
		     	rs.execute(countrySql);
		     	while(rs.next()) {
		     		String selected="";
			     	String curcountryid=Util.null2String(rs.getString("id"));
			     	String curcountryname=Util.null2String(rs.getString("countryname"));
			     	if(curcountryid.equals(countryid+""))	selected="selected";
		      %>
		     <option value="<%=curcountryid%>" <%=selected%>><%=Util.toScreen(curcountryname,user.getLanguage())%></option>
		     <%
		     }%>
		     </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
		<wea:item>
			<select id='provinceid' name=provinceid size=1 onChange="refresh();" style="width:50px">
     <option value=""></option>
     <%-- <%
	  rs.executeProc("HrmProvince_Select",countryid);
	  while(rs.next()){
     	String selected="";
     	String curprovinceid=rs.getString(1);
     	String curprovincename=rs.getString(2);
     	if(curprovinceid.equals(provinceid+""))	selected="selected";
     %> --%>
     <%
     boolean isOracleProvince = rs.getDBType().equals("oracle");
	 String provinceSql = "";
     if(isOracleProvince){
      	provinceSql = "select * from HrmProvince where countryid = " + countryid + " and nvl(canceled,0) <> 1";
     }else{
     	provinceSql = "select * from HrmProvince where countryid = " + countryid + " and ISNULL(canceled,0) <> 1";
   	 }
   	 rs.execute(provinceSql);
     while(rs.next()) {
     	String selected="";
     	String curprovinceid=rs.getString(1);
     	String curprovincename=rs.getString(2);
     	if(curprovinceid.equals(provinceid+""))	selected="selected";
      %>
     <option value="<%=curprovinceid%>" <%=selected%>><%=Util.toScreen(curprovincename,user.getLanguage())%></option>
     <%
     }%>
     </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=cityname value='<%=cityname%>'></wea:item>
	</wea:group>
</wea:layout>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TH>
<%
int i=0;
String sqlstr = "";
int	perpage=20;

if(rs.getDBType().equals("oracle")){
		sqlstr = " (select * from (select distinct * from HrmCity " + sqlwhere + " order by id) where rownum<"+ (pagenum*perpage+2) + ") s";
}else{
		sqlstr = " (select distinct top "+(pagenum*perpage+1)+" * from HrmCity " + sqlwhere + " order by id) as s" ;
}

rs.executeSql("Select count(id) RecordSetCounts from "+sqlstr);

boolean hasNextPage=false;
int RecordSetCounts = 0;
if(rs.next()){
	RecordSetCounts = rs.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

String sqltemp="";
if(rs.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+sqlstr+" order by id desc) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+sqlstr+"  order by id desc";
}
rs.execute(sqltemp);
int totalline=1;
if(rs.last()){
do{
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD><%=rs.getString(1)%></TD>
	<TD><%=rs.getString(2)%></TD>	<TD><%=Util.toScreen(ProvinceComInfo.getProvincename(rs.getString(5)),user.getLanguage())%></TD>
	
</TR>
<%
        if(hasNextPage){
			totalline+=1;
			if(totalline>perpage)	break;
		}
    }while(rs.previous());
    }
%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(1258,user.getLanguage()) %>" onclick="doSkip(-1)" class="zd_btn_cancle" />
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(1259,user.getLanguage()) %>" onclick="doSkip(1)"  class="zd_btn_cancle" />
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">


function refresh(){
	jQuery('#pagenum').val(1);
	document.SearchForm.submit() ;
}

function doSkip(num){
	var hasNest = <%=(hasNextPage? 1 : 0) %>  == 1 ? true : false ;
	var curr = <%=pagenum%> ;
	var newPage = curr+num ;
	if(!hasNest && num > 0){
		// last page ;
		newPage = curr ;
	}else if(newPage < 1){
		newPage = 1 ; // first page
	}
	jQuery('#pagenum').val(newPage);
	document.SearchForm.submit()
}

function btnCancel_Onclick(){
	if(dialog){
		dialog.close();
	}else{ 
	  window.parent.close();
	}
}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
		}else{ 
		  window.parent.returnValue  = returnjson;
		  window.parent.close();
		}
		})
})


function submitClear()
{
	var returnjson = {id:"",name:""};
	if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
	}else{ 
	  window.parent.returnValue  = returnjson;
	  window.parent.close();
	}
}
  
</script>
</BODY></HTML>
