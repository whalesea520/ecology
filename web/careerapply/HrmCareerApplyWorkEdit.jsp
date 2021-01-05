<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
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
<FORM name=resourceworkedit id=resource action="HrmCareerApplyOperation.jsp" method=post>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=lanrownum>
<input type=hidden name=workrownum>
<input type=hidden name=edurownum>
<input type=hidden name=trainrownum>
<input type=hidden name=rewardrownum>
<input type=hidden name=cerrownum>
<DIV>
  <BUTTON class=btnSave accessKey=E type=button onclick=edit()><U>E</U>-保存</BUTTON>
<BUTTON class=btn accessKey=B type=button onclick="location.href='HrmCareerApplyWorkView.jsp?id=<%=id%>'"><U>B</U>-返回</BUTTON>  
 </DIV>

<%
  String sql = "select * from HrmLanguageAbility where resourceid = "+id;  
  rs.executeSql(sql);  
%>
 
        <TABLE width="100%"  class=ListShort cols=4 id=lanTable>

	      <TBODY> 
          <TR class=Section> 
            <TH colspan=3>语言能力</TH>			
			<Td align=right colspan=1>
			<BUTTON class=btnNew accessKey=A onClick="addlanRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			<BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deletelanRow1()};"><U>D</U>-删除</BUTTON>			 
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=4></TD>
          </TR>	
		  <tr class=Header>
            <td >&nbsp</td> 		    
			<td >语言	</td>
			<td >水平</td>
			<td >备注</td>
		  </tr> 
