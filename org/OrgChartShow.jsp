<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*,java.io.File" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.org.layout.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.hrm.common.*,weaver.hrm.chart.domain.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="showDepLayoutToPicServlet" class="weaver.org.layout.ShowDepLayoutToPicServlet" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	boolean isHr = false;
	if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
		isHr = true;
	}
	String fnarightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All",user) ;

	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
						 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
						 
	String imagefilename = "/images/hdHRMCard.gif";
	String titlename = SystemEnv.getHtmlLabelName(562,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String sorgid = Util.null2String(request.getParameter("sorgid"),"1");
	
    int companyid = Util.getIntValue(request.getParameter("companyid"),1);
	String departids="\"\"";

	String status = Util.null2String(request.getParameter("status"), "8");
	String sql=" select count(id) from HrmResource ";
	String sqlwhere = " where 1=1 ";
	int ishead = 0;
	int ishead2 = 0;
	
	if(status.equals("") || status.equals("8")){
		sqlwhere += " and (  status = 0 or status = 1 or status = 2 or status = 3) ";
	} else if(!status.equals("9")){
		sqlwhere += " and status = " +status;
	}
%>
<HTML>
	<HEAD>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css"/>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/orgchart_wev8.css"/>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<style type="text/css">
		.ellipsis {
			padding:1px;
			white-space:nowrap;
			overflow:hidden;
			text-overflow:ellipsis;
		}
		.wpoint{
			position:absolute;
			overflow:hidden;
			width:1px;
			height:1px;
			background:#000;
			border:0;
			border:0;
		}
		</style>
		<script>
			var sorgid = "<%= sorgid%>";
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			function resetSelect(){
				var obj = $GetEle("status");
				if(obj)changeSelectValue(obj.id,"8");
			}
		</script>
	</HEAD>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input type="hidden" name="sorgid" value="<%=sorgid%>">
			<table id="topTitle" class="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(status.equals("")){status = "8";}%>
							<select class="inputstyle" id="status" name="status">
								<option value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
								<option value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
								<option value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
								<option value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
								<option value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
								<option value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
								<option value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
								<option value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
								<option value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();resetSelect()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<div id="contentDiv" style="position:relative;height:100%;bottom:4px;width:100%;overflow:auto;">
			<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="zIndex:-1" >
				<tr>
					<td align="center" valign="center">
						<div style="width:170px;border:1px solid #d0d0d0;"><img src="/images/loading2_wev8.gif" align="absmiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></div>
					</td>
				</tr>
			</table>
		</div>
<%
	int topMargin = 210;
	int leftMargin = 20;
	//DepLayout dl = DownloadDeptLayoutServlet.readDeptLayout(user.getLanguage(), false, user);
	DepLayout dl = DownloadDeptLayoutServlet.readDeptLayout(user.getLanguage(), false, user,sqlwhere,true);
	dl.buildObjectRef();
	dl.checkAndAutoset(10, 10, 20, 20);
%>
<table width="<%=dl.getMaxPos().x+60%>" height="<%=dl.getMaxPos().y+300%>" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<FORM action="OrgChartShow.jsp" id=Baco name=Baco method=post>				
				<%
				
			//	out.print(sql);
				String line_str = showDepLayoutToPicServlet.gerLine(request,response);
			%>
			<div id=oDiv STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=topMargin%>;LEFT:<%=leftMargin%>;height:<%=dl.getMaxPos().y%>;width:<%=dl.getMaxPos().x%>">
			
			<%
			out.print(line_str);
			
			int curnum = 0;
			for (int i=0;i<dl.departments.size();i++) {
				Department depart = (Department)dl.departments.get(i);
				String tmpnum="";
				String sqltmp="";
				departids +=",\"";
				departids += depart.id;
				departids +="\"";
				curnum += 1;
				if (depart.type == Department.TYPE_ZONGBU) {
			%>
				<TABLE class="org_node_c_inner_company" cellpadding=1 cellspacing=1 STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=depart.y%>px;LEFT:<%=depart.x%>px;height:<%=depart.getWidthHeight().y+1%>px;width:<%=depart.getWidthHeight().x%>px;cursor:hand;">
					<TR height=22px><TD colspan=2 style="color:#000079;text-decoration:none;font-size:12px;" id=t align="center"  title="<%=depart.name%>"><br><%=Tools.vString(depart.name, 12)%></TD></TR>
					<TR height=20px>
					<%
					tmpnum = "";
					sqltmp = sql+ sqlwhere;
					//if(ishead==0){
					//	sqltmp += " where ( departmentid != 0 and departmentid is not null)";
					//}else{
						sqltmp += " and ( departmentid != 0 and departmentid is not null )";
					//}
					RecordSet2.execute(sqltmp);		
					if(RecordSet2.next())
						tmpnum = RecordSet2.getString(1);
					%>
					<TD align="center" width="100%" style="padding-bottom:3px;color:#000079"><%=tmpnum%></TD>
					</TR>
				</TABLE>
			<%
				} else if (depart.type == Department.TYPE_FENBU) {
					int subcompanyid = depart.id;
					int tmpnum1 = depart.hrmcount;
			%>
				<TABLE class="org_node_c_inner_subcompany" cellpadding=1 cellspacing=1
					STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=depart.y%>px;LEFT:<%=depart.x%>px;height:<%=depart.getWidthHeight().y+1%>px;width:<%=depart.getWidthHeight().x%>px;background-repeat:no-repeat;">
					<TR height=28px><TD align="center" onclick="doShowOrg('subcompany','<%=depart.id%>');" style="color:#eee;cursor:pointer;text-decoration:none;font-size:12px;" colspan=1 TITLE="<%=depart.name%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>px;display:inline-block;overflow:hidden;"><span><%=Tools.vString(depart.name, 12)%></span></span></TD></TR>
					<TR height=14px>
					<%
					tmpnum = ""+tmpnum1;
					%>
					<TD align="center" width=100% style="padding-bottom:0px;color:#eee;cursor:pointer" onclick="doShow('subcompany','<%=depart.id%>');"><%=tmpnum%></TD>
					</TR>		
				</TABLE>
			<%
				} else if (depart.type == Department.TYPE_COMMON_DEPARTMENT) {
			%>
				<TABLE class="org_node_c_inner_dept" cellpadding=1 cellspacing=1 
					STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=depart.y%>px;LEFT:<%=depart.x%>px;height:<%=depart.getWidthHeight().y+1%>px;width:<%=depart.getWidthHeight().x%>px;cursor:hand;background-repeat:no-repeat;">
					<TR height=28px><TD onclick="doShowOrg('department','<%=depart.id%>');" align="center" style="color:#eee;cursor:pointer;text-decoration:none;font-size:12px;" colspan=1 TITLE="<%=depart.name%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>px;display:inline-block;overflow:hidden;"><span><%=Tools.vString(depart.name, 12)%></span></span></TD></TR>
					<TR height=14px>
					<%
					tmpnum = ""+depart.hrmcount;
					%>
					<TD align="center" width=100% style="padding-bottom:0px;color:#eee;cursor:pointer" onclick="doShow('department','<%=depart.id%>');"><%=tmpnum%></TD>
					</TR>
					
				</TABLE>
					
			<%  } // end of if
			} // end of for
			%>
			</div>
			<DIV style="position:absolute;top:947;left:804;visibility:hidden;width:1;height:1;"></DIV>
				
			
<SCRIPT LANGUAGE="JavaScript">
function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}
function doShowOrg(type,id)
{
	if(type === "subcompany"){
		window.open("/hrm/HrmTab.jsp?_fromURL=HrmDepartment&subcompanyid="+id);
	} else if(type === "department"){
		window.open("/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id="+id+"&hasTree=false");
	}
}
function getXY(event){
	var leftX;
	var topY;
	if (window.ActiveXObject) {
		leftX = document.body.scrollLeft + event.clientX;
		topY = document.body.scrollTop + event.clientY;
	}else{
		leftX = event.pageX;
		topY = event.pageY;
	}
	return {X:leftX,Y:topY};
}

