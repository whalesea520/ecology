<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<HTML>
<%
 String id = request.getParameter("id");     
%>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<BODY>
<FORM name=resourceworkinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<DIV>
  <BUTTON class=btnSave accessKey=E type=button onclick=edit()><U>E</U>-编辑</BUTTON>
  <!--<BUTTON class=btnSave accessKey=S type=button onclick=viewPersonalInfo()><U>S</U>-个人信息</BUTTON>-->
<BUTTON class=btnSave accessKey=B type=button onclick=back()><U>B</U>-返回</BUTTON>
 </DIV>    
<%
  String sql = "select * from HrmLanguageAbility where resourceid = "+id;  
  rs.executeSql(sql);  
%>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%" class=ListShort>
        <br>
          <COLGROUP> 
		    <COL width=30%> 
			<COL width=20%>			
			<COL width=50%>
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=5>语言能力</TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=3></TD>
          </TR>	
		  <tr class=Header>
		    <td >语言	</td>
			<td >水平</td>			
			<td >备注</td>
		  </tr> 
<%
  while(rs.next()){
    String language = Util.null2String(rs.getString("language"));
	String level = Util.null2String(rs.getString("level_n"));
	String memo = Util.null2String(rs.getString("memo"));
%>
	      <tr>
	        <TD class=Field> 
              <%=language%>
            </TD>	        
	        <TD class=Field> 
                <%if (level.equals("0")) {%><%=SystemEnv.getHtmlLabelName(154,7)%><%}%>
                <%if (level.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,7)%><%}%>
				<%if (level.equals("2")) {%><%=SystemEnv.getHtmlLabelName(822,7)%><%}%>
                <%if (level.equals("3")) {%><%=SystemEnv.getHtmlLabelName(823,7)%><%}%>
            </TD>
	        <TD class=Field> 
              <%=memo%>
            </TD>            	       
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
   </tr>
  
<%
  sql = "select * from HrmEducationInfo where resourceid = "+id;  
  rs.executeSql(sql);  
%>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%" class=ListShort>
        <br> 
          <COLGROUP> 
		    <COL width=25%> 
			<COL width=25%>
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
            <COL width=30%>
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=6>教育情况</TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=6></TD>
          </TR>	
		  <tr class=Header>
		    <td >学校名称	</td>
			<td >专业	</td>
			<td >开始日期</td>
			<td >结束日期</td>
			<td >学历</td>
			<td >详细描述</td>
		  </tr> 
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String school = Util.null2String(rs.getString("school"));
	String speciality = Util.null2String(rs.getString("speciality"));
	String educationlevel = Util.null2String(rs.getString("educationlevel"));
	String studydesc = Util.null2String(rs.getString("studydesc"));
%>
	      <tr>
	        <TD class=Field> 
              <%=school%>
            </TD>
	        <TD class=Field>	         
              <%=SpecialityComInfo.getSpecialityname(speciality)%>
            </TD>
	        <TD class=Field> 
              <%=startdate%>
            </TD>
	        <TD class=Field> 
              <%=enddate%>
            </TD>
	        <TD class=Field>
	            <%=EduLevelComInfo.getEducationLevelname(educationlevel)%>              
            </TD>
	        <TD class=Field> 
              <%=studydesc%>
            </TD>
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
   </tr>
   
   
<%
  sql = "select * from HrmWorkResume where resourceid = "+id;  
  rs.executeSql(sql);  
%>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%" class=ListShort>
        <br>
          <COLGROUP> 
		    <COL width=15%> 
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
			<COL width=35%>
            <COL width=30%>
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=6>入职前工作简历</TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=6></TD>
          </TR>	
		  <tr class=Header>
		    <td >公司名称	</td>
			<td >职务	</td>
			<td >开始日期</td>
			<td >结束日期</td>
			<td >工作描述</td>
			<td >离开原因</td>
		  </tr> 
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String leavereason = Util.null2String(rs.getString("leavereason"));
	String workdesc = Util.null2String(rs.getString("workdesc"));
%>
	      <tr>
	        <TD class=Field> 
              <%=company%>
            </TD>
	        <TD class=Field> 
              <%=jobtitle%>
            </TD>
	        <TD class=Field> 
              <%=startdate%>
            </TD>
	        <TD class=Field> 
              <%=enddate%>
            </TD>
	        <TD class=Field> 
              <%=workdesc%>
            </TD>
	        <TD class=Field> 
              <%=leavereason%>
            </TD>
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
   </tr>


