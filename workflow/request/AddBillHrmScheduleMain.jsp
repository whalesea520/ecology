
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>

<form name="frmmain" method="post" action="BillHrmScheduleMainOperation.jsp" enctype="multipart/form-data">
    <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>
    
    <table class=viewform>
        <tr><td height=15></td></tr>
        <tr>
            <td>
            <BUTTON Class=BtnFlow type=button accessKey=A onclick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <BUTTON Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16756,user.getLanguage())%>
            </td>
        </tr>
        <TR class=Spacing><TD class=Line1></TD></TR>
        </TR>
        <tr>
            <td>
            <%
            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }

            // 确定字段是否显示，是否可以编辑，是否必须输入
            isfieldids.clear() ;              //字段队列
            isviews.clear() ;              //字段是否显示队列
            isedits.clear() ;              //字段是否可以编辑队列
            ismands.clear() ;              //字段是否必须输入队列

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
                isedits.add(Util.null2String(RecordSet.getString("isedit")));
                ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
            }

            if( colcount != 0 ) colwidth = 95/colcount ;


    %>
            <table class=liststyle cellspacing=1 id="oTable">
              <COLGROUP> 
              <tr class=header> 
                <td width="5%">&nbsp;</td>
   <%
            ArrayList viewfieldnames = new ArrayList() ;
            
            // 得到每个字段的信息并在页面显示

            int detailfieldcount = -1 ;

            for(int i=0;i<fieldids.size();i++){         // 循环开始

                String fieldid=(String)fieldids.get(i);  //字段id
                String isview="0" ;    //字段是否显示
                String isedit="0" ;    //字段是否可以编辑
	            String ismand="0" ;    //字段是否必须输入

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
                    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
                }
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环
                
                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;                                                   
                
                fieldname=(String)fieldnames.get(i);
                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
<%          }
%>
              </tr>
            </table>
            </td>
        </tr>
    </table>
    
    <input type='hidden' id=nodesnum name=nodesnum>
	<input type="hidden" name="needwfback" id="needwfback" value="1" />
</form>

<script language=javascript>

rowindex = 0 ;
deleteindex=0;

