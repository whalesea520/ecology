
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util,weaver.systeminfo.SystemEnv"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sfm" class="weaver.splitepage.transform.SptmForMail" scope="page" />
<jsp:useBean id="userSetting" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" />

<%@ include file="/homepage/element/content/Common.jsp"%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
    String indie = Util.null2String(request.getParameter("indie"), "false");
    if ("true".equals(indie)) {
%>
<%@ include file="/homepage/HpElementCss.jsp"%>
<%
    }
%>

<%
    /*
    	基本信息
    	--------------------------------------
    	hpid:表首页ID
    	subCompanyId:首页所属分部的分部ID
    	eid:元素ID
    	ebaseid:基本元素ID
    	styleid:样式ID
    	
    	条件信息
    	--------------------------------------
    	strsqlwhere 格式为 条件1^,^条件2...
    	perpage  显示页数
    	linkmode 查看方式  1:当前页 2:弹出页

    	
    	字段信息
    	--------------------------------------
    	fieldIdList
    	fieldColumnList
    	fieldIsDate
    	fieldTransMethodList
    	fieldWidthList
    	linkurlList
    	valuecolumnList
    	isLimitLengthList
     */
     
     int unreadCount = 0;
     int todoCount = 0;
%>
<div id="tabContainer_<%=eid%>" class="tab2">
    <table height="32px" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <!-- 我的邮件 -->
            <td onclick="showRemindMail(this, <%=eid%>, 0)" class='tab2selected'>
                <%=SystemEnv.getHtmlLabelName(27603, user.getLanguage())%>
                <span id="unreadCount"></span>
            </td>
            <!-- 待办邮件 -->
            <td onclick="showRemindMail(this, <%=eid%>, 1)" class='tab2unselected'>
                <%=SystemEnv.getHtmlLabelName(83090, user.getLanguage())%>
                <span id="todoCount"></span>
            </td>
            
        </tr>
    </table>
</div>

