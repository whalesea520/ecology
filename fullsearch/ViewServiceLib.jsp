
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file="/systeminfo/init_wev8.jsp"%>

<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="ResourceComInfo"
    class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
    class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo"
    class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML>
    <HEAD>

        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <script language="javascript"
            src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
    </head>
    <% 
	    if(!HrmUserVarify.checkUserRight("eAssistant:server", user)){
		    response.sendRedirect("/notice/noright.jsp");
		    return;
		}
        // 高级搜索框中的姓名
        String serviceName = Util.fromScreen(request.getParameter("serviceName"),
                user.getLanguage());
        // 高级搜索框中的标签
        String label = Util.fromScreen(request.getParameter("label"), user
                .getLanguage());
        // 高级搜索框中的分部ID
        String serviceSubId = Util.fromScreen(request.getParameter("serviceSubId"),
                user.getLanguage());
        // 高级搜索框中的部门ID
        String serviceDepId = Util.fromScreen(request.getParameter("serviceDepId"),
                user.getLanguage());
        // 高级搜索框中的岗位
        String serviceJob = Util.fromScreen(request.getParameter("serviceJob"),
                user.getLanguage());
        // 操作的标识FLG
        String serviceOperType = Util.null2String(request
                .getParameter("serviceOperType"));
        // 编辑页面修改过后的标签
        String changeLabel = Util.null2String(request
                .getParameter("changeLabel"));
        changeLabel = Util.convertInput2DB(changeLabel);
        // 编辑页面:编辑过的人员ID
        String serviceId = Util.null2String(request.getParameter("serviceId"));
        //本页面要删除的人员ID
        String serviceLibIDs = Util.null2String(request
                .getParameter("serviceLibIDs"));
        // 正常搜索框中搜索条件
        String s_name = Util.null2String(request.getParameter("s_name"));
        //高级搜索框中数据同步到普通搜索框中
        String searchSer = Util.null2String(request.getParameter("searchSer"));
        s_name = searchSer;
        if(!"".equals(serviceName) && "".equals(s_name)){
        	s_name = serviceName;
        }
        //获得当前的日期和时间
        Date newdate = new Date() ;
        long datetime = newdate.getTime() ;
        Timestamp timestamp = new Timestamp(datetime) ;
        String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
        String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
        
        String[] sourceIDForDelArr = serviceLibIDs.split(","); 
        
        RecordSet rs = new RecordSet();
        if ("edit".equals(Util.null2String(serviceOperType))) {
            // 对单一客服人员标签进行更新
            String ChangeSql = "update FullSearch_CustomerSerDetail set label = '" + changeLabel + "' , lastmoddate = '"+CurrentDate+"' ,lastmodTime = '"+CurrentTime+"' where serviceId = "
                    + serviceId;
            rs.executeSql(ChangeSql);

        } else if ("del".equals(Util.null2String(serviceOperType))) {
            // 对单一后者批量标签进行删除
            String delSql = "delete from FullSearch_CustomerSerDetail where serviceId in("
                    + serviceLibIDs + ") ";
            rs.executeSql(delSql);

        } else if ("add".equals(Util.null2String(serviceOperType))) {
            // 所有ID集合
            List<String> listIdAll = new ArrayList<String>();
            List listExitId = new ArrayList();
            String[] idStr = serviceId.split(",");
            for (int i = 0; i < idStr.length; i++) {
                listIdAll.add(idStr[i]);
            }
            // 查询要添加标签的人员是否已存在标签,存在的话对该客服人员标签进行更新操作
            String exitIdSql = "select serviceId exitId from FullSearch_CustomerSerDetail where serviceId in (" + serviceId + ")";
            rs.executeSql(exitIdSql);
            while (rs.next()) {
                String exitId = rs.getString("exitId");
                listExitId.add(exitId);
                String updateExitIdSql = "";
                if(rs.getDBType().equals("oracle")){
                    updateExitIdSql = "update FullSearch_CustomerSerDetail set label =  label || ' ' ||'"
                        + changeLabel
                        + "', lastmoddate = '"+CurrentDate+"' ,lastmodTime = '"+CurrentTime+"'  where serviceId = '" + exitId + "'";
                }else{
                    updateExitIdSql = "update FullSearch_CustomerSerDetail set label =  label +' ' + '"
                        + changeLabel
                        + "', lastmoddate = '"+CurrentDate+"' ,lastmodTime = '"+CurrentTime+"'  where serviceId = '" + exitId + "'";
                }
                RecordSet rs1 = new RecordSet();
                rs1.execute(updateExitIdSql);
            }
            // 查询要添加标签的客服人员是否已存在标签,不存在的话对该客服人员标签进行插入操作
            for (int j = 0; j < listExitId.size(); j++) {
                if (listIdAll.contains(listExitId.get(j))) {
                    listIdAll.remove(listExitId.get(j));
                }
            }
            for (int j = 0; j < listIdAll.size(); j++) {
            	String id = listIdAll.get(j);
            	RecordSet rs2 = new RecordSet();
                String notExitIdSql = "insert into FullSearch_CustomerSerDetail (serviceID,label,lastmoddate,lastmodTime) values ("+id+",'"+changeLabel+"','"
                        +CurrentDate+"','"+CurrentTime+"')";
                rs2.execute(notExitIdSql);
            }

        }

        StringBuffer sqlwhere = new StringBuffer(" where 1 = 1");

        // 对普通搜索框中的人员姓名进行SQL拼接
        if (!"".equals(s_name)) {
            sqlwhere.append(" and t2.lastname like '%" + s_name + "%'");
        }

        // 对高级搜索框中的人员姓名进行SQL拼接
        if (!"".equals(serviceName)) {
            sqlwhere.append(" and t2.lastname like '%" + serviceName + "%'");
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
        if (!"".equals(serviceSubId)) {
            sqlwhere.append(" and t2.subcompanyid1 in (" + serviceSubId + ") ");
        }

        // 对高级搜索框中的部门进行SQL拼接
        if (!"".equals(serviceDepId)) {
            String serviceDepIdArr[] = serviceDepId.split(",");
            if(serviceDepIdArr.length > 0){
                sqlwhere.append(" and t2.departmentid in (" + serviceDepId + ") ");
            }else {
                sqlwhere.append(" and t2.departmentid = (" + serviceDepId + ") ");
            }
        }

        // 对高级搜索框中的岗位进行SQL拼接
        if (!"".equals(serviceJob)) {
            sqlwhere.append(" and t3.jobtitlename like ('%" + serviceJob + "%') ");
        }

        String sqlOrderBy = "t1.lastmoddate,t1.lastmodtime";

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
                    + ",javascript:delService(),_self} ";
            RCMenu += "{"
                + SystemEnv.getHtmlLabelName(20472, user.getLanguage())
                + ",javascript:createIndexl(),_self} ";
            RCMenuHeight += RCMenuHeightStep;
        %>
        <%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
        <form id="weaverA" name="weaverA" method="post"
            action="ViewServiceLib.jsp">
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
                            class="e8_btn_top middle" onclick="delService()" />
                        <input type="text" class="searchInput" id="s_name" name="s_name"
                            value="<%=s_name %>" />
                        <input type="button"
                            value="<%=SystemEnv.getHtmlLabelName(20472, user.getLanguage())%>"
                            class="e8_btn_top middle" onclick="createIndexl()" />
                        <span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
                        <span
                            title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
                            class="cornerMenu middle"></span>
                    </td>
                </tr>
            </table>
            <div class="advancedSearchDiv" id="advancedSearchDiv">

                <input type="hidden" name="serviceOperType" id="serviceOperType">
                <input type="hidden" name="serviceLibIDs">
                <input type="hidden" id="searchSer" name="searchSer" value="">
                <wea:layout type="4col">
                    <wea:group
                        context='<%=SystemEnv.getHtmlLabelName(20331, user
                                    .getLanguage())%>'>
                        <!-- 客服人员姓名 -->
                        <wea:item><%=SystemEnv.getHtmlLabelName(27622, user
                                        .getLanguage())%></wea:item>
                        <wea:item>
                            <input type="text" id="serviceName" name="serviceName"
                                value="<%=serviceName%>" class="InputStyle"  onchange="setKeyword('serviceName','searchSer')">
                        </wea:item>

                        <!-- 标签 -->
                        <wea:item><%=SystemEnv.getHtmlLabelName(176, user
                                        .getLanguage())%></wea:item>
                        <wea:item>
                            <input type="text" id="label" name="label" value="<%=label%>"
                                class="InputStyle">
                        </wea:item>
                        <!-- 分部 -->
                        <wea:item><%=SystemEnv.getHtmlLabelName(141, user
                                        .getLanguage())%></wea:item>
                        <wea:item>
                            <%
                                String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=";
                            %>
                            <brow:browser viewType="0" name="serviceSubId"
                                browserValue='<%=serviceSubId%>' browserUrl='<%=browserUrl%>'
                                hasInput="true" isSingle="false" hasBrowser="true"
                                isMustInput='1' completeUrl="/data.jsp?type=164"
                                browserSpanValue='<%=serviceSubId.length() > 0 ? Util
                                    .toScreen(SubCompanyComInfo
                                            .getSubcompanynames(serviceSubId + ""),
                                            user.getLanguage()) : ""%>'>
                            </brow:browser>
                        </wea:item>
                        <!-- 部门 -->
                        <wea:item><%=SystemEnv.getHtmlLabelName(124, user
                                        .getLanguage())%></wea:item>
                        <wea:item>
                            <brow:browser viewType="0" name="serviceDepId"
                                browserValue="<%=serviceDepId%>"
                                browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
                                hasInput="true" isSingle="false" hasBrowser="true"
                                isMustInput='1' completeUrl="/data.jsp?type=4"
                                browserSpanValue='<%=serviceDepId.length() > 0 ? Util
                                    .toScreen(DepartmentComInfo
                                            .getDepartmentNames(serviceDepId + ""),
                                            user.getLanguage()) : ""%>'></brow:browser>
                        </wea:item>
                        <!-- 岗位 -->
                        <wea:item><%=SystemEnv.getHtmlLabelName(6086, user
                                        .getLanguage())%></wea:item>
                        <wea:item>
                            <input type="text" id="serviceJob" name="serviceJob"
                                value="<%=serviceJob%>" class="InputStyle">
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
                                class="e8_btn_cancel" onclick="resetCondtion();jQuery('#s_name').val('');jQuery('#s_name',parent.document).val('')" />
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
            String backfields = " t1.id, t1.serviceID, t1.label, t2.subcompanyid1, t2.departmentid, t2.lastname, t3.jobtitlename";
            String fromSql = " FullSearch_CustomerSerDetail t1 left join hrmresource t2 on t1.serviceID = t2.id left join HrmJobTitles t3 on t2.jobtitle = t3.id";
            tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
                    + PageIdConst.getPageSize(PageIdConst.SER_ViewMessage, user
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
                    + "\" sqlprimarykey=\"t1.serviceID\" sqlsortway=\"DESC\" />"

                    + "       <head>"

                    + "           <col width=\"15%\"  text=\""
                    + SystemEnv.getHtmlLabelName(27622, user.getLanguage())
                    + "\" column=\"lastname\" orderkey=\"lastname\" otherpara=\"column:serviceID\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.changeLabelInfo\"/>"

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
                    + "     <popedom column=\"serviceID\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getLabelId\"></popedom> "
                    + "     <operate href=\"javascript:changeLabel();\" text=\""
                    + SystemEnv.getHtmlLabelName(31231, user.getLanguage())
                    + "\" target=\"_self\" index=\"1\"/>"
                    + "     <operate href=\"javascript:delService();\" text=\""
                    + SystemEnv.getHtmlLabelName(91, user.getLanguage())
                    + "\" target=\"_self\" index=\"2\"/>" + "</operates>";
            tableString += "</table>";
        %>
        <input type="hidden" name="pageId" id="pageId"
            value="<%=PageIdConst.SER_ViewMessage%>" />
        <wea:SplitPageTag tableString='<%=tableString%>' mode="info" />
    </body>
    <script language="javascript">
var dialog;
function changeLabel(serviceId){
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "/fullsearch/EditServiceLibrary.jsp?serviceOperType=edit&serviceId="+serviceId;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(31231, user.getLanguage())%>";
    dialog.Width = 600;
    dialog.Height = 400;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function doAdd(){
    __browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=','/hrm/resource/HrmResource.jsp?id=','hrmmembers',false,2,'',{name:'hrmmembers',hasInput:true,zDialog:true,needHidden:true,dialogTitle:'',_callback:showEditServiceLib});
}

function showEditServiceLib(event,datas,name,ismand){
    jQuery("input[name=serviceOperType]").val("add");
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    if("" == datas.id){
        return "";
    }
    var url = "/fullsearch/EditServiceLibrary.jsp?serviceOperType=add&serviceId="+datas.id;
    dialog.Title = '<%=SystemEnv.getHtmlLabelNames("83476,26272", user.getLanguage())%>';
    dialog.Width = 600;
    dialog.Height = 400;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function delService(id){
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
    }if(ids==""){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
        return;
    }else{
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>",function(){
            
            jQuery("input[name=serviceOperType]").val("del");
            jQuery("input[name=serviceLibIDs]").val(ids);
            document.forms[0].submit();
        });
    }
}

function createIndexl(){
     $.post("ViewServiceOperation.jsp", 
        {"operate":"createIndex"},
        function(data){
            var data=data.replace(/[\r\n]/g,"");//.replace(/[ ]/g,"");
             if(data=="false"){
                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%>");
             }else{
                window.top.Dialog.alert(data);
             }
        });
         
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
    var name=$("input[name='s_name']",parent.document).val();
    $("#serviceName").val(name);
    $("#searchSer").val(name);
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
