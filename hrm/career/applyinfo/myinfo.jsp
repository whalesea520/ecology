
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.hrm.career.domain.HrmCareerApply" %>
<!-- modified by wcd 2014-06-19 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="applyManager" class="weaver.hrm.career.manager.HrmCareerApplyManager" scope="page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<% 
	String method = Util.null2String(request.getParameter("method"));
	boolean showPage = method.equals("add") ? HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add",user) : HrmUserVarify.checkUserRight("HrmCareerApplyEdit:Edit",user);
	if(!showPage) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String applyid = Util.null2String(request.getParameter("applyid"));
	
	HrmCareerApply bean = applyManager.get(applyid);
	if(bean == null){
		bean.init();
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(bean != null?93:82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(773,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	int scopeId = 1;
	String sql = "";
	String needinputitems = "";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<!--checkbox组件-->
		<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
		<script language=javascript src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<!-- 下拉框美化组件-->
		<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
		<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

		<!-- 泛微可编辑表格组件-->
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();
			}
		</script>
	</HEAD>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<iframe id="checkHas" style="display:none"></iframe>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM name=resource id=resource action="save.jsp" method=post >
			<input class=inputstyle type=hidden name=operation value="saveMyInfo">
			<input class=inputstyle type=hidden name=method value="<%=method%>">
			<input class=inputstyle type=hidden name=applyid value="<%=applyid%>">
			<input class=inputstyle type=hidden name=scopeid value="<%=scopeId%>">
			<input class=inputstyle type=hidden name=rownum>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,birthday)"></BUTTON> 
				            <SPAN id=datespan ><%=bean.getBirthday()%></SPAN> 
				            <input class=inputstyle type="hidden" id="birthday" name="birthday" value="<%=bean.getBirthday()%>"> 
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle type=text name=folk value="<%=bean.getFolk()%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle type=text name=nativeplace value="<%=bean.getNativeplace()%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle type=text name=regresidentplace value="<%=bean.getRegresidentplace()%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle type=text name=certificatenum value="<%=bean.getCertificatenum()%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></wea:item>
					<wea:item>
						<select name="maritalstatus" id="maritalstatus" class=inputstyle>
							<option value="0" <%if(bean.getMaritalstatus().equals("0") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></option>
							<option value="1" <%if(bean.getMaritalstatus().equals("1") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></option>
							<option value="2" <%if(bean.getMaritalstatus().equals("2") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%></option>
						</select>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle type=text name=policy value="<%=bean.getPolicy()%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datememberspan,bememberdate)"></BUTTON> 
				            <SPAN id=datememberspan ><%=bean.getBememberdate()%></SPAN> 
				            <input class=inputstyle type="hidden" id="bememberdate" name="bememberdate" value="<%=bean.getBememberdate()%>"> 
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datepartyspan,bepartydate)"></BUTTON> 
				            <SPAN id=datepartyspan ><%=bean.getBepartydate()%></SPAN> 
				            <input class=inputstyle type="hidden" id="bepartydate" name="bepartydate" value="<%=bean.getBepartydate()%>"> 
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></wea:item>
					<wea:item>
							<select name="islabouunion" id="islabouunion" class=inputstyle>
								<option value="0" <%if(bean.getIslabouunion().equals("0") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
								<option value="1" <%if(bean.getIslabouunion().equals("1") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
							</select>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="educationlevel" browserValue='<%=bean.getEducationlevel()==-1?"":String.valueOf(bean.getEducationlevel())%>' 
				                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
				                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				                completeUrl="/data.jsp?type=educationlevel" width="60%" browserSpanValue='<%=bean.getEducationlevel()==-1?"":EducationLevelComInfo.getEducationLevelname(String.valueOf(bean.getEducationlevel()))%>'>
					        </brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle type=text name=degree value="<%=bean.getDegree()%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></wea:item>
					<wea:item>
							<select name="healthinfo" id="healthinfo" class=inputstyle>
								<option value="0" <%if(bean.getHealthinfo().equals("0") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
								<option value="1" <%if(bean.getHealthinfo().equals("1") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
								<option value="2" <%if(bean.getHealthinfo().equals("2") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
								<option value="3" <%if(bean.getHealthinfo().equals("3") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%></option>
							</select>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle maxlength=5  size=5 name=height value="<%=bean.getFormatHeight()%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("height")'>
							cm
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle maxlength=5  size=5 name=weight value="<%=bean.getFormatWeight()%>"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("weight")'>
							kg
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle type=text name=residentplace value="<%=bean.getResidentplace()%>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<input class=inputstyle type=text name=tempresidentnumber value="<%=bean.getTempresidentnumber()%>">
						</wea:required>
					</wea:item>
					<!-- 自定义字段 start -->
					<%
						CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
						cfm.getCustomFields();
						cfm.getCustomData(Util.getIntValue(applyid,0));
						while(cfm.next()){
							if(cfm.isMand()){
								needinputitems += ",customfield"+cfm.getId();
							}
							String fieldvalue = cfm.getData("field"+cfm.getId());
							String idStr = "namespan"+ cfm.getId();
							if(cfm.getHtmlType().equals("6"))continue;
					%>
					<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(cfm.getLable()),user.getLanguage())%></wea:item>
					<wea:item>
					<%
						if(cfm.getHtmlType().equals("1")){
					%>
						<wea:required id='<%=idStr %>' required="<%=cfm.isMand()%>" value="<%=fieldvalue%>">
					<%
							if(cfm.getType()==1){
					%>
							<input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=50 onChange="checkinput('customfield<%=cfm.getId()%>','namespan<%=cfm.getId()%>')">
					<%
							}else if(cfm.getType()==2){
					%>
							<input datatype="int" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','namespan<%=cfm.getId()%>')">
					<%
							}else if(cfm.getType()==3){
					%>
							<input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','namespan<%=cfm.getId()%>')">
					<%
							}
					%>
						</wea:required>
					<%
						}else if(cfm.getHtmlType().equals("2")){
					%>
						<wea:required id='<%=idStr %>' required="<%=cfm.isMand()%>" value="<%=fieldvalue%>">
							<textarea class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','namespan<%=cfm.getId()%>')" rows="4" cols="40" style="width:80%" class=Inputstyle><%=fieldvalue%></textarea>
						</wea:required>
					<%
						}else if(cfm.getHtmlType().equals("3")){

							String fieldtype = String.valueOf(cfm.getType());
							String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
							String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
							String showname = "";                                   // 新建时候默认值显示的名称
							String showid = "";                                     // 新建时候默认值

							String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
							String newdocid = Util.null2String(request.getParameter("docid"));

							if( fieldtype.equals("37") && !newdocid.equals("")) {
								if( ! fieldvalue.equals("") ) fieldvalue += "," ;
								fieldvalue += newdocid ;
							}

							if(fieldtype.equals("2") ||fieldtype.equals("19")){
								showname=fieldvalue; // 日期时间
							}else if(!fieldvalue.equals("")) {
								String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
								String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
								String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
								sql = "";

								HashMap temRes = new HashMap();

								if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")||fieldtype.equals("166")) {    // 多人力资源,多客户,多会议，多文档
									sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
								}
								else {
									sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
								}

								rs.executeSql(sql);
								while(rs.next()){
									showid = Util.null2String(rs.getString(1)) ;
									String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
									if(!linkurl.equals(""))
										//showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
										temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
									else{
										//showname += tempshowname ;
										temRes.put(String.valueOf(showid),tempshowname);
									}
								}
								StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
								String temstkvalue = "";
								while(temstk.hasMoreTokens()){
									temstkvalue = temstk.nextToken();

									if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
										showname += temRes.get(temstkvalue);
									}
								}

							}
					%>
						<%if(fieldtype.equals("2")){%>
							<button class=Calendar type="button" onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
						<%}else if(fieldtype.equals("19")){%>
							<button class=Clock type="button" onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
						<%}else{%>
							<button class=Browser type="button" onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
						<%}%>
							<input type=hidden name="customfield<%=cfm.getId()%>" value="<%=fieldvalue%>">
							<span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
			            <%if(cfm.isMand() && fieldvalue.equals("")) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%>
			        </span>
					<%
						}else if(cfm.getHtmlType().equals("4")){
					%>
							<input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
					<%
						}else if(cfm.getHtmlType().equals("5")){
							cfm.getSelectItem(cfm.getId());
					%>
							<select class=InputStyle name="customfield<%=cfm.getId()%>" class=InputStyle>
					<%
							while(cfm.nextSelect()){
					%>
								<option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%>
					<%
							}
					%>
							</select>
					<%
						}
					%>
					</wea:item>
					<%}%>
					<!-- 自定义字段 end -->
				</wea:group>
			</wea:layout>
			<div id="familyInfo" class="groupmain" style="width:100%"></div>
			<%
				sql = "select * from HrmFamilyInfo where resourceid = "+applyid +" order by id ";
				rs.executeSql(sql);
				StringBuilder datas = new StringBuilder();
				while(rs.next()){
					String member = Util.null2String(rs.getString("member"));
					String title = Util.null2String(rs.getString("title"));	
					String company = Util.null2String(rs.getString("company"));
					String jobtitle = Util.null2String(rs.getString("jobtitle"));	
					String address = Util.null2String(rs.getString("address"));	
					
					datas.append("[")
					.append("{name:'member',value:'").append(member).append("',iseditable:true,type:'input'},")
					.append("{name:'title',value:'").append(title).append("',iseditable:true,type:'input'},")
					.append("{name:'company',value:'").append(company).append("',iseditable:true,type:'input'},")
					.append("{name:'jobtitle',value:'").append(jobtitle).append("',iseditable:true,type:'input'},")
					.append("{name:'address',value:'").append(address).append("',iseditable:true,type:'input'}")
					.append("],");
				}
				String ajaxData = datas.toString();
				if(ajaxData.length() > 0){
					ajaxData = ajaxData.substring(0,ajaxData.length()-1);
				}
				ajaxData = "["+ajaxData+"]";
			%>
			<script>
				var items=[
				{width:"10%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='member'>"},
				{width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(1944,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='title'>"},
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='company'>"},
				{width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='jobtitle'>"},
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='address'>"}];
				var option= {
					openindex:true,
					navcolor:"#003399",
					basictitle:"<%=SystemEnv.getHtmlLabelName(814,user.getLanguage())%>",
					toolbarshow:true,
					colItems:items,
					usesimpledata: true,
					initdatas:eval("<%=ajaxData%>"),
					addrowCallBack:function() {
						
					},
					copyrowsCallBack:function() {
						
					},
					configCheckBox:true,
					checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
				};
			   var group=new WeaverEditTable(option);
			   $("#familyInfo").append(group.getContainer());
		   </script>
		   <!-- 自定义明细字段 start -->
		   <%

         RecordSet.executeSql("select id, formlabel from cus_treeform where viewtype='1' and parentid="+scopeId+" order by scopeorder");
         //System.out.println("select id from cus_treeform where parentid="+scopeId);
         int recorderindex = 0 ;
         while(RecordSet.next()){
             recorderindex = 0 ;
             int subId = RecordSet.getInt("id");
             CustomFieldManager cfm2 = new CustomFieldManager("HrmCustomFieldByInfoType",subId);
             cfm2.getCustomFields();
             CustomFieldTreeManager.getMutiCustomData("HrmCustomFieldByInfoType", subId, Util.getIntValue(applyid,0));
             int colcount1 = cfm2.getSize() ;
             int colwidth1 = 0 ;
             int rowcount = 0;
             while(cfm2.next()){
            	 if(!cfm2.isUse())continue;
            	 rowcount++;
             }
             if(rowcount==0)continue;
             cfm2.beforeFirst();
             if( colcount1 != 0 ) {
                 colwidth1 = 95/colcount1 ;
     %>
    <div id="cus_list_<%=subId%>" class="work_groupmaindemo_<%=subId%>" style="width:100%"></div>
	 <table Class=ListStyle cellspacing="0" cellpadding="0">
  			<tr class="DataLight">
  	      <td style="text-align: right;" colspan="2"  >
						<BUTTON Class=addbtn  type="button" accessKey=A onclick="addRow_<%=subId%>()"></BUTTON>
						<BUTTON class=delbtn type="button" accessKey=D onClick="if(isdel()){deleteRow_<%=subId%>();}"></BUTTON>
					</td>
        </tr>
        <tr>
            <td colspan=2>
            <table Class=ListStyle id="oTable_<%=subId%>" my_title="<%=RecordSet.getString("formlabel")%>" cellspacing="0" cellpadding="0" style="margin-top: 0px;">
            <COLGROUP>
            <tr class=header>
            <td width="5%">&nbsp;</td>
   <%

       while(cfm2.next()){
      	 if(!cfm2.isUse())continue;
		  String fieldlable =String.valueOf(cfm2.getLable());

   %>
		 <td width="<%=colwidth1%>%" nowrap><%=SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlable,0) ,user.getLanguage())%></td>
           <%
	   }
       cfm2.beforeFirst();
%>
</tr>
<%

    boolean isttLight = false;
    while(CustomFieldTreeManager.nextMutiData()){
            isttLight = !isttLight ;
%>
            <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
            <td width="5%"><input class="groupselectbox" type='checkbox' name='check_node_<%=subId%>' value='<%=recorderindex%>'></td>
        <%
        while(cfm2.next()){
        	if(!cfm2.isUse())continue;
            String fieldid=String.valueOf(cfm2.getId());  //字段id
            String ismand=cfm2.isMand()?"1":"0";   //字段是否必须输入
            String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
            String fieldtype=String.valueOf(cfm2.getType());
            String fieldvalue =  Util.null2String(CustomFieldTreeManager.getMutiData("field"+fieldid)) ;

            if(ismand.equals("1"))  needinputitems+= ",customfield"+fieldid+"_"+subId+"_"+recorderindex;
            //如果必须输入,加入必须输入的检查中
%>
            <td class=field nowrap style="TEXT-VALIGN: center"><div>
<%
            if(fieldhtmltype.equals("1")){                          // 单行文本框
                if(fieldtype.equals("1")){                          // 单行文本框中的文本
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle style="width: 90%" datatype="text" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input  class=InputStyle style="width: 90%" datatype="text" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" size=10>
<%
                    }

                }else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle style="width: 90%" datatype="int" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>"
                            onKeyPress="ItemCount_KeyPress()" onBlur="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input  class=InputStyle style="width: 90%" datatype="int" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
<%
                    }
                }else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                    if(ismand.equals("1")) {
%>
                        <input class=InputStyle datatype="float" style="width: 90%" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>"
                            onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')">
                        <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                    }else{
%>
                        <input class=InputStyle  datatype="float" style="width: 90%" type=text name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
<%
                    }
                }
            }else if(fieldhtmltype.equals("2")){                     // 多行文本框
                if(ismand.equals("1")) {
%>
                    <textarea class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>"  onChange="checkinput('customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>','customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span')"
                        rows="4" cols="40" style="width:80%" ><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
                    <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                }else{
%>
                    <textarea class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
<%
                }
            }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                String showname = "";                                   // 新建时候默认值显示的名称
                String showid = "";                                     // 新建时候默认值

                String newdocid = Util.null2String(request.getParameter("docid"));

                if( fieldtype.equals("37") && !newdocid.equals("")) {
                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                    fieldvalue += newdocid ;
                }

                if(fieldtype.equals("2") ||fieldtype.equals("19")){
                    showname=fieldvalue; // 日期时间
                }else if(!fieldvalue.equals("")) {
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                    sql = "";

                    HashMap temRes = new HashMap();

                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("166")) {    // 多人力资源,多客户,多会议，多文档
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    rs.executeSql(sql);
                    while(rs.next()){
                        showid = Util.null2String(rs.getString(1)) ;
                        String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                            temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                        else{
                            //showname += tempshowname ;
                            temRes.put(String.valueOf(showid),tempshowname);
                        }
                    }
                    StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                    String temstkvalue = "";
                    while(temstk.hasMoreTokens()){
                        temstkvalue = temstk.nextToken();

                        if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                            showname += temRes.get(temstkvalue);
                        }
                    }

                }
%>
                    <button class=Browser  type="button" onclick="onShowBrowser('<%=fieldid%>_<%=subId%>_<%=recorderindex%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%>"></button>
                    <span id="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>span"><%=showname%>
<%
                if( ismand.equals("1") && fieldvalue.equals("") ){
%>
                       <img src="/images/BacoError_wev8.gif" align=absmiddle>
<%
                }
%>
                    </span> <input type=hidden name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
            }else if(fieldhtmltype.equals("4")) {                    // check框
%>
                <!--xiaofeng,td1464-->
                <input class=InputStyle type=checkbox value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>0" <%if(fieldvalue.equals("1")){%> checked <%}%> onclick='changecheckbox(this,customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>)'>
                <input type= hidden name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" value="<%=fieldvalue%>">
                
<%
            }else if(fieldhtmltype.equals("5")){                     // 选择框   select
                cfm2.getSelectItem(cfm2.getId());
%>
                <select class=InputStyle name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" class=InputStyle>
<%
                while(cfm2.nextSelect()){
%>
                    <option value="<%=cfm2.getSelectValue()%>" <%=cfm2.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm2.getSelectName()%>
<%
                }
%>
                </select>
<%
            }
%>
</div>
            </td>
<%
        }
        cfm2.beforeFirst();
        recorderindex ++ ;
    }

%>
</tr>
</table>
</td>
</tr>
</table>
<script language=javascript>
var rowindex_<%=subId%> = <%=recorderindex%> ;
var curindex_<%=subId%> = <%=recorderindex%> ;
function addRow_<%=subId%>(group){
    //oRow = oTable_<%=subId%>.insertRow(-1);
 		//oRow.className="DataLight";
    
 		oRow=document.createElement("tr");
    oCell = oRow.insertCell(-1);
    //oCell.style.height=24;
    //oCell.style.background=getRowBg();

    var sHtml = "<input class='groupselectbox' type='checkbox' name='check_node_<%=subId%>' value='"+rowindex_<%=subId%>+"'>";
    oCell.innerHTML = sHtml;
<%
    while(cfm2.next()){   
    	if(!cfm2.isUse())continue;
    	// 循环开始
        String fieldhtml = "" ;
        String fieldid=String.valueOf(cfm2.getId());  //字段id
        String ismand=cfm2.isMand()?"1":"0";   //字段是否必须输入
        String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
        String fieldtype=String.valueOf(cfm2.getType());

        if(ismand.equals("1"))  needinputitems+= ",customfield"+fieldid+"_"+subId+"_"+recorderindex;
        //如果必须输入,加入必须输入的检查中

        // 下面开始逐行显示字段

        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='text' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value='' style='width:90%'>";
                }
            }else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle  datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='int' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
                }
            }else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                if(ismand.equals("1")) {
                    fieldhtml = "<input class=InputStyle datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)'><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                }else{
                    fieldhtml = "<input class=InputStyle datatype='float' type=text name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' style='width:90%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
                }
            }
        }else if(fieldhtmltype.equals("2")){                     // 多行文本框
            if(ismand.equals("1")) {
                fieldhtml = "<textarea class=InputStyle name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' onChange='checkinput1(customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\",customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span)' rows='4' cols='40' style='width:80%'></textarea><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
            }else{
                fieldhtml = "<textarea class=InputStyle name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' rows='4' cols='40' style='width:80%'></textarea>" ;
            }
        }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url

             if (!fieldtype.equals("37")) {    //  多文档特殊处理
                fieldhtml = "<button class=Browser type='button' onclick=onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "') title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
            } else {                         // 如果是多文档字段,加入新建文档按钮
                fieldhtml = "<button class=AddDoc type='button' onclick=onShowBrowser('" + fieldid + "_"+subId+"_\"+rowindex_"+subId+"+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')>" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>";
            }
            fieldhtml += "<input type=hidden name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' value=''><span id='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"span'>" ;

            if(ismand.equals("1")) {
                fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>" ;
            }
            fieldhtml += "</span>" ;
        }else if(fieldhtmltype.equals("4")) {                    // check框
            //xiaofeng,td1464
            fieldhtml += "<input class=InputStyle type=checkbox value=1 name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"0'  onclick='changecheckbox(this,customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\")'" ;
            fieldhtml += ">" ;
            fieldhtml += "<input type=hidden value=0 name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' " ;
            fieldhtml += ">" ;
        }else if(fieldhtmltype.equals("5")){                     // 选择框   select
            fieldhtml += "<select class=InputStyle name='customfield"+fieldid+"_"+subId+"_\"+rowindex_"+subId+"+\"' " ;
            fieldhtml += ">" ;

            // 查询选择框的所有可以选择的值
            cfm2.getSelectItem(cfm2.getId());
            while(cfm2.nextSelect()){
                String tmpselectvalue = Util.null2String(cfm2.getSelectValue());
                String tmpselectname = Util.toScreen(cfm2.getSelectName(),user.getLanguage());
                fieldhtml += "<option value='"+tmpselectvalue+"'>"+tmpselectname+"</option>" ;
            }
            fieldhtml += "</select>" ;
        }                                          // 选择框条件结束 所有条件判定结束
%>
    oCell = oRow.insertCell(-1);
    oCell.className="field";
    //oCell.style.height=24;
    //oCell.style.background=getRowBg();

    var sHtml = "<%=fieldhtml%>" ;
    oCell.innerHTML = sHtml;
<%
    }       // 循环结束
