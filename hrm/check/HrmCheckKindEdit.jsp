
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*,weaver.hrm.tools.HrmDateCheck" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckItemComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobComInfo" class="weaver.hrm.check.JobComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML>
<%!
/**
*@Date June 2,2004
*@author Charoes Huang
*Description:是否能够删除
*/
private boolean canDelete(int checkKindID){
	boolean canDelete = true;

	String sqlStr ="SELECT COUNT(*) From HrmCheckList WHERE checktypeid ="+checkKindID;
	
	RecordSet rs = new RecordSet();
	rs.executeSql(sqlStr);
	int count = 0;
	if(rs.next()){
		count = rs.getInt(1);
	}
	
	if(count > 0){
		canDelete = false;
	}

	return canDelete;
}
%>

<%
  if(!HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

      // 人力资源每日检查
		/*
	HrmDateCheck hdc = new HrmDateCheck();
	hdc.checkDate();
		*/
    String id = request.getParameter("id");

	boolean canDelete = canDelete(Util.getIntValue(id,0));
	String sql = null;
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css" type=text/css rel="stylesheet">
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language="javascript" src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6118,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    int trainTableIndex = 0;
    int cerTableIndex = 0;
    int rewardTableIndex = 0; 
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="edit();">
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=hrmcheckkind id=hrmcheckkind action="HrmCheckOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=trainrownum>
<input class=inputstyle type=hidden name=rewardrownum>
<input class=inputstyle type=hidden name=cerrownum>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15759,user.getLanguage())%>'>
		<%
		    String kindname="" ;
		    String checkcycle="" ;
		    String checkexpecd="" ;
		    String checkstartdate="" ;
		    String checkenddate="" ;
		    RecordSet.executeProc("HrmCheckKind_SByid",id);
		    if( RecordSet.next()){
		         kindname = Util.toScreenToEdit(RecordSet.getString("kindname"),user.getLanguage());
		         checkcycle = Util.toScreenToEdit(RecordSet.getString("checkcycle"),user.getLanguage());
		         checkexpecd = Util.toScreenToEdit(RecordSet.getString("checkexpecd"),user.getLanguage());
		         checkstartdate = Util.toScreenToEdit(RecordSet.getString("checkstartdate"),user.getLanguage());
		         
		    }
		%>
	  <wea:item><%=SystemEnv.getHtmlLabelName(15755,user.getLanguage())%></wea:item>            
	  <wea:item> 
	  	<input class=inputstyle  maxLength=30 size=30 name="kindname" value="<%=kindname%>" onchange='checkinput("kindname","kindnamespan")'>
	    <SPAN id=kindnamespan></SPAN> 
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(15756,user.getLanguage())%></wea:item>
	  <wea:item> 
      <select class=inputstyle name=checkcycle >
        <option value="1" <%if(checkcycle.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
        <option value="2" <%if(checkcycle.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
        <option value="3" <%if(checkcycle.equals("3")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
        <option value="4" <%if(checkcycle.equals("4")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
      </select>
    </wea:item> 
    <wea:item><%=SystemEnv.getHtmlLabelName(15757,user.getLanguage())%></wea:item>
    <wea:item> 
      <input class=inputstyle  maxLength=30 size=5 name="checkexpecd" value="<%=checkexpecd%>" onchange='checkinput("checkexpecd","checkexpecdspan")' onKeyPress="ItemCount_KeyPress()"><%=SystemEnv.getHtmlLabelName(1925, user.getLanguage())%>
      <SPAN id=checkexpecdspan></SPAN> 
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15758,user.getLanguage())%></wea:item>
    <wea:item><BUTTON class=Calendar type="button" id=selectcontractbegintime onClick="getHrmDate(checkstartdatespan,checkstartdate)"></BUTTON> 
      <SPAN id=checkstartdatespan ><%=checkstartdate%></SPAN> 
      <input class=inputstyle type="hidden" id="checkstartdate" name="checkstartdate" value=<%=checkstartdate%>>
    </wea:item>
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<div id="lan" class="trainTable" style="width:100%"></div>
		<script>
		var items=[
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>",itemhtml:"<span class='browser' name='jobid' completeurl='/data.jsp?type=hrmjobtitles' browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectedids=' hasinput='true' isSingle='false'></span>"},
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%>",itemhtml:"<input type='text' name='deptid' disabled/>"},
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>",itemhtml:"<input type='text' name='subcid' disabled/>"},
				{width:"5%",tdclass:"desclass",colname:"",itemhtml:""}];
		<%
			sql = "select * from HrmCheckPost where checktypeid = "+id;  
			rs.executeSql(sql);
			StringBuffer ajaxData = new StringBuffer();
			ajaxData.append("[");
		  while(rs.next()){
				String jobid = Util.null2String(rs.getString("jobid"));
				String deptid = Util.null2String(rs.getString("deptid"));
				String subcid = Util.null2String(rs.getString("subcid"));
				if(deptid.length()==0||deptid.equals("0")){
					//分部 部门丢失情况从jobtitle的departmenid
					//deptid = JobTitlesComInfo.getDepartmentid(jobid);
					//subcid = DepartmentComInfo.getSubcompanyid1(deptid);
				}
				trainTableIndex++;
				ajaxData.append("[");
				ajaxData.append("{name:\"jobid\",value:\""+jobid+"\",label:\""+Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobid),user.getLanguage())+"\",iseditable:true,type:\"browser\"},");
				ajaxData.append("{name:\"deptid\",value:\""+Util.toScreen(DepartmentComInfo.getDepartmentname(deptid),user.getLanguage())+"\",label:\""+Util.toScreen(DepartmentComInfo.getDepartmentname(deptid),user.getLanguage())+"\",iseditable:true,type:\"input\"},");
					ajaxData.append("{name:\"subcid\",value:\""+Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcid),user.getLanguage())+"\",label:\""+Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcid),user.getLanguage())+"\",iseditable:true,type:\"input\"}");
				if(rs.getCounts()==trainTableIndex){
					ajaxData.append("]");
				}else{
					ajaxData.append("],");
				}
		  }
		  ajaxData.append("]");
		%>
		var ajaxdata=<%=ajaxData.toString()%>;
		var trainTableIndex = <%=trainTableIndex%>;
		var option= {
									openindex:true,
		              basictitle:"<%=SystemEnv.getHtmlLabelName(17425,user.getLanguage())%>",
		              toolbarshow:true,
		              colItems:items,
		              usesimpledata: true,
		              container:".trainTable",
		              initdatas: ajaxdata,
		              addrowCallBack:function(obj,tr,entry) {
		         				trainTableIndex = obj.count;
		              },
		              copyrowsCallBack:function(obj,tr,entry) {
										trainTableIndex = obj.count;
		              },
		             	configCheckBox:true,
		             	checkBoxItem:{"itemhtml":'<input name="check_lan" class="groupselectbox" type="checkbox" >',width:"5%"}
		            };
		           var group=new WeaverEditTable(option);
        $(".trainTable").append(group.getContainer());
       </script>  
  </wea:item> 
  <wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<div id="lan" class="cerTable" style="width:100%"></div>
		<script>
			var items=[
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%>",itemhtml:"<span class='browser' name='checkitemid' completeurl='/data.jsp?type=HrmCheckItem' browserurl='/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/check/CheckItemBrowser.jsp?selectedids=' hasinput='true' isSingle='false'></span>"},
				{width:"70%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:30%' name='checkitemproportion' onKeyPress='ItemCount_KeyPress()'>%"}];
		<%
			sql = "select * from HrmCheckKindItem where checktypeid = "+id;  
			rs.executeSql(sql);
			StringBuffer ajaxData = new StringBuffer();
			ajaxData.append("[");
		  while(rs.next()){
        String checkitemproportion = Util.null2String(rs.getString("checkitemproportion"));
        String checkitemid = Util.null2String(rs.getString("checkitemid"));
        cerTableIndex++;
				ajaxData.append("[{name:\"checkitemid\",value:\""+checkitemid+"\",label:\""+Util.toScreen(CheckItemComInfo.getCheckName(checkitemid),user.getLanguage())+"\",iseditable:true,type:\"browser\"},");
				if(rs.getCounts()==cerTableIndex){
					ajaxData.append("{name:\"checkitemproportion\",value:\""+checkitemproportion+"\",iseditable:true,type:\"input\"}]");
				}else{
					ajaxData.append("{name:\"checkitemproportion\",value:\""+checkitemproportion+"\",iseditable:true,type:\"input\"}],");
				}
		  }
		  ajaxData.append("]");
		%>
		var ajaxdata=<%=ajaxData.toString()%>;
		var cerTableIndex = <%=cerTableIndex%>;
		var option= {
									openindex:true,
		              basictitle:"<%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%>",
		              toolbarshow:true,
		              colItems:items,
		              usesimpledata: true,
		              container:".cerTable",
		              initdatas: ajaxdata,
		              addrowCallBack:function(obj,tr,entry) {
										cerTableIndex=obj.count;
		              },
		              copyrowsCallBack:function(obj,tr,entry) {
										cerTableIndex=obj.count;
		              },
		             	configCheckBox:true,
		             	checkBoxItem:{"itemhtml":'<input name="check_lan" class="groupselectbox" type="checkbox" >',width:"5%"}
		            };
		           var group=new WeaverEditTable(option);
		           $(".cerTable").append(group.getContainer());
       </script>
	</wea:item>
	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
	 <div id="lan" class="rewardTable" style="width:100%"></div>
			<script>	
				var items=[
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>",itemhtml:"<select class=inputstyle id='typeid' name='typeid' onchange='onChangeSharetype(this)'><option value='1'><%=SystemEnv.getHtmlLabelName(15763,user.getLanguage())%></option><option value='2'><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></option><option value='3'><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option><option value='4'><%=SystemEnv.getHtmlLabelName(15764,user.getLanguage())%></option><option value='5'><%=SystemEnv.getHtmlLabelName(15765,user.getLanguage())%></option><option value='6'><%=SystemEnv.getHtmlLabelName(15766,user.getLanguage())%></option><option value='7'><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option></select>"},
				{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>",itemhtml:"<div id='div_browser_#rowIndex#' style='display:none'><span class='browser' name='resourceid' completeurl='/data.jsp' browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids=' hasinput='true' isSingle='true'></span></div>"},
				{width:"40%",colname:"<%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:30%' name='checkproportion' onKeyPress='ItemCount_KeyPress()'>%"}];
				<%
				sql = "select * from HrmCheckActor where checktypeid = "+id;  
				rs.executeSql(sql);
				StringBuffer ajaxData = new StringBuffer();
				ajaxData.append("[");
			  while(rs.next()){
	        String checkproportion = Util.null2String(rs.getString("checkproportion"));
	        String typeid = Util.null2String(rs.getString("typeid"));
	        String resourceid = Util.null2String(rs.getString("resourceid"));
	        rewardTableIndex++;
					ajaxData.append("[{name:\"typeid\",value:\""+typeid+"\",iseditable:true,type:\"select\"},");
					ajaxData.append("{name:\"resourceid\",value:\""+resourceid+"\",label:\""+Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())+"\",iseditable:true,type:\"browser\"},");
					if(rs.getCounts()==rewardTableIndex){
						ajaxData.append("{name:\"checkproportion\",value:\""+checkproportion+"\",iseditable:true,type:\"input\"}]");
					}else{
						ajaxData.append("{name:\"checkproportion\",value:\""+checkproportion+"\",iseditable:true,type:\"input\"}],");
					}
			  }
			  ajaxData.append("]");
				%>
			var ajaxdata=<%=ajaxData.toString()%>;
			var rewardTableIndex = <%=rewardTableIndex%>;
				var option= {
											openindex:true,
				              basictitle:"<%=SystemEnv.getHtmlLabelName(15662,user.getLanguage())%>",
				              toolbarshow:true,
				              colItems:items,
				              usesimpledata: true,
				              container:".rewardTable",
				              initdatas: ajaxdata,
				              addrowCallBack:function(obj,tr,entry) {
												rewardTableIndex=obj.count;
												var thisvalue = jQuery("#typeid_"+(rewardTableIndex-1)).val();
										  	if(thisvalue==7){
										 			jQuery("#div_browser_"+(rewardTableIndex-1)).show();
												}
												else{
													jQuery("#div_browser_"+(rewardTableIndex-1)).hide();
												}
				              },
				              copyrowsCallBack:function(obj,tr,entry) {
												rewardTableIndex=obj.count;
												var thisvalue = jQuery("#typeid_"+(rewardTableIndex-1)).val();
										  	if(thisvalue==7){
										 			jQuery("#div_browser_"+(rewardTableIndex-1)).show();
												}
												else{
													jQuery("#div_browser_"+(rewardTableIndex-1)).hide();
												}
				              },
				             	configCheckBox:true,
				             	checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
				            };
         	var group=new WeaverEditTable(option);
         	$(".rewardTable").append(group.getContainer());
       </script> 
	</wea:item>
 	</wea:group>
