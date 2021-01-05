<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<html>
<%
 String id = request.getParameter("id");    
 int isView = Util.getIntValue(request.getParameter("isView"));    
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body>
<FORM name=resourcepersonalinfo id=resource action="HrmCareerApplyOperation.jsp" method=post>
<DIV>
  <BUTTON class=btnSave accessKey=E type=button onclick=edit()><U>E</U>-编辑</BUTTON>
<!--  <BUTTON class=btnSave accessKey=S type=button onclick=viewWorkInfo()><U>S</U>-工作信息</BUTTON>-->
  <BUTTON class=btnSave accessKey=B type=button onclick=back()><U>B</U>-返回</BUTTON>
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
            <TD>出生日期</TD>
            <TD class=Field> 
              <%=birthday%>
            </TD>
          </TR>
	      <TR> 
            <TD>民族</TD>
            <TD class=Field> 
              <%=folk%>
            </TD>
          </TR>
	      <TR> 
            <TD>籍贯</TD>
            <TD class=Field> 
              <%=nativeplace%>
            </TD>
          </TR>
	      <TR> 
            <TD>户口</TD>
            <TD class=Field> 
              <%=regresidentplace%>
            </TD>
          </TR>
	      <TR> 
            <TD>身份证号</TD>
            <TD class=Field> 
              <%=certificatenum%>
            </TD>
          </TR>
	      <TR> 
            <TD>婚姻状况</TD>
            <TD class=Field>               
                <%if(maritalstatus.equals("0")){%>未婚 <%}%>
                <%if(maritalstatus.equals("1")){%>已婚 <%}%>
                 <%if(maritalstatus.equals("2")){%>离异 <%}%>
            </TD>
          </TR>
	      <TR> 
            <TD>政治面貌</TD>
            <TD class=Field> 
              <%=policy%>
            </TD>
          </TR>
	      <TR> 
            <TD>入团日期</TD>
            <TD class=Field> 
              <%=bememberdate%>
            </TD>
          </TR>
	      <TR> 
            <TD>入党日期</TD>
            <TD class=Field> 
              <%=bepartydate%>
            </TD>
          </TR>
	      <TR> 
            <TD>工会会员</TD>
            <TD class=Field>
              <%if(islabouunion.equals("1")){%>是<%}%> 
              <%if(islabouunion.equals("0")){%>否<%}%>                             
            </TD>
          </TR>
	      <TR> 
            <TD>学历</TD>
            <TD class=Field>
              <%=EduLevelComInfo.getEducationLevelname(educationlevel)%>                         
            </TD>
          </TR>
	      <TR> 
            <TD>学位</TD>
            <TD class=Field> 
              <%=degree%>
            </TD>
          </TR>
	      <TR> 
            <TD>健康状况</TD>
            <TD class=Field> 
              <%if(healthinfo.equals("0")){%>优秀<%}%>
              <%if(healthinfo.equals("1")){%>良好<%}%>
              <%if(healthinfo.equals("2")){%>一般<%}%>
              <%if(healthinfo.equals("3")){%><%=SystemEnv.getHtmlLabelName(825,7)%><%}%>              
            </TD>
          </TR>
	      <TR> 
            <TD>身高</TD>
            <TD class=Field> 
              <%=height%>
            </TD>
          </TR>
       	  <TR> 
            <TD>体重</TD>
            <TD class=Field> 
              <%=weight%>
            </TD>
          </TR>
	      <TR> 
            <TD>现居住地</TD>
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
            <TD>暂住证号码</TD>
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
            <TH colSpan=5>家庭情况</TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=5></TD>
          </TR>	
		  <tr class=header>
		    <td>成员	</td>
			<td>称谓	</td>
			<td>工作单位</td>
			<td>职务</td>
			<td>地址	</td>
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
    location = "/web/careerapply/HrmCareerApplyPerEdit.jsp?id=<%=id%>";
  }
  function viewWorkInfo(){    
    location = "/web/careerapply/HrmCareerApplyWorkView.jsp?id=<%=id%>";
  }  
  function back(){    
    location = "/web/careerapply/HrmCareerApplyEdit.jsp?applyid=<%=id%>";
  }  
</script> 
</body>
</html>