<TABLE id='_contenttable_<%=eid%>' class="Econtent" width="100%">
    <TR>
        <TD width="1px"></TD>
        <TD width="*">
            <TABLE width="99%" style='table-layout: fixed;'>
                <%
                    int mailId = 0;
                    String priority = "";
                    String senddate = "";
                    String sendfrom = "";
                    int size = fieldIdList.size();
                    int rowcount = 0;
                    String imgSymbol = "";
                    if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) {
                        imgSymbol = "<img name='esymbol' src='" + esc.getIconEsymbol(hpec.getStyleid(eid)) + "'>";
                    }

                    strsqlwhere = Util.StringReplace(strsqlwhere, "^,^", " & ");
                    ArrayList setList = Util.TokenizerString(strsqlwhere, "&");
                    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID() + "");
                    String resourceids = user.getUID() + "";
                    if (belongtoshow.equals("1") && "0".equals(user.getAccount_type())) {
                        String belongtoids = user.getBelongtoids();
                        resourceids = resourceids + "," + belongtoids;
                    }

                    String unreadSqlWhere = "";
                    if(setList.size() == 0) {
                        unreadSqlWhere = " WHERE 1 != 1 ";
                    } else if (setList.size() == 2) {
                            unreadSqlWhere = " WHERE resourceid in(" + resourceids  + ") AND status='0' and canview=1 AND folderId=0 ";
                    } else if (setList.size() == 1) {
                        if (setList.get(0).equals("1")) {
                            unreadSqlWhere = " WHERE resourceid in(" + resourceids + ") AND status='0' and canview=1 and isInternal='1' AND folderId=0 ";
                        } else {
                            unreadSqlWhere = " WHERE resourceid in(" + resourceids + ") AND status='0' and canview=1 and (isInternal!=1 or isInternal is null) AND folderId=0 ";
                        }
                    }
                    
                    SplitPageParaBean unreadSpp = new SplitPageParaBean();
                    SplitPageUtil unreadSpu = new SplitPageUtil();
                    unreadSpp.setSqlFrom("MailResource");
                    unreadSpp.setBackFields("*");
                    unreadSpp.setPrimaryKey("id");
                    // sqlserver下配置
                    Map<String, Integer> unreadOrderByMap = new HashMap<String, Integer>();
                    unreadOrderByMap.put("senddate", unreadSpp.DESC);
                    unreadSpp.setOrderByMap(unreadOrderByMap);
                    // oracle 下要这样配置!!
                    unreadSpp.setSqlOrderBy("senddate");
                    unreadSpp.setSortWay(unreadSpp.DESC);
                    unreadSpp.setSqlWhere(unreadSqlWhere);
                    unreadSpu.setSpp(unreadSpp);
                    rs = unreadSpu.getCurrentPageRs(1, perpage + 3);
                    unreadCount = unreadSpu.getRecordCount();

                    while (rs.next() && rowcount < perpage && size > 0) {
                        mailId = rs.getInt("id");
                        priority = rs.getString("priority");
                        senddate = rs.getString("senddate");
                        sendfrom = rs.getString("sendfrom");
                %>
                <TR height="18px">
                    <TD width="8"><%=imgSymbol%></TD>
                    <%
                        for (int i = 0; i < size; i++) {
                            String fieldId = (String) fieldIdList.get(i);
                            String columnName = (String) fieldColumnList.get(i);
                            String strIsDate = (String) fieldIsDate.get(i);
                            String fieldTransMethod = (String) fieldTransMethodList.get(i);
                            String fieldwidth = (String) fieldWidthList.get(i);
                            String linkurl = (String) linkurlList.get(i);
                            String valuecolumn = (String) valuecolumnList.get(i);
                            String isLimitLength = (String) isLimitLengthList.get(i);
                            String showValue = "";
                            String cloumnValue = Util.null2String(rs.getString(columnName));
                            String urlValue = Util.null2String(rs.getString(valuecolumn));
                            String url = "/email/new/MailInBox.jsp?mailid=" + mailId + "&fromable=element";
                            String titleValue = cloumnValue;

                            if ("1".equals(isLimitLength)) {
                                cloumnValue = hpu.getLimitStr(eid, fieldId, cloumnValue, user, hpid, subCompanyId);
                            }
                            if (cloumnValue.trim().isEmpty()) {
                                cloumnValue = titleValue;
                            }

                            if ("1".equals(linkmode)) {
                                showValue = "<a  class='ellipsis' href='" + url + "' target='_self'><font class='font'>" + cloumnValue + "</font></a>";
                            } else {
                                showValue = "<a class='ellipsis' href=\"javascript:openFullWindowForXtable('" + url + "');javascript:refreshUnread('" + eid + "','" + ebaseid + "', '" + mailId + "');\"><font class='font'>" + cloumnValue + "</font></a>";
                            }

                            if ("sendfrom".equals(columnName)) {
                                showValue = sfm.getMailSendFromRealName(cloumnValue, userid + "", rs.getInt("isInternal"));
                            }
                    %>
                    <%
                        if ("sendfrom".equals(columnName)) {
                    %>
                    <TD width="<%=fieldwidth%>" <%if("1".equals(isLimitLength)) out.println(" title=\""+titleValue+"\"");%>><%=showValue%></TD>
                    <%
                        }
                    %>
                    <%
                        if ("subject".equals(columnName)) {
                    %>
                    <TD width="<%=fieldwidth%>" <%if("1".equals(isLimitLength)) out.println(" title=\""+titleValue+"\"");%>><%=showValue%></TD>
                    <%
                        }
                    %>
                    <%
                        if ("priority".equals(columnName)) {
                    %>
                    <TD>
                        <font class='font'> 
                        <%
                            if (priority.equals("3")) {
                                 out.print(SystemEnv.getHtmlLabelName(2086, user.getLanguage()));
                             } else if (priority.equals("2")) {
                                 out.print(SystemEnv.getHtmlLabelName(15533, user.getLanguage()));
                             } else if (priority.equals("4")) {
                                 out.print(SystemEnv.getHtmlLabelName(19952, user.getLanguage()));
                             }
                        %>
                        </font>
                    </TD>
                    <%
                        }
                    %>
                    <%
                        if ("senddate".equals(columnName)) {
                    %>
                    <TD align="right"> <font class='font'><%=senddate%></font></TD>
                    <%
                        }
                    %>
                    <%
                        }
                    %>
                </TR>
                <%
                    rowcount++;
                        if (rowcount < perpage) {
                %>
                <TR class='sparator' style="height: 1px" height=1px>
                    <td colspan=<%=size + 1%> style='padding: 0px'></td>
                </TR>
                <%
                    }
                %>
                <%
                    }
                %>

                <%
                    if (rowcount == perpage) {
                %>
                <TR class='sparator' style="height: 1px" height=1px>
                    <td colspan=<%=size + 1%> style='padding: 0px'></td>
                </TR>
                <%
                    }
                %>
                <%
                    if (setList.size() > 1 || (setList.size() > 0 && !setList.get(0).equals("1"))) {
                %>
                <TR height="18px">
                    <TD width="8"><%=imgSymbol%></TD>
                    <td colspan="<%=size%>">
                        <font class='font'> <%=SystemEnv.getHtmlLabelName(20265, user.getLanguage())%>:
                            <%
                                 rs.executeSql("SELECT * FROM MailAccount WHERE userId in (" + resourceids + ")");
                                 while (rs.next()) {
                            %> 
                            <%=rs.getString("accountName")%>
                            <span id="span<%=rs.getInt("id")%><%=eid%>" style="font: 12px MS Shell Dlg, Verdana">
                                <img src="/images/loading2_wev8.gif" style="height: 16px; vertical-align: middle" />
                            </span> 
                            <iframe id="iframe<%=rs.getInt("id")%><%=eid%>" style='display: none' style="width:0;height:0" src="/email/UnreadOnMailServer.jsp?mailAccountId=<%=rs.getInt("id")%>"
                                onload="showUnreadNumber(<%=rs.getInt("id")%><%=eid%>)"></iframe> 
                           <%
                                }
                            %>
                            &nbsp;<a href="javascript:gotoMail()" style="color: blue; text-decoration: underline"><%=SystemEnv.getHtmlLabelName(20267, user.getLanguage())%></a>
                        </font>
                    </td>
                </TR>
                <%
                    }
                %>
            </TABLE>
        </TD>
        <TD width="1px"></TD>
    </TR>
