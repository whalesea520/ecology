<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head> 
<%
if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28625,user.getLanguage());//创建浏览按钮
String needfav ="1";
String needhelp ="";
String customid = Util.null2String(request.getParameter("customid"));
String browserid = Util.null2String(request.getParameter("browserid"));
String type = Util.null2String(request.getParameter("type"));
String flag = Util.null2String(request.getParameter("flag"));
String sql = "";

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_custombrowser a,modeTreeField b WHERE a.appid=b.id AND a.id="+customid;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}

String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doback(),_self} " ;//取消
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain action="/formmode/browser/CreateBrowserOperation.jsp" method=post onsubmit="javascript:return submitData();">
<table id="topTitle" cellpadding="0" cellspacing="0" style="display:none;">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<input id="customid" name="customid" type="hidden" value="<%=customid%>">
			<!-- 默认创建单选按钮 -->
			<input type="hidden" id="type" name="type" value="1">
			<TABLE class="viewform">
				<COLGROUP>
					<COL width="20%">
					<COL width="80%">
				</COLGROUP>
				<TBODY>
					<%
						String msg = "";
						if(flag.equals("1")){
							//msg = "";
							msg = SystemEnv.getHtmlLabelName(28629,user.getLanguage());//流程按钮的标识已存在，请修改
						}else if(flag.equals("2")){
							msg = SystemEnv.getHtmlLabelName(19327,user.getLanguage());//数据异常
						}
						if(!msg.equals("")){
							out.println("<font color=red>"+msg+"</font>");
						}
					%>
			    	<TR class="Spacing" style="height: 1px">
						<TD class="Line" colSpan=2 ></TD>
					</TR>
					<TR>
		      			<TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD><!-- 标识 -->
		          		<TD class=Field>
		        			<INPUT type=text class=Inputstyle size=30 maxlength="40" name="browserid" onchange='checkinput("browserid","browseridimage")' onBlur="checkBrowserId('browserid','browseridimage')" value="<%=browserid%>">
		          			<SPAN id=browseridimage><%if(browserid.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		          		</TD>
		        	</TR>
		        	<TR style="height: 1px">
		    			<TD class="Line" colSpan=2 ></TD>
		    		</TR>
		    		
		    		<!-- 创建流程按钮的时候不需要区分单选多选，应该根据流程表单中创建字段的时候选择的单选多选为准。
					<TR>
			      		<TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
						<td class="Field">
							<select id="type" name="type">
								<option value="1" <%if(type.equals("1")){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(28626,user.getLanguage())%></option>
								<option value="2" <%if(type.equals("2")){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(28627,user.getLanguage())%></option>
							</select>
						</td>
			        </TR>
			        <TR class="Spacing" style="height: 1px">
			    		<TD class="Line" colSpan=2 ></TD>
			    	</TR>
			    	-->
			    	 
					<TR>
					    <TD colspan="2">
					        <br>
					        	<b><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>：</b><!-- 说明 -->
					        <br>
					        <%=SystemEnv.getHtmlLabelName(81940 , user.getLanguage())%><br><!-- 1）标识只能为数字、字母和下划线，最大长度为40个字符。 -->
					        <%=SystemEnv.getHtmlLabelName(81941 , user.getLanguage())%><br><!-- 2）标识为自定义浏览按钮的ID。 -->
					    </TD>
					</TR>
			 	</TBODY>
			</TABLE>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

 </form>

<SCRIPT LANGUAGE="javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

function submitData()
{
	var checkfields = "browserid";
	checkBrowserId('browserid','browseridimage');
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
        frmMain.submit();
    }else{
        return false;
	}
}

//检查browserid只能为英文+数字+"_"
function checkBrowserId(inputname,inputspan){
	var inputvalue = $GetEle(inputname).value; 
	var length = inputvalue.length;
	var valuechar = inputvalue.split("");
	//alert(inputvalue +"	"+length);
	var islegal = true;
	for(var i=0;i<length;i++){
		//判断是否为数字和下划线
		var letter = valuechar[i];
		var charnumber = parseInt(letter);
		if( isNaN(charnumber) && (valuechar[i]!="_")){
			//判断是否为字母
			var str = /[_a-zA-Z]/; 
        	if(!str.test(letter)) {         
        		islegal = false; 
			}
		}
	}
	if(!islegal){
		$GetEle(inputname).value = "";
		$GetEle(inputspan).innerHTML = "<IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">";
	}
}

function doback(){
    dialog.close();
}

</SCRIPT>

</BODY></HTML>
