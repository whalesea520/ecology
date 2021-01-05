
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var parentDialog = parent.parent.getDialog(parent);
	function pop_numCheck(objectname){
		 objValue=objectname.value;
		 valuechar = objectname.value.split("") ;
		isnumber = false ;
		for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
		if(isnumber||objValue==0) objectname.value = "" ;
	} 
</script>
<%
   boolean canSetDocPopUp = HrmUserVarify.checkUserRight("Docs:SetPopUp", user);
   if(!canSetDocPopUp){
    response.sendRedirect("/notice/noright.jsp");
    return ;
   }

   String docsid = Util.null2String(request.getParameter("docsid"));
   String operate = Util.null2String(request.getParameter("operate"));
   String isShowPop = "0";
   String sqlstr = "";
   String[] docsidArr = docsid.split(",");
   
   String startDate = Util.null2String(request.getParameter("startDate"));
   String endDate = Util.null2String(request.getParameter("endDate"));
   String pop_num = Util.null2String(request.getParameter("pop_num"));
   String pop_hight = Util.null2String(request.getParameter("pop_hight"));
   String pop_width = Util.null2String(request.getParameter("pop_width"));
   String pop_type = Util.null2String(request.getParameter("pop_type"));
   if("save".equals(operate)){
   	  for(int i=0;i<docsidArr.length;i++){
	      sqlstr = "insert into DocPopUpInfo(docid,pop_startdate,pop_enddate,pop_num,pop_hight,pop_width,is_popnum,pop_type) values ("+docsid+",'"+startDate+"','"+endDate+"','"+pop_num+"','"+pop_hight+"','"+pop_width+"',0,'"+pop_type+"')";
          RecordSet.executeSql(sqlstr);
	   }
   }
   if("update".equals(operate)){
     sqlstr = "update DocPopUpInfo set pop_startdate = '"+startDate+"',pop_enddate = '"+endDate+"',pop_num = '"+pop_num+"',pop_hight = '"+pop_hight+"',pop_width ='"+pop_width+"',pop_type='"+pop_type+"' where docid = "+docsid;
     RecordSet.executeSql(sqlstr);
   }
   //System.out.println("operate::"+operate+"::docsid::"+docsid);
   if("delete".equals(operate)){
     RecordSet.executeSql("delete from DocPopUpInfo where docid in( "+docsid+")");
	  RecordSet.executeSql("delete from DocPopUpUser where docid = "+docsid); //
   }
    if(!"".equals(operate)){
   		%>
	     <script>
	     		parent._table.reLoad();
	     </script>
     	<%
     	return;
   }
   
   if(docsidArr.length==1){
	   RecordSet.executeSql("select * from DocPopUpInfo where docid = "+docsid);
	   if(RecordSet.next()){
	     startDate = RecordSet.getString("pop_startdate");
	     endDate = RecordSet.getString("pop_enddate");
	     pop_num = RecordSet.getString("pop_num");
	     pop_hight = RecordSet.getString("pop_hight");
	     pop_width = RecordSet.getString("pop_width");
		 pop_type=RecordSet.getString("pop_type");
	     isShowPop = "1";
	   }
	}

%>

<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "";
	String needfav = "";
	String needhelp = "";