</TABLE>

<table id='_waitdeal_<%=eid%>' class="Econtent" width="100%" style="display: none">
    <TR>
        <TD width="1px"></TD>
        <TD width="*">
            <TABLE width="99%" style='table-layout: fixed;'>
                <%
                    String todoSqlWhere = " WHERE resourceid in(" + resourceids + ") AND  canview=1 and waitdeal=1 ";
                    SplitPageParaBean todoSpp = new SplitPageParaBean();
                    SplitPageUtil todoSpu = new SplitPageUtil();
                    todoSpp.setSqlFrom("MailResource");
                    todoSpp.setBackFields("*");
                    todoSpp.setPrimaryKey("id");
                    // sqlserver下配置
                    Map<String, Integer> todoOrderByMap = new HashMap<String, Integer>();
                    todoOrderByMap.put("senddate", todoSpp.DESC);
                    todoSpp.setOrderByMap(todoOrderByMap);
                    // oracle 下要这样配置!!
                    todoSpp.setSqlOrderBy("senddate");
                    todoSpp.setSortWay(todoSpp.DESC);
                    todoSpp.setSqlWhere(todoSqlWhere);
                    todoSpu.setSpp(todoSpp);
                    rs2 = todoSpu.getCurrentPageRs(1, perpage + 3);
                    todoCount = todoSpu.getRecordCount();

                    int rowcount2 = 0;
                    while (rs2.next() && rowcount2 < perpage && size > 0) {
                        rowcount2++;
                        mailId = rs2.getInt("id");
                        priority = rs2.getString("priority");
                        senddate = rs2.getString("senddate");
                        sendfrom = rs2.getString("sendfrom");
                %>
                <TR height="18px">
                    <TD width="8"><%=imgSymbol%></TD>
                    <%
                        for (int i = 0; i < size; i++) {
                            String fieldId = (String) fieldIdList.get(i);
                            String columnName = (String) fieldColumnList.get(i);
                            String strIsDate = (String) fieldIsDate.get(i);
                            String fieldTransMethod = (String) fieldTransMethodList.get(i);
                            String fieldwidth = (String) fieldWidthList.get(i);
                            String linkurl = (String) linkurlList.get(i);
                            String valuecolumn = (String) valuecolumnList.get(i);
                            String isLimitLength = (String) isLimitLengthList.get(i);
                            String showValue = "";
                            String cloumnValue = Util.null2String(rs2.getString(columnName));
                            String urlValue = Util.null2String(rs2.getString(valuecolumn));
                            String url = "/email/new/MailInBox.jsp?mailid=" + mailId + "&fromable=element";
                            String titleValue = cloumnValue;

                            //if ("1".equals(isLimitLength)) {
                            //    cloumnValue = hpu.getLimitStr(eid, fieldId, cloumnValue, user, hpid,
                            //            subCompanyId);
                            //}
                            if (cloumnValue.trim().isEmpty()) {
                                cloumnValue = titleValue;
                            }

                             if ("1".equals(linkmode)) {
                                showValue = "<a  class='ellipsis' href='" + url + "' target='_self'><font class='font'>" + cloumnValue + "</font></a>";
                            } else {
                                showValue = "<a class='ellipsis' href=\"javascript:openFullWindowForXtable('" + url + "');javascript:refreshUnread('" + eid + "','" + ebaseid + "', '" + mailId + "');\"><font class='font'>" + cloumnValue + "</font></a>";
                            }

                            if ("sendfrom".equals(columnName)) {
                                showValue = sfm.getMailSendFromRealName(cloumnValue, userid + "", rs2
                                        .getInt("isInternal"));
                            }
                    %>
                    <%
                        if ("sendfrom".equals(columnName)) {
                    %>
                    <TD width="<%=fieldwidth%>" <%if("1".equals(isLimitLength)) out.println(" title=\""+titleValue+"\"");%>><%=showValue%></TD>
                    <%
                        }
                    %>
                    <%
                        if ("subject".equals(columnName)) {
                    %>
                    <TD width="<%=fieldwidth%>" <%if("1".equals(isLimitLength)) out.println(" title=\""+titleValue+"\"");%>><%=showValue%></TD>
                    <%
                        }
                    %>
                    <%
                        if ("priority".equals(columnName)) {
                    %>
                    <TD>
                        <font class='font'> 
                        <%
                             if (priority.equals("3")) {
                                 out.print(SystemEnv.getHtmlLabelName(2086, user.getLanguage()));
                             } else if (priority.equals("2")) {
                                 out.print(SystemEnv.getHtmlLabelName(15533, user.getLanguage()));
                             } else if (priority.equals("4")) {
                                 out.print(SystemEnv.getHtmlLabelName(19952, user.getLanguage()));
                             }
                         %>
                        </font>
                    </TD>
                    <%
                        }
                    %>
                    <%
                        if ("senddate".equals(columnName)) {
                    %>
                    <TD align="right"><font class='font'><%=senddate%></font></TD>
                    <%
                        }
                    %>
                    <%
                        }
                    %>
                </TR>
                <%
                    rowcount++;
                        if (rowcount < perpage) {
                %>
                <TR class='sparator' style="height: 1px" height=1px>
                    <td colspan=<%=size + 1%> style='padding: 0px'></td>
                </TR>
                <%
                    }
                %>
                <%
                    }
                %>

                <%
                    if (rowcount == perpage) {
                %>
                <TR class='sparator' style="height: 1px" height=1px>
                    <td colspan=<%=size + 1%> style='padding: 0px'></td>
                </TR>
                <%
                    }
                %>
            </TABLE>
        </TD>
        <TD width="1px"></TD>
    </TR>
