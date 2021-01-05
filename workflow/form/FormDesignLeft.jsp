
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
String strInputMainField = "";
String strInputMainInitField = "";

String strTextareaMainField = "";
String strTextareaMainInitField = "";

String strSelectMainField = "";
String strSelectMainInitField = "";

String strCheckMainField = "";
String strCheckMainInitField = "";

String strBrowserMainField = "";
String strBrowserMainInitField = "";

while(FieldComInfo.next()){
	String _fieldid = FieldComInfo.getFieldid();
	String _fieldname = FieldComInfo.getFieldname();

	if(FieldComInfo.getFieldhtmltype(_fieldid).equals("1")) {
		strInputMainField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strInputMainInitField.equals(""))	strInputMainInitField = _fieldname;
	}else if(FieldComInfo.getFieldhtmltype(_fieldid).equals("2")) {
		strTextareaMainField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strTextareaMainInitField.equals(""))	strTextareaMainInitField = _fieldname;
	}else if(FieldComInfo.getFieldhtmltype(_fieldid).equals("5")) {
		strSelectMainField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strSelectMainInitField.equals(""))	strSelectMainInitField = _fieldname;
	}else if(FieldComInfo.getFieldhtmltype(_fieldid).equals("4")) {
		strCheckMainField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strCheckMainInitField.equals(""))	strCheckMainInitField = _fieldname;
	}else if(FieldComInfo.getFieldhtmltype(_fieldid).equals("3")) {
		strBrowserMainField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strBrowserMainInitField.equals(""))	strBrowserMainInitField = _fieldname;
	}

}


String strInputDetailField = "";
String strInputDetailInitField = "";

String strTextareaDetailField = "";
String strTextareaDetailInitField = "";

String strSelectDetailField = "";
String strSelectDetailInitField = "";

String strCheckDetailField = "";
String strCheckDetailInitField = "";

String strBrowserDetailField = "";
String strBrowserDetailInitField = "";


while(DetailFieldComInfo.next()){
	String _fieldid = DetailFieldComInfo.getFieldid();
	String _fieldname = DetailFieldComInfo.getFieldname();

	if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("1")) {
		strInputDetailField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strInputDetailInitField.equals(""))	strInputDetailInitField = _fieldname;
	}else if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("2")) {
		strTextareaDetailField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strTextareaDetailInitField.equals(""))	strTextareaDetailInitField = _fieldname;
	}else if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("5")) {
		strSelectDetailField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strSelectDetailInitField.equals(""))	strSelectDetailInitField = _fieldname;
	}else if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("4")) {
		strCheckDetailField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strCheckDetailInitField.equals(""))	strCheckDetailInitField = _fieldname;
	}else if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("3")) {
		strBrowserDetailField +="tmpObj.options[i++] = new Option('"+_fieldname+"','"+_fieldid+"');";
		if(strBrowserDetailInitField.equals(""))	strBrowserDetailInitField = _fieldname;
	}

}


int formid = Util.getIntValue(request.getParameter("formid"),0) ;
String formname="";
String formdes="";

String sql = "";
String itemListOptions = "";
String itemProps = "";

String type = Util.null2String(request.getParameter("src")) ;
String isview = Util.null2String(request.getParameter("isview")) ;
if(type.equals(""))
	type = "addform";