function doShow(type, id){
	if(type === "subcompany"){
		window.open("/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&from=hrmorg&virtualtype="+sorgid+"&subcompanyid1="+id);
	} else if(type === "department"){
		window.open("/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&from=hrmorg&virtualtype="+sorgid+"&departmentid="+id);
	}
}


			var oc_DivisionList = new Array(<%=departids%>);


			var oc_CurrentMenu;
			var oc_CurrentIndex;

			function oc_ShowMenu(Index,elMenu){
				/*var event = getEvent();
				var t;
				try{
				oc_CurrentMenu = elMenu;
				oc_CurrentIndex = Index;
				
				//on error resume next
				elMenu.style.visibility="hidden";
				//on error goto 0
				
				var elFrom = event.srcElement ? event.srcElement : event.target;
				elFrom = jQuery(elFrom).parent().parent().children()[0];
				//alert(elFrom.tagName);
				if (elFrom.tagName == "TR" || elFrom.tagName == "TD" || elFrom.tagName == "SPAN") {
					jQuery(elMenu).find("td[id=t]").text(jQuery(elFrom).text());
				}
				
				xy = getXY(event);
				t = xy.Y - 2;
				l = xy.X - 10;
				h = elMenu.clientHeight;
				w = elMenu.clientWidth;

				if ((l + w) > (document.body.scrollLeft + document.body.offsetWidth))  l = l - (w-20)
				if ((t + h) > (document.body.scrollTop + document.body.offsetHeight))  t = t - (h+2)

				elMenu.style.left = l;
				elMenu.style.top = t;
				elMenu.style.visibility = "visible";
				}catch(e){
					
				}*/
			}

			function oc_CurrentMenuOnMouseOut(){
				var event = getEvent();
				var el = event.srcElement ? event.srcElement : event.target;
				if (el.tagName == "A")   el = jQuery(el).parent();
				if (el.tagName == "IMG")   el = jQuery(el).parent();
				if (el.tagName == "TD" && jQuery(el).attr("class") != "MenuPopupSelected" && jQuery(el).attr("class") != "NoHand")  el.className = "MenuPopup";
				
			}

			function oc_CurrentMenuOnMouseOver(){
				var event = getEvent();
				var el = event.srcElement ? event.srcElement : event.target;
				if (el.tagName == "A")  el = jQuery(el).parent();
				if (el.tagName == "IMG")  el = jQuery(el).parent();
				if (el.tagName == "TD" && jQuery(el).attr("class") != "MenuPopupSelected" && jQuery(el).attr("class") != "NoHand")  el.className = "MenuPopupFocus";
				
			}

			function document_onmouseover(){
				//on error resume next
				var event = getEvent();
				var el = event.srcElement ? event.srcElement : event.target;
				if (el.tagName == "BODY"){
					oc_CurrentMenu.style.visibility = "hidden";
				}
			}

			function document_onmouseup(){
				//on error resume next
				var event = getEvent();
				var el = event.srcElement ? event.srcElement : event.target;
				if (el.tagName == "BODY"){
					oc_CurrentMenu.style.visibility = "hidden";
				}
			}

			function oc_getAllDivisions(isQuoted){
				oc_getAllDivisions = null;
				for(var i = 1;i<oc_getAllDivisions.length;i++){
					d = oc_DivisionList[i];
					if(isQuoted){
						d = "'" + d + "'";
						return oc_getAllDivisions + "," + d;
					}
				}
			}


			function oc_CurrentMenuOnClick(){
					var event = getEvent();
					var el = event.srcElement ? event.srcElement : event.target;
					if (el.tagName == "A")   el = jQuery(el).parent();
					var r;
					var status=<%=status%>;
					switch(jQuery(el).parent()[0].id){
					
						case "D1":
							r="/hrm/company/HrmDepartmentDsp.jsp?id=" + oc_DivisionList[oc_CurrentIndex];
							break;
						case "D2":
							r="/hrm/company/HrmCostcenterChart.jsp?id=" + oc_DivisionList[oc_CurrentIndex];
							break;
						case "D3":
							r="/hrm/search/HrmResourceSearchTmp.jsp?from=hrmorg&status="+status+"&department=" + oc_DivisionList[oc_CurrentIndex];
							break;
					}
					oc_CurrentMenu.style.visibility = "hidden";
					if (r != "" && r!=null){
						event.returnValue = false;
						window.location.href = r;
					}
			}
