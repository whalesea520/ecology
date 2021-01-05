<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.homepage.HomepageBean" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.page.HPTypeEnum" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="wbe" class="weaver.admincenter.homepage.WeaverBaseElementCominfo" scope="page"/>
<jsp:useBean id="hpsb" class="weaver.homepage.style.HomepageStyleBean" scope="page"/>
<jsp:useBean id="wp" class="weaver.admincenter.homepage.WeaverPortal" scope="page"/>
<jsp:useBean id="wpc" class="weaver.admincenter.homepage.WeaverPortalContainer" scope="page"/>


<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>

<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>"/>
</jsp:include>

<%
    //add by wshen
    String showElemFlag = Util.null2String(request.getParameter("isshowelemflag"));
    String showElemIds = Util.null2String(request.getParameter("elemids"));
    List showElemList = new ArrayList();//需要显示的文件列表
    for (String eid : showElemIds.split(",")) {
        showElemList.add(eid);
    }
    //end
//BaseBean.writeLog(request.getQueryString()+"%%%%%%%%%");
//Get Parameter
// hpid 正数 为 门户 id hpinfo。负数为 协同id  ，synergy_base 表中。 协同信息不 存储在  hpinfo 表中。
    String hpid = ""+Util.getIntValue(Util.null2String(request.getParameter("hpid")));
    String requestid = Util.null2String(request.getParameter("requestid"));

    int fnaBudgetAssistantCnt = 0;
    String sqlFnaBudgetAssistantCnt = "select count(*) cnt \n" +
            " from fnaBudgetAssistant a \n" +
            " where (a.bxxx=1 or a.bxtb=1) \n" +
            " and a.ebaseid = 'fnaBudgetAssistant' \n" +
            " and a.hpid = " + Util.getIntValue(hpid, 0);
    RecordSet rSet = new RecordSet();
    rSet.execute(sqlFnaBudgetAssistantCnt);
    if (rSet.next()) {
        fnaBudgetAssistantCnt = Util.getIntValue(rSet.getString("cnt"), 0);
    }

    int fnaBudgetAssistant1Cnt = 0;
    String sqlFnaBudgetAssistant1Cnt = "select count(*) cnt \n" +
            " from fnaBudgetAssistant1 a \n" +
            " where a.ebaseid = 'fnaBudgetAssistant1' \n" +
            " and a.hpid = " + Util.getIntValue(hpid, 0);
    rSet.execute(sqlFnaBudgetAssistant1Cnt);
    if (rSet.next()) {
        fnaBudgetAssistant1Cnt = Util.getIntValue(rSet.getString("cnt"), 0);
    }

//System.out.println("hpid=============a"+hpid);
    int isfromportal = Util.getIntValue(request.getParameter("isfromportal"), 0);
    int isfromhp = Util.getIntValue(request.getParameter("isfromhp"), 0);
    int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), -1);
    boolean isSetting = "true".equalsIgnoreCase(Util.null2String(request.getParameter("isSetting")));
    int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
    String opt = Util.null2String(request.getParameter("opt"));
    String from = Util.null2String(request.getParameter("from"));

// --- 协同区新增参数开始 ---
// 页面类型(doc:文档, wf:流程, hp_workflow_form:流程表单)
    String pagetype = Util.null2String(request.getParameter("pagetype"));
// 是否为处理页面(0:新建页面, 1:处理页面)
    String ispagedeal = Util.null2String(request.getParameter("ispagedeal"));
// --- 协同区新增参数结束 ---

    String hasTemplate = Util.null2String(request.getParameter("hastemplate"));
    boolean hasRight = true;
    boolean issubmenu = false;
    if ("loginview".equals(pagetype)) {
        if ("edit".equals(opt) && !HrmUserVarify.checkUserRight("homepage:Maint", user)) {
            hasRight = false;
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
    } else {
        if ("edit".equals(opt) || isSetting || "privew".equals(opt)) {
            if ("doc".equals(pagetype) || "wf".equals(pagetype)) {
                // 协同权限
                if (!HrmUserVarify.checkUserRight("Synergy:Maint", user)) {
                    hasRight = false;
                    response.sendRedirect("/notice/noright.jsp");
                    return;
                }
            } else {
                // 门户权限
                if (!HrmUserVarify.checkUserRight("homepage:Maint", user) && !pu.getUserMaintHpidListPublic(user.getUID()).contains(hpid) && !"addElement".equals(from)) {
                    hasRight = false;
                    response.sendRedirect("/notice/noright.jsp");
                    return;
                }
            }
        }
    }

//当前设置元素的流程
    int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
    int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);

/**设置菜单信息**/
    String menutype = Util.null2String(request.getParameter("menutype"));
    String menuparentid = Util.null2String(request.getParameter("menuparentid"));
    String menuindex = Util.null2String(request.getParameter("menuindex"));
    request.getSession().setAttribute(user.getUID() + "_menutype", menutype);

    request.getSession().setAttribute(user.getUID() + "_menuparentid", menuparentid);
    request.getSession().setAttribute(user.getUID() + "_menuindex", menuindex);
    request.getSession().setAttribute(user.getUID() + "_hpid_menu", hpid);
//BaseBean.writeLog(user.getUID()+"_menutype"+"----"+request.getSession().getAttribute(user.getUID()+"_menutype")+"::::menutype"+"%%%%%%%%%Homepage");

//如果首页ID为0将不显示页面
//if("0".equals(hpid)){
    //out.println(SystemEnv.getHtmlLabelName(20276,user.getLanguage()));
    //return ;
//}

//保存退出的首页
    if (!isSetting) pu.saveUserHpStat(user, hpid);


//计算相关页面数据
//HomepageBean hpb=pu.getHpb(hpid);
    String layoutid = pc.getLayoutid(hpid);
    String styleid = pc.getStyleid(hpid);
    String menuStyleid = pc.getMenuStyleid(hpid);
    String pageTitle = pc.getInfoname(hpid);

    String isRedirectUrl = pc.getIsRedirectUrl(hpid);
    if ("1".equals(isRedirectUrl)) {
        String redirectUrl = pc.getRedirectUrl(hpid);
        if (redirectUrl != null && !"".equals(redirectUrl)) {
            if (!redirectUrl.startsWith("http") && !redirectUrl.startsWith("/")) {
                redirectUrl = "http://" + redirectUrl;
            }
            response.sendRedirect(redirectUrl);
            return;
        }
    }


//设置自动刷新首页
    String needRefresh = "0";
    int refreshMins = 100;
    rs.executeSql("select needRefresh, refreshMins from SystemSet");
    if (rs.next()) {
        needRefresh = rs.getString(1);
        refreshMins = rs.getInt(2);
        if ("1".equals(needRefresh)) {
%>
<script language=javascript>
    setTimeout(function () {
        doAutoRefresh();
    },<%=refreshMins%> * 60 * 1000
    )
    ;

    function doAutoRefresh() {
        $('.item').trigger('reload');
        setTimeout(function () {
            doAutoRefresh();
        },<%=refreshMins%> * 60 * 1000
    )
        ;
    }
</script>

<%
        }
    }

    int tempsubid = subCompanyId == 0 ? Util.getIntValue(hpc.getSubcompanyid(hpid)) : subCompanyId;
    int nodelUserid = pu.getHpUserId(hpid, "" + tempsubid, user);
    int nodelUsertype = pu.getHpUserType(hpid, "" + tempsubid, user);

    String synersySatus = "0";
//为协同信息
    if (Util.getIntValue(hpid) < 0) {
        styleid = "synergys";//在具体加 元素时，会加后缀
        layoutid = "1";// 一行一列
        // //协同的 userid  和 usertype 为 1  和 0
        wpc.addLayoutForSynergy(hpid, layoutid, "1", "0");
        //协同的 userid  和 usertype 为 1  和 0
        nodelUserid = 1;
        nodelUsertype = 0;

        //查询 当前 协同门户是否启用
        rs.execute("select isuse from synergyconfig where hpid=" + hpid);
        if (rs.next()) synersySatus = rs.getString("isuse");// 0 是不启用  1 是 启用
        if ("".equals(synersySatus)) synersySatus = "0";
    }

%>
<html>
<head>
    <title><%=pageTitle%>
    </title>
    <!-- 引入CSS -->
    <script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
    <script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
    <link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css"/>
    <link rel="stylesheet" href="/js/homepage/tabs/css/e8tabs_wev8.css" type="text/css"/>
    <script language=javascript src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
    <script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
    <link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet"/>
    <link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css"/>
    <link rel="stylesheet" type="text/css" href="/homepage/css/homepage.css"/>
    <script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
    <script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
    <script type="text/javascript" src="/homepage/js/homepage.js"></script>

    <!-- 引入JavaScript -->
    <%=pu.getPageJsImportStr(hpid) %>
    <%=pu.getPageCssImportStr(hpid) %>
    <script type="text/javascript">

        function onLoadComplete(ifm) {
            if (ifm.readyState == "complete") {
                if (ifm.contentWindow.document.body.scrollHeight > ifm.height) {
                    ifm.style.height = ifm.height;
                } else {
                    ifm.style.height = ifm.contentWindow.document.body.scrollHeight;
                }
            }
        }
    </script>
    <STYLE TYPE="text/css">
        body {
            background: <%=pc.getBgColor(hpid)%>;
        }

        <% if(isSetting) { %>
        td[coord] {
            border: 1px dashed #EA8237;
            border-top: none;
        }

        <%}%>

        <% if(Util.getIntValue(hpid) >0){%>
        .elementdatatable td {
            vertical-align: middle;
            padding-top: 2px;
            padding-bottom: 2px;
            line-height: 20px;
            font-size: 12px;
        }

        <%}else{%>
        .elementdatatable td {
            padding-top: 2px;
            padding-bottom: 2px;
            vertical-align: middle;
            line-height: 20px;
            font-size: 12px;
        }

        <%}%>

        <%=pu.getHpCss(hpid,nodelUserid,nodelUsertype,user,tempsubid)%>
        ;


    </STYLE>


    <SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
    <SCRIPT type="text/javascript" src="/js/jscolor/jscolor_wev8.js"></script>

    <link type='text/css' rel='stylesheet' href='/wui/theme/<%=curTheme %>/skins/<%=curskin %>/wui_wev8.css'/>
    <link type='text/css' rel='stylesheet' href='/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css'/>
    <link rel="stylesheet" href="/wui/theme/ecology8/templates/default/css/default2_wev8.css" type="text/css">
    </link>
    <script type="text/javascript" src="/wui/theme/ecology8/templates/default/js/default_wev8.js"></script>