if(!type.equals("addform")){
	FormManager.setFormid(formid);
	FormManager.getFormInfo();
	formname=FormManager.getFormname();
	formdes=FormManager.getFormdes();

	ArrayList formfieldids = new ArrayList();
	ArrayList formfieldlabels = new ArrayList();
	sql = "select * from workflow_fieldlable where formid = "+formid+" and langurageid = 7";
	rs.executeSql(sql);
	while(rs.next()){
		formfieldids.add(rs.getString("fieldid"));
		formfieldlabels.add(rs.getString("fieldlable"));
	}


	sql = "select * from workflow_formprop where formid = "+formid;
	rs.executeSql(sql);

	while(rs.next()){
		String objid = rs.getString("objid");
		String objval = rs.getString("objtype");
		String fieldlabel = "";
		String fieldid = Util.null2String(rs.getString("fieldid"));
		int _pos = formfieldids.indexOf(fieldid) ;
		if(_pos != -1)
			fieldlabel = ""+formfieldlabels.get(_pos);

		String optionname = "";

		if(objval.equals("1"))
			optionname = SystemEnv.getHtmlLabelName(22360, user.getLanguage());
		else if(objval.equals("2"))
			optionname = SystemEnv.getHtmlLabelName(74, user.getLanguage());
		else if(objval.equals("7"))
			optionname = SystemEnv.getHtmlLabelName(128026, user.getLanguage());
		else if(objval.equals("3"))
			optionname = SystemEnv.getHtmlLabelName(128146, user.getLanguage());
		else if(objval.equals("4"))
			optionname = SystemEnv.getHtmlLabelName(128148, user.getLanguage());
		else if(objval.equals("5"))
			optionname = SystemEnv.getHtmlLabelName(690, user.getLanguage());
		else if(objval.equals("6"))
			optionname = SystemEnv.getHtmlLabelName(127059, user.getLanguage());
		else if(objval.equals("9"))
			optionname = SystemEnv.getHtmlLabelName(32306, user.getLanguage());



		String isdetail = rs.getString("isdetail");
		String thisFormOptions = "";
		thisFormOptions += "<option value='0' ";
			if(!isdetail.equals("1"))
				thisFormOptions +=" selected ";
		thisFormOptions += ">"+SystemEnv.getHtmlLabelName(129060, user.getLanguage())+"</option>";
		thisFormOptions += "<option value='1' ";
			if(isdetail.equals("1"))
				thisFormOptions +=" selected ";
		thisFormOptions += ">"+SystemEnv.getHtmlLabelName(129061, user.getLanguage())+"</option>";

		if(!objval.equals("0")){
			itemProps += "<input type='hidden' name='prop_"+objval+"_"+objid+"_ptx' value='"+rs.getString("ptx")+"'>";
			itemProps += "<input type='hidden' name='prop_"+objval+"_"+objid+"_pty' value='"+rs.getString("pty")+"'>";
			itemProps += "<input type='hidden' name='prop_"+objval+"_"+objid+"_width' value='"+rs.getString("width")+"'>";
			itemProps += "<input type='hidden' name='prop_"+objval+"_"+objid+"_height' value='"+rs.getString("height")+"'>";
			itemListOptions += "<option value='"+objval+"_"+objid+"'>"+optionname+"_"+objid+"</option>";

		}

		if(objval.equals("1")){

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_1' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(345, user.getLanguage())+"</td><td><textarea name='prop_"+objval+"_"+objid+"_1'  class=Inputstyle rows=6 cols=23  onchange='changeProp(this,"+objval+","+objid+",1);'>"+rs.getString("defvalue")+"</textarea></td></tr>";
			//itemProps += "<tr id='oTr_"+objval+"_"+objid+"_2' style='display:none;'><td>"+"样式"+"</td><td><textarea name='prop_"+objval+"_"+objid+"_2'  class=Inputstyle rows=6 cols=23  onchange='changeProp(this,"+objval+","+objid+",2);'>"+rs.getString("attribute1")+"</textarea></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_2' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(16197, user.getLanguage())+"</td><td><select name='prop_"+objval+"_"+objid+"_2' style='width:100%;' onchange='changeProp(this,"+objval+","+objid+",2);'>";
			itemProps +="<option value=''></optoin>";
			itemProps +="<option value='xx-small'";
			if(rs.getString("attribute1").equals("xx-small"))
					itemProps +=" selected ";
			itemProps +=">xx-small</optoin>";
			itemProps +="<option value='x-small'";
			if(rs.getString("attribute1").equals("x-small"))
					itemProps +=" selected ";
			itemProps +=">x-small</optoin>";
			itemProps +="<option value='small'";
			if(rs.getString("attribute1").equals("small"))
					itemProps +=" selected ";
			itemProps +=">small</optoin>";
			itemProps +="<option value='medium'";
			if(rs.getString("attribute1").equals("medium"))
					itemProps +=" selected ";
			itemProps +=">medium</optoin>";
			itemProps +="<option value='large'";
			if(rs.getString("attribute1").equals("large"))
					itemProps +=" selected ";
			itemProps +=">large</optoin>";
			itemProps +="<option value='x-large'";
			if(rs.getString("attribute1").equals("x-large"))
					itemProps +=" selected ";
			itemProps +=">x-large</optoin>";
			itemProps +="<option value='xx-large'";
			if(rs.getString("attribute1").equals("xx-large"))
					itemProps +=" selected ";
			itemProps +=">xx-large</optoin>";

			String _colorbold = rs.getString("attribute2");
			String _color="black";
			String isbold = " checked ";

			int tmppos = _colorbold.indexOf(":");
			if(tmppos != -1){
				_color=_colorbold.substring(0,tmppos);

				String _tmpstr = _colorbold.substring(tmppos);
				if(!_tmpstr.equals(":1") || _tmpstr.equals(""))
					isbold = "";
			}


			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_3' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(495, user.getLanguage())+"</td><td><BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",3);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_3_span' id='prop_"+objval+"_"+objid+"_3_span' style='width:20;height:20;background-color:"+_color+";'>&nbsp;</span><input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 value='"+_color+"' onchange='changeProp(this,"+objval+","+objid+",3);'></td></tr>";

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_4' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(16198, user.getLanguage())+"</td><td><input type='checkbox'  class=Inputstyle name='prop_"+objval+"_"+objid+"_4' size=18  value='1' onchange='changeProp(this,"+objval+","+objid+",4);' "+isbold+"></td></tr>";

		}else if(objval.equals("2")){
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_1' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(15240, user.getLanguage())+"</td><td><input type='hidden' class=Inputstyle  name='prop_"+objval+"_"+objid+"_1' size=18 onchange='changeProp(this,"+objval+","+objid+",1);' value=\""+rs.getString("defvalue")+"\"><img src=\""+rs.getString("defvalue")+"\" border=0 height=30></td></tr>";

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_2' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(128028, user.getLanguage())+"</td><td><input type='text' class=Inputstyle  name='prop_"+objval+"_"+objid+"_2' size=18 onchange='changeProp(this,"+objval+","+objid+",2);' value='"+rs.getString("attribute1")+"'></td></tr>";
		}else if(objval.equals("3")){

			String _strFieldOption = "";

			if(!isdetail.equals("1")) {
				while(FieldComInfo.next()){
					String _fieldid = FieldComInfo.getFieldid();
					String _fieldname = FieldComInfo.getFieldname();

					if(FieldComInfo.getFieldhtmltype(_fieldid).equals("1")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}else if(isdetail.equals("1")){
				while(DetailFieldComInfo.next()){
					String _fieldid = DetailFieldComInfo.getFieldid();
					String _fieldname = DetailFieldComInfo.getFieldname();

					if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("1")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_10' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(700, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+thisFormOptions+"</select></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_1' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(229, user.getLanguage())+"</td><td><input type='text'  class=Inputstyle name='prop_"+objval+"_"+objid+"_1' size=18 onchange='changeProp(this,"+objval+","+objid+",1);' value='"+fieldlabel+"'></td></tr>";

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_2' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'>"+_strFieldOption+"</select></td></tr>";

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_3' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(19206, user.getLanguage())+"</td><td><input type='text'  class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 onchange='changeProp(this,"+objval+","+objid+",3);' value='"+rs.getString("defvalue")+"'></td></tr>";
			String _color = rs.getString("attribute2");
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_11' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(495, user.getLanguage())+"</td><td><BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;"+_color+"'>&nbsp;</span><input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='"+rs.getString("attribute2")+"' onchange='changeProp(this,"+objval+","+objid+",11);'></td></tr>";

		}else if(objval.equals("4")){

			String _strFieldOption = "";

			if(!isdetail.equals("1")) {
				while(FieldComInfo.next()){
					String _fieldid = FieldComInfo.getFieldid();
					String _fieldname = FieldComInfo.getFieldname();

					if(FieldComInfo.getFieldhtmltype(_fieldid).equals("2")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}else if(isdetail.equals("1")){
				while(DetailFieldComInfo.next()){
					String _fieldid = DetailFieldComInfo.getFieldid();
					String _fieldname = DetailFieldComInfo.getFieldname();

					if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("2")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_10' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(700, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+thisFormOptions+"</select></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_1' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(229, user.getLanguage())+"</td><td><input type='text'  class=Inputstyle name='prop_"+objval+"_"+objid+"_1' size=18 onchange='changeProp(this,"+objval+","+objid+",1);' value='"+fieldlabel+"'></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_2' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'>"+_strFieldOption+"</select></td></tr>";

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_3' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(19206, user.getLanguage())+"</td><td><input type='text'  class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 onchange='changeProp(this,"+objval+","+objid+",3);' value='"+rs.getString("defvalue")+"'></td></tr>";

			String _color = rs.getString("attribute2");
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_11' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(495, user.getLanguage())+"</td><td><BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;"+_color+"'>&nbsp;</span><input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='"+rs.getString("attribute2")+"' onchange='changeProp(this,"+objval+","+objid+",11);'></td></tr>";


		}else if(objval.equals("5")){
			String _strFieldOption = "";

			if(!isdetail.equals("1")) {
				while(FieldComInfo.next()){
					String _fieldid = FieldComInfo.getFieldid();
					String _fieldname = FieldComInfo.getFieldname();

					if(FieldComInfo.getFieldhtmltype(_fieldid).equals("5")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}else if(isdetail.equals("1")){
				while(DetailFieldComInfo.next()){
					String _fieldid = DetailFieldComInfo.getFieldid();
					String _fieldname = DetailFieldComInfo.getFieldname();

					if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("5")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_10' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(700, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+thisFormOptions+"</select></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_1' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(229, user.getLanguage())+"</td><td><input type='text'  class=Inputstyle name='prop_"+objval+"_"+objid+"_1' size=18 onchange='changeProp(this,"+objval+","+objid+",1);' value='"+fieldlabel+"'></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_2' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'>"+_strFieldOption+"</select></td></tr>";

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_3' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(19206, user.getLanguage())+"</td><td><input type='text'  class=Inputstyle name='prop_"+objval+"_"+objid+"_3' size=18 onchange='changeProp(this,"+objval+","+objid+",3);' value='"+rs.getString("defvalue")+"'></td></tr>";

			String _color = rs.getString("attribute2");
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_11' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(495, user.getLanguage())+"</td><td><BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;"+_color+"'>&nbsp;</span><input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='"+rs.getString("attribute2")+"' onchange='changeProp(this,"+objval+","+objid+",11);'></td></tr>";

		}else if(objval.equals("6")){
			String _strFieldOption = "";

			if(!isdetail.equals("1")) {
				while(FieldComInfo.next()){
					String _fieldid = FieldComInfo.getFieldid();
					String _fieldname = FieldComInfo.getFieldname();

					if(FieldComInfo.getFieldhtmltype(_fieldid).equals("4")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}else if(isdetail.equals("1")){
				while(DetailFieldComInfo.next()){
					String _fieldid = DetailFieldComInfo.getFieldid();
					String _fieldname = DetailFieldComInfo.getFieldname();

					if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("4")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}
			String bslected1[] = new String[2];
			for(int i=0;i<2;i++){
				bslected1[i] = "";
			}
			bslected1[Util.getIntValue(rs.getString("defvalue"),1)] = " selected ";

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_10' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(700, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+thisFormOptions+"</select></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_1' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(229, user.getLanguage())+"</td><td><input type='text'  class=Inputstyle name='prop_"+objval+"_"+objid+"_1' size=18 onchange='changeProp(this,"+objval+","+objid+",1);' value='"+fieldlabel+"'></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_2' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'>"+_strFieldOption+"</select></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_3' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(19206, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_3' onchange='changeProp(this,"+objval+","+objid+",3);'><option value='0' "+bslected1[0]+" >"+"不选中"+"</option><option value='1' "+bslected1[1]+" >"+"选中"+"</option></select></td></tr>";
			String _color = rs.getString("attribute2");
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_11' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(495, user.getLanguage())+"</td><td><BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;"+_color+"'>&nbsp;</span><input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='"+rs.getString("attribute2")+"' onchange='changeProp(this,"+objval+","+objid+",11);'></td></tr>";

		}else if(objval.equals("9")){
			String _strFieldOption = "";

			if(!isdetail.equals("1")) {
				while(FieldComInfo.next()){
					String _fieldid = FieldComInfo.getFieldid();
					String _fieldname = FieldComInfo.getFieldname();

					if(FieldComInfo.getFieldhtmltype(_fieldid).equals("3")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}else if(isdetail.equals("1")){
				while(DetailFieldComInfo.next()){
					String _fieldid = DetailFieldComInfo.getFieldid();
					String _fieldname = DetailFieldComInfo.getFieldname();

					if(DetailFieldComInfo.getFieldhtmltype(_fieldid).equals("3")) {
						_strFieldOption +="<option value='"+_fieldid+"' ";
						if(fieldid.equals(_fieldid))
							_strFieldOption +=" selected ";

						_strFieldOption +=">"+_fieldname+"</option>";
					}
				}
			}
			String bslected1[] = new String[2];
			for(int i=0;i<2;i++){
				bslected1[i] = "";
			}
			bslected1[Util.getIntValue(rs.getString("defvalue"),1)] = " selected ";

			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_10' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(700, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_10' onchange='changeProp(this,"+objval+","+objid+",10);'>"+thisFormOptions+"</select></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_1' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(229, user.getLanguage())+"</td><td><input type='text'  class=Inputstyle name='prop_"+objval+"_"+objid+"_1' size=18 onchange='changeProp(this,"+objval+","+objid+",1);' value='"+fieldlabel+"'></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_2' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_2' onchange='changeProp(this,"+objval+","+objid+",2);'>"+_strFieldOption+"</select></td></tr>";
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_3' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(19206, user.getLanguage())+"</td><td><select style='width:100%;' name='prop_"+objval+"_"+objid+"_3' onchange='changeProp(this,"+objval+","+objid+",3);'><option value='' "+bslected1[0]+" >"+"不默认"+"</option><option value='1' "+bslected1[1]+" >"+"默认"+"</option></select></td></tr>";
			String _color = rs.getString("attribute2");
			if(!_color.equals(""))
				_color=" background-color:"+_color;
			itemProps += "<tr id='oTr_"+objval+"_"+objid+"_11' style='display:none;'><td>"+SystemEnv.getHtmlLabelName(495, user.getLanguage())+"</td><td><BUTTON type='button' CLASS=Browser onclick='SelectColor(this,"+objval+","+objid+",11);'>&nbsp;</BUTTON><span name='prop_"+objval+"_"+objid+"_11_span' id='prop_"+objval+"_"+objid+"_11_span' style='width:20;height:20;"+_color+"'>&nbsp;</span><input type='hidden' class=Inputstyle name='prop_"+objval+"_"+objid+"_11' size=18 value='"+rs.getString("attribute2")+"' onchange='changeProp(this,"+objval+","+objid+",11);'></td></tr>";

		}
	}

}



    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
%>
<HTML xmlns:mpc>
<HEAD>
<TITLE></TITLE>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE>
    @media all
    {
	    mpc\:container {
	                    behavior:url(/htc/mpc.htc);
	                    }

	    mpc\:page {
	                    behavior:url(/htc/mpc.htc);
	                    }
    }
     H1              {
                    font: bold 18pt verdana;
                    color: navy
                    }

    P               {
                    font: 10pt verdana;
                    }
	A:link { color:#003399; text-decoration:none; }
	A:visited { color:#6699CC; text-decoration:none; }
	A:hover { text-decoration:underline; }
</STYLE>
<%if(isview.equals("1")){%>

<SCRIPT LANGUAGE="JavaScript">
window.open("FormPreview.jsp?formid=<%=formid%>", 'new_window', 'scrollbars=auto,toolbar=no,location=no,status=no,menubar=no,resizable=yes,top=0,left=0,width=800,height=600');
</script>
<%}%>
<SCRIPT LANGUAGE="JavaScript">
var formDocument = window.parent.mainFrame.document;

function addItem(objid){
	formDocument.all("objtype").value=objid;
	for(i=1;i<11;i++){
		if(i!=9)
			document.all("img_"+i).src = "/images/formdesign/"+i+".gif";
	}
	var imgid = objid*1+1;
	document.all("img_"+imgid).src = "/images/formdesign/"+imgid+"-down_wev8.gif";
}

function imgOver(imgid){
	var objid =formDocument.all("objtype").value;
	if((objid*1+1)!=imgid)
		document.all("img_"+imgid).src = "/images/formdesign/"+imgid+"-over_wev8.gif";
}

function imgOut(imgid){
	var objid =formDocument.all("objtype").value;
	if((objid*1+1)!=imgid)
		document.all("img_"+imgid).src = "/images/formdesign/"+imgid+".gif";
}

function changeProp(thisobj,objval,objid,propid){
	var desobj = formDocument.all("sItem_"+objval+"_"+objid);
	if(objval == "1") {
		if(propid == "1") {
			var _str = thisobj.innerHTML;
			var _newStr = "";
			for(i=0;i<_str.length;i++){
				if(_str.charAt(i) == '\n')
					_newStr += "<br>";
				else
					_newStr += _str.charAt(i);
			}
			desobj.innerHTML = _newStr;
		}
		if(propid == "2") {
			desobj.style.fontSize  = thisobj.value;
		}
		if(propid == "3") {
			desobj.style.color = thisobj.value;
		}
		if(propid == "4") {
			if(thisobj.checked)
				desobj.style.fontWeight = "bold";
			else
				desobj.style.fontWeight = "normal";

		}
	}else if(objval == "2") {
		if(propid == "1") {
			desobj.src = thisobj.value;
		}else if(propid == "2") {
			desobj.border = thisobj.value;
		}
	}else if(objval == "3") {
		if(propid == "1") {
			formDocument.all("sTitle_"+objval+"_"+objid).innerHTML = thisobj.value;
		}else if(propid == "2") {
				tmpName = "";
				for (i=0; i< thisobj.options.length; i++){
					if(thisobj.options(i).value == thisobj.value)
						tmpName = thisobj.options(i).text;
				}
				window.document.all("prop_"+objval+"_"+objid+"_3").value = "";
				desobj.value = tmpName;

		}else if(propid == "3") {
				tmpValue = desobj.value;
				pos = tmpValue.indexOf("{");
				if(pos == -1)
					desobj.value = tmpValue +"{"+ thisobj.value+"}";
				else
					desobj.value = tmpValue.substring(0,pos) +"{"+ thisobj.value+"}";
		}else if(propid == "10") {
			_thisvalue = thisobj.value;

			tmpObj = window.document.all("prop_"+objval+"_"+objid+"_2");

			var len = tmpObj.options.length;
			for(var i = (len-1); i >= 0; i--) {
				tmpObj.options[i] = null;
			}
			var i=0;

			if(_thisvalue != 0) {
				<%=strInputDetailField%>
				desobj.value = "<%=strInputDetailInitField%>";
			}
			else {
				<%=strInputMainField%>
				desobj.value = "<%=strInputMainInitField%>";
			}
			window.document.all("prop_"+objval+"_"+objid+"_3").value = "";

		}
	}else if(objval == "4") {
		if(propid == "1") {
			formDocument.all("sTitle_"+objval+"_"+objid).innerHTML = thisobj.value;
		}else if(propid == "2") {
				tmpName = "";
				for (i=0; i< thisobj.options.length; i++){
					if(thisobj.options(i).value == thisobj.value)
						tmpName = thisobj.options(i).text;
				}
				window.document.all("prop_"+objval+"_"+objid+"_3").value = "";
				desobj.innerHTML = tmpName;

		}else if(propid == "3") {
				tmpValue = desobj.innerHTML;
				pos = tmpValue.indexOf("{");
				if(pos == -1)
					desobj.innerHTML = tmpValue +"{"+ thisobj.value+"}";
				else
					desobj.innerHTML = tmpValue.substring(0,pos) +"{"+ thisobj.value+"}";
		}else if(propid == "10") {
			_thisvalue = thisobj.value;

			tmpObj = window.document.all("prop_"+objval+"_"+objid+"_2");

			var len = tmpObj.options.length;
			for(var i = (len-1); i >= 0; i--) {
				tmpObj.options[i] = null;
			}
			var i=0;

			if(_thisvalue != 0) {
				<%=strTextareaDetailField%>
				desobj.value = "<%=strTextareaDetailInitField%>";
			}
			else {
				<%=strTextareaMainField%>
				desobj.value = "<%=strTextareaMainInitField%>";
			}
			window.document.all("prop_"+objval+"_"+objid+"_3").value = "";

		}
	}else if(objval == "5") {
		if(propid == "1") {
			formDocument.all("sTitle_"+objval+"_"+objid).innerHTML = thisobj.value;
		}else if(propid == "2") {
				tmpName = "";
				for (i=0; i< thisobj.options.length; i++){
					if(thisobj.options(i).value == thisobj.value)
						tmpName = thisobj.options(i).text;
				}
				window.document.all("prop_"+objval+"_"+objid+"_3").value = "";
				desobj.options[0].text = tmpName;

		}else if(propid == "10") {
			_thisvalue = thisobj.value;

			tmpObj = window.document.all("prop_"+objval+"_"+objid+"_2");

			var len = tmpObj.options.length;
			for(var i = (len-1); i >= 0; i--) {
				tmpObj.options[i] = null;
			}
			var i=0;

			if(_thisvalue != 0) {
				<%=strSelectDetailField%>
				desobj.options[0].text = "<%=strSelectDetailInitField%>";
			}
			else {
				<%=strSelectMainField%>
				desobj.options[0].text = "<%=strSelectMainInitField%>";
			}
			window.document.all("prop_"+objval+"_"+objid+"_3").value = "";

		}
	}else if(objval == "6") {
		if(propid == "1") {
			formDocument.all("sTitle_"+objval+"_"+objid).innerHTML = thisobj.value;
		}else if(propid == "2") {
				tmpName = "";
				for (i=0; i< thisobj.options.length; i++){
					if(thisobj.options(i).value == thisobj.value)
						tmpName = thisobj.options(i).text;
				}
				window.document.all("prop_"+objval+"_"+objid+"_3").checked = true;

				formDocument.all("sItem_"+objval+"_"+objid+"_div").innerHTML = tmpName;

		}else if(propid == "10") {
			_thisvalue = thisobj.value;

			tmpObj = window.document.all("prop_"+objval+"_"+objid+"_2");

			var len = tmpObj.options.length;
			for(var i = (len-1); i >= 0; i--) {
				tmpObj.options[i] = null;
			}
			var i=0;

			if(_thisvalue != 0) {
				<%=strCheckDetailField%>
				formDocument.all("sItem_"+objval+"_"+objid+"_div").innerHTML = "<%=strCheckDetailInitField%>";
			}
			else {
				<%=strCheckMainField%>
				formDocument.all("sItem_"+objval+"_"+objid+"_div").innerHTML = "<%=strCheckMainInitField%>";
			}
			window.document.all("prop_"+objval+"_"+objid+"_3").checked = true;

		}else if(propid == "3") {
			if(thisobj.value == "1")
				desobj.checked = true;
			else
				desobj.checked = false;
		}

	}else if(objval == "9") {
		if(propid == "1") {
			formDocument.all("sTitle_"+objval+"_"+objid).innerHTML = thisobj.value;
		}else if(propid == "2") {
				tmpName = "";
				for (i=0; i< thisobj.options.length; i++){
					if(thisobj.options(i).value == thisobj.value)
						tmpName = thisobj.options(i).text;
				}
				window.document.all("prop_"+objval+"_"+objid+"_3").value = "";

				formDocument.all("sItem_"+objval+"_"+objid+"_div").innerHTML = tmpName;

		}else if(propid == "10") {
			_thisvalue = thisobj.value;

			tmpObj = window.document.all("prop_"+objval+"_"+objid+"_2");

			var len = tmpObj.options.length;
			for(var i = (len-1); i >= 0; i--) {
				tmpObj.options[i] = null;
			}
			var i=0;

			if(_thisvalue != 0) {
				<%=strBrowserDetailField%>
				formDocument.all("sItem_"+objval+"_"+objid+"_div").innerHTML = "<%=strBrowserDetailInitField%>";
			}
			else {
				<%=strBrowserMainField%>
				formDocument.all("sItem_"+objval+"_"+objid+"_div").innerHTML = "<%=strBrowserMainInitField%>";
			}
			window.document.all("prop_"+objval+"_"+objid+"_3").value = "";

		}
	}

	if(propid=="11"){
		formDocument.all("sPiece_"+objval+"_"+objid).style.backgroundColor=thisobj.value;
	}
	//window.document.all("oMPC").selectedIndex = 2;
}


function onShowItems(selval){
	allobj = window.document.all;

	for(i=0 ; i<allobj.length ; i++) {
       		if(allobj[i].id.indexOf("oTr_")!=-1 && allobj[i].style.display=="")
       			allobj[i].style.display="none";
	}
	for(i=0 ; i<allobj.length ; i++) {
       		if(allobj[i].id.indexOf("oTr_"+selval+"_")!=-1 && allobj[i].style.display=="none"){
       			allobj[i].style.display="";
       		}
	}



	//window.document.all("oMPC").selectedIndex = 2;

}

function SelectColor(thisobj,objval,objid,propid){
	var id = window.showModalDialog("/systeminfo/ColorBrowser.jsp");
	if(id){
		document.all("prop_"+objval+"_"+objid+"_"+propid).value=id;
		document.all("prop_"+objval+"_"+objid+"_"+propid+"_span").style.backgroundColor  = id;
		changeProp(document.all("prop_"+objval+"_"+objid+"_"+propid),objval,objid,propid);
	}
}
</SCRIPT>

</HEAD>
<BODY BGCOLOR="#D6D3CE" style="margin:0px;" >

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    if(operatelevel>0){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onCreate(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(221, user.getLanguage())+",javascript:onView(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(1205, user.getLanguage())+",javascript:onExit(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    if(type.equals("editform")&&operatelevel>0){


        RCMenu += "{"+SystemEnv.getHtmlLabelName(18368, user.getLanguage())+",addformrowcal.jsp?createtype=2&formid="+formid+",_parent}" ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(18369, user.getLanguage())+",addformcolcal.jsp?createtype=2&formid="+formid+",_parent}" ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",manageform.jsp,_parent}" ;
    RCMenuHeight += RCMenuHeightStep ;
    %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="form1" action="FormDesignOperation.jsp" method=post enctype="multipart/form-data">

<input type="hidden" value="<%=type%>" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<br>
  <img id="img_1" name="img_1" onclick="addItem(0);"  onmouseover="imgOver(1);" onmouseout="imgOut(1);" style="CURSOR: hand" src="/images/formdesign/1-down_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(78, user.getLanguage()) %>">
       <img id="img_2" name="img_2" onclick="addItem(1);"  onmouseover="imgOver(2);" onmouseout="imgOut(2);" style="CURSOR: hand" src="/images/formdesign/2_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(22360, user.getLanguage()) %>">
       <img id="img_3" name="img_3" onclick="addItem(2);"  onmouseover="imgOver(3);" onmouseout="imgOut(3);" style="CURSOR: hand" src="/images/formdesign/3_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(74, user.getLanguage()) %>">
    <img id="img_8" name="img_8" onclick="addItem(7);"  onmouseover="imgOver(8);" onmouseout="imgOut(8);" style="CURSOR: hand" src="/images/formdesign/8_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(128026, user.getLanguage()) %>">
       <img id="img_4" name="img_4" onclick="addItem(3);"  onmouseover="imgOver(4);" onmouseout="imgOut(4);" style="CURSOR: hand" src="/images/formdesign/4_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(128146, user.getLanguage()) %>">
        <img id="img_5" name="img_5" onclick="addItem(4);"  onmouseover="imgOver(5);" onmouseout="imgOut(5);" style="CURSOR: hand" src="/images/formdesign/5_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(128148, user.getLanguage()) %>">
       <img id="img_6" name="img_6" onclick="addItem(5);"  onmouseover="imgOver(6);" onmouseout="imgOut(6);" style="CURSOR: hand" src="/images/formdesign/6_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(690, user.getLanguage()) %>">
       <img id="img_7" name="img_7" onclick="addItem(6);"  onmouseover="imgOver(7);" onmouseout="imgOut(7);" style="CURSOR: hand" src="/images/formdesign/7_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(691, user.getLanguage())%>">
       <img id="img_10" name="img_10" onclick="addItem(9);"  onmouseover="imgOver(10);" onmouseout="imgOut(10);" style="CURSOR: hand" src="/images/formdesign/10_wev8.gif" border=0 title="<%=SystemEnv.getHtmlLabelName(32306, user.getLanguage()) %>">

<hr>
<DIV STYLE="MARGIN-top:2px;MARGIN-left:2px ">
  <div ID="oMPC">

    <table width=100% cols=2 id="propertyTable">
    <tr>
    <td colspan=2>
    <select name=itemList style="width:100%" onchange="onShowItems(this.value);">
    <option value="0"><%=SystemEnv.getHtmlLabelName(22967, user.getLanguage())%></option>
    <%=itemListOptions%>
    </select>
    </td>
    </tr>
    <tr id="oTr_0_1">
    <td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
    <td><input type="text" name="prop_0_1"  size=18  class=Inputstyle value="<%=formname%>"></td>
    </tr>
    <tr id="oTr_0_2">
    <td><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></td>
    <td><textarea name="prop_0_2"  cols="23" rows="3" class=Inputstyle  ><%=formdes%></textarea></td>
    </tr>


    <%=itemProps%>

    </table>
  </div>
</DIV>


    <input type="hidden" name="allobjs" value="">
    <input type="hidden" name="submittypetmp" value="0">
    <input type="hidden" name="isview" value="0">
</form>
<hr>
<%
String _info = "";
if(Util.getIntValue(Util.null2String(request.getParameter("errorcode")),0)==1){
	_info = "[ERROR]"+SystemEnv.getHtmlLabelName(22410, user.getLanguage())+"！<br>";
}
%><font color=red>
<div name="info" id="info" STYLE="MARGIN-top:2px;MARGIN-left:2px;" align=left>
<%=_info%>

</div>
</font>
<script language="javascript">
function onCreate(){
 	document.all("info").innerHTML = "";

	if(document.all("prop_0_1").value==""){
		var _tmpval = document.all("info").innerHTML;
		 document.all("info").innerHTML="[ERROR]<%=SystemEnv.getHtmlLabelName(129062, user.getLanguage())%>！<br>"+_tmpval;
		return;
	}

	var allobjs = "";
	var itemList = window.document.all("itemList");
	var len = itemList.length;
	var minpty = 0;

	for(i=0;i<len;i++){
		var _tmpObj = itemList.options[i].value;
		var _tmpText = itemList.options[i].text;
		allobjs += ","+_tmpObj;
		if(_tmpObj != ""){
			tmptype = _tmpObj.substring(0,1);
			var _tmpStr = ",3,4,5,6,9,";
			if(_tmpStr.indexOf(","+tmptype+",")!=-1){

				var _tmpval = document.all("info").innerHTML;
				_curpty = document.all("prop_"+_tmpObj+"_pty").value;
				if(document.all("prop_"+_tmpObj+"_1").value == ""){

					document.all("info").innerHTML="[ERROR]<%=SystemEnv.getHtmlLabelName(129063, user.getLanguage())%>{"+_tmpText+"}"+<%=SystemEnv.getHtmlLabelNames("18946,229",user.getLanguage()) %>+"!<br>"+_tmpval;
						return;
				}
				if(document.all("prop_"+_tmpObj+"_10").value == "1"){
					if(minpty != 0 && ((_curpty-minpty) > 30 ||(_curpty-minpty) < -30 )) {
						document.all("info").innerHTML="[ERROR]<%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%>{"+_tmpText+"}<%=SystemEnv.getHtmlLabelName(129064, user.getLanguage())%>!<br>"+_tmpval;
						return;
					}
					minpty = _curpty ;
				}
			}
		}
	}

	window.document.all("allobjs").value=allobjs;
	document.form1.submit();
}

function onView(){

	window.document.all("isview").value="1";
	onCreate();
}

function onExit(){
	var returnVal = window.showModalDialog("ExitPopup.jsp","","dialogHeight: 120px; dialogWidth: 200px; center: Yes; help: No; resizable: No; status: No");

	if(returnVal){
		if(returnVal=="2"){
			window.parent.location = "manageform.jsp";
			return;
		}


	 	document.all("info").innerHTML = "";

		if(document.all("prop_0_1").value==""){
			var _tmpval = document.all("info").innerHTML;
			 document.all("info").innerHTML="[ERROR]<%=SystemEnv.getHtmlLabelName(129062, user.getLanguage())%>!<br>"+_tmpval;
			return;
		}

		var allobjs = "";
		var itemList = window.document.all("itemList");
		var len = itemList.length;
		var minpty = 0;

		for(i=0;i<len;i++){
			var _tmpObj = itemList.options[i].value;
			var _tmpText = itemList.options[i].text;
			allobjs += ","+_tmpObj;
			if(_tmpObj != ""){
				tmptype = _tmpObj.substring(0,1);
				var _tmpStr = ",3,4,5,6,9,";
				if(_tmpStr.indexOf(","+tmptype+",")!=-1){

					var _tmpval = document.all("info").innerHTML;
					_curpty = document.all("prop_"+_tmpObj+"_pty").value;
					if(document.all("prop_"+_tmpObj+"_1").value == ""){

						document.all("info").innerHTML="[ERROR]<%=SystemEnv.getHtmlLabelName(129063, user.getLanguage())%>{"+_tmpText+"}"+<%=SystemEnv.getHtmlLabelNames("18946,229",user.getLanguage()) %>+"!<br>"+_tmpval;
							return;
					}
					if(document.all("prop_"+_tmpObj+"_10").value == "1"){
						if(minpty != 0 && ((_curpty-minpty) > 30 ||(_curpty-minpty) < -30 )) {
							document.all("info").innerHTML="[ERROR]<%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%>{"+_tmpText+"}<%=SystemEnv.getHtmlLabelName(129064, user.getLanguage())%>!<br>"+_tmpval;
							return;
						}
						minpty = _curpty ;
					}
				}
			}
		}

		window.document.all("submittypetmp").value="1";
		window.document.all("allobjs").value=allobjs;
		document.form1.submit();
	}
}
</script>
</BODY>
</HTML>