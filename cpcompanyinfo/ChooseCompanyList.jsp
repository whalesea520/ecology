<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<base target="_self">
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var dialog =  parent.parent.dialog;
	console.log("dialog:"+dialog);
</script>
</HEAD>


<%
	String companyid = Util.null2String(request.getParameter("companyid"));
	String se_fieldname = Util.null2String(request.getParameter("se_fieldname"));
	String se_fielddesc = Util.null2String(request.getParameter("se_fielddesc"));
	String sql="";
	if("sqlserver".equals(rs.getDBType())){
		 sql = "select t1.*,(case substring(t1.archivenum,0,1) when 'L' then 1 when 'H' then 2 when 'R' then 3 when 'W' then 4 end ) as ablity from CPCOMPANYINFO t1 where t1.isdel='T' and t1.companyid !='"+companyid+"' ";
	}else{
		 sql = "select t1.*,(case substr(t1.archivenum,0,1) when 'L' then 1 when 'H' then 2 when 'R' then 3 when 'W' then 4 end ) as ablity from CPCOMPANYINFO t1 where t1.isdel='T' and t1.companyid !='"+companyid+"' ";
	}
	if(!"".equals(se_fieldname)){
		sql+=" and ARCHIVENUM like '%"+se_fieldname+"%'";
	}
	if(!"".equals(se_fielddesc)){
		sql+=" and COMPANYNAME like '%"+se_fielddesc+"%'";
	}
	sql+=" order by ablity asc,t1.archivenum asc";
	//System.out.println("执行的sql"+sql);
	rs.execute(sql);
	int i = 1;
%>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:window.parent.onseach(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:window.parent.onClean(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="/cpcompanyinfo/ChooseCompanyList.jsp" method="post"  id="SearchForm">
	<input type="hidden" name="companyid"  value="<%=companyid %>" >
	
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="*">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top" width="100%">
						<table width=100% class="viewform">
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						<tr>
						<TD ><%=SystemEnv.getHtmlLabelNames("128191",user.getLanguage())%></TD>
						<TD  class=field>
								<input type='text' name='se_fieldname' value='<%=se_fieldname%>'>
						</TD>
						<TD ><%=SystemEnv.getHtmlLabelNames("1976",user.getLanguage())%></TD>
						<TD  class=field>
								<input type='text' name='se_fielddesc' value='<%=se_fielddesc%>'>
						</TD>
						</TR>
						<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=2></TD></TR>
						</table>

						<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'  style="table-layout: fixed;">
								<TR class=DataHeader>
								<TH style="width: 0px"></TH>
								<TH width=50% ><%=SystemEnv.getHtmlLabelNames("128191",user.getLanguage())%></TH>
								<TH width=50% ><%=SystemEnv.getHtmlLabelNames("1976",user.getLanguage())%></TH>
								</tr>
								<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> 
									<%
										while(rs.next()){
											if(i%2==0){
												out.println("<tr class=DataDark>");
											}else{
												out.println("<tr class=DataLight>");
											}
									%>
										<td width="0px" height="25px"  align="center">
											<%=rs.getString("COMPANYID") %>
										</td>
										<td width="50px" height="25px"  align="center">
											<%=rs.getString("ARCHIVENUM") %>
										</td>
										<td>
											<%=rs.getString("COMPANYNAME") %>
										</td>
									</tr>
										<TR class=Line  style='height:1px;'><th colspan='3' ></Th></TR> 
									<%
										i++;
									}
									%>	
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
</form>
</BODY></HTML>

<SCRIPT LANGUAGE="javascript">
var ids = "";
var names = "";
//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
					ids = jQuery(this).find("td:eq(0)").text();
			   		names =jQuery(this).find("td:eq(2)").text();
			   		
			   		
			   		if( dialog){
			 
					    	var returnjson = {id: ids,name: names};
					    	try{
					            dialog.callback(returnjson);
					       }catch(e){}
						  	
					 }else{
					 
						window.parent.returnValue = {id: ids,name: names};
					    window.parent.close();
					}  
			   		
		}
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});
function onSubmit() {
		$G("SearchForm").submit()
}
function onClean()
{

	if(dialog){
			 
	    	var returnjson = {id: "0",name: ""};
	    	try{
	            dialog.callback(returnjson);
	       }catch(e){}
		  	
	 }else{
		window.parent.returnValue = {id: "0",name: ""};
	     window.parent.close();
	}  

}
function onseach(){
	$("#SearchForm").submit()
}
</script>