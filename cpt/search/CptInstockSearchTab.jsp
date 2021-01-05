<%@page import="weaver.cpt.util.CommonShareManager"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CptCapital:InStockCheck", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String nameQuery = Util.null2String(request.getParameter("flowTitle"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
<script src="/cpt/js/myobserver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6050,user.getLanguage());
String needfav ="1";
String needhelp ="";
String pageId=Util.null2String(PropUtil.getPageId("cpt_cptinstocksearchtab"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelNames("20839,33110",user.getLanguage())+",javascript:batchInstock(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post">
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("20839,33110",user.getLanguage()) %>" class="e8_btn_top"  onclick="batchInstock()"/> 
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>

<%
String sqlWhere = " where d.cptstockinid=m.id and m.ischecked = 0 and m.checkerid in(" +new CommonShareManager().getContainsSubuserids(""+ user.getUID())+")  ";

if(!"".equals(nameQuery)){
	//sqlWhere+=" and name like '%"+nameQuery+"%'";
}


String orderby =" m.id ";
String tableString = "";
int perpage=10;                                 
String backfields = " m.id,m.id as tmpid,m.checkerid,m.buyerid,d.SelectDate,m.stockindate,d.contractno,d.customerid ";
String fromSql  = " CptStockInMain m,CptStockInDetail d ";

tableString =   " <table instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanBatchInstock' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"m.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("83587",user.getLanguage())+"\" column=\"tmpid\" orderkey=\"tmpid\"   />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("913",user.getLanguage())+"\" column=\"buyerid\" orderkey=\"buyerid\" transmethod=\"weaver.cpt.util.CommonTransUtil.getHrmNamesWithCard\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("901",user.getLanguage())+"\" column=\"checkerid\" orderkey=\"checkerid\" transmethod=\"weaver.cpt.util.CommonTransUtil.getHrmNamesWithCard\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("16914",user.getLanguage())+"\" column=\"SelectDate\" orderkey=\"SelectDate\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("753",user.getLanguage())+"\" column=\"stockindate\" orderkey=\"stockindate\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("21282",user.getLanguage())+"\" column=\"contractno\" orderkey=\"contractno\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("138",user.getLanguage())+"\" column=\"customerid\" orderkey=\"customerid\" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\"  />"+
                "       </head>"+
                "     <popedom column=\"id\"  ></popedom> "+
                "		<operates>"+
                "		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelNames("15359",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelNames("15358",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+                  
                " </table>";
                
                //out.println("select "+backfields+"\n from "+fromSql+"\n"+sqlWhere);
%>

<!-- listinfo -->
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83689",user.getLanguage())%>'  >
		<wea:item attributes="{'isTableList':'true'}">
			<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
 
 
 </form>
<script language="javascript">
function onEdit(id){
	if(id){
		var url="/cpt/capital/CptCapitalInstock.jsp?isdialog=1&id="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("6050",user.getLanguage())%>";
		openDialog(url,title,1000,550);
	}
}

function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83690",user.getLanguage())%>',function(){
			jQuery.post(
				"/cpt/capital/CapitalInstock1Operation.jsp",
				{"method":"delete","id":id},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83691",user.getLanguage())%>",function(){
						try{
							window.parent.location.href=window.parent.location.href;
						}catch(e){}
						
					});
				}
			);
			
		});
	}
}

function batchInstock(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	//检查是否可验收
   jQuery.ajax({
	url : "/cpt/capital/CapitalInstock1Operation.jsp",
	type : "post",
	async : true,
	processData : true,
	data : {"method":"checkstate","checkstateids":typeids},
	dataType : "json",
	success: function do4Success(data){
			if(data.msg=="true"){
				window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83692",user.getLanguage())%>',function(){
					var url="/cpt/capital/CptCapitalInstock.jsp?isdialog=1&method=batchinstock&id="+typeids;
					var title="<%=SystemEnv.getHtmlLabelNames("83693",user.getLanguage())%>";
					openDialog(url,title,1000,550);
					
				});
			}else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83694",user.getLanguage())%>");
				return;
			}
		}
	});
	
	
}
try{
	updatecptstockinnum("<%=user.getUID() %>");
}catch(e){}

 function back()
{
	window.history.back(-1);
}

</script>
</BODY>
</HTML>
