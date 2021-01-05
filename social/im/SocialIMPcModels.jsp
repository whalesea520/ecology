<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.conn.BatchRecordSet"%>
<%@page import="java.util.regex.*"%>
<%@page import="java.util.*"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.social.po.SocialClientProp"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.login.Account"%>
<%@ page import="weaver.login.VerifyLogin"%>
<%@page import="weaver.social.SocialUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/social/im/SocialIMInit.jsp" %>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<%
    String bathPath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/";
    String model = Util.null2String(request.getParameter("model"));
    Pattern pattern = Pattern.compile("[0-9]*");
    String userid = user.getUID()+"";
    String signatures = SocialUtil.getSignatures(userid);
    if(signatures==null||signatures==""){
        signatures="";
    }
    boolean isOpenfire = SocialOpenfireUtil.getInstanse().isBaseOnOpenfire();
    boolean isForbitOnlineStatus = SocialClientProp.getPropValue(SocialClientProp.FORBIT_ONLINESTATUS).equals("1");
    boolean isForbitAccountSwitch = SocialClientProp.getPropValue(SocialClientProp.FORBIT_ACCOUNTSWITCH).equals("1");
    boolean isSignForbit = SocialClientProp.getPropValue(SocialClientProp.FORBIT_SIGN).equals("1");
    String style = "";
    if(isOpenfire){
        if(!isForbitOnlineStatus&&isForbitAccountSwitch&&!isSignForbit){
            style = "max-width:73px";
        }else if(!isForbitOnlineStatus&&isForbitAccountSwitch&&isSignForbit){
            style = "max-width:105px";
        } else if(!isForbitOnlineStatus&&!isForbitAccountSwitch){
            style = "";
        } else if(isForbitOnlineStatus&&!isForbitAccountSwitch){
            style = "max-width:68px";
        } else if(isForbitOnlineStatus&&isForbitAccountSwitch&&!isForbitAccountSwitch){
            style = "max-width:95px";
        } else if(isForbitOnlineStatus&&isForbitAccountSwitch&&isForbitAccountSwitch){
                style = "max-width:165px";
        }
    }else{
        if(isForbitAccountSwitch&&!isSignForbit){
            style = "max-width:95px";
        }else if(!isForbitAccountSwitch){
            style = "max-width:68px";
        }else if(isForbitAccountSwitch&&isSignForbit){
            style = "max-width:165px";
        }
    }
%>

