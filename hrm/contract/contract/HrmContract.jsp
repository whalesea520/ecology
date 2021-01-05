<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String cmd = Util.null2String(request.getParameter("cmd"));
	String id = Util.null2String(request.getParameter("id"));
	String subcid = Util.null2String(request.getParameter("subcid"));
	String deptid = Util.null2String(request.getParameter("deptid"));
	boolean hasRight = false;
	String rightStr = "";
	if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
		hasRight = true ;
		rightStr = "HrmContractTypeAdd:Add";
	}
	if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
		hasRight = true ;
		rightStr = "HrmContractAdd:Add";
	}
	if(!hasRight){
			response.sendRedirect("/notice/noright.jsp");
			return;
	}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#templet").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"/hrm/contract/contract/HrmContractOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

var dialog = null;
var _departmentid = "";
var _subid = "";
function closeDialog(){
	if(dialog)
		dialog.close();
	if(!_departmentid){
		_departmentid = "";
	}
	if(!_subid){
		_subid = "";
	}
	
	//alert("/hrm/contract/contract/HrmContract.jsp?departmentid="+_departmentid);
	window.location.href = "/hrm/contract/contract/HrmContract.jsp?departmentid="+_departmentid+"&subcompanyid="+_subid;
	return;
}

function openDialog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null ||id == ""){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmContractAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(614,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmContractEdit&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(614,user.getLanguage())%>";
	}
	url+="&subcompanyid=<%=Util.null2String(request.getParameter("subcompanyid"))%>&departmentid=<%=Util.null2String(request.getParameter("departmentid"))%>";
	dialog.Width = 800;
	dialog.Height = 750;
	dialog.maxiumnable = true;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function showUrl(url,title){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
if("<%=cmd%>" == "showtype"){
	var url = "/hrm/contract/contracttype/HrmContractTypeEdit.jsp?id=<%=id%>";
	showUrl(url,"<%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%>");
}else if("<%=cmd%>" == "showdetail"){
	var url = "/hrm/contract/contracttype/HrmContractTypeEdit.jsp?id=<%=id%>";
	showUrl(url,"<%=SystemEnv.getHtmlLabelName(33741,user.getLanguage())%>");
}

function onLog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=105 and relatedName in (select contractname from HrmContract where id = ")%>&from=hrmcontract&id="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=105")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<body>
<%

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String from = Util.null2String(request.getParameter("from"));
boolean isshow = Util.null2String(request.getParameter("isshow")).equals("1");
boolean isoracle = rs.getDBType().equals("oracle") ;
String typepar = Util.null2String(request.getParameter("typepar"));
String namepar = Util.null2String(request.getParameter("namepar"));
String manpar = Util.null2String(request.getParameter("manpar"));
String startdatefrom = Util.null2String(request.getParameter("startdatefrom"));
String startdateto = Util.null2String(request.getParameter("startdateto"));
String enddatefrom = Util.null2String(request.getParameter("enddatefrom"));
String enddateto = Util.null2String(request.getParameter("enddateto"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String status = Util.null2String(request.getParameter("status"));

String startdateselect = Util.null2String(request.getParameter("startdateselect"));
String enddateselect = Util.null2String(request.getParameter("enddateselect"));
if(!startdateselect.equals("") && !startdateselect.equals("0")&& !startdateselect.equals("6")){
	startdatefrom = TimeUtil.getDateByOption(startdateselect,"0");
	startdateto = TimeUtil.getDateByOption(startdateselect,"1");
}

if(!enddateselect.equals("") && !enddateselect.equals("0")&& !enddateselect.equals("6")){
	enddatefrom = TimeUtil.getDateByOption(enddateselect,"0");
	enddateto = TimeUtil.getDateByOption(enddateselect,"1");
}

String qname = Util.null2String(request.getParameter("flowTitle"));

if("".equals(departmentid) && !from.equals("tree") && !	from.equals("")){
	departmentid = Util.null2String((String)session.getAttribute("HrmContract_departmentid_"+user.getUID()));
}

String sqlwhere = "";
String sqlstr ="";
String currentvalue = "";
int ishead = 0;
if(sqlwhere.length()==0){
	sqlwhere = " where 1=1 ";
}
if(qname.length()>0){
	sqlwhere += " and contractname like '%" + qname +"%' ";
}
if(!namepar.equals("")){
		if(sqlwhere.equals("")) sqlwhere += " where contractname like '%" + namepar +"%' ";

	else
		sqlwhere += " and contractname like '%" + namepar +"%' ";
}
if(!manpar.equals("")){

		if(sqlwhere.equals(""))sqlwhere += " where contractman =" + manpar +" ";

	else
		sqlwhere += " and contractman =" + manpar +" ";
}
if(subcid.length()>0){
	sqlwhere += " and contractman in (select id from HrmResource where subcompanyid1 = " + subcid +") ";
}
if(deptid.length()>0){
	sqlwhere += " and contractman in (select id from HrmResource where departmentid = " + deptid +") ";
}
if(!typepar.equals("")){

		if(sqlwhere.equals(""))sqlwhere += " where contracttypeid in (select id from HrmContractType where typename like '%" + typepar +"%') ";

	else
		sqlwhere += " and contracttypeid in (select id from HrmContractType where typename like '%" + typepar +"%') ";
}
if(!startdatefrom.equals("")){

       if(sqlwhere.equals(""))	sqlwhere+=" where contractstartdate>='"+startdatefrom+"'";
		else 	sqlwhere+=" and contractstartdate>='"+startdatefrom+"'";
}
if(!startdateto.equals("")){
        if(sqlwhere.equals(""))	sqlwhere+=" where contractstartdate<='"+startdateto+"'";
		else 	sqlwhere+=" and contractstartdate<='"+startdateto+"'";

}
if(!enddatefrom.equals("")){

		if(sqlwhere.equals(""))	sqlwhere+=" where contractenddate>='"+enddatefrom+"'";
		else 	sqlwhere+=" and contractenddate>='"+enddatefrom+"'";
}
if(!enddateto.equals("")){
      

		if(sqlwhere.equals(""))	sqlwhere+=" where contractenddate<='"+enddateto+"'";
		else 	sqlwhere+=" and contractenddate<='"+enddateto+"'";

}



if(!status.equals("")&& !status.equals("8")&&!status.equals("9") ){
			if(sqlwhere.equals("")){
				sqlwhere = " where contractman in (select id from hrmresource where status = "+status+" )  ";
			}else{
				sqlwhere += " and contractman in ( select id from hrmresource where status = "+status+" ) ";
			}
}

if(status.equals("8")||status.equals("") ){
			if(sqlwhere.equals("")){
				sqlwhere = " where contractman in (select id from hrmresource where status = 0 or status = 1 or status = 2 or status = 3) ";
			}else{
				sqlwhere += " and contractman in  (select id from hrmresource where status = 0 or status = 1 or status = 2 or status = 3) ";
			}
		}

if(detachable==1||true){
	if(!departmentid.equals("") && subcompanyid.equals("")){
			if(sqlwhere.equals("")){
			sqlwhere += " where id != 0 and  contractman in (select id from HrmResource where departmentid ="+departmentid+")" ;
			}else{
			sqlwhere += " and id != 0 and  contractman in (select id from HrmResource where departmentid ="+departmentid+")" ;
			}
	}else if(!subcompanyid.equals("") && departmentid.equals("")){
		if(sqlwhere.equals("")){
				sqlwhere += " where id != 0 and  contractman in (select id from HrmResource where subcompanyid1 ="+subcompanyid+")" ;
		}else{
				sqlwhere += " and id != 0 and  contractman in (select id from HrmResource where subcompanyid1 ="+subcompanyid+")" ;
		}
	
	}else if (from.equals("location")){
			if(!subcompanyid.equals("")){
				if(sqlwhere.equals("")){
				sqlwhere += " where id != 0 and  contractman in ((select id from HrmResource where subcompanyid1 ="+subcompanyid+"))" ;
				}else{
				sqlwhere += " and id != 0 and  contractman in ((select id from HrmResource where subcompanyid1 ="+subcompanyid+"))" ;
				}
			}else if (!departmentid.equals("")){
				if(sqlwhere.equals("")){
					sqlwhere += " where id != 0 and  contractman in ((select id from HrmResource where subcompanyid1 ="+departmentid+"))" ;
					}else{
					sqlwhere += " and id != 0 and  contractman in ((select id from HrmResource where subcompanyid1 ="+departmentid+"))" ;
					}
			}
	}else if (from.equals("delete")){
		if(sqlwhere.equals("")){
				sqlwhere += " where id != 0 and  contractman in ((select id from HrmResource where departmentid ="+user.getUserDepartment()+"))" ;
				}else{
				sqlwhere += " and id != 0 and  contractman in ((select id from HrmResource where departmentid ="+user.getUserDepartment()+"))" ;
				}
	}
}else{
	if(sqlwhere.equals("")){
		sqlwhere += " where id != 0 " ;
	}else{
		sqlwhere += " and id != 0 " ;
	}
}
if(!"".equals(departmentid)){
	session.setAttribute("HrmContract_departmentid_"+user.getUID(), departmentid);
}
session.setAttribute("sqlwhere",sqlwhere);
int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
  String sqlnum = "select count(id) from HrmContract "+sqlwhere;
  //System.out.println("sqlnum:"+sqlnum);
  rs.executeSql(sqlnum);
  rs.next();
  numcount = rs.getInt(1);


String temptable = "temptable"+Util.getNumberRandom();
String sqltemp = "" ;
String temptable1="";
if(isoracle) {
    //sqltemp = "create table "+temptable+" as select * from ( select * from HrmContract "+sqlwhere+" order by id desc )  where rownum<"+ (pagenum*perpage+1);
	temptable1="(select * from (select *  FROM HrmContract "+sqlwhere+"  order by id desc ) where rownum<"+ (pagenum*perpage+1)+")  s";
}
else {
    //sqltemp = "select top "+(pagenum*perpage)+" * into "+temptable+" from HrmContract "+sqlwhere+" order by id desc";
    temptable1="(select top "+(pagenum*perpage+1)+"  *  from HrmContract  "+sqlwhere+"  order by id desc) as s";
}

//rs.executeSql(sqltemp);
//out.print(temptable1);
String sqlcount = "select count(id) from "+temptable1;
//rs.executeSql(sqlcount);
rs.next();
int count = rs.getInt(1);
String sql = "" ;
if(isoracle) {
    sql = "select * from (select * from "+temptable1 +" order by id ) where rownum<="+ (count - ((pagenum-1)*perpage)) ;
}
else {
    sql = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable1+" order by id ";
}
//out.print(sql);
boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage());
String needfav ="1";
String needhelp ="";
if(!isshow){
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
    int deplevel=0;
    if(detachable==1){
       deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmContractAdd:Add",Util.getIntValue(DepartmentComInfo.getSubcompanyid1(departmentid)));
    }else{
      if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user))
        deplevel=2;
    }
   // if(((subcompanyid.length()>0||departmentid.length()>0))|| detachable == 0) {
	//	if(deplevel>0){
			if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			}
		//}
	//}
    if(HrmUserVarify.checkUserRight("HrmContractDelete:Delete", user)){ 
    	   RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
    	   RCMenuHeight += RCMenuHeightStep ;
    	}	
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
	
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}%>
<FORM id=templet name=templet action="HrmContract.jsp" method=post>
<input class=inputstyle type="hidden" name="from">
<input class=inputstyle type="hidden" name="departmentid" value="<%=departmentid%>">
<input class=inputstyle type="hidden" name="subcompanyid" value="<%=subcompanyid%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmContractDelete:Delete", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" id="flowTitle" name="flowTitle" value="<%=qname %>" onchange="setKeyword('flowTitle','namepar','templet');"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></wea:item>
    <wea:item><input  class=inputstyle type=text name=typepar value=<%=typepar%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15142,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=text id=namepar name=namepar value=<%=namepar%>></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%></wea:item>
    <wea:item>
			<brow:browser viewType="0" name="manpar" browserValue='<%=manpar %>' 
        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
        completeUrl="/data.jsp" width="80%" linkUrl="javascript:openhrm($id$)" 
        browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(manpar),user.getLanguage()) %>'>
      </brow:browser>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelNames("15776,124",user.getLanguage())%></wea:item>
	<wea:item>
		<span>
			<brow:browser viewType="0" name="deptid" browserValue='<%=deptid%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=DepartmentComInfo.getDepartmentname(deptid)%>'>
			</brow:browser>
		</span>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelNames("15776,26505",user.getLanguage())%></wea:item>
	<wea:item>
		<span>
			<brow:browser viewType="0" name="subcid" browserValue='<%=subcid%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcid)%>'>
			</brow:browser>
		</span>
	</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
    <wea:item>
       <span>
      	<select name="startdateselect" id="startdateselect" onchange="changeDate(this,'spanstartdate');" style="width: 135px">
      		<option value="0" <%=startdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=startdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=startdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=startdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=startdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=startdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=startdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanstartdate style="<%=startdateselect.equals("6")?"":"display:none;" %>">
	       <BUTTON type="button" class=Calendar id=selectstartdatefrom onclick="getDate(startdatefromspan,startdatefrom)"></BUTTON>
	       <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN> －
	       <BUTTON type="button" class=Calendar id=selectstartdateto onclick="getDate(startdatetospan,startdateto)"></BUTTON>
	       <SPAN id=startdatetospan ><%=startdateto%></SPAN>
       </span>
       <input class=inputstyle type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
       <input class=inputstyle type="hidden" name="startdateto" value="<%=startdateto%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></wea:item>
    <wea:item>
       <span>
      	<select name="enddateselect" id="enddateselect" onchange="changeDate(this,'spanenddate');" style="width: 135px">
      		<option value="0" <%=enddateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=enddateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=enddateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=enddateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=enddateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=enddateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=enddateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanenddate style="<%=enddateselect.equals("6")?"":"display:none;" %>">
	       <BUTTON type="button" class=Calendar id=selectenddatefrom onclick="getDate(enddatefromspan,enddatefrom)"></BUTTON>
	       <SPAN id=enddatefromspan ><%=enddatefrom%></SPAN> －
	       <BUTTON type="button" class=Calendar id=selectenddateto onclick="getDate(enddatetospan,enddateto)"></BUTTON>
	       <SPAN id=enddatetospan ><%=enddateto%></SPAN>
       </span>
       <input class=inputstyle type="hidden" name="enddatefrom" value="<%=enddatefrom%>">
       <input class=inputstyle type="hidden" name="enddateto" value="<%=enddateto%>">
    </wea:item>
 		<wea:item><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
    <wea:item>
        <SELECT class=inputstyle id=status name=status value="<%=status%>">
