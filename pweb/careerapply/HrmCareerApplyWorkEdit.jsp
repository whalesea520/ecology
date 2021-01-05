
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
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
<BODY>
<DIV class=HdrProps></DIV>
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
  <BUTTON class=btnSave accessKey=E type=button onclick=edit()><U>E</U>-<%=SystemEnv.getHtmlLabelName(86, 7)%></BUTTON>
<BUTTON class=btnSave accessKey=B type=button onclick="location.href='HrmCareerApplyWorkView.jsp?id=<%=id%>'"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290, 7)%></BUTTON>  
 </DIV>

<%
  String sql = "select * from HrmLanguageAbility where resourceid = "+id;  
  rs.executeSql(sql);  
%>
 
        <TABLE width="100%"  class=ListShort cols=4 id=lanTable>

	      <TBODY> 
          <TR class=Section> 
            <TH colspan=3><%=SystemEnv.getHtmlLabelName(815, 7)%></TH>			
			<Td align=right colspan=1>
			<BUTTON class=btnNew accessKey=A type=button onClick="addlanRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			<BUTTON class=btnDelete accessKey=D type=button onClick="javascript:if(isdel()){deletelanRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, 7)%></BUTTON>			 
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=4></TD>
          </TR>	
		  <tr class=Header>
            <td >&nbsp</td> 		    
			<td ><%=SystemEnv.getHtmlLabelName(231, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(15715, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(454, 7)%></td>
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
            <TH colspan=3><%=SystemEnv.getHtmlLabelName(813, 7)%></TH>			
			<Td align=right colspan=4>
			<BUTTON class=btnNew accessKey=A type=button onClick="addeduRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			<BUTTON class=btnDelete accessKey=D type=button onClick="javascript:if(isdel()){deleteeduRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, 7)%></BUTTON>			 
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=7></TD>
          </TR>	
		  <tr class=Header>
            <td >&nbsp</td> 
		    <td ><%=SystemEnv.getHtmlLabelName(1903, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(803, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(818, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1942, 7)%></td>
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
	          <BUTTON class=Browser type=button name="btnspeciality_<%=edurowindex%>"  onclick="onShowSpeciality(specialityspan_<%=edurowindex%>,speciality_<%=edurowindex%>)">
	          </BUTTON>
	          <SPAN id=specialityspan_<%=edurowindex%>>
	            <%=SpecialityComInfo.getSpecialityname(speciality)%>
	          </SPAN>
	          <INPUT type=hidden name="speciality_<%=edurowindex%>"  value="<%=speciality%>">
              
            </TD>
	        <TD class=Field width=100><div id="edustartdatediv<%=edurowindex%>">
              <BUTTON class=Calendar  type=button id=selectcontractdate onclick='getDate(edustartdatespan_<%=edurowindex%> , edustartdate_<%=edurowindex%>)' > </BUTTON><SPAN id='edustartdatespan_<%=edurowindex%>'><%=startdate%></SPAN> <input type=hidden id='edustartdate_<%=edurowindex%>' name='edustartdate_<%=edurowindex%>' value="<%=startdate%>">
				</div>
            </TD>
	        <TD class=Field width=100><div id="eduenddatediv<%=edurowindex%>">
              <BUTTON class=Calendar  type=button id=selectcontractdate onclick='getDate(eduenddatespan_<%=edurowindex%> , eduenddate_<%=edurowindex%>)' > </BUTTON><SPAN id='eduenddatespan_<%=edurowindex%>'><%=enddate%></SPAN> <input type=hidden id='eduenddate_<%=edurowindex%>' name='eduenddate_<%=edurowindex%>' value="<%=enddate%>">
				</div>
            </TD>
	        <TD class=Field> 
	          <BUTTON class=Browser name="btneducationlevel"  type=button onclick="onShowEduLevel(educationlevelspan_<%=edurowindex%>,educationlevel_<%=edurowindex%>)"> </BUTTON>
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
            <TH  colspan=3><%=SystemEnv.getHtmlLabelName(15716, 7)%></TH>
			<Td align=right colspan=4>
			 <BUTTON class=btnNew accessKey=A type=button onClick="addworkRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			 <BUTTON class=btnDelete accessKey=D type=button onClick="javascript:if(isdel()){deleteworkRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, 7)%></BUTTON>       </Td>
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=7></TD>
          </TR>	
		  <tr class=Header>
            <td>&nbsp;</td>
		    <td ><%=SystemEnv.getHtmlLabelName(1976, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1915, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1977, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(15676, 7)%></td>
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
	        <TD class=Field width=100><div id="workdatediv<%=workrowindex%>">
              <BUTTON class=Calendar  id=selectworkdate type=button onclick='getDate(workstartdatespan_<%=workrowindex%> , workstartdate_<%=workrowindex%>)' > </BUTTON><SPAN id='workstartdatespan_<%=workrowindex%>'><%=startdate%></SPAN> <input type=hidden id='workstartdate_<%=workrowindex%>' name='workstartdate_<%=workrowindex%>' value="<%=startdate%>">
            </div>
			</TD>
	        <TD class=Field width=100><div id="contractdatediv<%=workrowindex%>"> 
              <BUTTON class=Calendar  id=selectcontractdate type=button onclick='getDate(workenddatespan_<%=workrowindex%> , workenddate_<%=workrowindex%>)' > </BUTTON><SPAN id='workenddatespan_<%=workrowindex%>'><%=enddate%></SPAN> <input type=hidden id='workenddate_<%=workrowindex%>' name='workenddate_<%=workrowindex%>' value="<%=enddate%>">
			</div>        
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
            <TH colspan=3><%=SystemEnv.getHtmlLabelName(15717, 7)%></TH>
			<Td align=right colspan=3>
			 <BUTTON class=btnNew accessKey=A type=button onClick="addtrainRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			 <BUTTON class=btnDelete accessKey=D type=button onClick="javascript:if(isdel()){deletetrainRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, 7)%></BUTTON>	
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=6></TD>
          </TR>	
		  <tr class=Header>
            <td ></td>
		    <td ><%=SystemEnv.getHtmlLabelName(15678, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1974, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(454, 7)%></td>
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
	        <TD class=Field width=100><div id="scontractdateediv<%=trainrowindex%>">  
             <BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(trainstartdatespan_<%=trainrowindex%> , trainstartdate_<%=trainrowindex%>)' > </BUTTON><SPAN id='trainstartdatespan_<%=trainrowindex%>'><%=startdate%></SPAN> <input type=hidden id='trainstartdate_<%=trainrowindex%>' name='trainstartdate_<%=trainrowindex%>' value="<%=startdate%>">
            </div>
			</TD>
	        <TD class=Field width=100><div id="econtractdateediv<%=workrowindex%>">  
             <BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(trainenddatespan_<%=trainrowindex%> , trainenddate_<%=trainrowindex%>)' > </BUTTON><SPAN id='trainenddatespan_<%=trainrowindex%>'><%=enddate%></SPAN> <input type=hidden id='trainenddate_<%=trainrowindex%>' name='trainenddate_<%=trainrowindex%>' value="<%=enddate%>">
            </div>
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
        <TABLE width="100%"  class=ListShort cols=5 id="cerTable">

	      <TBODY> 
          <TR class=Section> 
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(1502, 7)%></TH>
			<Td align=right colspan=3>
			 <BUTTON class=btnNew accessKey=A type=button onClick="addcerRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			 <BUTTON class=btnDelete accessKey=D type=button onClick="javascript:if(isdel()){deletecerRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, 7)%></BUTTON>	
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=5></TD>
          </TR>	
		  <tr class=header>
            <td ></td>
		    <td ><%=SystemEnv.getHtmlLabelName(195, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(740, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(741, 7)%></td>
			<td ><%=SystemEnv.getHtmlLabelName(1974, 7)%></td>			
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
	        <TD class=Field width=100><div id = "hrmscontractdatediv<% %>=cerrowindex%>"> 
             <BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(cerstartdatespan_<%=cerrowindex%> , cerstartdate_<%=cerrowindex%>)' > </BUTTON><SPAN id='cerstartdatespan_<%=cerrowindex%>'><%=startdate%></SPAN> <input type=hidden id='cerstartdate_<%=cerrowindex%>' name='cerstartdate_<%=cerrowindex%>' value="<%=startdate%>">
            </div>
			</TD>
	        <TD class=Field width=100><div id  = "hrmecontractdatediv<%= cerrowindex%>">
             <BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(cerenddatespan_<%=cerrowindex%> , cerenddate_<%=cerrowindex%>)' > </BUTTON><SPAN id='cerenddatespan_<%=cerrowindex%>'><%=enddate%></SPAN> <input type=hidden id='cerenddate_<%=cerrowindex%>' name='cerenddate_<%=cerrowindex%>' value="<%=enddate%>">
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
            <TH colspan=3><%=SystemEnv.getHtmlLabelName(15718, 7)%></TH>
			<Td align=right colspan=1>
			 <BUTTON class=btnNew accessKey=A type=button onClick="addrewardRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON> 
			 <BUTTON class=btnDelete accessKey=D type=button onClick="javascript:if(isdel()){deleterewardRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, 7)%></BUTTON>
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=4></TD>
          </TR>	
		  <tr class=header>
            <td></td>
		    <td ><%=SystemEnv.getHtmlLabelName(15666, 7)%>	</td>
			<td ><%=SystemEnv.getHtmlLabelName(1962, 7)%></td>			
			<td ><%=SystemEnv.getHtmlLabelName(454, 7)%></td>
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
	        <TD class=Field width=100><div id="rewdatediv<%=rewardrowindex %>"> 
              <BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(rewarddatespan_<%=rewardrowindex%> , rewarddate_<%=rewardrowindex%>)' > </BUTTON><SPAN id='rewarddatespan_<%=rewardrowindex%>'><%=rewarddate%></SPAN> <input type=hidden id='rewarddate_<%=rewardrowindex%>' name='rewarddate_<%=rewardrowindex%>' value="<%=rewarddate%>">
            </div>
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
	ncol = jQuery(eduTable).find("tr:nth-child(3)").find("td").length;
	oRow = eduTable.insertRow(-1);
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
				var sHtml = "<BUTTON class=Browser type=button name='btnspeciality_"+edurowindex+"'  onclick='onShowSpeciality(specialityspan_"+edurowindex+" , speciality_"+edurowindex+")'></BUTTON><SPAN id='specialityspan_"+edurowindex+"'></SPAN><INPUT type=hidden name='speciality_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(edustartdatespan_"+edurowindex+" , edustartdate_"+edurowindex+")' > </BUTTON><SPAN id='edustartdatespan_"+edurowindex+"'></SPAN> <input type=hidden id='edustartdate_"+edurowindex+"' name='edustartdate_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
            case 4: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(eduenddatespan_"+edurowindex+" , eduenddate_"+edurowindex+")' > </BUTTON><SPAN id='eduenddatespan_"+edurowindex+"'></SPAN> <input type=hidden id='eduenddate_"+edurowindex+"' name='eduenddate_"+edurowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		    case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Browser type=button name='btneducationlevel_"+edurowindex+"'  onclick='onShowEduLevel(educationlevelspan_"+edurowindex+" , educationlevel_"+edurowindex+")'></BUTTON><SPAN id='educationlevelspan_"+edurowindex+"'></SPAN><INPUT type=hidden name='educationlevel_"+edurowindex+"'>";
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
	ncol = jQuery(workTable).find("tr:nth-child(3)").find("td").length;
	oRow = workTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
                oCell.style.width=20;
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
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(workstartdatespan_"+workrowindex+" , workstartdate_"+workrowindex+")' > </BUTTON><SPAN id='workstartdatespan_"+workrowindex+"'></SPAN> <input type=hidden id='workstartdate_"+workrowindex+"' name='workstartdate_"+workrowindex+"'>";

				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
				oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(workenddatespan_"+workrowindex+" , workenddate_"+workrowindex+")' > </BUTTON><SPAN id='workenddatespan_"+workrowindex+"'></SPAN> <input type=hidden id='workenddate_"+workrowindex+"' name='workenddate_"+workrowindex+"'>";
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
	ncol = jQuery(trainTable).find("tr:nth-child(3)").find("td").length;
	oRow = trainTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
                oCell.style.width=20;
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
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(trainstartdatespan_"+trainrowindex+" , trainstartdate_"+trainrowindex+")' > </BUTTON><SPAN id='trainstartdatespan_"+trainrowindex+"'></SPAN> <input type=hidden id='trainstartdate_"+trainrowindex+"' name='trainstartdate_"+trainrowindex+"'>";				
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(trainenddatespan_"+trainrowindex+" , trainenddate_"+trainrowindex+")' > </BUTTON><SPAN id='trainenddatespan_"+trainrowindex+"'></SPAN> <input type=hidden id='trainenddate_"+trainrowindex+"' name='trainenddate_"+trainrowindex+"'>";				
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
	ncol = jQuery(cerTable).find("tr:nth-child(3)").find("td").length;
	oRow = cerTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
                oCell.style.width=20;
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
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(cerstartdatespan_"+cerrowindex+" , cerstartdate_"+cerrowindex+")' > </BUTTON><SPAN id='cerstartdatespan_"+cerrowindex+"'></SPAN> <input type=hidden id='cerstartdate_"+cerrowindex+"' name='cerstartdate_"+cerrowindex+"'>";				
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(cerenddatespan_"+cerrowindex+" , cerenddate_"+cerrowindex+")' > </BUTTON><SPAN id='cerenddatespan_"+cerrowindex+"'></SPAN> <input type=hidden id='cerenddate_"+cerrowindex+"' name='cerenddate_"+cerrowindex+"'>";				
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
	ncol = jQuery(rewardTable).find("tr:nth-child(3)").find("td").length;
	oRow = rewardTable.insertRow(-1);
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
				var sHtml = "<BUTTON class=Calendar type=button id=selectcontractdate onclick='getDate(rewarddatespan_"+rewardrowindex+" , rewarddate_"+rewardrowindex+")' > </BUTTON><SPAN id='rewarddatespan_"+rewardrowindex+"'></SPAN> <input type=hidden id='rewarddate_"+rewardrowindex+"' name='rewarddate_"+rewardrowindex+"'>";
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
	ncol = jQuery(lanTable).find("tr:nth-child(3)").find("td").length;
	oRow = lanTable.insertRow(-1);
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
     if(checkDateValidity()){
     document.resourceworkedit.lanrownum.value=lanrowindex;
     document.resourceworkedit.edurownum.value=edurowindex;
	 document.resourceworkedit.workrownum.value=workrowindex;
	 document.resourceworkedit.trainrownum.value=trainrowindex;
	 document.resourceworkedit.rewardrownum.value=rewardrowindex;
	 document.resourceworkedit.cerrownum.value=cerrowindex;
     document.resourceworkedit.operation.value="editwork";
	 document.resourceworkedit.submit();
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

sub onShowSpecialitybak(inputspan,inputname)
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
</BODY>
</HTML>
 <script language="javascript">
/**
*       oTable ,表对象
*       row,开始的行
*       col1,开始日期的列
*       col2,结束日期的列
*/

function checkTableObjDate(oTable,row,col1,col2){
        var errorMessage ="";
        return errorMessage;
        if(oTable.rows.length < row)  return  "";
        var description = oTable.rows.item(0).cells.item(0).innerText;
        var rowIndex = row -1 ;
        for(var i=rowIndex;i<oTable.rows.length;i++){
            var rowObj = oTable.rows.item(i);
            var startDate = rowObj.cells.item(col1).children(0).children(2).value;
            
            var endDate = rowObj.cells.item(col2).children(0).children(2).value;
            if(compareDate(startDate,endDate)==1){
                //alert(description+": 第"+(i-rowIndex+1)+"行的\"开始日期\"必须在\"结束日期\"之前！");
                  errorMessage = errorMessage + description+": "+<%=SystemEnv.getHtmlLabelName(15323, 7)%>
                 +(i-rowIndex+1)+<%=SystemEnv.getHtmlLabelName(129299, 7)%>+"\n"  ;
            }

        }
        return errorMessage;
}

function checkDateValidity(){
		return true;
     var isValide = false;
     var eduTableArray = new Array(eduTable,4,3,4)  ;
     var workTableArray = new Array(workTable,4,3,4)  ;
     var trainTableArray = new Array(trainTable,4,2,3)  ;
     var cerTableArray = new Array(cerTable,4,2,3)  ;
     var oTableArray = new Array(eduTableArray,
                                 workTableArray,
                                 trainTableArray,
                                 cerTableArray
                                 );
     var errorMessage ="";
     for(var i=0;i<oTableArray.length;i++){
        var oTable = oTableArray[i][0];
        var row = oTableArray[i][1];
        var col1 = oTableArray[i][2];
        var col2 = oTableArray[i][3];
        var message = checkTableObjDate(oTable,row,col1,col2);
        if(message!="") errorMessage = errorMessage + message;
     }
     if(errorMessage!=""){
        alert(errorMessage);
     }else{
        isValide = true;
     }

     return isValide;
}

/**
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
*/
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
function onShowSpeciality(inputspan,inputname){
	dialog = new window.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(803,7)%>";
	dialog.Width = 580;
	dialog.Height = 550;
	dialog.Drag = true;
	dialog.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp";
	dialog.callbackfun = function (params,datas){
		if (datas!=null){
			if (datas.id!=""){
				$(inputspan).html(datas.name);
				$(inputname).val(datas.id);
			}else{
				$(inputspan).html("");
				$(inputname).val("");
			}
		}
	};
	dialog.show();
}

function onShowEduLevel(inputspan,inputname){
	dialog = new window.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(818,7)%>";
	dialog.Width = 580;
	dialog.Height = 550;
	dialog.Drag = true;
	dialog.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp";
	dialog.callbackfun = function (params,datas){
		if (datas!=null){
			if (datas.id!=""){
				$(inputspan).html(datas.name);
				$(inputname).val(datas.id);
			}else{
				$(inputspan).html("");
				$(inputname).val("");
			}
		}
	};
	dialog.show();
}
</script>
<SCRIPT language="javascript"  src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/pweb/pwebJsDatetime/WdatePicker_wev8.js"></script>