function addRow()
{
	oRow = oTable.insertRow(-1);

    oCell = oRow.insertCell(-1); 
    oCell.style.height=24;
    oCell.style.background= "#D2D1F1";
	    
    var oDiv = document.createElement("div");
    var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'>"; 
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
<%
    for(int i=0;i<fieldids.size();i++){         // 循环开始

        String fieldhtml = "" ;
        String fieldid=(String)fieldids.get(i);  //字段id
        
        String isview="0" ;    //字段是否显示
        String isedit="0" ;    //字段是否可以编辑
        String ismand="0" ;    //字段是否必须输入

        int isfieldidindex = isfieldids.indexOf(fieldid) ;
        if( isfieldidindex != -1 ) {
            isview=(String)isviews.get(isfieldidindex);    //字段是否显示
            isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
            ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
        }
        if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环

        String fieldname = "" ;                         //字段数据库表中的字段名
        String fieldhtmltype = "" ;                     //字段的页面类型
        String fieldtype = "" ;                         //字段的类型
        String fieldlable = "" ;                        //字段显示名
        int languageid = user.getLanguage() ;
        fieldname=(String)fieldnames.get(i);
        fieldhtmltype=(String)fieldhtmltypes.get(i);
        fieldtype=(String)fieldtypes.get(i);
        
        if(ismand.equals("1"))  needcheck+=",field"+fieldid + "_" + i ;   //如果必须输入,加入必须输入的检查中

        // 下面开始逐行显示字段
        
        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(isedit.equals("1")){
                    if(ismand.equals("1")) {
                        fieldhtml = "<input type=text name='field"+fieldid+"_\"+rowindex+\"' size=50 onChange='checkinput1(field"+fieldid+"_\"+rowindex+\",field"+fieldid+"_\"+rowindex+\"span)'><span id='field"+fieldid+"_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                    }else{
                        fieldhtml = "<input type=text name='field"+fieldid+"_\"+rowindex+\"' value='' size=50>";
                    }
                }
            }
            else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                if(isedit.equals("1")){
                    if(ismand.equals("1")) {
                        fieldhtml = "<input type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);checkinput1(field"+fieldid+"_\"+rowindex+\",field"+fieldid+"_\"+rowindex+\"span)'><span id='field"+fieldid+"_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ; 
                    }else{
                        fieldhtml = "<input type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>" ;
                    }
                }
            }
            else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                if(isedit.equals("1")){
                    if(ismand.equals("1")) {
                        fieldhtml = "<input type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(field"+fieldid+"_\"+rowindex+\",field"+fieldid+"_\"+rowindex+\"span)'><span id='field"+fieldid+"_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                    }else{
                        fieldhtml = "<input type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>" ;
                    }
                }
            }
        }                                                       // 单行文本框条件结束
        else if(fieldhtmltype.equals("2")){                     // 多行文本框
            if(isedit.equals("1")){
                if(ismand.equals("1")) {
                    fieldhtml = "<textarea name='field"+fieldid+"_\"+rowindex+\"' onChange='checkinput1(field"+fieldid+"_\"+rowindex+\",field"+fieldid+"_\"+rowindex+\"span)' rows='4' cols='40' style='width:80%'></textarea><span id='field"+fieldid+"_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ; 
                }else{
                    fieldhtml = "<textarea name='field"+fieldid+"_\"+rowindex+\"' rows='4' cols='40' style='width:80%'></textarea>" ;
                }
            }
        }                                                           // 多行文本框条件结束
        else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
            String showname = "";                                   // 新建时候默认值显示的名称
            String showid = "";                                     // 新建时候默认值

            if(fieldtype.equals("8") && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值
                showid = "" + Util.getIntValue(prjid,0);
            }else if((fieldtype.equals("9") || fieldtype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值
                showid = "" + Util.getIntValue(docid,0);
            }else if((fieldtype.equals("1") ||fieldtype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值
                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldtype.equals("7") || fieldtype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值
                showid = "" + Util.getIntValue(crmid,0);
            }else if(fieldtype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)  
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if(fieldtype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldtype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);				
            }

            if(showid.equals("0")) showid = "" ;
            
            if(! showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
                String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;

                RecordSet.executeSql(sql);
                if(RecordSet.next()) {
                    if(!linkurl.equals("")) 
                    {
        				if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                    	{
                    		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
                    	}
        				else
        					showname = "<a href='"+linkurl+showid+"'>"+RecordSet.getString(1)+"</a>&nbsp";
        			}
                    else 
                        showname =RecordSet.getString(1) ;
                }
            }
            
            if(fieldtype.equals("2")){                              // 浏览按钮为日期
                showname = currentdate;
                showid = currentdate;
            }

            if(isedit.equals("1")){ 
                if( !fieldtype.equals("37") ) {    //  多文档特殊处理
                    fieldhtml = "<button class=Browser onclick=onShowBrowser('"+fieldid+"_\"+rowindex+\"','"+url+"','"+linkurl+"','"+fieldtype+"','"+ismand+"') title='"+SystemEnv.getHtmlLabelName( 172 ,user.getLanguage() )+"'></button>" ; 
                } else {                         // 如果是多文档字段,加入新建文档按钮
                    fieldhtml = "<button class=AddDocFlow onclick=onShowBrowser('"+fieldid+"_\"+rowindex+\"','"+url+"','"+linkurl+"','"+fieldtype+"','"+ismand+"')>"+SystemEnv.getHtmlLabelName( 611 ,user.getLanguage() )+"</button>&nbsp;&nbsp<button class=AddDocFlow onclick='onNewDoc("+fieldid+"_\"+rowindex+\")' title='"+SystemEnv.getHtmlLabelName( 82 ,user.getLanguage() )+"'>"+SystemEnv.getHtmlLabelName( 82 ,user.getLanguage() )+"</button>" ;
                 }
            }
            fieldhtml += "<input type=hidden name='field"+fieldid+"_\"+rowindex+\"' value='"+showid+"'><span id='field"+fieldid+"_\"+rowindex+\"span'>"+ Util.toScreen(showname,user.getLanguage()) ;
            
            if(ismand.equals("1") && showname.equals("")) {
               fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>" ; 
            }
            fieldhtml += "</span>" ; 
        }                                                       // 浏览按钮条件结束                       
        else if(fieldhtmltype.equals("4")) {                    // check框   
            fieldhtml += "<input type=checkbox value=1 name='field"+fieldid+"_\"+rowindex+\"' " ; 
            
            if(isedit.equals("0"))  fieldhtml += "DISABLED" ;  
            
            fieldhtml += ">" ;
        }                                                       // check框条件结束
        else if(fieldhtmltype.equals("5")){                     // 选择框   select
            fieldhtml += "<select name='field"+fieldid+"_\"+rowindex+\"' " ;
            if(isedit.equals("0")) fieldhtml += "DISABLED" ;
            fieldhtml += ">" ;
           
            // 查询选择框的所有可以选择的值
            char flag= Util.getSeparator() ;
            rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);  
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                fieldhtml += "<option value='"+tmpselectvalue+"'>"+tmpselectname+"</option>" ;
            }
            fieldhtml += "</select>" ;
        }                                          // 选择框条件结束 所有条件判定结束
%>
        
        oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
	    
        var oDiv = document.createElement("div");
        var sHtml = "<%=fieldhtml%>" ; 
        oDiv.innerHTML = sHtml;
        oCell.appendChild(oDiv);
<%
    }       // 循环结束
%>
        
	rowindex = rowindex*1 +1;
    document.frmmain.nodesnum.value = rowindex ;
	
}


function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
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
                        oTable.deleteRow(rowsum1);
                    }
                    rowsum1 -=1;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}	
</script> 


<script language=vbs>
sub onShowDate(spanname,inputname,ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if returndate<>"" then
	    spanname.innerHtml= returndate
        inputname.value=returndate
	else
	    if ismand = 1 then
	        spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
        else 
            spanname.innerHtml = ""
        end if
        inputname.value= ""
	end if
end sub

sub onShowFeeType(spanname,inputname,ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else 
    if ismand = 1 then
	    spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else 
        spanname.innerHtml = ""
    end if
	inputname.value=""
	end if
	end if
end sub

sub onShowCustomer(spanname,inputname,ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else 
	if ismand = 1 then
	    spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else 
        spanname.innerHtml = ""
    end if
	inputname.value=""
	end if
	end if
end sub

sub onShowProject(spanname,inputname,ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if NOT isempty(id) then
    if id(0)<> "" then
    spanname.innerHtml = id(1)
    inputname.value=id(0)
    else
    if ismand = 1 then
        spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    else 
        spanname.innerHtml = ""
    end if
    inputname.value=""
    end if
	end if
end sub
</script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
