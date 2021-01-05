
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*,weaver.hrm.common.*" %>
<!-- modified by wcd 2014-06-25 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String authorityTag = Util.null2String(request.getParameter("authorityTag"));
	int t1Id = authorityTag.equals("transfer") ? 33380 : 34054;
	int t2Id = authorityTag.equals("transfer") ? 33379 : 34033;
	String transferType = Tools.vString(request.getParameter("transferType"),"resource");
	String fromid=Util.null2String(request.getParameter("fromid"));
	String fromname = "";
	if(fromid.length() > 0){
		if(transferType.equals("resource")) {
			fromname = ResourceComInfo.getResourcename(fromid);
		} else if(transferType.equals("department")) {
			fromname = DepartmentComInfo.getDepartmentname(fromid);
		} else if(transferType.equals("subcompany")) {
			fromname = SubCompanyComInfo.getSubCompanyname(fromid);
		} else if(transferType.equals("role")) {
			fromname = RolesComInfo.getRolesRemark(fromid);
		}
	}
	String toid=Util.null2String(request.getParameter("toid"));
	String toname = "";
	if(toid.length() > 0){
		String[] toids = toid.split(",");
		for(String _toid : toids){
			if(transferType.equals("resource")) {
				toname += ResourceComInfo.getResourcename(_toid)+",";
			} else if(transferType.equals("department")) {
				toname += DepartmentComInfo.getDepartmentname(_toid)+",";
			} else if(transferType.equals("subcompany")) {
				toname += SubCompanyComInfo.getSubCompanyname(_toid)+",";
			} else if(transferType.equals("role")) {
				toname += RolesComInfo.getRolesRemark(_toid)+",";
			}
		}
		if(toname.endsWith(",")) {
			toname = toname.substring(0,toname.length()-1);
		}
	}
	String numberstr = Tools.getURLDecode(request.getParameter("numberstr"));
	MJson mjson = new MJson(numberstr,true);
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.getParentWindow(this);
			var dialog = parent.getDialog(this);
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<div style="text-align:center;padding-top:10px;width:100%">
			<%=Tools.replace(SystemEnv.getHtmlLabelName(t1Id,user.getLanguage()),"{param}"," "+fromname+" ")+" "+toname%>
			<center>
			<table width="36%">
				<%
				String key = "";
				int value = 0;
				String labelId = "";
				int countValue = 0;
				while(mjson.next()){
					key = mjson.getKey();
					value = Tools.parseToInt(mjson.getValue());
					if(value <= 0){
						continue;
					}
					countValue += value;
					if(authorityTag.equals("transfer")){
						if(key.equals("T101")) labelId = "21313";
						else if(key.equals("T111")) labelId = "33929,101";
						else if(key.equals("T112")) labelId = "430,101";
						else if(key.equals("T113")) labelId = "101,1332";
						else if(key.equals("T121")) labelId = "442";
						else if(key.equals("T122")) labelId = "122";
						else if(key.equals("T123")) labelId = "22671";
						else if(key.equals("T124")) labelId = "33646";
						else if(key.equals("T125")) labelId = "33645";
						else if(key.equals("T131")) labelId = "18015,15586,99";
						else if(key.equals("T132")) labelId = "15060,665,18015";
						else if(key.equals("T133")) labelId = "1207";
						else if(key.equals("T134")) labelId = "17991";
						else if(key.equals("T141")) labelId = "58,21945";
						else if(key.equals("T142")) labelId = "58,77,385";
						else if(key.equals("T143")) labelId = "58,78,385";
						else if(key.equals("T144")) labelId = "58,15059";
						else if(key.equals("T145")) labelId = "20482,633,385";
						else if(key.equals("T146")) labelId = "15060,60,25236";
						else if(key.equals("T147")) labelId = "15060,60,25237";
						else if(key.equals("T148")) labelId = "58";
						else if(key.equals("T151")) labelId = "33929,2103";
						else if(key.equals("T152")) labelId = "430,2103";
						else if(key.equals("T161")) labelId = "2211";
						else if(key.equals("T171")) labelId = "535";
						else if(key.equals("T181")) labelId = "18831";
						else if(key.equals("T182")) labelId = "17855,21945";
						else if(key.equals("T183")) labelId = "17855,633,385";
						else if(key.equals("T191")) labelId = "15060,60,33677";
						else if(key.equals("T201")) labelId = "17587";
						else if(key.equals("T202")) labelId = "6086";
						else if(key.equals("T203")) labelId = "179";
						else if(key.equals("T204")) labelId = "24002";
						else if(key.equals("T211")) labelId = "18015,15586,99";
						else if(key.equals("T221")) labelId = "58,21945";
						else if(key.equals("T222")) labelId = "58,77,385";
						else if(key.equals("T223")) labelId = "58,78,385";
						else if(key.equals("T224")) labelId = "58,15059";
						else if(key.equals("T225")) labelId = "15060,60,25236";
						else if(key.equals("T226")) labelId = "15060,60,25237";
						else if(key.equals("T231")) labelId = "17694,21945";
						else if(key.equals("T232")) labelId = "17694,633,385";
						else if(key.equals("T241")) labelId = "15060,60,33677";
						else if(key.equals("T301")) labelId = "17898";
						else if(key.equals("T302")) labelId = "124";
						else if(key.equals("T303")) labelId = "24002";
						else if(key.equals("T311")) labelId = "18015,15586,99";
						else if(key.equals("T321")) labelId = "58,21945";
						else if(key.equals("T322")) labelId = "58,77,385";
						else if(key.equals("T323")) labelId = "58,78,385";
						else if(key.equals("T324")) labelId = "58,15059";
						else if(key.equals("T325")) labelId = "15060,60,25236";
						else if(key.equals("T326")) labelId = "15060,60,25237";
						else if(key.equals("T331")) labelId = "17694,21945";
						else if(key.equals("T332")) labelId = "17694,633,385";
						else if(key.equals("T341")) labelId = "15060,60,33677";
						else if(key.equals("T401")) labelId = "18015,15586,99";
						else if(key.equals("T411")) labelId = "58,21945";
						else if(key.equals("T412")) labelId = "58,77,385";
						else if(key.equals("T413")) labelId = "58,78,385";
						else if(key.equals("T414")) labelId = "58,15059";
						else if(key.equals("T415")) labelId = "15060,60,25236";
						else if(key.equals("T416")) labelId = "15060,60,25237";
						else if(key.equals("T421")) labelId = "17694,21945";
						else if(key.equals("T422")) labelId = "17694,633,385";
						else if(key.equals("T431")) labelId = "15060,60,33677";
						else if(key.equals("Temail001")) labelId = "15060,60,131756";
						else if(key.equals("Temail002")) labelId = "15060,60,131757";
					}else if(authorityTag.equals("copy")){
						if(key.equals("C101")) labelId = "20306,21313";
						else if(key.equals("C111")) labelId = "430,101";
						else if(key.equals("C112")) labelId = "20306,101";
						else if(key.equals("C121")) labelId = "122";
						else if(key.equals("C122")) labelId = "33646";
						else if(key.equals("C123")) labelId = "33645";
						else if(key.equals("C131")) labelId = "31698,385";
						else if(key.equals("C132")) labelId = "15060,665,18015";
						else if(key.equals("C133")) labelId = "17991";
						else if(key.equals("C141")) labelId = "58,21945";
						else if(key.equals("C142")) labelId = "58,77,385";
						else if(key.equals("C143")) labelId = "58,78,385";
						else if(key.equals("C144")) labelId = "58,15059";
						else if(key.equals("C145")) labelId = "20482,633,385";
						else if(key.equals("C146")) labelId = "15060,60,25236";
						else if(key.equals("C147")) labelId = "15060,60,25237";
						else if(key.equals("C148")) labelId = "20306,58";
						else if(key.equals("C151")) labelId = "430,2103";
						else if(key.equals("C161")) labelId = "2211";
						else if(key.equals("C171")) labelId = "430,17855";
						else if(key.equals("C172")) labelId = "17694,21945";
						else if(key.equals("C173")) labelId = "17694,633,385";
						else if(key.equals("C181")) labelId = "15060,60,33677";
						else if(key.equals("C201")) labelId = "6086";
						else if(key.equals("C202")) labelId = "24002";
						else if(key.equals("C211")) labelId = "20306,21313";
						else if(key.equals("C221")) labelId = "20306,101";
						else if(key.equals("C231")) labelId = "31698,385";
						else if(key.equals("C241")) labelId = "58,21945";
						else if(key.equals("C242")) labelId = "58,77,385";
						else if(key.equals("C243")) labelId = "58,78,385";
						else if(key.equals("C244")) labelId = "58,15059";
						else if(key.equals("C245")) labelId = "15060,60,25236";
						else if(key.equals("C246")) labelId = "15060,60,25237";
						else if(key.equals("C247")) labelId = "20306,58";
						else if(key.equals("C251")) labelId = "17694,21945";
						else if(key.equals("C252")) labelId = "17694,633,385";
						else if(key.equals("C261")) labelId = "15060,60,33677";
						else if(key.equals("C301")) labelId = "124";
						else if(key.equals("C302")) labelId = "6086";
						else if(key.equals("C303")) labelId = "24002";
						else if(key.equals("C311")) labelId = "20306,21313";
						else if(key.equals("C321")) labelId = "20306,101";
						else if(key.equals("C331")) labelId = "31698,385";
						else if(key.equals("C341")) labelId = "58,21945";
						else if(key.equals("C342")) labelId = "58,77,385";
						else if(key.equals("C343")) labelId = "58,78,385";
						else if(key.equals("C344")) labelId = "58,15059";
						else if(key.equals("C345")) labelId = "15060,60,25236";
						else if(key.equals("C346")) labelId = "15060,60,25237";
						else if(key.equals("C347")) labelId = "20306,58";
						else if(key.equals("C351")) labelId = "17694,21945";
						else if(key.equals("C352")) labelId = "17694,633,385";
						else if(key.equals("C361")) labelId = "15060,60,33677";
						else if(key.equals("C401")) labelId = "20306,21313";
						else if(key.equals("C411")) labelId = "20306,101";
						else if(key.equals("C421")) labelId = "31698,385";
						else if(key.equals("C431")) labelId = "58,21945";
						else if(key.equals("C432")) labelId = "58,77,385";
						else if(key.equals("C433")) labelId = "58,78,385";
						else if(key.equals("C434")) labelId = "58,15059";
						else if(key.equals("C435")) labelId = "15060,60,25236";
						else if(key.equals("C436")) labelId = "15060,60,25237";
						else if(key.equals("C437")) labelId = "20306,58";
						else if(key.equals("C441")) labelId = "17694,21945";
						else if(key.equals("C442")) labelId = "17694,633,385";
						else if(key.equals("C451")) labelId = "15060,60,33677";
					}
				%>
				<tr>
					<td><%=SystemEnv.getHtmlLabelNames(labelId,user.getLanguage())%>:</td>
					<td><span style='color:#1E90FF'><%=value%></span>&nbsp;<%=SystemEnv.getHtmlLabelName(33367,user.getLanguage())%></td>
				</tr>
				<%
				}
				%>
			</table>
			</center>
			<%=Tools.replace(SystemEnv.getHtmlLabelName(t2Id,user.getLanguage()),"{param}"," <span style='color:#1E90FF'>"+String.valueOf(countValue)+"</span> ")%>
		</div>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</body>
</html>