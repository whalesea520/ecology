/*
 * Async Treeview 0.1 - Lazy-loading extension for Treeview
 * 
 * http://bassistance.de/jquery-plugins/jquery-plugin-treeview/
 *
 * Copyright (c) 2007 J枚rn Zaefferer
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Revision: $Id$
 *
 */

;
(function($) {
    var timer;
    var menuItemHtml = "<a id='launchChatdiv' style='font-size: 12px;position:absolute;z-index:10000;width: 68px; height: 24px;background: #fff;border: 1px solid #eee;text-align: center;line-height: 24px;color: #384560;cursor:pointer;text-decoration:overline'></a>";
    var isLaunchChatFunc = true;
    /**
     * 判断是否人力资源接口是否开启
     */
    $.ajax({
        type: "POST",
        url: "/mobile/plugin/hrm/hrminterface.jsp?cmd=getResourceInfo&date=" + new Date(),
        datatype: "text",
        success: function(ret) {
            ret = $.trim(ret);
            try {
                if (ret == '{}') {
                    isLaunchChatFunc = false;
                } else {
                    ret = JSON.parse(ret);
                    if (ret.length <= 0) {
                        isLaunchChatFunc = false;
                    }
                }
            } catch (err) {
                isLaunchChatFunc = false;
            }
        },
        error: function(XmlHttpRequest) {
            isLaunchChatFunc = false;
        }
    });

    function showRightMenu(self, title, deptid, deptname, type, fncb) {
        var top = $(self).offset().top;
        var left = $(self).offset().left;
        var typeStr = 'subcompanyid1';
        if (type) {
            typeStr = 'departmentid';
        }
        $.ajax({
            type: "POST",
            url: "/mobile/plugin/hrm/hrminterface.jsp?cmd=getResourceInfo&" + typeStr + "=" + deptid + "&date=" + new Date(),
            datatype: "text",
            success: function(ret) {
                ret = $.trim(ret);
                var chatdiv = $('#launchChatdiv');
                if (chatdiv.length == 0) {
                    chatdiv = $(menuItemHtml);
                    chatdiv.text(title).appendTo('body');
                    $(document).bind('click', function(e) {
                        chatdiv.hide();
                    });
                }
                chatdiv.css({
                    "left": left + 34,
                    "top": top + 12
                }).unbind('click').bind('click', function(e) {
                    chatdiv.hide();
                    if (typeof fncb == 'function') {
                        try {
                            fncb(JSON.parse(ret).resourcelist, deptname);
                        } catch (e) {
                            console.log(e, ret);
                        }
                    }
                }).show();
            },
            error: function(XmlHttpRequest) {
                alert('获取远程接口错误' + XmlHttpRequest.responseText);
                console.info("运行出错了" + XmlHttpRequest.responseText);
            }
        });
    }

    function showMiniCard(uid, obj) {
        var top = $(obj).offset().top;
        var left = $(obj).offset().left;
        $.ajax({
            //提交数据的类型 POST GET
            type: "POST",
            //提交的网址
            url: "/hrm/resource/simpleHrmResourceTemp.jsp?userid=" + uid + "&date=" + new Date(),
            //返回数据的格式 "xml", "html", "script", "json", "jsonp", "text".
            datatype: "text",
            //成功返回之后调用的函数             
            success: function(ret) {
                ret = $.trim(ret);
                var simpleInfo = ret.split('$$$');
                var mobilephone = $.trim(simpleInfo[4]);
                var fixphone = $.trim(simpleInfo[5]);
                var name = $.trim(simpleInfo[2]);
                var job = $.trim(simpleInfo[simpleInfo.length - 4]);
                if (name == ",") {
                    name = "暂无";
                }
                if (mobilephone == ",") {
                    mobilephone = "暂无";
                }
                if (job == ",") {
                    job = "暂无";
                }
                $("#userMiniCardName").text(name).attr('title', name);
                $("#userMiniCardJob").text(job).attr('title', job);
                $("#userMiniCardMobilephone").text(mobilephone).attr('title', mobilephone);
            },
            //调用出错执行的函数
            error: function(XmlHttpRequest) {
                console.info("运行出错了" + XmlHttpRequest.responseText);
            }
        });
        $("#userMiniCard").css("left", left);
        $("#userMiniCard").css("top", top + 25);
        $("#userMiniCard").show();
    }

    function hideMiniCard() {
        $("#userMiniCard").hide();
    }

    function hrmGroupOnmouseOver(nodeid, obj) {
        //return;
        var hasEditRight = $(obj).attr("_haseditright") === 'true';
        if (nodeid == 'privateGroup' || (nodeid == 'publicGroup' && hasEditRight)) {
            var $addgroup = $("<img />");
            $addgroup.attr("id", nodeid + "groupImg");
            $addgroup.css("right", "15px");
            $addgroup.css("position", "absolute");
            $addgroup.attr("src", "/social/images/im/im_add_hrmgroup_wev8.png");
            $addgroup.attr("title", "新建");
            $addgroup.click(function() {
                HrmGroupUtil.doAdd(null, nodeid);
                event.cancelBubble = true;
                return false;
            });
            $(obj).children("span").append($addgroup);
        } else {
            if (hasEditRight) {
                var $editImg = $("<img />");
                $editImg.attr("id", nodeid + "editImg");
                $editImg.css("right", "40px");
                $editImg.css("position", "absolute");
                $editImg.attr("src", "/social/images/im/im_edit_hrmgroup_wev8.png");
                $editImg.attr("title", "编辑");
                $editImg.click(function() {
                    HrmGroupUtil.doEdit(nodeid);
                    event.cancelBubble = true;
                    return false;
                });
                var $delImg = $("<img />");
                $delImg.attr("id", nodeid + "delImg");
                $delImg.css("right", "15px");
                $delImg.css("position", "absolute");
                $delImg.attr("src", "/social/images/im/im_del_hrmgroup_wev8.png");
                $delImg.attr("title", "删除");
                $delImg.click(function() {
                    HrmGroupUtil.doDel(nodeid);
                    event.cancelBubble = true;
                    return false;
                });

                $(obj).children("span").append($editImg).append($delImg);
            }
        }
    }

    function hrmGroupOnmouseOut(nodeid) {
        //return;
        if (nodeid == 'privateGroup' || nodeid == 'publicGroup') {
            $('#' + nodeid + 'groupImg').remove();
        } else {
            $('#' + nodeid + "editImg").remove();
            $('#' + nodeid + "delImg").remove();
        }
    }

    function load(settings, root, child, container) {
        $.getJSON(settings.url, { root: root }, function(response) {
            var containerid = container.attr('id');
            var _matchIndex = containerid == 'hrmOrgTree' ? '1' : '0';
            var memArr = new Array();
            var currentArr = new Array();
            var type = 0;
            var treeID = "";

            function createNode(parent) {
                var strSpan = "<span>" + this.text + "</span>";
                $strSpan = $("<span />");
                $strSpan.html(strSpan);
                if (this.href) {
                    var strTarget = "_blank";
                    if (this.target) strTarget = this.target;
                    strSpan = "<a href='#' style='' onclick='window.open(\"" + this.href + "\"," + strTarget + ");event.cancelBubble = true; return false;'>" + this.text + "</a>";
                    $strSpan.empty();
                    $strSpan.html(strSpan);
                }

                if (this.onclick) {
                    //alert(this.onclick);
                    strSpan = "<a href='#' style='word-break:break-all' onclick=\"" + this.onclick + ";event.cancelBubble = true; return false;\">" + this.text + "</a>";
                    $strSpan.empty();
                    $strSpan.html(strSpan);
                }
                /*
                var preCurrent = $("<li/>").attr("id", this.id || "").append('<div id = "divAdd" style="width:150px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;"></div>');
                var divCurrent = preCurrent.append($strSpan);
                var current = preCurrent.appendTo(parent).css("position", "relative");*/
                var current = $("<li/>").attr("id", this.id || "").append($strSpan).appendTo(parent).css("position", "relative");
                if (this.target == "hrmGroup" && this.id != "allGroup" && (this.hasChildren || this.children && this.children.length || this.isFolder) || this.id == "publicGroup" || this.id == "privateGroup") {
                    $strSpan.hover(function() {
                            hrmGroupOnmouseOver(escape($(this).parent().attr('id')), $(this).parent());
                        },
                        function() {
                            hrmGroupOnmouseOut(escape($(this).parent().attr('id')));
                        });
                    current.attr("_targetname", this.treeID);
                }
                if (this.hasOwnProperty("hasEditRight")) {
                    current.attr("_hasEditRight", this.hasEditRight);
                }
                if (this.classtag) {
                    current.addClass(this.classtag);
                }
                if (this.targetname) {
                    current.attr("_targetname", this.targetname);
                }
                if (this.targethead) {
                    current.attr("_targethead", this.targethead);
                }
                if (this.classes) {
                    current.children("span").addClass(this.classes);
                }
                if (this.expanded) {
                    current.addClass("open");
                }
                if (this.hasChildren || this.children && this.children.length) {
                    current.children("span").addClass("folder")
                    var branch = $("<ul/>").appendTo(current);
                    if (this.hasChildren) {
                        current.addClass("hasChildren");
                        createNode.call({
                            text: "placeholder",
                            id: "placeholder",
                            children: []
                        }, branch);
                    }
                    if (this.children && this.children.length) {
                        $.each(this.children, createNode, [branch])
                    }

                    /*begin*/
                    if (GroupChatSet.isGroupChatForbit === '0' && GroupChatSet.hasGroupChatRight === '1' && isLaunchChatFunc && _matchIndex == 1 && (this.classes == 'department' || this.classes == 'subcompany')) {
                        current.children("span").bind('contextmenu', function(e) {
                            return false
                        }).bind('mouseup', function(e) {
                            if (3 == e.which) {
                                var self = $(this);
                                var id = self.parent().attr('id');
                                var type = 0;
                                if (id.indexOf('department|') != -1) {
                                    type = 1;
                                }
                                var depid = id.substring(11, id.length);
                                var depname = self.find('a').text();
                                showRightMenu(self, social_i18n('CreateGroup'), depid, depname, type, function(resourcelist, depname) {
                                    //alert(JSON.stringify(resourcelist) + "|" + depname);
                                    var succFuc = function() {
                                            var rescnt = resourcelist.count;
                                            console.log(rescnt);
                                            if (rescnt > 500) {
                                                alert(social_i18n('GroupMemberLimit'));
                                                return false;
                                            }
                                            var discussName = depname;
                                            var resourceids = resourcelist.id;
                                            resourceids = (AccountUtil || top.AccountUtil).checkAccount(resourceids);
                                            rescnt = resourceids == "" ? 0 : rescnt;
                                            var memberidList = rescnt == 0 ? [] : resourceids.split(","),
                                                mid, temp = [];
                                            for (var i = 0; i < memberidList.length; ++i) {
                                                // console.log(getIMUserId(memberidList[i]));
                                                if (memberidList[i] && memberidList[i] != M_USERID) {
                                                    temp.push(getIMUserId(memberidList[i]));
                                                }
                                            }
                                            (DiscussUtil || top.DiscussUtil)._addDiscuss(discussName, temp.join(','), temp);
                                            $('.imToptab .tabitem[_target=recent]').click();
                                        };
                                        if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
                                            WindowDepartUtil.showNewClientComfirm("信息确认",social_i18n('AddGroupAlert'),succFuc ,function() {return;});
                                        }else{
                                            showImConfirm(social_i18n('AddGroupAlert'),succFuc ,function() {return;});
                                        }
                                });
                            }
                            return false;
                        });
                    }
                    /*end*/
                } else {
                    if (this.isFolder) {
                        current.children("span").addClass("folder");
                    } else {
                        current.children("span").addClass("file");
                        var personid = current.attr("id");
                        try {
                            personid = personid.split("|")[_matchIndex];
                        } catch (err) {
                            console.error(err);
                        }
                        if (typeof userInfos != 'undefined') {
                            var userhead = '/messager/images/icon_m_wev8.jpg';
                            if (userInfos[personid]) {
                                userhead = userInfos[personid].userHead;
                            }
                            if (current.children("span").hasClass("person")) {
                                current.children("span").parent().attr('style', "max-width:156px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;")
                                current.children("span").removeClass("person");
                                current.prepend("<span style='background:url(" + userhead + ") 0 0 no-repeat;background-size:18px 18px;padding-left:24px;'></span>");
                                current.bind('mouseenter', function() {
                                    timer = setTimeout(function() {
                                        clearTimeout(timer);
                                        if (typeof ChatUtil != 'undefined') {
                                            ChatUtil.showImSignPic(current, personid);
                                        }
                                    }, 800);
                                }).bind('mouseleave', function() {
                                    clearTimeout(timer);
                                    if (typeof ChatUtil != 'undefined') {
                                        ChatUtil.hideImSignPic();
                                    }
                                });
                                //设置组织架构和常用组的在线
                                memArr.push(personid);
                                currentArr[personid] = current;
                                treeID = current.parent().parent().attr('_targetname');
                                current.parent().parent().css("position", "relative");
                                if (this.target == undefined) {
                                    //组织架构
                                    type = 1;
                                } else if (this.target == 'hrmGroup' && treeID == 'PrivateGroup') {
                                    //私人组
                                    type = 2;
                                } else if (this.target == 'hrmGroup' && treeID == 'PublicGroup') {
                                    //公共组
                                    type = 3;
                                }

                            }
                        }
                    }
                }
            }
            $.each(response, createNode, [child]);
            $(container).treeview({ add: child });
            if (memArr.length != 0 && currentArr.length != 0 && type != 0) {
                if(IS_BASE_ON_OPENFIRE && ClientSet.ifForbitOnlineStatus != '1'){
                //添加组织架构在线状态数字
                $(child.parent().find('span.department.folder')[0]).append("<div id='statusNum' isFirst='true' all='"+memArr.length+"' member='0' count='0' style='display:inline-block;'>(0/"+memArr.length+")</div>");
                OnLineStatusUtil.setOrgTreeUserStatus(currentArr, memArr, type);
                }
            }
        });
    }

    var proxied = $.fn.treeview;
    $.fn.treeview = function(settings) {
        if (!settings.url || settings.url && settings.reload) {
            return proxied.apply(this, arguments);
        }
        var container = this;
        load(settings, "source", this, container);
        var userToggle = settings.toggle;
        var extSettings = {
            collapsed: true,
            toggle: function() {
                var $this = $(this);
                if ($this.hasClass("hasChildren")) {
                    var childList = $this.removeClass("hasChildren").find("ul");
                    childList.empty();
                    load(settings, this.id, childList, container);
                }

                if (userToggle) {
                    userToggle.apply(this, arguments);
                }
            }
        };
        return proxied.call(this, $.extend({}, settings, extSettings)).bind({
            reload: function(event, url, reload, toggle) {
                var item = $(this).find("#" + reload);
                var childList = item.find("ul");
                var settings = $.extend(extSettings, { url: url, toggle: toggle });
                if (childList.length <= 0) {
                    $("<ul>").appendTo(item);
                    childList = item.find("ul")
                    item.applyClasses(settings, settings.toggle);
                } else {
                    childList.empty();
                }
                load(settings, reload, childList, container);
            }
        });
    };

})(jQuery);