</SCRIPT>

				<DIV id="oc_divMenuTop" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuOnMouseOut()" onmouseover="return oc_CurrentMenuOnMouseOver()" style="HEIGHT: 79px; WIDTH: 246px;">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD>
				</TR>
				
				</TABLE>
				</DIV>
				<DIV id="oc_divMenuGroup" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuOnMouseOut()" onmouseover="return oc_CurrentMenuOnMouseOver()" style="HEIGHT: 79px; WIDTH: 246px;">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
				
				</TABLE>
				</DIV>
				<DIV id="oc_divMenuDivision" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuOnMouseOut()" onmouseover="return oc_CurrentMenuOnMouseOver()" style="HEIGHT: 79px; WIDTH: 246px;">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
				
					 <TR id=D1><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD></TR>
				
					 <!--TR id=D2><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></TD></TR-->
					 
					 <TR id=D3><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD></TR>
					
				
				</TABLE>
				</DIV>
				

			</FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>

<script language="javascript">
 function onSubmit(){ 	
	document.Baco.submit();
 }

 jQuery(document).ready(function(){
	if (typeof onBtnSearchClick != "undefined" && onBtnSearchClick instanceof Function) {
		$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	}
	document.all("contentDiv").style.display = "none";
});
</script>
</BODY>
</HTML>