<%

    if(status.equals("")){
      status = "8";
    }
  
%>
                   <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
                   <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
                   <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
                   <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
                   <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
                   <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
                   <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
                   <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
                   <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
                   <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
                 </SELECT>
    </wea:item>
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%
	//得到pageNum 与 perpage
	//int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
	//int perpage = UserDefaultManager.getNumperpage();
	if(perpage <2) perpage=15;
	
	//设置好搜索条件
	String backFields =" id,contractname,contracttypeid,contractman,contractstartdate,contractenddate ";
	String fromSql = " HrmContract";
	String sqlmei = "";
	String sqlWhere = "" ;
	String orderBy="";
	//orderBy = " enddate  ";
	if(!sqlwhere.equals("")){
	sqlwhere += sqlmei;
	}
	String linkstr = "";
	//linkstr = "HrmCheckBasicInfo.jsp";
	//操作字符串
	String  operateString= "";
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmContractOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmContractEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmContractDelete:Delete", user)+":"+":"+HrmUserVarify.checkUserRight("HrmContractAdd:add", user)+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
			   operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="</operates>";	
	 String tabletype="checkbox";
	 if(HrmUserVarify.checkUserRight("HrmContractDelete:Delete", user)){
	 	tabletype = "checkbox";
	 }
	 if(isshow){
		tabletype = "none";
	 }
 
	
	String tableString=""+
											"<table pageId=\""+PageIdConst.HRM_Contract+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_Contract,user.getUID(),PageIdConst.HRM)+"\" tabletype=\""+tabletype+"\">"+
											" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmContractCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
											"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
											"<head>";
				tableString+="<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15142,user.getLanguage())+"\" column=\"contractname\" orderkey=\"id\" href=\"HrmContractView.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_fullwindow\"/>";
				tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15776,user.getLanguage())+"\" column=\"contractman\" orderkey=\"contractman\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>";
				tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(6158,user.getLanguage())+"\" column=\"contracttypeid\" orderkey=\"contracttypeid\" href=\"/hrm/contract/contract/HrmContract.jsp?cmd=showtype\" linkkey=\"id\" transmethod=\"weaver.hrm.contract.ContractTypeComInfo.getContractTypename\" target=\"_self\"/>";	    
				tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1970,user.getLanguage())+"\" column=\"contractstartdate\" orderkey=\"contractstartdate\" transmethod=\"\"/>";
				tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15236,user.getLanguage())+"\" column=\"contractenddate\" orderkey=\"contractenddate\" transmethod=\"\"/>";
				tableString+="</head>";
				if(!isshow){
				tableString+=operateString;
				}
				tableString+="</table>";

	                   %>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_Contract %>"/>
<wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'   mode="run"/>

</BODY>
<script language=javascript>
function submitData() {
 document.templet.from.value = "location";
 templet.submit();

}
</script>
<script language=vbs>
sub onShowResource()
	Dim id
if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>")
	end if
	if NOT isempty(id) then
	        if id(0)<> "" then
		manparspan.innerHtml = "<a href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		templet.manpar.value=id(0)
		else
		manparspan.innerHtml = ""
		templet.manpar.value=""
		end if
	end if
end sub
</script>
<script language=javascript>
function pageup(){
    document.templet.pagenum.value="<%=pagenum-1%>";
    document.templet.action="HrmContract.jsp";
    document.templet.submit();
}
function pagedown(){
    document.templet.pagenum.value="<%=pagenum+1%>";
    document.templet.action="HrmContract.jsp";
    document.templet.submit();
}
function ContractExport(){
    searchexport.location="ContractReportExport.jsp";
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
