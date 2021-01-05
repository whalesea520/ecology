<%@page import="weaver.crm.Maint.CustomerStatusComInfo"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>
<style>
</style>
<%
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String subject = Util.fromScreen3(request.getParameter("subject"), user.getLanguage());
String customerId = Util.fromScreen3(request.getParameter("customerId"), user.getLanguage());
String sellstatusid = Util.fromScreen3(request.getParameter("sellstatusid"), user.getLanguage());
String endtatusid = Util.fromScreen3(request.getParameter("endtatusid"), user.getLanguage());
String selltype = Util.fromScreen3(request.getParameter("selltype"), user.getLanguage());
int search = Util.getIntValue(request.getParameter("search"), 0);
if(search==0) endtatusid = "0";

//找到用户能看到的所有客户
String condition = "";
//找到用户能看到的所有客户
String userid = "" + user.getUID();
//如果属于总部级的CRM管理员角色，则能查看到所有客户。
String sql = "select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid;
rs.executeSql(sql);
if (rs.next()) {
	condition = " (select id from CRM_CustomerInfo where deleted=0 or deleted is null) as customerIds ";
} else {
	String leftjointable = CrmShareBase.getTempTable(userid);
	condition = " (select t1.id,t1.deleted "
		+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
		+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds";
}
String sqlWhere = "where 1=1 ";
if(!sqlwhere.equals("")) sqlWhere = sqlwhere;
if (!subject.equals("")) {
	sqlWhere += " and t.subject like '%" + subject +"%'";
}
if (!customerId.equals("")) {
	sqlWhere += " and t.customerid = " + customerId;
}
if (!sellstatusid.equals("")) {
	sqlWhere += " and t.sellstatusid = " + sellstatusid;
}
if (!endtatusid.equals("")) {
	sqlWhere += " and t.endtatusid = " + endtatusid;
}
if (!selltype.equals("")) {
	sqlWhere += " and t.selltype = " + selltype;
}

int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
int perpage = 50;
RecordSet.executeSql("Select count(distinct t.id) RecordSetCounts from CRM_SellChance t join "+condition+" on t.customerId=customerIds.id "+ sqlWhere);
boolean hasNextPage = false;
int RecordSetCounts = 0;
if (RecordSet.next()) {
	RecordSetCounts = RecordSet.getInt(1);
}
if (RecordSetCounts > pagenum * perpage) {
	hasNextPage = true;
}
String sqltemp="";
int iTotal =RecordSetCounts;
int iNextNum = pagenum * perpage;
int ipageset = perpage;
if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
if(iTotal < perpage) ipageset = iTotal;

sqltemp = "select top "+iNextNum+" t.id,t.subject,t.customerId,t.preyield,t.sellstatusid,t.endtatusid,t.selltype,t.createdate,t.createtime from CRM_SellChance t join "+condition+" on t.customerId=customerIds.id "+sqlWhere+" order by t.createdate desc,t.createtime desc";
sqltemp = "select top " + ipageset +" t2.* from (" + sqltemp + ") t2 order by t2.createdate,t2.createtime";
sqltemp = "select distinct top " + ipageset +" t3.* from (" + sqltemp + ") t3 order by t3.createdate desc,t3.createtime desc";
//System.out.println("sqltemp:"+sqltemp);
RecordSet.executeSql(sqltemp);
%>
<BODY scroll="auto">
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

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="SellChanceBrowser.jsp" method=post>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>' />
  <input type="hidden" id="pagenum" name="pagenum" value='' />
  <input type="hidden" name="search" value='1' />