%>
    rowindex_<%=subId%> += 1;
    jQuery("#nodesnum_<%=subId%>").val(rowindex_<%=subId%>);
    if(group)group.addCustomRow(oRow);
}


function deleteRow_<%=subId%>(){

    len = document.forms[0].elements.length;
    var i=0;
    var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
        if (document.forms[0].elements[i].name=='check_node_<%=subId%>')
            rowsum1 += 1;
    }
    
    for(i=len-1; i >= 0;i--) {
        if (document.forms[0].elements[i].name=='check_node_<%=subId%>'){
            if(document.forms[0].elements[i].checked==true) {
            	 jQuery(document.forms[0].elements[i]).parent().parent().parent().parent().remove();
            	 jQuery(document.forms[0].elements[i]).parent().parent().parent().parent().next("tr").remove();
                //oTable_<%=subId%>.deleteRow(rowsum1+1);
								curindex_<%=subId%>--;
            }
            rowsum1--;
        }
    }
}
</script>
<input type="hidden" id="nodesnum_<%=subId%>" name="nodesnum_<%=subId%>" value="<%=recorderindex%>">
<%
             }
%>

<%
         }
%>
			<!-- 自定义明细字段 end -->
		</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	</BODY>
	<script>
		function doSave(){
			if(check_form(document.resource,'<%=needinputitems%>')){
				try{
					document.resource.rownum.value = group.count;
				}catch(e){}
				document.resource.submit();
			}
		}
		
		function onShowBrowser(id,url,linkurl,type1,ismand){
    spanname = "customfield"+id+"span";
	inputname = "customfield"+id;
	if (type1== 2 || type1 == 19){
		if (type1 == 2){
			onWorkFlowShowDate(spanname,inputname,ismand);
		}else{
			onWorkFlowShowTime(spanname,inputname,ismand);
		}
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=168 && type1!=166){
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170 || type1==166){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else if (type1==37){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids)
		}else{
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}
		if (id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65|| type1==168){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					id1ids="";
					id1idnum=0;
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							curid=ids[i];
							curname=names[i];					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
							if(id1idnum==0){
								id1ids=curid;
								id1idnum++;
							}else{
								id1ids=id1ids+","+curid;
								id1idnum++;
							}
						}
					}
					
					jQuery("#customfield"+id+"span").html(sHtml);
					jQuery("input[name=customfield"+id+"]").val(id1ids);					
				}else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
						}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}else{
			   if  (id1.id!="" && id1.id!= "0"){
			        if (linkurl == ""){
						jQuery("#customfield"+id+"span").html(id1.name);
					}else{
						jQuery("#customfield"+id+"span").html("<a href="+linkurl+id1.id+">"+id1.name+"</a>");
					}
					jQuery("input[name=customfield"+id+"]").val(id1.id);
			   }else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}
		}
	}
}
jQuery("table[id^='oTable_']").each(function(){
	var tab_index = jQuery(this).attr("id").split("_")[1]; 
	var items=[];
	var ajaxdata = [];
	var cellLen = jQuery(this).find("tr").eq(0).find("td").length;
	var cellWidth = 90/(cellLen-1);
	jQuery(this).find("tr").eq(0).find("td").each(function(index){
		if(jQuery.trim(jQuery(this).text())=="")return;
		//if(index==1)
			//items.push({width:"10px",colname:""+jQuery(this).text()+"",itemhtml:""});
		//else	
			items.push({width:cellWidth+"%",colname:""+jQuery(this).text()+"",itemhtml:""});
	}); 
	var option= {
							openindex:true,
              basictitle:jQuery(this).attr("my_title"),
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              addrowtitle:"<%=SystemEnv.getHtmlLabelName(83452,user.getLanguage())%>",
              deleterowstitle:"<%=SystemEnv.getHtmlLabelName(83453,user.getLanguage())%>",
              container: ".work_groupmaindemo_"+tab_index,
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_work" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           group.getContainer().find(".additem").unbind();
           
           group.getContainer().find(".additem").click(function(){
             window["addRow_"+tab_index](group);
           });
  	//增加行
   	jQuery(this).find("tr").each(function(index){
    if(index==0)return;
		group.addCustomRow(this);
	});   
	jQuery(this).parent().parent().parent().remove();
});
	</script>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
</HTML>
