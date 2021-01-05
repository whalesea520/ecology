
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.hrm.tools.HrmDateCheck" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckItemComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobComInfo" class="weaver.hrm.check.JobComInfo" scope="page" />
<HTML>
<%
      // 人力资源每日检查
	/*
	HrmDateCheck hdc = new HrmDateCheck();
	hdc.checkDate();
	*/
    String id = request.getParameter("id");
%>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6118,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCheckKindEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM name=hrmcheckkind id=hrmcheckkind action="HrmCheckOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=trainrownum>
<input class=inputstyle type=hidden name=rewardrownum>
<input class=inputstyle type=hidden name=cerrownum>

<TABLE width="100%"  class=ViewForm>
<COLGROUP> <COL width=15%> <COL width=85%>
<TBODY> 
<TR class=Title> 
<TH colSpan=2><%=SystemEnv.getHtmlLabelName(15759,user.getLanguage())%></TH>
</TR>
<TR class=Spacing style="height:2px"> 
<TD class=Line1 colSpan=2></TD>
</TR>	
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
          <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15755,user.getLanguage())%></TD>            
             <TD class=Field> 
        
      <SPAN id=kindnamespan><%=kindname%></SPAN> 
    </TD>
          </TR>	
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></TD>
    <td class=Field> 
      <select class=inputstyle name=checkcycle  disabled>
        <option value="1" <%if(checkcycle.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
        <option value="2" <%if(checkcycle.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
        <option value="3" <%if(checkcycle.equals("3")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
        <option value="4" <%if(checkcycle.equals("4")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
      </select>
    </td>
  </TR>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(15757,user.getLanguage())%></TD>
    <TD class=Field>    
      <SPAN id=checkexpecdspan><%=checkexpecd%></SPAN><%=SystemEnv.getHtmlLabelName(1925, user.getLanguage())%>
    </TD>
  </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <TR> 
          <TR>
            <TD ><%=SystemEnv.getHtmlLabelName(15758,user.getLanguage())%></TD>
            <TD class=Field>
              <SPAN id=checkstartdatespan ><%=checkstartdate%></SPAN> 
              <input class=inputstyle type="hidden" id="checkstartdate" name="checkstartdate" value=<%=checkstartdate%>>
            </TD>
          </TR>
           <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
            </tbody>
       </table>
<%
     String sql = "select * from HrmCheckPost where checktypeid = "+id;  
     rs.executeSql(sql);  
%>
        <TABLE width=100%  class=ListStyle cellspacing=1 cols=3 id="trainTable">

	      <TBODY> 
          <TR class=header> 
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(17425,user.getLanguage())%></TH>
			<Td align=right colspan=2>
			
 		    </Td>
          </TR>
          <TR class=spacing style="display:none"> 
            <TD class=Sep1 colSpan=6></TD>
          </TR>	
		  <tr class=Header>
            <td width=4% > </td>
		    <td width=20% ><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
			<td width=76% ></td>
		  </tr> 

<%
    int trainrowindex=0;
    boolean isLight = false;
    while(rs.next()){
    String jobid = Util.null2String(rs.getString("jobid"));
if(isLight)
		{%>
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
            <TD align="center" class="Field" width=20>
                <DIV>
                </DIV>
            </td>
            <TD class=Field>
                <DIV>
                
                   <input class=inputstyle type=hidden name=jobid_<%=trainrowindex%> id=jobid  value="<%=jobid%>">
                   <span id=jobidspan_<%=trainrowindex%>><%=Util.toScreen(JobComInfo.getJobName(jobid),user.getLanguage())%>
                   </span>
               </DIV>
            </TD>

            <TD class=Field width=500>

            </TD>
        </tr>
<%
        isLight = !isLight;
        trainrowindex++;
  }
%>        
      </tbody>
       </table>
<%
    sql = "select * from HrmCheckKindItem where checktypeid = "+id;  
    rs.executeSql(sql);  
%>
        <TABLE width="100%"  class=ListStyle cellspacing=1 cols=3 id="cerTable">

	      <TBODY> 
          <TR class=header> 
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></TH>
			<Td align=right colspan=3>
			
 		    </Td>
          </TR>
          <TR class=spacing style="display:none"> 
            <TD class=Sep1 colSpan=3></TD>
          </TR>	
		  <tr class=header>
            <td width=4%></td>
		    <td width=66%><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></td>
			<td width=30%><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></td>
				
		  </tr> 
<%
    isLight = false;
    int cerrowindex = 0;
    while(rs.next()){   
        String checkitemproportion = Util.null2String(rs.getString("checkitemproportion"));
        String checkitemid = Util.null2String(rs.getString("checkitemid"));
if(isLight)
		{%>
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
            <TD align="center" class=Field width=20>

            </td>
	       
	        <TD class=Field>
             
    <input class=inputstyle type=hidden name=checkitemid_<%=cerrowindex%> id=checkitemid  value="<%=checkitemid%>">
    <span id=checkitemidspan_<%=cerrowindex%>>
    <%=Util.toScreen(CheckItemComInfo.getCheckName(checkitemid),user.getLanguage())%>
    </span> 
            </TD>
	        <TD class=Field>
                <input class=inputstyle disabled="true" type=text style='width:30%' name="checkitemproportion_<%=cerrowindex%>" value="<%=checkitemproportion%>">%

        </TD>      
                 
	      </tr> 
<%
    isLight = !isLight;
	cerrowindex++;
  }
%>        
      </tbody>
       </table>

<%
    sql = "select * from HrmCheckActor where checktypeid = "+id;  
    rs.executeSql(sql);  
%>

        <TABLE width="100%"  class=ListStyle cellspacing=1 cols=4 id="rewardTable">

	      <TBODY> 
          <TR class=header> 
            <TH colspan=3><%=SystemEnv.getHtmlLabelName(15662,user.getLanguage())%></TH>
			<Td align=right colspan=1>
			
 		    </Td>
          </TR>
          <TR class=spacing style="display:none"> 
            <TD class=Sep1 colSpan=4></TD>
          </TR>	
		  <tr class=header>
            <td width=4%></td>
		    <td width=26%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
			<td width=40%><%=SystemEnv.getHtmlLabelName(15761,user.getLanguage())%></td>			
			<td width=30%><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></td>
		  </tr> 
<%
    int rewardrowindex=0;
    isLight = false;
    while(rs.next()){   
        String checkproportion = Util.null2String(rs.getString("checkproportion"));
        String typeid = Util.null2String(rs.getString("typeid"));
        String resourceid = Util.null2String(rs.getString("resourceid"));
if(isLight)
		{%>
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
            <TD align="center" class=Field width=20>
         
            </td>	        
       
	        <TD class=Field >
              <select width="100%" disabled="true" class=inputstyle name="typeid_<%=rewardrowindex%>" onchange="onChangeSharetype(<%=rewardrowindex%>)"><option value='1' <%if(typeid.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15763,user.getLanguage())%></option><option value='2' <%if(typeid.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></option><option value='3' <%if(typeid.equals("3")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option><option value='4' <%if(typeid.equals("4")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15764,user.getLanguage())%></option><option value='5' <%if(typeid.equals("5")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15765,user.getLanguage())%></option><option value='6' <%if(typeid.equals("6")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15766,user.getLanguage())%></option><option value='7' <%if(typeid.equals("7")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option></select>
            </TD>
            <TD class=Field>
              <div id="resourcediv_<%=rewardrowindex%>" <%if (!typeid.equals("7")){ %>style="display:none"<%}%>>
                 
                  <input class=inputstyle type="hidden" name="resourceid_<%=rewardrowindex%>"  id="resourceid"  value="<%=resourceid%>" disabled="true">
                  <span id="resourceidspan_<%=rewardrowindex%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span>
                      
            
                  </div>
            </TD>
        <TD class=Field>
                <input class=inputstyle type=text style='width:30%'  disabled="true" name="checkproportion_<%=rewardrowindex%>" value="<%=checkproportion%>">%

        </TD>            	       
	      </tr> 
<%
     isLight = !isLight;
	 rewardrowindex++;
  }
%>        
      </tbody>
       </table>

<input class=inputstyle type=hidden name="trainrowcount" value="<%=trainrowindex%>" >
<input class=inputstyle type=hidden name="cerrowindex" value="<%=cerrowindex%>" >
<input class=inputstyle type=hidden name="rewardrowindex" value="<%=rewardrowindex%>" >
</form>
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
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language=javascript>
 var rowColor="" ;
trainrowindex = <%=trainrowindex%>
function addtrainRow()
{
	ncol = trainTable.cols;
	oRow = trainTable.insertRow();
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_train' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Browser onclick='onShowJobID(jobidspan_"+trainrowindex+",jobid_"+trainrowindex+")'></BUTTON> <input class=inputstyle type=hidden name=jobid_"+trainrowindex+" span id=jobid_"+trainrowindex+" span value=''><span id=jobidspan_"+trainrowindex+" ></span>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            
					
		}
	}
	trainrowindex = trainrowindex*1 +1;
	
}

function deletetrainRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_train')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_train'){
			if(document.forms[0].elements[i].checked==true) {
				trainTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}
	
	}	
}	


cerrowindex = <%=cerrowindex%>
function addcerRow()
{
	ncol = cerTable.cols;
	oRow = cerTable.insertRow();
	rowColor = getRowBg();

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_cer' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:

				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Browser onclick='onShowCheckID(checkitemidspan_"+cerrowindex+",checkitemid_"+cerrowindex+")'></BUTTON> <input class=inputstyle type=hidden name=checkitemid_"+cerrowindex+" span id=checkitemid_"+cerrowindex+" span value=''><span id=checkitemidspan_"+cerrowindex+" span></span>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type=text style='width:30%' name='checkitemproportion_"+cerrowindex+"' onKeyPress='ItemCount_KeyPress()'><font size=3><b>%</font>";				
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			document.forname.cerrowindex = cerrowindex ;		    
		}
	}
	cerrowindex = cerrowindex*1 +1;
	
}

function deletecerRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cer')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cer'){
			if(document.forms[0].elements[i].checked==true) {
				cerTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

rewardrowindex = <%=rewardrowindex%>
function addrewardRow()
{
	ncol = rewardTable.cols;
	oRow = rewardTable.insertRow();
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_reward' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle name='typeid_"+rewardrowindex+"' onchange='onChangeSharetype("+rewardrowindex+")'><option value='1'><%=SystemEnv.getHtmlLabelName(15763,user.getLanguage())%></option><option value='2'><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></option><option value='3'><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option><option value='4'><%=SystemEnv.getHtmlLabelName(15764,user.getLanguage())%></option><option value='5'><%=SystemEnv.getHtmlLabelName(129238, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15765,user.getLanguage())%></option><option value='6'><%=SystemEnv.getHtmlLabelName(129239, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15766,user.getLanguage())%></option><option value='7'><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option></select>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<div id='resourcediv_"+rewardrowindex+"' style='display:none'>         <BUTTON class=Browser onclick='onShowResourceID(resourceidspan_"+rewardrowindex+",resourceid_"+rewardrowindex+")'></BUTTON> <input class=inputstyle type=hidden name=resourceid_"+rewardrowindex+" span id=resourceid_"+rewardrowindex+" span value=''><span id=resourceidspan_"+rewardrowindex+" span> </span></div>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:30%' name='checkproportion_"+rewardrowindex+"' onKeyPress='ItemCount_KeyPress()'><font size=3><b>%</font>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
           document.forname.rewardrowindex = rewardrowindex ;
		}
	}
	rewardrowindex = rewardrowindex*1 +1;

}

function deleterewardRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_reward')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_reward'){
			if(document.forms[0].elements[i].checked==true) {
				rewardTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}
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

      location = "HrmCheckKindEdit.jsp?id=<%=id%>";

  }

   function del(){
     document.hrmcheckkind.operation.value="DeleteCheckKindinfo";
	 document.hrmcheckkind.submit();
  }

  function onChangeSharetype(rewardrowindex){
    thisvalue=document.all("typeid_"+rewardrowindex).value ;

    if(thisvalue==7){
 		document.all("resourcediv_"+rewardrowindex).style.display='';
	}
	else{
		document.all("resourcediv_"+rewardrowindex).style.display='none';
	}
}

function onDelete(){
    if(isdel()){del()};
}

function doBack(){
	location = "HrmCheckKind.jsp";
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

