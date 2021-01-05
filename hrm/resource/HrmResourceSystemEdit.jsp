            
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
            <%@ page import="weaver.general.Util,
                             weaver.file.Prop,
                             weaver.general.GCONST,
                             weaver.hrm.settings.RemindSettings,
							 weaver.hrm.common.*,
							 weaver.hrm.autotask.domain.*" %>
            <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
            <jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
			<jsp:useBean id="HrmResourceManager" class="weaver.hrm.passwordprotection.manager.HrmResourceManager" scope="page" />
            <jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
            <jsp:useBean id="ln" class="ln.LN" scope="page" />
            <jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
			<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
			<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
			<jsp:useBean id="HrmUsbAutoDateManager" class="weaver.hrm.autotask.manager.HrmUsbAutoDateManager" scope="page" />
						<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
						<%@ taglib uri="/browserTag" prefix="brow"%>
             <html>
            <%
            String isrsaopen = Util.null2String(Prop.getPropValue("openRSA","isrsaopen"));//是否开启RSA
            //xiaofeng usb setting
            RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
            String openPasswordLock = settings.getOpenPasswordLock();
        	String passwordComplexity = settings.getPasswordComplexity();
            String usb_enable=settings.getNeedusb();
			usb_enable = "1";
            String firmcode=settings.getFirmcode();
            String usercode=settings.getUsercode();
			String usbType=settings.getUsbType();
            String needed="0";
            String userUsbType="";
            //String needdynapass="0";
			int needdynapass= 0;//是否使用动态密码
			String passwordstate= "1";//动态密码状态，默认为停止
	     	int dynapass_enable=settings.getNeeddynapass();
	    	int minpasslen=settings.getMinPasslen();  
			//added by wcd 2014-12-25 [用户前台设置可在三种辅助校验方式中任选其一] start
			int needdynapassdefault = settings.getNeeddynapassdefault();
			String needusbHt = settings.getNeedusbHt();
			String needusbdefaultHt = settings.getNeedusbdefaultHt();
			String needusbDt = settings.getNeedusbDt();
			String needusbdefaultDt = settings.getNeedusbdefaultDt();
			//added by wcd 2014-12-25 end
	
	     String id = request.getParameter("id");
	     int hrmid = user.getUID();
	     boolean ishe = (hrmid == Util.getIntValue(id));
	     String isView = request.getParameter("isView");
	     String usingid = request.getParameter("usingid");
	     boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
	     String account="";
	     String isADAccount = "";
	     int accounttype = 0;
	     String usbstate="";
	     String loginid = "";
	     String password = "qwertyuiop";
	     int systemlanguage = 7;
	     String email = "";
	     String seclevel = "";
			String serial = "";
			String tokenKey="";
            //xiaofeng
            String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
            boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
                        //老的分权管理
            /*
            int detachable=0;
            if(session.getAttribute("detachable")!=null){
                detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
            }else{
                rs.executeSql("select detachable from SystemSet");
                if(rs.next()){
                    detachable=rs.getInt("detachable");
                    session.setAttribute("detachable",String.valueOf(detachable));
                }
            }
            */
			//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
			int hrmdetachable=0;
			if(session.getAttribute("hrmdetachable")!=null){
			    hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
			}else{
				boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
				if(isUseHrmManageDetach){
				   hrmdetachable=1;
				   session.setAttribute("detachable","1");
				   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
				}else{
				   hrmdetachable=0;
				   session.setAttribute("detachable","0");
				   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
				}
			}              
            int hrmoperatelevel=-1;
			boolean isright = false;
	    if(hrmdetachable==1){
                String deptid=ResourceComInfo.getDepartmentID(id);
                String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
                hrmoperatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Util.getIntValue(subcompanyid));
            }else{
				String departmentidtmp = ResourceComInfo.getDepartmentID(id);
				if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All",user,departmentidtmp)){
					hrmoperatelevel=2;
				}
            }
            if(!(iss || hrmoperatelevel>0)){
            	response.sendRedirect("/notice/noright.jsp") ;
            }else{
            	isright = true;
            }
			//Start 手机接口功能 by alan
            String isMgmsUser = "";
            rs.executeSql("SELECT userid FROM workflow_mgmsusers WHERE userid="+id);
            if(rs.next()){
            	isMgmsUser = "checked";
            }
            boolean EnableMobile = Util.null2String(Prop.getPropValue("mgms" , "mgms.on")).toUpperCase().equals("Y");
            //End 手机接口功能

			String mainDactylogramImgSrc="/images/loginmode/5_wev8.gif";
			String assistantDactylogramImgSrc="/images/loginmode/5_wev8.gif";
			String mainDactylogram = "";
			String assistantDactylogram = "";
			String subcomId = "";
			int passwordlock = -1;
            rs.executeSql("select subcompanyid1,account,accounttype,loginid,systemlanguage,email,seclevel,needusb,needdynapass,passwordstate,passwordlock,serial,dactylogram,assistantdactylogram,tokenKey,userUsbType,usbstate,isADAccount from HrmResource where id = "+id );


            if(rs.next()){
				subcomId = Util.null2String(rs.getString("subcompanyid1")); 
            	isADAccount  = Util.null2String(rs.getString("isADAccount"));
                account = Util.null2String(rs.getString("account"));
                accounttype = Util.getIntValue(rs.getString("accounttype"),0);
                loginid = Util.null2String(rs.getString("loginid"));
                systemlanguage = Util.getIntValue(rs.getString("systemlanguage"),7);
                email = Util.null2String(rs.getString("email"));
                seclevel = Util.null2String(rs.getString("seclevel"));
                needed=String.valueOf(rs.getInt("needusb"));
                userUsbType=Util.null2String(rs.getString("userUsbType"));
                usbstate=Util.null2String(rs.getString("usbstate"));
                if(userUsbType.equals("")){
                	//userUsbType=usbType;     //将原来启用状态的用户赋值为默认usb类型	
                }
				serial = Util.null2String(rs.getString("serial"));
				tokenKey = Util.null2String(rs.getString("tokenKey"));
                //needdynapass=String.valueOf(rs.getInt("needdynapass"));
				needdynapass=rs.getInt("needdynapass");
				passwordstate=String.valueOf(rs.getInt("passwordstate"));
				passwordlock = rs.getInt("passwordlock");
				//System.out.println("-=-=-=-=-=:"+passwordstate);
				if(!passwordstate.equals("0")&&!passwordstate.equals("1")&&!passwordstate.equals("2")) passwordstate ="1";//修改passwordstate的值可实现更改默认状态,0，启动。1，停止。2，网段策略。
				if(!usbstate.equals("0")&&!usbstate.equals("1")&&!usbstate.equals("2")) usbstate ="0";//修改usbstate的值可实现更改默认状态,0，启动。1，停止。2，网段策略。
				
	mainDactylogram = Util.null2String(rs.getString("dactylogram"));
	assistantDactylogram = Util.null2String(rs.getString("assistantdactylogram"));
	mainDactylogramImgSrc = (mainDactylogram.equals(""))?"/images/loginmode/5_wev8.gif":"/images/loginmode/4_wev8.gif";
	assistantDactylogramImgSrc = (assistantDactylogram.equals(""))?"/images/loginmode/5_wev8.gif":"/images/loginmode/4_wev8.gif";
            }
			boolean alAjax = false;
            //xiaofeng
            if(loginid.equals("")){
            	password="";//默认值
				if(!("1".equals(Tools.vString(ln.getConcurrentFlag())))) alAjax = true;
			}

            boolean canSave = false;
            int ckHrmnum = ln.CkHrmnum();
            if(ckHrmnum < 0){//只有License检查人数小于规定人数，才能修改。防止客户直接修改数据库数据
            	canSave = true;
            }else if(ckHrmnum==0 && !loginid.trim().equals("")){
            	canSave = true;//如果正好license人数到头，而且当前的登录名是空，那么就不让修改登录名
            }
			//TD8617
	    String needSynPassword = "";
	    rs.executeSql("select * from ldapset");
	    if(rs.next()) {
	       needSynPassword = rs.getString("needSynPassword");
	    }		
		
            %>

            <head>

                 <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
                <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
				<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
				<%
				if("1".equals(isrsaopen)){
				 %>
				<script  type="text/javascript" src="/js/rsa/jsencrypt.js"></script>
				<script  type="text/javascript" src="/js/rsa/rsa.js"></script>
				<%} %>

            </head>
             <%
            String imagefilename = "/images/hdMaintenance_wev8.gif";
            String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(468,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
            String needfav ="1";
            String needhelp ="";

            %>
            <body>

            <script src="/js/ComboBox_wev8.js"></script>


            <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
            <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
            <%
            if(canSave&&isright){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:edit(this),_self} " ;
            RCMenuHeight += RCMenuHeightStep ;
            }
            RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewSystemInfo(),_self} " ;
            RCMenuHeight += RCMenuHeightStep ;
            %>
            <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%
            if(canSave&&isright){
		 %>
			<input type=button class="e8_btn_top" onclick="edit(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%
			}
			 %>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
            <FORM name=resourcesysteminfo id=resourcesysteminfo action="HrmResourceOperation.jsp" method=post >
            <input class=inputstyle type=hidden name=operation>
			<input class=inputstyle type=hidden name=isEdit value="1">
            <input class=inputstyle type=hidden name=id value="<%=id%>">
            <input class=inputstyle type=hidden name=isView value="<%=isView%>">
			<input class=inputstyle type=hidden name=username value="<%=account%>" />
			<input class=inputstyle type=hidden name=isfromtab value="<%=isfromtab%>">
			<input class=inputstyle type=hidden name=needdynapass value="<%=needdynapass%>">
			<input class=inputstyle type=hidden name=passwordstate value="<%=passwordstate%>">
			<%if("1".equals(usbType)){%>
			<input class=inputstyle type=hidden name=serial />
			<%}%>

            <input class=inputstyle type=hidden name=old_needed value="<%=needed%>" >
            <%
            String errmsg = Util.null2String(request.getParameter("errmsg"));
            if(errmsg.equals("1")){
            %>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(16128,user.getLanguage())%>
            
            <%if(!"".equals(usingid)) {
            	rs.executeSql("select lastname from HrmResource where id="+usingid);
				if(rs.next()) {
					out.print(SystemEnv.getHtmlLabelName(24356,user.getLanguage()));
					out.print("("+usingid+":"+rs.getString("lastname")+")");
				}
            } %>
            </font>
            </div>
            <%} else if(errmsg.equals("2")) {%>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(23845,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23084,user.getLanguage())%>
            </font>
            </DIV>
           	 <%} else if(errmsg.equals("-21")) {%>
	            <DIV>
	            <font color=red size=2>
	            	<%=SystemEnv.getHtmlLabelName(382092 ,user.getLanguage())%>
	            </font>
	            </DIV>
            <%} else if(errmsg.equals("3")) {%>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(81826,user.getLanguage())%>
            </font>
            </DIV>
           
            <%} else if(errmsg.equals("4")) {%>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(81827,user.getLanguage())%>
            </font>
            </DIV>
            
            <%} else if(errmsg.equals("5")) {%>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(81795,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685,user.getLanguage())%>
            </font>
            </DIV>
            <%} else if(errmsg.equals("6")) {%>
             <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(81796,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685,user.getLanguage())%>
            </font>
            </DIV>
            <%} else if(errmsg.equals("7")) {%>
            <DIV>
            <font color=red size=2>
            <%
				rs.executeSql("select passwordpolicy from ldapset");
				if(rs.next()) {
					out.println(rs.getString("passwordpolicy"));
				}
			%>
            </font>
            </DIV>
            <%} else if(errmsg.equals("8")) {%>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(81848,user.getLanguage())%>
            </font>
            </DIV>
            <%} else if(errmsg.equals("9")) {
            %>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(23845,user.getLanguage())%>
            <%=SystemEnv.getHtmlLabelName(81868,user.getLanguage())%>
            </font>
            </DIV>
            <%} else if(errmsg.equals("184")) {
                %>
                <DIV>
                <font color=red size=2>
                <%=SystemEnv.getHtmlLabelName(131434,user.getLanguage())%>
                </font>
                </DIV>
            <%} else if(errmsg.equals("bbserror")){ %>
			<DIV>
            <font color=red size=2><%=SystemEnv.getHtmlLabelName(82624,user.getLanguage())%></font><!-- OA信息保存成功，同步至BBS信息失败 -->
            </div>
			<%}%>
            <%
            if(!canSave){
            %>
            <DIV>
            <font color=red size=2>
            <%=SystemEnv.getHtmlLabelName(16129,user.getLanguage())%>
            </div>
            <%}%>
            
            <wea:layout type="2col">
            	<%
            	String attr = "{'groupDisplay':'none'}";
            	if(isfromtab)attr="";
            	%>
            	<wea:group context='<%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%>' attributes="<%=attr %>">
            		<wea:item><%=SystemEnv.getHtmlLabelName(16126,user.getLanguage())%></wea:item>
            		<wea:item attributes="{'id':'tloginid'}">
            			<%if(ishe){%>         
            				<%=loginid%>
                    <input class=inputstyle type=hidden name=loginid value="<%=loginid%>">
				            <%
				            }else{
				              if(!"1".equals(isADAccount)){%>
				                        <input style="width:300px" class=inputstyle type=text name=loginid value="<%=loginid%>" <%if(!canSave){%> disabled <%}%> >
				                        <input type=hidden name=account value="<%=account%>" <%if(!canSave){%> disabled <%}%> >
				            <%
				               }else{
				               
				            %>
				     <input style="width:300px" class=inputstyle type=text name=loginid value="<%=loginid%>" <%if(!canSave){%> disabled <%}%> >
                  	<!--<input type=hidden id=loginid name=loginid value="<%=account%>" <%if(!canSave){%> disabled <%}%> >
                    
                     <brow:browser viewType="0" name="loginidBro" browserValue='<%=account%>' 
			            browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/ldap/ldapAccountList.jsp?selectedids="
			            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
			            width="125px" afterDelCallback='deleteElement' isAutoComplete="true"
			            _callback='clickBrowser' completeUrl="/data.jsp?type=adaccount"
			            browserSpanValue='<%=account%>'>
			        </brow:browser>-->
			        
                   <!-- <script>
                     account=new ComboBox("account",tloginid)  ;
                     account.className="inputstyle";
                     
                      document.resourcesysteminfo.accounttxt.value= "<%=account%>";
                    </script> -->
			            <%}
			            }
			            %>
            		</wea:item>
            		<%if(mode!=null && mode.equals("ldap")) {%>
            		<wea:item><%=SystemEnv.getHtmlLabelName(81932,user.getLanguage())%></wea:item>
            		<wea:item><input class="inputstyle" type="checkbox" tzCheckbox='true' id="isADAccount" name="isADAccount" onclick="changePasswordVal();" value="1" <%if("1".equals(isADAccount))out.println("checked"); %>></wea:item>
            		<%} %>
            		<%if("1".equals(openPasswordLock)){%>
		            <wea:item><%=SystemEnv.getHtmlLabelName(24706,user.getLanguage())%></wea:item>
		            <wea:item>
		               <input type="checkbox" name="passwordlock" value="<%=passwordlock %>" <%if(1==passwordlock){%>checked<%}%> onclick="setPasswordLock(this);">        
		            </wea:item>
			          <%}%>
			         
                <wea:item attributes="{'samePair':'passwordInfo'}"><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
                <wea:item attributes="{'samePair':'passwordInfo'}">
                  <input style="width:300px" class=inputstyle type=password id="oapassword" name=password value="<%=password%>" <%if(!canSave){%> disabled <%}%> >
                </wea:item>
                <wea:item attributes="{'samePair':'passwordInfo'}"><%=SystemEnv.getHtmlLabelName(16127,user.getLanguage())%></wea:item>
                <wea:item attributes="{'samePair':'passwordInfo'}">
                  <input style="width:300px" class=inputstyle type=password name=passwordconfirm value="<%=password%>" <%if(!canSave){%> disabled <%}%> >
                </wea:item>
               
                <%if(dynapass_enable==1 || "1".equals(needusbHt) || "1".equals(needusbDt) || "1".equals(settings.getNeedca())){%>
                <wea:item><%=SystemEnv.getHtmlLabelName(81629,user.getLanguage())%></wea:item>
                <wea:item>
                <div style="display: none"> 
                	<input type="checkbox" id="needusb" name="needusb" value="<%=usb_enable%>" <%if(needed!=null&&needed.equals("1")){%>checked<%}%>  <%if(!canSave){%> disabled <%}%>>
                </div>
					<select onchange="changeshow(this);change(this);onUserUsbTypeChange();" name="userUsbType" id="userUsbType" <%if(!canSave){%> disabled <%}%>>
						<option value="-1">&nbsp;</option>
						<%if(dynapass_enable == 1){%>
						<option value="4" <%if("4".equals(userUsbType) || needdynapass == 1){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(32511,user.getLanguage())%></option>
						<%}if("1".equals(needusbHt)){%>
						<option value="2" <%if("2".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21589,user.getLanguage())%></option>
						<%}if("1".equals(needusbDt)){%>
						<option value="3" <%if("3".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(32896,user.getLanguage())%></option>
						<%}if("1".equals(settings.getNeedca())){%>
						<option value="21" <%if("21".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(381991,user.getLanguage())%></option>
						<%}%>
					</select>
					&nbsp;
					<span id="spanusbstate">
					<select id="usbstate" name="usbstate" onchange="javascript:chooseUsbs(this);">
						<option value="0" <%=(usbstate!=null&&usbstate.equals("0"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
						<option value="1" <%=(usbstate!=null&&usbstate.equals("1"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
						<option value="2" <%=(usbstate!=null&&usbstate.equals("2"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
					</select>
					</span>
                </wea:item>
	            <%
					String defaultDate = TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),1);
					Map automap = new HashMap();
					automap.put("userId", id);
					HrmUsbAutoDate autoDate = HrmUsbAutoDateManager.get(automap);
					String needauto = "1";
					String enableDate = "";
					String enableUsbType = userUsbType;
					if(autoDate != null){
						needauto = String.valueOf(autoDate.getNeedAuto());
						enableDate = autoDate.getEnableDate();
						enableUsbType = String.valueOf(autoDate.getEnableUsbType());
					}
					
	                String t_style = "none";
	                if(usbstate!=null&&usbstate.equals("1"))t_style="";
	                String arr = "{'samePair':'serialtr5','display':'"+t_style+"'}";
				%>
				<wea:item attributes='<%=arr %>' ><%=SystemEnv.getHtmlLabelNames("81855,18095",user.getLanguage())%></wea:item>
                <wea:item attributes='<%=arr %>' >
					<span id="enableDateInfo">
					<input type="checkbox" id="needauto" name="needauto" value="1" <%if(needauto.equals("1")){%>checked<%}%> <%if(!canSave){%> disabled <%}%> onclick="changeTokenKeySpan(this)">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<%=SystemEnv.getHtmlLabelNames("18095,97",user.getLanguage())%>：
					<%if(canSave){%>
					<input class=inputstyle type=text size=4 name="days" maxlength="4" style="width: 40px;"
										onKeyPress="ItemCount_KeyPress()"
										onBlur="checknumber('days');checkcount('days');dealDate(this.value)" onChange="ckNumber('days');" value="" />
					<%=SystemEnv.getHtmlLabelNames("1925,18110",user.getLanguage())%>&nbsp;&nbsp;
					<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(enableDateSpan,enableDate);"></BUTTON>
					<%} %>
					<SPAN id=enableDateSpan><%if(enableDate.equals("")){%><%=defaultDate%><%}else{%><%=enableDate %><%}%></SPAN>
					<input class=inputstyle type="hidden" name="enableDate" value="<%if(enableDate.equals("")){%><%=defaultDate%><%}else{%><%=enableDate %><%}%>" onPropertyChange="setDefaultDate(this.value,'<%=defaultDate %>');">
					<span style="margin-left:20px"><%=SystemEnv.getHtmlLabelNames("18095,599",user.getLanguage())%>
					<select name="enableUsbType" id="enableUsbType">
						<option value="0" <%if("0".equals(enableUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
						<!--<option value="1" <%if("1".equals(enableUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>-->
						<option value="2" <%if("2".equals(enableUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
					 </select></span>
					</span>
                </wea:item>
				<%
					t_style = "none";
					if(needed!=null&&needed.equals("1")&&userUsbType.equals("2"))t_style = "";
					arr = "{'samePair':'serialtr1','display':'"+t_style+"'}";
				%>
                <wea:item attributes='<%=arr %>' ><%=SystemEnv.getHtmlLabelName(21597,user.getLanguage())%></wea:item>
                <wea:item attributes='<%=arr %>' >
					<input class="inputstyle" type="text" maxlength="32" size="32" style="width:300px" id="serial" name="serial" temptitle="<%=SystemEnv.getHtmlLabelName(21597,user.getLanguage())%>" value="<%=(userUsbType.equals("2") ? serial : "") %>" onblur="changeSerial()"  onchange="changeSerial()" <%if(!canSave){%> disabled <%}%>>
					<span id="serialspan"><%if("".equals((userUsbType.equals("2") ? serial : "")) && canSave){%><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%}%></span>
					<button type="button" class=e8_btn_top  id="changeUsb" onclick="updateKey()" style=";margin-left:10px;" <%if(!canSave){%> disabled <%}%>>
					   <%=("2".equals(userUsbType)&&serial.equals(""))?SystemEnv.getHtmlLabelName(28032,user.getLanguage()):SystemEnv.getHtmlLabelName(83738,user.getLanguage())%>
					</button>
                </wea:item>
				<%
				  t_style = "none";
				  if(needed!=null&&needed.equals("1")&&userUsbType.equals("3")&&"1".equals(needusbDt))t_style = "";
				  arr = "{'samePair':'serialtr3','display':'"+t_style+"'}";
				%>
                <wea:item attributes='<%=arr %>'><%=SystemEnv.getHtmlLabelName(32897,user.getLanguage())%></wea:item>
                <wea:item attributes='<%=arr %>'>
					<input class="inputstyle" type="text" id="tokenKey" name="tokenKey" style="width:300px" temptitle="<%=SystemEnv.getHtmlLabelName(32897,user.getLanguage())%>" value="<%=tokenKey%>" onblur="checkTokenKey();changeTokenKey()" onchange="changeTokenKey()" maxlength="10">
					<span id="tokenKeyspan"><%if("".equals(tokenKey)&&canSave){%><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%}%></span>
					<button type="button" class=e8_btn_top  id="changeKey" onclick="updateKey()" style=";margin-left:10px;" <%if(!canSave){%> disabled <%}%>>
					   <%=("3".equals(userUsbType)&&tokenKey.equals(""))?SystemEnv.getHtmlLabelName(28032,user.getLanguage()):SystemEnv.getHtmlLabelName(83738,user.getLanguage())%>
					</button>
                </wea:item>
                <%  
                		t_style = "none";
                		if("1".equals(settings.getNeedca())&&userUsbType.equals("21"))t_style = "";
                		arr = "{'samePair':'serialtr21','display':'"+t_style+"'}";
                %>
                <wea:item attributes='<%=arr %>' ><%=SystemEnv.getHtmlLabelName( 84 ,user.getLanguage())%></wea:item>
                <wea:item attributes='<%=arr %>' >
					<input class="inputstyle" type="text" maxlength="32" size="32" style="width:180px" id="serial21" 
					   name="serial21" temptitle="<%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%>" 
					   value="<%=("21".equals(userUsbType)? serial : "")%>" <%if(!canSave){%> disabled <%}%>>
                	<button  type="button" class="e8_btn_top" onclick="getCaUnique(this)" style=";margin-left:10px;" >
                		<%=SystemEnv.getHtmlLabelName(382090,user.getLanguage()) %>
                	</button>
                </wea:item>
                
                <%}%>
            		<%if(isMultilanguageOK){%>
                <wea:item><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></wea:item>
                <wea:item>
			            <%=LanguageComInfo.getLanguagename(""+systemlanguage)%>  
				</wea:item>
            		<%}%>
                <wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
                <wea:item>
                	<input style="width:300px" class=inputstyle type=text name=email value="<%=email%>" <%if(!canSave){%> disabled <%}%>>
                </wea:item>
                <wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
                <wea:item>
		            <%if(ishe){%>         
		            <%=seclevel%>
		            	<input class=inputstyle type=hidden name=seclevel value="<%=seclevel%>" >
		            <%}else{%>
		            	<input style="width:300px" class=inputStyle maxlength=3  size=5 name=seclevel value="<%=seclevel%>" onblur="checkSeclevel(this)"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("seclevel");' <%if(!canSave){%> disabled <%}%>>
		            <%}%>
                </wea:item>
                <%if(GCONST.getONDACTYLOGRAM()){%>
                <wea:item>
	                <wea:layout type="2col">
	                	<wea:group context='<%=SystemEnv.getHtmlLabelNames("22143,22144",user.getLanguage())%>'>
											<wea:item><%=SystemEnv.getHtmlLabelName(22145,user.getLanguage())%></wea:item>
											<wea:item><%=SystemEnv.getHtmlLabelName(22146,user.getLanguage())%></wea:item>
											<wea:item><a style="cursor:hand" onclick="FingerEnroll('maindactylogram')"><img width=80 height=100 src='<%=mainDactylogramImgSrc%>' align="absmiddle" border="0"></a></wea:item>
											<wea:item><a style="cursor:hand" onclick="FingerEnroll('assistantdactylogram')"><img width=80 height=100 src='<%=assistantDactylogramImgSrc%>' align="absmiddle" border="0"></a></wea:item>
											<wea:item><%if(!mainDactylogram.equals("")){%><a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="delDactylogram('maindactylogram')"><font color="red"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22145,user.getLanguage())%></font></a><%}%></wea:item>
											<wea:item><%if(!assistantDactylogram.equals("")){%><a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="delDactylogram('assistantdactylogram')"><font color="red"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22146,user.getLanguage())%></font></a><%}%></wea:item>
											<wea:item attributes="{'display':'none'}">
												<input type="hidden" id="maindactylogram" name="maindactylogram" value="">
												<input type="hidden" id="assistantdactylogram" name="assistantdactylogram" value="">
												<input type="hidden" id="topage" name="topage" value="HrmResourceSystemEdit.jsp">
											</wea:item>
										</wea:group>
									</wea:layout>
								</wea:item>
                <%}%>
                <%if(EnableMobile){%>
						  	<wea:item><%=SystemEnv.getHtmlLabelName(23996,user.getLanguage())%></wea:item>
						  	<wea:item><input type="checkbox" name="isMgmsUser" value='<%=id%>' <%=isMgmsUser%>></wea:item>
							  <%}else{ %>
							  <wea:item attributes="{'samePair':'MgmsUser','display':'none'}">&nbsp;</wea:item>
							  <wea:item attributes="{'samePair':'MgmsUser','display':'none'}">
									<input type=hidden name="isMgmsUser" value="<%if(isMgmsUser.equals("checked"))out.println(id);%>">
								</wea:item>
							  <%}%>
            	</wea:group>
            </wea:layout>
            </form>
            <%if(GCONST.getONDACTYLOGRAM()){%>
            <object classid="clsid:1E6F2249-59F1-456B-B7E2-DD9F5AE75140" width="1" height="1" id="dtm" codebase="WellcomJZT998.ocx"></object>
            <%}%>
            <script language=vbs>
            sub onShowLanguage()
            	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp")
            	if (Not IsEmpty(id)) then
            	if id(0)<> 0 then
            	systemlanguagespan.innerHtml = id(1)
            	resourcesysteminfo.systemlanguage.value=id(0)
            	else
            	systemlanguagespan.innerHtml = ""
            	resourcesysteminfo.systemlanguage.value=""
            	end if
            	end if
            end sub


            </script>
            <script language=javascript>
            $(document).ready(function() {
                
            	if("ldap" == "<%=mode%>" && "1" == "<%=isADAccount%>" && "<%=needSynPassword%>" != "y") {
            		hideEle("passwordInfo");
            	}
            	if("ldap" == "<%=mode%>" && "1" == "<%=isADAccount%>" && "<%=needSynPassword%>" == "y") {
            		$("#oapassword").val("");
					document.resourcesysteminfo.passwordconfirm.value = "";
            	}
            	onUserUsbTypeChange();
            });
			var isCaInit = false ;
            //ca -gecy 
            function getCaUnique(btn){
				if(!!(window['ActiveXObject'] || "ActiveXObject" in window)){
					getCaUniqueForIe(btn);
					return ;
				}
            	
                
                if(!isCaInit){
	            	jQuery.getScript('/wui/common/js/cacheck.js?t='+new Date().getTime(),function(){
	    				try{
	    					isCaInit = true ;
	    					doGetCaUnique() ;
	    				}catch(e){
	    					alert(e);
	    				}
	    			});
                }else{
                	doGetCaUnique() ;
                }
            }

            function doGetCaUnique(pin){
           		SafeEngineCtlObj.plugin = window.top ;
				SafeEngineCtlObj.checkBorser() ;
				isCaInit = true ;
				SafeEngineCtlObj.initUniqueKey(function(ukdata){
            		$('#serial21').val(ukdata) ;
    			},function(ret){
    				SafeEngineCtlObj.dialog(ret);
    			},function(htmlmsg){
    				$('#serial21').parent().append('<span style="margin-left:20px;color:red;">'+htmlmsg+'</span>');
	    		},pin);
            }

            function getCaUniqueForIe(btn){
               
	           	if(window.top.Dialog){
					dialog = new window.top.Dialog();
				} else {
					dialog = new Dialog();
				}
	           	dialog.currentWindow = window;
	
	           	dialog.Title = '<%=SystemEnv.getHtmlLabelName(382090,user.getLanguage())%>' ;
	           	dialog.Modal = true;
				dialog.maxiumnable = true;
	           	dialog.Width = 600;
				dialog.Height = 200;
				dialog.callbackfun = checkCaValue ;
				dialog.URL = "/hrm/resource/hrmGetCaPin.jsp";
				
				dialog.show();
            }

            function checkCaValue(pin){
            	 if(!isCaInit){
 	            	jQuery.getScript('/wui/common/js/cacheck.js?t='+new Date().getTime(),function(){
 	    				try{
 	    					isCaInit = true ;
 	    					doGetCaUnique(pin) ;
 	    				}catch(e){
 	    					alert(e);
 	    				}
 	    			});
                 }else{
                 	doGetCaUnique(pin) ;
                 }
            }
            
            function onUserUsbTypeChange(){
              jQuery("#spanusbstate").hide();
            	if(jQuery("#userUsbType").val()!=-1){
            		jQuery("#spanusbstate").show();
            	}
				chooseUsbs($GetEle("usbstate"));
            }
			var common = new MFCommon();
			
			if("ldap" == "<%=mode%>" && "1" == "<%=isADAccount%>") {
				var isBindAD = true;
			} else {
				var isBindAD = false//是否绑定AD账户
			}
			
			function getDate(spanname,inputname){  
				WdatePicker({lang:common.getLanguageStr(),minDate:'%y-%M-{%d+1}', el:spanname,
					onpicked:function(dp){
						var returnvalue = dp.cal.getDateStr();
						$dp.$(inputname).value = returnvalue;
						resetDays(returnvalue);
					},
					oncleared:function(dp){
						$dp.$(inputname).value = '';
						$GetEle("days").value = '';
					}
				});
			}
			
			function setDefaultDate(value,defaultDate){
				if(value==''){
					$GetEle("enableDate").value=defaultDate;
					$GetEle("enableDateSpan").innerHTML=defaultDate;
				}
			}
			
			function resetDays(date){
				var currentDate = new Date();
				$GetEle("days").value = common.daysBetween(common.date2str(currentDate,"yyyy-MM-dd"), date);
			}
			
			function dealDate(days){
				if(days > 0){
					var enableDate = new Date();
					enableDate.setDate(enableDate.getDate()+parseInt(days));
					$GetEle("enableDate").value = common.date2str(enableDate,"yyyy-MM-dd");
					$GetEle("enableDateSpan").innerHTML = common.date2str(enableDate,"yyyy-MM-dd");
				}
			}
			
			function ckNumber(days){
				var temp=/^\d+(\.\d+)?$/;
				var days = $GetEle(days);
				if(temp.test(days.value)==false){
					days.value = "";
				}
			}
function chkMail(){
if(document.resourcesysteminfo.email.value == ''){
return true;
}

var email = document.resourcesysteminfo.email.value;
var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
chkFlag = pattern.test(email);
if(chkFlag){
return true;
}
else
{
window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
document.resourcesysteminfo.email.focus();
return false;
}
}

function CheckPasswordComplexity()
{
	var ocs = "<%=password%>";
	var cs = document.resourcesysteminfo.passwordconfirm.value;
	//alert(cs);
	var checkpass = true;
	<%
	if("1".equals(passwordComplexity))
	{		
	%>
	var complexity11 = /[a-z]+/;
	var complexity12 = /[A-Z]+/;
	var complexity13 = /\d+/;
	if(cs!=""&&ocs!=cs)
	{
		if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		{
			checkpass = true;
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31863,user.getLanguage())%>");
			checkpass = false;
		}
	}
	<%
	}
	else if("2".equals(passwordComplexity))
	{
	%>
	var complexity21 = /[a-zA-Z_]+/;
	var complexity22 = /\W+/;
	var complexity23 = /\d+/;
	if(cs!=""&&ocs!=cs)
	{
		if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		{
			checkpass = true;
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83716,user.getLanguage())%>");
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}

function setPasswordLock(o)
{
	
	if(o.checked)
	{
		o.value = 1;
	}
	else
	{
		o.value = -1;
	}
}

var openStatus = 0;
function OpenDevice()
{
    dtm.DataType = 0;
    iRet = dtm.EnumerateDevicesSimple();
    if(iRet == 0)
    {
        devInfo = dtm.strInfo;
        devNum = devInfo.split(",")[1];
        iRet = dtm.OpenDevice(devNum);
        if(iRet == 0)
        {
            openStatus = 1;
        }
    }
}
function CloseDevice()
{
    iRet = dtm.CloseDevice();
}     	
//--------------------------------------------------------------//
// 登记指纹模板
//--------------------------------------------------------------//
function FingerEnroll(hiddenname){
	OpenDevice();
	if(openStatus==1){
		dtm.InputParam = "";
		iRet = dtm.EnrollSimple();
		if(iRet != 0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22147,user.getLanguage())%>");
		}else{
	  	$GetEle(hiddenname).value=dtm.strInfo;
	  	document.resourcesysteminfo.operation.value=hiddenname;
	  	document.resourcesysteminfo.submit();
		}
		CloseDevice();
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22148,user.getLanguage())%>");
	}
}
function delDactylogram(hiddenname){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
  	document.resourcesysteminfo.operation.value=hiddenname;
  	document.resourcesysteminfo.submit();
	}
}
            	
              function edit(obj){
              
          
                  if("1"=="<%=usb_enable%>"&&jQuery("#userUsbType").val()==2){
                  	<%if(!isIE.equals("true")){%>
											window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83061, user.getLanguage())%>");
											return false;
										<%}%>
                     if(!change2())return false;
                  }
                  var accounttype = <%=accounttype%>;
                  var needusbcheck = false;
                  var userUsbType=jQuery("#userUsbType").val(); 
				  var usbstate = jQuery("#usbstate").val();
                  var mode="<%=mode%>";
				  var needpwdcheck = true;
				  var isADAccount = "<%=isADAccount%>";
				  if("<%=Tools.vString(ln.getConcurrentFlag())%>" !== "1" && $GetEle("loginid").value != ""){
				  	if("<%=subcomId.trim()%>" == "" || "<%=subcomId.trim()%>" == "0"){
						  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129244, user.getLanguage())%>");
						  return ;
				  	}
					  var result = common.ajax("cmd=noMore&arg=<%=subcomId%>");
					  if(result && result == "true"&&'<%=subcomId%>'!='0'){
						  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81926,user.getLanguage())%>");
						  return false;
					  }
				  }
				 
				  //判断是否与AD账户绑定 如果与AD账户绑定了 就不进行OA的密码验证
				  if(isBindAD)
					needpwdcheck = false;
				
				
				if("1"=="<%=usb_enable%>"&&"2"==userUsbType&&jQuery("#needusb").length>0){
				     needusbcheck = $GetEle("needusb").checked;
				}
				
                 if(userUsbType=="2" && (usbstate != "1" || (usbstate == "1" && $GetEle("needauto").checked)) && !check_form(document.resourcesysteminfo, "serial")){
					 return false;
				 }
				
                 if(userUsbType=="3" && (usbstate != "1" || (usbstate == "1" && $GetEle("needauto").checked)) && !check_form(document.resourcesysteminfo, "tokenKey")){
					 return false;
				 }
				if(!chkMail()) return false;
				
				//OA判断密码长度
				
				if(isBindAD == false) {
				
					if(document.resourcesysteminfo.password.value!="qwertyuiop" && document.resourcesysteminfo.loginid.value != "" && 
							document.resourcesysteminfo.password.value.length<<%=minpasslen%> && needpwdcheck){
                     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");   
                     return ;                
                  }
				}
				
				  
				 if(usbstate == "1"){
					 var needauto = $GetEle("needauto").checked;
					 var enableDate = $GetEle("enableDate").value;
					 var enableUsbType = $GetEle("enableUsbType").value;
					 common.ajax("cmd=saveUsbAutoDate&arg0=<%=id%>&arg1="+needauto+"&arg2="+enableDate+"&arg3="+enableUsbType);
				 } else {
					 common.ajax("cmd=saveUsbAutoDate&arg0=<%=id%>&arg1=false&arg2=&arg3=0");
				 }
              //modify by xiaofeng, for td1458
              //modify by cx, for td128484
              if(isBindAD == false && "2"!=userUsbType){
              
              if($GetEle("loginid").value.indexOf(" ")!=-1 || $GetEle("loginid").value.indexOf(";")!=-1 || $GetEle("loginid").value.indexOf("--")!=-1 
            		 || $GetEle("loginid").value.indexOf("'")!=-1){
            	  window.top.Dialog.alert("<%=Util.toScreenForJs(SystemEnv.getHtmlLabelName(24752,user.getLanguage()))%>"); 
            	  return;
                  }
              else if(document.resourcesysteminfo.password.value!="qwertyuiop"&&document.resourcesysteminfo.loginid.value != ""&&document.resourcesysteminfo.password.value.length<<%=minpasslen%>){
                     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");                   
                  }else if(document.resourcesysteminfo.password.value == document.resourcesysteminfo.passwordconfirm.value ){
						document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
		                var checkpass = CheckPasswordComplexity();
		                if(checkpass)
						{
							if(needusbcheck==false || (needusbcheck==true && userUsbType=="2")){
							
							<%
							if("1".equals(isrsaopen)){
							%>
							var password = jQuery("input[name='password']");
							var passwordconfirm = jQuery("input[name='passwordconfirm']");
							passwordconfirm.val(__RSAEcrypt__.rsa_data_encrypt(passwordconfirm.val()));
							password.val(__RSAEcrypt__.rsa_data_encrypt(password.val()));
							<%}%>
			                    document.resourcesysteminfo.submit() ;
			                    obj.disabled=true;
							}
						}
                  }else{
                    window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
                  }
                 }else if(isBindAD && "2"!=userUsbType){
                	 if(document.resourcesysteminfo.loginid.value == "" && accounttype==0) {
			             window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16647,user.getLanguage())%>");
			             return;
			         }
                	 
                	 if("y" == "<%=needSynPassword%>") {
		                 //if((document.resourcesysteminfo.password.value != "" || document.resourcesysteminfo.passwordconfirm.value !="")) {
			             //    	if(document.resourcesysteminfo.loginid.value == "") {
			             //    		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16647,user.getLanguage())%>");
			             //    	 	return;
			             //    	}
		                 //}
		                 if(document.resourcesysteminfo.password.value != document.resourcesysteminfo.passwordconfirm.value) {
		                 	 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
		                 	 return;
		                 }
	                 
	            	}
	             
               
                 //document.resourcesysteminfo.loginid.value=document.resourcesysteminfo.accounttxt.value;
                  if(accounttype==0){//主账号
                 //if(isValid(document.resourcesysteminfo.loginid.value)){	
                    document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
						if(needusbcheck==false || (needusbcheck==true && userUsbType=="2" )){
						
						
			<%
			if("1".equals(isrsaopen)){
			%>
			var password = jQuery("input[name='password']");
			var passwordconfirm = jQuery("input[name='passwordconfirm']");
			passwordconfirm.val(__RSAEcrypt__.rsa_data_encrypt(passwordconfirm.val()));
			password.val(__RSAEcrypt__.rsa_data_encrypt(password.val()));
			<%}%>
		                    document.resourcesysteminfo.submit() ;
		                    obj.disabled=true;
						}
              		//}else{
                    //   window.top.Dialog.alert("无效的帐号!!!请从列表中选择。")
                   //  }
                   }else{//次账号
				   document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
						if(needusbcheck==false || (needusbcheck==true && userUsbType=="2" )){
							//document.resourcesysteminfo.accounttxt.value = "";
							
			<%
			if("1".equals(isrsaopen)){
			%>
			var password = jQuery("input[name='password']");
			var passwordconfirm = jQuery("input[name='passwordconfirm']");
			passwordconfirm.val(__RSAEcrypt__.rsa_data_encrypt(passwordconfirm.val()));
			password.val(__RSAEcrypt__.rsa_data_encrypt(password.val()));
			<%}%>
		                    document.resourcesysteminfo.submit() ;
		                    obj.disabled=true;
						}
				   }
                  }else if(isBindAD && "2"==userUsbType){
                  	if(document.resourcesysteminfo.loginid.value == "" && accounttype==0) {
			             window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16647,user.getLanguage())%>");
			             return;
			        }
                  	if("y" == "<%=needSynPassword%>") {
                  		//if((document.resourcesysteminfo.password.value != "" || document.resourcesysteminfo.passwordconfirm.value !="")) {
                 	  	//	if(document.resourcesysteminfo.loginid.value == "") {
	                 	//		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16647,user.getLanguage())%>");
	                 	 //	 	return;
                 		//	 } 
                	  //  }
                  	  
	                  if(document.resourcesysteminfo.password.value != document.resourcesysteminfo.passwordconfirm.value) {
	                 	 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
	                 	 return;
	                  }
	                  
	                 
                  	}
					 // if(isValid(document.resourcesysteminfo.loginid.value)){
					 //document.resourcesysteminfo.loginid.value=document.resourcesysteminfo.accounttxt.value;
					   <%if(usb_enable!=null&&usb_enable.equals("1")){%>
							if(document.resourcesysteminfo.loginid.value == null || document.resourcesysteminfo.loginid.value == '' || document.resourcesysteminfo.loginid.value == document.resourcesysteminfo.username.value || needusbcheck==false || (needusbcheck==true && userUsbType=="2") || (needusbcheck==true && userUsbType=="3")){
								if(needusbcheck==false || (needusbcheck==true && "<%=usbType%>"=="2" )){
								
									document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
									
			<%
			if("1".equals(isrsaopen)){
			%>
			var password = jQuery("input[name='password']");
			var passwordconfirm = jQuery("input[name='passwordconfirm']");
			passwordconfirm.val(__RSAEcrypt__.rsa_data_encrypt(passwordconfirm.val()));
			password.val(__RSAEcrypt__.rsa_data_encrypt(password.val()));
			<%}%>
				                    document.resourcesysteminfo.submit() ;
				                    obj.disabled=true;
								}
							}else{
								window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21606,user.getLanguage())%>");
							}
						<%}else{%>
						if(needusbcheck==false || (needusbcheck==true && "<%=usbType%>"=="2" )){
								document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
								
			<%
			if("1".equals(isrsaopen)){
			%>
			var password = jQuery("input[name='password']");
			var passwordconfirm = jQuery("input[name='passwordconfirm']");
			passwordconfirm.val(__RSAEcrypt__.rsa_data_encrypt(passwordconfirm.val()));
			password.val(__RSAEcrypt__.rsa_data_encrypt(password.val()));
			<%}%>
			                    document.resourcesysteminfo.submit() ;
			                    obj.disabled=true;
							}
						<%}%>
						//}else{
						//  window.top.Dialog.alert("无效的帐号!!!请从列表中选择。")
					   //}
					}else{
						<%if(usb_enable!=null&&usb_enable.equals("1")){%>
						if($GetEle("loginid").value.indexOf(" ")!=-1 || $GetEle("loginid").value.indexOf(";")!=-1 || $GetEle("loginid").value.indexOf("--")!=-1 
			            		 || $GetEle("loginid").value.indexOf("'")!=-1){
			            	  window.top.Dialog.alert("<%=Util.toScreenForJs(SystemEnv.getHtmlLabelName(24752,user.getLanguage()))%>"); 
			            	  return;
			                  }
							  
						if(document.resourcesysteminfo.password.value == document.resourcesysteminfo.passwordconfirm.value){
						if(document.resourcesysteminfo.loginid.value == null || document.resourcesysteminfo.loginid.value == '' || document.resourcesysteminfo.loginid.value == document.resourcesysteminfo.username.value || needusbcheck==false || (needusbcheck==true && userUsbType=="2") || (needusbcheck==true && userUsbType=="3")){
							document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
							var checkpass = CheckPasswordComplexity();
							if(checkpass)
							{
								if(needusbcheck==false || (needusbcheck==true && userUsbType=="2" )){
								
			<%
			if("1".equals(isrsaopen)){
			%>
			var password = jQuery("input[name='password']");
			var passwordconfirm = jQuery("input[name='passwordconfirm']");
			passwordconfirm.val(__RSAEcrypt__.rsa_data_encrypt(passwordconfirm.val()));
			password.val(__RSAEcrypt__.rsa_data_encrypt(password.val()));
			<%}%>
				                    document.resourcesysteminfo.submit() ;
				                    obj.disabled=true;
								}
							}
						}else{
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21606,user.getLanguage())%>");
						}
						}else{
							window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
						}
						<%}else{%>
						if($GetEle("loginid").value.indexOf(" ")!=-1 || $GetEle("loginid").value.indexOf(";")!=-1 || $GetEle("loginid").value.indexOf("--")!=-1 
			            		 || $GetEle("loginid").value.indexOf("'")!=-1){
			            	  window.top.Dialog.alert("<%=Util.toScreenForJs(SystemEnv.getHtmlLabelName(24752,user.getLanguage()))%>"); 
			            	  return;
			                  }
							if(document.resourcesysteminfo.password.value == document.resourcesysteminfo.passwordconfirm.value){
								document.resourcesysteminfo.operation.value = "addresourcesysteminfo";
								var checkpass = CheckPasswordComplexity();
								if(checkpass)
								{
									if(needusbcheck==false || (needusbcheck==true && userUsbType=="2" )){
									
			<%
			if("1".equals(isrsaopen)){
			%>
			var password = jQuery("input[name='password']");
			var passwordconfirm = jQuery("input[name='passwordconfirm']");
			passwordconfirm.val(__RSAEcrypt__.rsa_data_encrypt(passwordconfirm.val()));
			password.val(__RSAEcrypt__.rsa_data_encrypt(password.val()));
			<%}%>
					                    document.resourcesysteminfo.submit() ;
					                    obj.disabled=true;
									}
								}
							}else{
								window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
							}
							
						<%}%>
					}
              }
 
              function isValid(a){
               if (a == null || a == undefined || a =='') {
　　            			return true;
　　								}
                 for(i=0;i<account.options.length;i++){
                     if(a==account.options[i].text)
                             return true;
                 }
                  return false;
              }
              function viewSystemInfo(){
                location = "/hrm/resource/HrmResourceSystemView.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
              }
			  function changeshow(obj){
			    var usbstate = $GetEle("usbstate").value;				
				if(usbstate == "1"){
					showEle("serialtr5");
				} else {
					hideEle("serialtr5");
				}
				
				if(obj.value=="2"){
					showEle("serialtr1");
					hideEle("serialtr3");
				}else if(obj.value=="3"){
					hideEle("serialtr1");
					showEle("serialtr3");
				}else{
					hideEle("serialtr1");
					hideEle("serialtr3");
				}
				if(obj.value=="0")
				   jQuery("#changeUsb").hide();
				else if(obj.value=="1"){
				   jQuery("#changeUsb").show();
				   jQuery("#changeUsb").html("<%=SystemEnv.getHtmlLabelName(83738,user.getLanguage())%>");
				}else if(obj.value=="2"){
					jQuery("#changeKey").hide();
				   jQuery("#changeUsb").show();
				   if("<%=serial%>"=="")
				       jQuery("#changeUsb").html("<%=SystemEnv.getHtmlLabelName(28032,user.getLanguage())%>");  
				   else
				      jQuery("#changeUsb").html("<%=SystemEnv.getHtmlLabelName(83738,user.getLanguage())%>");      
				      
				}else if(obj.value=="3"){      
				   jQuery("#changeUsb").hide();
				   jQuery("#changeKey").show();
				   if("<%=serial%>"=="")
				       jQuery("#changeKey").html("<%=SystemEnv.getHtmlLabelName(28032,user.getLanguage())%>");  
				   else
				      jQuery("#changeKey").html("<%=SystemEnv.getHtmlLabelName(83738,user.getLanguage())%>"); 
				} 

				if(obj.value == '21'){
					showEle("serialtr21");
				}else{
					hideEle("serialtr21");
				}   
			  }
			  
			  function change(obj){
				  try{
			    if(jQuery("#needusb").attr("checked")&&obj.value!="3"){
			      if(obj.value=="1")
			           return change1(obj);
			      else if(obj.value=="2")
			           return change2(obj);    
			    }else
			         return true; 
				  }catch(e){}
			  }
			  
			  function checkSeclevel(obj){
			   if(obj.value!=""&&(isNaN(obj.value)||parseInt(obj.value)<0||parseInt(obj.value)>255||obj.value!=parseInt(obj.value)))
			      obj.value="0";
			  }
			  
			  
			  </script>
             <%if(usb_enable!=null&&usb_enable.equals("1")){%>
			<script language=javascript>
			    
			    function updateKey(){
			        var needusb=jQuery("#userUsbType").val();
			        if(needusb=="1")
			            updateKey1();
			        else if(needusb=="2")   
			            updateKey2();
			        else if(needusb=="3")
			            bindTokenKey();    
			            
			    }
			
			
				function updateKey1(){
				  /*
				  if(!resourcesysteminfo.needusb.checked==true){
					alert('该用户不是需要加强安全性的用户')
				  return
				  }
				 */ 
              try{
                wk = new ActiveXObject("WIBUKEY.WIBUKEY")
                wk.FirmCode = <%=firmcode%>
                wk.UserCode = <%=usercode%>
                wk.UsedSubsystems = 1
                wk.AccessSubSystem()
                if(wk.LastErrorCode==17){
                  window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>')
                  return
                  }
                else if(wk.LastErrorCode>0){
                  throw new Error(wk.LastErrorCode)
                  }
                wk.UsedWibuBox.MoveFirst()
                resourcesysteminfo.serial.value=wk.UsedWibuBox.SerialText
                window.top.Dialog.alert(resourcesysteminfo.serial.value);
                window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83743,user.getLanguage())%>')
                }catch(err){
                  window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>')
                  return
                }
             }

             function change1(obj){
             //if(obj.checked==true){
             try{
                wk = new ActiveXObject("WIBUKEY.WIBUKEY")
                wk.FirmCode = <%=firmcode%>
                wk.UserCode = <%=usercode%>
                wk.UsedSubsystems = 1
                wk.AccessSubSystem()
                if(wk.LastErrorCode==17){
                  window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>')
                  //obj.checked=false
                  
                  return false;
                  }
                else if(wk.LastErrorCode>0){
                  throw new Error(wk.LastErrorCode)
                  }
                wk.UsedWibuBox.MoveFirst()
                resourcesysteminfo.serial.value=wk.UsedWibuBox.SerialText
                //alert('按保存之后该用户的usb令牌生效')
                }catch(err){
                  window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>')
                  //obj.checked=false
                  
                  return false;
                }
                return true;
             //}else{
             //return
             //}
             }
			</script>
		<script language=javascript>
			function updateKey2(){
			   /*
				if(!resourcesysteminfo.needusb.checked==true){
					alert('该用户不是需要加强安全性的用户');
					return;
				}
			  */
				var returnstr = getUserName();
				if(returnstr != undefined && returnstr != ""){
					resourcesysteminfo.username.value=returnstr;
					resourcesysteminfo.loginid.value=returnstr;
				}
			}

			function change2(obj){
				//if(obj.checked==true){
					var returnstr = getUserName();
					if(returnstr != undefined && returnstr != ""){
						resourcesysteminfo.username.value=returnstr;
						resourcesysteminfo.loginid.value=returnstr;
						return true;
					}else
					    return false;
				//}
			}
		</script>
		<%if("1".equals(needusbHt)){ %>
		<OBJECT id="htactx" name="htactx"
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
<%}%>
<SCRIPT LANGUAGE="javascript">
function getUserName(){
	try{
		var hCard = htactx.OpenDevice(1);//打开设备
		if(hCard==0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>");
			return "";
		}
		
		try{
			var userName = htactx.GetUserName(hCard);//获取用户名
			htactx.CloseDevice(hCard);
			return userName;
		}catch(e){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>");
			htactx.CloseDevice(hCard);
			return "";
		}
	}catch(e){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>");
		return "";
	}
}
</script>
				 <%
			 }%>
         <script type="text/javascript">
         	var i  = 0;
         	
            function bindTokenKey(){
               url=encodeURIComponent("/login/bindTokenKey.jsp?requestFrom=system&userid=<%=id%>");  
               result=window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,null);
               if(result&&result.tokenKey!=""){
                  jQuery("#tokenKey").val(result.tokenKey);
               }
            }
			
			function changeTokenKeySpan(obj) {
				if(obj.checked) {
					$GetEle("tokenKeyspan").innerHTML = $GetEle("tokenKey").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
					$GetEle("serialspan").innerHTML = $GetEle("serial").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
				} else {
					$GetEle("tokenKeyspan").innerHTML = "";
					$GetEle("serialspan").innerHTML = "";
				}
			}
            
            function chooseUsbs(obj){
            	if(obj.value==1){
					if($GetEle("needauto").checked) {
						$GetEle("tokenKeyspan").innerHTML = $GetEle("tokenKey").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
						$GetEle("serialspan").innerHTML = $GetEle("serial").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
					} else {
						$GetEle("tokenKeyspan").innerHTML = "";	
						$GetEle("serialspan").innerHTML = "";
					}
            		changeshow(jQuery("#userUsbType")[0]);
            	}else{
					$GetEle("tokenKeyspan").innerHTML = $GetEle("tokenKey").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
					$GetEle("serialspan").innerHTML = $GetEle("serial").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
            		change(jQuery("#userUsbType")[0]);
					changeshow(jQuery("#userUsbType")[0]);
            	}
            }
			
			function changeSerial() {
				if($GetEle("usbstate").value==1){
					if($GetEle("needauto").checked) {
						checkinput('serial','serialspan');
					} else {
						$GetEle("serialspan").innerHTML = "";
					}
				}else{
					checkinput('serial','serialspan');
				}
			}
            
			function changeTokenKey() {
				if($GetEle("usbstate").value==1){
					if($GetEle("needauto").checked) {
						checkinput('tokenKey','tokenKeyspan');
					} else {
						$GetEle("tokenKeyspan").innerHTML = "";
					}
				}else{
					checkinput('tokenKey','tokenKeyspan');
				}
			}
			
            function checkTokenKey(){ 
               var tokenKey=jQuery("#tokenKey");
               if(tokenKey.val()!=""&&(!isdigit(tokenKey.val())||tokenKey.val().length!=10)){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83745,user.getLanguage())%>");
	              tokenKey.val("");
	              tokenKey.focus();
	           }else if(tokenKey.val()!=""){ 
	              jQuery.post("/login/LoginOperation.jsp",{'method':'checkIsUsed','userid':<%=id%>,'tokenKey':tokenKey.val()},function(data){
	                 data=eval("("+data+")");
	                 var status=data.status;
	                 if(status=="1"){
	                    window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83755,user.getLanguage())%>"'+data.lastname+'",<%=SystemEnv.getHtmlLabelName(83757,user.getLanguage())%>');
	                    tokenKey.val("");
	                    tokenKey.focus();
	                 }
	              });
	           }
            }
            
            function isdigit(s){
				var r,re;
				re = /\d*/i; //\d表示数字,*表示匹配多个数字
				r = s.match(re);
				return (r==s)?true:false;
		    }
		    
		    function clickBrowser(event,datas,name,_callbackParams) {
		    	$("#loginid").val(datas.name);
		    }
		    
		    function deleteElement(ext,fieldid,params) {
		     $("#loginid").val("");
			}
			
			function changePasswordVal() {
			
				<%if("1".equals(isADAccount)) {%>
					if(i%2 == 0) {
						isBindAD = false;
						if("<%=needSynPassword%>" != "y") {
							showEle("passwordInfo");
						}
						$("#oapassword").val("<%=password%>");
						document.resourcesysteminfo.passwordconfirm.value = "<%=password%>";
					} else {
						isBindAD = true;
						if("<%=needSynPassword%>" != "y") {
							hideEle("passwordInfo");
						}
						
						$("#oapassword").val("");
						document.resourcesysteminfo.passwordconfirm.value = "";
					}
					i++;
				<%} else {%>
			
					if(i%2 == 0) {
						isBindAD = true;
						if("<%=needSynPassword%>" != "y") {
							hideEle("passwordInfo");
						}
						$("#oapassword").val("");
						document.resourcesysteminfo.passwordconfirm.value = "";
					} else {
						isBindAD = false;
						if("<%=needSynPassword%>" != "y") {
							showEle("passwordInfo");
						}
						$("#oapassword").val("<%=password%>");
						document.resourcesysteminfo.passwordconfirm.value = "<%=password%>";
					}
					i++;
				<%}%>
			}
         </script>
            </body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
            </html>
