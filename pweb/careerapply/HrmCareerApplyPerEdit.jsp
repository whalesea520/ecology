
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<html>
<%!
    /**
     * Add by Charoes ,remove the zero behind a Two Digit precision Decimal .
     * @param s
     * @return
     */
    private String trimZero(String s){
        int index = s.indexOf(".");
        if(index !=-1){
            String temp = s.substring(index+1);
            if(temp.equals("00"))
                s = s.substring(0,index);
            else{
                if(temp.substring(temp.length()-1).equals("0") ){
                    s = s.substring(0,s.length()-1)      ;
                }
            }
        }
        return s;
    }

%>
<%
String id = request.getParameter("id"); 
%>
<head>
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
</head>
<body>
<DIV class=HdrProps></DIV>
<FORM name=resourcepersonalinfo id=resource action="HrmCareerApplyOperation.jsp" method=post>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<DIV>

  <BUTTON class=btnSave accessKey=E type=button onclick=edit()><U>E</U>-<%=SystemEnv.getHtmlLabelName(86, 7)%></BUTTON>
  <BUTTON class=btnSave accessKey=B type=button onclick="location.href='HrmCareerApplyPerView.jsp?id=<%=id%>'"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290, 7)%></BUTTON>
 </DIV>
 <TABLE class=Form>
    <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> 
	<TBODY> 
    <TR> 
      <TD vAlign=top>
      <TABLE width="100%">
          <COLGROUP> <COL width=20%> <COL width=80%>
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15687, 7)%></TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=2></TD>
          </TR>	  
 <%
  String sql = "";
  sql = "select * from HrmCareerApply where id = "+id;  
  rs.executeSql(sql);
  while(rs.next()){
    String birthday = Util.null2String(rs.getString("birthday"));
    String folk = Util.null2String(rs.getString("folk"));
    String nativeplace = Util.null2String(rs.getString("nativeplace"));
    String regresidentplace = Util.null2String(rs.getString("regresidentplace"));
    String certificatenum = Util.null2String(rs.getString("certificatenum"));    
    String maritalstatus = Util.null2String(rs.getString("maritalstatus"));
    String policy = Util.null2String(rs.getString("policy"));
    String bememberdate = Util.null2String(rs.getString("bememberdate"));
    String bepartydate = Util.null2String(rs.getString("bepartydate"));
    String islabouunion = Util.null2String(rs.getString("islabouunion"));
    String educationlevel = Util.null2String(rs.getString("educationlevel"));
    String degree = Util.null2String(rs.getString("degree"));
    String healthinfo = Util.null2String(rs.getString("healthinfo"));
    String height = Util.null2String(rs.getString("height"));
    String weight = Util.null2String(rs.getString("weight"));
    String residentplace = Util.null2String(rs.getString("residentplace"));
    String homeaddress = Util.null2String(rs.getString("homeaddress"));
    String tempresidentnumber = Util.null2String(rs.getString("tempresidentnumber"));    
%>        
	 <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(464, 7)%></TD>
            <TD class=Field>
              <BUTTON class=Calendar type="button" id=selectbirthday onclick="getbirthdayDate()"></BUTTON> 
              <SPAN id=birthdayspan ><%=birthday%></SPAN> 
              <input type="hidden" id="birthday" name="birthday" value="<%=birthday%>">                            
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1886, 7)%></TD>
            <TD class=Field> 
              <input type=text name=folk value="<%=folk%>">
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1840, 7)%></TD>
            <TD class=Field> 
              <input type=text name=nativeplace value="<%=nativeplace%>">
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15683, 7)%></TD>
            <TD class=Field> 
              <input type=text name=regresidentplace value="<%=regresidentplace%>">
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1887, 7)%></TD>
            <TD class=Field> 
              <input type=text name=certificatenum value="<%=certificatenum%>">
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(469, 7)%></TD>
            <TD class=Field> 
              <select name=maritalstatus value="<%=maritalstatus%>">
                <option value="0" <%if(maritalstatus.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(470, 7)%></option>
                <option value="1" <%if(maritalstatus.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(471, 7)%></option>
                <option value="2" <%if(maritalstatus.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(472, 7)%> </option>
              </select>
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1837, 7)%></TD>
            <TD class=Field> 
              <input type=text name=policy value="<%=policy%>">
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1834, 7)%></TD>
            <TD class=Field>
              <button class=Calendar type="button" id=selectbememberdate onClick="getbememberdateDate()"></button> 
              <span id=bememberdatespan ><%=bememberdate%></span> 
              <input type="hidden" id="bememberdate" name="bememberdate" value="<%=bememberdate%>">               
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1835, 7)%></TD>
            <TD class=Field>
              <button class=Calendar type="button" id=selectbepartydate onClick="getbepartydateDate()"></button> 
              <span id=bepartydatespan ><%=bepartydate%></span> 
              <input type="hidden" id="bepartydate" name="bepartydate" value="<%=bepartydate%>">               
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15684, 7)%></TD>
            <TD class=Field>
              <select class=saveHistory id=islabouunion name=islabouunion value="<%=islabouunion%>">
                <option value=1 <%if(islabouunion.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(163, 7)%></option>
                <option value=0 <%if(islabouunion.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(161, 7)%></option>                
              </select>               
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(818, 7)%></TD>
            <TD class=Field>
              <BUTTON class=Browser type=button name="btneducationlevel"  onclick="onShowEduLevel(educationlevelspan,educationlevel)"> </BUTTON>
              <SPAN id=educationlevelspan><%=EduLevelComInfo.getEducationLevelname(educationlevel)%></SPAN>
              <INPUT type=hidden name=educationlevel value="<%=educationlevel%>">              
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1833, 7)%></TD>
            <TD class=Field> 
              <input type=text name=degree value="<%=degree%>">
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1827, 7)%></TD>
            <TD class=Field>
              <select class=saveHistory id=healthinfo name=healthinfo value="<%=healthinfo%>">
                <option value=0 <%if(healthinfo.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(824,7)%></option>
                <option value=1 <%if(healthinfo.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(821,7)%></option>
                <option value=2 <%if(healthinfo.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(154,7)%></option>
                <option value=3 <%if(healthinfo.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(825,7)%></option>
              </select>               
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(-947, 7)%></TD>
            <TD class=Field>
              <input class=saveHistory maxlength=5  size=5 name=height value="<%=trimZero(height)%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("height")'>
              cm
            </TD>
          </TR>
       	  <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(129280, 7)%></TD>
            <TD class=Field>
              <input class=saveHistory maxlength=5  size=5 name=weight value="<%=trimZero(weight)%>"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("weight")'>
              kg
            </TD>
          </TR>
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(1829, 7)%></TD>
            <TD class=Field> 
              <input type=text name=residentplace value="<%=residentplace%>">
            </TD>
          </TR>
<!--	      <TR> 
            <TD >家庭联系方式</TD>
            <TD class=Field> 
              <input type=text name=homeaddress value="<%=homeaddress%>">
            </TD>
          </TR>
-->          
	      <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15685, 7)%></TD>
            <TD class=Field> 
              <input type=text name=tempresidentnumber value="<%=tempresidentnumber%>">
            </TD>
          </TR>
<%
  }
%>        

 	      </tbody>
       </table>
   </tr>

 
<%
  sql = "select * from HrmFamilyInfo where resourceid = "+id;  
  rs.executeSql(sql);  
%>
	<TR> 
      <TD vAlign=top> 
        <TABLE width="100%" cols=6 id="oTable" class=ListShort>
          <COLGROUP> 
   		    <COL width=3%> 
		    <COL width=12%> 
			<COL width=10%>
			<COL width=30%>
			<COL width=15%>
			<COL width=30%>
	      <TBODY>
		  <input type=hidden id=rownum name=rownum>	  
          <TR class=Section> 
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(814, 7)%></TH>
	    <Td align=right colspan=4>
	    <BUTTON class=btnNew type=button accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
	    <BUTTON class=btnDelete type=button accessKey=D onClick="javascript:if(isdel()){deleteRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, 7)%></BUTTON>  	    
           </Td>
          </TR>
		  <tr class=Header>
            <td ></td>
		    <td ><%=SystemEnv.getHtmlLabelName(431, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1944, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1914, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1915, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(110, 7)%>	</td>
		  </tr>
<%
  int rownum = 0;
  while(rs.next()){
    String member = Util.null2String(rs.getString("member"));
	String title = Util.null2String(rs.getString("title"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String address = Util.null2String(rs.getString("address"));
%>
	      <tr>
            <td>
             <input type='checkbox' name='check_node' value='0'>
           </td>
	        <TD class=Field> 
              <input type=text  name="member_<%=rownum%>" value="<%=member%>">
            </TD>
	        <TD class=Field> 
              <input type=text  name="title_<%=rownum%>" value="<%=title%>">
            </TD>
	        <TD class=Field> 
              <input type=text  name="company_<%=rownum%>" value="<%=company%>">
            </TD>
	        <TD class=Field> 
              <input type=text  name="jobtitle_<%=rownum%>" value="<%=jobtitle%>">
            </TD>
	        <TD class=Field> 
              <input type=text  name="address_<%=rownum%>" value="<%=address%>">
            </TD>
	      </tr> 
<%
	rownum++;
  }
%>        
      </tbody>
       </table>
   </tr>
	
   </tbody>
</table>
</form>
 <script language=vbs>
sub onShowEduLevelbak(inputspan,inputname)
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
  function edit(){ 
    document.resourcepersonalinfo.operation.value="editper";
    document.resourcepersonalinfo.rownum.value=rowindex;
	document.resourcepersonalinfo.submit();
  }  

rowindex = <%=rownum%>;
function addRow()
{
	ncol = jQuery(oTable).find("tr:nth-child(3)").find("td").length;
	oRow = oTable.insertRow(-1);
	alert(ncol);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
            case 0:
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
	document.resourcepersonalinfo.rownum.value = rowindex;
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
</body>
<SCRIPT language="javascript"  src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/pweb/pwebJsDatetime/WdatePicker_wev8.js"></script>
</html>
