<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="init.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow" %>
<%@ page isELIgnored="false" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.FileInputStream" %>
<jsp:useBean id="searchResultBean" class="weaver.fullsearch.SearchResultBean"/>
<jsp:setProperty name="searchResultBean" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="searchResultBean" property="user" value="<%=user%>"/>
<jsp:setProperty name="searchResultBean" property="key" param="key"/>
<jsp:setProperty name="searchResultBean" property="page" param="page"/>
<jsp:setProperty name="searchResultBean" property="searchType" param="searchType"/>
<jsp:setProperty name="searchResultBean" property="contentType" param="contentType"/>
<jsp:setProperty name="searchResultBean" property="sourceType" param="sourceType"/>
<jsp:setProperty name="searchResultBean" property="cusContentType" param="cusContentType"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<%
    String searchfrom = Util.null2String(request.getParameter("searchfrom")).trim();
    String key2 = Util.null2String(request.getParameter("key")).trim();
    String hideTitle = Util.null2String(request.getParameter("hideTitle"));
    String noCheckStr = Util.null2String(request.getParameter("noCheck"));
    String contentType = Util.null2String(request.getParameter("contentType"));
    boolean noCheck = "1".equals(noCheckStr);
    Map searchInfos = null;
    if ("".equals(key2) && !noCheck) {
        //顶部快捷搜索为空时的跳转
        request.getRequestDispatcher("Search.jsp").forward(request, response);
        return;
    } else {
        pageContext.setAttribute("key", searchResultBean.getKey());
        pageContext.setAttribute("searchType", searchResultBean.getSearchType());
        pageContext.setAttribute("contentType", searchResultBean.getContentType());
        pageContext.setAttribute("cusContentType", searchResultBean.getCusContentType());
        pageContext.setAttribute("sourceType", searchResultBean.getSourceType());
        searchInfos = searchResultBean.getSearchInfos();
        if (searchInfos == null) {
            request.getRequestDispatcher("Search.jsp?FLAG=-1&MSG=" + "<b style='color:red;'>" + SystemEnv.getHtmlLabelName(83416, user.getLanguage()) + "</b>").forward(request, response);
            return;
        }
        List as = (List) searchInfos.get("allSchemas");
        pageContext.setAttribute("allSchemas", as);
    }
    boolean useAdSearch = "1".equals(BaseBean.getPropValue("QuickSearch", "useES"));
    String needRemind = BaseBean.getPropValue("QuickSearch", "needRemind");//等于1 需要提醒
    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(String.valueOf(user.getUID()));
    InputStream in=new FileInputStream(GCONST.getRootPath()+"WEB-INF/searchInf.properties");
    Properties prop = new Properties();
    prop.load(in);
    in.close();
    String docShowE9 = prop.getProperty("e9.doc.show");
