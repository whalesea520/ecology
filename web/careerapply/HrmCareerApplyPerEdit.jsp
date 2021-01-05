<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<html>
<%
String id = request.getParameter("id"); 
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/web/css/style_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<FORM name=resourcepersonalinfo id=resource action="HrmCareerApplyOperation.jsp" method=post>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<DIV>

  <BUTTON class=btnSave accessKey=E type=button onclick=edit()><U>E</U>-保存</BUTTON>
  <BUTTON class=btn accessKey=B type=button onclick="location.href='HrmCareerApplyPerView.jsp?id=<%=id%>'"><U>B</U>-返回</BUTTON>
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
            <TH colSpan=2>个人信息</TH>
          </TR>
          <TR class=Separator> 
            <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colSpan=2></TD>
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
            <TD >出生日期</TD>
            <TD bgcolor="F6F6F6">
              <BUTTON class=Calendar id=selectbirthday onclick="getbirthdayDate()"></BUTTON> 
              <SPAN id=birthdayspan ><%=birthday%>
              </SPAN> 
              <input type="hidden" name="birthday" value="<%=birthday%>">                            
            </TD>
          </TR>
	      <TR> 
            <TD >民族</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=folk value="<%=folk%>" class=stedit>
            </TD>
          </TR>
	      <TR> 
            <TD >籍贯</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=nativeplace value="<%=nativeplace%>" class=stedit>
            </TD>
          </TR>
	      <TR> 
            <TD >户口</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=regresidentplace value="<%=regresidentplace%>" class=stedit>
            </TD>
          </TR>
	      <TR> 
            <TD >身份证号</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=certificatenum value="<%=certificatenum%>" class=stedit>
            </TD>
          </TR>
	      <TR> 
            <TD >婚姻状况</TD>
            <TD bgcolor="F6F6F6"> 
              <select name=maritalstatus value="<%=maritalstatus%>">
                <option value="0" <%if(maritalstatus.equals("0")){%> selected <%}%>>未婚</option>
                <option value="1" <%if(maritalstatus.equals("1")){%> selected <%}%>>已婚</option>
                <option value="2" <%if(maritalstatus.equals("2")){%> selected <%}%>>离异 </option>
              </select>
            </TD>
          </TR>
	      <TR> 
            <TD >政治面貌</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=policy value="<%=policy%>" class=stedit>
            </TD>
          </TR>
	      <TR> 
            <TD >入团日期</TD>
            <TD bgcolor="F6F6F6">
              <button class=Calendar id=selectbememberdate onClick="getbememberdateDate()"></button> 
              <span id=bememberdatespan ><%=bememberdate%></span> 
              <input type="hidden" name="bememberdate" value="<%=bememberdate%>">               
            </TD>
          </TR>
	      <TR> 
            <TD >入党日期</TD>
            <TD bgcolor="F6F6F6">
              <button class=Calendar id=selectbepartydate onClick="getbepartydateDate()"></button> 
              <span id=bepartydatespan ><%=bepartydate%></span> 
              <input type="hidden" name="bepartydate" value="<%=bepartydate%>">               
            </TD>
          </TR>
	      <TR> 
            <TD >工会会员</TD>
            <TD bgcolor="F6F6F6">
              <select class=stedit id=islabouunion name=islabouunion value="<%=islabouunion%>">
                <option value=1 <%if(islabouunion.equals("1")){%> selected <%}%>>是</option>
                <option value=0 <%if(islabouunion.equals("0")){%> selected <%}%>>否</option>                
              </select>               
            </TD>
          </TR>
	      <TR> 
            <TD >学历</TD>
            <TD bgcolor="F6F6F6">
              <BUTTON class=Browser name="btneducationlevel"  onclick="onShowEduLevel(educationlevelspan,educationlevel)"> </BUTTON>
              <SPAN id=educationlevelspan><%=EduLevelComInfo.getEducationLevelname(educationlevel)%></SPAN>
              <INPUT type=hidden name=educationlevel value="<%=educationlevel%>">              
            </TD>
          </TR>
	      <TR> 
            <TD >学位</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=degree value="<%=degree%>" class=stedit>
            </TD>
          </TR>
	      <TR> 
            <TD >健康状况</TD>
            <TD bgcolor="F6F6F6">
              <select class=stedit id=healthinfo name=healthinfo value="<%=healthinfo%>">
                <option value=0 <%if(healthinfo.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(824,7)%></option>
                <option value=1 <%if(healthinfo.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(821,7)%></option>
                <option value=2 <%if(healthinfo.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(154,7)%></option>
                <option value=3 <%if(healthinfo.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(825,7)%></option>
              </select>               
            </TD>
          </TR>
	      <TR> 
            <TD >身高</TD>
            <TD bgcolor="F6F6F6">
              <input class=stedit maxlength=3  size=5 name=height value="<%=height%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("height")'>               
              cm
            </TD>
          </TR>
       	  <TR> 
            <TD >体重</TD>
            <TD bgcolor="F6F6F6">
              <input class=stedit maxlength=3  size=5 name=weight value="<%=weight%>"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("weight")'>                
              kg
            </TD>
          </TR>
	      <TR> 
            <TD >现居住地</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=residentplace value="<%=residentplace%>" class=stedit>
            </TD>
          </TR>
<!--	      <TR> 
            <TD >家庭联系方式</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=homeaddress value="<%=homeaddress%>">
            </TD>
          </TR>
-->          
	      <TR> 
            <TD >暂住证号码</TD>
            <TD bgcolor="F6F6F6"> 
              <input type=text name=tempresidentnumber value="<%=tempresidentnumber%>" class=stedit>
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
        <TABLE width="100%" cols=6 id="oTable" class=ListShort cellpadding=1>
          <COLGROUP> 
   		    <COL width=3%> 
		    <COL width=12%> 
			<COL width=10%>
			<COL width=30%>
			<COL width=15%>
			<COL width=30%>
	      <TBODY>
		  <input type=hidden name=rownum>	  
          <TR class=Section> 
            <TH colspan=2>家庭情况</TH>
	    <Td align=right colspan=4>
	    <BUTTON class=btnNew accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
	    <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow1()};"><U>D</U>-删除</BUTTON>  	    
           </Td>
          </TR>
          <TR class=Separator> 
            <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colSpan=6></TD>
          </TR>	
		  <tr class=Header>
            <td bgcolor="F6F6F6"></td>
		    <td bgcolor="F6F6F6">成员	</td>
			<td bgcolor="F6F6F6">称谓	</td>
			<td bgcolor="F6F6F6">工作单位</td>
			<td bgcolor="F6F6F6">职务</td>
			<td bgcolor="F6F6F6">地址	</td>
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
	        <TD bgcolor="F6F6F6"> 
              <input type=text  name="member_<%=rownum%>" value="<%=member%>">
            </TD>
	        <TD bgcolor="F6F6F6"> 
              <input type=text  name="title_<%=rownum%>" value="<%=title%>">
            </TD>
	        <TD bgcolor="F6F6F6"> 
              <input type=text  name="company_<%=rownum%>" value="<%=company%>">
            </TD>
	        <TD bgcolor="F6F6F6"> 
              <input type=text  name="jobtitle_<%=rownum%>" value="<%=jobtitle%>">
            </TD>
	        <TD bgcolor="F6F6F6"> 
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
  function edit(){ 
    document.resourcepersonalinfo.operation.value="editper";
    document.resourcepersonalinfo.rownum.value=rowindex;
	document.resourcepersonalinfo.submit();
  }  

rowindex = <%=rownum%>;
function addRow()
{
	ncol = oTable.cols;
	oRow = oTable.insertRow();
	
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
				var sHtml =  "<input type=text class=stedit name='member_"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class=stedit name='title_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class=stedit name='company_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class=stedit name='jobtitle_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		    case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class=stedit name='address_"+rowindex+"'>";
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
				oTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}	
	}	
}

function isdel(){
   if(!confirm("确定要删除吗？")){
       return false;
   }
       return true;
   } 
</script> 
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>