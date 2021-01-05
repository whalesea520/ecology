<%@ page import = "weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%!
public ArrayList<Integer> getLsResource(weaver.conn.RecordSet rs,String sqlwhere2)throws Exception{
	ArrayList<Integer> lsReource = new ArrayList<Integer>();
	ArrayList<HrmShareType>  lsHrmShareType = new ArrayList<HrmShareType>();
	HrmShareType hrmShareType = new HrmShareType();
	
	//首先获得范围表中的数据
	rs.executeSql(" SELECT sharetype,relatedId,level_from, level_to FROM hrmarrangeshiftset ");
	while(rs.next()){
		hrmShareType = new HrmShareType();
		hrmShareType.setSharetype(rs.getInt("sharetype"));
		hrmShareType.setRelatedId(rs.getInt("relatedId"));
		hrmShareType.setLevel_from(rs.getInt("level_from"));
		hrmShareType.setLevel_to(rs.getInt("level_to"));
		lsHrmShareType.add(hrmShareType);
	}
	
	for(int i=0;i<lsHrmShareType.size();i++){
		hrmShareType = lsHrmShareType.get(i);
		if(hrmShareType.getSharetype()==5){
			//所有人
			rs.executeSql("select id from hrmresource where  status in(0,1,2,3) " 
										+" and seclevel >= "+hrmShareType.getLevel_from() +" and seclevel >= "+hrmShareType.getLevel_to()
										+ sqlwhere2 + " order by departmentid ");
			while(rs.next()){
				lsReource.add(rs.getInt("id"));
			}
		}else if(hrmShareType.getSharetype()==4){
			//角色
			rs.executeSql("SELECT resourceid FROM HrmRoleMembers WHERE roleid ="+hrmShareType.getRelatedId()
									+" and rolelevel>="+hrmShareType.getLevel_from() +" AND rolelevel<="+hrmShareType.getLevel_to());
			while(rs.next()){
				lsReource.add(rs.getInt("id"));   
			}
		}else if(hrmShareType.getSharetype()==3){
			//人力资源	
			lsReource.add(hrmShareType.getRelatedId());
		}else if(hrmShareType.getSharetype()==2){
			//部门
			rs.executeSql("SELECT id FROM hrmresource WHERE departmentid in ("+DepartmentComInfo.getAllChildDepartId(""+hrmShareType.getRelatedId(),""+hrmShareType.getRelatedId())
								+") and seclevel>="+hrmShareType.getLevel_from() +" AND seclevel<="+hrmShareType.getLevel_to()+ sqlwhere2 + " order by departmentid");
			while(rs.next()){
			lsReource.add(rs.getInt("id"));
			}
		}else if(hrmShareType.getSharetype()==1){
			//分部
			String subComIds = SubCompanyComInfo.getSubCompanyTreeStr(""+hrmShareType.getRelatedId())+hrmShareType.getRelatedId();
			rs.executeSql("SELECT id FROM hrmresource WHERE subcompanyid1 in ("+subComIds
								+") and seclevel>="+hrmShareType.getLevel_from() +" AND seclevel<="+hrmShareType.getLevel_to()+ sqlwhere2 + " order by departmentid");
		
			while(rs.next()){
				lsReource.add(rs.getInt("id"));
			}
		}
	}
	return lsReource;
}

%>
<HTML>
<HEAD>
<%
if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>

<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16693 , user.getLanguage()) ; 
String needfav ="1";
String needhelp ="";
boolean CanAdd = HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user);

Calendar thedate = Calendar.getInstance() ; //

String currentdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ;   // 当天

String rightlevel = HrmUserVarify.getRightLevel("HrmArrangeShiftMaintance:Maintance" , user ) ;
String sqlwherestr = "" ;

if(rightlevel.equals("0") ) {
    sqlwherestr = "?sqlwhere=where departmentid=" + user.getUserDepartment() ; 
}
else if(rightlevel.equals("1") ) {
    sqlwherestr += "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ; 
}

String department = Util.fromScreen(request.getParameter("department") , user.getLanguage()) ; //部门
String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到
String resourceid = Util.fromScreen(request.getParameter("resourceid") , user.getLanguage()) ; //人力资源
String shiftname = Util.fromScreen(request.getParameter("shiftname") , user.getLanguage()) ; //排班类型

ArrayList<Integer> lsResource = getLsResource(rs,"");
String whereClause = "";
for(Integer id :lsResource){
	if(whereClause.length()>0)whereClause+=",";
	whereClause+=id;
}
if(sqlwherestr.length()==0){
	sqlwherestr += "?sqlwhere=where hrmresource.id in( "+whereClause+")";
}else{
	sqlwherestr += " and hrmresource.id in( "+whereClause+")";
}
%>