<%
  sql = "select * from HrmTrainBeforeWork where resourceid = "+id;  
  rs.executeSql(sql);  
%>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%" class=ListShort>
        <br>
          <COLGROUP> 
		    <COL width=25%> 
			<COL width=10%>
			<COL width=10%>
			<COL width=20%>
			<COL width=35%>
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=5>入职前培训</TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=5></TD>
          </TR>	
		  <tr class=Header>
		    <td >培训名称	</td>
			<td >开始日期</td>
			<td >结束日期</td>
			<td >培训单位</td>
			<td >备注</td>
		  </tr> 
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("trainstartdate"));
	String enddate = Util.null2String(rs.getString("trainenddate"));
	String trainname = Util.null2String(rs.getString("trainname"));
	String trainresource = Util.null2String(rs.getString("trainresource"));	
	String trainmemo = Util.null2String(rs.getString("trainmemo"));
%>
	      <tr>
	        <TD class=Field> 
              <%=trainname%>
            </TD>	        
	        <TD class=Field> 
              <%=startdate%>
            </TD>
	        <TD class=Field> 
              <%=enddate%>
            </TD>
            <TD class=Field> 
              <%=trainresource%>
            </TD> 
	        <TD class=Field> 
              <%=trainmemo%>
            </TD>	       
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
   </tr>

<%
  sql = "select * from HrmCertification where resourceid = "+id;  
  rs.executeSql(sql);  
%>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%" class=ListShort>
        <br>
          <COLGROUP> 
		    <COL width=25%> 
			<COL width=10%>
			<COL width=10%>
			<COL width=20%>
			<COL width=35%>
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=4>资格证书</TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=5></TD>
          </TR>	
		  <tr class=Header>
		    <td >名称	</td>
			<td >开始日期</td>
			<td >结束日期</td>
			<td >颁发单位</td>			
		  </tr> 
<%
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("datefrom"));
	String enddate = Util.null2String(rs.getString("datto"));
	String cername = Util.null2String(rs.getString("certname"));
	String cerresource = Util.null2String(rs.getString("awardfrom"));	
	
%>
	      <tr>
	        <TD class=Field> 
              <%=cername%>
            </TD>	        
	        <TD class=Field> 
              <%=startdate%>
            </TD>
	        <TD class=Field> 
              <%=enddate%>
            </TD>
            <TD class=Field> 
              <%=cerresource%>
            </TD> 	    
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
   </tr>

<%
  sql = "select * from HrmRewardBeforeWork where resourceid = "+id;  
  rs.executeSql(sql);  
%>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%" class=ListShort>
        <br>
          <COLGROUP> 
		    <COL width=15%> 
			<COL width=10%>
			<COL width=10%>
			<COL width=10%>
			<COL width=35%>
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=5>入职前奖惩</TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=5></TD>
          </TR>	
		  <tr class=Header>
		    <td >奖惩名称	</td>
			<td >奖惩日期</td>			
			<td >备注</td>
		  </tr> 
<%
  while(rs.next()){
    String rewarddate = Util.null2String(rs.getString("rewarddate"));
	String rewardname = Util.null2String(rs.getString("rewardname"));
	String rewardmemo = Util.null2String(rs.getString("rewardmemo"));
%>
	      <tr>
	        <TD class=Field> 
              <%=rewardname%>
            </TD>	        
	        <TD class=Field> 
              <%=rewarddate%>
            </TD>
	        <TD class=Field> 
              <%=rewardmemo%>
            </TD>            	       
	      </tr> 
<%
  }
%>        
      </tbody>
       </table>
   </tr>

</table>
</form>
<script language=javascript>
  function edit(){    
    location = "/web/careerapply/HrmCareerApplyWorkEdit.jsp?id=<%=id%>";    
  }
  
  function viewPersonalInfo(){    
    location = "/web/careerapply/HrmCareerApplyPerView.jsp?id=<%=id%>";
  }  
  
  function back(){    
    location = "/web/careerapply/HrmCareerApplyEdit.jsp?applyid=<%=id%>";
  }  
</script> 
</BODY>
</HTML>

