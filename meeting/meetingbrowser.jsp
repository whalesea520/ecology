
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@page import="weaver.workflow.browserdatadefinition.ConditionField"%>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="MeetingShareUtil" class="weaver.meeting.MeetingShareUtil" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
String allUser=MeetingShareUtil.getAllUser(user);
String name = Util.null2String(request.getParameter("name"));
String address = Util.null2String(request.getParameter("address"));
String begindatefrom = Util.null2String(request.getParameter("begindatefrom"));
String begindateto = Util.null2String(request.getParameter("begindateto"));
int timeSag = Util.getIntValue(request.getParameter("timeSag"));
String flag = Util.null2String(request.getParameter("flag"));

String bdf_wfid = Util.null2String(request.getParameter("bdf_wfid"));
String bdf_fieldid = Util.null2String(request.getParameter("bdf_fieldid"));
String bdf_viewtype = Util.null2String(request.getParameter("bdf_viewtype"));
boolean isbdf=false;
List<ConditionField> list=null;
ConditionField conditionField=null;
String conditionFieldName="";
if(!"".equals(bdf_wfid)&&!"".equals(bdf_fieldid)&&!"".equals(bdf_viewtype)){
	list=ConditionField.readAll(Util.getIntValue(bdf_wfid),Util.getIntValue(bdf_fieldid),Util.getIntValue(bdf_viewtype));
}

if(list!=null&&list.size()>0){
	isbdf=true;
	if(!"1".equals(flag)){//是否是点击搜索 1表示点击搜索
		for(int i=0;i< list.size();i++){
			conditionField=list.get(i);
			conditionFieldName=conditionField.getFieldName();
			
			//处理后台设置默认值
			if("name".equalsIgnoreCase(conditionFieldName)){
				name="".equals(name)?conditionField.getValue():name;
			}else if("address".equalsIgnoreCase(conditionFieldName)){
				if("2".equals(conditionField.getValueType())){
					address="".equals(address)?conditionField.getValue():address;
				}else if("3".equals(conditionField.getValueType())){
					if(conditionField.isGetValueFromFormField()){
						String formAddress=Util.null2String(request.getParameter("bdf_address"));
						address="".equals(address)?formAddress:address;//获取表单字段值
					}
				}
			}else if("begindateselect".equalsIgnoreCase(conditionFieldName)){
				int selectType=Util.getIntValue(conditionField.getValueType(),0);
				if(selectType==6){
					begindatefrom="".equals(begindatefrom)?conditionField.getStartDate():begindatefrom;
					begindateto="".equals(begindateto)?conditionField.getEndDate():begindateto;
				}else if(selectType==8){//获取表单字段值
					if(conditionField.isGetValueFromFormField()){
						String formDate=Util.null2String(request.getParameter("bdf_begindateselect"));
						begindatefrom="".equals(begindatefrom)?formDate:begindatefrom;
						begindateto="".equals(begindateto)?formDate:begindateto;
					}
					selectType=6;
				}
				timeSag=timeSag>-1?timeSag:selectType;
			}
		}
	}
}
//如果timeSag==-1则赋值0
timeSag=timeSag==-1?0:timeSag;
String titlename ="";
String sqlwhere="";
sqlwhere+=" and m1.meetingstatus=2 and m1.repeattype=0";
sqlwhere+=" and m1.id=m2.meetingid and m2.userid in ("+allUser+")";//增加条件：当前用户在Meeting_ShareDetail权限表中有记录
if(!name.equals("")) {
    sqlwhere += " and  m1.name like '%"+name+"%'";
} 