<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doCreate(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doCreate(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmmain name=frmmain method=post action="HrmArrangeShiftMaintanceOperation.jsp">
<input class=inputstyle type="hidden" name="operation" value=process>
<input class=inputstyle type="hidden" name="department" value="<%=department%>">

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
  	<wea:item><%=SystemEnv.getHtmlLabelNames("33604,1867",user.getLanguage())%></wea:item> 
   	<wea:item>
			 <%
			 String url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"+sqlwherestr;
			 String completeUrl = "/data.jsp?whereClause= t1.id in( "+whereClause+")";
			 %>
 			 <brow:browser viewType="0" name="multresourceid" browserValue="" browserUrl='<%=url %>'
         hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
         completeUrl='<%=completeUrl %>' linkUrl="javascript:openhrm($id$)"
         browserSpanValue="">
       </brow:browser>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(740 , user.getLanguage())%></wea:item>
     <wea:item>
        <BUTTON class=Calendar type="button" id=selectstartdate onclick="getDate(fromdatespan,fromdate)"></BUTTON> 
        <SPAN id=fromdatespan >
        <%if(!fromdate.equals("")){%><%=fromdate%><%}else{%>
             <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
             <%}%>
        </SPAN> 
        <input class=inputstyle type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>" onChange='checkinput("fromdate","fromdatespan")'>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(741 , user.getLanguage())%></wea:item>
     <wea:item>
       <BUTTON class=Calendar type="button" id=selectendsedate onclick="getDate(enddatespan,enddate)"></BUTTON> 
        <SPAN id=enddatespan >
        <%if(!enddate.equals("")){%><%=enddate%><%}else{%>
             <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
             <%}%>
        </SPAN> 
         <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>" onChange='checkinput("enddate","enddatespan")'>
     </wea:item>  
     <wea:item><%=SystemEnv.getHtmlLabelName(16255 , user.getLanguage())%></wea:item>
     <wea:item>         
 			<brow:browser viewType="0" name="shiftname" browserValue='<%=shiftname %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/schedule/HrmMutiArrangeShiftBrowser.jsp?shiftids="
      hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=HrmArrangeShift" 
      browserSpanValue='<%=shiftname %>'
      ></brow:browser>  
    </wea:item>
    </wea:group>
</wea:layout>
</form>
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
<script language=javascript>
//浏览框显示值
function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);

			jQuery(inputname).val(ids);
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");

			linkurl = ""

			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];

				sHtml += "<a target='_blank' href=/hrm/resource/HrmResource.jsp?id=" + curid + ">" + curname + "</a>&nbsp;";
			}

			jQuery(spanname).html(sHtml);
		} else {
			jQuery(inputname).val("")
			jQuery(spanname).html("");
		}
	}
}

 function onShowResource(spanname , inputname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp<%=sqlwherestr%>",inputname , spanname);
 }

 function doCreate(obj){
     if(check_form(document.frmmain,'multresourceid,fromdate,enddate')){
         if( document.frmmain.fromdate.value > document.frmmain.enddate.value ) {
             window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83828,user.getLanguage())%>") ;
             return ;
         }

         if( document.frmmain.fromdate.value < "<%=currentdate%>" ) {
             window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83830,user.getLanguage())%>") ;
             return ;
         }

         if( document.frmmain.shiftname.value=='') {
             if(confirm("<%=SystemEnv.getHtmlLabelName(83832,user.getLanguage())%>")) {
                 document.frmmain.action="HrmArrangeShiftMaintanceOperation.jsp" ; 
                 document.frmmain.operation.value="process" ; 
                 obj.disabled = true ;
                 document.frmmain.submit();
             }
         }
         else {
             document.frmmain.action="HrmArrangeShiftMaintanceOperation.jsp" ; 
             document.frmmain.operation.value="process" ; 
             obj.disabled = true ;
             document.frmmain.submit();
         }
     }
 }

</script>

<script language=vbs>
 sub onShowResource1(spanname , inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp<%=sqlwherestr%>")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            spanname.innerHtml = Mid(id(1),2,len(id(1)))
            inputname.value=Mid(id(0),2,len(id(0)))
        else 
            spanname.innerHtml="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
            inputname.value=""
	end if
	end if
end sub

sub onShowArrangeShift(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmArrangeShiftBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> 0 then
		tdname.innerHtml = id(1)
		inputename.value=id(0)
		else
		tdname.innerHtml = ""
		inputename.value= ""
		end if
	end if
end sub
</script>
</body>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
