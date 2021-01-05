<%@ page import="weaver.workflow.request.RequestConstants" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
int colsnum = 25;
int widthper = 4;
int recorderindex = 0 ;
%>
<TABLE class="ViewForm" cellPadding=0 cellSpacing=0 >
<COLGROUP>
<% 
	for(int i=0;i<colsnum;i++){
%>
  		<td width="<%=widthper%>%"></td>
<%
	}
%>

  <%//xwj for td1834 on 2005-05-22
    String isEdit_ = "-1";
    RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -1");
    if(RecordSet.next()){
   isEdit_ = Util.null2String(RecordSet.getString("isedit"));
    }
     
  %>

<!--新建的第一行，包括说明和重要性 -->
  
  <TR>
    <TD colspan=2><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class=field colspan=<%=colsnum-2%> >
     
        <%if(!"1".equals(isEdit_)){//xwj for td1834 on 2005-05-22%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
       <%}
       else{%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%}%>
     
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
    
     
      <!--add by xhheng @ 2005/01/25 for 消息提醒 Request06，流转过程中察看短信设置 -->
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%
      String sqlWfMessage = "select messageType from workflow_base where id="+workflowid;
      int wfMessageType=0;
      rs.executeSql(sqlWfMessage);
      if (rs.next()) {
        wfMessageType=rs.getInt("messageType");
      }
      if(wfMessageType == 1){
        String sqlRqMessage = "select messageType from workflow_requestbase where requestid="+requestid;
        int rqMessageType=0;
        rs.executeSql(sqlRqMessage);
        if (rs.next()) {
          rqMessageType=rs.getInt("messageType");
        }%>
        <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
        <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
        <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
      <%}%>
    </TD>
  </TR>  	   	<TR >
    <TD class="Line1" colSpan=<%=colsnum%>></TD>
  </TR>
  <!--第一行结束 -->
   
</table>
<br>
<TABLE class="ViewForm" cellPadding=0 cellSpacing=0 style="border-bottom :3 groove black;border-left :3 groove black;border-right :3 groove black;border-top :3 groove black;">
<colgroup>
<td width=1%></td>
<td width=100%></td>
<td width=1%></td>


<tr>
<td>&nbsp;</td>
<td>
<TABLE class="ViewForm" cellPadding=0 cellSpacing=1>
<COLGROUP>
<% 
	for(int i=0;i<colsnum;i++){
%>
  		<td width="<%=widthper%>%"></td>
<%
	}
%>
<%
//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）

ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldvalues=new ArrayList();          //字段的值
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)

RecordSet.executeProc("workflow_FieldID_Select",formid+"");
while(RecordSet.next()){
fieldids.add(Util.null2String(RecordSet.getString(1)));
fieldorders.add(Util.null2String(RecordSet.getString(2)));
}

RecordSet.executeProc("workflow_FieldLabel_Select",formid+"");
while(RecordSet.next()){
fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
languageids.add(Util.null2String(RecordSet.getString("languageid")));
	//out.println("<b>LANGUAGE:"+Util.null2String(RecordSet.getString("languageid"))+"</b>");
}

// 查询每一个字段的值
 RecordSet.executeProc("workflow_FieldValue_Select",requestid+"");       // 从workflow_form表中查
    RecordSet.next();
    for(int i=0;i<fieldids.size();i++){
        String fieldname=FieldComInfo.getFieldname((String)fieldids.get(i));
        fieldvalues.add(Util.null2String(RecordSet.getString(fieldname)));
    }

// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列
ArrayList isedits=new ArrayList();              //字段是否可以编辑队列
ArrayList ismands=new ArrayList();              //字段是否必须输入队列

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}

String rowCalItemStr1,colCalItemStr1,mainCalStr1;
				rowCalItemStr1 = new String("");
				colCalItemStr1 = new String("");
			
				mainCalStr1 = new String("");

				rs.executeProc("Workflow_formdetailinfo_Sel",formid+"");
				while(rs.next()){
					rowCalItemStr1 = Util.null2String(rs.getString("rowCalStr"));
					colCalItemStr1 = Util.null2String(rs.getString("colCalStr"));
					mainCalStr1 = Util.null2String(rs.getString("mainCalStr"));
                    //System.out.println("rowCalItemStr1 = " + rowCalItemStr1);
				}

                // 要进行制动获取的字段

                //autoGetIndex[0] = 1;
                //autoGetIndex[1] = 2;
                //autoGetIndex[2] = 3;
                //autoGetIndex[3] = 5;
				//Clone the ArrayList Objects
				ArrayList fieldids1 =new ArrayList(); 
				ArrayList fieldlabels1=new ArrayList();
				ArrayList fieldhtmltypes1=new ArrayList();
				ArrayList fieldtypes1=new ArrayList();
				ArrayList fieldnames1=new ArrayList();
				ArrayList fieldviewtypes1=new ArrayList();
				ArrayList isfieldids1=new ArrayList();
				ArrayList isviews1=new ArrayList();
				ArrayList isedits1=new ArrayList();
				ArrayList ismands1=new ArrayList();

			//	fieldids1 = (ArrayList)fieldids.clone();
			//	fieldlabels1=(ArrayList)fieldlabels.clone();
			//	fieldhtmltypes1=(ArrayList)fieldhtmltypes.clone();
			//	fieldtypes1=(ArrayList)fieldtypes.clone();
			//	fieldnames1=(ArrayList)fieldnames.clone();
			//	fieldviewtypes1=(ArrayList)fieldviewtypes.clone();
			//	isfieldids1=(ArrayList)isfieldids.clone();
			//	isviews1=(ArrayList)isviews.clone();
			//	isedits1=(ArrayList)isedits.clone();
			//	ismands1 =(ArrayList)ismands.clone();
				
                int colcount1 = 0;
                int colwidth1 = 0;
            //    fieldids.clear();
            //    fieldlabels.clear();
            //    fieldhtmltypes.clear();
             //   fieldtypes.clear();
             //   fieldnames.clear();
            //    fieldviewtypes.clear();


				  // 确定字段是否显示，是否可以编辑，是否必须输入
            //    isfieldids.clear();              //字段队列
            //    isviews.clear();              //字段是否显示队列
            //    isedits.clear();              //字段是否可以编辑队列
            //    ismands.clear();              //字段是否必须输入队列

				Integer language_id = new Integer(user.getLanguage());
				//System.out.println(formid+Util.getSeparator()+nodeid);
				
				
int colindex = 0;
int rowindex = 0;
int lastpty = 0;
int lastformid = 0;
String formscripts = "";
	
int thisformcols = 1;

int hasshowdetail = 0;
int showrequestname = 0;

