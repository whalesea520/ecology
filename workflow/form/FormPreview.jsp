<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;
String  userid = ""+user.getUID();
String isbill ="0";
String newfromdate = currentdate;
String newenddate = currentdate;
int formid = Util.getIntValue(request.getParameter("formid"),0) ;
int colsnum = 25;
int widthper = 4;
%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>

<form name="frmmain" method="post">
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
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列
ArrayList isedits=new ArrayList();              //字段是否可以编辑队列
ArrayList ismands=new ArrayList();              //字段是否必须输入队列

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
				//得到计算公式的字符串

		ArrayList formdetailwidths = new ArrayList();
		String sqlSelformdetailfield = "SELECT convert(int,Round(formprop.width/30.0,0)*30) as width,formfield.fieldid,formfield.fieldorder, fieldlable.fieldlable,fieldlable.langurageid,  dictdetail.fieldname,dictdetail.fielddbtype,dictdetail.fieldhtmltype,dictdetail.type ";
		
		sqlSelformdetailfield += " FROM  Workflow_formfield formfield,  Workflow_fieldlable fieldlable, Workflow_formdictdetail dictdetail ,Workflow_formprop formprop ";
		sqlSelformdetailfield += " where formfield.fieldid = fieldlable.fieldid  ";
		sqlSelformdetailfield += " and formfield.formid = fieldlable.formid  ";
		sqlSelformdetailfield += " and formfield.formid = "+formid;
		sqlSelformdetailfield += " and formfield.fieldid = dictdetail.id  ";
		sqlSelformdetailfield += " and formfield.isdetail = '1'   ";
		sqlSelformdetailfield += " and formprop.formid = formfield.formid ";
		sqlSelformdetailfield += " and formprop.fieldid = formfield.fieldid  ";
		sqlSelformdetailfield += "  Order by formprop.ptx   ";
	
		rs.executeSql(sqlSelformdetailfield);
             //   rs.executeProc("Workflow_formdetailfield_Sel",""+formid+Util.getSeparator()+nodeid);
                while (rs.next()) {

					 	fieldids1.add(Util.null2String(rs.getString("fieldid")));
						fieldlabels1.add(Util.null2String(rs.getString("fieldlable")));
						fieldhtmltypes1.add(Util.null2String(rs.getString("fieldhtmltype")));
						fieldtypes1.add(Util.null2String(rs.getString("type")));
						isviews1.add("1");
						isedits1.add("1");
						ismands1.add("0");
						fieldnames1.add(Util.null2String(rs.getString("fieldname")));
						formdetailwidths.add(Util.null2String(rs.getString("width")));
						colcount1 ++ ;
						
                }
				//	out.println("size:"+fieldids.size());
                //for (int i = 0; i < autoGetIndex.length; i++) {
                //    autoGetDataId += "-" + fieldids.get(autoGetIndex[i]);
                //}
                if (colcount1 != 0) {

					colwidth1 = 95 / colcount1;
            %>
 <table class=form>
        <tr><td height=15></td></tr>
        <tr>
            <td>
            <BUTTON Class=Btn type=button accessKey=A onclick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></BUTTON>
            <BUTTON Class=Btn type=button accessKey=E onclick="if(isdel()){deleteRow1();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON>

            </td>
        </tr>
        <tr>
            <td>

            <table Class=ListStyle id="oTable" >
              <COLGROUP>
              <TBODY>
              <tr class=header>
                <td width="5%">&nbsp;</td>
   <%
       ArrayList viewfieldnames = new ArrayList();

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
           viewfieldnames.add(fieldname);
   %>
                <td width="<%=colwidth1%>%" nowrap><%=fieldlable%></td>
           <%
       }
%>
              </tr>
              </TBODY>
              <TFOOT>
              <TR class=header>
                <TD ><%=SystemEnv.getHtmlLabelName(358, user.getLanguage())%></TD>