</table>
    <script>
        /*  页面样式不支持，暂时去除
        jQuery(function(){
            var unreadCount = <%=unreadCount%>;
            if(unreadCount > 0) {
                jQuery("#unreadCount").html("(" + unreadCount + ")")
            }
            
            var todoCount = <%=todoCount%>;
            if(todoCount > 0) {
                jQuery("#todoCount").html("(" + todoCount + ")")
            }
        });
        */
    
        function showRemindMail(obj,eid,mainType){
             jQuery(obj).parent("tr:first").find(".tab2selected").removeClass("tab2selected").addClass("tab2unselected");
             jQuery(obj).removeClass("tab2unselected").addClass("tab2selected");
             
             if(mainType == 1) {
        	     jQuery("#_contenttable_"+eid).hide();
        	     jQuery("#_waitdeal_"+eid).show();
             
             }else {
             	 jQuery("#_contenttable_"+eid).show();
        	     jQuery("#_waitdeal_"+eid).hide();
             }
          }
          
    	function gotoMail(){
    		try{
    			if($(".menuItem[levelid='536']",parent.document.body).length>0){
    				$(".menuItem[levelid='536']",parent.document.body).trigger("click");
    			}else{
    				if($("#LeftMenuFrame",parent.document.body).length>0){
    					$("#tbl",$("#LeftMenuFrame",parent.document.body)[0].contentWindow.document.body).find("td[extra='myEmail']").trigger("click");
    					window.open("/email/new/MailInBox.jsp?folderid=0&receivemail=false&"+new Date().getTime());
    				}else{
    					window.open("/email/new/MailFrame.jsp?"+new Date().getTime());
    				}
    			}		
    		}catch(e){
    			window.open("/email/new/MailFrame.jsp?"+new Date().getTime());
    		}
    	}
        
        //打开发件人
        function openShowNameHref(hrmid,obj,type){	
        	openFullWindowForXtable("/email/new/MailAdd.jsp?to="+hrmid+"&isInternal="+type);		
        }
        
        // 外部窗口方式，打开未读后，刷新页面元素
        function refreshUnread(eid, ebaseid, mailId) {
            var refreshInterval = null;
            var count = 1;
            refreshInterval = setInterval(function(){
                jQuery.post("/email/new/MailOperation.jsp", {opt : 'isMailReaded', mailId : mailId}, function(data){
                    data = jQuery.trim(data);
                    if(data == 1) {
                        clearInterval(refreshInterval);
                        onRefresh(eid, ebaseid);
                    }
                    count++;
                    if(count == 3) {
                        clearInterval(refreshInterval);
                    }
                });
            }, 700);
        }
    </script>