ArrayList ptxs = new ArrayList();
ArrayList ptys = new ArrayList();
ArrayList widths = new ArrayList();
ArrayList heights = new ArrayList();

//modify by xhheng @20050302 for TD 1695
boolean isoracle = (rs.getDBType()).equals("oracle");
String sqlFormprop = "";
if (isoracle) {
  sqlFormprop = "select objtype,isdetail,objid,fieldid,attribute2,attribute1,defvalue,trunc(Round((trunc(ptx)-30)/30.0,0)*30) as ptx1,trunc(Round((trunc(pty)-30)/30.0,0)*30) as pty1,trunc(Round(trunc(width)/30.0,0)*30) as width1,trunc(Round(trunc(height)/30.0,0)*30) as height1 from workflow_formprop where formid="+formid+"order by trunc(pty),trunc(ptx)";
}else{
  sqlFormprop = "select convert(int,Round((convert(int,ptx)-30)/30.0,0)*30) as ptx1,convert(int,Round((convert(int,pty)-30)/30.0,0)*30) as pty1,convert(int,Round(convert(int,width)/30.0,0)*30) as width1,convert(int,Round(convert(int,height)/30.0,0)*30) as height1,* from workflow_formprop where formid="+formid+" order by convert(int,pty),convert(int,ptx)";
}

