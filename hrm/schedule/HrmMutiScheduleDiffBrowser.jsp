<%@ page import = "weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page" />
<jsp:useBean id = "WorkflowComInfo" class = "weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String id = Util.null2String(request.getParameter("id"));
String diffname = Util.null2String(request.getParameter("diffname"));
String diffdesc = Util.null2String(request.getParameter("diffdesc"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String salaryitem = Util.null2String(request.getParameter("salaryitem"));
String difftype = Util.null2String(request.getParameter("difftype"));
String difftime = Util.null2String(request.getParameter("difftime"));
String salaryable = Util.null2String(request.getParameter("salaryable"));
String counttype = Util.null2String(request.getParameter("counttype"));

String check_per = ","+Util.null2String(request.getParameter("diffids"))+",";

String diffids = "" ;
String diffnames ="";
String strtmp = "select id,diffname from HrmScheduleDiff ";
rs.executeSql(strtmp);
while(rs.next()){
	if(check_per.indexOf(","+rs.getString("id")+",")!=-1){
        diffids +="," + rs.getString("id");
        diffnames += ","+rs.getString("diffname");
	}
}


String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!diffname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where diffname like '%";
		sqlwhere += Util.fromScreen2(diffname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and diffname like '%";
		sqlwhere += Util.fromScreen2(diffname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!diffdesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where diffdesc like '%";
		sqlwhere += Util.fromScreen2(diffdesc,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and diffdesc like '%";
		sqlwhere += Util.fromScreen2(diffdesc,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!workflowid.equals("")&&!workflowid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where workflowid =";
		sqlwhere += Util.fromScreen2(workflowid,user.getLanguage());
		sqlwhere += " ";
	}
	else{
		sqlwhere += " and workflowid =";
		sqlwhere += Util.fromScreen2(workflowid,user.getLanguage());
		sqlwhere += " ";
	}
}
if(!salaryitem.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where salaryitem =";
		sqlwhere += Util.fromScreen2(salaryitem,user.getLanguage());
		sqlwhere += " ";
	}
	else{
		sqlwhere += " and salaryitem =";
		sqlwhere += Util.fromScreen2(salaryitem,user.getLanguage());
		sqlwhere += " ";
	}
}
if(!difftype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where difftype ="+Util.fromScreen2(difftype,user.getLanguage());		
	}
	else{
		sqlwhere += " and difftype ="+Util.fromScreen2(difftype,user.getLanguage());		
	}
}
if(!difftime.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where difftime ="+Util.fromScreen2(difftime,user.getLanguage());		
	}
	else{
		sqlwhere += " and difftime ="+Util.fromScreen2(difftime,user.getLanguage());		
	}
}
if(!salaryable.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where salaryable ="+Util.fromScreen2(salaryable,user.getLanguage());		
	}
	else{
		sqlwhere += " and salaryable ="+Util.fromScreen2(salaryable,user.getLanguage());		
	}
}

if(!counttype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where counttype ="+Util.fromScreen2(counttype,user.getLanguage());		
	}
	else{
		sqlwhere += " and counttype ="+Util.fromScreen2(counttype,user.getLanguage());		
	}
}


%>
<BODY>
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
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmMutiScheduleDiffBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input class=inputstyle type="hidden" name="diffids" value="">

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform>          
<TR class=Spacing>
    </TD>
</TR>
<TR>
    <TD ><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD class=field>
      <input class=inputstyle size=10 name=diffname value="<%=diffname%>">
    </TD>
<!--    <TD class=field>说明</TD>
    <TD class=field>
      <input size=10 name=diffdesc value="<%=diffdesc%>">
    </TD>
</tr>
<tr>
  <td>工作流</td>
  <td class=field>
    <button type="button" class=Browser onclick="onShowWorkflow('workflowidspan','workflowid')"></button>  
    <input type="hidden" name="workflowid" value="<%=workflowid%>">
    <SPAN id=workflowidspan>
     <%=WorkflowComInfo.getWorkflowname(workflowid)%>
    </SPAN>
  </td>
-->  
<!--
  <td>相关工资项目</td>
  <td class=field>
    <button type="button" class=Browser onclick="onShowSalaryItem('salaryitemspan','salaryitem')"></button>
    <input type="hidden" name="salaryitem" value="<%=salaryitem%>">
    <SPAN id=salaryitemspan>        
      <%=Util.toScreen(SalaryComInfo.getSalaryname(salaryitem),user.getLanguage())%>                
    </SPAN>
  </td>  
</tr>
<tr>
-->
      <td><%=SystemEnv.getHtmlLabelName(447,user.getLanguage())%></td>
      <td class=field>        
        <input class=inputstyle type="radio" name="difftype" value="0" <% if(difftype.equals("0")){%> checked<%}%>><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>  
        <input class=inputstyle type="radio" name="difftype" value="1" <% if(difftype.equals("1")){%> checked<%}%>><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%>                
      </td>
