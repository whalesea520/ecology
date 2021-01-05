
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript" src="/js/jquery.table_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_7_wev8.js"></script>
<link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();

%>
<BODY>
<%
/*登录名冲突*/
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,7)%>
</font>
</DIV>
<%}%>

<DIV class=HdrProps></DIV>
<FORM name=resource id=resource action="HrmCareerApplyOperation.jsp" method=post>
	
	<input type=hidden name=operation value="addtwo">
<%
  String id = request.getParameter("id");  
%>	
        <input type=hidden name=id value="<%=id%>">

<DIV><BUTTON class=btnSave accessKey=S type=button onClick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(1402, 7)%>  </BUTTON> </DIV>
  <TABLE class=Form>
    <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=20%> <COL width=80%><TBODY> 
          <TR class=Section> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(411,7)%></TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(464, 7)%></TD>
            <TD class=Field>
              <BUTTON type="button" class=Calendar id=selectbirthday onclick="getbirthdayDate()"></BUTTON> 
              <SPAN id=birthdayspan ></SPAN> 
              <input type="hidden" id="birthday" name="birthday">
            </TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1886, 7)%></TD>
            <TD class=Field> 
              <INPUT class=saveHistory maxLength=30 size=30 
            name=folk>
            </TD>
          </TR>          
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1840, 7)%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=60 size=30 
            name=nativeplace>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(15683, 7)%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=60 size=30 
            name=regresidentplace>
            </td>
          </tr>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1887, 7)%></TD>
            <TD class=Field> 
              <INPUT class=saveHistory maxLength=60 size=30 
            name=certificatenum>
            </TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(469, 7)%></TD>
            <TD class=Field> 
              <SELECT class=saveHistory id=maritalstatus name=maritalstatus>
                <OPTION value=""> 
                <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(470,7)%></OPTION>
                <OPTION value=1><%=SystemEnv.getHtmlLabelName(471,7)%></OPTION>
                <OPTION value=2><%=SystemEnv.getHtmlLabelName(472, 7)%> </OPTION>
              </SELECT>
            </TD>
          </tr>
	  <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1837, 7)%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=30 size=30 name=policy>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1834, 7)%></td>
            <td class=Field>
              <button type="button" class=Calendar id=selectbememberdate onClick="getbememberdateDate()"></button> 
              <span id=bememberdatespan ></span> 
              <input type="hidden" id="bememberdate" name="bememberdate">
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1835, 7)%></td>
            <td class=Field>
              <button type="button" class=Calendar id=selectbepartydate onClick="getbepartydateDate()"></button> 
              <span id=bepartydatespan ></span> 
              <input type="hidden" id="bepartydate" name="bepartydate">
            </td>
          </tr>
	  <tr> 
            <td><%=SystemEnv.getHtmlLabelName(15684, 7)%></td>
            <td class=Field> 
              <select name=islabouunion value="1">
                <option value="1"><%=SystemEnv.getHtmlLabelName(163, 7)%></option>
                <option value="0"><%=SystemEnv.getHtmlLabelName(161, 7)%></option>                
              </select>              
            </td>
          </tr>
          <TR> 
            <td><%=SystemEnv.getHtmlLabelName(818, 7)%></td>
            <td class=Field> 
							<brow:browser viewType="0" name="educationlevel" browserValue="" 
					    browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/educationlevel/EduLevelBrowser.jsp?selectedids="
					    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					    completeUrl="/data.jsp?type=educationlevel" width="120px" browserSpanValue="">
					    </brow:browser>
            </td>
          </TR>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1833, 7)%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=30 size=30  name=degree>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1827, 7)%></td>
            <td class=Field> 
              <select class=saveHistory id=healthinfo name=healthinfo>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(824,7)%></option>
                <option value=1><%=SystemEnv.getHtmlLabelName(821,7)%></option>
                <option value=2><%=SystemEnv.getHtmlLabelName(154,7)%></option>
                <option value=3><%=SystemEnv.getHtmlLabelName(825,7)%></option>
              </select>
            </td>
          </tr>          
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1826, 7)%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=5  size=5 name=height onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("height")'>
              cm
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(129280, 7)%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=5  size=5 name=weight onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("weight")'>
              kg
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1829, 7)%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=60 size=30  name=residentplace>
            </td>
          </tr>
<!--          
          <tr> 
            <td>家庭联系方式</td>
            <td class=Field> 
              <input class=saveHistory maxlength=100 size=30 name=homeaddress>
            </td>
          </tr>
-->          
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(15685, 7)%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=60 size=30 name=tempresidentnumber>
            </td>
          </tr>          
          </TBODY> 
        </TABLE>
      </TD>      
    </TR>
    
    
    
    
      <TABLE class=Form cellpadding=1  cols=6 id="oTable">
      <input type=hidden name=rownum>	  
      <TR class=Section>
       <TH colspan=2><%=SystemEnv.getHtmlLabelName(15686, 7)%></TH>
       <Td align=right colSpan=4>
	  		<BUTTON type="button" class=btnNew accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15128, 7)%></BUTTON>
	  		<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, 7)%></BUTTON>
      </Td>       
      </TR>
    	<tr class=header>
           <td class=Field></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1943, 7)%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1944, 7)%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1914, 7)%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1915, 7)%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(110, 7)%></td>
    	</tr>
       </table>     
           	
    </TBODY> 
  </table>
  </FORM>
<script language=vbs>
sub onShowNationality()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	nationalityspan.innerHtml = id(1)
	resource.nationality.value=id(0)
	else 
	nationalityspan.innerHtml = ""
	resource.nationality.value=""
	end if
	end if
end sub

sub onShowEduLevel(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp")
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
</script> 

<script language=javascript>
function doSave() {
        document.resource.rownum.value = rowindex;
		document.resource.submit() ;
	
}
rowindex = "0";
function addRow()
{
	ncol = jQuery(oTable).find("tr:nth-child(2)").find("td").length;
	oRow = oTable.insertRow(-1);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
                        case 0:
                                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;			
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<input type=text  name='member_"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  name='title_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  name='company_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
                        case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  name='jobtitle_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		        case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  name='address_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;				
		}
	}
	rowindex = rowindex*1 +1;
	document.resource.rownum.value = rowindex;
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	} 
	
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+1);	
			}
			rowsum1 -=1;
		}	
	}	
}

function isdel(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(127574, 7)%>")){
		return true;
	}else{
		return false;
	}
}
</script>

</BODY>
<SCRIPT language="javascript"   src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/pweb/pwebJsDatetime/WdatePicker_wev8.js"></script>
</HTML>