RecordSet.executeSql(sqlFormprop);
while(RecordSet.next()){
	if(RecordSet.getInt("objtype")==0)
		continue;
	int thisformid = Util.getIntValue(RecordSet.getString("isdetail"),0);
	
	if(thisformid!=0 && hasshowdetail != 0) {		
		continue;
	}
	
	int ptx = RecordSet.getInt("ptx1");
	int pty = RecordSet.getInt("pty1");
	int width = RecordSet.getInt("width1");
	int height = RecordSet.getInt("height1");
		
	int _bRowindexStep = 0;	
	int _eRowindexStep = 0;	
	int _eRowindexStepLast = 0;
	int _ptx0 = 0;
	int _pty0 = 0;
	int _width0 = 0;
	int _height0 = 0;
	int _arraysize = ptxs.size();	
	if(_arraysize>1){
		_ptx0 = Util.getIntValue(""+ptxs.get(_arraysize-1),0);
		_pty0= Util.getIntValue(""+ptys.get(_arraysize-1),0);
		_width0 = Util.getIntValue(""+widths.get(_arraysize-1),0);
		_height0 = Util.getIntValue(""+heights.get(_arraysize-1),0);
	}
	
	for(int i=0;i<_arraysize;i++){
		int _ptx = Util.getIntValue(""+ptxs.get(i),0);
		int _pty = Util.getIntValue(""+ptys.get(i),0);
		int _width = Util.getIntValue(""+widths.get(i),0);
		int _height = Util.getIntValue(""+heights.get(i),0);
		
		if((_pty+_height)>_pty0){
			if(_ptx>_ptx0)	_eRowindexStepLast += _width/30;	
		}
		
		if((_pty+_height)>pty){
			if(_ptx<ptx)	_bRowindexStep += _width/30;
			else		_eRowindexStep += _width/30;	
		}	
	}
	
	if(thisformid!=0 && hasshowdetail == 0){
	
		for(;rowindex<(colsnum-_eRowindexStepLast);rowindex++){
			out.print("<td></td>");
		}		
		for(int i=0;i<((pty-_pty0)/30);i++){
			out.print("</tr><tr><td colspan=\""+(colsnum-_eRowindexStepLast)+"\"></td>");
			
			colindex ++;
		}
		
		colindex ++;	
		rowindex=colsnum;
		out.print("</tr><tr height='24'><td colspan='"+colsnum+"'>");	
		
		%>
		
  <!--##############表单明细表开始-#############-->
    <%
      boolean isshowmenu=false;     //add by xhheng @20041220 for TD 1437
				//得到计算公式的字符串

		ArrayList formdetailwidths = new ArrayList();
		String sqlSelformdetailfield = "SELECT convert(int,Round(formprop.width/30.0,0)*30) as width,formfield.fieldid,formfield.fieldorder, fieldlable.fieldlable,fieldlable.langurageid, nodeform.isview,nodeform.isedit,nodeform.ismandatory, dictdetail.fieldname,dictdetail.fielddbtype,dictdetail.fieldhtmltype,dictdetail.type ";
		
		sqlSelformdetailfield += " FROM  Workflow_formfield formfield, Workflow_nodeform nodeform, Workflow_fieldlable fieldlable, Workflow_formdictdetail dictdetail ,Workflow_formprop formprop ";
		sqlSelformdetailfield += " where formfield.formid = "+formid+" and nodeform.nodeid =   "+nodeid;
		sqlSelformdetailfield += " and formfield.fieldid = nodeform.fieldid  ";
		sqlSelformdetailfield += " and formfield.fieldid = fieldlable.fieldid  ";
		sqlSelformdetailfield += " and formfield.formid = fieldlable.formid  ";
		sqlSelformdetailfield += " and formfield.fieldid = dictdetail.id  ";
		sqlSelformdetailfield += " and formfield.isdetail = '1'   ";
		sqlSelformdetailfield += " and formprop.formid = formfield.formid ";
		sqlSelformdetailfield += " and formprop.fieldid = formfield.fieldid  ";
		sqlSelformdetailfield += "  Order by formprop.ptx   ";
	
		rs.executeSql(sqlSelformdetailfield);
             //   rs.executeProc("Workflow_formdetailfield_Sel",""+formid+Util.getSeparator()+nodeid);
                while(rs.next()) {

					 if(language_id.toString().equals(Util.null2String(rs.getString("langurageid"))))
						{
						fieldids1.add(Util.null2String(rs.getString("fieldid")));
						fieldlabels1.add(Util.null2String(rs.getString("fieldlable")));
						fieldhtmltypes1.add(Util.null2String(rs.getString("fieldhtmltype")));
						fieldtypes1.add(Util.null2String(rs.getString("type")));
						isviews1.add(Util.null2String(rs.getString("isview")));
						isedits1.add(Util.null2String(rs.getString("isedit")));
            //add by xhheng @20041220 for TD 1437
            if(Util.null2String(rs.getString("isedit")).equals("1")){
              isshowmenu=true;
            }
						ismands1.add(Util.null2String(rs.getString("ismandatory")));
						fieldnames1.add(Util.null2String(rs.getString("fieldname")));
						formdetailwidths.add(Util.null2String(rs.getString("width")));
						colcount1 ++ ;
						}
                }
				//	out.println("size:"+fieldids.size());
                //for (int i = 0; i < autoGetIndex.length; i++) {
                //    autoGetDataId += "-" + fieldids.get(autoGetIndex[i]);
                //}
               
               

				//System.out.println("colcount1 = "+colcount1);
                if (colcount1 != 0) {

					colwidth1 = 95 / colcount1;
            %>
 <table class=form>
        <% if( isshowmenu ) { //modify by xhheng @20041220 for TD 1437%>
        <tr>
            <td>
            <BUTTON Class=Btn type=button accessKey=A onclick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></BUTTON>
            <BUTTON Class=Btn type=button accessKey=E onclick="if(isdel()){deleteRow1();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON>
            </td>
        </tr>
        <%  } %>
        <tr>
            <td>

            <table Class=ListStyle id="oTable" >
              <COLGROUP>
              <TBODY>
              <tr class=header>
                <td width="5%">&nbsp;</td>
   <%

       // 得到每个字段的信息并在页面显示

       int detailfieldcount = -1;

       for (int i = 0; i < fieldids1.size(); i++) {         // 循环开始

          String fieldid=(String)fieldids1.get(i);  //字段id
		  String isview=(String)isviews1.get(i);     //字段是否显示
		  String isedit=(String)isedits1.get(i);   //字段是否可以编辑
		  String ismand=(String)ismands1.get(i);   //字段是否必须输入
		  String fieldlable =(String)fieldlabels1.get(i);
		  String fieldname = (String)fieldnames1.get(i);
		  String fieldhtmltype = (String) fieldhtmltypes1.get(i);
		  if( ! isview.equals("1") ) continue;  //不显示即进行下一步循环

		int _widthdetail = Util.getIntValue((String)formdetailwidths.get(i),0);
		colwidth1 = (_widthdetail*10)/75;
   %>
                <td width="<%=colwidth1%>%" nowrap><%=fieldlable%></td>
           <%
       }
%>
              </tr>
              <%

    int countaccessory = 0 ;
    boolean isttLight = false;
    rs.executeSql(" select * from Workflow_formdetail where requestid ="+requestid );

    while(rs.next()) {
        isttLight = !isttLight ;
%>
<TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
<!--modify by xhheng @20041220 for TD 1437-->
<td width="5%">
  <% if( isshowmenu ) { %>
    <input type='checkbox' name='check_node' value='<%=recorderindex%>'>
  <% } else { %>
    &nbsp;
  <% } %>
</td>
        <%
        for(int i=0;i<fieldids1.size();i++){         // 循环开始

           String fieldid=(String)fieldids1.get(i);  //字段id
		  String isview=(String)isviews1.get(i);     //字段是否显示
		  String isedit=(String)isedits1.get(i);   //字段是否可以编辑
		  String ismand=(String)ismands1.get(i);   //字段是否必须输入
		  String fieldlable =(String)fieldlabels1.get(i);
		  String fieldname = (String)fieldnames1.get(i);
		  String fieldhtmltype = (String) fieldhtmltypes1.get(i);

          String fieldtype=(String)fieldtypes1.get(i);
		  String fieldvalue =  Util.null2String(rs.getString(fieldname)) ;

            if( ! isview.equals("1") ) {
%>
<input type=hidden name="field<%=fieldid%>_<%=recorderindex%>" value="<%=fieldvalue%>">
                <%
            }
            else {
                if(ismand.equals("1"))  needcheck+= ",field"+fieldid+"_"+recorderindex;
                //如果必须输入,加入必须输入的检查中
%>
<td class=field nowrap style="TEXT-VALIGN: center">
			<div>
                      <%
                if(fieldhtmltype.equals("1")){                          // 单行文本框
                    if(fieldtype.equals("1")){                          // 单行文本框中的文本
                        if(isedit.equals("1") && isremark==0 ){
                            if(ismand.equals("1")) {
                      %>
                      <input datatype="text" type=text name="field<%=fieldid%>_<%=recorderindex%>" size=10 value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkinput('field<%=fieldid%>_<%=recorderindex%>','field<%=fieldid%>_<%=recorderindex%>span')">
                      <span id="field<%=fieldid%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                      <%

                            }else{%>
                            <input datatype="text" type=text name="field<%=fieldid%>_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" size=10>
                      <%            }
                        }
                        else {
                      %>
                        <%=Util.toScreen(fieldvalue,user.getLanguage())%>
                        <input type=hidden name="field<%=fieldid%>_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
                      <%
                        }
                    }
                    else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                        if(isedit.equals("1") && isremark==0 ){
                            if(ismand.equals("1")) {
                      %>
                      <input datatype="int" type=text name="field<%=fieldid%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>"
                      onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>_<%=recorderindex%>','field<%=fieldid%>_<%=recorderindex%>span');calSum()">
                      <span id="field<%=fieldid%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                       <%

                            }else{%>
                            <input datatype="int" type=text name="field<%=fieldid%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);calSum()'>
                       <%           }
                        }
                        else {
                       %>
                        <%=fieldvalue%><input type=hidden name="field<%=fieldid%>_<%=recorderindex%>" value="<%=fieldvalue%>">
                      <%
                        }
                    }
                    else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                        if(isedit.equals("1") && isremark==0 ){
                            if(ismand.equals("1")) {
                      %>
                      <input datatype="float" type=text name="field<%=fieldid%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>"
                      onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('field<%=fieldid%>_<%=recorderindex%>','field<%=fieldid%>_<%=recorderindex%>span');calSum()">
                      <span id="field<%=fieldid%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                       <%
                            }else{%>
                            <input  datatype="float" type=text name="field<%=fieldid%>_<%=recorderindex%>" size=10 value="<%=fieldvalue%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this);calSum()'>
                       <%           }
                        }
                        else {
                       %>
                        <%=fieldvalue%><input type=hidden name="field<%=fieldid%>_<%=recorderindex%>" value="<%=fieldvalue%>">
                      <%
                        }
                    }
                }                                                       // 单行文本框条件结束
                else if(fieldhtmltype.equals("2")){                     // 多行文本框
                    if(isedit.equals("1") && isremark==0 ){
                        if(ismand.equals("1")) {
                      %>
                      <textarea name="field<%=fieldid%>_<%=recorderindex%>"  onChange="checkinput('field<%=fieldid%>_<%=recorderindex%>','field<%=fieldid%>_<%=recorderindex%>span')"
                      rows="4" cols="40" style="width:80%" ><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
                      <span id="field<%=fieldid%>_<%=recorderindex%>span"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                       <%
                        }else{
                       %>
                       <textarea name="field<%=fieldid%>_<%=recorderindex%>" rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
                       <%       }
                    }
                    else {
                       %>
                        <%=Util.toScreen(fieldvalue,user.getLanguage())%>
                        <input type=hidden name="field<%=fieldid%>_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
                      <%
                    }
                }                                                           // 多行文本框条件结束
                else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                    String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
                    String showname = "";                                                   // 值显示的名称
                    String showid = "";                                                     // 值

                    //add by wang jinyong
                    HashMap temRes = new HashMap();

                    // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
                    if( fieldtype.equals("37") && fieldid.equals(docfileid) && !newdocid.equals("")) {
                        if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                        fieldvalue += newdocid ;
                    }

                    if(fieldtype.equals("2") ||fieldtype.equals("19")  )    showname=fieldvalue; // 日期时间
                    else if(!fieldvalue.equals("")) {
                        String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                        String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                        String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段

                        if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("57")||fieldtype.equals("65")) {    // 多人力资源,多客户,多会议，多文档
                            sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                        }
                        else {
                            sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                        }

                        RecordSet rs3 = new RecordSet() ;
                        rs3.executeSql(sql);
                        while(rs3.next()){
                            showid = Util.null2String(rs3.getString(1)) ;
                            String tempshowname= Util.toScreen(rs3.getString(2),user.getLanguage()) ;
                            if(!linkurl.equals("")){
                                //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                                if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                {
                                	temRes.put(String.valueOf(showid),"<a href='javaScript:openhrm("+showid+");' onclick='pointerXY(event);'>"+tempshowname+"</a> ");
                                }
                                else
                                	temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                            }else{
                                //showname += tempshowname ;
                                temRes.put(String.valueOf(showid),tempshowname);
                            }
                        }


                        StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                        String temstkvalue = "";
                        while(temstk.hasMoreTokens()){
                            temstkvalue = temstk.nextToken();
                         
                            if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                                showname += temRes.get(temstkvalue);
                            }
                        }
                    }

                    //add by dongping
                    //永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表
                    if (fieldtype.equals("118")) {
                        showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>"+SystemEnv.getHtmlLabelName(2193, user.getLanguage())+"</a>" ;
                        //showid = "<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>查看会议室使用情况</a>";
                    }

                    if(isedit.equals("1") && isremark==0 ){
                        if( !fieldtype.equals("37") ) {    //  多文档特殊处理
                      %>
                      <button class=Browser onclick="onShowBrowser2('<%=fieldid%>_<%=recorderindex%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())%>"></button>
                       <%       } else {                         // 如果是多文档字段,加入新建文档按钮
                       %>
                       <button class=AddDoc onclick="onShowBrowser2('<%=fieldid%>_<%=recorderindex%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" > <%=SystemEnv.getHtmlLabelName(83476,user.getLanguage())%></button>&nbsp;&nbsp;<button class=AddDoc onclick="onNewDoc('<%=fieldid%>_<%=recorderindex%>')" title="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%></button>
                       <%       }
                    }
                       %>
                       <span id="field<%=fieldid%>_<%=recorderindex%>span"><%=showname%>
                       <%
                    if( ismand.equals("1") && fieldvalue.equals("") ){
                       %>
                       <img src="/images/BacoError_wev8.gif" align=absmiddle>
                       <%
                    }
                       %>
                       </span> <input type=hidden name="field<%=fieldid%>_<%=recorderindex%>" value="<%=fieldvalue%>">
                       <%
                }                                                       // 浏览按钮条件结束
                else if(fieldhtmltype.equals("4")) {                    // check框
                       %>
                       <input type=checkbox value=1 name="field<%=fieldid%>_<%=recorderindex%>" <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%>  <%if(fieldvalue.equals("1")){%> checked <%}%> >
                       <%
                    if( isedit.equals("0") || isremark==1 ){
                       %>
                       <input type= hidden name="field<%=fieldid%>_<%=recorderindex%>" value="<%=fieldvalue%>">
                       <%
                    }
                }                                                       // check框条件结束
                else if(fieldhtmltype.equals("5")){                     // 选择框   select
                       %>
                       <select name="field<%=fieldid%>_<%=recorderindex%>" <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%> >
                       <%
                    // 查询选择框的所有可以选择的值
                    RecordSet rstmp = new RecordSet();
                    
                    rstmp.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
                    while(rstmp.next()){
                        String tmpselectvalue = Util.null2String(rstmp.getString("selectvalue"));
                        String tmpselectname = Util.toScreen(rstmp.getString("selectname"),user.getLanguage());
                       %>
                       <option value="<%=tmpselectvalue%>" <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
                       <%
                    }
                       %>
                       </select>
                       <%
                    if( isedit.equals("0") || isremark==1 ) {
                       %>
                       <input type= hidden name="field<%=fieldid%>_<%=recorderindex%>" value=<%=fieldvalue%>>
                       <%
                    }
                }                                          // 选择框条件结束 所有条件判定结束
                       %>
					   </div>
                       </td>
                <%
            }
        }
        recorderindex ++ ;
