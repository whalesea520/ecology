<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("378",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->LocationBrowser.jsp");
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
String locationname = Util.null2String(request.getParameter("locationname"));
String locationdesc = Util.null2String(request.getParameter("locationdesc"));
String address = Util.null2String(request.getParameter("address"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!locationname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where locationname like '%";
		sqlwhere += Util.fromScreen2(locationname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and locationname like '%";
		sqlwhere += Util.fromScreen2(locationname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!locationdesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where locationdesc like '%";
		sqlwhere += Util.fromScreen2(locationdesc,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and locationdesc like '%";
		sqlwhere +=  Util.fromScreen2(locationdesc,user.getLanguage());
		sqlwhere += "%'";
	}
}if(!address.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where address1 like '%";
		sqlwhere +=  Util.fromScreen2(address,user.getLanguage());
		//sqlwhere += "%' or address2 like '%";
		//sqlwhere += Util.fromScreen2(address,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and (address1 like '%";
		sqlwhere += Util.fromScreen2(address,user.getLanguage());
		//sqlwhere += "%' or address2 like '%";
		//sqlwhere += Util.fromScreen2(address,user.getLanguage());
		sqlwhere += "%')";
	}
}
%>
<BODY>
<div class="zDialog_div_content">
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(378,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LocationBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:resetSelect(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=button onclick="resetSelect()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
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
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle id=locationname name=locationname value='<%=locationname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle id=locationdesc name=locationdesc value='<%=locationdesc%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 1</wea:item>
		<wea:item><input class=inputstyle id=address name=address size=40 value='<%=address%>'></wea:item>
	</wea:group>
</wea:layout>
	<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
		<TR class=DataHeader>
			<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 1</TH>
		</TR>
		<%
		int i=0;
		sqlwhere = "select * from HrmLocations "+sqlwhere +" order by showOrder asc ";
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
			<TD style="padding-left: 12px;"><A HREF=#><%=RecordSet.getString(1)%></A></TD>
			<TD style="padding-left: 12px;"><%=RecordSet.getString(2)%></TD>
			<TD style="padding-left: 12px;"><%=RecordSet.getString(3)%></TD>
			<TD style="padding-left: 12px;"><%=(RecordSet.getString(4)).equals("")?RecordSet.getString(5):RecordSet.getString(4)%></TD>
		</TR>
		<%}%>
	</TABLE>
</FORM>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
function resetSelect(){
	jQuery("#locationname").val("");
	jQuery("#locationdesc").val("");
	jQuery("#address").val("");
}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:eq(1)").text().replace(/,/g, "，")};
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
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})
function btnclear_onclick()
{
	var returnjson = {id:"0",name:""};
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
  
	function btncancel_onclick(){
		if(dialog){
			dialog.close();
		}else{
	  	window.parent.close();
		}
	}


</script>
</BODY></HTML>