<%
  int lanrowindex=0;
  while(rs.next()){   
	String language = Util.null2String(rs.getString("language"));
	String level = Util.null2String(rs.getString("level_n"));
	String memo = Util.null2String(rs.getString("memo"));
%>
	      <tr>
            <TD class=Field width=10> 
              <input type='checkbox' name='check_lan' value='0'>
            </TD>
            <TD class=Field>               
              <input type=text style='width:100%' name="language_<%=lanrowindex%>" value="<%=language%>">
            </TD>	        
            <TD class=Field> 
	          <select class=saveHistory id=level style='width:100%' name="level_<%=lanrowindex%>" value="<%=level%>">
	            <option value=0 <%if(level.equals("0")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(154,7)%></option>
	            <option value=1 <%if(level.equals("1")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(821,7)%></option>
	            <option value=2 <%if(level.equals("2")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(822,7)%></option>
	            <option value=3 <%if(level.equals("3")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(823,7)%></option>	            
	          </select>              
            </TD>
	        <TD class=Field> 
              <input type=text  style='width:100%'  name="memo_<%=lanrowindex%>" value="<%=memo%>">
            </TD>
	      </tr> 
<%
	lanrowindex++;
  }
%>        
      </tbody>
       </table>



<%
  sql = "select * from HrmEducationInfo where resourceid = "+id;  
  rs.executeSql(sql);  
%>
 
        <TABLE width="100%"  class=ListShort cols=7 id=eduTable>

	      <TBODY> 
          <TR class=Section> 
            <TH colspan=3>教育情况</TH>			
			<Td align=right colspan=4>
			<BUTTON class=btnNew accessKey=A onClick="addeduRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			<BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteeduRow1()};"><U>D</U>-删除</BUTTON>			 
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=7></TD>
          </TR>	
		  <tr class=Header>
            <td >&nbsp</td> 
		    <td >学校名称	</td>
			<td >专业	</td>
			<td >开始日期</td>
			<td >结束日期</td>
			<td >学历</td>
			<td >详细描述</td>
		  </tr> 
<%
  int edurowindex=0;
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String school = Util.null2String(rs.getString("school"));
	String speciality = Util.null2String(rs.getString("speciality"));
	String educationlevel = Util.null2String(rs.getString("educationlevel"));
	String studydesc = Util.null2String(rs.getString("studydesc"));
%>
	      <tr>
            <TD class=Field width=10> 
              <input type='checkbox' name='check_edu' value='0'>
            </TD>
	        <TD class=Field>               
              <input type=text style='width:100%' name="school_<%=edurowindex%>" value="<%=school%>">
            </TD>
	        <TD class=Field> 
	          <BUTTON class=Browser name="btnspeciality_<%=edurowindex%>"  onclick="onShowSpeciality(specialityspan_<%=edurowindex%>,speciality_<%=edurowindex%>)">
	          </BUTTON>
	          <SPAN id=specialityspan_<%=edurowindex%>>
	            <%=SpecialityComInfo.getSpecialityname(speciality)%>
	          </SPAN>
	          <INPUT type=hidden name=speciality_<%=edurowindex%>>
              
            </TD>
	        <TD class=Field width=100> 
              <BUTTON class=Calendar  id=selectcontractdate onclick='getDate(edustartdatespan_<%=edurowindex%> , edustartdate_<%=edurowindex%>)' > </BUTTON><SPAN id='edustartdatespan_<%=edurowindex%>'><%=startdate%></SPAN> <input type=hidden id='edustartdate_<%=edurowindex%>' name='edustartdate_<%=edurowindex%>' value="<%=startdate%>">
            </TD>
	        <TD class=Field width=100> 
              <BUTTON class=Calendar  id=selectcontractdate onclick='getDate(eduenddatespan_<%=edurowindex%> , eduenddate_<%=edurowindex%>)' > </BUTTON><SPAN id='eduenddatespan_<%=edurowindex%>'><%=enddate%></SPAN> <input type=hidden id='eduenddate_<%=edurowindex%>' name='eduenddate_<%=edurowindex%>' value="<%=enddate%>">
            </TD>
	        <TD class=Field> 
	          <BUTTON class=Browser name="btneducationlevel"  onclick="onShowEduLevel(educationlevelspan_<%=edurowindex%>,educationlevel_<%=edurowindex%>)"> </BUTTON>
                <SPAN id=educationlevelspan_<%=edurowindex%>><%=EduLevelComInfo.getEducationLevelname(educationlevel)%></SPAN>
                <INPUT type=hidden name=educationlevel_<%=edurowindex%> value="<%=educationlevel%>">               
            </TD>
	        <TD class=Field> 
              <input type=text  style='width:100%'  name="studydesc_<%=edurowindex%>" value="<%=studydesc%>">
            </TD>
	      </tr> 
<%
	edurowindex++;
  }
%>        
      </tbody>
       </table>

<%
%>

        <TABLE width="100%"  class=ListShort cols=7 id="workTable">

	      <TBODY> 
          <TR class=Section> 
            <TH  colspan=3>入职前工作简历</TH>
			<Td align=right colspan=4>
			 <BUTTON class=btnNew accessKey=A onClick="addworkRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			 <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteworkRow1()};"><U>D</U>-删除</BUTTON>       </Td>
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=7></TD>
          </TR>	
		  <tr class=Header>
            <td ></td>
		    <td >公司名称	</td>
			<td >职务	</td>
			<td >开始日期</td>
			<td >结束日期</td>
			<td >工作描述</td>
			<td >离开原因</td>
		  </tr> 
<%
  int workrowindex = 0;
  sql = "select * from HrmWorkResume where resourceid = "+id;  
  rs.executeSql(sql);  

  while(rs.next()){
    String startdate = Util.null2String(rs.getString("startdate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String leavereason = Util.null2String(rs.getString("leavereason"));
	String workdesc = Util.null2String(rs.getString("workdesc"));
%>
	      <tr>
            <TD class=Field width=10> 
              <input type='checkbox' name='check_work' value='0'>
            </td>
	        <TD class=Field> 
              <input type=text style='width:100%' name="company_<%=workrowindex%>" value="<%=company%>">
            </TD>
	        <TD class=Field> 
              <input type=text style='width:100%' name="jobtitle_<%=workrowindex%>" value="<%=jobtitle%>">
            </TD>
	        <TD class=Field width=100> 
              <BUTTON class=Calendar  id=selectworkdate onclick='getDate(workstartdatespan_<%=workrowindex%> , workstartdate_<%=workrowindex%>)' > </BUTTON><SPAN id='workstartdatespan_<%=workrowindex%>'><%=startdate%></SPAN> <input type=hidden id='workstartdate_<%=workrowindex%>' name='workstartdate_<%=workrowindex%>' value="<%=startdate%>">
            </TD>
	        <TD class=Field width=100> 
              <BUTTON class=Calendar  id=selectcontractdate onclick='getDate(workenddatespan_<%=workrowindex%> , workenddate_<%=workrowindex%>)' > </BUTTON><SPAN id='workenddatespan_<%=workrowindex%>'><%=enddate%></SPAN> <input type=hidden id='workenddate_<%=workrowindex%>' name='workenddate_<%=workrowindex%>' value="<%=enddate%>">
            </TD>
	        <TD class=Field> 
              <input type=text style='width:100%' name="workdesc_<%=workrowindex%>" value="<%=workdesc%>">
            </TD>
	        <TD class=Field> 
              <input type=text style='width:100%' name="leavereason_<%=workrowindex%>" value="<%=leavereason%>">
            </TD>
	      </tr> 
<%
	workrowindex++;
  }
%>        
      </tbody>
       </table>


<%
  sql = "select * from HrmTrainBeforeWork where resourceid = "+id;  
  rs.executeSql(sql);  
%>

        <TABLE width="100%"  class=ListShort cols=6 id="trainTable">

	      <TBODY> 
          <TR class=Section> 
            <TH colspan=3>入职前培训</TH>
			<Td align=right colspan=3>
			 <BUTTON class=btnNew accessKey=A onClick="addtrainRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			 <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deletetrainRow1()};"><U>D</U>-删除</BUTTON>	
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=6></TD>
          </TR>	
		  <tr class=Header>
            <td ></td>
		    <td >培训名称	</td>
			<td >开始日期</td>
			<td >结束日期</td>
			<td >培训单位</td>
			<td >备注</td>
		  </tr> 
<%
  int trainrowindex = 0;
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("trainstartdate"));
	String enddate = Util.null2String(rs.getString("trainenddate"));
	String trainname = Util.null2String(rs.getString("trainname"));
	String trainresource = Util.null2String(rs.getString("trainresource"));	
	String trainmemo = Util.null2String(rs.getString("trainmemo"));
%>
	      <tr>
            <TD class=Field width=10> 
              <input type='checkbox' name='check_train' value='0'>
            </td>
	        <TD class=Field> 
              <input type=text style='width:100%' name="trainname_<%=trainrowindex%>" value=" <%=trainname%>">
            </TD>	        
	        <TD class=Field width=100> 
             <BUTTON class=Calendar  id=selectcontractdate onclick='getDate(trainstartdatespan_<%=trainrowindex%> , trainstartdate_<%=trainrowindex%>)' > </BUTTON><SPAN id='trainstartdatespan_<%=trainrowindex%>'><%=startdate%></SPAN> <input type=hidden id='trainstartdate_<%=trainrowindex%>' name='trainstartdate_<%=trainrowindex%>' value="<%=startdate%>">
            </TD>
	        <TD class=Field width=100> 
             <BUTTON class=Calendar  id=selectcontractdate onclick='getDate(trainenddatespan_<%=trainrowindex%> , trainenddate_<%=trainrowindex%>)' > </BUTTON><SPAN id='trainenddatespan_<%=trainrowindex%>'><%=enddate%></SPAN> <input type=hidden id='trainenddate_<%=trainrowindex%>' name='trainenddate_<%=trainrowindex%>' value="<%=enddate%>">
            </TD>
            <TD class=Field> 
              <input type=text style='width:100%' name="trainresource_<%=trainrowindex%>" value="<%=trainresource%>">
            </TD> 
	        <TD class=Field> 
              <input type=text style='width:100%' name="trainmemo_<%=trainrowindex%>" value="<%=trainmemo%>">
            </TD>	       
	      </tr> 
<%
	trainrowindex++;
  }
%>        
      </tbody>
       </table>

<%
  sql = "select * from HrmcerBeforeWork where resourceid = "+id;  
  rs.executeSql(sql);  
%>

        <TABLE width="100%"  class=ListShort cols=5 id="cerTable">

	      <TBODY> 
          <TR class=Section> 
            <TH colspan=2>资格证书</TH>
			<Td align=right colspan=3>
			 <BUTTON class=btnNew accessKey=A onClick="addcerRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			 <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deletecerRow1()};"><U>D</U>-删除</BUTTON>	
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=5></TD>
          </TR>	
		  <tr class=header>
            <td ></td>
		    <td >名称	</td>
			<td >开始日期</td>
			<td >结束日期</td>
			<td >培训单位</td>			
		  </tr> 
<%
  int cerrowindex = 0;
  sql = "select * from HrmCertification where resourceid = "+id;
  rs.executeSql(sql);
  while(rs.next()){
    String startdate = Util.null2String(rs.getString("datefrom"));
	String enddate = Util.null2String(rs.getString("dateto"));
	String cername = Util.null2String(rs.getString("certname"));
	String cerresource = Util.null2String(rs.getString("awardfrom"));		
%>
	      <tr>
            <TD class=Field width=10> 
              <input type='checkbox' name='check_cer' value='0'>
            </td>
	        <TD class=Field> 
              <input type=text style='width:100%' name="cername_<%=cerrowindex%>" value=" <%=cername%>">
            </TD>	        
	        <TD class=Field width=100> 
             <BUTTON class=Calendar  id=selectcontractdate onclick='getDate(cerstartdatespan_<%=cerrowindex%> , cerstartdate_<%=cerrowindex%>)' > </BUTTON><SPAN id='cerstartdatespan_<%=cerrowindex%>'><%=startdate%></SPAN> <input type=hidden id='cerstartdate_<%=cerrowindex%>' name='cerstartdate_<%=cerrowindex%>' value="<%=startdate%>">
            </TD>
	        <TD class=Field width=100> 
             <BUTTON class=Calendar  id=selectcontractdate onclick='getDate(cerenddatespan_<%=cerrowindex%> , cerenddate_<%=cerrowindex%>)' > </BUTTON><SPAN id='cerenddatespan_<%=cerrowindex%>'><%=enddate%></SPAN> <input type=hidden id='cerenddate_<%=cerrowindex%>' name='cerenddate_<%=cerrowindex%>' value="<%=enddate%>">
            </TD>
            <TD class=Field> 
              <input type=text style='width:100%' name="cerresource_<%=cerrowindex%>" value="<%=cerresource%>">
            </TD> 	        
	      </tr> 
<%
	cerrowindex++;
  }
%>        
      </tbody>
       </table>



        <TABLE width="100%"  class=ListShort cols=4 id="rewardTable">

	      <TBODY> 
          <TR class=Section> 
            <TH colspan=3>入职前奖惩</TH>
			<Td align=right colspan=1>
			 <BUTTON class=btnNew accessKey=A onClick="addrewardRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON> 
			 <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleterewardRow1()};"><U>D</U>-删除</BUTTON>
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=4></TD>
          </TR>	
		  <tr class=header>
            <td></td>
		    <td >奖惩名称	</td>
			<td >奖惩日期</td>			
			<td >备注</td>
		  </tr> 
<%int rewardrowindex=0;
  sql = "select * from HrmRewardBeforeWork where resourceid = "+id;  
  rs.executeSql(sql);  
  while(rs.next()){
    String rewarddate = Util.null2String(rs.getString("rewarddate"));
	String rewardname = Util.null2String(rs.getString("rewardname"));
	String rewardmemo = Util.null2String(rs.getString("rewardmemo"));
%>
	      <tr>
            <TD class=Field width=10> 
              <input type='checkbox'  name='check_reward' value='0'>
            </td>	        
	        <TD class=Field> 
              <input type=text style='width:100%' name="rewardname_<%=rewardrowindex%>" value="<%=rewardname%>">
            </TD>	        
	        <TD class=Field width=100> 
              <BUTTON class=Calendar  id=selectcontractdate onclick='getDate(rewarddatespan_<%=rewardrowindex%> , rewarddate_<%=rewardrowindex%>)' > </BUTTON><SPAN id='rewarddatespan_<%=rewardrowindex%>'><%=rewarddate%></SPAN> <input type=hidden id='rewarddate_<%=rewardrowindex%>' name='rewarddate_<%=rewardrowindex%>' value="<%=rewarddate%>">
            </TD>
	        <TD class=Field> 
              <input type=text style='width:100%' name="rewardmemo_<%=rewardrowindex%>" value="<%=rewardmemo%>">
            </TD>            	       
	      </tr> 
<%
	 rewardrowindex++;
  }
%>        
      </tbody>
       </table>



</form>
<script language=javascript>
  function viewBasicInfo(){    
    location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
  }
  function viewPersonalInfo(){    
    location = "/hrm/resource/HrmResourcePersonalView.jsp?id=<%=id%>";
  }
  function viewFinanceInfo(){    
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>";
  }  
  function viewSystemInfo(){    
    location = "/hrm/resource/HrmResourceSystemView.jsp?id=<%=id%>";
  }
  
edurowindex = <%=edurowindex%>;
function addeduRow(){        
	oRow = eduTable.insertRow();
	ncol = eduTable.cols ;
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox'  name='check_edu' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text style='width:100%' name='school_"+edurowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Browser name='btnspeciality_"+edurowindex+"'  onclick='onShowSpeciality(specialityspan_"+edurowindex+" , speciality_"+edurowindex+")'></BUTTON><SPAN id='specialityspan_"+edurowindex+"'></SPAN><INPUT type=hidden name='speciality_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(edustartdatespan_"+edurowindex+" , edustartdate_"+edurowindex+")' > </BUTTON><SPAN id='edustartdatespan_"+edurowindex+"'></SPAN> <input type=hidden id='edustartdate_"+edurowindex+"' name='edustartdate_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 4: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(eduenddatespan_"+edurowindex+" , eduenddate_"+edurowindex+")' > </BUTTON><SPAN id='eduenddatespan_"+edurowindex+"'></SPAN> <input type=hidden id='eduenddate_"+edurowindex+"' name='eduenddate_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		    case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Browser name='btneducationlevel_"+edurowindex+"'  onclick='onShowEduLevel(educationlevelspan_"+edurowindex+" , educationlevel_"+edurowindex+")'></BUTTON><SPAN id='educationlevelspan_"+edurowindex+"'></SPAN><INPUT type=hidden name='educationlevel_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 6: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text style='width:100%' name='studydesc_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
		}
	}
	edurowindex = edurowindex*1 +1;	
}
function deleteeduRow1()
{
	len = document.forms[0].elements.length;	
	var i=0;
	var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_edu')
			rowsum1 += 1;
	} 
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_edu'){
			if(document.forms[0].elements[i].checked==true) {
				eduTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}
	
	}	
}