%>
</tr>
        <%          }   %>

        <TFOOT>
        <TR class=header>
        <TD ><%=SystemEnv.getHtmlLabelName(358, user.getLanguage())%></TD>
<%
    for (int i = 0; i < fieldids1.size(); i++) {
        if (!isviews1.get(i).equals("1")) {
%>
<td width="<%=colwidth1%>%" id="sum<%=fieldids1.get(i)%>" style="display:none"></td>
<input type="hidden" name="sumvalue<%=fieldids1.get(i)%>" >
            <%
        } else {
            %>
            <td width="<%=colwidth1%>%" id="sum<%=fieldids1.get(i)%>" ></td>
            <input type="hidden" name="sumvalue<%=fieldids1.get(i)%>" >
                    <%
        }
    }
                    %>
                    </TR>
                    </TFOOT>
                    </table>
                    </td>
                    </tr>
</table>
<input type='hidden' name=colcalnames value="<%=colCalItemStr1%>">
<input type='hidden' id=nodesnum name=nodesnum value="<%=recorderindex%>">

<!-- modify by xhheng @20050323 for TD 1703-->
<INPUT type="hidden" name="needcheck" value="<%=needcheck%>">		<!--the need check html object name-->


<script language=javascript>

insertindex=<%=recorderindex%>;
deleteindex=0;
deletearray = new Array() ;
thedeletelength=0;

