<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
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
	
	<input type=hidden name=operation value="addthree">
<%
  String id = request.getParameter("id");  
%>	
        <input type=hidden name=id value="<%=id%>">
	

<DIV><BUTTON class=btnSave accessKey=S type=button onClick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,7)%></BUTTON> </DIV>
<!--
        <TABLE width="100%" class=Form>
          <COLGROUP> <COL width=20%> <COL width=80%> <TBODY> 
          <TR class=Section> 
            <TH colSpan=2 height="19">工作信息</TH>
          </TR>
          <TR class=Separator> 
            <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colSpan=2></TD>
          </TR>        
          <TR> 
            <TD>用工性质</TD>
            <TD class=Field> <BUTTON class=Browser onclick="onShowUsekind()"></BUTTON> 
              <SPAN id=usekindspan></SPAN> 
              <INPUT type=hidden name=usekind>
            </TD>
          </TR>
          <TR> 
            <TD>合同开始日期</TD>
            <TD class=Field>
			  <BUTTON class=Calendar id=selectcontractdate onclick="getstartdate()"></BUTTON> 
              <SPAN id=startdatespan ></SPAN> 
              <input type="hidden" name="startdate">
            </TD>
          </TR>          
          <TR>
            <TD>试用期结束日期</TD>
            <TD class=Field><BUTTON class=Calendar id=selectcontractbegintime onclick="getDate(probationenddatespan,probationenddate)"></BUTTON> 
              <SPAN id=probationenddatespan ></SPAN> 
              <input type="hidden" id="probationenddate" name="probationenddate">
            </TD>
          </TR>
          <TR> 
            <TD>合同结束日期</TD>
            <TD class=Field> <BUTTON class=Calendar id=selectenddate onclick="getenddate()"></BUTTON> 
              <SPAN id=enddatespan ></SPAN> 
              <input type="hidden" name="enddate">
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </TD>
-->      
      <TD vAlign=top>    
  </table>

        <TABLE width="100%"  class=ListShort cols=4 id=lanTable> 
	      <TBODY> 
          <TR class=Section> 
            <TH colspan=2>语言能力</TH>			
			<Td align=right colspan=2>
			<BUTTON class=btnNew accessKey=A onClick="addlanRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			<BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deletelanRow1()};"><U>D</U>-删除</BUTTON>			 
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colSpan=4></TD>
          </TR>	
		  <tr bgcolor="F3F3F3">
            <td width=10>&nbsp</td> 		    
			<td >语言	</td>
			<td >能力</td>
			<td >备注</td>
		  </tr> 	      
      </tbody>
       </table>


   <TR class=Separator> 
       <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colSpan=2></TD>
    </TR>
      <TABLE width="100%" class=ListShort cols=7 id=eduTable>
          <COLGROUP>		   
	      <TBODY> 
          <TR class=Section> 
            <TH colSpan=2>教育情况</TH>
		  	<Td align=right colSpan=5>
			 <BUTTON class=btnNew accessKey=A onClick="addeduRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			 <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteeduRow1()};"><U>D</U>-删除</BUTTON>
 		    </Td>
          </TR>
          <TR class=Separator> 
            <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colSpan=7></TD>
          </TR>	
		  <tr bgcolor="F3F3F3">
            <td></td>
		    <td class=Field>学校名称</td>
			<td class=Field>专业</td>
			<td class=Field>开始日期</td>
			<td class=Field>结束日期</td>
			<td class=Field>学历</td>
			<td class=Field>详细描述</td>
		  </tr> 
	  </table>
    
      <TABLE class=ListShort cellpadding=1  cols=7 id="workTable">	  
      <TH colspan=2 align=left>工作简历</TH>       
          <Td align=right colSpan=5>
			 <BUTTON class=btnNew accessKey=A onClick="addworkRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON>
			 <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteworkRow1()};"><U>D</U>-删除</BUTTON>       </Td>
       </TR>
        <TR class=separator>
        <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colspan=7></TD></TR>
             <tr bgcolor="F3F3F3">
               <td width=10></td>
    		   <td class=Field>公司名称</td>
    		   <td class=Field>开始日期</td>
    		   <td class=Field>结束日期</td>
    		   <td class=Field>职务</td>
    		   <td class=Field>工作描述</td>
    		   <td class=Field>离开原因</td>
    		</tr>        
       </table>     
       </TR>    
        <TR class=separator>
        <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colspan=7></TD>
        </TR>

      <TABLE class=ListShort cellpadding=1  cols=6 id="trainTable">	  
       <TR class=Section>
       <TH colspan=3 align=left>培训情况</TH>
       <Td colspan=3 align=right>
	     <BUTTON class=btnNew accessKey=A onClick="addtrainRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON> <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deletetrainRow1()};"><U>D</U>-删除</BUTTON>	
       </Td>
      </TR>    
        <TR class=separator>
        <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colspan=7></TD>
        </TR>
        	<tr bgcolor="F3F3F3">
               <td width=10></td>
    		   <td class=Field>培训名称</td>
    		   <td class=Field>培训开始日期</td>
    		   <td class=Field>培训结束日期</td>
    		   <td class=Field>培训单位</td>
    		   <td class=Field>备注</td>
    		</tr>        
       </table>     
           
       <TABLE class=ListShort cellpadding=1  cols=5 id="cerTable">	  
       <TR class=Section>
       <TH colspan=2 align=left>资格证书</TH>
       <Td colspan=3 align=right>
	     <BUTTON class=btnNew accessKey=A onClick="addcerRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON> <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deletecerRow1()};"><U>D</U>-删除</BUTTON>	
       </Td>
      </TR>    
        <TR class=separator>
        <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colspan=5></TD>
        </TR>
        	<tr bgcolor="F3F3F3">
               <td width=10></td>
    		   <td class=Field>名称</td>
    		   <td class=Field>开始日期</td>
    		   <td class=Field>结束日期</td>
    		   <td class=Field>颁发单位</td>    		   
    		</tr>        
       </table> 
       
      <TABLE class=ListShort cellpadding=1  cols=4 id="rewardTable">	  
        
       <TH colspan=2 align=left>奖惩情况</TH>
       <Td colspan=2 align=right>
	     <BUTTON class=btnNew accessKey=A onClick="addrewardRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,7)%></BUTTON> <BUTTON class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleterewardRow1()};"><U>D</U>-删除</BUTTON>
       </Td>
       <TR class=separator >        
       <TD height="1" background="/web/images/bg_hdotline_wev8.gif" colspan=4></TD></TR>
       </TR>
        	<tr bgcolor="F3F3F3">
               <td width=10></td>
    		   <td class=Field>奖惩名称</td>
    		   <td class=Field>奖惩日期</td>
    		   <td class=Field>备注</td>    		   
    		</tr>
        </table>           
     <input type=hidden name="edurownum">
     <input type=hidden name="workrownum">
     <input type=hidden name="trainrownum">
     <input type=hidden name="rewardrownum">
     <input type=hidden name="cerrownum">
     <input type=hidden name="lanrownum">
  </FORM>