<%if(model.equals("headtoolbar")) {
    String username = user.getLastname();
    String loginid = user.getLoginid();
    String messageUrl = SocialUtil.getUserHeadImage(userid);    
    String deptid=ResourceComInfo.getDepartmentID(userid);
    String subcompid=ResourceComInfo.getSubCompanyID(userid);
    String deptName = DepartmentComInfo.getDepartmentName(deptid);
    String subCompName = SubCompanyComInfo.getSubcompanyname(subcompid);
    String joDeptName = deptName + "/" + subCompName;
    String sex = user.getSex();
    if(joDeptName.endsWith("/")){
        joDeptName = deptName;
    }
    
    String defaultUrl = sex.equals("0") ? "/messager/images/icon_m_wev8.jpg" : "/messager/images/icon_w_wev8.jpg";
    //获取顶部按钮设置
    RecordSet recordSet = new RecordSet();
    recordSet.execute("select * from Social_Pc_UrlIcons where icotype = '0' and ifshowon = '1' order by showindex");
%>
    <div id="pc-headtoolbar" class="headtoolbar" itemCount="<%=recordSet.getCounts()%>">
        
        
        <div class="toolbar-left">
            <img src="<%=messageUrl %>" class="_userHead head80" title="<%=SystemEnv.getHtmlLabelName(131605, user.getLanguage())%>" onerror="javascript:this.src='<%=defaultUrl %>'" _loginid="<%=loginid %>"/><!-- 点击修改头像 -->
        </div>
        <div class="toolbar-right">
            <div class="_userName" title="<%=username %>">
                <div href="javascript:void(0);" title="<%=username %>" class="edPersonInfo" style="<%=style%>" ><%=username %></div>
                <%if(isOpenfire&&!isForbitOnlineStatus){%>
                <div title="<%=SystemEnv.getHtmlLabelName(131096, user.getLanguage())%>" target='online' class='edUserStatus' onClick="OnLineStatusUtil.showUserStatusPanel(this,event)"></div><!-- 在线 -->
                <% }%>
                <%if(!isForbitAccountSwitch){ %>
                <!-- 主次账号切换按钮 -->
                <jsp:include page="/social/im/SocialIMPcModels.jsp?model=accountswtichblock">
                </jsp:include>
        <%} %>
            </div>
            <div class="_userOrg" title="<%=joDeptName %>"><%=joDeptName %></div>
            <div class="nav-group">
                <nav>
                    <ul>
                    <%
                    String icouri = "", hoticouri = "", linkuri = "", numberuri = "", icotitle;
                    String defaultPicPath = "/social/images/pcmodels/htb_default_wev8.png";
                    String defaultPicHotPath = "/social/images/pcmodels/htb_default_h_wev8.png";
                    int fieldid, labelindexid, showindex, uritype,ifsysico, count = 0;
                    while(recordSet.next()){
                        fieldid = recordSet.getInt("id");
                        labelindexid = recordSet.getInt("labelindexid");
                        showindex = recordSet.getInt("showindex");
                        uritype = recordSet.getInt("uritype");
                        uritype = uritype < 0?0:uritype;
                        icouri = recordSet.getString("icouri");
                        hoticouri = recordSet.getString("hoticouri");
                        icouri = pattern.matcher(icouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+icouri:icouri;
                        hoticouri = pattern.matcher(hoticouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+hoticouri:hoticouri;
                        linkuri = recordSet.getString("linkuri");
                        numberuri = recordSet.getString("numberuri");
                        icotitle = SystemEnv.getHtmlLabelName(labelindexid, user.getLanguage());
                        ifsysico=recordSet.getInt("ifsysico");
                        
                        count++;
                    %>
                        <%if(count == 6){%><li class='arrowDown'><span class='nav-icon'><img src='/social/images/pcmodels/htb_arrowdown_wev8.png' icoUri='/social/images/pcmodels/htb_arrowdown_wev8.png' hotIcoUri='/social/images/pcmodels/htb_arrowdown_h_wev8.png' alt='...' title='<%=SystemEnv.getHtmlLabelName(131654, user.getLanguage())%>' style='max-height:10px;max-width: 10px;'/></span></li><%} %><!-- 更多 -->
                        <%if(count == 6) {%>
                            <ul>
                        <%} %>
                        <%if((ifsysico!=1)&&((uritype==1)||(uritype==2))){
                            numberuri="";
                        }%>
                        <li _linkuri="<%=linkuri %>" <%=count>5?"class='itemDrops itemHidden'":"" %> _uritype="<%=uritype %>" _numberuti="<%=numberuri %>" _identityid="<%=fieldid %>">
                            <span class="nav-icon"><img onerror="javascript:this.src='<%=defaultPicPath %>';this.setAttribute('icoUri', '<%=defaultPicPath %>');this.setAttribute('hotIcoUri', '<%=defaultPicHotPath %>');" src="<%=icouri %>" icoUri="<%=icouri %>" hotIcoUri="<%=hoticouri  %>" alt="<%=icotitle %>" title="<%=icotitle %>" style="max-height:20px;max-width: 20px;" draggable="false"/><small class="dot"></small></span><small class="nav-labe"></small>
                        </li>
                        <%if(count > 6 && count == recordSet.getCounts()) {%>
                            </ul>
                        <%} %>
                    <%} %>
                    </ul>
                </nav>
            </div>
        </div>
    </div>  
<%} else if(model.equals("footertoolbar")) { %>
    <div id="pc-footertoolbar" class="footertoolbar">
        <nav>
            <ul>
            <%
                //获取底部按钮设置
                //初始化底部按钮

                RecordSet recordSet = new RecordSet();
                recordSet.execute("select count(*) from SocialPcUserApps where userid = '"+userid+"'");
                recordSet.next();
                //System.err.print("select count(*) from SocialPcUserApps where userid = '"+userid+"'"+"   "+recordSet.getInt(1));
                if(recordSet.getInt(1) == 0){
                    //System.err.print("insert into SocialPcUserApps (icoid, userid, showindex) select id, '"+userid+"', showindex from Social_Pc_UrlIcons where ifshowon = '1' and ifsysico = '1' and icotype='1'");
                    recordSet.execute("insert into SocialPcUserApps (icoid, userid, showindex) select id, '"+userid+"', showindex from Social_Pc_UrlIcons where ifshowon = '1' and icotype='1' and showindex < 9");
                }
                String querySql = "select t1.id id, t1.showindex showindex, t2.labelindexid labelindexid, t2.labeltemp labeltemp, " +
                "t2.uritype uritype, t2.icouri icouri, t2.hoticouri hoticouri, t2.linkuri linkuri " +
                "from SocialPcUserApps t1 " +
                "inner join Social_Pc_UrlIcons t2 " +
                "on t1.icoid = t2.id " +
                "where t2.icotype = '1' and t2.ifshowon = '1' and t1.userid = '"+userid+"' and t1.showindex < 9 " +
                "order by t1.showindex ";
                recordSet.execute(querySql);
                String icouri = "", hoticouri = "", linkuri = "", icotitle;
                String defaultPicPath = "/social/images/pcmodels/ftb_default_wev8.png";
                String defaultPicHotPath = "/social/images/pcmodels/ftb_default_h_wev8.png";
                int fieldid, labelindexid, showindex, uritype;
                while(recordSet.next()){
                    labelindexid = recordSet.getInt("labelindexid");
                    showindex = recordSet.getInt("showindex");
                    uritype = recordSet.getInt("uritype");
                    uritype = uritype < 0?0:uritype;
                    icouri = recordSet.getString("icouri");
                    hoticouri = recordSet.getString("hoticouri");
                    icouri = pattern.matcher(icouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+icouri:icouri;
                    hoticouri = pattern.matcher(hoticouri).matches()?"/weaver/weaver.file.FileDownload?fileid="+hoticouri:hoticouri;
                    linkuri = recordSet.getString("linkuri");
                    icotitle = SystemEnv.getHtmlLabelName(labelindexid, user.getLanguage());
            %>
                <!-- 按钮 --><li _linkuri="<%=linkuri %>" _uritype="<%=uritype %>">
                    <span><img onerror="javascript:this.src='<%=defaultPicPath %>';this.setAttribute('icoUri', '<%=defaultPicPath %>');this.setAttribute('hotIcoUri', '<%=defaultPicHotPath %>');" src='<%=icouri %>' icoUri="<%=icouri %>" hotIcoUri="<%=hoticouri  %>" alt='<%=icotitle %>' title='<%=icotitle %>' draggable="false"/></span>
                <%} 
                    // 云盘未启用时，暂时屏蔽它
                    String isOpenDisk = weaver.file.Prop.getPropValue("network2Emessage", "openDisk");
                    if(isOpenDisk.equals("1")){
                         recordSet.execute("update Social_Pc_UrlIcons set icotype = 1 where linkuri = '/rdeploy/chatproject/doc/index.jsp'");
                    }else{                  
                        recordSet.execute("select count(*) from SocialPcUserApps where icoid in (select id from Social_Pc_UrlIcons where linkuri = '/rdeploy/chatproject/doc/index.jsp')");
                        if(recordSet.next() && recordSet.getInt(1) == 0) {
                            recordSet.execute("update Social_Pc_UrlIcons set icotype = 9 where linkuri = '/rdeploy/chatproject/doc/index.jsp'");
                        }
                    }
                %>
                </li>
            </ul>
        </nav>
        <!-- 更多 -->
        <span class="moreBtn"><img src='/social/images/pcmodels/ftb_more_wev8.png' alt='more' title='<%=SystemEnv.getHtmlLabelName(131607, user.getLanguage())%>' draggable="false"/>&nbsp;</span><!-- 应用管理 -->
        <div class="clear"></div>
    </div>
<%} else if(model.equals("appmanager")) { %>
    <jsp:include page="/social/im/SocialPcAppManager.jsp"></jsp:include>
<%} else if(model.equals("signitemblock")) { %>
    <%
    JSONObject jsonSignInfo = SocialIMService.getIMSignInfos(user);
    String signFlag = jsonSignInfo.optString("signFlag");
    boolean isNeedSign = "1".equals(jsonSignInfo.optString("isNeedSign"));
    Calendar calendar = TimeUtil.getCalendar(TimeUtil.getCurrentDateString());
    calendar.add(Calendar.DATE, 1);
    String zeroTimeMillis = calendar.getTimeInMillis()+"";
    if(!SocialClientProp.getPropValue(SocialClientProp.FORBIT_SIGN).equals("1") && isNeedSign){ %>
    <div id="pc-signitemblock" class="signitemblock" _signFlag="<%=signFlag%>" _clock="<%=zeroTimeMillis %>">
    	<span class="icoblockimg"></span>
        <span class="icoblock" title="<%=SystemEnv.getHtmlLabelName(131606, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(131606, user.getLanguage())%></span><!-- 签到 -->
    </div>
    <%} %>
<%} else if(model.equals("accountswtichblock")) { %>
<%if(weaver.general.GCONST.getMOREACCOUNTLANDING()){%>
<%
VerifyLogin  login = new VerifyLogin();
List accounts =(List)login.getAccountsById(user.getUID());
    if(accounts!=null&&accounts.size()>1){
        Iterator iter=accounts.iterator();
        int tmpCount = 0;
%>
<div id="pc-accountswtichblock" class="accountswtichblock" onclick="PcModels.doSwitchItemClick(this,event)">
    <span class="icoblock" title="<%=SystemEnv.getHtmlLabelName(131608, user.getLanguage())%>"></span> <!-- 主次帐号切换 -->
    <div class="accoutList" style="display:none;">
        <div style="height:10px;width:15px;z-index:101;top:-12px;position:absolute;background:url(/images/topnarrow.png) no-repeat;"></div>
        <div class="accoutListBox">
        <% while(iter.hasNext()){
            Account a=(Account)iter.next();
            String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
            String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
            String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());  
            String userName = ResourceComInfo.getResourcename(""+a.getId());
        %>
                            
            <div class="accountItem " userid="<%=a.getId() %>" onclick="PcModels.doSwitchAccount(this, event)">
                <div class="accountText">
                    <font color="#363636" title="<%=userName %>"><%=userName%></font>&nbsp;&nbsp;&nbsp;&nbsp;<font color="#0071ca" title="<%=jobtitlename %>"><%=jobtitlename %></font>
                    <br>
                    <font color="#868686"  title="<%=subcompanyname +"/"+departmentname %>"><%=subcompanyname +"/"+departmentname %></font>
                </div >
                                    
                <div class="accountIcon">
                    <%if(userid.equals(a.getId()+"")){ %>
                        <img style="width: 16px;height: 16px;vertical-align: middle;" src="/images/check.png">
                    <%} %>
                </div>
                <div style="clear:both;"></div>
            </div>
        
            <%if(++tmpCount < accounts.size()) {%>
                <div style="background-color:#d4d4d4;height:1px;width:188px;"></div>
            <%} %>
        <%} %>
        </div>
    </div>
</div>
<%}} %>
<%} else if(model.equals("skinitemblock")){%>
    <div id="pc-skinitemblock" onclick="PcModels.doSkinItemClick(this,event);" style="display:block;">
        <div class="colorPane">
            <div class="arrow"></div>
            <div target="default" class="default selected"></div>
            <div target="green" class="green"></div>
            <div target="yellow" class="yellow"></div>
            <div target="pink" class="pink"></div>
        </div>
        <div class="itemblock" data-title="<%=SystemEnv.getHtmlLabelName(131609, user.getLanguage())%>"></div><!-- 换肤 -->
    </div>
<%} else if(model.equals("personeditblock")){
    String messageUrl = SocialUtil.getUserHeadImage(userid);
    String username = user.getLastname();
    String loginId = user.getLoginid();
    String image=SocialUtil.getUserDefaultHeadImage(userid);
%>
    <div id="pc-personeditblock" style="display:block;">
        <div class="top">
            <img src="<%=messageUrl %>" class="_userHead head80" _loginid="<%=loginId %>" onerror="this.src='<%=image%>'"/>
            <div class="hoverBtn rgba06"  _loginid="<%=loginId %>"><%=SystemEnv.getHtmlLabelName(131605, user.getLanguage())%></div><!-- 编辑个人信息 -->
        </div>
        <div class="middle"><%=username %><img src="/social/images/pcmodels/per_edit_wev8.png" class="_userEditBtn" title="<%=SystemEnv.getHtmlLabelName(131610, user.getLanguage())%>"/></div><!-- 点击修改头像 -->
        <div class="bottom"><%if(signatures.equals("")){%><input class="_userSignatures" type="text" placeholder="<%=SystemEnv.getHtmlLabelName(131611, user.getLanguage())%>" title="<%=SystemEnv.getHtmlLabelName(131611, user.getLanguage())%>"/>
        <% }else{ %><input class="_userSignatures" placeholder="<%=SystemEnv.getHtmlLabelName(131611, user.getLanguage())%>" type="text" title="<%=SystemEnv.getHtmlLabelName(131611, user.getLanguage())%>" value="<%=signatures%>"/><%}%></div> <!-- 编辑个性签名 -->
    </div>
<%} %>
