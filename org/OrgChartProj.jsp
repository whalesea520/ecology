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
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="showDepLayoutToPicServlet" class="weaver.org.layout.ShowDepLayoutToPicServlet" scope="page" />
<%
	String fnarightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All",user) ;
						 
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(562,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String sorgid = Util.null2String(request.getParameter("sorgid"),"1");
	String workType = Util.null2String(request.getParameter("workType"));
	String projectStatus = Util.null2String(request.getParameter("projectStatus"));
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
				var obj = $GetEle("workType");
				if(obj)changeSelectValue(obj.id,"<%=workType%>");
				obj = $GetEle("projectStatus");
				if(obj)changeSelectValue(obj.id,"<%=projectStatus%>");
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
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
						<wea:item>
							<select class="InputStyle" name="workType" id="workType">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%while(WorkTypeComInfo.next()){%>
									<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=workType.equals(WorkTypeComInfo.getWorkTypeid())?"selected":""%>><%=WorkTypeComInfo.getWorkTypename()%></option>
								<%}%>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
						<wea:item>
							<select id="projectStatus" name="projectStatus" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%while(ProjectStatusComInfo.next()){%>
									<option value="<%=ProjectStatusComInfo.getProjectStatusid()%>" <%=projectStatus.equals(ProjectStatusComInfo.getProjectStatusid())?"selected":""%>><%=ProjectStatusComInfo.getProjectStatusdesc()%></option>
								<%}%>
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
    RecordSet.executeSql("select needupdate from orgchartstate");
    int needupdate = 1;
    if (RecordSet.next())
        needupdate = RecordSet.getInt("needupdate");
    
int companyid = Util.getIntValue(request.getParameter("companyid"),1);
String departids="\"\"";


RecordSet.executeProc("HrmSubCompany_SByCompanyID",""+companyid);

int subcompanycount = RecordSet.getCounts();
int clientwidth = 125*subcompanycount;

int top = 210;
int cellHeight = 66;
int cellWidth = 105;
int cellWidth2 = 420;
int lineHeight1 = 7;
int lineHeight2 = 73;
int lineWidth = 5;
int cellSpace = 20;
int linestep = 17;


String charttype = Util.null2String(request.getParameter("charttype"));

String[] projsta = request.getParameterValues("prjstatus");
String prjstatus="";
if(projsta!=null){
	for(int i=0;i<projsta.length;i++){
		prjstatus +=","+projsta[i];
	}
}

if(charttype.equals(""))
	charttype = "R";

int topMargin = 210;
int leftMargin = 20;
DepLayout dl = DownloadDeptLayoutServlet.readDeptLayout(user.getLanguage(), false, user);
dl.buildObjectRef();
dl.checkAndAutoset(10, 10, 20, 20);
%>
<table width="<%=dl.getMaxPos().x+60%>" height="<%=dl.getMaxPos().y+300%>" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

				<FORM action="OrgChartProj.jsp" id=Baco name=Baco method=post>
				<TABLE class="ViewForm" style='display:none;'>
					<COLGROUP>
					<COL width="100">
					<COL width="">
						<TBODY >
						<TR><TD ><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></td>
						<td class=Field>
							<table>
							<tr>
							<%while(ProjectStatusComInfo.next()){
								String ischecked = "";
								String tmpid1 = ProjectStatusComInfo.getProjectStatusid();
								if(prjstatus.indexOf(tmpid1)!=-1)
									ischecked = " checked";
							%>
							<td><INPUT TYPE=checkbox VALUE="<%=tmpid1%>" name="prjstatus" <%=ischecked%>>
							<%=SystemEnv.getHtmlLabelName(Integer.parseInt(ProjectStatusComInfo.getProjectStatusname()),user.getLanguage())%>
							</td>
							<%}%>
							</tr>
							</table>
						</td>
						</tr>
						</TBODY>
					</TABLE>
					
					
					<%
					String sql=" select count(t1.id) from Prj_ProjectInfo  t1, PrjShareDetail  t2 where t1.id=t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID()+" ";
					int ishead = 1;
					String status="";
					if(projsta!=null){
						for(int i=0;i<projsta.length;i++){
							status +=" or t1.status ="+projsta[i]+" ";
						}
					}
					if(!projectStatus.equals("")&&!projectStatus.equals("0")){
						if(ishead==0){
							ishead = 1;
							sql += " where t1.status="+projectStatus+" ";
						}
						else
							sql += " and t1.status=" + projectStatus+" ";
					}		
					if(!status.equals("")){
						status = status.substring(3);
						if(ishead==0){
							ishead = 1;
							sql += " where (";
							sql += status;
							sql += ")";
						}else{
							sql += " and (";
							sql += status;
							sql += ")";
						}
					}
					if(!workType.equals("")&&!workType.equals("0")){
						if(ishead==0){
							ishead = 1;
							sql += " where t1.worktype="+workType+" ";
						}
						else
							sql += " and t1.worktype=" + workType+" ";
					}
				//	out.print(sql);
					%>
					
				<div id=oDiv STYLE="POSITION:absolute;Z-INDEX:100;TOP:<%=topMargin%>;LEFT:<%=leftMargin%>;height:<%=dl.getMaxPos().y%>;width:<%=dl.getMaxPos().x%>">
				<%
				out.print(showDepLayoutToPicServlet.gerLine(request,response));
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
					<TR height=22px><TD colspan=2 style="color:#000079" id=t align="center" title="<%=depart.name%>"><br><%=Tools.vString(depart.name, 12)%></TD></TR>
					<TR height=20px>
						<%
						RecordSet2.execute(sql);
						tmpnum="";
						if(RecordSet2.next())
							tmpnum = RecordSet2.getString(1);
						%>
						<TD align="center" width="100%" style="padding-bottom:3px;color:#000079"><%=tmpnum%></TD>
						</TR>
					</TABLE>		
				<%
					} else if (depart.type == Department.TYPE_FENBU) {
						int subcompanyid = depart.id;
				%>
					<TABLE class="org_node_c_inner_subcompany" cellpadding=1 cellspacing=1
						STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=depart.y%>px;LEFT:<%=depart.x%>px;height:<%=depart.getWidthHeight().y+1%>px;width:<%=depart.getWidthHeight().x%>px;background-repeat:no-repeat;">
					<TR height=28px><TD align="center" onclick="doShowOrg('subcompany','<%=depart.id%>');" style="color:#eee;cursor:pointer" colspan=1 TITLE="<%=depart.name%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>px;display:inline-block;overflow:hidden;"><span><%=Tools.vString(depart.name, 12)%></span></span></TD></TR>
					<TR height=14px>
						<%
						sqltmp=sql;
						String tmpdepids = ",-1";
						RecordSet2.execute("select id from HrmDepartment where  subcompanyid1="+subcompanyid+" or  subcompanyid1  in (select id from hrmsubcompany where supsubcomid="+subcompanyid+")  ");
						while(RecordSet2.next()) { tmpdepids +=","+RecordSet2.getInt("id"); }
						tmpdepids=tmpdepids.substring(1);
						if(ishead==0){
							sqltmp += " where t1.department in ("+tmpdepids +")";
						}else{
							sqltmp += " and t1.department in ("+tmpdepids +")";
						}

						tmpnum = "";
						RecordSet2.execute(sqltmp);
						if(RecordSet2.next())
							tmpnum = RecordSet2.getString(1);
						%>
						<TD align="center" width=100% style="padding-bottom:0px;color:#eee;cursor:pointer" onclick="doShow('subcompany','<%=depart.id%>');"><%=tmpnum%></TD>
						</TR>
					</TABLE>
				<%
					} else if (depart.type == Department.TYPE_COMMON_DEPARTMENT) {
				%>
					<TABLE class="org_node_c_inner_dept" cellpadding=1 cellspacing=1 
						STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=depart.y%>px;LEFT:<%=depart.x%>px;height:<%=depart.getWidthHeight().y+1%>px;width:<%=depart.getWidthHeight().x%>px;cursor:hand;background-repeat:no-repeat;">
					<TR height=28px><TD onclick="doShowOrg('department','<%=depart.id%>');" align="center" style="color:#eee;cursor:pointer" colspan=1 TITLE="<%=depart.name%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>px;display:inline-block;overflow:hidden;"><span ><%=Tools.vString(depart.name, 12)%></span></span></TD></TR>
					<TR height=14px>
						<%
						sqltmp=sql;
						if(ishead==0){
							sqltmp += " where ( t1.department="+depart.id+")";
						}else{
							sqltmp += " and ( t1.department="+depart.id+")";
						}
						RecordSet2.execute(sqltmp);
						tmpnum = "";
						if(RecordSet2.next())
							tmpnum = RecordSet2.getString(1);
						%>
						<TD align="center" width=100% style="padding-bottom:0px;color:#eee;cursor:pointer" onclick="doShow('department','<%=depart.id%>');"><%=tmpnum%></TD>
						</TR>
					</TABLE>
						
				<%  } // end of if
				} // end of for
				%>
				</div>
				<DIV style="position:absolute;top:947;left:804;visibility:hidden;width:1;height:1;"></DIV>
				<SCRIPT language=VBScript>
				oc_DivisionList=array(<%=departids%>)



				dim oc_CurrentMenu
				dim oc_CurrentIndex

				Sub oc_ShowMenu(Index,elMenu)
					dim t
					on error resume next
					oc_CurrentMenu.style.visibility="hidden"
					on error goto 0
					Set oc_CurrentMenu=elMenu
					oc_CurrentIndex = Index

					' title
					set elFrom = window.event.srcElement
					do while elFrom.tagName<>"TABLE"
						set elFrom = elFrom.parentElement
					loop
					elMenu.all("t").innerText = elFrom.all("t").innerText

					st = document.body.scrollTop
					oh = document.body.offsetHeight
					t = (st + window.event.clientY) - 2
					l = (document.body.scrollLeft + window.event.clientX) -10
					h = elMenu.clientHeight
					w = elMenu.clientWidth

					if ((l + w) > (document.body.scrollLeft + document.body.offsetWidth)) then l = l - (w-20)
					if ((t + h) > (document.body.scrollTop + document.body.offsetHeight)) then t = t - (h+2)

					elMenu.style.left = l
					elMenu.style.top = t
					elMenu.style.visibility = "visible"
				End Sub

				Sub oc_CurrentMenuOnMouseOut()
					set el = window.event.srcElement
					if (el.tagName = "A") then set el = el.parentElement
					if (el.tagName = "IMG") then set el = el.parentElement
					if (el.tagName = "TD" AND el.className <> "MenuPopupSelected" AND el.className <> "NoHand") then el.className = "MenuPopup"
				End Sub

				Sub oc_CurrentMenuOnMouseOver()
					set el = window.event.srcElement
					if (el.tagName = "A") then set el = el.parentElement
					if (el.tagName = "IMG") then set el = el.parentElement
					if (el.tagName = "TD" AND el.className <> "MenuPopupSelected" AND el.className <> "NoHand") then el.className = "MenuPopupFocus"
				End Sub

				Sub document_onmouseover
					on error resume next
					If window.event.srcElement.tagName = "BODY" Then
						oc_CurrentMenu.style.visibility = "hidden"
					End If
				End Sub

				Sub document_onmouseup
					on error resume next
					If window.event.srcElement.tagName = "BODY" Then
						oc_CurrentMenu.style.visibility = "hidden"
					End If
				End Sub

				Function oc_getAllDivisions(isQuoted)
					oc_getAllDivisions = Null
					For i = 1 To UBound(oc_DivisionList)
						d = oc_DivisionList(i)
						If isQuoted Then d = "'" & d & "'"
						oc_getAllDivisions = oc_getAllDivisions + "," & d
					Next
				End Function

				sub onShowWorkTypeID()
					id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp")
					if (Not IsEmpty(id)) then
					if id(0)<> 0 then
					WorkTypespan.innerHtml = id(1)
					Baco.WorkType.value=id(0)
					else 
					WorkTypespan.innerHtml = ""
					Baco.WorkType.value=""
					end if
					end if
				end sub
				</SCRIPT>


					<DIV id="oc_divMenuTop" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
					<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
					<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD>
					</TR>
					
					</TABLE>
					</DIV>
					<DIV id="oc_divMenuGroup" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
					<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
					<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
					
					</TABLE>
					</DIV>
					<DIV id="oc_divMenuDivision" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
					<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
					<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
					
						 <TR id=D1><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD></TR>
					
						 <TR id=D2><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD></TR>
					
					</TABLE>
					</DIV>
					<SCRIPT LANGUAGE=VBScript>
					Sub oc_CurrentMenuOnClick
						set el = window.event.srcElement
						if (el.tagName = "A") then set el = el.parentElement
						select case el.parentElement.id
						
							case "D1"
								r="/hrm/company/HrmDepartmentDsp.jsp?id=" & oc_DivisionList(oc_CurrentIndex)
							case "D2"
								r="/proj/search/SearchOperation.jsp?destination=prjindept&depid=" & oc_DivisionList(oc_CurrentIndex)
						end select
						oc_CurrentMenu.style.visibility = "hidden"
						if (r <> "") then
							window.event.returnValue = false
							window.location.href = r
						end if
					End Sub
					</SCRIPT>

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
<script language="javascript">
 function onSubmit(){ 	
	document.Baco.submit();
 }
 function doShow(type, id){
	if(type === "subcompany"){
		window.open("/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&from=hrmorg&virtualtype="+sorgid+"&subcompanyid1="+id);
	} else if(type === "department"){
		window.open("/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&from=hrmorg&virtualtype="+sorgid+"&departmentid="+id);
	}
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
