<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.fullsearch.util.RmiConfig" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.fullsearch.SearchResultBean" %>
<%@ include file="init.jsp" %>
<%@ page isELIgnored="false" %>
<jsp:useBean id="demo" class="weaver.fullsearch.SearchBean"/>
<jsp:setProperty name="demo" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="demo" property="user" value="<%=user%>"/>
<jsp:useBean id="hotkey" class="weaver.fullsearch.bean.HotKeysBean"/>
<jsp:setProperty name="hotkey" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="hotkey" property="user" value="<%=user%>"/>
<jsp:setProperty name="hotkey" property="sysHotKeys" value="40"/>
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

        <%
        String hideTitle=Util.null2String(request.getParameter("hideTitle"));
        %>
        #so-nav-more {
            min-width: 50px;
            position: absolute;
            z-index: 0;
            margin-left: 485px;
            top: 195px;
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

        -->
    </style>
    <link href="../css/changebg_wev8.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
    <script type="text/javascript">
        var clickType = false;
        function dosubmit() {
            var key = jQuery("#key").val();
            if (key == jQuery("#key").attr("placeholder")) {
                key = "";
            }
            if (key == "") {
                jQuery("#key").focus();
            } else {
                jQuery("#key").val(checkData(key));
                jQuery("#errorInfo").css("display", "none");
                jQuery("#searchtsInfo").css("display", "");
                jQuery('#frm1').submit();
            }
        }

        function checkData(v) {
            var  entry = { "'": "&apos;", '"': '&quot;', '<': '&lt;', '>': '&gt;' };
            v = v.replace(/(['")-><&\\\/\.])/g, function ($0) { return entry[$0] || $0; });
            return v;
        }

        function init() {
            var flag = "<%=request.getParameter("FLAG")==null?"0":(String)request.getParameter("FLAG")%>";
            if (flag == "-1") {
                jQuery("#errorInfo").html("<b style='color:red;'><%=request.getParameter("MSG")==null?"":(String)request.getParameter("MSG")%></b>");
                jQuery("#errorInfo").css("display", "");
            }

            var companyname = "<%=companyNametools%>";
            var str1 = "<%=SystemEnv.getHtmlLabelName(23714,user.getLanguage())%>";

            if (companyname.length > 0) {
                window.status = str1 + companyname;
            }

            jQuery("#key").focus();

            var indx = 0;
            jQuery("#s_bg_allimgs").find('LI').each(function () {
                if (bg_index == jQuery(this).attr("data-index")) {
                    indx = bg_index;
                    return false;
                }
            });
            var bg_index = indx;
            jQuery("#bg_index").val(bg_index);

            if (bg_index != 0) {
                jQuery("#bg_flg").val("1");
                jQuery("#coltype").val(jQuery("LI[data-index=" + bg_index + "]").attr("coltype"));
            }

            var flag = jQuery("#bg_flg").val();
            var coltype = jQuery("LI[data-index=" + bg_index + "]").attr("coltype");
            if (flag == "1" && bg_index != "0") {
                jQuery("body").css("background-image", "url(../images/bg/" + bg_index + ".jpg)");
                jQuery("#s_bg_allimgs").find('LI').each(function () {
                    jQuery(this).removeClass("added");
                });
                jQuery("LI[data-index=" + bg_index + "]").addClass("added");

                if (coltype == "1") {
                    changeColorToW();
                } else {
                    changeColorToB();
                }
            } else {

                jQuery("body").css("background-image", "");
                changeColorToB();
            }
            jQuery(".btn_rd").css("margin-left", (jQuery("#bg").width() - 35) + "px")
            jQuery("#rd_div").css("margin-left", (jQuery("#bg").width() - 328) + "px")

        }

        function changeColorToW() {
            jQuery(".searchFtype").css("color", "#ffffff");
            jQuery(".searchtype").css("color", "#ffffff");
            jQuery(".searchtypeline").css("color", "#ffffff");
            jQuery(".topclassr").css("color", "#ffffff");
            //jQuery(".topclassl").css("color", "#ffffff");
            jQuery(".searchFtype_click").css("color", "#ffffff");
            if (clickType) {
                jQuery(".searchtype_click").css("color", "#ffffff");
                clickType = false;
            } else {
                jQuery(".searchtype_click").css("color", "#008EF5");
            }

            jQuery(".searchtype_click").hover(function () {
                jQuery(this).css("color", "#ffffff");
            }, function () {
                jQuery(this).css("color", "#008EF5");
            });
            //css("color", "#008EF5");
            jQuery("#topbar").css({"background": "#000000"});
            jQuery("#logfont").css("color", "#ffffff");
            //jQuery("#weather").attr("src","weather.jsp?fcolor=2");
            <% if(RmiConfig.isOpenWeather()){%>
            jQuery("#divwea").load("weather.jsp?fcolor=2");
            <%}%>
        }

        function changeColorToB() {
            jQuery(".searchFtype").css("color", "#000000");
            jQuery(".searchtype").css("color", "#000000");
            jQuery(".searchtypeline").css("color", "#000000");
            jQuery(".topclassr").css("color", "#000000");
            //jQuery(".topclassl").css("color", "#ffffff");
            jQuery(".searchFtype_click").css("color", "#ffffff");
            if (clickType) {
                jQuery(".searchtype_click").css("color", "#ffffff");
                clickType = false;
            } else {
                jQuery(".searchtype_click").css("color", "#008EF5");
            }

            jQuery(".searchtype_click").hover(function () {
                jQuery(this).css("color", "#ffffff");
            }, function () {
                jQuery(this).css("color", "#008EF5");
            });
            jQuery("#topbar").css({"background": "#ffffff"});
            jQuery("#logfont").css("color", "#000000");
            //jQuery("#weather").attr("src","weather.jsp?fcolor=1");
            <% if(RmiConfig.isOpenWeather()){%>
            jQuery("#divwea").load("weather.jsp?fcolor=1");
            <%}%>
        }

        function hideBgLayer(){
            jQuery("#s_bg_layer").css("display","none");
            jQuery("#s_bg_entrance").css("display","");
        }

        function showBgLayer(){
            jQuery("#s_bg_layer").css("display","");
            jQuery("#s_bg_entrance").css("display","none");
        }
        function changeBgImg(bgimgid) {
            jQuery.ajax({
                type: "GET",
                url: "ViewSet.jsp",
                data: "changetype=bgimg&bgimgid=" + bgimgid,
                success: function () {

                }
            });
        }

        jQuery(document).ready(function () {

            init();
            //提交查询
            jQuery("#search-button").click(function () {
                dosubmit();
            });

            document.onkeydown = function (e) {
                var ev = document.all ? window.event : e;
                if (ev.keyCode == 13) {
                    dosubmit();
                }
            }

            jQuery("#main").click(function () {
                jQuery("#so-nav-more").css("display", "none");
            });
            jQuery("#so-nav-more").click(function () {
                jQuery("#so-nav-more").css("display", "none");
            });
            jQuery(".moreType").click(function () {
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

                obj.parent().find(".searchtype").each(function () {
                    jQuery(this).removeClass("searchtype_click");
                });
                obj.addClass("searchtype_click");

                var flag = jQuery("#bg_flg").val();
                var coltype = jQuery("#coltype").val();
                if (flag == "1") {
                    if (coltype == "1") {
                        changeColorToW();
                    } else {
                        changeColorToB();
                    }
                } else {
                    changeColorToB();
                }

                jQuery("#contentType").val(obj.attr("contentType"));
            });

            jQuery("#s_bg_allimgs").find('LI').click(function () {
                var idx = jQuery(this).attr("data-index");
                var coltype = jQuery(this).attr("coltype");
                jQuery("body").css("background-image", "url(../images/bg/" + idx + ".jpg)");
                //jQuery("logo").css("background","url(images/logo_tm_wev8.png) left no-repeat");
                jQuery("#s_bg_allimgs").find('LI').each(function () {
                    jQuery(this).removeClass("added");
                });
                jQuery(this).addClass("added");
                jQuery("#bg_flg").val("1");
                jQuery("#bg_index").val(idx);
                jQuery("#coltype").val(coltype);
                if (coltype == "1") {
                    changeColorToW();
                } else {
                    changeColorToB();
                }
                changeBgImg(idx);
            });

            jQuery(".searchtype").click(function () {
                jQuery(".searchtype").each(function () {
                    jQuery(this).removeClass("searchtype_click");
                    $(this).unbind("mouseenter").unbind("mouseleave");
                });
                clickType = true;
                jQuery(this).addClass("searchtype_click");
                var flag = jQuery("#bg_flg").val();
                var coltype = jQuery("#coltype").val();
                if (flag == "1") {
                    if (coltype == "1") {
                        changeColorToW();
                    } else {
                        changeColorToB();
                    }
                } else {
                    changeColorToB();
                }

                jQuery("#contentType").val(jQuery(this).attr("contentType"));
            });

            jQuery(".searchFtype").click(function () {
                jQuery(".searchFtype").each(function () {
                    jQuery(this).removeClass("searchFtype_click");
                });
                jQuery(this).addClass("searchFtype_click");
                var flag = jQuery("#bg_flg").val();
                var coltype = jQuery("#coltype").val();
                if (flag == "1") {
                    if (coltype == "1") {
                        changeColorToW();
                    } else {
                        changeColorToB();
                    }
                } else {
                    changeColorToB();
                }
                jQuery("#searchType").val(jQuery(this).attr("searchType"));
            });

            jQuery("#s_bg_noimg").click(function () {
                jQuery("#bg_flg").val("0");
                jQuery("#bg_index").val("0");
                jQuery("body").css("background-image", "");
                //jQuery("logo").css("background","url(images/logo_wev8.png) left no-repeat");
                changeColorToB();
                changeBgImg(0);
            });

            jQuery("#s_bg_left").click(function () {
                var mgn = jQuery("#s_bg_allimgs").css("margin-left");
                var mgnnum = parseInt(mgn.substr(0, mgn.length - 2));
                mgnnum = mgnnum + 876;
                //var tolwidth = jQuery("#s_bg_allimgs").width();
                var tolwidth = 20 * 146;
                if (mgnnum <= 0) {
                    jQuery("#s_bg_allimgs").css("margin-left", mgnnum + "px");
                }
            });

            jQuery("#s_bg_right").click(function () {
                var mgn = jQuery("#s_bg_allimgs").css("margin-left");
                var mgnnum = parseInt(mgn.substr(0, mgn.length - 2));
                mgnnum = mgnnum - 876;
                //var tolwidth = jQuery("#s_bg_allimgs").width();
                var tolwidth = 20 * 146;
                if ((0 - mgnnum) < tolwidth) {
                    jQuery("#s_bg_allimgs").css("margin-left", mgnnum + "px");

                } else {
                    jQuery("#s_bg_allimgs").css("margin-left", "0px");
                }
            });

            jQuery("#s_bg_close").click(function () {
                hideBgLayer();
            });

            jQuery("#topbar").click(function () {
                hideBgLayer();
            });
            jQuery("#main").click(function () {
                hideBgLayer();
            });
            jQuery("#bg").click(function () {
                var e = arguments[0] || window.event;
                var eventSource = e.srcElement || e.target;
                if (eventSource.id != "searchSetBtn") {
                    hideSetting();
                }
                hideBgLayer();
                hideRD();

            });

            jQuery(".btn_rd").mouseover(function () {
                jQuery("#rdimg").attr("src", "../images/bg/rds_wev8.png");
            }).mouseout(function () {
                jQuery("#rdimg").attr("src", "../images/bg/rdns_wev8.png");
            });
        });

    </script>
    <script type="text/javascript" src="../js/placeholder_wev8.js"></script>
</head>

<body style="height:0px">
<form method="post" name="frm1" id="frm1" action="SearchResult.jsp" onkeydown="if(event.keyCode==13){return false;}">
    <input type="hidden" id="bg_flg" value="0"/>
    <input type="hidden" id="coltype" value="0"/>
    <input type="hidden" id="hideTitle" name="hideTitle" value='<%=hideTitle %>'/>
    <input type="hidden" id="searchType" name="searchType" value="CONTENT"/>
    <input type="hidden" id="contentType" name="contentType" value="ALL"/>
    <input type="hidden" id="page" name="page" value="1"/>
    <div id="bg"
         style="z-index:-100;position: fixed;top: 0px;left: 0px;right: 0px;bottom: 0px;width: 100%;height: 100%;">
        <div id="topbar"
             style="z-index:-10;width: 100%;height: 32px;overflow: hidden;Opacity:0.5;filter:Alpha(opacity=50);border-bottom:1px solid #CCC;border-top:0px;padding-top: 8px;">
            <div id="divwea" style="z-index:9999;position: relative;margin-top: 3px;">
            </div>
            <div id="searchSetBtn" class="searchSetBtn" onclick="showSetting()"
                 title="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage()) %>"></div>
            <%if (HrmUserVarify.checkUserRight("searchIndex:manager", user)) {%>
            <div id="indexmanage" name="indexmanage" class="topclassr">
				<span onclick="window.open('IndexManager.jsp')"
                      title="<%=SystemEnv.getHtmlLabelName(20422,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(20422, user.getLanguage()) %>
			  </span>
            </div>
            <div id="robotmanage" name="robotmanage" class="topclassr">
				<span onclick="window.open('robot/RobotManagerTab.jsp')"
                      title="<%=SystemEnv.getHtmlLabelName(82832,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(82832, user.getLanguage()) %>
			  </span>
            </div>
            <%if (RmiConfig.isSearchFile()) { %>
            <div id="indexCfg" name="indexcfg" class="topclassr">
				<span onclick="window.open('SearchInfoSet.jsp')"
                      title="<%=SystemEnv.getHtmlLabelName(19665,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(19665, user.getLanguage()) %>
			  </span>
            </div>
            <%} %>
            <%} %>
        </div>
        <!-- 搜索部分开始 -->
        <div id="main" align="center" style="width: 100%;height: 230px;margin-top: 10px;min-width: 1000px">
            <div style="width: 275px;height: 20px;"></div>
            <div id="logo"
                 style="z-index:9999;position: relative;display:inline-block;width: 200px;height: 110px;margin: 0px auto;">
                <div style="z-index:9999;position: relative;float:left;width: 65px;height: 110px;margin-top: 12px;background: url('../images/bg/wslogn_wev8.png') left no-repeat;"></div>
                <div id="logfont"
                     style="z-index:9999;position: relative;margin-top: 10px;font-weight: 500;font-size: 30px;float:left;height: 75px;padding-top: 35px;"><%=SystemEnv.getHtmlLabelName(31953, user.getLanguage()) %>
                </div>
            </div>
            <div style="width: 275px;height: 20px;"></div>
            <!-- 搜索类别 -->
            <div style='width: 560px;height: 24px;overflow: hidden;margin: 0px auto;<%="1".equals(hideTitle)?"display:none":"" %>'>
                <!--  搜索文本内容-->
                <div class="searchFtype searchFtype_click" style="margin-left: 10px" searchType="CONTENT" _type="0"
                     title="<%=SystemEnv.getHtmlLabelNames("197,608,345",user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%>
                </div>
                <!--  搜索图片-->
                <div class="searchFtype" searchType="PICTURE" _type="1"
                     title="<%=SystemEnv.getHtmlLabelNames("197,74",user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(74, user.getLanguage()) %>
                </div>
                <div class="searchtypeline " _type="2">|</div>
                <!--  搜索所有类型-->
                <div class="searchtype searchtype_click" contentType="ALL" _type="3"
                     title="<%=SystemEnv.getHtmlLabelNames("197,235,63",user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %>
                </div>
                <!--  搜索文档-->
                <div class="searchtype" _type="4" contentType="DOC"
                     title="<%=SystemEnv.getHtmlLabelNames("197,58",user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(58, user.getLanguage()) %>
                </div>
                <%
                    SearchResultBean searchResultBean = new SearchResultBean();
                    searchResultBean.setUser(user);
                    List list1 = searchResultBean.getSearchInfo();
                    if (list1 != null) {
                        int cnt = 3;
                        int list1size = list1.size();
                        for (Object obj : list1) {
                            if (obj != null && ((String) obj).indexOf(":") > 0) {
                                String str = (String) obj;
                                String key = str.substring(0, str.indexOf(":"));
                                String content = str.substring(str.indexOf(":") + 1);
                                if (cnt <= 8) {
                %>
                <div class="searchtype" _type="6" contentType="<%=key %>"
                     title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=content %>"><%=content %>
                </div>
                <% } else if (cnt == 9) {
                    if (list1size == 7) {%>
                <div class="searchtype" _type="6" contentType="<%=key %>"
                     title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=content %>"><%=content %>
                </div>
                <% } else {%>
                <div class="moreType" _type="13" contentType=""><img
                        style="width: 14px;margin-top:6px;margin-left: 2px;" src="/fullsearch/img/douleArrow_wev8.png"/>
                </div>
                <ul id="so-nav-more" style="display:none">
                    <li><a href="javascript:" contentType="<%=key %>"
                           title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %><%=content %>"><%=content %>
                    </a></li>
                    <% }
                    } else {%>
                    <li><a href="javascript:" contentType="<%=key %>"
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

            <!-- 搜索输入框 -->
            <div class="input-container"
                 style="display:inline-block;width: 540px;height: 33px;margin: 0px auto;background: #ffffff repeat-x;margin-top:4px;">
                <div style="width: 460px;height: 33px;float: left;background: #ffffff repeat-x;">
                    <input name="key" id="key" type="text"
                           style="width: 450px;height: 22px;border: 0px;margin-top: 4px;font-size: 14px;padding-left: 2px;"
                           autocomplete="off" x-webkit-speech
                           placeholder="<%=SystemEnv.getHtmlLabelName(32933,user.getLanguage()) %>"
                           submitbtn="search-button"/>
                </div>
                <div id="search-button" accesskey="S"
                     style="width: 71px;line-height: 33px;float: right;color: #fff; font-size: 14px;text-align: center;cursor: pointer;"
                     onmouseover="this.className='hover'" onmousedown="this.className='mousedown'"
                     onmouseout="this.className=''"><%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>
                </div>
            </div>

            <div align="center" style="color:red;display:none;" id="searchtsInfo">
                <%=SystemEnv.getHtmlLabelName(31521, user.getLanguage()) %>
            </div>

            <div align="center" style="color:red;display:none;" id="errorInfo">
            </div>

            <div class="btn_rd" title="<%=SystemEnv.getHtmlLabelName(81791,user.getLanguage()) %>" onclick="showRD()">
                <img id="rdimg" style="margin-top: 7px; width: 20px;height: 20px;" src="../images/bg/rdns_wev8.png"
                     align="middle"/>
            </div>

        </div>
        <!-- 搜索部分结束 -->

    </div>
</form>


<!-- 热点展示 -->
<div id="rd_div" style="width: 0px; position: fixed; top: 266px; right: 37px; overflow: hidden; display: none;">
    <jsp:include page="/fullsearch/SearchHot.jsp" flush="true"/>
</div>
<!-- 高级搜索设置 -->
<div id="searchSetDiv" style="display:none;position: fixed;;right:5px;top:35px;">
    <jsp:include page="/fullsearch/SearchSet.jsp" flush="true"/>
</div>

</body>
</html>