%>
<html>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<FORM id=weaver name=weaver action="PopUpDocSet.jsp" method=post>
<input type=hidden name="operate" id="operate">
<input type=hidden name="docsid" id="docsid" value="<%=docsid %>">
	
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21879,user.getLanguage())%></wea:item>
		<wea:item attributes="{'colspan':'full'}">
			<input class="inputStyle" type="checkbox" tzCheckbox="true"  id="isShow_id"	name="isShow_id" value="1" <%if("1".equals(isShowPop)) out.println("checked"); %> onclick="showOrHidenFun(this)">
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<%String attributes="{'isTableList':'true','colspan':'full','samePair':'showDiv_id','display':'\"+(\"1\".equals(isShowPop)?\"\":\"none\")+\"'}";%>
		<wea:item attributes='<%=attributes%>'>
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(19798,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="startDateSpan" required='<%=!"1".equals(isShowPop)%>' value="<%=startDate%>" isOutValue="true">
							<BUTTON class=Calendar type="button" onclick="getPfStartDate()"></BUTTON> 
						</wea:required>
						&nbsp;- &nbsp;
						<wea:required id="endDateSpan" required='<%=!"1".equals(isShowPop)%>' value="<%=endDate%>" isOutValue="true">
							<BUTTON class=Calendar type="button" onclick="getPfEndDate()"></BUTTON> 
						 </wea:required>
						 <input class=InputStyle  type="hidden" id="startDate" name="startDate" value="<%=startDate%>">
						 <input class=InputStyle  type="hidden" id="endDate" name="endDate" value="<%=endDate%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(21881,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descimage" required='<%=!"1".equals(isShowPop)%>' >
						<select name="pop_type" style="width:63px">
						                    <option value=1 <%if(pop_type.equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(33218,user.getLanguage())%></option>
						                    <option value=2 <%if(pop_type.equals("2")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(33216,user.getLanguage())%></option>
									   </select>

							<INPUT style="width:50px;" class=InputStyle id="pop_num" name="pop_num" type="text" value="<%=pop_num%>"  onBlur='pop_numCheck($GetEle("pop_num"));checkinput("pop_num","descimage")' onchange='checkinput("pop_num","descimage")'>
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(21882,user.getLanguage())%></wea:item>
					<wea:item><input  style="width:50px;"class=InputStyle  type="text" id="pop_hight" name="pop_hight" onBlur='checknumber("pop_hight")' value='<%=pop_hight%>'><span>px</span>
						<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(33446,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(21884,user.getLanguage())%></wea:item>
					<wea:item><input style="width:50px;" class=InputStyle  type="text" id="pop_width" name="pop_width" onBlur='checknumber("pop_width")' value='<%=pop_width%>'><span>px</span>
						<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(33445,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</body>
<script type='text/javascript'>
  var delFlag = 0;
  
  jQuery(document).ready(function(){
		if(!jQuery("#isShow_id").attr("checked")){
			delFlag = 1;
		}
		jQuery(".e8tips").wTooltip({html:true});
	});
  
  function showOrHidenFun(obj){
     //var showtemp = document.getElementById('isShow_id').value;
     var checked = jQuery(obj).attr("checked");
     if(checked){
       delFlag = 0;
       //document.getElementById('showDiv_id').style.display = "";
	   showEle("showDiv_id");
     }else{  
	   delFlag = 1;
       //document.getElementById('showDiv_id').style.display = "none";
	   hideEle("showDiv_id");
     }
  }
  
  function doSave(obj){
     var showflag = <%=isShowPop%>;
     if(showflag == 1 && delFlag == 1){  	
        document.getElementById('startDate').value = "";
	    document.getElementById('endDate').value = "";
	    document.getElementById('pop_num').value = "";
	    document.getElementById('pop_hight').value = "";
	    document.getElementById('pop_width').value = ""; 
	    document.getElementById('startDateSpan').innerHTML = "";
	    document.getElementById('endDateSpan').innerHTML = "";
      	weaver.operate.value="delete";
      	//weaver.docsid.value=<%=docsid%>;
        //document.weaver.submit();
        obj.disabled=true;
	    //obj.hide();
	    jQuery("#weaver").ajaxSubmit({
	      	type: 'post', 
	      	url: 'PopUpDocSet.jsp',
	      	success:function(data){
	      		 parentWin._table.reLoad();
	      		 parentWin.closeDialog();
	      	},
	      	error:function(XmlHttpRequest, textStatus, errorThrown){
	      		alert("error");
	      	}
	      });  
     }else{
	   if(!document.getElementById('isShow_id').checked){
	   		weaver.operate.value="delete";
		   jQuery("#weaver").ajaxSubmit({
	      	type: 'post', 
	      	url: 'PopUpDocSet.jsp',
	      	success:function(data){
	      		 parentWin._table.reLoad();
	      		 parentWin.closeDialog();
	      	},
	      	error:function(XmlHttpRequest, textStatus, errorThrown){
	      		alert("error");
	      	}
	      });
		 	return false;  
	    }
	    if(check_form(weaver,'startDate,endDate,pop_num')){
	      if(showflag == 1){
	        weaver.operate.value="update";
	      }else{
	        weaver.operate.value="save";
	      }
	      jQuery("#weaver").ajaxSubmit({
	      	type: 'post', 
	      	url: 'PopUpDocSet.jsp',
	      	success:function(data){
	      		 parentWin._table.reLoad();
	      		 parentWin.closeDialog();
	      	},
	      	error:function(XmlHttpRequest, textStatus, errorThrown){
	      		alert("error");
	      	}
	      });  
	   }
     }
  }
</script>
<SCRIPT language="javascript"  src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
</html>