</wea:layout>  
<input class=inputstyle type=hidden name="trainrowcount" value="<%=trainTableIndex%>" >
<input class=inputstyle type=hidden name="cerrowindex" value="<%=cerTableIndex%>" >
<input class=inputstyle type=hidden name="rewardrowindex" value="<%=rewardTableIndex%>" >
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
  /**
  *Add by Huang On May 10,2004 ,
  */
  function checkNoZero() {
       var checkValue = hrmcheckkind.checkexpecd.value;
       if(parseInt(checkValue)<=0  || parseInt(checkValue)+""=="NaN") {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(17408,user.getLanguage())%>");
        return false;
       }
       return true;
  }
  function edit(){

      if(check_form(document.hrmcheckkind,'kindname,checkexpecd,checkstartdate')&&checkNoZero()){
            document.hrmcheckkind.trainrownum.value=trainTableIndex;
            document.hrmcheckkind.rewardrownum.value=rewardTableIndex;
            document.hrmcheckkind.cerrownum.value=cerTableIndex;
            document.hrmcheckkind.operation.value="EditCheckKindinfo";
            document.hrmcheckkind.submit();
    }

  }

  function onChangeSharetype(obj){
    thisvalue=obj.value;
    rewardrowindex=jQuery(obj).attr("name").split("_")[1];
  	if(thisvalue==7){
 			jQuery("#div_browser_"+rewardrowindex).show();
		}
		else{
			jQuery("#div_browser_"+rewardrowindex).hide();
		}
}

 function onDelete(){
     <%if(canDelete) {%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
		document.hrmcheckkind.operation.value="DeleteCheckKindinfo";
		document.hrmcheckkind.submit();
    }
	<%}else{%>
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%>");
		<%}%>
  }


function doBack(){
	location = "HrmCheckKindView.jsp?id=<%=id%>";
  }
</script>

<script language=vbs>
sub onShowResourceID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = "<img src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub

sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	resource.usekind.value=id(0)
	else
	usekindspan.innerHtml = ""
	resource.usekind.value=""
	end if
	end if
end sub

sub onShowSpeciality(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	inputspan.innerHtml = id(1)
	inputname.value=id(0)
	else
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowCheckID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/check/CheckItemBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowJobID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

