<%@ page import = "weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page" />
<jsp:useBean id = "WorkflowComInfo" class = "weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%

String id = Util.null2String(request.getParameter("id"));
String diffname = Util.null2String(request.getParameter("diffname"));
String diffdesc = Util.null2String(request.getParameter("diffdesc"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String salaryitem = Util.null2String(request.getParameter("salaryitem"));
String difftype = Util.null2String(request.getParameter("difftype"));
String difftime = Util.null2String(request.getParameter("difftime"));
String salaryable = Util.null2String(request.getParameter("salaryable"));
String counttype = Util.null2String(request.getParameter("counttype"));

String scope = Util.null2String(request.getParameter("scope"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));


    //System.out.println("scope"+scope);
    //System.out.println("subcompanyid"+subcompanyid);
    //System.out.println("scopetype"+scopetype);
    //System.out.println("scopevalue"+scopevalue);
String supids=SubCompanyComInfo.getAllSupCompany(subcompanyid);
String sqlwhere = "";
if(scope.equals("0"))
  sqlwhere = " select * from hrmschedulediff where salaryable=1 and diffscope=0";
else if(scope.equals("1")){
    if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
  sqlwhere = " select * from hrmschedulediff where salaryable=1 and (diffscope=0 or (diffscope>0 and subcompanyid="+subcompanyid+") or (diffscope=2 and subcompanyid in("+supids+")))";
    }else
  sqlwhere = " select * from hrmschedulediff where salaryable=1 and (diffscope=0 or (diffscope>0 and subcompanyid="+subcompanyid+"))";
}else if(scope.equals("2")){
    if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
  sqlwhere = " select * from hrmschedulediff where salaryable=1 and (diffscope=0 or (diffscope=2 and subcompanyid in("+supids+","+subcompanyid+")))";
    }else
  sqlwhere = " select * from hrmschedulediff where salaryable=1 and (diffscope=0 or (diffscope=2 and subcompanyid="+subcompanyid+"))";
}


int ishead = 1;

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

   //System.out.println(sqlwhere);
rs.execute(sqlwhere);
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmScheduleDiffBrowser.jsp" method=post>
<input type=hidden name=subcompanyid value='<%=subcompanyid%>'>
<input type=hidden name=scope value='<%=scope%>'>
<input type=hidden name=difftype value='<%=difftype%>'>    
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
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




</TR>

<TR class=Spacing style="height:1px;">
    <TD class=Line1 colspan=8>
    </TD>
</TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
<TH width=60%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<!--<TH width=20%>说明</TH>
<TH width=15%>工作流</TH>
<TH width=15%>相关工资项目</TH>-->
<TH width=40%><%=SystemEnv.getHtmlLabelName(447,user.getLanguage())%></TH>
<!--
<TH width=10%>相关时间</TH>
<TH width=5%>薪资计算</TH>
<TH width=10%>计算类型</TH>-->
<%
int i=0;
rs.execute(sqlwhere);
while(rs.next()){
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
	<TD style="display:none"><A HREF=#><%=rs.getString("id")%></A></TD>
	<TD><%=rs.getString("diffname")%></TD>
<!--	<TD><%=rs.getString("diffdesc")%></TD>	
	<TD><%=WorkflowComInfo.getWorkflowname(""+rs.getInt("workflowid"))%></TD>
	<td><%=Util.toScreen(SalaryComInfo.getSalaryname(rs.getString("salaryitem")),user.getLanguage())%></td>
-->	
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
</BODY></HTML>
</BODY>
</HTML>

<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}
  var parentWin = parent.parent.getParentWindow(window.parent.window);
  var dialog = parent.parent.getDialog(window.parent.window);
function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
	var returnjson = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
	if(dialog){
	   try{
	    dialog.callback(returnjson);
	   }catch(e){}
	   try{
	    dialog.close(returnjson);
	   }catch(e){}
	}else{  
	    window.parent.parent.returnValue = returnjson;
		window.parent.parent.close();
	 }
		//window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		//window.parent.parent.close();
	}
}

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	   try{
	    dialog.callback(returnjson);
	   }catch(e){}
	   try{
	    dialog.close(returnjson);
	   }catch(e){}
	}else{  
	    window.parent.parent.returnValue = returnjson;
		window.parent.parent.close();
	 }
	//window.parent.parent.returnValue = {id:"",name:""};
	//window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>