workrowindex = <%=workrowindex%>

function addworkRow()
{
	ncol = workTable.cols;
	
	oRow = workTable.insertRow();
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox'  style='width:100%' name='check_work' value='0'>"; 
				oDiv.innerHTML = sHtml;                
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text  style='width:100%' name='company_"+workrowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(workstartdatespan_"+workrowindex+" , workstartdate_"+workrowindex+")' > </BUTTON><SPAN id='workstartdatespan_"+workrowindex+"'></SPAN> <input type=hidden id='workstartdate_"+workrowindex+"' name='workstartdate_"+workrowindex+"'>";

				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(workenddatespan_"+workrowindex+" , workenddate_"+workrowindex+")' > </BUTTON><SPAN id='workenddatespan_"+workrowindex+"'></SPAN> <input type=hidden id='workenddate_"+workrowindex+"' name='workenddate_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text style='width:100%' name='jobtitle_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		    case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text style='width:100%' name='workdesc_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 6: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text style='width:100%' name='leavereason_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
		}
	}
	workrowindex = workrowindex*1 +1;
	
}

function deleteworkRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_work')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_work'){
			if(document.forms[0].elements[i].checked==true) {
				workTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

trainrowindex = <%=trainrowindex%>
function addtrainRow()
{
	ncol = trainTable.cols;
	
	oRow = trainTable.insertRow();
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox'  style='width:100%' name='check_train' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text style='width:100%' name='trainname_"+trainrowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(trainstartdatespan_"+trainrowindex+" , trainstartdate_"+trainrowindex+")' > </BUTTON><SPAN id='trainstartdatespan_"+trainrowindex+"'></SPAN> <input type=hidden id='trainstartdate_"+trainrowindex+"' name='trainstartdate_"+trainrowindex+"'>";				
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(trainenddatespan_"+trainrowindex+" , trainenddate_"+trainrowindex+")' > </BUTTON><SPAN id='trainenddatespan_"+trainrowindex+"'></SPAN> <input type=hidden id='trainenddate_"+trainrowindex+"' name='trainenddate_"+trainrowindex+"'>";				
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text style='width:100%' name='trainresource_"+trainrowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		    case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text style='width:100%' name='trainmemo_"+trainrowindex+"'>";
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
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox'  style='width:100%' name='check_cer' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text style='width:100%' name='cername_"+cerrowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(cerstartdatespan_"+cerrowindex+" , cerstartdate_"+cerrowindex+")' > </BUTTON><SPAN id='cerstartdatespan_"+cerrowindex+"'></SPAN> <input type=hidden id='cerstartdate_"+cerrowindex+"' name='cerstartdate_"+cerrowindex+"'>";				
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(cerenddatespan_"+cerrowindex+" , cerenddate_"+cerrowindex+")' > </BUTTON><SPAN id='cerenddatespan_"+cerrowindex+"'></SPAN> <input type=hidden id='cerenddate_"+cerrowindex+"' name='cerenddate_"+cerrowindex+"'>";				
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text style='width:100%' name='cerresource_"+cerrowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		    
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
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_reward' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text style='width:100%' name='rewardname_"+rewardrowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(rewarddatespan_"+rewardrowindex+" , rewarddate_"+rewardrowindex+")' > </BUTTON><SPAN id='rewarddatespan_"+rewardrowindex+"'></SPAN> <input type=hidden id='rewarddate_"+rewardrowindex+"' name='rewarddate_"+rewardrowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text style='width:100%' name='rewardmemo_"+rewardrowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
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

lanrowindex = <%=lanrowindex%>;
function addlanRow(){        
	oRow = lanTable.insertRow();
	ncol = lanTable.cols ;
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox'  name='check_lan' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text style='width:100%' name='language_"+lanrowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;			
		    case 2: 
				var oDiv = document.createElement("div"); 				
				var sHtml = "<select class=saveHistory id=level style='width:100%' name='level_"+lanrowindex+"'><option value=0 selected ><%=SystemEnv.getHtmlLabelName(154,7)%></option><option value=1 ><%=SystemEnv.getHtmlLabelName(821,7)%></option><option value=2 ><%=SystemEnv.getHtmlLabelName(822,7)%></option><option value=3 ><%=SystemEnv.getHtmlLabelName(823,7)%></option></select>"
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text style='width:100%' name='memo_"+lanrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
		}
	}
	lanrowindex = lanrowindex*1 +1;	
}
function deletelanRow1()
{
	len = document.forms[0].elements.length;	
	var i=0;
	var rowsum1 = 0 ;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_lan')
			rowsum1 += 1;
	} 
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_lan'){
			if(document.forms[0].elements[i].checked==true) {
				lanTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}
	
	}	
}

  function edit(){    
     document.resourceworkedit.lanrownum.value=lanrowindex;
     document.resourceworkedit.edurownum.value=edurowindex;
	 document.resourceworkedit.workrownum.value=workrowindex;
	 document.resourceworkedit.trainrownum.value=trainrowindex;
	 document.resourceworkedit.rewardrownum.value=rewardrowindex;
	 document.resourceworkedit.cerrownum.value=cerrowindex;	 
     document.resourceworkedit.operation.value="editwork";
	 document.resourceworkedit.submit();
  }
function isdel(){
   if(!confirm("确定要删除吗？")){
       return false;
   }
       return true;
   } 
</script> 
<script language=vbs>
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
</BODY>
</HTML>

