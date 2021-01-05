
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file="/systeminfo/init_wev8.jsp"%>

<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
	<HEAD>

		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript"
			src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
	</head>
	<%
		if (!HrmUserVarify.checkUserRight("eAssistant:doc", user)) {
	        response.sendRedirect("/notice/noright.jsp");
	        return;
	    }
	    // 高级搜索框中的文档标题
		String docTitle = Util.fromScreen(request.getParameter("docTitle"),
				user.getLanguage());
        // 高级搜索框中的标签
		String label = Util.fromScreen(request.getParameter("label"), user
				.getLanguage());
		// 高级搜索中框的创建人
		String userid = Util.null2String(request.getParameter("userid"));
		// 操作的标识FLG
		String docOperType = Util.null2String(request.getParameter("docOperType"));
		// 编辑页面修改过后的标签
		String changeLabel = Util.null2String(request.getParameter("changeLabel"));
		changeLabel = Util.convertInput2DB(changeLabel);
		// 编辑页面:编辑过的文档ID
		String sourceId = Util.null2String(request.getParameter("sourceId"));
		//本页面要删除的文档ID
		String docLibIDs = Util.null2String(request.getParameter("docLibIDs"));
		// 正常搜索框中搜索条件
		String t_name = Util.null2String(request.getParameter("t_name"));
		//高级搜索框中数据同步到普通搜索框中
        String searchDoc = Util.null2String(request.getParameter("searchDoc"));
        t_name = searchDoc;
        if(!"".equals(docTitle) && "".equals(t_name)){
        	t_name = docTitle;
        }
		//获得当前的日期和时间
		Date newdate = new Date() ;
		long datetime = newdate.getTime() ;
		Timestamp timestamp = new Timestamp(datetime) ;
		String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
		String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
		
		// 批量删除时,取sourceID以便对表indexupdatelog进行一条一条插入
        String[] sourceIDForDelArr = docLibIDs.split(","); 
		
		RecordSet rs = new RecordSet();
		RecordSet rsUpdLog = new RecordSet();
		if("edit".equals(Util.null2String(docOperType))){
			// 对单一文档标签进行更新
			String ChangeSql = "update FullSearch_CusLabel set label = '"+changeLabel+"' , updateTime = CURRENT_TIMESTAMP where SOURCEID = "+sourceId+"and type='DOC'";
			
			// FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
			if(rs.executeSql(ChangeSql)){
				String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+sourceId+",'DOC','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
				rsUpdLog.executeSql(updLogSql);
			}
			
		}else if("del".equals(Util.null2String(docOperType))){
			// 对单一或者批量标签进行删除
			String delSql = "delete from FullSearch_CusLabel where SOURCEID in(" + docLibIDs+") and type='DOC'";
			
			// FullSearch_CusLabel删除成功后,对表indexupdatelog进行插入操作
			if(rs.executeSql(delSql)){
				String updLogSql = "";
				for(int i = 0; i<sourceIDForDelArr.length; i++){
                    updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+sourceIDForDelArr[i]+",'DOC','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
			}
			
		}else if ("add".equals(Util.null2String(docOperType))){
			// 所有ID集合
			List listIdAll = new ArrayList();
			List listExitId = new ArrayList();
			String[] idStr = sourceId.split(",");
			for(int i = 0; i < idStr.length; i++){
				listIdAll.add(idStr[i]);				
			}
			// 查询要添加标签的文档是否已存在标签,存在的话对该文档标签进行更新操作
			String exitIdSql = "select t1.sourceid exitId from FullSearch_CusLabel t1, docdetail t2 where t1.type='DOC' and t1.sourceid = t2.id and t1.sourceid in ("+sourceId+")";
			rs.executeSql(exitIdSql);
			while(rs.next()){
				String exitId = rs.getString("exitId");
				listExitId.add(exitId);
				String updateExitIdSql = "";
                if(rs.getDBType().equals("oracle")){
                    updateExitIdSql = "update FullSearch_CusLabel set label = (select label from FullSearch_CusLabel where sourceid = '" + exitId + "' and type='DOC' )|| ' ' || '"
                        + changeLabel
                        + "', updateTime = sysdate where sourceid = '" + exitId + "' and type='DOC' ";
                }else{
                    updateExitIdSql = "update FullSearch_CusLabel set label = label+ ' ' + '"+changeLabel+"', updateTime = CURRENT_TIMESTAMP where sourceid = '"+exitId+"' and type='DOC'";
                }
				RecordSet rs1 = new RecordSet(); 
				
				// FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
				if(rs1.execute(updateExitIdSql)){
	                String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+exitId+",'DOC','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
	                rsUpdLog.executeSql(updLogSql);
	            }
			}
			// 查询要添加标签的文档是否已存在标签,不存在的话对该文档标签进行插入操作
			for(int j = 0; j < listExitId.size(); j++){
				if(listIdAll.contains(listExitId.get(j))){
					listIdAll.remove(listExitId.get(j));
				}
			}
			for(int j = 0; j < listIdAll.size(); j++){
				
				String notExitIdSql = "insert into FullSearch_CusLabel (type,sourceid,label,updateTime) values ('DOC','"+listIdAll.get(j)+"','"+changeLabel+"',CURRENT_TIMESTAMP)";
				RecordSet rs2 = new RecordSet();
				
				// FullSearch_CusLabel插入成功后,对表indexupdatelog进行插入操作
				if(rs2.execute(notExitIdSql)){
                    String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+listIdAll.get(j)+",'DOC','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
            }
			
			
		}
		
		StringBuffer sqlwhere = new StringBuffer(" where t1.type='DOC'");

		if (!"".equals(docTitle)) {
			sqlwhere.append(" and t2.docsubject like '%" + docTitle + "%'");
		}
		if (!"".equals(t_name)) {
			sqlwhere.append(" and t2.docsubject like '%" + docTitle + "%'");
		}
		
		if (!"".equals(label)) {
            String[] labelArr = label.split(" ");
            if(labelArr.length > 0){
            	for (int i = 0; i < labelArr.length; i++) {
                    sqlwhere.append(" and t1.label like '%" + labelArr[i]
                            + "%'");
                }	
            }else {
            	sqlwhere.append(" and t1.label like '%" + label + "%'");
            }
            
        }
		
		if (!"".equals(userid)) {
            sqlwhere.append(" and t2.doccreaterid like '%" + userid + "%'");
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
					+ ",javascript:delDoc(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="weaverA" name="weaverA" method="post"
                action="ViewDocLib.jsp">
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
						class="e8_btn_top middle" onclick="delDoc()" />
					<input type="text" class="searchInput" id="t_name" name="t_name" value="<%=t_name %>"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
						class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			
				<input type="hidden" name="docOperType" id="docOperType">
	            <input type="hidden" name="docLibIDs">
	            <input type="hidden" id="searchDoc" name="searchDoc" value="">
				<wea:layout type="4col">
					<wea:group
						context='<%=SystemEnv.getHtmlLabelName(20331, user
									.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(19541, user
										.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" id="docTitle" name="docTitle"
								value="<%=docTitle%>" class="InputStyle" onchange="setKeyword('docTitle','searchDoc')">
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(176, user
										.getLanguage())%></wea:item>
						<wea:item>
							<input type="text" id="label" name="label" value="<%=label%>"
								class="InputStyle">
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(18582, user
										.getLanguage())%></wea:item>
						<wea:item>
							<span id="doccreateridselspan"> <brow:browser viewType="0"
									name="userid" browserValue='<%=userid%>' browserOnClick=""
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="
									hasInput="true" isSingle="true" hasBrowser="true"
									isMustInput='1' width="150px" completeUrl="/data.jsp"
									linkUrl="javascript:openhrm($userid$)"
									browserSpanValue='<%=ResourceComInfo.getLastname(userid)%>'></brow:browser>
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
								class="e8_btn_cancel" onclick="resetCondtion();jQuery('#t_name').val('');jQuery('#t_name',parent.document).val('')" />
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
			String backfields = " t1.id, t1.updateTime, t1.label, t1.sourceid, t2.docsubject, t2.doccreaterid";
			String fromSql = " FullSearch_CusLabel t1 left join docdetail t2 on t1.sourceid = t2.id ";
			tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
					+ PageIdConst.getPageSize(PageIdConst.DOC_ViewMessage, user
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
					
					+ "           <col width=\"34%\"  text=\""
					+ SystemEnv.getHtmlLabelName(19541, user.getLanguage())
					+ "\" column=\"docsubject\" orderkey=\"docsubject\" otherpara=\"column:sourceid\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.changeLabelInfo\" />"
					
					+ "           <col width=\"38%\"  text=\""
					+ SystemEnv.getHtmlLabelName(176, user.getLanguage())
					+ "\" column=\"label\" orderkey=\"label\" />"
					
					+ "           <col width=\"10%\"  text=\""
					+ SystemEnv.getHtmlLabelName(18582, user.getLanguage())
					+ "\" column=\"doccreaterid\" orderkey=\"doccreaterid\"  transmethod=\"weaver.fullsearch.EAssistantViewMethod.getDocCreaterResource\" />"
					+ "           <col width=\"18%\"  text=\""
					+ SystemEnv.getHtmlLabelName(19520, user.getLanguage())
					+ "\" column=\"updateTime\" orderkey=\"updateTime\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getCreateTimeForDocCreater\" />"
					
					+ "</head>";
					
			tableString += "<operates>"
					+ "		<popedom column=\"sourceid\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getLabelId\"></popedom> "
					+ "		<operate href=\"javascript:changeLabel();\" text=\"" + SystemEnv.getHtmlLabelName(31231, user.getLanguage()) + "\" target=\"_self\" index=\"1\"/>"
					+ "		<operate href=\"javascript:delDoc();\" text=\"" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + "\" target=\"_self\" index=\"2\"/>" 
					+ "</operates>";   
			tableString += "</table>";
		%>
		<input type="hidden" name="pageId" id="pageId"
			value="<%=PageIdConst.DOC_ViewMessage%>" />
		<wea:SplitPageTag tableString='<%=tableString%>' mode="info" />
	</body>
	<script language="javascript">
	
var dialog;
function changeLabel(sourceid){
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "/fullsearch/EditDocLibrary.jsp?docOperType=edit&sourceid="+sourceid;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(31231, user.getLanguage())%>";
    dialog.Width = 600;
    dialog.Height = 400;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function doAdd(){
    __browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=','/docs/docs/DocDsp.jsp?isrequest=1&id=','docs',false,1,'',{name:'docs',hasInput:true,zDialog:true,needHidden:true,dialogTitle:'',_callback:showEditDocLib});
}

function showEditDocLib(event,datas,name,ismand){
    if("" == datas.id){
        return "";
    }
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "/fullsearch/EditDocLibrary.jsp?docOperType=add&sourceid="+datas.id;
    dialog.Title = '<%=SystemEnv.getHtmlLabelNames("83476,126529", user.getLanguage())%>';
    dialog.Width = 600;
    dialog.Height = 400;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function delDoc(id){
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
			
	        jQuery("input[name=docOperType]").val("del");
	        jQuery("input[name=docLibIDs]").val(ids);
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
	var name=$("input[name='t_name']",parent.document).val();
	$("#docTitle").val(name);
	$("#searchDoc").val(name);
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