<script language=javascript>
edurowindex = "0";

function isdel(){
   if(!confirm("确定要删除吗？")){
       return false;
   }
       return true;
   } 

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

workrowindex = "0"

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
			case 2: 
                                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(workstartdatespan_"+workrowindex+" , workstartdate_"+workrowindex+")' > </BUTTON><SPAN id='workstartdatespan_"+workrowindex+"'></SPAN> <input type=hidden id='workstartdate_"+workrowindex+"' name='workstartdate_"+workrowindex+"'>";

				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 3: 
			    oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON class=Calendar  id=selectcontractdate onclick='getDate(workenddatespan_"+workrowindex+" , workenddate_"+workrowindex+")' > </BUTTON><SPAN id='workenddatespan_"+workrowindex+"'></SPAN> <input type=hidden id='workenddate_"+workrowindex+"' name='workenddate_"+workrowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
                        case 4: 
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

trainrowindex = "0"
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

rewardrowindex = "0"
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

cerrowindex = "0"
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

lanrowindex = 0;
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


function doSave() {
   document.resource.lanrownum.value = lanrowindex;
   document.resource.rewardrownum.value = rewardrowindex;
   document.resource.workrownum.value = workrowindex;
   document.resource.edurownum.value = edurowindex;	
   document.resource.trainrownum.value = trainrowindex;
   document.resource.cerrownum.value = cerrowindex;
   document.resource.submit() ;

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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