</head>


<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = pageTitle;
    String needfav = "1";
    String needhelp = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<body scroll="auto" style="overflow-x:hidden !important; overflow-y: auto !important">

<input name='ispagesetting' type='hidden' value='<%=isSetting%>'>

<%
    boolean isALlLocked = false;
    if (pc.getIsLocked(hpid).equals("1")) isALlLocked = true;
    if ("true".equals(request.getParameter("isSetting"))) {
%>

<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td width="160px">
        </td>
        <td class="rightSearchSpan"
            style="text-align: right; width: 500px !important">
            <%


                if (!isALlLocked && Util.getIntValue(hpid) > 0 && subCompanyId > 0) {//协同区 暂无元素同步
                    if (nodelUsertype == 3 || nodelUsertype == 4) {
            %>
            <input type="button" value="<%=SystemEnv.getHtmlLabelName(19744,user.getLanguage())%>" id="zd_btn_submit_0"
                   class="e8_btn_top" onclick="doSynize()">

            <%} else { %>
            <input type="button" value="<%=SystemEnv.getHtmlLabelName(19744,user.getLanguage())%>" id="zd_btn_submit_0"
                   class="e8_btn_top" onclick="doSynizeNormal()">

            <% }
            }%>

            <% if (Util.getIntValue(hpid) < 0 && !HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) { %>
            <input id="synersyStatus" type="button" stas='<%=synersySatus %>'
                   value="<%="0".equals(synersySatus)?SystemEnv.getHtmlLabelName(31676,user.getLanguage()):SystemEnv.getHtmlLabelName(31675,user.getLanguage())%>"
                   id="zd_btn_submit_0" class="e8_btn_top" onclick="onChanageSynersyStatus(<%=hpid %>)">
            <%} %>
            <% if (Util.getIntValue(hpid) < 0 && HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) { %>
            <input type="button" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" id="zd_btn_submit_0"
                   class="e8_btn_top" onclick="closeDialogCallback()">
            <%} %>

            <input id="btnStatus" type="button" stas='show'
                   value="<%=SystemEnv.getHtmlLabelName(18466,user.getLanguage())%>" id="zd_btn_submit_0"
                   class="e8_btn_top" onclick="onChanageAllStatus(this)">


            <input id="btnElib" type="button" value="<%=SystemEnv.getHtmlLabelName(19614,user.getLanguage())%>"
                   id="zd_btn_submit_0" class="e8_btn_top" onclick="toggleELib()">


            &nbsp;&nbsp;&nbsp;
            <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
        </td>
    </tr>
</table>

<%
    }
%>

<%@ include file="/homepage/HpCss.jsp" %>
<%


%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    if (!isALlLocked && Util.getIntValue(hpid) > 0 && subCompanyId > 0) {
        if (nodelUsertype == 3 || nodelUsertype == 4) {
            RCMenu += "{" + SystemEnv.getHtmlLabelName(19744, user.getLanguage()) + ",javascript:doSynize(this),_self} ";
            RCMenuHeight += RCMenuHeightStep;
        } else {
            RCMenu += "{" + SystemEnv.getHtmlLabelName(19744, user.getLanguage()) + ",javascript:doSynizeNormal(this),_self} ";
            RCMenuHeight += RCMenuHeightStep;
        }
    }

    RCMenu += "{<span id=spanStatus status=show>" + SystemEnv.getHtmlLabelName(18466, user.getLanguage()) + "</span>,javascript:onChanageAllStatus(this),_self} ";
    RCMenuHeight += RCMenuHeightStep;
    if (isSetting) {
        RCMenu += "{<span>" + SystemEnv.getHtmlLabelName(19614, user.getLanguage()) + "</span>,javascript:toggleELib(this) ,_self} ";
        RCMenuHeight += RCMenuHeightStep;

        if ("addElement".equals(from)) {
            RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",javascript:window.history.go(-1),_self} ";
            RCMenuHeight += RCMenuHeightStep;

        }/* else if("setElement".equals(from)) {
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBackList(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	  }else {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	  }*/
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!--菜单TABLE begin-->
<%
    if (isSetting) {

    } else {


        if ((isfromportal == 0 || isfromhp == 1) && Util.getIntValue(hpid) > 0) {
%>
<%@ include file="/homepage/Navigation.jsp" %>
<%
        }

    }
%>
<!--Debug Div-->
<textarea id="txtDebug" style="width:100%;height:200px;display:none"></textarea>

<!--Show Div-->
<div id="divInfo"
     style="border:1px solid #8888AA; background:white;display:none;position:absolute;padding:5px;posTop:expression(document.body.offsetHeight/2+document.body.scrollTop-50);posLeft:expression(document.body.offsetWidth/2-50);z-index:100;"></div>

<% if (!HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype) && Util.getIntValue(hpid) < 0 && !isSetting) {%>
<div id="reldiv"
     style="border-color: #c3c3c3; border-bottom-width: 2px; border-bottom-style: solid; position: absolute; width: 0px; bottom: 0px; background-color: rgb(255, 255, 255); height: auto; overflow: hidden; top: 0px; right: 0px; display: block;">
    <div id=relbtn _status="0" onclick="javascript:runeffect(this)"
         style="text-align: center; width: 10px; background: #f6f7f9; float: left; height: 100%; color: #000; cursor: pointer; font-weight: bold; padding-top: 200px;border-left:solid 1px #c4c4c4">

    </div>
        <%} %>

    <!--Content Table-->
    <input type="hidden" value="btnWfCenterReload" id="btnWfCenterReload" name="btnWfCenterReload"
           onclick="elmentReLoad(8)">

        <%if(Util.getIntValue(hpid) < 0){ // 协同 需要用到的 div%>
    <div id="Element_ContainerDiv"
         style="height:100%;overflow-y:auto;overflow-x:hidden;<%if(!isSetting && !HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)){ %>background:#f6f7f9;<%} %>">
        <%} %>
        <table id="container_Table" width="100%">
            <tr>
                <%if (isSetting) { %>
                <td id="spanELib" style="width:150px;background-color:#F7F8FA;border-right:1px solid #DADADA">
                    <%
                        //modify by wshen
                        if ("1".equals(showElemFlag)) {
                            out.print(wpc.getAllElementList((Util.getIntValue(hpid) < 0) ? "" : pagetype, user, showElemList));
                        } else {
                            out.print(wpc.getAllElementList((Util.getIntValue(hpid) < 0) ? "" : pagetype, user));
                        }
                        //end
                        //out.print(wpc.getAllElementList((Util.getIntValue(hpid) < 0)?"":pagetype,user));
                    %>
                </td>
                <%} %>
                <td>
                    <div id="Element_Container"
                         style="width:100%;display:block;vertical-align:top;height:100%;margin-left: 1px;">

		<span id="spanContent" style="<%if(Util.getIntValue(hpid) < 0){%>padding-bottom:10px;<%}%> %>">
			  <%//pu.getBaseHpStr(hpid,layoutid,styleid,user,"hp",subCompanyId,isSetting)%>
			 <%=wpc.getHpAllElement(hpid, layoutid, styleid, subCompanyId + "", user, isSetting, request) %>
		</span>
                    </div>
                </td>
            </tr>
        </table>

        <%if (Util.getIntValue(hpid) < 0) { // 协同 需要用到的 div%>
    </div>
        <%} %>

    <div id='encodeHTML' style='display:none'></div>


    <link rel="stylesheet" href="/js/homepage/tabs/css/e8tabs_wev8.css" type="text/css"/>
    <script src="/js/homepage/tabs/jquery.tabs_wev8.js"></script>
    <script src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
    <!-- for scrollbar
<link rel="stylesheet" type="text/css"
	href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript"
	src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript"
	src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