<%
    for (int i = 0; i < fieldids1.size(); i++) {
    	int _widthdetail = Util.getIntValue((String)formdetailwidths.get(i),0);
		colwidth1 = (_widthdetail*10)/75;
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
<input type='hidden' id=nodesnum name=nodesnum>

<script language=javascript>
function addRow()
{

    oRow = oTable.insertRow(curindex+1);
    oCell = oRow.insertCell();
    oCell.style.height=24;
    oCell.style.background= "#D2D1F1";
    //oCell.style.word-wrap= "normal";

    var oDiv = document.createElement("div");
    var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);

<%
    for (int i = 0; i < fieldids1.size(); i++) {         // 循环开始

        String fieldhtml = "";
        String fieldid = (String) fieldids1.get(i);  //字段id


	    String isview="1";     //字段是否显示
	    String isedit="1";   //字段是否可以编辑
	    String ismand=(String)ismands1.get(i);   //字段是否必须输入


        if (!isview.equals("1")) continue;           //不显示即进行下一步循环

        String fieldname = "";                         //字段数据库表中的字段名
        String fieldhtmltype = "";                     //字段的页面类型
        String fieldtype = "";                         //字段的类型
        String fieldlable = "";                        //字段显示名
        int languageid = user.getLanguage();
        fieldname = (String) fieldnames1.get(i);
        fieldhtmltype = (String) fieldhtmltypes1.get(i);
        fieldtype = (String) fieldtypes1.get(i);
	
       
        // 下面开始逐行显示字段

        if (fieldhtmltype.equals("1")) {                          // 单行文本框
            if (fieldtype.equals("1")) {                          // 单行文本框中的文本
                if (isedit.equals("1")) {
                    if (ismand.equals("1")) {
                        fieldhtml = "<input datatype='text' type=text name='field" + fieldid + "_\"+rowindex+\"' size=7 onChange='checkinput1(field" + fieldid + "_\"+rowindex+\",field" + fieldid + "_\"+rowindex+\"span)'><span id='field" + fieldid + "_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                    } else {
                        fieldhtml = "<input datatype='text' type=text name='field" + fieldid + "_\"+rowindex+\"' value='' size=7>";
                    }
                } else {
                    fieldhtml = "<span id='fieldspan" + fieldid + "_\"+rowindex+\"'> </span>";
                    fieldhtml += "<input type=hidden name='field" + fieldid + "_\"+rowindex+\"'>";
                }
            } else if (fieldtype.equals("2")) {              // 单行文本框中的整型
                if (isedit.equals("1")) {
                    if (ismand.equals("1")) {

                        fieldhtml = "<input datatype='int' type=text name='field" + fieldid + "_\"+rowindex+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);checkinput1(field" + fieldid + "_\"+rowindex+\",field" + fieldid + "_\"+rowindex+\"span);calSum()'><span id='field" + fieldid + "_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                    } else {

                        fieldhtml = "<input datatype='int' datatype='float' type=text name='field" + fieldid + "_\"+rowindex+\"' size=10 onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);calSum()'>";
                    }
                } else {
                    fieldhtml = "<span id='fieldspan" + fieldid + "_\"+rowindex+\"'> </span>";
                    fieldhtml += "<input type=hidden name='field" + fieldid + "_\"+rowindex+\"'>";
                }
            } else if (fieldtype.equals("3")) {                     // 单行文本框中的浮点型
                if (isedit.equals("1")) {
                    if (ismand.equals("1")) {
                        fieldhtml = "<input datetype='float' type=text name='field" + fieldid + "_\"+rowindex+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(field" + fieldid + "_\"+rowindex+\",field" + fieldid + "_\"+rowindex+\"span);calSum()'><span id='field" + fieldid + "_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                    } else {
                        fieldhtml = "<input datetype='float' type=text name='field" + fieldid + "_\"+rowindex+\"' size=10 onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);calSum()'>";
                    }
                } else {
                    fieldhtml = "<span id='fieldspan" + fieldid + "_\"+rowindex+\"'> </span>";
                    fieldhtml += "<input type=hidden name='field" + fieldid + "_\"+rowindex+\"'>";
                }
            }
        }                                                       // 单行文本框条件结束
        else if (fieldhtmltype.equals("2")) {                     // 多行文本框
            if (isedit.equals("1")) {
                if (ismand.equals("1")) {
                    fieldhtml = "<textarea name='field" + fieldid + "_\"+rowindex+\"' onChange='checkinput1(field" + fieldid + "_\"+rowindex+\",field" + fieldid + "_\"+rowindex+\"span)' rows='4' cols='40' style='width:80%'></textarea><span id='field" + fieldid + "_\"+rowindex+\"span'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                } else {
                    fieldhtml = "<textarea name='field" + fieldid + "_\"+rowindex+\"' rows='4' cols='40' style='width:80%'></textarea>";
                }
            } else {
                fieldhtml = "<span id='fieldspan" + fieldid + "_\"+rowindex+\"'> </span>";
                fieldhtml += "<input type=hidden name='field" + fieldid + "_\"+rowindex+\"'>";
            }
        }                                                           // 多行文本框条件结束
        else if (fieldhtmltype.equals("3")) {                         // 浏览按钮 (涉及workflow_broswerurl表)
            String url = BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
            String linkurl = BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
            String showname = "";                                   // 新建时候默认值显示的名称
            String showid = "";                                     // 新建时候默认值

           

            if (showid.equals("0")) showid = "";

            if (!showid.equals("")) {       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                String tablename = BrowserComInfo.getBrowsertablename(fieldtype);
                String columname = BrowserComInfo.getBrowsercolumname(fieldtype);
                String keycolumname = BrowserComInfo.getBrowserkeycolumname(fieldtype);
                String sql = "select " + columname + " from " + tablename + " where " + keycolumname + "=" + showid;

                rs.executeSql(sql);
                if (rs.next()) {
                    if (!linkurl.equals(""))
                    {
                    	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                    	{
                    		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + rs.getString(1) + "</a>&nbsp";
                    	}
                    	else
                        	showname = "<a href='" + linkurl + showid + "'>" + rs.getString(1) + "</a>&nbsp";
                    }
                    else
                        showname = rs.getString(1);
                }
            }

            if (fieldtype.equals("2")) {                              // 浏览按钮为日期
                showname = currentdate;
                showid = currentdate;
            }

            if (isedit.equals("1")) {
                //System.out.println("url = " + url);
                if (!fieldtype.equals("37")) {    //  多文档特殊处理
                    fieldhtml = "<button type='button' class=Browser onclick=\\\"onShowBrowser2('" + fieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
                } else {                         // 如果是多文档字段,加入新建文档按钮
                    fieldhtml = "<button type='button' class=AddDoc onclick=\\\"onShowBrowser2('" + fieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" + fieldtype + "','" + ismand + "')\\\">" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>&nbsp;&nbsp<button type='button' class=AddDoc onclick='onNewDoc(" + fieldid + "_\"+rowindex+\")' title='" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "'>" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "</button>";
                }
            }
            fieldhtml += "<input type=hidden name='field" + fieldid + "_\"+rowindex+\"' value='" + showid + "'><span id='field" + fieldid + "_\"+rowindex+\"span'>" + Util.toScreen(showname, user.getLanguage());

            if (ismand.equals("1") && showname.equals("")) {
                fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
            }
            fieldhtml += "</span>";
        }                                                       // 浏览按钮条件结束
        else if (fieldhtmltype.equals("4")) {                    // check框
            fieldhtml += "<input type=checkbox value=1 name='field" + fieldid + "_\"+rowindex+\"' ";

            if (isedit.equals("0")) fieldhtml += "DISABLED";

            fieldhtml += ">";
        }                                                       // check框条件结束
        else if (fieldhtmltype.equals("5")) {                     // 选择框   select
            fieldhtml += "<select name='field" + fieldid + "_\"+rowindex+\"' ";
            if (isedit.equals("0")) fieldhtml += "DISABLED";
            fieldhtml += ">";

            // 查询选择框的所有可以选择的值
            char flag = Util.getSeparator();
            rs.executeProc("workflow_SelectItemSelectByid", "" + fieldid + flag + isbill);
            while (rs.next()) {
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"), user.getLanguage());
                fieldhtml += "<option value='" + tmpselectvalue + "'>" + tmpselectname + "</option>";
            }
            fieldhtml += "</select>";
        }                                          // 选择框条件结束 所有条件判定结束
%>


        oCell = oRow.insertCell();
        oCell.style.height=24;
        oCell.style.background= "#D2D1F1";

        var oDiv = document.createElement("div");
        var sHtml = "<%=fieldhtml%>" ;
        //alert(sHtml);
        oDiv.innerHTML = sHtml;
        oCell.appendChild(oDiv);
        <%
			//System.out.println("field type:"+fieldtype);
    }       // 循环结束
%>

    rowindex = rowindex*1 +1;
    curindex = curindex*1 +1;
    document.frmmain.nodesnum.value = rowindex ;


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
        document.all("field"+id+"span").innerHtml = id1
        document.all("field"+id).value=id1
    else
        if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
            id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
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
rowindex = 0 ;
curindex = 0 ;

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
    //for( i=0; i<rowindex; i++){
        try{
			
			var i = window.event.srcElement.parentElement.parentElement.parentElement.rowIndex - 1;//只计算当前行的值
			//alert(window.event.srcElement.name);
        <%
           for(int j=0;j<fieldids1.size();j++){
				temStr = (String)fieldids1.get(j);
				int idx1 = calExp.indexOf("=");
				int idx2 = calExp.indexOf("detailfield_"+temStr);
				if(idx2<idx1){
					calExp = Util.StringReplace(calExp,"detailfield_"+temStr,"document.all(\"field"+temStr+"_\"+i).value ");
				}else{
					calExp = Util.StringReplace(calExp,"detailfield_"+temStr,"parse_Float(document.all(\"field"+temStr+"_\"+i).value) ");
				}
			
			}
			String targetStr =calExp.substring(0,calExp.indexOf("value")-1);
			//targetStr = targetStr.substring(0,targetStr.indexOf("_"));
			out.println("var tempObjName = getObjectName("+targetStr+",\"_\")");

			out.println("if(window.event.srcElement.name.toString().indexOf(tempObjName)==-1){");
               //update by liao dong for qc71259 in 20130906 start
            	 //如果除数为零的时候需要将Infinity去掉光标移至错误字段
            	 out.println("try{");  
            	 out.println(calExp+"; ");
            	 try{
             		 if(calExp.indexOf("=")>=0){
             			 String[] calSplitSign=calExp.split("=");
             			 String rightequalsmark = calSplitSign[0].replace(".innerHTML","");
             			 String leftequalsmark = calSplitSign[1].replace(".replace(/,/g,\"\"))", "").replace("parse_Float(", "").replace(".value", ""); 
             			 if(leftequalsmark.indexOf("/")>=0){
             				  String leftdivide  =leftequalsmark.split("/")[0];
             				  String rightdivide =leftequalsmark.split("/")[1];
             				  String inputObj = rightequalsmark.replace("+\"span\")",")");
             				  out.println(" if("+rightequalsmark+".innerHTML == \"Infinity\" || "+rightequalsmark+".innerHTML == \"-Infinity\" || "+rightequalsmark+".innerHTML == \"NaN\"   ){");
             				  out.println("if("+inputObj+".viewtype == 1){"); //必填
             				  out.println(rightequalsmark+".innerHTML=\"<img src='/images/BacoError_wev8.gif' align=absmiddle>\";");
             				  out.println("}else{");
             				  out.println(rightequalsmark+".innerHTML='';");
             				  out.println("}");
             				  out.println(inputObj+".value='';");
             				  out.println("return;");
             				  out.println("}");
             			 }
             		 } 
             	  }catch(Exception e){}
             	  out.println("}catch(e){");
             	  out.println("}");
            	  //end
			out.println("if("+calExp.substring(0,calExp.indexOf("value")-1)+".datatype=='int') "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",0);else "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",3);}");
	        %>

       }catch(e){}
   //}
<%
    }
%>
}