if(!address.equals("")) {
    sqlwhere += " and  m1.address ="+address;
} 
//时间处理
if(timeSag > 0&&timeSag<6){
	String tempfromdate = TimeUtil.getDateByOption(""+timeSag,"0");
	String tempenddate = TimeUtil.getDateByOption(""+timeSag,"1");
	if(!tempfromdate.equals("")){
		sqlwhere += " and m1.begindate >= '" + tempfromdate + "'";
	}
	if(!tempenddate.equals("")){
		sqlwhere += " and m1.begindate <= '" + tempenddate + "'";
	}
}else{
	if(timeSag==6){//指定时间
		if (!begindatefrom.equals("")) {
		    sqlwhere += " and m1.begindate>='" + begindatefrom + "'";
		}
		if (!begindateto.equals("")) {
		    sqlwhere += " and m1.begindate<='" + begindateto + "'";
		}
	}
} 
%>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetCd(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:closeDlg(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top middle" onclick="javascript:document.SearchForm.submit();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span><%=SystemEnv.getHtmlLabelName(780,user.getLanguage()) %></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>"/>
</jsp:include>
<div class="zDialog_div_content">
 <FORM NAME="SearchForm" id="SearchForm"  action="meetingbrowser.jsp" method=post>
 <input type="hidden" class="InputStyle"  name="flag" value="1">
 <input type="hidden" class="InputStyle"  name="bdf_wfid" value="<%=bdf_wfid%>">
 <input type="hidden" class="InputStyle"  name="bdf_fieldid" value="<%=bdf_fieldid%>">
 <input type="hidden" class="InputStyle"  name="bdf_viewtype" value="<%=bdf_viewtype%>">
 <%
 boolean hideAll=false;//是否隐藏所以查询条件
 if(isbdf){//生成隐藏字段 
	 	String temp_name="";
		boolean isHide=false;
		boolean isReadOnly=false;
		hideAll=true;
		for(int i=0;i< list.size();i++){
			conditionField=list.get(i);
			temp_name=conditionField.getFieldName();
			isReadOnly=conditionField.isReadonly();
			isHide=conditionField.isHide();
			if("name".equalsIgnoreCase(temp_name)){
				if(isHide){%>
				<input type="hidden" class="InputStyle"  name="name" value="<%=name%>">
				<%}else{
					hideAll=false;
				}
			}else if("address".equalsIgnoreCase(temp_name)){
				if(isHide){%>
				<input type="hidden" class="InputStyle"  name="address" value="<%=address%>">
				<%}else{
					hideAll=false;
				}
			}else if("begindateselect".equalsIgnoreCase(temp_name)){
				if(isHide){%>
				<input type="hidden" name="timeSag" value="<%=timeSag%>">
			    <input type="hidden" name="begindatefrom" value="<%=begindatefrom%>">
			    <input type="hidden" name="begindateto" value="<%=begindateto%>"> 
				<%}else{
					hideAll=false;
				}
			}
		}
 } %>
 
<wea:layout type="4col">
	<%if(!hideAll){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
		<%if(isbdf){//后台设置
			String temp_name="";
			boolean isHide=false;
			boolean isReadOnly=false;
			for(int i=0;i< list.size();i++){
				conditionField=list.get(i);
				temp_name=conditionField.getFieldName();
				isReadOnly=conditionField.isReadonly();
				isHide=conditionField.isHide();
				if("name".equalsIgnoreCase(temp_name)){
					if(!isHide){%>
						<wea:item> 
						<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
						</wea:item>
						<wea:item>
							<%if(isReadOnly){%>
							 <input type="hidden" name="name" value="<%=name%>">
							 <%} %>
							<input type="text" class="InputStyle"  name="name" <%=isReadOnly?"disabled":"" %> value="<%=name%>">
						</wea:item>
					<%}%>
					
		<%		}else if("address".equalsIgnoreCase(temp_name)){
					if(!isHide){%>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%>
					</wea:item>
					<wea:item >
						<brow:browser viewType="0" name="address" browserValue='<%=address%>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp?forall=1"
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='<%=isReadOnly?"0":"1" %>' width="150px"
								completeUrl="/data.jsp?type=87&forall=1" linkUrl="/meeting/Maint/MeetingRoom.jsp?id=" 
								browserSpanValue='<%= MeetingRoomComInfo.getMeetingRoomInfoname(address) %>'></brow:browser>
					</wea:item>
					<%} %>
		<%		}else if("begindateselect".equalsIgnoreCase(temp_name)){
					if(!isHide){%>
					<wea:item >
						<%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%>
					</wea:item>
					<wea:item attributes="{'colspan':'full'}">
						 <%if(isReadOnly){%>
							 <input type="hidden" name="timeSag" value="<%=timeSag%>">
						 <%} %>
						  <span>
                          	<select name="timeSag" id="timeSag" onchange="changeTimeSag(this,'senddate');" <%=isReadOnly?"disabled":"" %>>
                          		<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                          		<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
                          		<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
                          		<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
                          		<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
                          		<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
                          		<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
                          	</select>
                          </span>
                          <span id="senddate"  style="<%=timeSag==6?"":"display:none;" %>">
                          	  <%if(!isReadOnly){ %>
                          	  <BUTTON class=calendar type=button id=SelectDate onclick=getDate(fromdatespan,begindatefrom)></BUTTON>&nbsp;
                          	  <%} %>
							  <SPAN id=fromdatespan ><%=Util.toScreen(begindatefrom, user.getLanguage())%></SPAN>
							  <input type="hidden" name="begindatefrom" value="<%=begindatefrom%>">
							   &nbsp;－&nbsp;
							   <%if(!isReadOnly){ %>
								<BUTTON class=calendar type=button id=SelectDate onclick=getDate(enddatespan,begindateto)></BUTTON>&nbsp;
								<%} %>
							  <SPAN id=enddatespan ><%=Util.toScreen(begindateto, user.getLanguage())%></SPAN>
							  <input type="hidden" name="begindateto" value="<%=begindateto%>">
						 </span>
					</wea:item>
					<%} %>
		<%		}
			}
		}else{%>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input type="text" class="InputStyle"  name="name" value="<%=name%>">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="address" browserValue='<%=address%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp?forall=1"
					hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' width="150px"
					completeUrl="/data.jsp?type=87&forall=1" linkUrl="/meeting/Maint/MeetingRoom.jsp?id=" 
					browserSpanValue='<%= MeetingRoomComInfo.getMeetingRoomInfoname(address) %>'></brow:browser>
		</wea:item>
	    <wea:item>
			<%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%>
		</wea:item>
		<wea:item attributes="{'colspan':'full'}">
				<span class="wuiDateSpan" selectId="timeSag" selectValue="<%= timeSag%>">
			       <input class=wuiDateSel type="hidden" name="begindatefrom" value="<%=begindatefrom%>">
			       <input class=wuiDateSel  type="hidden" name="begindateto" value="<%=begindateto%>">
			    </span>
		</wea:item>
		<% }%>
    </wea:group>
    <%} %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
					//得到pageNum 与 perpage
					int perpage=9;
					//设置好搜索条件
					String backFields =" m1.id ,m1.name,m1.begindate,m1.address,m1.customizeaddress ";
					String fromSql = " meeting m1,Meeting_ShareDetail m2 ";
					if(!"".equals(sqlwhere.trim())){
						sqlwhere = " where 1=1 "+ sqlwhere;
					}
					String orderBy = "m1.begindate desc";
					String linkstr = "";
					linkstr = "";
					String tableString=""+
								"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
								"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"m1.id\" sqlsortway=\"desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
								"<head>"+
									"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" orderkey=\"id\"  />"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"begindate\" orderkey=\"begindate\" />"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(780,user.getLanguage())+"\" column=\"address\" orderkey=\"address\" otherpara=\""+user.getLanguage()+"+column:customizeaddress\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingAddress\"  />"+
								"</head>"+
								"</table>";
				%>
				<wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>"
					class="zd_btn_cancle" onclick="javascript:submitClear()">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					class="zd_btn_cancle" onclick="javascript:closeDlg()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
var parentWin ;
var dialog;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#_xTable div.table").find("tr[class!='HeaderForXtalbe']").live("click",function(){
		 var id0  = $(this).find("td:first").next().next().text();
	     id0 = id0.replace("<","&lt;")
	     id0 = id0.replace(">","&gt;")
			var returnjson = {id:$(this).find("td:first").next().text(),name:id0};
			returnValue(returnjson);
	});

});
function changeTimeSag(obj,spanname){
	if($(obj).val()=="6"){
		$('#'+spanname).show();
	}else{
		$('#'+spanname).hide();
	}
}

function submitClear()
{
	var returnjson = {id:"",name:""};
	returnValue(returnjson);
}

function returnValue(returnjson){
	if(dialog){
		try{
			  dialog.callback(returnjson);
		 }catch(e){}
	
		try{
			 dialog.close(returnjson);
		 }catch(e){}
	}else{ 
		window.parent.returnValue  = returnjson;
		window.parent.close();
	}
}

function closeDlg(){
	if(dialog){
		dialog.close();
	}else{ 
		window.parent.close();
	}
	
}

function resetCd(){
	resetCondtionBrw('SearchForm');
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
