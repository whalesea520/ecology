
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<br>
<div id="helpdiv" name="helpdiv" style="width:100%;height:100%">
<%
//这个页面用来写操作说明，分3种语言
//不用标签是因为操作说明都是大段文字
int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
if(languageid == 7){
%>
&nbsp;&nbsp;&nbsp;&nbsp;<b>操作说明</b>
<ul>
	<li>“字段显示名”指在“表单字段显示名设置”中设置的每个字段的显示名称。通过选择“字段显示名”下第一个下拉选择框的不同选项，改变下方所显示的字段显示名列表；双击字段列表中选项，在左侧Html编辑框鼠标光标处添加该显示名固定标签，可重复添加。显示名标签在表单展现时，将根据当前用户所使用的系统语言自动解析（表单设置中必须为该语言设置相对应显示名）。</li>
	<li>“表单字段”指这个表单下所有的主表、明细表的字段、以及该流程的所有节点列表。通过选择“表单字段”下第一个下拉选择框的不同选项，改变下方所显示的字段、节点列表；选择字段列表中的字段（节点列表除外），可以修改字段的显示属性；双击字段列表的选项，在左侧Html编辑框鼠标光标处添加该字段固定标签，字段、节点不可重复添加。字段标签在表单展现时，将自动转换为各类型字段。</li>
	<li>对于打印模板，不能设置字段属性。初始化打印模板时，只能设置每行显示字段数，并使用显示模板的字段显示顺序。</li>
	<li>在Html编辑框中选择某个字段标签后点击鼠标右键，选择“字段属性”，可设置字段SQL属性。在表单展现时可根据SQL初始化该字段的值。SQL示例：select name, id from table1 where value='$1$'。其中，“$1$”代表一个表单字段，SQL查询时，会将该字段的值自动带出，该字段的值改变时，目标字段的值相应改变。SQL中只支持从一个字段中取值，附件字段不支持SQL属性。</li>
</ul>




<%
}else if(languageid == 8){
%>
&nbsp;&nbsp;&nbsp;&nbsp;<b>Description of operation</b>
<ul>
	<li>"Field Display Name" refers to the display name of each field set in "Form Field Display Name Setting". Double-click the option in the field list, in the left side of the Html edit box to add the mouse cursor to the display name fixed label, and then select the display field name to display the name of the field, Can be added repeatedly. Display Name Label When the form is displayed, it will be automatically parsed according to the system language used by the current user (the corresponding display name must be set for the language in the form settings).</li>
	<li>"Form Field" refers to all the main tables under this form, the fields of the schedule, and the list of all the nodes in the process. You can change the display fields of the field by selecting the fields in the field list (except the node list), by selecting the different options in the first drop-down selection box under "Form Fields", and then changing the fields in the Field List. Option to the left of the Html edit box to add the mouse cursor to the field fixed labels, fields, nodes can not be added repeatedly. Field labels are automatically converted to fields of various types when the form is displayed.</li>
	<li>Field properties can not be set for print templates. When you initialize a print template, you can only set the number of fields displayed per row and use the order in which the fields of the display template are displayed.</li>
	<li>In the Html edit box, select a field label and click the right mouse button, select "Field Properties", you can set the field SQL properties. The value of the field can be initialized based on SQL when the form is displayed. SQL Example: select name, id from table1 where value = '$ 1 $'. Where "$ 1 $" represents a form field, SQL query will automatically bring out the value of the field, the value of the field changes, the target value of the corresponding field changes. SQL only supports values from a field, the attachment field does not support SQL attributes.</li>
</ul>




<%
}else if(languageid == 9){
%>
&nbsp;&nbsp;&nbsp;&nbsp;<b>操作說明</b>
<ul>
	<li>“字段顯示名”指在“表單字段顯示名設置”中設置的每個字段的顯示名稱。通過選擇“字段顯示名”下第一個下拉選擇框的不同選項，改變下方所顯示的字段顯示名列表；雙擊字段列表中選項，在左側Html編輯框鼠標光標處添加該顯示名固定標籤，可重複添加。顯示名標籤在表單展現時，將根據當前用戶所使用的系統語言自動解析（表單設置中必須為該語言設置相對應顯示名）。</li>
	<li>“表單字段”指這個表單下所有的主表、明細表的字段、以及該流程的所有節點列表。通過選擇“表單字段”下第一個下拉選擇框的不同選項，改變下方所顯示的字段、節點列表；選擇字段列表中的字段（節點列表除外），可以修改字段的顯示屬性；雙擊字段列表的選項，在左側Html編輯框鼠標光標處添加該字段固定標籤，字段、節點不可重複添加。字段標籤在表單展現時，將自動轉換為各類型字段。</li>
	<li>對於打印模板，不能設置字段屬性。初始化打印模板時，只能設置每行顯示字段數，並使用顯示模板的字段顯示順序。</li>
	<li>在Html編輯框中選擇某個字段標籤後點擊鼠標右鍵，選擇“字段屬性”，可設置字段SQL屬性。在表單展現時可根據SQL初始化該字段的值。 SQL示例：select name, id from table1 where value='$1$'。其中，“$1$”代表一個表單字段，SQL查詢時，會將該字段的值自動帶出，該字段的值改變時，目標字段的值相應改變。 SQL中只支持從一個字段中取值，附件字段不支持SQL屬性。</li>
</ul>
<%}%>
</div>