function setProductInfo(fieldId,rowIndex,pValue){
    //alert(fieldId+"  "+pValue);
    document.all("field"+fieldId+"_"+rowIndex).value=pValue;
    if(document.all("fieldspan"+fieldId+"_"+rowIndex)){
        document.all("fieldspan"+fieldId+"_"+rowIndex).innerHTML=pValue;
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
					temStr=document.all("field<%=str4%>_"+i).value;
					if(temStr+""!=""){
						sum+=temStr*1;
					}
				}catch(e){;}
			}
		
			  if(document.all("field<%=str3%>").datatype+''=="int")
				 document.all("field<%=str3%>").value=toPrecision(sum,0);
			  else
				 document.all("field<%=str3%>").value=toPrecision(sum,3);

		

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
            temStr=document.all("field<%=str%>_"+i).value;
            if(temStr+""!=""){
                sum+=temStr*1;
            }
        }catch(e){;}
    }
    document.all("sum<%=str%>").innerHTML=toPrecision(sum,3)+"&nbsp;"
    document.all("sumvalue<%=str%>").value=toPrecision(sum,3)
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

	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
}
/**

从"field142_0" 得到，field142
*/

function getObjectName(obj,indexChar){
	var tempStr = obj.name.toString();
	return tempStr.substring(0,tempStr.indexOf(indexChar)>=0?tempStr.indexOf(indexChar):tempStr.length);
}
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
	
	String isview="1" ;    //字段是否显示
	String isedit="1" ;    //字段是否可以编辑
	String ismand="0" ;    //字段是否必须输入
	
	String fieldname = "" ;                         //字段数据库表中的字段名
	String fieldhtmltype = "" ;                     //字段的页面类型
	String fieldtype = "" ;                         //字段的类型
	String fieldlable = "" ;                        //字段显示名
	int languageid = 0 ;
	
	if(!fieldid.equals("")){
		int isfieldidindex = isfieldids.indexOf(fieldid) ;
		if( isfieldidindex != -1 ) {
		isview=(String)isviews.get(isfieldidindex);    //字段是否显示
		    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
		    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
		}
	
		if( !isview.equals("1") ) continue ;           //不显示即进行下一步循环
	
	
		int tmpindex = fieldids.indexOf(fieldid);
		languageid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新
		fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
		fieldtype=FieldComInfo.getFieldType(fieldid);
		fieldlable=(String)fieldlabels.get(tmpindex);
		fieldname=FieldComInfo.getFieldname(fieldid);
	
		if(fieldname.equals("manager")) {
			String tmpmanagerid = ResourceComInfo.getManagerID(""+userid);
			%>
				<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>"
			<%
			continue;
		}
		if(fieldname.equals("begindate")) newfromdate="field"+fieldid;      //开始日期,主要为开始日期不大于结束日期进行比较
		if(fieldname.equals("enddate")) newenddate="field"+fieldid;     //结束日期,主要为开始日期不大于结束日期进行比较

		
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
	
		String _defvalue = RecordSet.getString("defvalue");
		if(!isedit.equals("1")){ 
			out.print("<span>"+_defvalue+"</span>");			
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
		
		String _defvalue = RecordSet.getString("defvalue");
		if(!isedit.equals("1")){ 
			out.print("<span>"+_defvalue+"</span>");			
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
		String _defvalue = RecordSet.getString("defvalue");
		%>		
		<select class=inputstyle  style="width:90%"  name="field<%=fieldid%>" <%if(isedit.equals("0")){%> DISABLED <%}%> class=Inputstyle>
		<%
		// 查询选择框的所有可以选择的值
		char flag= Util.getSeparator() ;
		rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
		while(rs.next()){
			String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
			String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
			%>
			<option value="<%=tmpselectvalue%>" <%if(_defvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
			<%
		}
		%>
		</select>
       		<%										
	}else if(objtype == 6){	
		String _defvalue = RecordSet.getString("defvalue");
		%>		 
			<input type=checkbox value=1 name="field<%=fieldid%>" <%if(_defvalue.equals("1")){%> checked <%}%>  <%if(isedit.equals("0")){%> DISABLED <%}%>  >
       		<%										
	}else if(objtype == 7){%>
		<img src="/images/line_wev8.gif" border="0" width=100% height=24>
		<%								
	}else if(objtype == 9){
		String _defvalue = RecordSet.getString("defvalue");
		
		String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		String showname = "";                                   // 新建时候默认值显示的名称
		String showid = "";                                     // 新建时候默认值
		
		
		
		if(showid.equals("0")) showid = "" ;
		
		if(! showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;
			
			rs.executeSql(sql);
			if(rs.next()) {
				if (!linkurl.equals(""))
                {
                	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                	{
                		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + rs.getString(1) + "</a>&nbsp";
                	}
                	else
                    	showname = "<a href='" + linkurl + showid + "'>" + rs.getString(1) + "</a>&nbsp";
                }
                else
                    showname = rs.getString(1);
			}
		}
		
		if(fieldtype.equals("2")){                              // 浏览按钮为日期
			showname = currentdate;
			showid = currentdate;
		}	
		if(isedit.equals("1")){
			if( !fieldtype.equals("37") ) {    //  多文档特殊处理
		%>
				<button type='button' class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
		<%       } else {                         // 如果是多文档字段,加入新建文档按钮
		%>
				<button type='button' class=AddDoc onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button type='button' class=AddDoc onclick="onNewDoc(<%=fieldid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
		<%       }
		}
		%>
		<input type=hidden name="field<%=fieldid%>" value="<%=showid%>">
		<span id="field<%=fieldid%>span"><%=Util.toScreen(showname,user.getLanguage())%>
		<%   if(ismand.equals("1") && showname.equals("")) {
		%>
			<img src="/images/BacoError_wev8.gif" align=absmiddle>
		<%
			}
		%>
		</span>
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
</form>
<script language=javascript>

function onNewDoc(fieldid) {
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldid ;
    if(check_form(document.frmmain,'requestname')){
        document.frmmain.src.value='save';
        document.frmmain.submit();
    }
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


   
</script>