<!--            
    <TD >相关时间</TD>
    <TD class=Field>
      <select name=difftime value="<%=difftime%>">
        <option value="" <%if(difftime.equals("")){%>selected <%}%>></option>
        <option value=0 <%if(difftime.equals("0")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></option>
        <option value=1 <%if(difftime.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(458,user.getLanguage())%></option>
        <option value=2 <%if(difftime.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(370,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371,user.getLanguage())%></option>
      </select>
    </TD>  
</TR>
<TR>    
    <td>薪资计算</td>
    <TD class=Field>
      <select name=salaryable value="<%=salaryable%>">
        <option value="" <%if(salaryable.equals("")){%>selected <%}%>></option>
        <option value=0 <%if(salaryable.equals("0")){%>selected <%}%>>是</option>
        <option value=1 <%if(salaryable.equals("1")){%>selected <%}%>>否</option>        
      </select>
    </TD>    
    <TD >计算类型</TD>
    <td class=field>        
        <select name="counttype" size=1 value="<%=counttype%>">
          <option value="" <% if(counttype.equals("")){%> selected<%}%>></option>
          <option value="0" <% if(counttype.equals("0")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(452,user.getLanguage())%></option>
          <option value="1" <% if(counttype.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(459,user.getLanguage())%></option>
        </select>       
      </td>
-->        
</TR>

<TR class=Spacing style="height:1px;">
    <TD class=Line1 colspan=8>
    </TD>
</TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>
<TH width=5%></TH>
<TH width=55%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=40%><%=SystemEnv.getHtmlLabelName(447,user.getLanguage())%></TH>
</TR>
<%
int i=0;
sqlwhere = "select * from HrmScheduleDiff "+sqlwhere;
rs.execute(sqlwhere);
while(rs.next()){
    String theid = rs.getString("id");

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
	<TD style="display:none"><A HREF=#><%=theid%></A></TD>
    <%
	 String ischecked = "";
	 if(check_per.indexOf(","+theid+",")!=-1){
         ischecked = " checked ";
	 }%>
	<TD><input class=inputstyle type=checkbox name="check_per" value="<%=theid%>" <%=ischecked%>></TD>
	<TD><%=rs.getString("diffname")%></TD>
	<TD>
	  <%if(rs.getString("difftype").equals("1")){%><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%><%}%>	  <%if(rs.getString("difftype").equals("0")){%><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%><%}%>
	</TD>
<!--	
	<td>
	  <%if(rs.getString("difftime").equals("0")){%><%=SystemEnv.getHtmlLabelName(380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%><%}%> 
          <%if(rs.getString("difftime").equals("1")){%><%=SystemEnv.getHtmlLabelName(458,user.getLanguage())%><%}%>
          <%if(rs.getString("difftime").equals("2")){%><%=SystemEnv.getHtmlLabelName(370,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371,user.getLanguage())%><%}%>	
        </td>
        <td>
          <% if(rs.getString("salaryable").equals("1")){%>
            <%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
          <% } else {%>
            <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <% } %>
        </td>
        <td>
          <% if(rs.getString("counttype").equals("0")){%><%=SystemEnv.getHtmlLabelName(452,user.getLanguage())%><%}%>
          <% if(rs.getString("counttype").equals("1")){%><%=SystemEnv.getHtmlLabelName(459,user.getLanguage())%><%}%>
        </td>
-->        
</TR>
<%}%>
</TABLE>
</FORM>
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


<script language="javascript">

function CheckAll(checked) {
//	alert(diffids);
//	diffids = "";
//	diffnames = "";
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				diffids = diffids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		diffnames = diffnames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);
		}
 	}
 //	alert(diffids);
}

function doSearch()
{
    jQuery("input[name=diffids]").val(diffids);
    document.SearchForm.submit();
}
</script>

<script language="javascript">

diffids = "<%=diffids%>";
diffnames = "<%=diffnames%>";
function btnsub_onclick(){
	jQuery("input[name=diffids]").val(diffids);
	document.SearchForm.submit();
}
function btnok_onclick(){
	window.parent.parent.returnValue = {id:documentids,name:documentnames,owner:docowner,doccreatedates:doccreatedate}
	window.parent.parent.close()
}


//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"){
			var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   		obj.attr("checked", false);
		   		documentids = documentids.replace("," + jQuery(this).find("td:eq(0)").text(), "");
		   		documentnames = documentnames.replace("," + jQuery(this).find("td:eq(2)").text(), "");
		   		docowner = docowner.replace("," + jQuery(this).find("td:eq(4)").text(), "");
		   		doccreatedate = doccreatedate.replace("," + jQuery(this).find("td:eq(5)").text(),"");
		   	}else{
		   		obj.attr("checked", true);
		   		documentids = documentids + "," + $.trim(jQuery(this).find("td:eq(0)").text());
		   		documentnames = documentnames + "," + $.trim(jQuery(this).find("td:eq(2)").text());
		   		docowner=docowner+"," + $.trim(jQuery(this).find("td:eq(4)").text());
		   		doccreatedate=doccreatedate+"," + $.trim(jQuery(this).find("td:eq(5)").text());
		   	}

		}
		//window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		//	window.parent.close()
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})
});
</script>
</BODY>
</HTML>