%>
<jsp:useBean id="hotkey" class="weaver.fullsearch.bean.HotKeysBean"/>
<jsp:setProperty name="hotkey" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="hotkey" property="user" value="<%=user%>"/>
<jsp:setProperty name="hotkey" property="key" param="key"/>
<% if ("1".equals(searchfrom)) {
    hotkey.setInit(true);
}%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=10"/>
    <title><%=SystemEnv.getHtmlLabelName(18446, user.getLanguage())%>
    </title>
    <style type="text/css">
        <!--
        * {
            font-family: 微软雅黑;
        }

        .result b {
            color: #fe4722;
        }

        .images_table {
            FONT-SIZE: 13px
        }

        .images_table TD {
            PADDING-BOTTOM: 20px;
            LINE-HEIGHT: 17px;
            PADDING-RIGHT: 16px;
        }

        .images_table IMG {
            BORDER-BOTTOM: #ccc 1px solid;
            BORDER-LEFT: #ccc 1px solid;
            PADDING-BOTTOM: 1px;
            PADDING-LEFT: 1px;
            PADDING-RIGHT: 1px;
            BORDER-TOP: #ccc 1px solid;
            BORDER-RIGHT: #ccc 1px solid;
            PADDING-TOP: 1px;
            max-width: 140px;
            max-height: 140px;
            _width: expression((this.offsetWidth > 140) ? "140px" : this.offsetWidth + "px" );
            /*_width: expression(Math.min(this.offsetWidth, 150) + "px");*/
            _height: expression((this.offsetHeight > 140) ? "140px" : this.offsetHeight + "px" );
            /*_height: expression(Math.min(this.offsetHeight, 150) + "px");*/
            border: none;
            width: 140px;
            height: 140px;
            PADDING: 0px;
        }

        .imgdiv IMG {
            BORDER-BOTTOM: #ccc 1px solid;
            BORDER-LEFT: #ccc 1px solid;
            PADDING-BOTTOM: 1px;
            PADDING-LEFT: 1px;
            PADDING-RIGHT: 1px;
            BORDER-TOP: #ccc 1px solid;
            BORDER-RIGHT: #ccc 1px solid;
            PADDING-TOP: 1px;
            margin: 5px;
            top: 50%;
            left: 50%;
            max-width: 750px;
            max-height: 450px;
            _width: expression((this.offsetWidth > 750) ? "750px" : this.offsetWidth + "px" );
            /*_width: expression(Math.min(this.offsetWidth, 750) + "px");*/
            _height: expression((this.offsetHeight > 450) ? "450px" : this.offsetHeight + "px" );
            /*_height: expression(Math.min(this.offsetHeight, 450) + "px");*/
        }

        CITE {
            FONT-STYLE: normal;
            COLOR: #093
        }

        .images_table .mcDiv {
            border: 1px solid #B8B8B8;
            width: 158px;
            height: 176px;
        }

        .images_table a {
            text-decoration: none;
        }

        .images_table .mcDiv .contentDiv {
            PADDING: 2px;
            text-align: center;
            height: 154px;
            width: 154px;
            position: relative;
        }

        .images_table .mcDiv .contentDiv .simgDiv {
            width: 148px;
            height: 148px;
            PADDING: 3px;
        }

        .search_tool_la {
            display: block;
            float: left;
            font-size: 12px;
            color: #666;
            cursor: pointer;
            max-width: 80px;
            text-overflow: ellipsis;
            white-space: nowrap;
            overflow: hidden;
        }

        .c-icon {
            display: inline-block;
            vertical-align: text-bottom;
            font-style: normal;
            width: 14px;
            height: 11px;
            overflow: hidden;
            background-image: url(../images/fullsearch/arrow.png);
        }

        .c-icon-delete {
            display: inline-block;
            vertical-align: text-bottom;
            font-style: normal;
            width: 10px;
            height: 10px;
            overflow: hidden;
            background-image: url(../images/fullsearch/delete.png);
            float: left;
            background-size: 100%;
            margin-top: 2.5px;
            margin-right: 2.5px;
        }

        .images_table .mcDiv .titleDiv {
            position: absolute;
            left: 0px;
            bottom: 3px;
            height: 18px;
            PADDING-left: 5px;
            PADDING-right: 5px;
            display: block;
            text-align: center;
            overflow: hidden;
            text-overflow: ellipsis;
            -o-text-overflow: ellipsis;
        }

        .images_table .mcDiv .overDiv {
            display: none;
            position: absolute;
            left: 0px;
            top: 0px;
            height: 150px;
            text-align: center;
            overflow: hidden;
            text-overflow: ellipsis;
            -o-text-overflow: ellipsis;
            width: 100%;
            background: #f4f4f4 !important;
            line-height: 20px
        }

        .divShow {
            display: block !important;
        }

        .btn_openall {

        }

        .btnclass {
            z-index: 9999;
            margin-right: 10px;
            font-size: 13px;
            cursor: pointer;
            margin-top: 5px;
            height: 20px;
            display: inline-block;
        }

        .btnleft {
            background: url(../images/bg/btn_new_wev8.png) no-repeat transparent;
            background-position: top left;
            height: 21px;
            cursor: pointer;
            float: left;
            padding-left: 15px;
            padding-top: 2px;
            padding-right: 15px;
        }

        .btnright {
            background: url(../images/bg/btn_new_wev8.png) no-repeat transparent;
            background-position: top right;
            height: 23px;
            width: 2px;
            float: right;
        }

        #so-nav-more {
            min-width: 50px;
            position: absolute;
            z-index: 0;
            margin-left: 485px;
            top: 5px;
            padding: 0;
            line-height: 30px;
            text-align: left;
            border: 1px #dedede solid;
            background: #FFF;
            list-style: none;
            display: none
        }

        #so-nav-more a {
            width: 100%;
            display: block;
            margin: 0;
            text-indent: 10px;
            text-decoration: none;
            cursor: pointer;
            color: #666;
            font-size: 15px;
        }

        #so-nav-more a:hover {
            background-color: #f1f1f1
        }

        .moreType {
            width: 20px;
            height: 24px;
            line-height: 24px;
            float: left;
            margin-left: 0px;
            text-align: center;
            cursor: pointer;
            color: #191919;
            font-size: 14px;
        }

        .hrmDiv a {
            text-decoration: none !important;
        }

        .hrmDiv a:link {
            color: #242424;
        }

        .hrmDiv a:hover {
            color: #018efb !important;
        }

        .hrmDiv a:visited {
            color: #242424;
        }

        .remind_tip {
            position: absolute;
            top: 10px;
            font-size: 14px;
            line-height: 22px;
            margin-left: 10px;
        }

        .remind_tip_op {
            color: #4AA0F6;
            position: absolute;
            right: 0px;
            cursor: pointer;
        }

        .remind_tip_text {
            height: 31px;
            background-color: #fff9c9;
            line-height: 31px;
            -moz-border-radius: 8px;
            -webkit-border-radius: 8px;
            border-radius: 8px 8px 8px 8px;
            padding: 2px 15px 2px 15px;
            color: #000000;
            margin-top: 28px;

        }

        /*向左箭头*/
        div.arrow-left {
            width: 0;
            height: 0;
            border-right: 12px solid #fff9c9;
            border-bottom: 12px solid transparent;
            border-top: 12px solid transparent;
            font-size: 0;
            line-height: 0;
            position: absolute;
            top: 44px;
        }

        .c-tip-con {
            position: absolute;
            z-index: 1;
            background: #fff;
            border: 1px solid rgba(0, 0, 0, .2);
            transition: opacity .218s;
            box-shadow: 0 2px 4px rgba(0, 0, 0, .2);
            font-size: 12px;
            line-height: 20px;
        }

        .c-tip-timerfilter-si-submit {
            display: inline;
            padding: 4px 10px;
            margin: 0;
            color: #333;
            border: 1px solid #d8d8d8;
            font-family: inherit;
            font-weight: 400;
            vertical-align: 0;
            background-color: #f9f9f9;
            outline: 0;
            text-decoration: none;
            cursor: pointer;
            margin-left: 10px;
        }

        .c-tip-con .c-tip-timerfilter ul {
            width: 115px;
            text-align: left;
            color: #666;
            margin: 0;
            padding: 0 10px 0 10px;
            list-style: none;
            -webkit-margin-before: 0.5em;
            -webkit-margin-after: 0.5em;
            -webkit-margin-start: 0px;
            -webkit-margin-end: 0px;
        }

        .c-tip-con .c-tip-timerfilter li {
            margin: 0;
            padding: 0;
            list-style: none;
            display: list-item;
            text-align: -webkit-match-parent;
            margin-bottom: 5px;
            cursor: pointer;
        }

        .c-tip-con .c-tip-menu li a {
            text-decoration: none;
            cursor: pointer;
            background-color: #fff;
            padding: 3px 0;
            color: #666;
        }

        .c-tip-con .c-tip-timerfilter li .c-tip-custom-submit, .c-tip-con .c-tip-timerfilter li .c-tip-timerfilter-si-submit {
            display: inline;
            padding: 4px 10px;
            margin: 0;
            color: #333;
            border: 1px solid #d8d8d8;
            font-family: inherit;
            font-weight: 400;
            text-align: center;
            vertical-align: 0;
            background-color: #f9f9f9;
            outline: 0;
        }

        #dateTip li:hover {
            background-color: #EBEBEB;
        }

        .sTitle a {
            text-decoration: underline !important;
            color: #42a4fe !important;
        }

        .calHdBtn {
            margin-bottom: 5px;
            line-height: 20px;
            text-align: center;
            width: 20px;
            height: 20px !important;
            cursor: pointer;
            display: inline-block;
            float: left;
            opacity: 1;
            background-position: 1px 50%;
            color: #999 !important;
        }

        .c-tip-con span {
            white-space: nowrap;
        }

        -->
    </style>
    <%if (user.getLanguage() == 7) {%>
    <script src="/js/ecology8/lang/weaver_lang_7_wev8.js" type="text/javascript"></script>
    <%} else if (user.getLanguage() == 9) {%>
    <script src="/js/ecology8/lang/weaver_lang_8_wev8.js" type="text/javascript"></script>
    <%} else {%>
    <script src="/js/ecology8/lang/weaver_lang_9_wev8.js" type="text/javascript"></script>
    <%} %>
    <script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
    <script src="/js/init_wev8.js" type="text/javascript"></script>
    <script type="text/javascript" src="../js/placeholder_wev8.js"></script>
    <script language="javascript" src="../js/weaver_wev8.js"></script>
    <script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
    <script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
    <jsp:include page="/systeminfo/DatepickerLangJs.jsp">
        <jsp:param name="languageId" value="<%=user.getLanguage()%>"/>
    </jsp:include>
    <jsp:include page="/systeminfo/WdCalendarLangJs.jsp">
        <jsp:param name="languageId" value="<%=user.getLanguage()%>"/>
    </jsp:include>
    <script src="/workplan/calendar/src/Plugins/Common_wev8.js" type="text/javascript"></script>
    <script src="/workplan/calendar/src/Plugins/json2_wev8.js" type="text/javascript"></script>
    <script src="/meeting/calendar/src/Plugins/jquery.datepickernew_wev8.js" type="text/javascript"></script>
    <script src="/workplan/calendar/src/Plugins/jquery.calendar_wev8.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="/js/ecology8/jNice/jNice/jNice_wev8.css"/>
    <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css"/>
    <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css"/>
    <link href="../css/changebg_wev8.css" rel="stylesheet" type="text/css"/>
    <link href="/workplan/calendar/css/calendar_wev8.css" rel="stylesheet" type="text/css"/>
    <link href="/workplan/calendar/css/dp_wev8.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="/js/poshytip-1.2/tip-yellowsimple/tip-yellowsimple_wev8.css" type="text/css"/>
    <script type="text/javascript">
        var con = new Array(10);
        var storage = window.localStorage;
        var jsonString = {};
        var noCheck = ("1" == "${noCheck}");
        var p = "${pageInfo}";
        var cpage = "${cpage}";
        var maxPerPage = "${maxPerPage}";
        var recordCount = "${recordCount}";
        var startRecordNum = "${startRecordNum}";
        var endRecordNum = "${endRecordNum}";
        var pages = "${pages}";
        var param = "${key}";
        var page = "${page}";
        var isLastPage = "${isLastPage}";
        var isNoResult = "${isNoResult}";

        function dosubmit(show) {
            var key = jQuery("#key").val();
            if (key == jQuery("#key").attr("placeholder")) {
                key = "";
            }
            var continueSearch = false;
            if (jQuery("#contentType").val() != "ALL" && noCheck == "true") {
                continueSearch = true;
            }
            if (key == "" && !continueSearch) {
                jQuery("#key").focus();
            } else {
                key = key.replace(new RegExp("&amp;quot;", "gm"), "\"");
                key = key.replace(new RegExp("&amp;", "gm"), " ");
                key = key.replace(new RegExp("&", "gm"), " ");
                jQuery("#key").val(key);
                jQuery(".summary").html("");
                jQuery(".result").html("");
                jQuery("#pageInfo").html("");
                jQuery("#searchtsInfo").css("display", "");
                if ($("#sourceType").val() == "") {
                    var sourceType = "PC";
                } else {
                    var sourceType = $("#sourceType").val();
                }
                $.ajax({
                    url: "AjaxSearchResult.jsp",
                    type: "POST",
                    data: {
                        "page": $("#page").val(),
                        "searchfrom": $("#searchfrom").val(),
                        "hideTitle": $("#hideTitle").val(),
                        "noCheck": $("#noCheck").val(),
                        "searchType": $("#searchType").val(),
                        "sourceType": sourceType,
                        "contentType": $("#contentType").val(),
                        "cusContentType": $("#cusContentType").val(),
                        "key": $("#key").val(),
                        "jsonString": JSON.stringify(jsonString),
                        "belongtoShow": "<%=belongtoshow%>",
                        "userId": $("#uid").val(),
                        "action": "search"
                    },
                    success: function (result) {
                        jQuery("#searchtsInfo").css("display", "none");
                        var searchResult = eval('(' + decodeURIComponent(result).replace(/\+/g, " ") + ')');

                        if (searchResult.FLAG == "-1") {
                            window.location.href = "Search.jsp?FLAG=-1&MSG=" + searchResult.MSG;
                            return;
                        }

                        var result = searchResult.result;
                        if (searchResult.recordCount == 0) {
                            $(".result").eq(0).text(result);
                        } else {
                            $(".result").eq(0).html(result);
                        }
                        if (show) {
                            $(".summary").eq(0).show();
                        }



                        var key =  searchResult.key.replace(/<+/g,"");
                        key = key.replace(/>+/g, "");
                        var v=$("#key").val().replace(/<\/?.+?>/g,"");
                        var value=v.replace(/ /g,"");
                        var resultKey = "搜索<b style='color:red;'> " + value + " </b>获得约 " + searchResult.recordCount + " 条结果";
                        $(".summary").eq(0).html(resultKey + "," + searchResult.pagese + "。");
                        p = searchResult.pageInfo;
                        cpage = searchResult.cpage;
                        maxPerPage = searchResult.maxPerPage;
                        recordCount = searchResult.recordCount;
                        startRecordNum = searchResult.startRecordNum;
                        endRecordNum = searchResult.endRecordNum;
                        pages = searchResult.pages;
                        param = searchResult.key;
                        page = searchResult.page;
                        isLastPage = searchResult.isLastPage;
                        isNoResult = searchResult.isNoResult;
                        initSchema();
                        initPage();
                        //$("#key").val(searchResult.key);
                        if (show) {
                            $("#tool").hide();
                            jQuery("#searchTool").hide();
                            jQuery("#searchInfo").show();
                            jQuery("#searchTool").find("div").each(function () {
                                if (jQuery(this).attr("id") == jQuery(".searchtype_click").eq(0).attr("contenttype")) {
                                    jQuery(this).show();
                                    jQuery(this).attr("value", "block");
                                    jQuery("#tool").show();
                                } else {
                                    jQuery(this).hide();
                                    jQuery(this).attr("value", "none");
                                }
                            });
                        }
                        $(".tools").each(function () {
                            if ($(this).attr("value") == "block") {
                                $(this).show();
                            }
                        })
                    }
                });
            }
        }

        function u2str(text){
            return $('<p></p>').html(text).text();
        }

        //HTML反转义
        function HTMLDecode(text) {
            var temp = document.createElement("div");
            temp.innerHTML = text;
            var output = temp.innerText || temp.textContent;
            temp = null;
            return output;
        }

        function initPage() {
            document.getElementById("key").focus();
            if (!isLastPage && (isNoResult == "" || isNoResult == "true"))return;
            var s = '';
            var getUrl = function (page, text) {
                return "<span onclick='changePage(" + page + ");' class='pc'>" + text + "</span>";
            }
            var getUrlN = function (page, text) {
                return "<span  onclick='changePage(" + page + ");' class='pc' style='width:65px;white-space: nowrap;'>" + text + "</span>";
            }
            var pageInfo = document.getElementById("pageInfo");
            var t = 0;

            var r = 0;
            if (page - 5 >= 1) {
                if (page + 5 <= pages) {
                    r = page - 4;
                }
                else if (page + 5 > pages) {
                    if (pages - 9 > 1)
                        r = pages - 9;
                    else
                        r = 1;
                }

            } else {
                r = 1;
            }

            var ll = '<%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>';
            /*上一页*/
            if (page > 1) {
                s += getUrlN(page - 1, ll) + "&nbsp;";
            }

            for (var i = r; i <= pages; i++) {

                s += (i == page) ? "<font color = 'red'>" + i + "</font>&nbsp;" : getUrl(i, i) + "&nbsp;";
                t++;
                if (t == 10) break;
            }
            if (pages == 1) s = '';
            var lll = '<%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>';
            /*下一页*/
            s += (recordCount == endRecordNum) ? "" : getUrlN(page + 1, lll);
            pageInfo.innerHTML = s;

        }

        function changePage(pagenum) {
            var keyw = $("#key").val() != "" ? $("#key").val() : "${key}";
            keyw = keyw.replace(new RegExp("&#034;", "gm"), "\"");
            jQuery("#key").val(keyw);
            jQuery("#page").val(pagenum);
            jQuery('#frm1').attr("action", "SearchResult.jsp");
            dosubmit(false);
        }

        function init() {

            if ("1" == '<%=Util.null2String(request.getParameter("hideTitle"))%>') {
                $('#hideTitleBar').hide();
                $('#hideTitle').val(1);
            }

            var companyname = "<%=companyNametools%>";
            var str1 = "<%=SystemEnv.getHtmlLabelName(23714,user.getLanguage())%>";

            if (companyname.length > 0) {
                window.status = str1 + companyname;
            }
            var keyw = "${key}";
            keyw = keyw.replace(new RegExp("&amp;quot;", "gm"), "\"");
            keyw = keyw.replace(new RegExp("&#034;", "gm"), "\"");
            jQuery("#key").val(keyw);

            contentTypeChg(jQuery("DIV[contentType='${contentType}']"), '${contentType}');
            searchypeChg(jQuery("DIV[searchType='${searchType}']"));
        }

        function contentTypeChg(obj, type) {
            if (obj.length == 0 && type != undefined) {
                var objLi = jQuery("#so-nav-more").find("A[contentType='" + type + "']");
                var obj = jQuery(".moreType").prev(".searchtype");
                var obj_val = obj.html();
                var obj_con = obj.attr("contentType");
                var obj_adSearch = obj.attr("adSearch");
                var obj_title = obj.attr("title");
                obj.attr("contentType", jQuery(objLi).attr("contentType"));
                obj.attr("adSearch", jQuery(objLi).attr("adSearch"));
                obj.attr("title", jQuery(objLi).attr("title"));
                obj.html(jQuery(objLi).html());
                jQuery(objLi).attr("contentType", obj_con);
                jQuery(objLi).attr("adSearch", obj_adSearch);
                jQuery(objLi).attr("title", obj_title);
                jQuery(objLi).html(obj_val);
            }
            jQuery(".searchtype").each(function () {
                jQuery(this).removeClass("searchtype_click");
            });
            obj.addClass("searchtype_click");
            jQuery("#contentType").val(obj.attr("contentType"));

            if (obj.attr("adSearch") != "") {
                jQuery('#advancedSearchTxt').html(obj.attr("adSearch"));
                jQuery('#advancedSearch').show();
                if ("<%=needRemind%>" == "1") {//后台开启提醒
                    if ("1" != storage.getItem("SearchResult-NoRemind-<%=user.getUID()%>")) {
                        jQuery('#remindContainer').show();
                    }
                }
            } else {
                jQuery('#advancedSearch').hide();
                jQuery('#advancedSearchTxt').html("");
                jQuery('#remindContainer').hide();
            }


        }

        function searchypeChg(obj) {
            jQuery(".searchFtype").each(function () {
                jQuery(this).removeClass("searchFtype_click");
            });
            obj.addClass("searchFtype_click");
            jQuery("#searchType").val(obj.attr("searchType"));
        }

        function setImgpos() {
            var d = 400 - jQuery(".nimg").width();
            var h = 300 - jQuery(".nimg").height();
            if (jQuery(".nimg").width() < 390 || jQuery(".nimg").height() < 290) {
                if (d > 0) {
                    jQuery("#imgdiv").css("padding-left", (d / 2) + "px");
                    jQuery("#imgdiv").css("padding-right", (d / 2) + "px");
                }
                if (h > 0) {
                    jQuery("#imgdiv").css("padding-top", (h / 2) + "px");
                    jQuery("#imgdiv").css("padding-bottom", (h / 2) + "px");
                }
            }

        }

        function showImgAll() {
            var linksrc = jQuery(".nimg").attr("src");
            if (linksrc && linksrc != "") {
                window.open(linksrc);
            }
        }

        function initSchema() {
            if (jQuery(".images_table") && jQuery(".images_table").length > 0) {
                //重构图片展示
                $('#barBox').css('z-index', '5');
                jQuery(".images_table td").each(function () {
                    $(this).css("pandding-left", "8px;");
                    var childrens = $(this).children();
                    if (childrens.length > 0) {
                        var imgHtml = childrens[0];
                        var titleHtml = childrens[2];
                        var contentHtml = childrens[4];
                        var resetHtml = "<div class='mcDiv' style='position: relative;'>" +
                            "<div class='contentDiv'>" +
                            "<div class='simgDiv' ></div>" +
                            "<div class='overDiv'><div class='overDivConten' style='padding: 8px;'></div></div>" +
                            "</div>" +
                            "<div class='titleDiv'></div>" +
                            "</div>";
                        $(this).children().remove();
                        $(this).append(resetHtml);
                        $(this).find(".simgDiv").append(imgHtml);
                        $(this).find(".titleDiv").append(titleHtml);
                        $(this).find(".overDivConten").append(contentHtml);
                        //修改标题
                        $(this).find('cite').html($(this).find('cite').attr('title'));
                        //摘要显示
                        $(this).find(".summary").show();
                    }
                });

                //覆盖层效果
                jQuery(".contentDiv").hover(function () {
                    //$(this).find('.overDiv').addClass("divShow");
                }, function () {
                    //$(this).find('.overDiv').removeClass("divShow");
                });
                //点击展示图片
                jQuery(".images_table .contentDiv").click(function () {
                    var obj = $($(this).find('.simgDiv')).find("a");
                    $("#imgdiv").html("<img class='nimg' alt='docimages_0' src='" + jQuery(obj).attr("likesrc") + "' style='border: 1px #E4E4E4 solid;'/>");
                    jQuery("#showImg").show(100, function () {
                        jQuery(obj).css("display", "");
                    });

                    setTimeout("setImgpos()", 200);
                });
            }
            //重构智能指令
            if (jQuery(".sTitle[schema='ROBOT']") && jQuery(".sTitle[schema='ROBOT']").length > 0) {
                jQuery(".sContent[schema='ROBOT']").remove();
                jQuery(".sfloor[schema='ROBOT']").remove();
                var divWidth = $(".result").width();
                jQuery(".sTitle[schema='ROBOT']").each(function () {
                    var obj = $(this);
                    jQuery.post("/fullsearch/robot/AjaxOperation.jsp", {
                            robotid: $(this).attr("schemaid"),
                            key: jQuery("#key").val()
                        },
                        function (datas) {
                            datas = datas.replace(/[\r\n]/g, "");
                            if (datas == "0") {//直接隐藏
                                $(obj).html("");
                            } else if (datas == "1") {//结果不处理,添加标记元素
                                $(obj).addClass("robotDiv");
                            } else {//结果转化
                                $('.result').prepend(datas + "<p></p>");
                                //$(obj).after(datas);
                                $(obj).html("");
                            }
                        });
                });
            }

            //重构人员展示
            if (jQuery(".sTitle[schema='RSC']") && jQuery(".sTitle[schema='RSC']").length > 0) {
                jQuery(".sContent[schema='RSC']").remove();
                jQuery(".sfloor[schema='RSC']").remove();
                var divWidth = $(".result").width();
                var dsp = 1;
                jQuery(".sTitle[schema='RSC']").each(function () {
                    var obj = $(this);
                    jQuery.post("/fullsearch/AjaxHrmOperation.jsp", {
                            userid: $(this).attr("schemaid"),
                            dw: divWidth,
                            dsp: dsp++
                        },
                        function (datas) {
                            var retDsp = jQuery(datas).attr("dsp");
                            //人员在智能指令之后
                            if (jQuery(".hrmDiv") && jQuery(".hrmDiv").length > 0) {
                                //$($('.hrmDiv')[jQuery(".hrmDiv").length-1]).after("<p></p>"+datas);
                                var needDsp = 0;
                                var minDsp = 0;
                                var maxDsp = 0;
                                $('.hrmDiv').each(function () {
                                    var selectDsp = parseInt($(this).attr("dsp"));
                                    if (minDsp == 0) {
                                        minDsp = selectDsp;
                                    }
                                    if (maxDsp < selectDsp) {
                                        maxDsp = selectDsp;
                                    }
                                    if (selectDsp < retDsp) {
                                        needDsp = selectDsp;
                                    }
                                })
                                if (needDsp == 0) {
                                    if (retDsp < minDsp) {
                                        $('.result').prepend("<p></p>" + datas);
                                    }
                                    if (retDsp > maxDsp) {
                                        $('.hrmDiv[dsp="' + maxDsp + '"]').after("<p></p>" + datas);
                                    }
                                } else {
                                    $('.hrmDiv[dsp="' + needDsp + '"]').after("<p></p>" + datas);
                                }

                            } else {
                                if (jQuery(".robotDiv") && jQuery(".robotDiv").length > 0) {
                                    $($('.robotDiv')[jQuery(".robotDiv").length - 1]).after("<p></p>" + datas);
                                } else {
                                    $('.result').prepend("<p></p>" + datas);
                                    //$(obj).after(datas);
                                }
                            }

                            $(obj).html("");
                            jQuery(".hrmDiv").hover(function () {
                                jQuery(this).find(".hrmDivOper").show();

                            }, function () {
                                jQuery(this).find(".hrmDivOper").hide();

                            });
                        });
                });
            }

            //重构e9文档跳转
            if (<%=!"0".equals(docShowE9)%> && jQuery(".sTitle") && jQuery(".sTitle").length > 0) {
                var url = window.top.location.href;
                if (url.indexOf("wui/index.") > 0) {
                    jQuery(".sTitle").each(function () {
                        var obj = $(this);
                        var docUrl = $(obj).find("a").eq(0);
                        var href = docUrl.attr("href");
                        if (href.indexOf("docs/docs/DocDsp.jsp") > 0) {
                            var id = href.substring(href.indexOf("id=") + 3, href.length);
                            docUrl.attr("href", "/spa/document/index.jsp?id=" + id);
                        } else if (href.indexOf("docs/docs/DocDspExt") > 0) {
                            var id = href.substring(href.indexOf("id=") + 3, href.indexOf("versionId=") - 1);
                            var versionId = href.substring(href.indexOf("versionId=") + 10, href.indexOf("imagefileId=") - 1);
                            var imagefileId = href.substring(href.indexOf("imagefileId=") + 12, href.indexOf("isFromAccessory=") - 1);
                            docUrl.attr("href", "/spa/document/index2file.jsp?id="+id+"&versionId="+versionId+"&imagefileId="+imagefileId)
                        }
                    });
                }
            }

            if (jQuery(".sTitle") && jQuery(".sTitle").length > 0) {
                for (var i = 0; i < jQuery(".sTitle").length; i++) {
                    jQuery(".sTitle").eq(i).addClass("esearch-btn");
                    var key = $("#key").val();
                    var contentType = $("#contentType").val();
                    var page = $("#page").val();
                    var searchType = $("#searchType").val();
                    var searchfrom = $("#searchfrom").val();
                    var obj = {
                        "key": key,
                        "contentType": contentType,
                        "page": page,
                        "searchType": searchType,
                        "sortField": $("#sortField").val(),
                        "userId": $("#uid").val()
                    };
                    $(".sTitle").eq(i).attr("esearch-val", JSON.stringify(obj));
                }
            }

        }

        jQuery(document).ready(function () {

            $("#sdshow").datepickernew({
                picker: "#st", showtarget: $("#st"),
                onReturn: function (r) {
                    $("#st").text(r.Format("yyyy-MM-dd"));
                    $("#st").val(r.Format("yyyy-MM-dd"));
                }
            });

            $("#edshow").datepickernew({
                picker: "#et", showtarget: $("#et"),
                onReturn: function (r) {
                    $("#et").text(r.Format("yyyy-MM-dd"));
                    $("#et").val(r.Format("yyyy-MM-dd"));
                }
            });

            init();

            //提交查询
            jQuery("#search-button").click(function () {
                jQuery("#page").val(1);
                jsonString = {};
                var date = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la');
                for (var i = 0; i < date.length; i++) {
                    date.eq(i).html(date.eq(i).attr("normalHtml"));
                    date.attr("content", "");
                }
                $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html('<%=SystemEnv.getHtmlLabelName(131374, user.getLanguage()) %>');
                clearCondition();
                dosubmit(true);
            });

            $(function () {
                document.onkeydown = function (e) {
                    var ev = document.all ? window.event : e;
                    if (ev.keyCode == 13) {
                        jQuery("#page").val(1);
                        jsonString = {};
                        clearCondition();
                        dosubmit(true);
                    }
                }
            });

            jQuery("#imgdiv").click(function () {
                if ($("#showImg").css("display") != "none") {
                    hideImgDiv();
                }
            });

            jQuery(".btnclass").mouseover(function () {
                jQuery(this).find(".btnleft").css("background-position", "bottom left");
                jQuery(this).find(".btnright").css("background-position", "bottom right");
            });

            jQuery(".btnclass").mouseout(function () {
                jQuery(this).find(".btnleft").css("background-position", "top left");
                jQuery(this).find(".btnright").css("background-position", "top right");
            });

            jQuery("#maindiv").click(function () {
                jQuery("#so-nav-more").css("display", "none");
            });
            jQuery("#so-nav-more").click(function () {
                jQuery("#so-nav-more").css("display", "none");
            });
            jQuery(".moreType").click(function () {
                //jQuery("#so-nav-more").css("display","block");
                if (jQuery("#so-nav-more").css("display") == "none") {
                    setTimeout(function () {
                        jQuery("#so-nav-more").css("display", "block");
                    }, 200)
                } else {
                    jQuery("#so-nav-more").css("display", "none");
                }
            });

            jQuery("#so-nav-more").find("A").click(function () {
                var obj = jQuery(".moreType").prev(".searchtype");
                var obj_val = obj.html();
                var obj_con = obj.attr("contentType");
                var obj_title = obj.attr("title");
                obj.attr("contentType", jQuery(this).attr("contentType"));
                obj.attr("title", jQuery(this).attr("title"));
                obj.html(jQuery(this).html());

                jQuery(this).attr("contentType", obj_con);
                jQuery(this).attr("title", obj_title);
                jQuery(this).html(obj_val);

                contentTypeChg(obj);
                jQuery("#page").val(0);
                jQuery(".summary").html("");
                jQuery(".result").html("");
                jQuery("#pageInfo").html("");
                jsonString = {};
                clearCondition();
                dosubmit(true);
            });

            jQuery(".images_table .simg").click(function () {
                $("#imgdiv").html("<img class='nimg' alt='docimages_0' src='" + jQuery(this).attr("likesrc") + "' style='border: 1px #E4E4E4 solid;'/>");

                jQuery("#showImg").show(100, function () {
                    jQuery(this).css("display", "");
                });

                setTimeout("setImgpos()", 200);
            });

            jQuery("#advancedSearch").click(function () {
                if (jQuery("#advancedSearchTxt").html() != "") {
                    location = "/system/QuickSearchOperation.jsp?fromES=1&contentType=" + jQuery("#contentType").val() + "&searchvalue=" + jQuery("#key").val();
                }
            });

            jQuery(".remind_tip_op").click(function () {
                window.top.Dialog.confirm("下次不再提醒", function () {
                    jQuery('#remindContainer').hide();
                    storage.setItem("SearchResult-NoRemind-<%=user.getUID()%>", "1");
                });

            });

            jQuery(".searchtype").click(function () {
                contentTypeChg(jQuery(this));
                jQuery("#page").val(0);
                jQuery(".summary").html("");
                jQuery(".result").html("");
                jQuery("#pageInfo").html("");
                $("#hrm").val("");
                $("#hrmspan").html("");
                var search = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la').eq(index);
                search.html(search.attr("normalhtml"));
                $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html('<%=SystemEnv.getHtmlLabelName(131374, user.getLanguage()) %>');
                jsonString = {};
                clearCondition();
                dosubmit(true);
            });

            jQuery(".searchFtype").click(function () {
                searchypeChg(jQuery(this));
                jQuery("#page").val(0);
                jQuery(".summary").html("");
                jQuery(".result").html("");
                jQuery("#pageInfo").html("");
                jsonString = {};
                var search = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la').eq(index);
                search.html(search.attr("normalhtml"));
                $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html('<%=SystemEnv.getHtmlLabelName(131374, user.getLanguage()) %>');
                clearCondition();
                dosubmit(true);
            });

            jQuery("#logoimg").click(function () {
                jQuery('#frm1').attr("action", "Search.jsp");
                jQuery('#frm1').submit();
            });

            jQuery("#maindiv").click(function () {
                var e = arguments[0] || window.event;
                var eventSource = e.srcElement || e.target;
                if (eventSource.id != "searchSetBtn") {
                    hideSetting();
                }
                hideRD();
            });

            jQuery(".btn_rd").mouseover(function () {
                jQuery("#rdimg").attr("src", "../images/bg/rds_wev8.png");
            }).mouseout(function () {
                jQuery("#rdimg").attr("src", "../images/bg/rdns_wev8.png");
            });

            Date.prototype.Format = function (fmt) {
                var o = {
                    "M+": this.getMonth() + 1, //月份
                    "d+": this.getDate(), //日
                    "h+": this.getHours(), //小时
                    "m+": this.getMinutes(), //分
                    "s+": this.getSeconds(), //秒
                    "q+": Math.floor((this.getMonth() + 3) / 3), //季度
                    "S": this.getMilliseconds() //毫秒
                };
                if (/(y+)/.test(fmt))
                    fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
                for (var k in o) {
                    if (new RegExp("(" + k + ")").test(fmt)) {
                        fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                    }
                }
                return fmt;
            }
            clearCondition();
            dosubmit(true);
            initSchema();

            //初始化协作板块
            $.ajax({
                url: "AjaxSearchResult.jsp",
                type: "POST",
                data: {
                    "action": "cowType"
                },
                success: function (result) {
                    var cowType = eval('(' + result + ')');
                    var content = "";
                    for (type in cowType) {
                        content += "<li value='"+type+"' onclick='cowtype(this)'>" + cowType[type] + "</li>";
                    }
                    $("#cowtype").html(content);
                }
            });
        });

        function hideImgDiv() {
            $("#imgdiv").html();
            $("#imgdiv").css("padding-left", "0px");
            $("#imgdiv").css("padding-top", "0px");
            $("#imgdiv").css("padding-right", "0px");
            $("#imgdiv").css("padding-bottom", "0px");
            $("#showImg").hide();
            $("#showImg").css("display", "none");
        }

        var index = 0;
        function searchTool(e) {
            index = $(e).attr("index");
            var margin = 20;
            for (var i = 0; i < index; i++) {
                margin += $(e).parent("div").find("span").eq(i).width();
                margin += 20;
            }
            if ($(e).attr('value') == "updatedate" || $(e).attr('value') == "CREATEDATE" || $(e).attr('value') == "BEGINDATE") {
                $("#dateTip").css("margin-left", margin + "px");
                $("#dateTip").toggle();
                if ($(e).attr('content') != "" && $(e).text() != "<%=SystemEnv.getHtmlLabelName(131367, user.getLanguage()) %>") {
                    var con = $(e).attr('content').split(",");
                    $('#st').val(con[0]);
                    $('#et').val(con[1]);
                    $("#st").text(con[0]);
                    $("#et").text(con[1]);
                } else {
                    $('#st').val('');
                    $('#et').val('');
                    $("#st").text("");
                    $("#et").text("");
                }
                $("#typeTip").hide();
                $("#hrmTip").hide();
                $("#tip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#seccategoryTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
                $("#cpttypeTip").hide();
            } else if ($(e).attr('value') == "TYPEID") {
                $("#typeTip").css("margin-left", margin + "px");
                $("#typeTip").toggle();
                $("#dateTip").hide();
                $("#hrmTip").hide();
                $("#tip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#seccategoryTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
                $("#cpttypeTip").hide();
            } else if ($(e).attr('value') == "WORKFLOWID") {
                $("#wftypeTip").css("margin-left", margin + "px");
                $("#wftypeTip").toggle();
                $("#dateTip").hide();
                $("#hrmTip").hide();
                $("#tip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#seccategoryTip").hide();
                $("#cptgroupTip").hide();
                $("#typeTip").hide();
                $("#cpttypeTip").hide();
            } else if ($(e).attr('value') == "CREATERNAME" || $(e).attr('value') == "manager" || $(e).attr('value') == "CREATOR"
                || $(e).attr('value') == "CREATERID" || $(e).attr('value') == "RESOURCEID" || $(e).attr('value') == "crmmanager" || $(e).attr('value') == "cowmanager") {
                if ($(e).attr('content') != "" && $(e).text() != "<%=SystemEnv.getHtmlLabelName(126493, user.getLanguage()) %>") {
                    __browserNamespace__._writeBackData("hrm", false, {
                        "id": $(e).attr('content'),
                        "name": $(e).text()
                    }, {isedit: true, hasInput: true});
                } else {
                    $("#hrm").val("");
                    $("#hrmspan").html("");
                }
                $("#hrmTip").css("margin-left", margin + "px");
                $("#hrmTip").toggle();
                $("#typeTip").hide();
                $("#dateTip").hide();
                $("#tip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#seccategoryTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
                $("#cpttypeTip").hide();
            } else if ($(e).attr('value') == "SUBCOMPANYID") {
                $("#companyTip").css("margin-left", margin + "px");
                $("#companyTip").toggle();
                $("#typeTip").hide();
                $("#dateTip").hide();
                $("#tip").hide();
                $("#hrmTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#seccategoryTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
                $("#cpttypeTip").hide();
            } else if ($(e).attr('value') == "DEPARTMENTID") {
                $("#departmentTip").css("margin-left", margin + "px");
                $("#departmentTip").toggle();
                $("#typeTip").hide();
                $("#dateTip").hide();
                $("#tip").hide();
                $("#hrmTip").hide();
                $("#companyTip").hide();
                $("#jobTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
                $("#cpttypeTip").hide();
            } else if ($(e).attr('value') == "jobtitle") {
                $("#jobTip").css("margin-left", margin + "px");
                $("#jobTip").toggle();
                $("#typeTip").hide();
                $("#dateTip").hide();
                $("#tip").hide();
                $("#hrmTip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#seccategoryTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
                $("#cpttypeTip").hide();
            } else if ($(e).attr('value').indexOf("firstDirectory") >= 0) {
                $("#seccategoryTip").css("margin-left", margin + "px");
                $("#seccategoryTip").toggle();
                $("#typeTip").hide();
                $("#dateTip").hide();
                $("#tip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#hrmTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
                $("#cpttypeTip").hide();
            } else if ($(e).attr('value') == 'capitalgroupid') {
                $("#cptgroupTip").css("margin-left", margin + "px");
                $("#cptgroupTip").toggle();
                $("#typeTip").hide();
                $("#dateTip").hide();
                $("#tip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#hrmTip").hide();
                $("#seccategoryTip").hide();
                $("#cpttypeTip").hide();
                $("#wftypeTip").hide();
            } else if ($(e).attr('value') == 'capitaltypeid') {
                $("#cpttypeTip").css("margin-left", margin + "px");
                $("#cpttypeTip").toggle();
                $("#typeTip").hide();
                $("#dateTip").hide();
                $("#tip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#hrmTip").hide();
                $("#seccategoryTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
            } else {
                $("#tip").css("margin-left", margin + "px");
                $("#tip").toggle();
                $("#typeTip").hide();
                $("#hrmTip").hide();
                $("#dateTip").hide();
                $("#companyTip").hide();
                $("#departmentTip").hide();
                $("#jobTip").hide();
                $("#seccategoryTip").hide();
                $("#cptgroupTip").hide();
                $("#wftypeTip").hide();
                $("#cpttypeTip").hide();
            }
        }

        $(document).ready(function () {
        }).click(function (e) {
            e = e || window.event;

            if ($(e.target).attr("id") != "hrmTip" && $(e.target).parents("#hrmTip").attr("id") != "hrmTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#hrmTip').hide();
                    $("#hrm").val("");
                    $("#hrmspan").html("");
                }
            }
            if ($(e.target).attr("id") != "tip" && $(e.target).parents("#tip").attr("id") != "tip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#tip').hide();
                }
            }
            if ($(e.target).attr("id") != "dateTip" && $(e.target).parents("#dateTip").attr("id") != "dateTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#dateTip').hide();
                }
            }
            if ($(e.target).attr("id") != "typeTip" && $(e.target).parents("#typeTip").attr("id") != "typeTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#typeTip').hide();
                }
            }
            if ($(e.target).attr("id") != "companyTip" && $(e.target).parents("#companyTip").attr("id") != "companyTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#companyTip').hide();
                }
            }
            if ($(e.target).attr("id") != "departmentTip" && $(e.target).parents("#departmentTip").attr("id") != "departmentTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#departmentTip').hide();
                }
            }
            if ($(e.target).attr("id") != "jobTip" && $(e.target).parents("#jobTip").attr("id") != "jobTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#jobTip').hide();
                }
            }
            if ($(e.target).attr("id") != "seccategoryTip" && $(e.target).parents("#seccategoryTip").attr("id") != "seccategoryTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#seccategoryTip').hide();
                }
            }
            if ($(e.target).attr("id") != "cptgroupTip" && $(e.target).parents("#cptgroupTip").attr("id") != "cptgroupTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#cptgroupTip').hide();
                }
            }
            if ($(e.target).attr("id") != "cpttypeTip" && $(e.target).parents("#cpttypeTip").attr("id") != "cpttypeTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#cpttypeTip').hide();
                }
            }
            if ($(e.target).attr("id") != "wftypeTip" && $(e.target).parents("#wftypeTip").attr("id") != "wftypeTip") {
                if ($(e.target).attr("class") != "search_tool_la") {
                    $('#wftypeTip').hide();
                }
            }
        });

        function tipClick() {
            $("#tip").hide();
            var value = $('#tipIn').val();
            if (value == "") {
                return;
            }
            var search = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la').eq(index);
            var html = search.html();
            //$('#tipIn').val('');
            search.html(value + "<i class='c-icon'></i>");
            search.attr("content", value);
            if (search.attr("normalHtml") == "" || typeof(search.attr("normalHtml")) == "undefined") {
                search.attr("normalHtml", html);
            }
            jsonString[search.attr("value")] = search.attr("content");
            $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html("<%=SystemEnv.getHtmlLabelName(311, user.getLanguage()) %><i class='c-icon-delete'></i>");
            jQuery("#page").val(1);
            dosubmit(false);
        }

        function browseClick(name) {
            $("#" + name + "Tip").hide();
            var value = $("#" + name).val();
            var search = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la').eq(index);
            if (((name == "cpttype" && value == "0") || (value == "")) && (search.attr("normalHtml") != "" && typeof(search.attr("normalHtml")) != "undefined")) {
                jsonString[search.attr("value")] = "";
                dosubmit(false);
                search.html(search.attr("normalHtml"));
                return;
            } else if (value == "") {
                return;
            }

            var html = search.html();
            var aspan = $("#" + name + "span").find("a");
            var content = "";
            for (var i = 0; i < aspan.length; i++) {
                content = content + aspan.eq(i).text() + ",";
            }
            search.html(content.substring(0, content.length - 1) + "<i class='c-icon'></i>");
            search.attr("content", value);
            if (search.attr("normalHtml") == "" || typeof(search.attr("normalHtml")) == "undefined") {
                search.attr("normalHtml", html);
            }
            jsonString[search.attr("value")] = search.attr("content").split(",");
            if (name == "hrm") {
                $("#" + name).val("");
                $("#" + name + "span").html("");
                _writeBackData('hrm', false, {'id': '', 'name': ''});
            }
            $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html("<%=SystemEnv.getHtmlLabelName(311, user.getLanguage()) %><i class='c-icon-delete'></i>");
            jQuery("#page").val(1);
            dosubmit(false);
        }

        function getDateStr(AddDayCount, msg) {
            var st = new Date();
            st.setDate(st.getDate() - AddDayCount);//获取AddDayCount天后的日期
            var y = st.getFullYear();
            var m = st.getMonth() + 1;//获取当前月份的日期
            var d = st.getDate();
            //判断 月
            if (m < 10) {
                m = "0" + m;
            } else {
                m = m;
            }
            //判断 日n
            if (d < 10) {
                d = "0" + d;
            } else {
                d = d;
            }
            $("#st").val(y + "-" + m + "-" + d);
            var et = new Date();
            var y = et.getFullYear();
            var m = et.getMonth() + 1;//获取当前月份的日期
            var d = et.getDate();
            //判断 月
            if (m < 10) {
                m = "0" + m;
            } else {
                m = m;
            }
            //判断 日n
            if (d < 10) {//如果天数<10
                d = "0" + d;
            } else {
                d = d;
            }
            $("#et").val(y + "-" + m + "-" + d);
            dateClick(msg);
        }

        function dateClick(msg) {
            $("#dateTip").hide();
            var stValue = $('#st').val();
            var etValue = $('#et').val();
            if (stValue == "" && etValue == "") {
                return;
            }

            var date = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la').eq(index);
            var html = date.html();

            if (msg != "" && typeof(msg) != "undefined") {
                date.html(msg + "<i class='c-icon'></i>");
            } else {
                date.html(stValue + "<%=SystemEnv.getHtmlLabelName(15322, user.getLanguage()) %>" + etValue + "<i class='c-icon'></i>");
            }

            date.attr("content", stValue + "," + etValue);
            if (date.attr("normalHtml") == "" || typeof(date.attr("normalHtml")) == "undefined") {
                date.attr("normalHtml", html);
            }
            if (msg != "<%=SystemEnv.getHtmlLabelName(131367, user.getLanguage()) %>") {
                jsonString[date.attr("value")] = date.attr("content").split(",");
            } else {
                jsonString[date.attr("value")] = ",".split(",");
            }
            $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html("<%=SystemEnv.getHtmlLabelName(311, user.getLanguage()) %><i class='c-icon-delete'></i>");
            $('#st').val('');
            $('#et').val('');
            $("#st").text("");
            $("#et").text("");
            jQuery("#page").val(1);
            dosubmit(false);
        }

        function backTool() {
            jsonString = {};
            clearCondition();
            jQuery("#page").val(0);
            var info = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html();
            $('#searchTool').slideUp(100, function () {
            });
            $('#searchInfo').slideDown(100, function () {
                $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html('<%=SystemEnv.getHtmlLabelName(131374, user.getLanguage()) %>');
                var date = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la');
                for (var i = 0; i < date.length; i++) {
                    date.eq(i).html(date.eq(i).attr("normalHtml"));
                    date.attr("content", "");
                }
            });
            if (info != "<%=SystemEnv.getHtmlLabelName(131374, user.getLanguage()) %>") {
                jQuery("#page").val(1);
                dosubmit(false);
            }
        }

        function cowtype(e) {
            $("#typeTip").hide();
            var text = $(e).text();
            if (text == "") {
                return;
            }
            var search = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la').eq(index);
            var html = search.html();
            search.html(text + "<i class='c-icon'></i>");
            search.attr("content", text);
            if (search.attr("normalHtml") == "" || typeof(search.attr("normalHtml")) == "undefined") {
                search.attr("normalHtml", html);
            }
            jsonString[search.attr("value")] = $(e).attr("value");
            $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find(".back").eq(0).html("<%=SystemEnv.getHtmlLabelName(311, user.getLanguage()) %><i class='c-icon-delete'></i>");
            jQuery("#page").val(1);
            dosubmit(false);
        }

        function clearCondition() {
            $('#tipIn').val('');
            $("#st").text("");
            $("#et").text("");
            $('#st').val('');
            $('#et').val('');
            $("#job").val("");
            $("#jobspan").html("");
            $("#hrm").val("");
            $("#hrmspan").html("");
            $("#department").val("");
            $("#departmentspan").html("");
            $("#cptgroup").val("");
            $("#cptgroupspan").html("");
            $("#wftype").val("");
            $("#wftypespan").html("");
            $("#cpttype").val("");
            $("#cpttypespan").html("");
            $("#seccategory").val("");
            $("#seccategoryspan").html("");
            $("#company").val("");
            $("#companyspan").html("");
            var date = $('#' + $('.searchtype_click').eq(0).attr('contenttype')).find('.search_tool_la');
            for (var i = 0; i < date.length; i++) {
                date.eq(i).html(date.eq(i).attr("normalHtml"));
                date.attr("content", "");
            }
        }

    </script>
