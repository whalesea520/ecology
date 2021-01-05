
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
<%
		String isclose = Util.null2String(request.getParameter("isclose"));
		String isDialog = Util.null2String(request.getParameter("isdialog"));
    String checkpeopleid = Util.null2String(request.getParameter("id")) ;
    String checkid = "" ;
    String checktypeid = "" ;
    String resourceid = "" ;
    String result = "" ;
    String startdate = "" ;
    String enddate = "" ;
    Calendar todaycal = Calendar.getInstance ();
    String nowdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
    String sql="select checkid,resourceid from HrmByCheckPeople where id="+ checkpeopleid ;
    rs.executeSql(sql) ;
    if(rs.next()) {
        checkid = Util.null2String(rs.getString("checkid"));
        resourceid = Util.null2String(rs.getString("resourceid"));
    }

    sql="select checktypeid,startdate,enddate from HrmCheckList where id="+ checkid ;
    rs.executeSql(sql) ;
    if(rs.next()) {
        checktypeid = Util.null2String(rs.getString("checktypeid"));
        startdate =  Util.null2String(rs.getString("startdate"));
        enddate = Util.null2String(rs.getString("enddate"));
    }
    
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6106,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
	if("<%=isclose%>"=="1"){
		parentWin.onBtnSearchClick();
		parentWin.closeDialog();	
	}
	</script>
</HEAD>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(nowdate.compareTo(enddate) <=0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=HrmCheckMark id=hrmcheckkind action="HrmCheckMarkOperation.jsp" method=POST >
<input class=inputstyle type=hidden name=checkpeopleid value="<%=checkpeopleid%>">
<input class=inputstyle type=hidden name=checktypeid value="<%=checktypeid%>">
<input class=inputstyle type=hidden name=operation value="AddCheck">
   
            <TABLE width="100%"  class=ListStyle cellspacing=1 >
                
                <TBODY> 
                    <TR class=Header> 
                    <TH colspan=3>
			
                    <%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%>: <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></TH>

                    </TR>
                        <tr class=header>
                        <td width=20%><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></td>
                        <td width=30%><%=SystemEnv.getHtmlLabelName(15752,user.getLanguage())%></td>
                        <td width=25%><%=SystemEnv.getHtmlLabelName(15657,user.getLanguage())%></td>
                        <td width=25%><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></td>
                    </tr>
                    <%      
                            String checkitemid="" ;
                            ArrayList results = new ArrayList();
                            ArrayList checkitemids = new ArrayList();
                            sql="select result,checkitemid from HrmCheckGrade where checkpeopleid="+ checkpeopleid ;
                            rs2.executeSql(sql) ;
                            while(rs2.next()){
                                results.add(Util.null2String(rs2.getString("result")));
                                checkitemids.add(Util.null2String(rs2.getString("checkitemid")));
                            }
                            
                                                   
                            sql = "select checkitemid , checkitemproportion from HrmCheckKindItem where checktypeid="+checktypeid;
         
                            rs.executeSql(sql) ;
                            boolean isLight = false;
                            while(rs.next()){  
                                checkitemid = Util.null2String(rs.getString("checkitemid"));
                                String checkitemproportion = Util.null2String(rs.getString("checkitemproportion"));
                               
                                isLight = !isLight ; 
                       
                        %>
                   
                    
                    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
                        <TD class=Field width=100> 
                        <%=Util.toScreen(CheckComInfo.getCheckName(checkitemid),user.getLanguage())%>
                        </TD>
                        <TD class=Field width=100> 
                        <%=Util.toScreen(CheckComInfo.getCheckItemExplain(checkitemid),user.getLanguage())%>
                        </TD>
                        <%
                        int checkitemidindex = checkitemids.indexOf( checkitemid ) ;
                        if(checkitemidindex != -1) 
                        result = (String)results.get( checkitemidindex ) ;

                        
                       if(nowdate.compareTo(enddate) <=0) {
                        %>
                            
                        <TD class=Field>
	                        <input class=inputstyle type=text maxlength="30" style="width:60%" name="result_<%=checkitemid%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("result_<%=checkitemid%>");check(this);checkinput("result_<%=checkitemid%>","result_<%=checkitemid%>span");' value="<%=result%>"
	                         onchange='checkinput("result_<%=checkitemid%>","result_<%=checkitemid%>span");' title="<%=SystemEnv.getHtmlLabelName(83390,user.getLanguage())%>">
                       	 <SPAN id=result_<%=checkitemid%>span>
													<%
													  if(result.equals("")) {
													%>
													    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
													<%
													  }
													%>
												  </SPAN>
                        </TD>
                        <%
                        }else{
                        %>
                        <TD class=Field>
	                        <%=result %>
                        </TD>
                        <%
                        }
                        %>
                        <TD>
                            <%=checkitemproportion%>%
                        </TD>
                    </tr> 
                    <%       
                       }
                           
                    %>  
                </tbody>
            </table>
 </form>
   <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
<script language=javascript>
function onDelete(){
if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
document.HrmCheckMark.operation.value="delete";
document.HrmCheckMark.submit();
}
}

function check(obj){
	if(obj){
		var value = parseFloat(obj.value);
		if(value > 5 || value < 0){
			obj.value = "";
		}
	}
}

function doBack(){
	location ="/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>";
}

function submitData() {
 var flag = true;
 jQuery("#hrmcheckkind").find("input[name^=result]").each(function(){
 	 if(jQuery(this).val()==""){
 	 	flag = false;
 	 	return;
 	 }
 })
 if(!flag){
 	window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>')
 	return;
 }
 if(check_form(HrmCheckMark,'result')){
 	HrmCheckMark.submit();
 }
}
</script>
</BODY>
</HTML>