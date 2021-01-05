<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
</HEAD>
<%
String wfid = Util.null2String(request.getParameter("wfid"));
String formid = Util.null2String(request.getParameter("billid"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
int tabletype = Util.getIntValue(Util.null2String(request.getParameter("tabletype")),0);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
boolean hasSqlwhere = false;
if("".equals(sqlwhere) && !"".equals(wfid)){
	hasSqlwhere = false;
}else{
	hasSqlwhere = true;
}
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasSqlwhere == false){
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="searchDetailedField.jsp" method=post>
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<%if(hasSqlwhere == false){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item><input name=fieldname class="InputStyle" value='<%=fieldname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26734, user.getLanguage())%></wea:item>
		<wea:item>
			<select id="tabletype" name="tabletype">
				<option value=0 <%if(tabletype==0){%>selected<%}%>></option>
				<option value=1 <%if(tabletype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
				<option value=2 <%if(tabletype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>
			</select>		
		</wea:item>
		<%}%>
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE ID=BrowseTable class="ListStyle" cellspacing="0" width="100%">
			<TR class=header>
			<TH width=50%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TH>
			<TH width=50%><%=SystemEnv.getHtmlLabelName(26734, user.getLanguage())%></TH>
			</TR>
			<%
			int i=0;
			String sql = "";
			String isbill = "";
			
			if(hasSqlwhere == false){
				RecordSet.executeSql("select formid,isbill from workflow_base where id="+wfid);
				if(RecordSet.next()){
					formid = RecordSet.getString("formid");
					isbill = RecordSet.getString("isbill");
				}
				if(isbill.equals("0")){//表单
						sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder, '' as description, a.groupid as optionkey from workflow_formfield a, workflow_fieldlable b "+
						      " where a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage();
						if(tabletype==1) sql += " and a.isdetail is null ";
						if(tabletype==2) sql += " and a.isdetail=1 ";
						if(!fieldname.equals("")) sql += " and b.fieldlable like '%"+fieldname+"%' ";
					if(RecordSet.getDBType().equals("oracle")){
						sql += " order by a.isdetail desc,optionkey asc,a.fieldorder asc ";
					}else{    
						sql += " order by a.isdetail,optionkey,a.fieldorder ";
					}
				}else if(isbill.equals("1")){//单据
					sql = "select id as fieldid,fieldlabel,viewtype as isdetail,dsporder as fieldorder, '' as description, detailtable as optionkey from workflow_billfield where billid="+formid;
					if(tabletype==1) sql += " and viewtype=0";
					if(tabletype==2) sql += " and viewtype=1";
					sql += " order by viewtype,optionkey,dsporder";
				}
			}else{
				isbill = Util.null2o(request.getParameter("isbill"));
				int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
				if("1".equals(isbill)){
					if(isdetail == 0){
						sql = "select id as fieldid, fieldlabel, 0 as isdetail, 0 as fieldorder, '' as description, '' as optionkey from workflow_billfield where viewtype=1 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid;
					}else{
						sql = "select id as fieldid, fieldlabel, 1 as isdetail, 0 as fieldorder, '' as description, '' as optionkey from workflow_billfield where viewtype=1 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid;
					}
				}else{
					if(isdetail == 0){
						sql = "select id as fieldid, fieldname as fieldlable, 0 as isdetail, 0 as fieldorder, description, '' as optionkey from workflow_formdict "+sqlwhere;
					}else{
						sql = "select id as fieldid, fieldname as fieldlable, 1 as isdetail, 0 as fieldorder, description, '' as optionkey from workflow_formdictdetail "+sqlwhere;
					}
				}
				sql += " order by id";
			}
			String mainOption = "";
			String optionsql = "";
			Hashtable detailOption = new Hashtable();
			if(hasSqlwhere == false){
			if(isbill.equals("0")){//表单主字段
			    optionsql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "+
			          " where a.isdetail is null and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage();
			    if(RecordSet.getDBType().equals("oracle")){
			        optionsql += " order by a.isdetail desc,a.fieldorder asc ";
			    }else{    
			        optionsql += " order by a.isdetail,a.fieldorder ";
			    }
			}else if(isbill.equals("1")){//单据主字段
			    optionsql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=0 and billid="+formid;
			    optionsql += " order by viewtype,dsporder";
			}
			rs.executeSql(optionsql);
			while(rs.next()){
			    String tempfieldname = "";
			    if(isbill.equals("0")) tempfieldname = rs.getString("fieldlable");
			    if(isbill.equals("1")) tempfieldname = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"), user.getLanguage());
			    mainOption += "<,option value="+rs.getString(1)+">"+tempfieldname+"</option,>";
			}
	
			if(isbill.equals("0")){
			    ArrayList detaigroupidlist = new ArrayList();
			    optionsql = "select distinct groupid from workflow_formfield where formid="+formid;
			    rs.executeSql(optionsql);
			    while(rs.next()){
			        String tempgroupid = Util.null2String(rs.getString("groupid"));
			        if(tempgroupid.equals("")) continue;
			        detaigroupidlist.add(tempgroupid);
			    }
			    for(int j=0;j<detaigroupidlist.size();j++){
			        String tempgroupid = (String)detaigroupidlist.get(j);
			        if(tempgroupid.equals("")) continue;
			        optionsql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "+
			                    " where a.isdetail=1 and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage()+" and groupid="+tempgroupid;
			        if(rs.getDBType().equals("oracle")){
			            optionsql += " order by a.isdetail desc,a.fieldorder asc ";
			        }else{    
			            optionsql += " order by a.isdetail,a.fieldorder ";
			        }
			        rs.executeSql(optionsql);
			        String wfDetailFieldsOptions = "";
			        while(rs.next()){
			            String tempfieldname = rs.getString("fieldlable");
			            wfDetailFieldsOptions += "<,option value="+rs.getString(1)+">"+tempfieldname+"</option,>";
			        }
			        detailOption.put(tempgroupid,wfDetailFieldsOptions);
			    }
			}else{
			    ArrayList detailtablelist = new ArrayList();
			    optionsql = "select distinct detailtable from workflow_billfield where billid="+formid;
			    rs.executeSql(optionsql);
			    while(rs.next()){
			        String tempdetailtable = Util.null2String(rs.getString("detailtable"));
			        if(tempdetailtable.equals("")) continue;
			        detailtablelist.add(tempdetailtable);
			    }
			    for(int j=0;j<detailtablelist.size();j++){
			        String tempdetailtable = Util.null2String((String)detailtablelist.get(j));
			        if(tempdetailtable.equals("")) continue;
			        optionsql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=1 and billid="+formid+" and detailtable='"+tempdetailtable+"'";
			        optionsql += " order by viewtype,dsporder";
			        rs.executeSql(optionsql);
			        String wfDetailFieldsOptions = "";
			        while(rs.next()){
			            String tempfieldname = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"), user.getLanguage());
			            wfDetailFieldsOptions += "<,option value="+rs.getString(1)+">"+tempfieldname+"</option,>";
			        }
			        detailOption.put(tempdetailtable,wfDetailFieldsOptions);
			    }
			}
			}
			
			//out.println("sql:"+sql);
			RecordSet.execute(sql);
			while(RecordSet.next()){
				String fieldlablename = "";
				if(isbill.equals("1")){//单据无法将字段名称作为查询条件，在这里进行处理
					fieldlablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage());
					if(!fieldname.equals("")&&fieldlablename.indexOf(fieldname)<0) continue;
				}else{
					fieldlablename = Util.null2String(RecordSet.getString("fieldlable"));
				}
				String description_tmp = Util.null2String(RecordSet.getString("description")).trim();
				if(!"".equals(description_tmp)){
					fieldlablename = description_tmp;
				}
				int id_tmp = Util.getIntValue(RecordSet.getString("fieldid"), 0);
				
				String tempoption = ","+mainOption;
				String isdetail = Util.null2String(RecordSet.getString("isdetail"));
				if(isdetail.equals("1")){
				    String optionkey = Util.null2String(RecordSet.getString("optionkey"));
				    if(!optionkey.equals("")) tempoption = ","+(String)detailOption.get(optionkey);
				}
				tempoption += ",";
				
				if(i==0){
					i=1;
			%>
			<TR class=DataLight>
			<%
				}else{
					i=0;
			%>
			<TR class=DataDark>
				<%
				}
				%>
				<TD style="display:none"><%=RecordSet.getString("fieldid")%></TD>
				<TD>
					<%=fieldlablename%>
				</TD>
				<TD>
					<%if(RecordSet.getString("isdetail").equals("1")){
							out.print(SystemEnv.getHtmlLabelName(19325,user.getLanguage()));
						}else{
							out.print(SystemEnv.getHtmlLabelName(21778,user.getLanguage()));
						}
					%>
				</TD>
				<TD style="display:none"><%if(isdetail.equals("1")){%>1<%}else{%>0<%}%></TD>
				<TD style="display:none"><%=tempoption%></TD>
			</TR>
			<%}%>
			</TABLE>		
		</wea:item>
	</wea:group>
</wea:layout>

</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>

<script language="javascript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		/* var returnjson = {
			id:$($(this).children()[0]).text(),
			name:$($(this).children()[1]).text(),
			fieldtype:$($(this).children()[3]).text(),
			options:$($(this).children()[4]).text()
		};
		*/
		var strid = $($(this).children()[0]).text();
	    var strName = $($(this).children()[1]).text();
		if(dialog){
		    //dialog.callback(returnjson);
		    parentWin.assignment(strid,strName);
		    dialog.close();
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})



function submitClear()
{
	var returnjson = {id:"",name:"",fieldtype:"",options:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.parent.returnValue  = returnjson;
	    window.parent.parent.close();
	}
}

function onClear()
{
	submitClear() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.parent.close() ;
	}	
}

</script>
</HTML>