-->
    <SCRIPT LANGUAGE="JavaScript">
        $(document).ready(function () {
            //jQuery("#Element_Container").perfectScrollbar();

            $(".ehover").bind("mouseover", function () {
                $(this).addClass("ehoverBg")
            })
            $(".ehover").bind("mouseout", function () {
                $(this).removeClass("ehoverBg")
            });
            <% if(Util.getIntValue(hpid)<0 && !isSetting ) {%>
            <% if(!HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {%>
            <% if(Util.getIntValue(hpid)>-28 ){%>
            $("#Element_Container").css("height", ($(window.top.document.body).height() - 120) + 'px');
            <%}else{%>
            $("#Element_Container").css("height", ($(window.top.document.body).height() - 60) + 'px');
            <%}%>
            <%}%>
            $("#Element_Container").css("overflow-y", "hidden");
            $("#Element_Container").css("overflow-x", "hidden");
            $("#Element_ContainerDiv").css("overflow-y", "hidden");
            <% }else if(Util.getIntValue(hpid)<0 ){ %>
            $("#Element_Container").css("overflow", "hidden");
            $("#Element_ContainerDiv").css("overflow-y", "auto");
            <%}%>
        });

        try {
            parent.defaultHpid = '<%=hpid%>';
        } catch (e) {
        }


        function elementsIsLoad() {
            var initedLength = $(".item[isinited!=true]").length;
            if (initedLength == 0) {
                if (parent.portalIframeLoadingOver) {
                    parent.portalIframeLoadingOver('<%=hpid%>', $("#Container").height());
                }
            }
        }


        /*修改相应元素位置 到到相应的元素下去*/
        function fixedPosition(eid) {
            //jQuery("#spanContent").height(document.body.scrollHeight+30);
            var oFrm = (function (p, t) {

                while (p != t) {
                    if (t.document.getElementById("mainFrame") != null)
                        return t.document.getElementById("mainFrame");
                    else
                        t = p;
                    p = p.parent;
                }
                return t.document.getElementById("mainFrame");
            })(window.parent, window);
            if (<%=isfromportal==1%>) { //从门户过的数据需要刷新页面宽度
                try {

                    if (parseInt(oFrm.style.height) < parseInt(document.body.scrollHeight)) {
                        oFrm.style.height = document.body.scrollHeight + "px";
                    } else {
                        oFrm.style.height = document.body.scrollHeight + "px";
                    }
                } catch (e) {
                    log(e)
                }
            } else {

                if (<%=Util.getIntValue(hpid)<0 %>) {
                    oFrm ? oFrm.style.height = "100%" : "";
                } else {
                    oFrm ? oFrm.style.height = "100%" : "";
                }

            }
            //jQuery("#Element_Container").perfectScrollbar('update');
        }
        function toggleELib(obj) {

            if ($('#spanELib').is(":hidden")) {
                $('#spanELib').show();
                $('#spanELib').css("margin", "10 0 0 10");
                $('#spanELib').css("width", "150px");
                $('#spanContent').css("width", document.body.clientWidth - 160);
                $(window.parent.document).find("#btnElib").attr("value", "<%=SystemEnv.getHtmlLabelName(19614,user.getLanguage())%>");
                if (typeof(obj) != "undefined")obj.lastChild.innerHTML = "<%=SystemEnv.getHtmlLabelName(19614,user.getLanguage())%>";
            } else {
                $('#spanELib').hide();
                $('#spanELib').css("width", "0%");
                $(window.parent.document).find("#btnElib").attr("value", "<%=SystemEnv.getHtmlLabelName(19613,user.getLanguage())%>");
                if (typeof(obj) != "undefined")obj.lastChild.innerHTML = "<%=SystemEnv.getHtmlLabelName(19613,user.getLanguage())%>";
            }
        }

        //=====================================协同开始

        var myin;
        var pbodyover;
        function runeffect(obj) {
            var _fnaBudgetAssistantCnt = <%=fnaBudgetAssistantCnt %>;
            var _fnaBudgetAssistant1Cnt = <%=fnaBudgetAssistant1Cnt %>;
            var _status = jQuery(obj).attr("_status");
            var _w = "430px";
            var _r = "418px";
            if (_fnaBudgetAssistantCnt > 0 || _fnaBudgetAssistant1Cnt > 0) {
                _w = "860px";
                _r = "848px";
            }

            if (_status == 1) {
                _w = "0px";
                _r = "0px";
                jQuery(obj).attr("_status", 0);
            } else {
                jQuery(obj).attr("_status", 1);
                $(window.parent.document).find("#synergy_framecontent").css("width", _w);
            }

            jQuery($(window.parent.document).find("#synergy_moveDiv")).animate({right: _r}, 300, null, function () {
                if (_status == 1) {
                    $(this).find("img").attr("src", "/page/resource/userfile/image/synergy/left_wev8.png");
                    $(this).attr("title", "<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(32832,user.getLanguage()) %>");
                    $("#Element_Container").css("overflow-y", "hidden");
                    $(window.parent.document.body).css("overflow-y", pbodyover);

                } else {
                    $(this).find("img").attr("src", "/page/resource/userfile/image/synergy/right_wev8.png");
                    $(this).attr("title", "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(32832,user.getLanguage()) %>");
                    $("#Element_Container").css("overflow-y", "auto");
                    $("#Element_Container").css("margin-right", "-30px");
                    pbodyover = $(window.parent.document.body).css("overflow-y");
                    $(window.parent.document.body).css("overflow-y", "hidden");

                }
            });
            jQuery("#reldiv").animate({width: _w}, 300, null, function () {
                if (_status == 1)
                    $(window.parent.document).find("#synergy_framecontent").css("width", _w);
            });

        }

        function docParamSetting(eid, ebaseid) {
            var sharelevel = $("input[name=_esharelevel_" + eid + "]").val();
            var ePerpageValue = 5;
            var dlg = new window.top.Dialog();//定义Dialog对象
            dlg.Model = true;
            dlg.Width = 800;//定义长度
            dlg.Height = 460;
            dlg.URL = "/synergy/maintenance/SynergyElementSet4Param.jsp?eid=" + eid + "&ebaseid=" + ebaseid + "&esharelevel=" + sharelevel + "&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>";
            dlg.Title = "<%=SystemEnv.getHtmlLabelName(84299,user.getLanguage())%>";
            dlg.callbackfun = function (datas) {
                if (datas) {
                    if (datas != "") {
                        datas = "SynergyParamXML:'" + datas + "'";
                    }
                    datas = "var postObj = {" + datas + "}";
                    eval(datas)
                    $.post('/synergy/browser/operationCommon.jsp?eid=' + eid + '&ebaseid=' + ebaseid + '&esharelevel=' + sharelevel + '&ePerpageValue=' + ePerpageValue + '&hpid=<%=hpid%>', postObj,
                            function (data) {
                                if ($.trim(data) == "") {
                                    //$("#setting_"+eid).hide();
                                    //$("#setting_"+eid).remove();
                                    if (ebaseid == "news" || parseInt(ebaseid) == 7 || parseInt(ebaseid) == 1 || parseInt(ebaseid) == 29) {
                                        $.post('/page/element/compatible/NewsOperate.jsp', {
                                            method: 'submit',
                                            eid: eid
                                        }, function (data) {
                                            if ($.trim(data) == "") {
                                                //$("#item_"+eid).attr('needRefresh','true')
                                                //$("#item_"+eid).trigger("reload");
                                            }
                                        });
                                    } else {
                                        //$("#item_"+eid).attr('needRefresh','true')
                                        //$("#item_"+eid).trigger("reload");
                                    }
                                }
                            }
                    );
                }
                dlg.close();
            }
            dlg.show();
        }


        function synParamSetting(eid, ebaseid) {
            var sharelevel = $("input[name=_esharelevel_" + eid + "]").val();
            var ePerpageValue = 5;
            var dlg = new window.top.Dialog();//定义Dialog对象
            dlg.Model = true;
            dlg.Width = 800;//定义长度
            dlg.Height = 460;
            dlg.URL = "/synergy/maintenance/SynergyElementSet4Param.jsp?eid=" + eid + "&ebaseid=" + ebaseid + "&esharelevel=" + sharelevel + "&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>";
            dlg.Title = "<%=SystemEnv.getHtmlLabelName(84299,user.getLanguage())%>";
            dlg.callbackfun = function (datas) {
                if (datas) {
                    if (datas != "") {
                        datas = "SynergyParamXML:'" + datas + "'";
                    }
                    datas = "var postObj = {" + datas + "}";
                    eval(datas)
                    $.post('/synergy/browser/operationCommon.jsp?eid=' + eid + '&ebaseid=' + ebaseid + '&esharelevel=' + sharelevel + '&ePerpageValue=' + ePerpageValue + '&hpid=<%=hpid%>', postObj,
                            function (data) {
                                if ($.trim(data) == "") {
                                    //$("#setting_"+eid).hide();
                                    //$("#setting_"+eid).remove();
                                    if (ebaseid == "news" || parseInt(ebaseid) == 7 || parseInt(ebaseid) == 1 || parseInt(ebaseid) == 29) {
                                        $.post('/page/element/compatible/NewsOperate.jsp', {
                                            method: 'submit',
                                            eid: eid
                                        }, function (data) {
                                            if ($.trim(data) == "") {
                                                //$("#item_"+eid).attr('needRefresh','true')
                                                //$("#item_"+eid).trigger("reload");
                                            }
                                        });
                                    } else {
                                        //$("#item_"+eid).attr('needRefresh','true')
                                        //$("#item_"+eid).trigger("reload");
                                    }
                                }
                            }
                    );
                }
                dlg.close();
            }
            dlg.show();
        }


        function showSynParamSetting2Wf(eid, tabid, ebaseid) {
            var ePerpageValue = 5;
            var sharelevel = $("input[name=_esharelevel_" + eid + "]").val();
            var dlg = new window.top.Dialog();//定义Dialog对象
            dlg.Model = true;
            dlg.Width = 460;//定义长度
            dlg.Height = 240;
            dlg.URL = "/synergy/maintenance/SynergyElementSet4Wf.jsp?pagetype=<%=pagetype%>&eid=" + eid + "&ispagedeal=<%=ispagedeal%>&ebaseid=" + ebaseid + "&tabid=" + tabid + "&esharelevel=" + sharelevel + "&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>&wfid=<%=wfid %>&nodeid=<%=nodeid %>";
            dlg.Title = "<%=SystemEnv.getHtmlLabelName(84301,user.getLanguage())%>";
            dlg.callbackfun = function (datas) {
                if (datas) {
                    if (datas != "") {
                        datas = "SynergyParamXML:'" + datas + "'";
                    }
                    datas = "var postObj = {" + datas + "}";
                    eval(datas)
                    $.post('/synergy/browser/operationCommon.jsp?eid=' + eid + '&ebaseid=' + ebaseid + '&tabid=' + tabid + '&esharelevel=' + sharelevel + '&ePerpageValue=' + ePerpageValue + '&hpid=<%=hpid%>', postObj,
                            function (data) {
                                if ($.trim(data) == "") {
                                    //$("#setting_"+eid).hide();
                                    //$("#setting_"+eid).remove();
                                    if (ebaseid == "news" || parseInt(ebaseid) == 7 || parseInt(ebaseid) == 1 || parseInt(ebaseid) == 29) {
                                        $.post('/page/element/compatible/NewsOperate.jsp', {
                                            method: 'submit',
                                            eid: eid
                                        }, function (data) {
                                            if ($.trim(data) == "") {
                                                //$("#item_"+eid).attr('needRefresh','true')
                                                //$("#item_"+eid).trigger("reload");
                                            }
                                        });
                                    } else {
                                        //$("#item_"+eid).attr('needRefresh','true')
                                        //$("#item_"+eid).trigger("reload");
                                    }
                                }
                            }
                    );
                }
                dlg.close();
            }
            dlg.show();
        }

        //=====================================协同结束

        function closeDialogCallback() {
            var hpid = "<%=hpid %>";

            //获取元素详细信息
            var elements = "";
            var items = $(".item");
            for (var i = 0, length = items.length; i < length; i++) {
                //var id = $(items[i]).attr("eid");
                var name = $(items[i]).find(".title").text();

                elements += name + ",";
            }

            $.post(
                    "/homepage/maint/HomepageForWorkflowOperation.jsp",
                    {method: "getFormFilterId", hpid: "<%=hpid%>"},
                    function (data) {
                        var result = {
                            hpid: hpid,
                            elements: elements.substring(0, elements.length - 1),
                            trifields: $.trim(data)
                        };

                        var dialog = parent.parentDialog;   //弹出窗口的引用，用于关闭页面
                        dialog.close(result);
                    }
            );


        }

        function onAddElement(ebaseid, styleid) {

            var hpid = "<%=hpid%>";
            if (hpid == '' || hpid == 0) {
                top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30776,user.getLanguage())%>");
                return;
            }
            var hpstyleid = "<%=styleid%>";
            if (hpstyleid != "") styleid = hpstyleid;

            ////=======协同区开始
            if (hpid < 0) {
                var suffix = $(".item").length + 1;
                if (suffix > 6) {
                    var i = 0;
                    i = Math.floor(suffix / 6);
                    suffix = suffix - 6 * i;
                }
                styleid = styleid + suffix;
            }
            ////=======协同区结束
            if ($(".item").length == 10) {
                if (confirm("<%=SystemEnv.getHtmlLabelName(84090,user.getLanguage())%>")) {
                    url = "/homepage/element/ElementPreview.jsp?ebaseid=" + ebaseid + "&styleid=" + styleid + "&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&fromModule=Portal&layoutflag=A";
                    GetContent("divInfo", url, true);
                }
            } else {
                url = "/homepage/element/ElementPreview.jsp?ebaseid=" + ebaseid + "&styleid=" + styleid + "&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&fromModule=Portal&layoutflag=A";
                GetContent("divInfo", url, true);
            }

        }

        function onDel(eid) {
            if (!confirm("<%=SystemEnv.getHtmlLabelName(19747,user.getLanguage())%>")) return;

            var group = $($("#item_" + eid).parents(".group")[0]);
            var flag = group.attr("areaflag");
            var eids = "";

            $(group).children("div .item").each(function () {
                if ($(this).attr("eid") != eid)    eids += $(this).attr("eid") + ",";
            });
            //alert(eids);
            $.get("/homepage/element/EsettingOperate.jsp",
                    {
                        method: "delElement",
                        hpid: "<%=hpid%>",
                        eid: eid,
                        delFlag: flag,
                        delAreaElement: eids,
                        subCompanyId: "<%=subCompanyId%>"
                    },
                    function (data) {
                        if ($.trim(data) == "") {
                            $("#item_" + eid).remove();
                        } else {
                            alert($.trim(data))
                        }
                    }
            );
        }

        var randomValue;
        function onSetting(eid, ebaseid) {


            //获取设置页面内容
            var settingUrl = "/page/element/setting.jsp?pagetype=<%=pagetype%>&eid=" + eid + "&ebaseid=" + ebaseid + "&hpid=<%=hpid%>&subcompanyid=<%=subCompanyId%>";
            $.post(settingUrl, null,
                    function (data) {
                        if ($.trim(data) != "") {
                            $("#setting_" + eid).hide();
                            $("#setting_" + eid).remove();
                            $("#content_" + eid).prepend($.trim(data))
                            //$("#setting_"+eid+" .weavertabs").weavertabs({selected:0});

                            $(".tabs").PortalTabs({
                                getLine: 1,
                                topHeight: 40
                            });
                            $(".tab_box").height(0);
                            $("#setting_" + eid).show();
                            $("#weavertabs-content-" + eid).show();

                            var urlContent = $.trim($("#weavertabs-content-" + eid).attr("url")).replace(/&amp;/g, "&");
                            var urlStyle = $.trim($("#weavertabs-style-" + eid).attr("url")).replace(/&amp;/g, "&");
                            var urlShare = $.trim($("#weavertabs-share-" + eid).attr("url")).replace(/&amp;/g, "&");

                            //alert(document.getElementById("weavertabs-content-"+eid));

                            if (urlContent != "") {
                                if (ebaseid == 7 || ebaseid == 8 || ebaseid == 1 || ebaseid == 'news' || ebaseid == 29 || ebaseid == 'reportForm' || ebaseid == "OutData") {
                                    //randomValue =Math.round(Math.random()*(100-1)+1)
                                    randomValue = new Date().getTime();
                                    $("#setting_" + eid).attr("randomValue", randomValue);
                                }
                                urlContent = urlContent + "&random=" + randomValue;

                                $("#weavertabs-content-" + eid).html("")
                                $("#weavertabs-content-" + eid).html("<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(19611,user.getLanguage())%>...");
                                $("#weavertabs-content-" + eid).load(urlContent, {}, function () {
                                    //alert($("#weavertabs-content-"+eid).html())
                                    //$("#tabDiv_"+eid).dialog('destroy');
                                    $("#sync_datacenter_" + eid).tzCheckbox({labels: ['', '']});
                                    $(".filetree").filetree();
                                    $(".vtip").simpletooltip();
                                    fixedPosition(eid);
                                    jscolor.init();
                                    //初始化layout组件
                                    initLayout();
                                });
                            }
                            if (urlStyle != "") $("#weavertabs-style-" + eid).load(urlStyle, {}, function () {

                                var checkimg = $("#eLogo_" + eid).attr("value");
                                $("#weavertabs-style-" + eid + " .filetree").filetree({"file": checkimg});
                                //$("#weavertabs-style-"+eid+" .filetree").filetree();
                                //初始化layout组件
                                initLayout();
                                $("#weavertabs-style-" + eid).hide();

                            });

                            if (urlShare != "") $("#weavertabs-share-" + eid).load(urlShare, {}, function () {
                                //$("#weavertabs-share-"+eid+" .filetree").filetree();
                                $("#weavertabs-share-" + eid).hide();
                            });
                        }

                    });

            //以下处理所有tabs插件


            //log("urlContent:"+urlContent);
            //log("urlStyle:"+urlStyle);
        }
        function doUseSetting(eid, ebaseid) {

            /*对知识订阅元素进行特殊处理*/
            if (ebaseid == 34) {
                var begin = document.getElementById("begindate_" + eid).value;
                var end = document.getElementById("enddate_" + eid).value;
                if (begin != "" && end != "") {
                    if (begin > end) {
                        alert("<%=SystemEnv.getHtmlLabelName(24569,user.getLanguage())%>");
                        return;
                    }
                }
            }
            //common部分处理
            var ePerpageValue = 5;
            var eShowMoulde = '0';
            var eLinkmodeValue = '';
            var esharelevel = '';
            try {
                if (document.getElementById("_ePerpage_" + eid) != null) {
                    ePerpageValue = $("#_ePerpage_" + eid).val();
                }
                if (document.getElementById("_eShowMoulde_" + eid) != null) {
                    eShowMoulde = document.getElementById("_eShowMoulde_" + eid).value;
                }
                if (document.getElementById("_eLinkmode_" + eid) != null) {
                    eLinkmodeValue = $("#_eLinkmode_" + eid).val();
                }

                esharelevel = $("input[name=_esharelevel_" + eid + "]").val();
            } catch (e) {
            }
            var eFieldsVale = "";
            var chkFields = document.getElementsByName("_chkField_" + eid);
            if (chkFields != null) {
                for (var i = 0; i < chkFields.length; i++) {
                    var chkField = chkFields[i];
                    if (chkField.checked) eFieldsVale += chkField.value + ",";
                }
                if (eFieldsVale != "") eFieldsVale = eFieldsVale.substring(0, eFieldsVale.length - 1);
            }
            var imsgSizeStr = "";
            if ($("input[name=_imgWidth" + eid + "]").val()) {

                var imgWidth = $("input[name=_imgWidth" + eid + "]").val();
                var imgHeight = $("input[name=_imgHeight" + eid + "]").val();

                if (imgWidth.replace(/(^\s*)|(\s*$)/g, "") == "") {
                    imgWidth = "0";
                }
                if (imgHeight.replace(/(^\s*)|(\s*$)/g, "") == "") {
                    imgHeight = "0";
                }
                var imgSize = imgWidth + "*" + imgHeight;

                imsgSizeStr = "imgSize_" + $("input[name=_imgWidth" + eid + "").attr("basefield");
            }

            var imgType = 0;
            var imgSrc = "";
            if (document.getElementById("_imgType" + eid) != null) {
                imgType = document.getElementById("_imgType" + eid).value;

                if (imgType == 1) {
                    imgSrc = $("#_imgsrc" + eid).val();
                }
            }

            //得到上传时的字数标准

            var newstemplateStr = "";
            if (document.getElementById("_newstemplate" + eid) != null) {
                newstemplateStr = document.getElementById("_newstemplate" + eid).value
            }
            var eTitleValue = "";
            var whereKeyStr = "";
            if (esharelevel == "2") {
                var eTitleValue = document.getElementById("_eTitel_" + eid).value;
                var _whereKeyObjs = document.getElementsByName("_whereKey_" + eid);
                if (eTitleValue.indexOf('%') != -1) {
                    //alert("<%=SystemEnv.getHtmlLabelName(20858,user.getLanguage())%>");
                    //return;
                }
                //alert(escape(eTitleValue));
                $("#title_" + eid).html(eTitleValue.replace(/ /gi, "&nbsp;"));
                $("#title_" + eid).append("<span id='count_" + eid + "'></span>");
                var multiETitleValue = jQuery("#__multilangpre__eTitel_" + eid + jQuery("#_eTitel_" + eid).attr("rnd_lang_tag")).val();
                eTitleValue = multiETitleValue || eTitleValue;
                eTitleValue = eTitleValue.replace(/\\/g, "\\\\");
                eTitleValue = eTitleValue.replace(/'/g, "\\'");
                eTitleValue = eTitleValue.replace(/"/g, "\\\"");
                if (ebaseid == 'notice') {
                    onchanges(eid);
                }
                //newstr=newstr.replace(/&/g,"',");
                //eTitleValue = $("#title_"+eid).html();
                //eTitleValue = escape(eTitleValue)
                //得到上传的SQLWhere语句
                if (ebaseid !== "reportForm") {
                    for (var k = 0; k < _whereKeyObjs.length; k++) {
                        var _whereKeyObj = _whereKeyObjs[k];
                        if (_whereKeyObj.tagName == "INPUT" && _whereKeyObj.type == "checkbox" && !_whereKeyObj.checked) continue;
                        if (ebaseid == 'reportForm') {
                            if (_whereKeyObj.tagName == "INPUT" && _whereKeyObj.type == "radio" && !_whereKeyObj.checked) continue;
                        }
                        whereKeyStr += _whereKeyObj.value + "^,^";
                    }
                }
                //else if(ebaseid == "reportForm"){
                //       $("#tabSetting_"+eid +" tr").find(".ctitle").each(function(i){
                //       	whereKeyStr += $(this).attr("sqlWhere")+"_$_";
                //       })
                //   }
            }
            if (whereKeyStr != "") whereKeyStr = whereKeyStr.substring(0, whereKeyStr.length - 3);
            whereKeyStr = whereKeyStr.replace(/'/g, "\\'");
            //当日计划特殊处理
            if (ebaseid == 15) {
                whereKeyStr = $("#_whereKey_" + eid).val();
            }

            //仅对多文档中心元素进行此处理，修正td21552
            if (whereKeyStr != null && $.trim(whereKeyStr) != "" && ebaseid == '17') {
                var whereStr = $.trim(whereKeyStr).split('^,^');
                if (whereStr[1] != null && whereStr[1] != "" && whereStr[1].length != 0) {
                    $("#more_" + eid).attr("href", "javascript:openFullWindowForXtable('/page/element/compatible/more.jsp?ebaseid=" + ebaseid + "&eid=" + eid + "')");
                    $("#more_" + eid).attr("morehref", "/page/element/compatible/more.jsp?ebaseid=" + ebaseid + "&eid=" + eid);
                } else {
                    $("#more_" + eid).attr("href", "#");
                    $("#more_" + eid).attr("morehref", "");
                }
            }


            var scolltype = "";
            if (document.getElementsByName("_scolltype" + eid).length > 0) {
                scolltype = document.getElementsByName("_scolltype" + eid)[0].value;
                //whereKeyStr+="^,^"+scolltype;

            }

            //alert(scolltype);
            //eTitleValue=eTitleValue.replace(/&/g, "%26");//把eTitleValue中的&换成%26;
            //eTitleValue = encodeURIComponent(eTitleValue)
            //alert(eTitleValue)
            //用户自定义元素内容部分

            //相关的样式设置部分
            var eLogo = $("#eLogo_" + eid).val();
            var eStyleid = $("#eStyleid_" + eid).val();
            var eHeight = $("#eHeight_" + eid).val();
            var eMarginTop = $("#eMarginTop_" + eid).val();
            var eMarginBottom = $("#eMarginBottom_" + eid).val();
            var eMarginLeft = $("#eMarginLeft_" + eid).val();
            var eMarginRight = $("#eMarginRight_" + eid).val();
            var eIsNew = "";
            var eIsBold = "";
            var eIsRgb = "";
            var eNewColor = "";
            var eIsLean = "";

            if ($("#isnew_" + eid).attr("checked") == true) {
                eIsNew = $("#isnew_" + eid).val();
            }
            if ($("#isbold_" + eid).attr("checked") == true) {
                eIsBold = $("#isbold_" + eid).val();
            }
            if ($("#isrgb_" + eid).attr("checked") == true) {
                eIsRgb = $("#isrgb_" + eid).val();
            }
            if ($("#islean_" + eid).attr("checked") == true) {
                eIsLean = $("#islean_" + eid).val();
            }
            var eNewColor = "#" + $("#newcolor_" + eid).val();

            //相关的共享设置部分
            var operationurl = $.trim($("#setting_" + eid).attr("operationurl")).replace(/&amp;/g, "&");
            //alert(eid)
            var postStr = "eid:'" + eid + "',eShowMoulde:'" + eShowMoulde + "',ebaseid:'" + ebaseid + "',eTitleValue:'" + eTitleValue + "',ePerpageValue:'" + ePerpageValue + "',eLinkmodeValue:'" + eLinkmodeValue + "',";
            postStr += "eFieldsVale:'" + eFieldsVale + "',imgSizeStr:'" + imgSize + "',whereKeyStr:'" + whereKeyStr + "',esharelevel:'" + esharelevel + "',hpid:'" + '<%=hpid%>' + "',subCompanyId:'" + '<%=subCompanyId%>' + "',";
            postStr += "eLogo:'" + eLogo + "',eStyleid:'" + eStyleid + "',eHeight:'" + eHeight + "',newstemplate:'" + newstemplateStr + "',imgType:'" + imgType + "',imgSrc:'" + imgSrc + "',eScrollType:'" + scolltype + "',"
            postStr += "eMarginTop:'" + eMarginTop + "',eMarginBottom:'" + eMarginBottom + "',eMarginLeft:'" + eMarginLeft + "',eMarginRight:'" + eMarginRight + "',isnew:'" + eIsNew + "',isbold:'" + eIsBold + "',isrgb:'" + eIsRgb + "',islean:'" + eIsLean + "',newcolor:'" + eNewColor + "'";

            /*对外部数据元素的内容进行特殊处理*/
            if (ebaseid == "OutData") {
                var nums = $("#nums_" + eid).val();
                postStr = "eid:'" + eid + "',eShowMoulde:'" + eShowMoulde + "',ebaseid:'" + ebaseid + "',eTitleValue:'" + eTitleValue + "',ePerpageValue:'" + nums + "',eLinkmodeValue:'" + eLinkmodeValue + "',";
                postStr += "eFieldsVale:'" + eFieldsVale + "',imgSizeStr:'" + imgSize + "',whereKeyStr:'" + whereKeyStr + "',esharelevel:'" + esharelevel + "',hpid:'" + '<%=hpid%>' + "',subCompanyId:'" + '<%=subCompanyId%>' + "',";
                postStr += "eLogo:'" + eLogo + "',eStyleid:'" + eStyleid + "',eHeight:'" + eHeight + "',newstemplate:'" + newstemplateStr + "',imgType:'" + imgType + "',imgSrc:'" + imgSrc + "',eScrollType:'" + scolltype + "',"
                postStr += "eMarginTop:'" + eMarginTop + "',eMarginBottom:'" + eMarginBottom + "',eMarginLeft:'" + eMarginLeft + "',eMarginRight:'" + eMarginRight + "',isnew:'" + eIsNew + "',isbold:'" + eIsBold + "',isrgb:'" + eIsRgb + "',islean:'" + eIsLean + "',newcolor:'" + eNewColor + "'";
                postStr += ",nums:'" + nums + "'";

            }
            
			if(ebaseid=="CoreMail") {
				var coreMailSysid = $("#coreMailSysid_"+eid).val();
				if(coreMailSysid == "") {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129952,user.getLanguage()) %>");
					return;
				}
			}
            var wordcountStr = "";
            var _wordcountObjs = document.getElementsByName("_wordcount_" + eid);

            for (var j = 0; j < _wordcountObjs.length; j++) {
                var wordcountObj = _wordcountObjs[j];
                var basefield = $(wordcountObj).attr("basefield");
                wordcountStr += "&wordcount_" + basefield + "=" + wordcountObj.value;
                postStr += ",wordcount_" + basefield + ":'" + wordcountObj.value + "'";
            }


            var custformitem = $("#setting_form_" + eid);
            if (custformitem.length === 0 && (ebaseid === 'DataCenter' || ebaseid === 'searchengine' || ebaseid === 'news' || ebaseid === 'menu' || ebaseid === 'Flash' || ebaseid === 'notice' || ebaseid === 'picture' || ebaseid === 'scratchpad' || ebaseid === 'weather' || ebaseid === 'favourite' || ebaseid === 'video' || ebaseid === 'Slide' || ebaseid === 'audio' || ebaseid === 'jobsinfo' || ebaseid === 'addwf' || ebaseid === 'outterSys')) {
                custformitem = $("#weavertabs-content-" + eid);
                if (ebaseid === 'DataCenter' || ebaseid === 'picture' || ebaseid === 'weather' || ebaseid === 'news' || ebaseid === 'menu' || ebaseid === 'Flash' || ebaseid === 'favourite' || ebaseid === 'video' || ebaseid === 'Slide' || ebaseid === 'audio' || ebaseid === 'jobsinfo' || ebaseid === 'addwf' || ebaseid === 'outterSys') {
                    var pitem = custformitem.parent();
                    var pitem = custformitem.parent();
                    custformitem = $("<form id='#setting_form_" + eid + "'></form>").append(custformitem);
                    pitem.append(custformitem);
                } else
                    custformitem = $("<form></form>").append(custformitem.clone());
            }

            //自定义表单参数处理
            var newstrform = custformitem.serialize();
            //alert(ebaseid);
            //alert(custformitem.html());
            var paramstr = newstrform.split("&");
            var newitem = {};

            var parammap;
            for (var i = 0; i < paramstr.length; i++) {
                parammap = paramstr[i].split("=");
                newitem[parammap[0]] = decodeURIComponent(parammap[1]).replace(/\+/g, " ").replace(/&lt;/g, "<").replace(/&gt;/g, ">");
            }

            var newstr = "";
            if (ebaseid == "weather") {
                var weatherWidth;
                var wWidth = $("#content_view_id_" + eid).width();
                if (newstr != null && newstr != "" && newstr.length != 0) {
                    var weatherWidth = newstr.substring(newstr.lastIndexOf("'") + 1);
                    var reg = new RegExp("[\+\]", "g");
                    weatherWidth = weatherWidth.replace(reg, "");
                    if (weatherWidth == null ||
                            weatherWidth == "" ||
                            isNaN(weatherWidth) ||
                            parseFloat(weatherWidth) > parseFloat(wWidth) ||
                            parseFloat(weatherWidth) <= 0) {
                        var lNewStr = newstr.substring(0, newstr.lastIndexOf("'") + 1);
                        newstr = lNewStr + wWidth;
                    } else {
                        var lNewStr = newstr.substring(0, newstr.lastIndexOf("'") + 1);
                        newstr = lNewStr + weatherWidth;
                    }
                }
            } else if (ebaseid == "FormModeCustomSearch") {
                var pageform = $("#setting_form_" + eid);

                var formmode_esharelevel = $("[name='_esharelevel_" + eid + "']").val();
                var formmode_reportId = $("#reportId_" + eid).val();
                var formmode_fields = $("#fields_" + eid).val();
                var formmode_fieldsWidth = $("#fieldsWidth_" + eid).val();

                newstr = "_esharelevel_" + eid + ":'" + formmode_esharelevel + "',"
                        + "reportId_" + eid + ":'" + formmode_reportId + "',"
                        + "fields_" + eid + ":'" + formmode_fields + "',"
                        + "fieldsWidth_" + eid + ":'" + formmode_fieldsWidth + "";
            }

            if (newstr != "") {
                postStr = postStr + "," + newstr + "'";
            }
            //alert(encodeURI(postStr))
            postStr = "var postObj = {" + postStr + "}";
            eval(postStr);

            //添加表单参数
            for (var item in newitem) {
                postObj[item] = newitem[item];
            }
            var orderStr = getTabOrders(eid);
            $.post(operationurl, postObj,
                    function (data) {
                        if ($.trim(data) == "") {
                            $("#setting_" + eid).hide();
                            $("#setting_" + eid).html('');
                            $("#setting_" + eid).remove();
                            if (ebaseid == "reportForm" || ebaseid == "news" || parseInt(ebaseid) == 7 || parseInt(ebaseid) == 1 || parseInt(ebaseid) == 29) {
                                $.post('/page/element/compatible/NewsOperate.jsp', {
                                    method: 'submit',
                                    eid: eid,
                                    orders: orderStr
                                }, function (data) {
                                    if ($.trim(data) == "") {
                                        $("#item_" + eid).attr('needRefresh', 'true');
                                        $("#item_" + eid).trigger("reload");
                                    }
                                });
                            } else {
                                $("#item_" + eid).attr('needRefresh', 'true');
                                $("#item_" + eid).trigger("reload");
                            }
                        } else {
                            data = $.parseJSON($.trim(data));
                            if (data && data.__result__ === false) {
                                top.Dialog.alert(data.__msg__);
                            }
                        }
                    }
            );
            if (window.frames["eShareIframe_" + eid] && esharelevel == "2") {
                window.frames["eShareIframe_" + eid].document ? window.frames["eShareIframe_" + eid].document.getElementById("frmAdd_" + eid).submit() : "";
            }

            if (ebaseid == "menu") {
                setTimeout(function rload() {
                    location.reload();
                }, 200);
            }

            //元素共享设置提交


            //} catch(e){
            //	 alert(e)
            //}
            fixedPosition(eid);
        }

        function onUseSetting(eid, ebaseid) {
            if ($("#reportId_" + eid).val() == "" && ebaseid == "FormModeCustomSearch") {
                Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>", function () {
                });//必要信息不完整！
                return;
            }
            if (ebaseid == 8) { /*对流程中心元素进行特殊处理*/
                doWorkflowEleSet(eid, ebaseid);
                //return;
            } else {
                doUseSetting(eid, ebaseid);
            }
        }


        function onLockOrUn(eid, ebaseid, obj) {

            if (confirm("<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>")) {

                divInfo.style.display = 'inline';
                var url;


                if (jQuery(obj).attr("status") == "unlocked") {
                    url = "/homepage/element/EsettingOperate.jsp?method=locked&eid=" + eid + "&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
                } else {
                    url = "/homepage/element/EsettingOperate.jsp?method=unlocked&eid=" + eid + "&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
                }
                log(url)
                $.get(url, {}, function (data) {
                    log($.trim(data));

                    divInfo.style.display = 'none';
                    if (jQuery(obj).attr("status") == "unlocked") {
                        jQuery(obj).attr("status", "locked");
                    } else {
                        jQuery(obj).attr("status", "unlocked");
                    }
                    //
                    jQuery(obj).children(":first").attr("src", $.trim(data));
                });

            }
        }

        function MoveEData(srcFlag, targetFlag) {
            var srcItemEids = "";
            $(".group[areaflag=" + srcFlag + "]>.item").each(function (i) {
                if (this.className == "item") {
                    srcItemEids += $(this).attr("eid") + ",";
                }
            })

            var targetItemEids = "";
            $(".group[areaflag=" + targetFlag + "]>.item").each(function (i) {
                if (this.className == "item") {
                    targetItemEids += $(this).attr("eid") + ",";
                }
            })
            //log("src"+srcFlag+"-"+srcItemEids);
            //log("target:"+targetFlag+"-"+targetItemEids);

            var url = "/homepage/element/EsettingOperate.jsp?method=editLayout&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&srcFlag=" + srcFlag + "&targetFlag=" + targetFlag + "&srcStr=" + srcItemEids + "&targetStr=" + targetItemEids;
            GetContent(divInfo, url, false);

        }
        function doSynize(obj) {
            window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>', function () {
                //obj.disabled=true;
                divInfo.style.display = 'inline';
                var code = "divInfo.style.display=\"none\";";
                var url = '/homepage/maint/HomepageMaintOperate.jsp?method=synihp&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>'
                GetContentForSynize(divInfo, url, false, code);
            });
        }
        function doSynizeNormal(obj) {
            var isNeedRefresh = 1;

            window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>', function () {
                //obj.disabled=true;
                divInfo.style.display = 'inline';
                var code = "divInfo.style.display=\"none\";";
                var url = '/homepage/maint/HomepageMaintOperate.jsp?method=synihpnormal&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>'
                GetContentForSynize(divInfo, url, false, code, isNeedRefresh);
            });
        }

        //菜单
        function onMenuDivClick(hpid, subCompanyId) {
            window.location = "/homepage/Homepage.jsp?hpid=" + hpid + "&subCompanyId=" + subCompanyId + "&isfromportal=<%=isfromportal%>&isfromhp=<%=isfromhp%>"
        }


        /**
         删除Tab页
         */
        function deleTab(eid, tabId, ebaseid) {
            var formAction = "";
            if (parseInt(ebaseid) == 8) {
                formAction = "/homepage/element/setting/WorkflowCenterOpration.jsp";
            } else if (ebaseid == "reportForm" || ebaseid == "news" || parseInt(ebaseid) == 7 || parseInt(ebaseid) == 1 || parseInt(ebaseid) == 29) {
                formAction = "/page/element/compatible/NewsOperate.jsp";
            } else if (ebaseid == "OutData") {
                if (confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>")) {
                    formAction = "/page/element/OutData/tabOperation.jsp?type=";
                } else {
                    return;
                }
            }
            var para = {method: 'delete', eid: eid, tabId: tabId};
            $.post(formAction, para, function (data) {
                if ($.trim(data) == "") {
                    try {
                        var tabArr = tabId.split(";");
                        for (var i = 0; i < tabArr.length; i++) {
                            $("#setting_" + eid).find("#tab_" + eid + "_" + tabArr[i]).parent().parent().remove();
                        }
                    } catch (e) {
                        $("#setting_" + eid).find("#tab_" + eid + "_" + tabId).parent().parent().remove();
                    }

                }
            });

        }
        function batchDeleTab(eid, ebaseid) {
            var tableId = 'tabSetting_';
//	var rows = [];
            var j = 0;
            var tabIds = "";
            $("#" + tableId + eid + " tr").find('[name=checkrow_' + eid + ']').each(function (i) {
                if ($(this).attr('checked')) {
                    //	rows[j++] = $(this).parent().parent();
                    j++;
                    tabIds += $(this).parent().parent().find('[tabId]').attr('tabId') + ";";
                }
            })
            if (j == 0) {
                top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
            } else {
                top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>', function () {
                    tabIds = tabIds.substring(0, tabIds.length - 1);
                    //if('reportForm' == ebaseid){
                    //	var tabArr = tabIds.split(";");
                    //	for(var i=0; i <tabArr.length; i ++){
                    //		$("#setting_"+eid).find("#tab_"+eid+"_"+tabArr[i]).parent().parent().remove();
                    //	}
                    //}else{
                    deleTab(eid, tabIds, ebaseid);
                    //}
                    $('#checkAll_' + eid).attr("checked", false);
                });
            }
        }

        /**
         打开对话框
         */
        var tab_dialog;
        function showTabDailog(eid, method, tabId, url, ebaseid) {
            var whereKeyStr = "";
            var showCopy = "1";
            var countFlag = "1";
            // 更换弹出窗口为zDialog
            if (true) {
                url += "&ebaseid=" + ebaseid + "&method=" + method;
                if ("reportForm" == ebaseid) {
                    url += "&pagetype=<%=pagetype%>&ispagedeal=<%=ispagedeal%>&wfid=<%=wfid %>&nodeid=<%=nodeid %>";
                }
                tab_dialog = new window.top.Dialog();
                tab_dialog.currentWindow = window;   //传入当前window
                tab_dialog.Width = 630;
                tab_dialog.Height = 500;
                tab_dialog.Modal = true;
                tab_dialog.Title = "<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>";
                tab_dialog.URL = url;
                tab_dialog.show();
                return;
            }
            /*try{
             $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("name","dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue"));

             $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("src",url);
             $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).bgiframe();
             //$("#tabDiv_"+eid).dialog('destroy');
             $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog({
             id:tabId,
             bgiframe: true,
             autoOpen: false,
             height: 630,
             width:450,
             draggable:true,
             modal: true,
             buttons: {
             '
            <%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>': function() {
             $(this).dialog('destroy');
             },
             '
            <%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>': function() {
             // 准备Tab页条件数据
             var formParams ={};
             var formAction ="";
             var tabTitle ="";
             var displayTitle="";
             if(parseInt(ebaseid)==8){
             $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#btnSave").trigger("click")
             formAction =$("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").attr("action")
             tabTitle = $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#tabTitle_"+eid).attr("value")
             displayTitle = $("#encodeHTML").text(tabTitle).html();
             $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#tabTitle").attr("value",tabTitle);
             $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#tabId").attr("value",tabId);
             $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#method").attr("value",method);
             formParams = $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").serializeArray();
             if($("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#showCopy_"+eid).attr("checked")){
             showCopy = "1"
             }else{
             showCopy = "0"
             }
             $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#showCopy").attr("value",showCopy);
             formAction ="/homepage/element/setting/"+formAction;
             }else if(ebaseid=="news" || parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
             formAction ="/page/element/compatible/NewsOperate.jsp";
             tabTitle = $("#dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).contents().find("#tabTitle_"+eid).attr("value")
             displayTitle = $("#encodeHTML").text(tabTitle).html();

             whereKeyStr = window.frames["dialogIframe_"+eid+"_"+$("#setting_"+eid).attr("randomValue")].getNewsSettingString(eid);

             formParams ={eid:eid,tabId:tabId,tabTitle:tabTitle,tabWhere:whereKeyStr,method:method};
             }
             if(tabTitle==''){
             alert('
            <%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>')
             return false;
             }
             //alert(formAction)
             $.post(formAction,formParams,function(data){
             //alert(data)
             if($.trim(data)==""){
             if(method=='add'){
             $("#tabSetting_"+eid+">tbody").append("<TR><TD><span id = tab_"+eid+"_"+tabId+" tabId='"+tabId+"' tabTitle='' tabWhere='"+whereKeyStr+"' showCopy='"+showCopy+"'></span></TD><TD width=100 lign='right'><a href='javascript:deleTab("+eid+","+tabId+",\""+ebaseid+"\")'>
            <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> &nbsp;&nbsp; <a href='javascript:editTab("+eid+","+tabId+",\""+ebaseid+"\")'>
            <%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%></a></TD></TR>")
             $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("tabCount",tabId);
             $("#tab_"+eid+"_"+tabId).html(displayTitle);
             $("#tab_"+eid+"_"+tabId).attr("tabTitle",tabTitle);
             }else{
             $("#tab_"+eid+"_"+tabId).html(displayTitle);
             $("#tab_"+eid+"_"+tabId).attr("tabTitle",tabTitle);
             $("#tab_"+eid+"_"+tabId).attr("showCopy",showCopy);
             $("#tab_"+eid+"_"+tabId).attr("tabWhere",whereKeyStr);
             }
             $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog('close');
             } else {
             $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog('close');
             }
             });
             }
             },

             close: function() {
             $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog('destroy');

             }
             });
             $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).dialog('open');
             $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).height(373);
             }catch(e){
             alert(e.message)
             }*/
        }

        function doTabSave(eid, ebaseid, tabId, method) {
            // 准备Tab页条件数据
            var tabDocument = tab_dialog.innerDoc
            var tabWindow = tab_dialog.innerWin
            var whereKeyStr = "";
            var showCopy = "1";
            var countFlag = "1";
            var formParams = {};
            var formAction = "";
            var tabTitle = "";
            var orderNum = "0";
            if (method == 'add') {
                orderNum = $("#tabSetting_" + eid).length;
            } else {
                orderNum = $("#tab_" + eid + "_" + tabId).attr("orderNum");
            }

            var displayTitle = "";
            if (parseInt(ebaseid) == 8) {
                $(tabDocument).find("#ifrmViewType_" + eid).contents().find("#btnSave").trigger("click")
                formAction = $(tabDocument).find("#ifrmViewType_" + eid).contents().find("#frmFlwCenter").attr("action")
                tabTitle = $(tabDocument).find("#tabTitle_" + eid).attr("value")
                var multiTabTitle = $(tabDocument).find("#__multilangpre_tabTitle_" + eid + $(tabDocument).find("#tabTitle_" + eid).attr("rnd_lang_tag")).attr("value");
                var tabTitle0 = tabTitle;
                tabTitle = multiTabTitle || tabTitle;
                displayTitle = $("#encodeHTML").text(tabTitle0).html();
                $(tabDocument).find("#ifrmViewType_" + eid).contents().find("#frmFlwCenter").find("#tabTitle").attr("value", tabTitle);
                $(tabDocument).find("#ifrmViewType_" + eid).contents().find("#frmFlwCenter").find("#tabId").attr("value", tabId);
                $(tabDocument).find("#ifrmViewType_" + eid).contents().find("#frmFlwCenter").find("#method").attr("value", method);
                //	$(tabDocument).find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").find("#orderNum").attr("value",orderNum);
                if ($(tabDocument).find("#showCopy_" + eid).attr("checked")) {
                    showCopy = "1"
                } else {
                    showCopy = "0"
                }
                $(tabDocument).find("#ifrmViewType_" + eid).contents().find("#frmFlwCenter").find("#showCopy").attr("value", showCopy);
                if ($(tabDocument).find("#countFlag_" + eid).attr("checked")) {
                    countFlag = "1"
                } else {
                    countFlag = "0"
                }
                $(tabDocument).find("#ifrmViewType_" + eid).contents().find("#frmFlwCenter").find("#countFlag").attr("value", countFlag);
                //序列化表单
                formParams = $(tabDocument).find("#ifrmViewType_" + eid).contents().find("#frmFlwCenter").serializeArray();
                formAction = "/homepage/element/setting/" + formAction;
            } else if (ebaseid == "news" || parseInt(ebaseid) == 7 || parseInt(ebaseid) == 1 || parseInt(ebaseid) == 29) {
                formAction = "/page/element/compatible/NewsOperate.jsp";
                tabTitle = $(tabDocument).find("#tabTitle_" + eid).attr("value");
                var multiTabTitle = $(tabDocument).find("#__multilangpre_tabTitle_" + eid + $(tabDocument).find("#tabTitle_" + eid).attr("rnd_lang_tag")).attr("value");
                //alert("-------****tabTitle****------"+tabTitle+" --------*********multiTabTitle*******----------"+multiTabTitle);
                //console.log("-------****tabTitle****------"+tabTitle+" --------*********multiTabTitle*******----------"+multiTabTitle);
                var tabTitle0 = tabTitle;
                tabTitle = multiTabTitle || tabTitle;
                displayTitle = $("#encodeHTML").text(tabTitle0).html();
                //	orderNum =$(tabDocument).find("#orderNum_"+eid).attr("value");
                //displayTitle = $("#encodeHTML").text(tabTitle).html();

                whereKeyStr = tabWindow.getNewsSettingString(eid);
                formParams = {eid: eid, tabId: tabId, tabTitle: tabTitle, tabWhere: whereKeyStr, method: method};//
            } else if (ebaseid == "reportForm") {
                formAction = "/page/element/compatible/NewsOperate.jsp";
                tabTitle = $(tabDocument).find("#tabTitle_" + eid).attr("value");
                var multiTabTitle = $(tabDocument).find("#__multilangpre_tabTitle_" + eid + $(tabDocument).find("#tabTitle_" + eid).attr("rnd_lang_tag")).attr("value");
                //alert("-------****tabTitle****------"+tabTitle+" --------*********multiTabTitle*******----------"+multiTabTitle);
                //console.log("-------****tabTitle****------"+tabTitle+" --------*********multiTabTitle*******----------"+multiTabTitle);
                var tabTitle0 = tabTitle;
                tabTitle = multiTabTitle || tabTitle;
                displayTitle = $("#encodeHTML").text(tabTitle0).html();
                //	orderNum =$(tabDocument).find("#orderNum_"+eid).attr("value");
                //displayTitle = $("#encodeHTML").text(tabTitle).html();

                whereKeyStr = tabWindow.getNewsSettingString(eid);
                formParams = {
                    ebaseid: 'reportForm',
                    eid: eid,
                    tabId: tabId,
                    tabTitle: tabTitle,
                    sqltabWhere: whereKeyStr,
                    method: method
                };//
            }

            if (tabTitle == '') {
                alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>')
                return false;
            }

            //		formParams['orderNum']=orderNum;
            //alert(formAction)
            $.post(formAction, formParams, function (data) {
                if ($.trim(data) == "") {
                    if (method == 'add') {
                        //		var posOr = getTabPos(eid,orderNum,"tabSetting_"+eid);
                        var tabHtmlStr = '';
                        if (<%=Util.getIntValue(hpid)<0 %> &&
                        (parseInt(ebaseid) == 8) && (<%="wf".equals(pagetype) %> ||
                        <%=HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype) %>))
                        {// 协同
                            tabHtmlStr = "<TR><TD><input type='checkbox' name='checkrow_" + eid + "'/>&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>'/></TD><TD><span id = tab_" + eid + "_" + tabId + " orderNum='" + orderNum + "' tabId='" + tabId + "' tabTitle=''  showCopy='" + showCopy + "' countFlag='" + countFlag + "'></span></TD><TD width=200 lign='right'><a href='javascript:deleTab(" + eid + "," + tabId + ",\"" + ebaseid + "\")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> &nbsp;&nbsp;&nbsp;  <a href='javascript:editTab(" + eid + "," + tabId + ",\"" + ebaseid + "\")'><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%></a>&nbsp;&nbsp;<a href='javascript:showSynParamSetting2Wf(" + eid + "," + tabId + ",\"" + ebaseid + "\")'><%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%></a></TD></TR>";
                            //			    $("#tabSetting_"+eid+">tbody").append(tabHtmlStr);
                        }
                    else
                        {
                            tabHtmlStr = "<TR><TD><input type='checkbox' name='checkrow_" + eid + "'/>&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>'/></TD><TD><span id = tab_" + eid + "_" + tabId + " orderNum='" + orderNum + "' tabId='" + tabId + "' tabTitle=''  showCopy='" + showCopy + "'></span></TD><TD width=200 lign='right'><a href='javascript:deleTab(" + eid + "," + tabId + ",\"" + ebaseid + "\")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> &nbsp;&nbsp;&nbsp;  <a href='javascript:editTab(" + eid + "," + tabId + ",\"" + ebaseid + "\")'><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%></a></TD></TR>";
                            //		       $("#tabSetting_"+eid+">tbody").append(tabHtmlStr);
                        }
                        tabHtmlStr += "<tr class='Spacing' style='height:1px!important;'><td colspan='3' class='paddingLeft0Table'><div class='intervalDivClass' style='display:block''></div></td></tr>";
                        $("#tabSetting_" + eid + ">tbody").append(tabHtmlStr);
                        /*	if(posOr != -1){
                         $("#tabSetting_"+eid+">tbody").find('[id='+posOr+']').parent().parent().before(tabHtmlStr);
                         }else {

                         }*/

                        $("#tabDiv_" + eid + "_" + $("#setting_" + eid).attr("randomValue")).attr("tabCount", tabId);
                        $("#tab_" + eid + "_" + tabId).html(displayTitle);
                        $("#tab_" + eid + "_" + tabId).attr("tabTitle", tabTitle);
                    } else {
                        $("#tab_" + eid + "_" + tabId).html(displayTitle);
                        $("#tab_" + eid + "_" + tabId).attr("tabTitle", tabTitle);
                        $("#tab_" + eid + "_" + tabId).attr("showCopy", showCopy);
                        $("#tab_" + eid + "_" + tabId).attr("countFlag", countFlag);
                        $("#tab_" + eid + "_" + tabId).attr("tabWhere", whereKeyStr);
                        /*	if(orderNum != $("#tab_"+eid+"_"+tabId).attr('orderNum')){
                         $("#tab_"+eid+"_"+tabId).attr("orderNum",orderNum);
                         var posOr = getTabPos(eid,orderNum,"tabSetting_"+eid,"tab_"+eid+"_"+tabId);
                         var tempHtml = "<TR>"+$("#tab_"+eid+"_"+tabId).parent().parent().html()+"</TR>";
                         $("#tab_"+eid+"_"+tabId).parent().parent().remove();
                         if(posOr != -1){
                         $("#tabSetting_"+eid+">tbody").find('[id='+posOr+']').parent().parent().before(tempHtml);
                         }else {
                         $("#tabSetting_"+eid+">tbody").append(tempHtml);
                         }
                         }*/
                    }
                    tab_dialog.close();
                } else {
                    data = $.parseJSON($.trim(data));
                    if (data && data.__result__ === false) {
                        top.Dialog.alert(data.__msg__);
                    }
                    //tab_dialog.close();
                }
            });

        }

        /**
         验证SQL语句
         */
        function checkSql(Obj) {
            var sqlStr = jQuery(Obj).val();//event.srcElement.value;
            sqlStr = sqlStr.replace(/\n/g, "");
            sqlStr = sqlStr.replace(/\r/g, "");
            event.srcElement.value = sqlStr;
            sqlStr = " " + sqlStr.toUpperCase();
            if (sqlStr.indexOf(' INSERT ') != -1 || sqlStr.indexOf(' UPDATE ') != -1 || sqlStr.indexOf(' DELETE ') != -1 || sqlStr.indexOf(' CREATE ') != -1 || sqlStr.indexOf(' DROP ') != -1) {
                //event.srcElement.value = "";
                jQuery(Obj).val("");
                alert("<%=SystemEnv.getHtmlLabelName(22949,user.getLanguage())%>")
            }
        }
        function onBack() {
            var pagetype = "<%=pagetype %>";
            if (pagetype == "loginview") {

                window.location = "/homepage/base/LoginBase.jsp?hpid=<%=hpid%>";

            }
            else {
                window.location = '/homepage/base/HomepageBase.jsp?hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&opt=<%=opt%>';
            }
        }
        function onBackList() {
            var pagetype = "<%=pagetype %>";
            if (pagetype == "loginview") {
                window.location = "/homepage/maint/LoginPageContent.jsp";
            }
            else {
                window.location = '/homepage/maint/HomepageRight.jsp?subCompanyId=<%=subCompanyId%>';
            }
        }
        function onOk() {
            window.location = "/homepage/maint/HomepageRight.jsp?subCompanyId=<%=subCompanyId%>";
        }


        function onAddedOrUn(eid, ebaseid, obj) {
            divCenter.style.display = 'inline';
            var code = "divCenter.style.display=\"none\";";
            if (jQuery(obj).attr("status") == "add") {
                if (confirm("<%=SystemEnv.getHtmlLabelName(21775,user.getLanguage())%>")) {
                    jQuery(obj).attr("status", "remove");
                    obj.src = '/images/homepage/style/style1/remove_wev8.png';
                    url = "/homepage/element/EsettingOperate.jsp?method=addtoass&eid=" + eid;
                    GetContent(divCenter, url, false, code);
                }
            } else {
                if (confirm("<%=SystemEnv.getHtmlLabelName(21776,user.getLanguage())%>")) {
                    jQuery(obj).attr("status", "add");
                    obj.src = '/images/homepage/style/style1/add_wev8.png';
                    url = "/homepage/element/EsettingOperate.jsp?method=removefromass&eid=" + eid;
                    GetContent(divCenter, url, false, code);
                }
            }
        }


        //菜单
        function onMenuDivClick(hpid, subCompanyId) {
            window.location = "/homepage/Homepage.jsp?hpid=" + hpid + "&subCompanyId=" + subCompanyId + "&isfromportal=<%=isfromportal%>&isfromhp=<%=isfromhp%>"
        }

        //过滤元素标题中的特殊字符
        function checkTextValid(id) {
            return true;
            //注意：修改####处的字符，其它部分不许修改.
            //if(/^[^####]*$/.test(form.elements[i].value))

            if (/^[^\"+-\\|:;,='<>]*$/.test($("#" + id).val())) {
                return true;
            } else {
                alert("<%=SystemEnv.getHtmlLabelName(24950,user.getLanguage())%>:" + "\"+-\\|:;,='<>")
                $("#" + id).val($("#" + id).attr("defautvalue"));
                return false;
            }
        }

        function showUnreadNumber(accountId) {
            var oSpan = document.getElementById("span" + accountId);
            var oIframe = document.getElementById("iframe" + accountId);
            var unreadMailNumber;
            if (oIframe.contentWindow.document.body.innerText) {
                unreadMailNumber = jQuery.trim(oIframe.contentWindow.document.body.innerText);
            } else {
                unreadMailNumber = jQuery.trim(oIframe.contentWindow.document.body.lastChild.textContent);
            }
            oSpan.innerHTML = unreadMailNumber == -1 ? "<img src='/images/BacoError_wev8.gif' align='absmiddle' alt='<%=SystemEnv.getHtmlLabelName(20266,user.getLanguage())%>'>" : "(<b>" + unreadMailNumber + "</b>)";
        }


    </SCRIPT>

    <%@ include file="/js/homepage/Homepage_js.jsp" %>

    <SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
    <SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
    <SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>

        <%
if("true".equals(request.getParameter("isSetting"))&&false){
	%>
    <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
    <div id="zDialog_div_bottom" class="zDialog_div_bottom">
        <wea:layout needImportDefaultJsAndCss="false">
            <wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
                <wea:item type="toolbar">
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"
                           id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();"/>
                </wea:item>
            </wea:group>
        </wea:layout>
    </div>

        <%
}
%>
    <div style='height: 35px;width: auto;margin: 5px;border: 1px dashed rgb(18, 17, 17);display:none;'
         class='itemholder'></div>


    <script src="/page/layoutdesign/js/jquery-ui_wev8.js"></script>
    <script>
        var hoveritem = undefined;
        var itemholder = $(".itemholder");
        $("#spanELib td a").draggable({
            helper: "clone",
            start: function (event, ui) {
                var helper = ui.helper;
                helper.addClass("dragitemholder");

            }, drag: function (event, ui) {
                if (hoveritem !== undefined) {
                    var items = hoveritem.find(".item");
                    var itemtemp;
                    var offset = ui.offset;
                    var itemoffset;
                    var itemheight;
                    var flag = true;
                    for (var i = 0, len = items.length; i < len; i++) {
                        itemtemp = $(items[i]);
                        itemoffset = itemtemp.offset();
                        itemheight = itemtemp.height();
                        if (offset.top > itemoffset.top && offset.top < itemoffset.top + itemheight) {
                            if (itemtemp.prev() === itemholder)
                                return;
                            itemholder.insertBefore(itemtemp);
                            itemholder.show();
                            return;
                        }
                        if (i === (len - 1))
                            flag = false;
                    }
                    if (!flag || items.length === 0) {
                        hoveritem.find(".group").append(itemholder);
                        itemholder.show();
                    }
                }
            }
        });
        //将td注册drop事件
        $(".group").parent().droppable({
            over: function (event, ui) {
                hoveritem = $(event.target);
            },
            drop: function (event, ui) {
                var ebaseid = ui.helper.attr("ebaseid");
                var styleid = "<%=styleid%>";
                if (ebaseid == null || styleid == null) {
                    return;
                }
                ////=======协同区开始
                if ("<%=hpid%>" < 0) {
                    var suffix = $(".item").length + 1;
                    if (suffix > 6) {
                        var i = 0;
                        i = Math.floor(suffix / 6);
                        suffix = suffix - 6 * i;
                    }
                    styleid = styleid + suffix;
                }
                ////=======协同区结束

                var areaflag = hoveritem.find(".group").attr("areaflag");
                var newurl = "/homepage/element/ElementPreview.jsp?ebaseid=" + ebaseid + "&styleid=" + styleid + "&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&fromModule=Portal&layoutflag=" + areaflag;
                GetContentForDragAdd("divInfo", newurl, true);
                //鼠标移除则隐藏占位框
            }, out: function (event, ui) {

                itemholder.hide();
            }
        });

        function doTabSave2(eid, ebaseid, tabId, para, sign) {
            if (sign != "0") {
                return;
            }
            var tabDocument = tab_dialog.innerDoc;
            var tabWindow = tab_dialog.innerWin;
            var showCopy = "1";
            var formAction = "";
            var tabTitle = "";
            var displayTitle = "";
//	var orderNum = para.orderNum;
            formAction = "/page/element/OutData/tabOperation.jsp";
            tabTitle = $(tabDocument).find("#tabTitle_" + eid).attr("value");
            //displayTitle = $("#encodeHTML").text(tabTitle).html();
            var multiTabTitle = $(tabDocument).find("#__multilangpre_tabTitle" + $(tabDocument).find("#tabTitle_" + eid).attr("rnd_lang_tag")).attr("value");
            var tabTitle0 = tabTitle;
            tabTitle = multiTabTitle || tabTitle;
            displayTitle = $("#encodeHTML").text(tabTitle0).html();
            var formParams;
            if (para.type == '1') {
                formParams = {
                    eid: eid,
                    tabId: tabId,
                    method: para.method,
                    addrUrl: para.addrUrl,
                    addrId: para.addrId,
                    type: para.type,
                    tabTitle: tabTitle
                };
            } else {
                formParams = {
                    eid: eid,
                    tabId: tabId,
                    method: para.method,
                    addrUrl: para.addrUrl,
                    addrId: para.addrId,
                    type: para.type,
                    tabTitle: tabTitle,
                    pattern: para.pattern,
                    source: para.source,
                    area: para.area,
                    dataKey: para.dataKey,
                    fieldname: para.fieldname,
                    searchname: para.searchname,
                    isshowname: para.isshowname,
                    transql: para.transql,
                    wsAddr: para.wsAddr,
                    wsMethod: para.wsMethod,
                    wsPara: para.wsPara,
                    href: para.href,
                    sysAddr: para.sysAddr
                };
            }


            $.post(formAction, formParams, function (data) {
                if ($.trim(data) == 'no') {
                    top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())+SystemEnv.getHtmlLabelName(127826,user.getLanguage())%>');
                } else {
                    if (para.method == 'add') {
                        //onSetting(eid,ebaseid);
                        $("#tabtable").append("<TR><TD><span id = tab_" + eid + "_" + tabId + " tabId='" + tabId + "' tabTitle='' showCopy='" + showCopy + "'></span></TD><TD width=100 lign='right'><a href='javascript:deleTab(" + eid + "," + tabId + ",\"" + ebaseid + "\")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> &nbsp;&nbsp; <a href='javascript:editTab(" + eid + "," + tabId + ",\"" + ebaseid + "\")'><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%></a></TD></TR>")
                        $("#tabDiv_" + eid + "_" + $("#setting_" + eid).attr("randomValue")).attr("tabCount", tabId);
                        $("#tab_" + eid + "_" + tabId).html(displayTitle);
                        $("#tab_" + eid + "_" + tabId).attr("tabTitle", tabTitle);
                    } else {
                        $("#tab_" + eid + "_" + tabId).html(displayTitle);
                        $("#tab_" + eid + "_" + tabId).attr("tabTitle", tabTitle);
                        $("#tab_" + eid + "_" + tabId).attr("showCopy", showCopy);
                        //$("#tab_"+eid+"_"+tabId).attr("tabWhere",whereKeyStr);
                    }
                    tab_dialog.close();
                }
            });

        }

    </script>
</body>
</html>
