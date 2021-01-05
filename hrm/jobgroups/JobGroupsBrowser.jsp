<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("805",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->JobGroupBrowser.jsp");
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
 </script>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String jobgroupremark = Util.null2String(request.getParameter("jobgroupremark"));
String jobgroupname = Util.null2String(request.getParameter("jobgroupname"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!jobgroupremark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobgroupremark like '%";
		sqlwhere += Util.fromScreen2(jobgroupremark,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and jobgroupremark like '%";
		sqlwhere += Util.fromScreen2(jobgroupremark,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!jobgroupname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobgroupname like '%";
		sqlwhere += Util.fromScreen2(jobgroupname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and jobgroupname like '%";
		sqlwhere += Util.fromScreen2(jobgroupname,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="document.SearchForm.submit();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="JobGroupsBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform>
<TR class=Spacing style="height:2px"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15% style="padding-left: 12px;"><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=jobgroupremark id="jobgroupremark"></TD>
<TD width=15% style="padding-left: 12px;"><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=jobgroupname id="jobgroupname"></TD>
</TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TH>
<%
int i=0;
sqlwhere = "select * from HrmJobGroups "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
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
	<TD style="padding-left: 12px;"><A HREF=#><%=RecordSet.getString("id")%></A></TD>
	<TD style="padding-left: 12px;"><%=RecordSet.getString(2)%></TD>
	<TD style="padding-left: 12px;"><%=RecordSet.getString(3)%></TD>
	
</TR>
<%}%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"  class="zd_btn_submit" id="btnclear" onclick="btnclear_onclick();" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
        <input type="button"  class="zd_btn_cancle" id="btncancel" onclick="btncancel_onclick()" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</wea:item>
		</wea:group>
	</wea:layout>		
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</div>
</BODY></HTML>

<script language=javascript>
//修改浏览框
jQuery(document).ready(function(){
			$("#jobgroupremark").val('<%=jobgroupremark%>');	
			$("#jobgroupname").val('<%=jobgroupname%>');

	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		var returnjson = {id:jQuery(this).find("td:first").text(),name:jQuery(this).find("td:first").next().html()};
			if(dialog){
			    dialog.callback(returnjson);
			}else{ 
			    window.parent.returnValue  = returnjson;
			    window.parent.close();
			}
		})
/*
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected")
		})
*/
});

function btnclear_onclick(){
	var returnjson = {id:"0",name:""};
	if(dialog){
    dialog.callback(returnjson);
	}else{ 
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	 }
}
function btncancel_onclick(){
		if(dialog){
			dialog.close();
		}else{
	    window.parent.parent.close();
		}
}
</script>