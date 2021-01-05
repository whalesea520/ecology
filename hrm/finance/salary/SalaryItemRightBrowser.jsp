<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15815",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->SalaryItemRightBrowser.jsp");
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
</HEAD>
<%
String scope = Util.null2String(request.getParameter("scope"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SalaryItemRightBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>
<TH width=35%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
 </tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
String supids=SubCompanyComInfo.getAllSupCompany(subcompanyid);
String sqlwhere = "";
if(scope.equals("0"))
  sqlwhere = " select * from HrmSalaryItem where itemtype<9 and applyscope=0";
else if(scope.equals("1")){
    if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
  sqlwhere = " select * from HrmSalaryItem where itemtype<9 and applyscope=0 or (applyscope>0 and subcompanyid="+subcompanyid+") or (applyscope=2 and subcompanyid in("+supids+"))";
    }else
  sqlwhere = " select * from HrmSalaryItem where itemtype<9 and applyscope=0 or (applyscope>0 and subcompanyid="+subcompanyid+")";
}else if(scope.equals("2")){
    if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
  sqlwhere = " select * from HrmSalaryItem where itemtype<9 and applyscope=0 or (applyscope=2 and subcompanyid in("+supids+","+subcompanyid+"))";
    }else
  sqlwhere = " select * from HrmSalaryItem where itemtype<9 and applyscope=0 or (applyscope=2 and subcompanyid="+subcompanyid+")";
}
 
rs.execute(sqlwhere);
while(rs.next()){
    String id = Util.null2String(rs.getString("id")) ;
    String itemname = Util.toScreen(rs.getString("itemname"),user.getLanguage()) ;
    String itemcode = Util.toScreen(rs.getString("itemcode"),user.getLanguage()) ;
    String itemtype = Util.null2String(rs.getString("itemtype")) ;

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
	<TD width=0% style="display:none"><A HREF=#><%=id%></A></TD>
	<TD><%=itemname%></TD>
    <TD><%=itemcode%></TD>
	<TD><%if( itemtype.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1804,user.getLanguage())%>
        <%} else if( itemtype.equals("2")) {%><%=SystemEnv.getHtmlLabelName(15825,user.getLanguage())%>
        <%} else if( itemtype.equals("3")) {%><%=SystemEnv.getHtmlLabelName(15826,user.getLanguage())%>
        <%} else if( itemtype.equals("4")) {%><%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%><%}%>
    </TD>
</TR>
<%}%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
    window.parent.close();
  }
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
	    window.parent.returnValue = returnjson;
	    window.parent.close();
		}
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
    window.parent.returnValue = returnjson;
    window.parent.close();
	}
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>