</head>
<body>

<div>

    <div id="jobTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:190px;">
                    <li style="list-style:none;">
                        <brow:browser viewType="0" name='job'
                                      browserValue='' browserSpanValue=''
                                      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids="
                                      hasInput="true"
                                      isSingle='false'
                                      hasBrowser="true" isMustInput='1'
                        >
                        </brow:browser>
                        <a href="javascript:;" style="float: left;margin-top: 5px;margin-bottom: 5px;"
                           class="c-tip-timerfilter-si-submit"
                           onclick="browseClick('job')"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div id="tip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:206px;padding:7px 10px 10px;">
                    <li style="list-style:none;"><input id="tipIn" name="si" type="txt"
                                                        class="c-tip-si-input c-gap-bottom-small c-gap-right-small c-input"
                                                        autocomplete="off" value=""><a href="javascript:;"
                                                                                       style="margin-left:10px;"
                                                                                       class="c-tip-timerfilter-si-submit"
                                                                                       onclick="tipClick()"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                    </a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="hrmTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:190px;">
                    <li style="list-style:none;">
                        <brow:browser viewType="0" name="hrm" browserValue=''
                                      browserOnClick=""
                                      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
                                      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
                                      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)"
                                      browserSpanValue=''></brow:browser>
                        <a href="javascript:;" style="float: left;margin-top: 5px;margin-bottom: 5px;"
                           class="c-tip-timerfilter-si-submit"
                           onclick="browseClick('hrm')"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="departmentTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:190px;">
                    <li style="list-style:none;">
                        <brow:browser viewType="0" name="department" browserValue=''
                                      browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
                                      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
                                      completeUrl="/data.jsp?type=4"
                                      browserSpanValue=''></brow:browser>
                        <a href="javascript:;" style="float: left;margin-top: 5px;margin-bottom: 5px;"
                           class="c-tip-timerfilter-si-submit"
                           onclick="browseClick('department')"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="cptgroupTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:190px;">
                    <li style="list-style:none;">
                        <brow:browser name="cptgroup" browserValue='' browserSpanValue=''
                                      browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp"
                                      completeUrl="/data.jsp?type=25" isMustInput="1" viewType="0" browserOnClick=""
                                      hasInput="true" isSingle="true" hasBrowser="true"/>
                        <a href="javascript:;" style="float: left;margin-top: 5px;margin-bottom: 5px;"
                           class="c-tip-timerfilter-si-submit"
                           onclick="browseClick('cptgroup')"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="wftypeTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:190px;">
                    <li style="list-style:none;">
                        <brow:browser viewType="0"
                                      hasInput="true" hasBrowser="true"
                                      isMustInput="1" completeUrl="/data.jsp?type=-99991"
                                      browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutiWorkflowBrowser.jsp?selectedids="
                                      isSingle="false"
                                      name="wftype"
                                      browserValue=''
                                      browserSpanValue=''>
                        </brow:browser>
                        <a href="javascript:;" style="float: left;margin-top: 5px;margin-bottom: 5px;"
                           class="c-tip-timerfilter-si-submit"
                           onclick="browseClick('wftype')"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="cpttypeTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:190px;">
                    <li style="list-style:none;">
                        <brow:browser name="cpttype" browserValue='' browserSpanValue=''
                                      browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp"
                                      completeUrl="/data.jsp?type=25" isMustInput="1" viewType="0" browserOnClick=""
                                      hasInput="false" isSingle="true" hasBrowser="true"/>
                        <a href="javascript:;" style="float: left;margin-top: 5px;margin-bottom: 5px;"
                           class="c-tip-timerfilter-si-submit"
                           onclick="browseClick('cpttype')"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="seccategoryTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:190px;">
                    <li style="list-style:none;">
                        <brow:browser viewType="0" name="seccategory" browserValue=''
                                      browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
                                      idKey="id"
                                      hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1'
                                      completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#"
                                      browserSpanValue=''></brow:browser>
                        <a href="javascript:;" style="float: left;margin-top: 5px;margin-bottom: 5px;"
                           class="c-tip-timerfilter-si-submit"
                           onclick="browseClick('seccategory')"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="companyTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 249; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-si">
                <ul style="width:190px;">
                    <li style="list-style:none;">
                        <brow:browser viewType="0" name="company" browserValue=""
                                      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
                                      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
                                      completeUrl="/data.jsp?type=164"/>
                        <a href="javascript:;" style="float: left;margin-top: 5px;margin-bottom: 5px;"
                           class="c-tip-timerfilter-si-submit"
                           onclick="browseClick('company')"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="dateTip" class="c-tip-con dateTip"
         style="position: fixed;margin-left: 397px; z-index: 260; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter">
                <ul style="padding: 0 0 0 0;width: 150px;">
                    <li style="padding-left: 10px;padding-right: 10px"><span
                            onclick="getDateStr(0, '<%=SystemEnv.getHtmlLabelName(131367, user.getLanguage()) %>')"><%=SystemEnv.getHtmlLabelName(131367, user.getLanguage()) %></span>
                    </li>
                    <li style="padding-left: 10px;padding-right: 10px"><span
                            onclick="getDateStr(1, '<%=SystemEnv.getHtmlLabelName(131368, user.getLanguage()) %>')"><%=SystemEnv.getHtmlLabelName(131368, user.getLanguage()) %></span>
                    </li>
                    <li style="padding-left: 10px;padding-right: 10px"><span
                            onclick="getDateStr(7, '<%=SystemEnv.getHtmlLabelName(131369, user.getLanguage()) %>')"><%=SystemEnv.getHtmlLabelName(131369, user.getLanguage()) %></span>
                    </li>
                    <li style="padding-left: 10px;padding-right: 10px"><span
                            onclick="getDateStr(30, '<%=SystemEnv.getHtmlLabelName(131370, user.getLanguage()) %>')"><%=SystemEnv.getHtmlLabelName(131370, user.getLanguage()) %></span>
                    </li>
                    <li style="padding-left: 10px;padding-right: 10px"><span
                            onclick="getDateStr(365, '<%=SystemEnv.getHtmlLabelName(131371, user.getLanguage()) %>')"><%=SystemEnv.getHtmlLabelName(131371, user.getLanguage()) %></span>
                    </li>
                    <li style="padding-left: 10px;padding-right: 10px" class="c-tip-custom">
                        <hr style="margin-top: 5px; margin-bottom: 5px; ">
                        <span style="float: left;width: 100%;margin-bottom: 5px;"><%=SystemEnv.getHtmlLabelName(131372, user.getLanguage()) %></span>
                        <span class="c-tip-custom-st" style="margin-bottom: 5px;float: left;">
                            <span style="width: 30px;float: left;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;"><%=SystemEnv.getHtmlLabelName(83838, user.getLanguage()) %></span>
                            <input type="hidden" name="txtshow" id="sdshow"/>
                            <div id="st" unselectable="on" class="calHdBtn txtbtn"
                                 style="margin-left: 5px;width:90px;border:1px solid #999 !important;text-align: left;"></div>
                        </span>
                        <span class="c-tip-custom-et" style="margin-bottom: 5px;float: left;">
                            <span style="width: 30px;float: left;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;"><%=SystemEnv.getHtmlLabelName(83903, user.getLanguage()) %></span>
                            <input type="hidden" name="txtshow" id="edshow"/>
                            <div id="et" unselectable="on" class="calHdBtn txtbtn"
                                 style="margin-left: 5px;width:90px;border:1px solid #999 !important;text-align: left;"></div>
                        </span>
                        <a style="margin-bottom: 10px;float: left;" href="javascript:;" class="c-tip-custom-submit"
                           onclick="dateClick()"><%=SystemEnv.getHtmlLabelName(33703, user.getLanguage()) %>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div id="typeTip" class="c-tip-con" style="position: fixed;margin-left: 397px; z-index: 223; display: none;">
        <div>
            <div class="c-tip-menu c-tip-timerfilter c-tip-timerfilter-ft">
                <ul id="cowtype" style="overflow-x:hidden;height:300px;cursor: pointer;">

                </ul>
            </div>
        </div>
    </div>

    <form action="" method="post" name="frm1" id="frm1" onkeydown="if(event.keyCode==13){return false;}">
        <input type="hidden" id="page" name="page" value="1"/>
        <input type="hidden" id="searchfrom" name="searchfrom" value="1"/>
        <input type="hidden" id="hideTitle" name="hideTitle" value='<%=hideTitle %>'/>
        <input type="hidden" id="searchType" name="searchType" value="${searchType}"/>
        <input type="hidden" id="sourceType" name="sourceType" value="${sourceType}"/>
        <input type="hidden" id="contentType" name="contentType" value="${contentType}"/>
        <input type="hidden" id="cusContentType" name="cusContentType" value="${cusContentType}"/>
        <input type="hidden" id="noCheck" name="noCheck" value='<%=noCheckStr %>'/>
        <input type="hidden" id="uid" name="uid" value="<%=user.getUID()%>">
        <input type="hidden" id="jsonString" name="jsonString" value="">

        <div id="maindiv"
             style="z-index:1;position: relative;top: 0px;left: 0px;right: 0px;bottom: 0px;width: 100%;height: 100%;">
            <div id="barBox"
                 style="width: 100%;position: fixed;top: 0px;background-color:white;border-bottom:1px solid #CCC;">
                <div id="topbar" style="z-index:100;width: 100%;height: 40px;overflow: hidden;border-top:0px;">
                    <div style="display:inline-block;z-index:1000;margin-left: 20px;width: 600px;height: 40px;float: left;<%="1".equals(hideTitle)?"display:none":"" %>">
                        <div style="  margin-left:0px;width: 550px; height: 24px; overflow: hidden; margin-bottom: 5px; margin-top: 11px;">
                            <!--  搜索文本内容-->
                            <div class="searchFtype searchFtype_click" style="margin-left: 10px" searchType="CONTENT"
                                 _type="0"
                                 title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(608,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%>
                            </div>
                            <!--  搜索图片-->
                            <div class="searchFtype" searchType="PICTURE" _type="1"
                                 title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(74, user.getLanguage()) %>
                            </div>
                            <div class="searchtypeline " _type="2">|</div>
                            <!--  搜索所有类型-->
                            <div class="searchtype searchtype_click" contentType="ALL" _type="3" adSearch=""
                                 title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(235,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %>
                            </div>
                            <!--  搜索文档-->
                            <div class="searchtype" _type="4" contentType="DOC"
                                 adSearch='<%=useAdSearch&&"1".equals(BaseBean.getPropValue("QuickSearch","DOC.use"))?SystemEnv.getHtmlLabelName(128861,user.getLanguage()).replace("{M}",SystemEnv.getHtmlLabelName(58,user.getLanguage())):"" %>'
                                 title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(58,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(58, user.getLanguage()) %>
                            </div>
                            <%
                                List list1 = pageContext.getAttribute("allSchemas") == null ? null : (List) pageContext.getAttribute("allSchemas");
                                if (list1 != null) {
                                    int cnt = 3;
                                    int list1size = list1.size();
                                    for (Object obj : list1) {
                                        if (obj != null && ((String) obj).indexOf(":") > 0) {
                                            String str = (String) obj;
                                            String key = str.substring(0, str.indexOf(":"));
                                            String content = str.substring(str.indexOf(":") + 1);
                                            String adSearch = "";
                                            if (useAdSearch && "1".equals(BaseBean.getPropValue("QuickSearch", key + ".use"))) {
                                                adSearch = SystemEnv.getHtmlLabelName(128861, user.getLanguage()).replace("{M}", content);
                                            }
                                            if (cnt <= 8) {
                            %>
                            <div class="searchtype" _type="6" contentType="<%=key %>" adSearch="<%=adSearch %>"
                                 title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=content %>"><%=content %>
                            </div>
                            <% } else if (cnt == 9) {
                                if (list1size == 7) {%>
                            <div class="searchtype" _type="6" contentType="<%=key %>"
                                 adSearch=<%=adSearch %> title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=content %>"><%=content %>
                            </div>
                            <% } else {%>
                            <div class="moreType" _type="13" contentType=""><img
                                    style="width: 14px;margin-top:6px;margin-left: 2px;"
                                    src="/fullsearch/img/douleArrow_wev8.png"/></div>
                            <ul id="so-nav-more" style="display:none">
                                <li><a href="javascript:" contentType="<%=key %>" adSearch="<%=adSearch %>"
                                       title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=content %>"><%=content %>
                                </a></li>
                                <% }
                                } else {%>
                                <li><a href="javascript:" contentType="<%=key %>" adSearch="<%=adSearch %>"
                                       title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=content %>"><%=content %>
                                </a></li>
                                <% }
                                    cnt++;
                                }
                                }
                                    if (cnt >= 9) { %>
                            </ul>
                            <% }
                            }%>

                        </div>
                    </div>
                    <div id="searchSetBtn" class="searchSetBtn" onclick="showSetting()"
                         style="margin-top:11px; margin-right:30px;"
                         title="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage()) %>"></div>

                    <%if (HrmUserVarify.checkUserRight("searchIndex:manager", user)) {%>
                    <div id="indexmanage" name="indexmanage" class="topclassr topclassrof">
				<span onclick="window.open('IndexManager.jsp')"
                      title="<%=SystemEnv.getHtmlLabelName(20422,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(20422, user.getLanguage()) %>
			  </span>
                    </div>
                    <div id="robotmanage" name="robotmanage" class="topclassr topclassrof">
				<span onclick="window.open('robot/RobotManagerTab.jsp')"
                      title="<%=SystemEnv.getHtmlLabelName(82832,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(82832, user.getLanguage()) %>
			  </span>
                    </div>
                    <%} %>
                </div>
                <div id="searchBar" align="left" style="margin-top: -1px;margin-left: 20px;">
                    <!-- 搜索输入框 -->
                    <div style="display:inline-block;z-index:100;width: 100%;height: 63px;overflow: hidden;">
                        <div style="width: 100%;display: inline-block;">
                            <div class="input-container" style="float: left;width: 540px;height: 33px;margin: 0px;">
                                <div style="width: 460px;height: 33px;float: left;">
                                    <input name="key" id="key" type="text"
                                           style="width: 450px;height: 22px;border: 0px;margin-top: 4px;font-size: 14px;padding-left: 2px;"
                                           autocomplete="off"
                                           placeholder="<%=SystemEnv.getHtmlLabelName(32933,user.getLanguage()) %>"
                                           x-webkit-speech/>
                                </div>
                                <div id="search-button"
                                     style="width: 71px;line-height: 33px;float: right;color: #fff;font-size: 14px;text-align: center;cursor: pointer;"
                                     onmouseover="this.className='hover'" onmousedown="this.className='mousedown'"
                                     onmouseout="this.className=''"><%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>
                                </div>
                            </div>
                            <div style="line-height: 35px;margin-left: 40px;float: left;color: rgb(153, 153, 153);font-size: 12px;">
                                <div id="advancedSearch" style="display:none;cursor: pointer;float: left;">
                                    <div style="float:left" id="advancedSearchTxt"></div>
                                    <div style="float:left"><img style="width: 12px;margin-top: 12px;margin-left: 2px;"
                                                                 src="/fullsearch/img/douleArrow_wev8.png"/></div>
                                </div>
                                <div id="remindContainer" style="float: left;margin-top: 9px;display:none">
                                    <div class="arrow-left"></div>
                                    <div class="arrow-left1"></div>
                                    <div class="remind_tip">
                                        <div class="remind_tip_op">不再提醒</div>
                                        <div class="remind_tip_text">点击后进入原搜索界面,进行详细搜索</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id='searchInfo' style="margin-bottom: 5px; margin-top: 5px;width:540px">
                        <span class="summary" style="color:#999;font-size:12px;display:none;">
                        </span>
                            <%if(!"1".equals(hideTitle)){ %>
                            <div id="tool"
                                 style="color: #666;font-size: 12px;float: right;cursor: pointer;display: none;"
                                 onclick="$('#searchTool').slideDown(100,function () {});$('#searchInfo').slideUp(100,function(){});">
                                <%=SystemEnv.getHtmlLabelName(131373, user.getLanguage()) %>
                            </div>
                            <%}%>
                        </div>
                        <div id="searchTool" style="margin-bottom: 5px;margin-top: 5px;width:540px;">
                            <%
                                Map<Object, Object> toolMap = (Map) searchInfos.get("searchTools");
                                Map<Object, Object> infoMap = (Map) searchInfos.get("searchInfo");
                                if (toolMap != null) {
                                    for (Map.Entry<Object, Object> entry : toolMap.entrySet()) {
                                        int i = 0;
                                        String spanString = "";
                                        String[] toolNames = String.valueOf(entry.getValue()).split(",");
                                        for (String name : toolNames) {
                                            Object info = infoMap.get(name);
                                            if ("".equals(name)) {
                                                continue;
                                            }
                                            if (entry.getKey().equals("EMAIL")) {
                                                if (name.equals("CREATERID")) {
                                                    info = SystemEnv.getHtmlLabelName(129935, user.getLanguage());
                                                }
                                                if (name.equals("CREATEDATE")) {
                                                    info = SystemEnv.getHtmlLabelName(131410, user.getLanguage());
                                                }
                                            }
                                            if (i == 0) {
                                                spanString += "<span index=\"" + i + "\" class=\"search_tool_la\" onclick=\"searchTool(this);\" value=\"" + name + "\" content='' map='" + info + "' >" + info + "<i	class=\"c-icon\"></i></span>";

                                            } else {
                                                spanString += "<span style=\"margin-left:20px\" index=\"" + i + "\" class=\"search_tool_la\" onclick=\"searchTool(this);\"  value=\"" + name + "\" content='' map='" + info + "' >" + info + "<i class=\"c-icon\"></i></span>";
                                            }
                                            i++;
                                        }

                            %>
                            <div id="<%= entry.getKey()%>" class="tools" value="<%=StringUtils.isBlank(contentType)?(entry.getKey().equals("ALL")?"block":"none"):(entry.getKey().equals(contentType)?"block":"none")%>"
                                 style="display: none">
                                <%=spanString %>
                                <span class="back"
                                      style="color: rgb(102, 102, 102); font-size: 12px; float: right; cursor: pointer; display: block;"
                                      onclick="backTool()"><%=SystemEnv.getHtmlLabelName(131374, user.getLanguage()) %></span>
                            </div>
                            <%
                                    }
                                }

                            %>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 搜索部分开始 -->
            <div align="left" style="margin-top: 108px;margin-left: 20px;">
                <div style="width: 275px;height: 0px;"></div>
                <!-- 搜索输入框 -->
                <div align="center" style="text-align:left;color:red;display:none;" id="searchtsInfo">
                    <%=SystemEnv.getHtmlLabelName(31521, user.getLanguage()) %>
                </div>
                <div style="width:100%">

                    <div style="float:left;width:90%">
                        <div style="width:100%;margin-top: 0px;" class="result">
                        </div>
                        <div id="pageInfo" name="pageInfo"
                             style="display:inline-block;width:100%;text-align:left;"></div>
                    </div>

                    <div class="btn_rd" title="<%=SystemEnv.getHtmlLabelName(81791,user.getLanguage()) %>"
                         onclick="showRD()">
                        <img id="rdimg" style="margin-top: 7px; width: 20px;height: 20px;margin-left: 7px;"
                             src="../images/bg/rdns_wev8.png" align="middle"/>
                    </div>

                </div>
            </div>
            <!-- 搜索部分结束 -->
        </div>
    </form>
    <!-- 热点展示 -->
    <div id="rd_div"
         style="width: 0px; position: fixed; top: 266px; right: 37px; overflow: hidden; display: none;z-index:9999">
        <jsp:include page="/fullsearch/SearchHot.jsp" flush="true" />
    </div>
    <!-- 高级搜索设置 -->
    <div id="searchSetDiv" style="display:none;position:fixed;right:5px;top:35px;z-index:9999">
        <jsp:include page="/fullsearch/SearchSet.jsp" flush="true" />
    </div>
    <!-- 图片详情展示 -->
    <div id="showImg" style=" position: fixed; left:100px;top: 100px; overflow: hidden; display: none;z-index:99">
        <table cellspacing="0" cellpadding="0" border="0" style="background-color:#FFF">
            <colgroup>
                <col width="5px"/>
                <col width="25px"/>
                <col width="*"/>
                <col width="25px"/>
                <col width="5px"/>
            </colgroup>
            <tbody>
            <tr style="height: 5px;">
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/t_left_box_wev8.png')"></td>
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/t_center_box_wev8.png') repeat-x;"></td>
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/t_center_box_wev8.png') repeat-x;"></td>
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/t_center_box_wev8.png') repeat-x;"></td>
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/t_right_box_wev8.png')"></td>
            </tr>
            <tr style="height: 25px;">
                <td style="font-size: 0px;background: url('../images/bg/c_left_box_wev8.png') repeat-y;"></td>
                <td style=""></td>
                <td style="text-align:center;">
                    <div class="btn_openall btnclass" style="height: 25px;"
                         title="<%=SystemEnv.getHtmlLabelName(26923,user.getLanguage()) %>" onclick="showImgAll()">
                        <div class="btnleft" style=""><%=SystemEnv.getHtmlLabelName(26923, user.getLanguage()) %>
                        </div>
                        <div class="btnright"> &nbsp;</div>
                    </div>
                </td>
                <td style="">
                    <div class="btn_close" style="height: 25px;"
                         title="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" onclick="hideImgDiv()"></div>
                </td>
                <td style="font-size: 0px;background: url('../images/bg/c_right_box_wev8.png') repeat-y;"></td>
            </tr>
            <tr>
                <td style="font-size: 0px;background: url('../images/bg/c_left_box_wev8.png') repeat-y;"></td>
                <td style=""></td>
                <td style="background: #fff;">
                    <table id="" style="width: auto;height: auto" cellpadding="0" cellspacing="0" border="0">
                        <tbody>
                        <tr>
                            <td valign="top" style="border-left: 0px #E4E4E4 solid;">
                                <div valign="center" id="imgdiv" class="imgdiv" style="">

                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </td>
                <td style=""></td>
                <td style="font-size: 0px;background: url('../images/bg/c_right_box_wev8.png') repeat-y;"></td>
            </tr>
            <tr style="height: 25px;">
                <td style="font-size: 0px;background: url('../images/bg/c_left_box_wev8.png') repeat-y;"></td>
                <td style=""></td>
                <td style=""></td>
                <td style=""></td>
                <td style="font-size: 0px;background: url('../images/bg/c_right_box_wev8.png') repeat-y;"></td>
            </tr>
            <tr style="height: 5px;">
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/f_left_box_wev8.png')"></td>
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/f_center_box_wev8.png') repeat-x;"></td>
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/f_center_box_wev8.png') repeat-x;"></td>
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/f_center_box_wev8.png') repeat-x;"></td>
                <td style="height: 5px;font-size: 0px;background: url('../images/bg/f_right_box_wev8.png')"></td>
            </tr>
            </tbody>
        </table>
    </div>
    <%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>

</body>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
<%if (searchInfos.get("searchTools") != null) {%>
<script type="text/javascript" src="../js/track/track.js?22"></script>
<%}%>
</html>
