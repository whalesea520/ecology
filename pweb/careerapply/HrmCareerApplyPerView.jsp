
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
 int isView = Util.getIntValue(request.getParameter("isView"));    
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body>
<DIV class=HdrProps></DIV>
<FORM name=resourcepersonalinfo id=resource action="HrmCareerApplyOperation.jsp" method=post>
<DIV>
  <BUTTON class=btnSave accessKey=E type=button onclick=edit()><U>E</U>-<%=SystemEnv.getHtmlLabelName(93, 7)%></BUTTON>
<!--  <BUTTON class=btnSave accessKey=S type=button onclick=viewWorkInfo()><U>S</U>-工作信息</BUTTON>-->
  <BUTTON class=btnSave accessKey=B type=button onclick=back()><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290, 7)%></BUTTON>
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
            <TD><%=SystemEnv.getHtmlLabelName(464, 7)%></TD>
            <TD class=Field> 
              <%=birthday%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1886, 7)%></TD>
            <TD class=Field> 
              <%=folk%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1840, 7)%></TD>
            <TD class=Field> 
              <%=nativeplace%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15683, 7)%></TD>
            <TD class=Field> 
              <%=regresidentplace%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(-1359, 7)%></TD>
            <TD class=Field> 
              <%=certificatenum%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(469, 7)%></TD>
            <TD class=Field>               
                <%if(maritalstatus.equals("0")){%><%=SystemEnv.getHtmlLabelName(470, 7)%> <%}%>
                <%if(maritalstatus.equals("1")){%><%=SystemEnv.getHtmlLabelName(471, 7)%> <%}%>
                 <%if(maritalstatus.equals("2")){%><%=SystemEnv.getHtmlLabelName(472, 7)%> <%}%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1837, 7)%></TD>
            <TD class=Field> 
              <%=policy%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1834, 7)%></TD>
            <TD class=Field> 
              <%=bememberdate%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1835, 7)%></TD>
            <TD class=Field> 
              <%=bepartydate%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15684, 7)%></TD>
            <TD class=Field>
              <%if(islabouunion.equals("1")){%><%=SystemEnv.getHtmlLabelName(163, 7)%><%}%> 
              <%if(islabouunion.equals("0")){%><%=SystemEnv.getHtmlLabelName(161, 7)%><%}%>                             
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(818, 7)%></TD>
            <TD class=Field>
              <%=EduLevelComInfo.getEducationLevelname(educationlevel)%>                         
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1833, 7)%></TD>
            <TD class=Field> 
              <%=degree%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1827, 7)%></TD>
            <TD class=Field> 
              <%if(healthinfo.equals("0")){%><%=SystemEnv.getHtmlLabelName(824, 7)%><%}%>
              <%if(healthinfo.equals("1")){%><%=SystemEnv.getHtmlLabelName(821, 7)%><%}%>
              <%if(healthinfo.equals("2")){%><%=SystemEnv.getHtmlLabelName(154, 7)%><%}%>
              <%if(healthinfo.equals("3")){%><%=SystemEnv.getHtmlLabelName(825,7)%><%}%>              
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(-947, 7)%></TD>
            <TD class=Field> 
              <%=trimZero(height)%>
            </TD>
          </TR>
       	  <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(129280, 7)%></TD>
            <TD class=Field> 
              <%=trimZero(weight)%>
            </TD>
          </TR>
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1829, 7)%></TD>
            <TD class=Field> 
              <%=residentplace%>
            </TD>
          </TR>
<!--	      <TR> 
            <TD>家庭联系方式</TD>
            <TD class=Field> 
              <%=homeaddress%>
            </TD>
          </TR>
-->          
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15685, 7)%></TD>
            <TD class=Field> 
              <%=tempresidentnumber%>
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
        <TABLE width="100%" class=ListShort>
          <COLGROUP> 
		    <COL width=15%> 
			<COL width=10%>
			<COL width=30%>
			<COL width=15%>
			<COL width=30%>
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(814, 7)%></TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=5></TD>
          </TR>	
		  <tr class=header>
		    <td><%=SystemEnv.getHtmlLabelName(431, 7)%>	</td>
			<td><%=SystemEnv.getHtmlLabelName(1944, 7)%>	</td>
			<td><%=SystemEnv.getHtmlLabelName(1914, 7)%></td>
			<td><%=SystemEnv.getHtmlLabelName(1915, 7)%></td>
			<td><%=SystemEnv.getHtmlLabelName(110, 7)%>	</td>
		  </tr>
<%
  while(rs.next()){
    String member = Util.null2String(rs.getString("member"));
	String title = Util.null2String(rs.getString("title"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String address = Util.null2String(rs.getString("address"));
%>
	      <tr>
	        <TD class=Field> 
              <%=member%>
            </TD>
	        <TD class=Field> 
              <%=title%>
            </TD>
	        <TD class=Field> 
              <%=company%>
            </TD>
	        <TD class=Field> 
              <%=jobtitle%>
            </TD>
	        <TD class=Field> 
              <%=address%>
            </TD>
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
   </tr>
	
   </tbody>
</table>
</form>
 <script language=javascript>
  function edit(){ 
    location = "/pweb/careerapply/HrmCareerApplyPerEdit.jsp?id=<%=id%>";
  }
  function viewWorkInfo(){    
    location = "/pweb/careerapply/HrmCareerApplyWorkView.jsp?id=<%=id%>";
  }  
  function back(){    
    location = "/pweb/careerapply/HrmCareerApplyEdit.jsp?applyid=<%=id%>";
  }  
</script> 
</body>
</html>