<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
										<table width=100% class=ViewForm>
											<COLGROUP>
												<COL width="15%">
												<COL width="35%">
												<COL width="15%">
												<COL width="35%">
											</COLGROUP>
											<TBODY>
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%><!-- 主题 -->
												</TD>
												<TD class=Field>
													<input class=inputstyle type=text style="width: 98%" maxlength="30" name="subject" value="<%=subject %>"/>
												</TD>
												<TD><%=SystemEnv.getHtmlLabelName(24974, user.getLanguage())%><!-- 客户 -->
												</TD>
												<TD class=Field>
													<input class=wuiBrowser type=hidden id=customerId name=customerId value="<%=customerId%>"
													_displayTemplate="<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}')>#b{name}</a>" 
													_displayText="<%=CustomerInfoComInfo.getCustomerInfoname(customerId) %>" 
													_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" />
												</TD>
											</TR>
											<tr style="height: 1px">
												<td class=Line colspan=4></td>
											</tr>
											<tr>
											  	<TD>商机类型</TD>
											  	<TD class=Field>
												    <select class=InputStyle name="selltype">
												    	<option value=""></option>
												    	<option value="1" <%if(endtatusid.equals("1")){%> selected <%}%> >终端客户商机</option>
												    	<option value="2" <%if(endtatusid.equals("2")){%> selected <%}%> >老客户二次商机</option>
												    	<option value="3" <%if(endtatusid.equals("3")){%> selected <%}%> >代理压货商机</option>
											    	</select>
											    </TD> 
											  	<!-- 
										   		<TD class=Field>
											    	<select class=InputStyle id=sellstatusid name=sellstatusid>
											      		<option value="" <%if(sellstatusid.equals("")){%> selected<%}%> ></option>
											    <%  
											    	SellstatusComInfo.setTofirstRow();
											    	while(SellstatusComInfo.next()){
											    %>
												    	<option value="<%=SellstatusComInfo.getSellStatusid()%>"  <%if(sellstatusid.equals(SellstatusComInfo.getSellStatusid())){%>selected="selected"<%}%>>
												    		<%=SellstatusComInfo.getSellStatusname()%>
												    	</option>
											    <%	} %>
											    	</select>
										    	</TD>
										    	 -->
											    <TD>商机状态</TD>
											    <TD class=Field>
												    <select class=InputStyle name="endtatusid">
												    	<option value=""></option>
												    	<option value="4" <%if(endtatusid.equals("4")){%> selected <%}%> >培育</option>
												    	<option value="0" <%if(endtatusid.equals("0")){%> selected <%}%> >紧跟</option>
												    	<option value="3" <%if(endtatusid.equals("3")){%> selected <%}%> >暂停</option>
												    	<option value="1" <%if(endtatusid.equals("1")){%> selected <%}%> >成功</option>
												    	<option value="2" <%if(endtatusid.equals("2")){%> selected <%}%> >失败</option>
											    	</select>
											    </TD> 
											</tr>
											<tr style="height: 1px">
												<td class=Line colspan=4></td>
											</tr>
										</TBODY>
									</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
			<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
			<TH width="30%"><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></TH>   
			<TH width="40%"><%=SystemEnv.getHtmlLabelName(24974, user.getLanguage())%></TH>        
			<TH width="17%">商机类型</TH>
			<TH width="12%">商机状态</TH>
          </tr><TR class=Line style="height:1px;"><TH colSpan=5></TH></TR>
				<%
					int i = 0;
					String id_ = "";
					String subject_ = "";
					String customerName_ = "";
					String endtatusid_ = "";
					String endtatusname_ = "";
					String selltype_ = "";
					String selltypename_ = "";
					while (RecordSet.next()) {
						id_ = RecordSet.getString("id");
						subject_ = Util.null2String(RecordSet.getString("subject"));
						customerName_ = CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("customerid"));
						endtatusid_ = Util.null2String(RecordSet.getString("endtatusid"));
						if(endtatusid_.equals("4")) endtatusname_ = "培育";
						else if(endtatusid_.equals("0")) endtatusname_ = "紧跟";
						else if(endtatusid_.equals("3")) endtatusname_ = "暂停";
						else if(endtatusid_.equals("1")) endtatusname_ = "成功";
						else if(endtatusid_.equals("2")) endtatusname_ = "失败";
						
						selltype_ = Util.null2String(RecordSet.getString("selltype"));
						if(selltype_.equals("1")) selltypename_ = "终端客户商机";
						else if(selltype_.equals("2")) selltypename_ = "老客户二次商机";
						else if(selltype_.equals("3")) selltypename_ = "代理压货商机";
							if (i == 0) {
								i = 1;
				%>
				<TR class=DataLight>
				<%
							} else {
								i = 0;
				%>
				<TR class=DataDark>
				<%
							}
				%>
					<TD style="display:none"><A HREF=#><%=id_%></A></TD>
					<TD width="30%" style="word-break:break-all"><%=subject_%></TD>	
					<TD width="40%" style="word-break:break-all"><%=customerName_%></TD>
					<TD width="17%" style="word-break:break-all"><%=selltypename_%></TD>
					<TD width="12%" style="word-break:break-all"><%=endtatusname_%></TD>
				</TR>
				<%
					}
				%>
</TABLE>
<table align=right>
<tr style="display:none">
   <td>&nbsp;</td>
   <td>
	   <%if(pagenum>1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<button type=submit class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>
	   <%if(hasNextPage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			<button type=submit class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
	   <%}%>
   </td>
   <td>&nbsp;</td>
</tr>
</table>
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
<script type="text/javascript">
<!--

$(function(){
	//客户状态
	$("#SelectCustomerStatusID").modalDialog({
		url:"/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp",
		callBack:function(datas,e){
			if(datas){
				if(datas[0]!=0){
					$("#customerStatusSpan").html(datas[1]);
					$("#customerStatus").val(datas[0]);
					$("#customerStatusName").val(datas[1]);
				}else{
					$("#customerStatusSpan").html("");
					$("#customerStatus").val("");
					$("#customerStatusName").val("");
				}
			}
		}
	});
	//所在城市
	$("#SelectCityID").modalDialog({
		url:"/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp",
		callBack:function(datas,e){
			
		}
	});
	//客户描述
	$("#SelectCustomerDescID").modalDialog({url:""});

	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	
});




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
     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
	 window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue={id:"",name:""};
	window.parent.parent.close();
	
}
function onShowCustomerSizeID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp");
	if (datas){
		if(datas.id!=""){
			$GetEle("customerSizeSpan").innerHTML = datas.name;
			$GetEle("customerSize").value=datas.id;
			$GetEle("customerSizeName").value=datas.name;
		}else{
			$GetEle("customerSizeSpan").innerHTML = "";
			$GetEle("customerSize").value="";
			$GetEle("customerSizeName").value="";
		}
	}
}
//-->
</script>