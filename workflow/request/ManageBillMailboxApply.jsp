

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillMailboxApplyOperation.jsp">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
  <%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>   
  

	<table class=liststyle cellspacing=1   border=1 width="80%">
	<tr> 
      <td colspan=2 align=center bgcolor="lightblue"><b><%=SystemEnv.getHtmlLabelName(1022,user.getLanguage())%></b></td>
    </tr>  
    <tr> 
      <td colspan=2>
<b><%=SystemEnv.getHtmlLabelName(16659,user.getLanguage())%></b><p>
<%=SystemEnv.getHtmlLabelName(16660,user.getLanguage())%><p>
<b><%=SystemEnv.getHtmlLabelName(16661,user.getLanguage())%></b><p>
<%=SystemEnv.getHtmlLabelName(16662,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16663,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16664,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16665,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16666,user.getLanguage())%><p>
      </td>
    </tr>
    </table>
   
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
 
<script language=javascript>

function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else 
                return true;
            }
            }
        else
        return true;
        }
}

	
	function checktimeok(){
	if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != ""){
				YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
				MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
				DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
				YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
				MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
				DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
				// window.alert(YearFrom+MonthFrom+DayFrom);
	                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
	        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
	         return false;
	  			 }
	  }
	     return true; 
	}

	function doRemark(){
		parastr = "<%=needcheck%>" ;
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doSave(){
		parastr = "<%=needcheck%>" ;
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='save';
//			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			if(checktimeok()){
				//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
			}
		}
	}
	
	function doSubmit(){
		parastr = "<%=needcheck%>" ;
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='submit';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			if(checktimeok()){
				//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
			}
		}
	}
	function doReject(){
		document.frmmain.src.value='reject';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
        if(onSetRejectNode()){
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}
	function doReopen(){
		document.frmmain.src.value='reopen';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doDelete(){
		document.frmmain.src.value='delete';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
</script>
<script language=vbs>
sub getTheDate(inputname,spanname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
sub onShowBrowser2(id,url,linkurl,type1,ismand)
    if type1= 2 or type1 = 19 then
        id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
        document.all("field"+id+"span").innerHtml = id1
        document.all("field"+id).value=id1
    else
        if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 then
            id1 = window.showModalDialog(url)
        else
            tmpids = document.all("field"+id).value
            id1 = window.showModalDialog(url&"?resourceids="&tmpids)
        end if
        if NOT isempty(id1) then
            if type1 = 17 or type1 = 18 or type1=27 or type1=37 then
                if id1(0)<> ""  and id1(0)<> "0" then
                    resourceids = id1(0)
                    resourcename = id1(1)
                    sHtml = ""
                    resourceids = Mid(resourceids,2,len(resourceids))
                    document.all("field"+id).value= resourceids
                    resourcename = Mid(resourcename,2,len(resourcename))
                    while InStr(resourceids,",") <> 0
                        curid = Mid(resourceids,1,InStr(resourceids,",")-1)
                        curname = Mid(resourcename,1,InStr(resourcename,",")-1)
                        resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
                        resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					end if
                    wend
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					end if
                    document.all("field"+id+"span").innerHtml = sHtml

                else
                    if ismand=0 then
                        document.all("field"+id+"span").innerHtml = empty
                    else
                        document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                    end if
                    document.all("field"+id).value=""
                end if

            else
               if  id1(0)<>""   and id1(0)<> "0"  then

                    if linkurl = "" then
                        document.all("field"+id+"span").innerHtml = id1(1)
                    else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							document.all("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
						end if
                        
                    end if
                    document.all("field"+id).value=id1(0)
                else
                    if ismand=0 then
                        document.all("field"+id+"span").innerHtml = empty
                    else
                        document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                    end if
                    document.all("field"+id).value=""
                end if
            end if
        end if
    end if
end sub
</script>
</body>
</html>