function addRow()
{
oRow = oTable.insertRow(curindex+1);

oCell = oRow.insertCell(-1);
oCell.style.height=24;
oCell.style.background= "#D2D1F1";

var oDiv = document.createElement("div");
var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'>";
oDiv.innerHTML = sHtml;
oCell.appendChild(oDiv);

<%
    needcheck="";
    for(int i=0;i<fieldids1.size();i++){         // 循环开始

        String fieldhtml = "" ;
        String fieldid=(String)fieldids1.get(i);  //字段id


        String isview=(String)isviews1.get(i);     //字段是否显示
	    String isedit=(String)isedits1.get(i);   //字段是否可以编辑
	    String ismand=(String)ismands1.get(i);   //字段是否必须输入

        if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环

        String fieldname = "" ;                         //字段数据库表中的字段名
        String fieldhtmltype = "" ;                     //字段的页面类型
        String fieldtype = "" ;                         //字段的类型
        String fieldlable = "" ;                        //字段显示名
        int languageid = user.getLanguage() ;
        fieldname=(String)fieldnames1.get(i);
        fieldhtmltype=(String)fieldhtmltypes1.get(i);
        fieldtype=(String)fieldtypes1.get(i);

        if (ismand.equals("1")) 
          needcheck += ",field" + fieldid + "_\"+rowindex+\"";   //如果必须输入,加入必须输入的检查中

        // 下面开始逐行显示字段

        if(fieldhtmltype.equals("1")){                          // 单行文本框
            if(fieldtype.equals("1")){                          // 单行文本框中的文本
                if(isedit.equals("1")){
                    if(ismand.equals("1")) {
                        fieldhtml = "<input datatype='text' type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onChange='checkinput1(field"+fieldid+"_\"+rowindex+\",field"+fieldid+"_\"+rowindex+\"span)'><span id='field"+fieldid+"_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                    }else{
                        fieldhtml = "<input datatype='text' type=text name='field"+fieldid+"_\"+rowindex+\"' value='' size=10>";
                    }
                }else{
                    fieldhtml = "<span id='fieldspan"+fieldid+"_\"+rowindex+\"'> </span>";
                    fieldhtml += "<input type=hidden name='field"+fieldid+"_\"+rowindex+\"'>";
                }
            }
            else if(fieldtype.equals("2")){                     // 单行文本框中的整型
                if(isedit.equals("1")){
                    if(ismand.equals("1")) {
                        fieldhtml = "<input  datatype='int' type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);checkinput1(field"+fieldid+"_\"+rowindex+\",field"+fieldid+"_\"+rowindex+\"span);calSum()'><span id='field"+fieldid+"_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                    }else{
                        fieldhtml = "<input datatype='int' type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);calSum()'>" ;
                    }
                }else{
                    fieldhtml = "<span id='fieldspan"+fieldid+"_\"+rowindex+\"'> </span>";
                    fieldhtml += "<input type=hidden name='field"+fieldid+"_\"+rowindex+\"'>";
                }
            }
            else if(fieldtype.equals("3")){                     // 单行文本框中的浮点型
                if(isedit.equals("1")){
                    if(ismand.equals("1")) {
                        fieldhtml = "<input datatype='float' type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(field"+fieldid+"_\"+rowindex+\",field"+fieldid+"_\"+rowindex+\"span);calSum()'><span id='field"+fieldid+"_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>" ;
                    }else{
                        fieldhtml = "<input datatype='float' type=text name='field"+fieldid+"_\"+rowindex+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);calSum()'>" ;
                    }
                }else{
                    fieldhtml = "<span id='fieldspan"+fieldid+"_\"+rowindex+\"'> </span>";
                    fieldhtml += "<input type=hidden name='field"+fieldid+"_\"+rowindex+\"'>";
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
            }else{
                fieldhtml = "<span id='fieldspan"+fieldid+"_\"+rowindex+\"'> </span>";
                fieldhtml += "<input type=hidden name='field"+fieldid+"_\"+rowindex+\"'>";
            }
        }                                                           // 多行文本框条件结束
        else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url

            if(isedit.equals("1")){
                if (!fieldtype.equals("37")) {    //  多文档特殊处理
                    fieldhtml = "<button class=Browser onclick=\\\"onShowBrowser2('" + fieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
                } else {                         // 如果是多文档字段,加入新建文档按钮
                    fieldhtml = "<button class=AddDoc onclick=\\\"onShowBrowser2('" + fieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\">" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>&nbsp;&nbsp<button class=AddDoc onclick=\\\"onNewDoc('" + fieldid + "_\"+rowindex+\"')\\\" title='" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "'>" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "</button>";
                }
            }
            fieldhtml += "<input type=hidden name='field"+fieldid+"_\"+rowindex+\"' value=''><span id='field"+fieldid+"_\"+rowindex+\"span'>" ;

            if(ismand.equals("1")) {
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
            rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+Util.getSeparator()+isbill);
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
    if ("<%=needcheck%>" != ""){
        document.getElementById("needcheck").value += "<%=needcheck%>";
    }

    rowindex = rowindex*1 +1;
    curindex = curindex*1 +1;
    document.frmmain.nodesnum.value = rowindex ;

}

function toInt(str , def) {
    if(isNaN(parseInt(str))) return def ;
    else return str ;
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
                oTable.deleteRow(rowsum1);
				curindex--;
            }
            rowsum1 -=1;
        }
    }
}

</script>

