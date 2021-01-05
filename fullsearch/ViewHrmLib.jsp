
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>

<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML>
	<HEAD>

		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript"
			src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
	</head>
	<% 
		if(!HrmUserVarify.checkUserRight("eAssistant:rsc", user)){
		    response.sendRedirect("/notice/noright.jsp");
		    return;
		}
	    // 左侧结构树中取得要查询的总部或者分部或者部门
	    String _fromURLLeft = Util.fromScreen(request.getParameter("_fromURL"), user
                .getLanguage());
        // 左侧结构树中取得的总部ID
        String companyIdLeft = Util.fromScreen(request.getParameter("companyid"), user
                .getLanguage());
        // 左侧结构树中取得的分部ID
	    String subCompanyIdLeft = Util.fromScreen(request.getParameter("subCompanyId"), user
            .getLanguage());
	    // 左侧结构树中取得的部门ID
	    String depCompanyIdLeft = Util.fromScreen(request.getParameter("departmentid"), user
            .getLanguage());
		// 高级搜索框中的姓名
		String rscName = Util.fromScreen(request.getParameter("rscName"),
				user.getLanguage());
		// 高级搜索框中的标签
		String label = Util.fromScreen(request.getParameter("label"), user
				.getLanguage());
		// 高级搜索框中的分部ID
		String rscSubId = Util.fromScreen(request.getParameter("rscSubId"),
				user.getLanguage());
		// 高级搜索框中的部门ID
		String rscDepId = Util.fromScreen(request.getParameter("rscDepId"),
				user.getLanguage());
		// 高级搜索框中的岗位
		String rscJob = Util.fromScreen(request.getParameter("rscJob"),
				user.getLanguage());
		// 操作的标识FLG
		String rscOperType = Util.null2String(request
				.getParameter("rscOperType"));
		// 编辑页面修改过后的标签
		String changeLabel = Util.null2String(request
				.getParameter("changeLabel"));
		changeLabel = Util.convertInput2DB(changeLabel);
		// 编辑页面:要编辑的人员ID
		String sourceId = Util.null2String(request.getParameter("sourceId"));
		//本页面要删除的人员ID
		String rscLibIDs = Util.null2String(request
				.getParameter("rscLibIDs"));
		// 正常搜索框中搜索条件
		String h_name = Util.null2String(request.getParameter("h_name"));
		//高级搜索框中数据同步到普通搜索框中
        String searchHrm = Util.null2String(request.getParameter("searchHrm"));
        h_name = searchHrm;
        if(!"".equals(rscName) && "".equals(h_name)){
        	h_name = rscName;
        }
		// 批量删除时,取sourceID以便对表indexupdatelog进行一条一条插入
		String[] sourceIDForDelArr = rscLibIDs.split(","); 
		
		//获得当前的日期和时间
        Date newdate = new Date() ;
        long datetime = newdate.getTime() ;
        Timestamp timestamp = new Timestamp(datetime) ;
        String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
        String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
        
		RecordSet rs = new RecordSet();
        RecordSet rsUpdLog = new RecordSet();
		if ("edit".equals(Util.null2String(rscOperType))) {
			// 对单一文档标签进行更新
			String ChangeSql = "update FullSearch_CusLabel set label = '" + changeLabel + "' , updateTime = CURRENT_TIMESTAMP where type = 'RSC' and sourceId = " + sourceId;

			// FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
            if(rs.executeSql(ChangeSql)){
                String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+sourceId+",'RSC','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                
                rsUpdLog.executeSql(updLogSql);
            }

		} else if ("del".equals(Util.null2String(rscOperType))) {
			// 对单一或者批量标签进行删除
			String delSql = "delete from FullSearch_CusLabel where sourceId in (" + rscLibIDs + ") and type = 'RSC' ";

			// FullSearch_CusLabel删除成功后,对表indexupdatelog进行插入操作
            if(rs.executeSql(delSql)){
            	String updLogSql = "";
            	for(int i = 0; i<sourceIDForDelArr.length; i++){
            		updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+sourceIDForDelArr[i]+",'RSC','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
            	}
            }

		} else if ("add".equals(Util.null2String(rscOperType))) {
			// 所有ID集合
			List listIdAll = new ArrayList();
			List listExitId = new ArrayList();
			String[] idStr = sourceId.split(",");
			for (int i = 0; i < idStr.length; i++) {
				listIdAll.add(idStr[i]);
			}
			
			// 查询要添加标签的文档是否已存在标签,存在的话对该文档标签进行更新操作
			String exitIdSql = "select t1.sourceid exitId from FullSearch_CusLabel t1, hrmresource t2 where t1.type='RSC' and t1.sourceid = t2.id and t1.sourceid in ("
					+ sourceId + ")";
			rs.executeSql(exitIdSql);
			while (rs.next()) {
				String exitId = rs.getString("exitId");
				listExitId.add(exitId);
				String updateExitIdSql = "";
				if(rs.getDBType().equals("oracle")){
					updateExitIdSql = "update FullSearch_CusLabel set label = (select label from FullSearch_CusLabel where sourceid = '" + exitId + "' and type='RSC' )|| ' ' || '"
                        + changeLabel
                        + "', updateTime = sysdate where sourceid = '" + exitId + "' and type='RSC' ";
				}else{
				    updateExitIdSql = "update FullSearch_CusLabel set label = label+ ' ' + '"
						+ changeLabel
						+ "', updateTime = CURRENT_TIMESTAMP where sourceid = '" + exitId + "' and type='RSC' ";
				}
				RecordSet rs1 = new RecordSet();
				
				// FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
                if(rs1.execute(updateExitIdSql)){
                    String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+exitId+",'RSC','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
			}
			// 查询要添加标签的文档是否已存在标签,不存在的话对该文档标签进行插入操作
			for (int j = 0; j < listExitId.size(); j++) {
				if (listIdAll.contains(listExitId.get(j))) {
					listIdAll.remove(listExitId.get(j));
				}
			}
			for (int j = 0; j < listIdAll.size(); j++) {

				String notExitIdSql = "insert into FullSearch_CusLabel (type,sourceid,label,updateTime) values ('RSC','"
						+ listIdAll.get(j)
						+ "','"
						+ changeLabel
						+ "',CURRENT_TIMESTAMP)";
				RecordSet rs2 = new RecordSet();
				
				// FullSearch_CusLabel插入成功后,对表indexupdatelog进行插入操作
                if(rs2.execute(notExitIdSql)){
                    String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+listIdAll.get(j)+",'RSC','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
			}

		}

		StringBuffer sqlwhere = new StringBuffer(" where t1.type='RSC'");

		// 对左侧结构树进行SQl拼接
		if(_fromURLLeft.equals("HrmCompanyDsp")){
			
		}
		if(_fromURLLeft.equals("HrmSubCompanyDsp")){
			sqlwhere.append(" and t2.subcompanyid1 = " + subCompanyIdLeft + " ");
		 }
		if(_fromURLLeft.equals("HrmDepartmentDsp")){
			sqlwhere.append(" and t2.departmentid = " + depCompanyIdLeft + " ");
		}
		// 对普通搜索框中的人员姓名进行SQL拼接
		if (!"".equals(h_name)) {
			sqlwhere.append(" and t2.lastname like '%" + h_name + "%'");
		}

		// 对高级搜索框中的人员姓名进行SQL拼接
		if (!"".equals(rscName)) {
			sqlwhere.append(" and t2.lastname like '%" + rscName + "%'");
		}

		// 对高级搜索框中的标签进行SQL拼接
		if (!"".equals(label)) {
			String[] labelArr = label.split(" ");
			if (labelArr.length > 0) {
				for (int i = 0; i < labelArr.length; i++) {
					sqlwhere.append(" and t1.label like '%" + labelArr[i]
							+ "%'");
				}
			} else {
				sqlwhere.append(" and t1.label like '%" + label + "%'");
			}

		}

		// 对高级搜索框中的分部进行SQL拼接
		if (!"".equals(rscSubId)) {
			sqlwhere.append(" and t2.subcompanyid1 in (" + rscSubId + ") ");
		}

		// 对高级搜索框中的部门进行SQL拼接
		if (!"".equals(rscDepId)) {
			String rscDepIdArr[] = rscDepId.split(",");
			if(rscDepIdArr.length > 0){
				sqlwhere.append(" and t2.departmentid in (" + rscDepId + ") ");
			}else {
				sqlwhere.append(" and t2.departmentid = (" + rscDepId + ") ");
			}
		}

		// 对高级搜索框中的岗位进行SQL拼接
		if (!"".equals(rscJob)) {
			sqlwhere.append(" and t3.jobtitlename like ('%" + rscJob + "%') ");
		}

		String sqlOrderBy = "t1.updateTime";

		String imagefilename = "/images/hdReport_wev8.gif";
		String titlename =SystemEnv.getHtmlLabelName(128696,user.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>

		<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(83476, user.getLanguage())
					+ ",javascript:doAdd(),_self} ";
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(32136, user.getLanguage())
					+ ",javascript:delHrm(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="weaverA" name="weaverA" method="post"
                action="ViewHrmLib.jsp">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(83476, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="doAdd()" />
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="delHrm()" />
					<input type="text" class="searchInput" id="h_name" name="h_name" value="<%=h_name %>"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
						class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			
				<input type="hidden" name="rscOperType" id="rscOperType">
	            <input type="hidden" name="rscLibIDs">
	            <input type="hidden" id="searchHrm" name="searchHrm" value="">
				<wea:layout type="4col">
					<wea:group
						context='<%=SystemEnv.getHtmlLabelName(20331, user
									.getLanguage())%>'>
                        <!-- 人员姓名 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(27622, user
										.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" id="rscName" name="rscName"
								value="<%=rscName%>" class="InputStyle"  onchange="setKeyword('rscName','searchHrm')">
						</wea:item>

                        <!-- 标签 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(176, user
										.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" id="label" name="label" value="<%=label%>"
								class="InputStyle">
							</span>
						</wea:item>
						<!-- 分部 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(141, user
										.getLanguage())%></wea:item>
						<wea:item>
							<%
								String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=";
							%>
							<brow:browser viewType="0" name="rscSubId"
								browserValue='<%=rscSubId%>' browserUrl='<%=browserUrl%>'
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' completeUrl="/data.jsp?type=164"
								browserSpanValue='<%=rscSubId.length() > 0 ? Util
									.toScreen(SubCompanyComInfo
											.getSubcompanynames(rscSubId + ""),
											user.getLanguage()) : ""%>'>
							</brow:browser>
						</wea:item>
						<!-- 部门 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(124, user
										.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="rscDepId"
								browserValue="<%=rscDepId%>"
								browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' completeUrl="/data.jsp?type=4"
								browserSpanValue='<%=rscDepId.length() > 0 ? Util
                                    .toScreen(DepartmentComInfo
                                            .getDepartmentNames(rscDepId + ""),
                                            user.getLanguage()) : ""%>'></brow:browser>
						</wea:item>
						<!-- 岗位 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(6086, user
										.getLanguage())%></wea:item>
                        <wea:item>
                            <input type="text" id="rscJob" name="rscJob" value="<%=rscJob%>"
                                class="InputStyle">
                            </span>
                        </wea:item>
                        
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" onclick="doSubmit();" class="e8_btn_submit"
								value="<%=SystemEnv.getHtmlLabelName(197, user
										.getLanguage())%>" />
							<input type="button"
								value="<%=SystemEnv.getHtmlLabelName(2022, user
										.getLanguage())%>"
								class="e8_btn_cancel" onclick="resetCondtion();jQuery('#h_name').val('');jQuery('#h_name',parent.document).val('')" />
							<input type="button"
								value="<%=SystemEnv.getHtmlLabelName(201, user
										.getLanguage())%>"
								class="e8_btn_cancel" id="cancel" />
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
		</div>
		<%
			String tableString = "";
			int perpage = 10;
			String backfields = " t1.id, t1.updateTime, t1.label, t1.sourceid, t2.lastname, t2.subcompanyid1, t2.departmentid, t3.jobtitlename";
			String fromSql = " FullSearch_CusLabel t1 left join hrmresource t2 on t1.sourceid = t2.id left join HrmJobTitles t3 on t2.jobtitle = t3.id";
			tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
					+ PageIdConst.getPageSize(PageIdConst.RSC_ViewMessage, user
							.getUID())
					+ "\" >"
					+ " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:sourceid\" showmethod=\"weaver.fullsearch.EAssistantViewMethod.getCheckbox\"  />"
					+ "       <sql backfields=\""
					+ backfields
					+ "\" sqlform=\""
					+ fromSql
					+ "\"  sqlwhere=\""
					+ Util.toHtmlForSplitPage(sqlwhere.toString())
					+ "\"  sqlorderby=\""
					+ sqlOrderBy
					+ "\" sqlprimarykey=\"sourceid\" sqlsortway=\"DESC\" />"

					+ "       <head>"

					+ "           <col width=\"15%\"  text=\""
					+ SystemEnv.getHtmlLabelName(27622, user.getLanguage())
					+ "\" column=\"lastname\" orderkey=\"lastname\" otherpara=\"column:sourceid\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.changeLabelInfo\"/>"

					+ "           <col width=\"30%\"  text=\""
					+ SystemEnv.getHtmlLabelName(176, user.getLanguage())
					+ "\" column=\"label\" orderkey=\"label\"/>"

					+ "           <col width=\"15%\"  text=\""
                    + SystemEnv.getHtmlLabelName(141, user.getLanguage())
                    + "\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getSubName\" />"
					
					+ "           <col width=\"15%\"  text=\""
					+ SystemEnv.getHtmlLabelName(124, user.getLanguage())
					+ "\" column=\"departmentid\" orderkey=\"departmentid\"  transmethod=\"weaver.fullsearch.EAssistantViewMethod.getDepName\" />"
					
					+ "           <col width=\"25%\"  text=\""
					+ SystemEnv.getHtmlLabelName(6086, user.getLanguage())
					+ "\" column=\"jobtitlename\" orderkey=\"jobtitlename\"/>"

					+ "</head>";

			tableString += "<operates>"
					+ "		<popedom column=\"sourceid\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getLabelId\"></popedom> "
					+ "		<operate href=\"javascript:changeLabel();\" text=\""
					+ SystemEnv.getHtmlLabelName(31231, user.getLanguage())
					+ "\" target=\"_self\" index=\"1\"/>"
					+ "		<operate href=\"javascript:delHrm();\" text=\""
					+ SystemEnv.getHtmlLabelName(91, user.getLanguage())
					+ "\" target=\"_self\" index=\"2\"/>" + "</operates>";
			tableString += "</table>";
		%>
		<input type="hidden" name="pageId" id="pageId"
			value="<%=PageIdConst.RSC_ViewMessage%>" />
		<wea:SplitPageTag tableString='<%=tableString%>' mode="info" />
	</body>
	<script language="javascript">
var dialog;
function changeLabel(sourceId){
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "/fullsearch/EditHrmLibrary.jsp?rscOperType=edit&sourceId="+sourceId;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(31231, user.getLanguage())%>";
    dialog.Width = 600;
    dialog.Height = 400;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function doAdd(){
    __browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=','/hrm/resource/HrmResource.jsp?id=','hrmmembers',false,2,'',{name:'hrmmembers',hasInput:true,zDialog:true,needHidden:true,dialogTitle:'',_callback:showEditHrmLib});
}

function showEditHrmLib(event,datas,name,ismand){
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    if("" == datas.id){
        return "";
    }
    var url = "/fullsearch/EditHrmLibrary.jsp?rscOperType=add&sourceId="+datas.id;
    dialog.Title = '<%=SystemEnv.getHtmlLabelNames("83476,33451", user.getLanguage())%>';
    dialog.Width = 600;
    dialog.Height = 400;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function delHrm(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))
			ids = ids +$(this).attr("checkboxId")+",";
	});
	}else {
        ids = id;
    }
    if(ids.match(/,$/)){
        ids = ids.substring(0,ids.length-1);
    }
	if(ids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
		return;
	}else{
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>",function(){
			
	        jQuery("input[name=rscOperType]").val("del");
	        jQuery("input[name=rscLibIDs]").val(ids);
	        document.forms[0].submit();
	    });
	}
}

function doSubmit()
{
	document.forms[0].submit();
}
function resetCondtion(){
	resetCondtionBrw("advancedSearchDiv");
}
</script>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer"
		src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>


<script language="javascript">

function preDo(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
}

function onBtnSearchClick(){
	var name=$("input[name='h_name']",parent.document).val();
	$("#rscName").val(name);
	$("#searchHrm").val(name);
	doSubmit();
}

function doSearchsubmit(){
    $('#weaverA').submit();
}

function closeDialog(){
    _table. reLoad();
    dialog.close();
}

function setKeyword(source,target){
    var targetVal =document.getElementById(source).value; 
    document.getElementById(target).value=targetVal;
}
</script>