<SCRIPT LANGUAGE="VBS">
sub onShowBrowser2(id,url,linkurl,type1,ismand)
    if type1= 2 or type1 = 19 then
        id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
        document.getElementById("field"+id+"span").innerHtml = id1
        document.getElementById("field"+id).value=id1
    else
        if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
            id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.getElementById("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
        else
            tmpids = document.getElementById("field"+id).value
            id1 = window.showModalDialog(url&"?resourceids="&tmpids)
        end if
        if NOT isempty(id1) then
            if type1 = 17 or type1 = 18 or type1=27 or type1=37 then
                if id1(0)<> ""  and id1(0)<> "0" then
                    resourceids = id1(0)
                    resourcename = id1(1)
                    sHtml = ""
                    resourceids = Mid(resourceids,2,len(resourceids))
                    document.getElementById("field"+id).value= resourceids
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
                    
                    document.getElementById("field"+id+"span").innerHtml = sHtml

                else
                    if ismand=0 then
                        document.getElementById("field"+id+"span").innerHtml = empty
                    else
                        document.getElementById("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                    end if
                    document.getElementById("field"+id).value=""
                end if

            else
               if  id1(0)<>""   and id1(0)<> "0"  then
                    if linkurl = "" then
                        document.getElementById("field"+id+"span").innerHtml = id1(1)
                    else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							document.getElementById("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							document.getElementById("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
						end if
                    end if
                    document.getElementById("field"+id).value=id1(0)
                else
                    if ismand=0 then
                        document.getElementById("field"+id+"span").innerHtml = empty
                    else
                        document.getElementById("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                    end if
                    document.getElementById("field"+id).value=""
                end if
            end if
        end if
    end if
end sub

</script>

<%
    ArrayList rowCalAry = new ArrayList();
    ArrayList rowCalSignAry = new ArrayList();
    ArrayList colCalAry = new ArrayList();
	ArrayList mainCalAry = new ArrayList();
    ArrayList tmpAry = null;


    StringTokenizer stk = new StringTokenizer(colCalItemStr1,";");
    while(stk.hasMoreTokens()){
        colCalAry.add(stk.nextToken());
    }
	StringTokenizer stk2 = new StringTokenizer(rowCalItemStr1,";");
	//out.println(rowCalItemStr1);

	ArrayList newRowCalArray = new ArrayList();

	while(stk2.hasMoreTokens()){
		//out.println(stk2.nextToken(";"));
		rowCalAry.add(stk2.nextToken(";"));
	}
	stk2 = new StringTokenizer(mainCalStr1,";");
	while(stk2.hasMoreTokens()){
		//out.println(stk2.nextToken(";"));
		mainCalAry.add(stk2.nextToken(";"));
	}
	//out.println(mainCalStr1);

%>

<%--<iframe name=productInfo style="width:100%;height:300;display:none"></iframe>--%>
<script language="javascript">
rowindex = <%=recorderindex%> ;
curindex = <%=recorderindex%> ;

<%--added by Charoes Huang FOR Bug 625--%>
function parse_Float(i){
	try{
	    i =parseFloat(i);
		if(i+""=="NaN")
			return 0;
		else
			return i;
	}catch(e){
		return 0;
	}
}


function calSumPrice(){

    var temv1;
    //alert(rowindex);
<%
    String temStr = "";
    for(int i=0; i<rowCalAry.size(); i++){
        temStr = "";
		String calExp = (String)rowCalAry.get(i);

%>

        try{

			var i = window.event.srcElement.parentElement.parentElement.parentElement.rowIndex - 1;//只计算当前行的值

			//alert(window.event.srcElement.name);
        <%
           for(int j=0;j<fieldids1.size();j++){
				temStr = (String)fieldids1.get(j);
				int idx1 = calExp.indexOf("=");
				int idx2 = calExp.indexOf("detailfield_"+temStr);
				if(idx2<idx1){
					calExp = Util.StringReplace(calExp,"detailfield_"+temStr,"document.getElementById(\"field"+temStr+"_\"+i).value ");
				}else{
					calExp = Util.StringReplace(calExp,"detailfield_"+temStr,"parse_Float(document.getElementById(\"field"+temStr+"_\"+i).value) ");
				}		
			}
			String targetStr =calExp.substring(0,calExp.indexOf("value")-1);
			//targetStr = targetStr.substring(0,targetStr.indexOf("_"));
			out.println("var tempObjName = getObjectName("+targetStr+",\"_\")");

			out.println("if(window.event.srcElement.name.toString().indexOf(tempObjName)==-1){");
			 //update by liao dong for qc71259 in 20130906 start
            	  //如果除数为零的时候需要将Infinity去掉光标移至错误字段
            	  out.println("try{");  
            	  out.println(calExp+"; ") ;
            	 try{
             		 if(calExp.indexOf("=")>=0){
             			 String[] calSplitSign=calExp.split("=");
             			 String rightequalsmark = calSplitSign[0].replace(".innerHTML","");
             			 String leftequalsmark = calSplitSign[1].replace(".replace(/,/g,\"\"))", "").replace("parse_Float(", "").replace(".value", ""); 
             			 if(leftequalsmark.indexOf("/")>=0){
             				  String leftdivide  =leftequalsmark.split("/")[0];
             				  String rightdivide =leftequalsmark.split("/")[1];
             				  out.println(" if("+rightequalsmark+".innerHTML == \"Infinity\" || "+rightequalsmark+".innerHTML == \"-Infinity\"  || "+rightequalsmark+".innerHTML == \"NaN\"){");
             				  out.println(rightequalsmark+".innerHTML='';");
             				  String inputObj = rightequalsmark.replace("+\"span\")",")");
             				  out.println(inputObj+".value='';");
             				  out.println("return;");
             				  out.println("}");
             			 }
             		 } 
             	  }catch(Exception e){}
             	  out.println("}catch(e){");
             	  out.println("}");
            	  //end
            out.println(" if("+calExp.substring(0,calExp.indexOf("value")-1)+".datatype=='int') "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",0);else "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",3);}");
	        %>

       }catch(e){}

<%
    }
%>
}

function setProductInfo(fieldId,rowIndex,pValue){
    //alert(fieldId+"  "+pValue);
    document.getElementById("field"+fieldId+"_"+rowIndex).value=pValue;
    if(document.getElementById("fieldspan"+fieldId+"_"+rowIndex)){
        document.getElementById("fieldspan"+fieldId+"_"+rowIndex).innerHTML=pValue;
    }

}

function calMainField(){
	<%
		for(int i=0;i<mainCalAry.size();i++){
			temStr = "";
			String str2 =  mainCalAry.get(i).toString();
		    int idx = str2.indexOf("=");
			String str3 = str2.substring(0,idx);
			str3 = str3.substring(str3.indexOf("_")+1);
			String str4 = str2.substring(idx);
			str4 = str4.substring(str4.indexOf("_")+1);

	%>
		   var sum=0;
		   var temStr;
			for(i=0; i<rowindex; i++){

				try{
					temStr=document.getElementById("field<%=str4%>_"+i).value;
					if(temStr+""!=""){
						sum+=temStr*1;
					}
				}catch(e){;}
			}
			 if(document.getElementById("field<%=str3%>").datatype+''=="int")
				 document.getElementById("field<%=str3%>").value=toPrecision(sum,0);
			  else
				 document.getElementById("field<%=str3%>").value=toPrecision(sum,3);



	<%
	}
	%>

}
function calSum(){

    calSumPrice();

    var sum=0;
    var temStr;
<%
    for(int i=0; i<colCalAry.size(); i++){
        temStr = "";
		String str = colCalAry.get(i).toString();
		str = str.substring(str.indexOf("_")+1);
%>
    sum=0;
    for(i=0; i<rowindex; i++){

        try{
            temStr=document.getElementById("field<%=str%>_"+i).value;
            if(temStr+""!=""){
                sum+=temStr*1;
            }
        }catch(e){;}
    }
    document.getElementById("sum<%=str%>").innerHTML=toPrecision(sum,3)+"&nbsp;"
    document.getElementById("sumvalue<%=str%>").value=toPrecision(sum,3)
<%
    }
%>
	calMainField();
}

/**
return a number with a specified precision.
*/
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	
	 //add by liaodong  for qc75759 in 2013年10月30日 start
	var returnVal = isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1;
	try{
		if(String(returnVal).indexOf("e")>=0)return returnVal;
	}catch(e){}
	var valInt = (returnVal.toString().split(".")[1]+"").length;
	if(aNumber == 0){
		return  "";
	}
	if(valInt != precision){
	    var lengInt = precision-valInt;
		//判断添加小数位0的个数
		if(lengInt == 1){
			returnVal += "0";
		}else if(lengInt == 2){
			returnVal += "00";
		}else if(lengInt == 3){
			returnVal += "000";
		}else if(lengInt < 0){
			if(precision == 1){
				returnVal += ".0";
			}else if(precision == 2){
				returnVal += ".00";
			}else if(precision == 3){
				returnVal += ".000";
			}else if(precision == 4){
				returnVal += ".0000";
			}		
		}		
	}
	return  returnVal;
	//end
}
/**

从"field142_0" 得到，field142
*/

function getObjectName(obj,indexChar){
	var tempStr = obj.name.toString();
	return tempStr.substring(0,tempStr.indexOf(indexChar)>=0?tempStr.indexOf(indexChar):tempStr.length);
}

calSum();
</script>
  <!--##############表单明细表结束-#############-->

  <%}//(colcount1 != 0)  end%>

</td>		
		
		<%
		hasshowdetail = 1;
				
		continue;
	}	
	
	int objtype = RecordSet.getInt("objtype");
	String objid=RecordSet.getString("objid");
	String fieldid = Util.null2String(RecordSet.getString("fieldid"));
	
	if(lastpty != pty){
		for(;rowindex<(colsnum-_eRowindexStepLast);rowindex++){
			out.print("<td></td>");
		}
		rowindex = 0;
		colindex ++;		
		out.print("</tr>");
	}	
	for(;colindex<(pty/30);colindex++){
		out.print("<tr height='24'>");
		for(int i=0;i<(colsnum-_bRowindexStep-_eRowindexStep);i++)
			out.print("<td></td>");
		out.print("</tr>");					
	}
	
	
	if(rowindex ==0){			
		out.print("<tr height='24' >");	
		rowindex += _bRowindexStep;
	}
	for(;rowindex<(ptx/30);rowindex++){
		out.print("<td></td>");
	}
	int _widthcols = width/30;
	rowindex += _widthcols;
	
	//print Items...
	
	String isview="0" ;    //字段是否显示
	String isedit="0" ;    //字段是否可以编辑
	String ismand="0" ;    //字段是否必须输入
	
	String fieldname = "" ;                         //字段数据库表中的字段名
	String fieldhtmltype = "" ;                     //字段的页面类型
	String fieldtype = "" ;                         //字段的类型
	String fieldlable = "" ;                        //字段显示名
	String fieldvalue = "" ;                        //字段显示名
	int languageid = 0 ;
	
	if(!fieldid.equals("")){
		int isfieldidindex = isfieldids.indexOf(fieldid) ;
		if( isfieldidindex != -1 ) {
		isview=(String)isviews.get(isfieldidindex);    //字段是否显示
		    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
		    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
		}
	  
    if( !isview.equals("1") ) continue ;           //不显示即进行下一步循环 add by xhheng @20041217 for TD 1445

		int tmpindex = fieldids.indexOf(fieldid);
		languageid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新
		fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
		fieldtype=FieldComInfo.getFieldType(fieldid);
		fieldlable=(String)fieldlabels.get(tmpindex);
		fieldname=FieldComInfo.getFieldname(fieldid);
	   	fieldvalue=(String)fieldvalues.get(tmpindex);
	   	
	   	if(fieldname.equals("manager")) {
			String tmpmanagerid = ResourceComInfo.getManagerID(""+userid);
			%>
				<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>"
			<%
			continue;
		}
		if( !isview.equals("1") ) {                              // 不显示的作为 hidden 保存信息
%>
    <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" >
<%
    }
	

		
		if(fieldname.equals("begindate")) newfromdate="field"+fieldid;      //开始日期,主要为开始日期不大于结束日期进行比较
		if(fieldname.equals("enddate")) newenddate="field"+fieldid;     //结束日期,主要为开始日期不大于结束日期进行比较

	if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
    if(fieldhtmltype.equals("1") && (fieldtype.equals("2") || fieldtype.equals("3")) && Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue = "" ;

		if(ismand.equals("1"))  needcheck+=",field"+fieldid;   //如果必须输入,加入必须输入的检查中
		
		int _tmpcols = 1;
		if(_widthcols > 4) 
			_tmpcols = 2;
		
		out.print("<td colspan='"+_tmpcols+"' rowspan='"+height/30+"'  style='border-bottom :1 groove black;border-left :1 groove black;border-top :1 groove black;'><b>"+Util.toScreen(fieldlable,languageid)+"</b></td>");		
		
		_widthcols = _widthcols-_tmpcols;
		if(_widthcols<1)
			_widthcols = 1;
			
			String _fontsize = Util.null2String(RecordSet.getString("attribute2"));
			if(!_fontsize.equals(""))				
				_fontsize = " background-color:"+_fontsize+";";	
		
		out.print("<td colspan='"+_widthcols+"'  class=field rowspan='"+height/30+"' style='"+_fontsize+"border-bottom :1 groove black;border-right :1 groove black;border-top :1 groove black;'>");
	}else
		out.print("<td colspan='"+_widthcols+"' rowspan='"+height/30+"'>");
	
	
	
	
	if(objtype == 1){ 
	String _fontsize = Util.null2String(RecordSet.getString("attribute1"));
			if(!_fontsize.equals(""))
				_fontsize = " font-size:"+_fontsize;
				String _colorbold = Util.null2String(RecordSet.getString("attribute2"));
			String _color="black";
			String _isbold = " font-weight:bold ";
			
			int tmppos = _colorbold.indexOf(":");
			if(tmppos != -1){
				_color=_colorbold.substring(0,tmppos);
				
				String _tmpstr = _colorbold.substring(tmppos);
				if(!_tmpstr.equals(":1") || _tmpstr.equals(""))
					_isbold = " font-weight:normal ";
			}
		%>
				
			
		<span style='color:<%=_color%>;<%=_fontsize%>;<%=_isbold%>'><%=Util.toHtml(RecordSet.getString("defvalue"))%></span>					
		<%
	}else if(objtype == 2){
		String _src = Util.null2String(RecordSet.getString("defvalue"));
		if(!_src.equals("")){%>
			<img src="<%=_src%>" border="<%=Util.getIntValue(RecordSet.getString("attribute1"),0)%>"  >	
		<%}
	}else if(objtype == 3){
	
		String _defvalue = fieldvalue;
		if(!isedit.equals("1") || isremark!=0){ 
      %>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%>
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
      <%
      }else if(ismand.equals("1")) {
			if(fieldtype.equals("1")){ 
		%>
			<input datatype="text" type=text class=Inputstyle name="field<%=fieldid%>" value="<%=_defvalue%>" style="width:90%" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        		<span id="field<%=fieldid%>span"><%if(_defvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
     		<%	}else if(fieldtype.equals("2")){ 	%>
			<input  datatype="int" type=text class=Inputstyle name="field<%=fieldid%>" value="<%=_defvalue%>"  style="width:90%"
			onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
			<span id="field<%=fieldid%>span"><%if(_defvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
		<%	}else if(fieldtype.equals("3")){ 	%>
			<input datatype="float" type=text class=Inputstyle name="field<%=fieldid%>"  value="<%=_defvalue%>"  style="width:90%"
			onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
			<span id="field<%=fieldid%>span"><%if(_defvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
		<%	} 	%>
		<%}else{
			if(fieldtype.equals("1")){ 
		%>
     			<input datatype="text" type=text class=Inputstyle name="field<%=fieldid%>"  value="<%=_defvalue%>"   style="width:90%">
     		<%	}else if(fieldtype.equals("2")){ 	%>
     		        <input  datatype="int" type=text class=Inputstyle name="field<%=fieldid%>"  value="<%=_defvalue%>"   style="width:90%" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
		<%	}else if(fieldtype.equals("3")){ 	%>
        		<input datatype="float" type=text class=Inputstyle name="field<%=fieldid%>"  value="<%=_defvalue%>"  style="width:90%" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
		<%	}	%>			  
      		<%}				
	}else if(objtype == 4){
		
		String _defvalue = fieldvalue;
		if(!isedit.equals("1") || isremark!=0){
      %>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%>
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
      <%			
		}else if(ismand.equals("1")) {
		%>
			<textarea class=Inputstyle name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')"
			rows="4" cols="40" style="width:90%" class=Inputstyle><%=_defvalue%></textarea>
			<span id="field<%=fieldid%>span"><%if(_defvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
		<%}else{
		%>
     			<textarea class=Inputstyle name="field<%=fieldid%>" rows="4" cols="40" style="width:90%"><%=_defvalue%></textarea>		  
      		<%}										
	}else if(objtype == 5){	
		String _defvalue = fieldvalue;
		%>		
		<select class=inputstyle  style="width:90%"  name="field<%=fieldid%>" <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%> class=Inputstyle>
		<%
		// 查询选择框的所有可以选择的值
		rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+Util.getSeparator()+isbill);
		while(rs.next()){
			String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
			String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
			%>
			<option value="<%=tmpselectvalue%>" <%if(_defvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
			<%
		}
		%>
		</select> <%
            if( isedit.equals("0") || isremark==1 ) {
       %>
        <input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
       <%
            }									
	}else if(objtype == 6){	
		String _defvalue = fieldvalue;
		%>		 
			<input type=checkbox value=1 name="field<%=fieldid%>" <%if(_defvalue.equals("1")){%> checked <%}%>  <%if(isedit.equals("0") || isremark==1 ){%> DISABLED <%}%>  >
       		 <%
            if( isedit.equals("0") || isremark==1 ){
       %>
        <input type= hidden name="field<%=fieldid%>" value="<%=fieldvalue%>">
       <%
            }										
	}else if(objtype == 7){%>
		<img src="/images/line_wev8.gif" border="0" width=100% height=24>
		<%								
	}else if(objtype == 9){
		String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl =BrowserComInfo.getLinkurl(fieldtype);   // 浏览值点击的时候链接的url
            String showname = "";                                                   // 值显示的名称
            String showid = "";                                                     // 值

            // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
            if( fieldtype.equals("37") && (fieldid+"_"+recorderindex).equals(docfileid) && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                fieldvalue += newdocid ;
            }

            if(fieldtype.equals("2") ||fieldtype.equals("19")  )	showname=fieldvalue; // 日期时间
            else if(!fieldvalue.equals("")) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段

                //add by wang jinyong
                HashMap temRes = new HashMap();

                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                rs.executeSql(sql);
                while(rs.next()){
                    showid = Util.null2String(rs.getString(1)) ;
                    String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals(""))
                    	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                        {
                        	temRes.put(String.valueOf(showid),"<a href='javaScript:openhrm("+showid+");' onclick='pointerXY(event);'>"+tempshowname+"</a> ");
                        }
                        else 
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        //showname += tempshowname ;
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();
                   
                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        showname += temRes.get(temstkvalue);
                    }
                }

            }
            if(isedit.equals("1") && isremark==0 ){
                if( !fieldtype.equals("37") ) {    //  多文档特殊处理
	   %>
        <button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
       <%       } else {                         // 如果是多文档字段,加入新建文档按钮
       %>
        <button class=AddDoc onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp;<button class=AddDoc onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
       <%       }
            }
       %>
        <span id="field<%=fieldid%>span"><%=showname%>
       <%
            if( ismand.equals("1") && fieldvalue.equals("") ){
       %>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span> <input type=hidden name="field<%=fieldid%>" value="<%=fieldvalue%>">
       <%						
	}
	%></td><%
		lastpty = pty;	
		ptxs.add(""+ptx);
		ptys.add(""+pty);
		widths.add(""+width);
		heights.add(""+height);
	}
	for(;rowindex<colsnum;rowindex++){
		out.print("<td></td>");
	}
%>
</tr>


 </table>
</td>
<td>&nbsp;</td>
</tr></table>
<%
	fieldids = fieldids1;
	fieldlabels=fieldlabels1;
	fieldhtmltypes=fieldhtmltypes1;
	fieldtypes=fieldtypes1;
	fieldnames=fieldnames1;
	fieldviewtypes=fieldviewtypes1;
	isfieldids=isfieldids1;
	isviews=isviews1;
	isedits=isedits1;
	ismands =ismands1;

%>

<input type=hidden name="requestid" value=<%=requestid%>>           <!--请求id-->
<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">       <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">                     <!--当前节点类型-->
<input type=hidden name="src">                                <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">             <!--单据id-->
<input type=hidden name=isremark>
<input type=hidden name ="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="topage" value="<%=topage%>">				<!--返回的页面-->

<script language="javascript">

function onNewDoc(fieldid) {
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldid ;
    document.frmmain.src.value='save';
    document.frmmain.submit();
}

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


function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
    if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != "")
    {
        YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
        MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
        DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
        YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
        MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
        DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
        if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
            window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
            return false;
        }
    }
    return true;
}

</script>
