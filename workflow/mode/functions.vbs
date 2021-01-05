'**************************************************
'		文件菜单
'**************************************************
'新建
Public Sub mnuFileNew_click()
	'If CellWeb1.IsModified() Then '文档已经被更改
	language=7
	if language=8 then
		rtn = MsgBox( "Whether create new format?", vbYesNo)
	else
	    rtn = MsgBox( "是否真的要新建一个模版？", vbYesNo)
	end if
		If rtn = vbNo Then
			Exit Sub
		End If
	'End If
	CellWeb1.SetMaxRows(0)
	CellWeb1.SetMaxRows(20)
	CellWeb1.SetMaxCols(10)
	CellWeb1.FormProtect = false
	CellWeb1.SetShowPopupMenu false
	menu_init
End Sub

'打开本地文档
Public Sub mnuFileOpen_click()
	CellWeb1.OnFileOpen
	CellWeb1.SetShowPopupMenu false
	menu_init
End Sub

Public Sub mnuExcelFileOpen_click()
	CellWeb1.OnOpenExcelFile
	CellWeb1.SetShowPopupMenu false
	menu_init
End Sub

'打开远程文档
Public Sub mnuFileWebOpen_click()
    language=7
	if language=8 then
	strFilename = InputBox( "Please intput report file name of server", "open report file", "HTTP://" )
	else
	strFilename = InputBox( "请输入远程服务器上的超级报表文件名", "打开超级报表文件", "HTTP://" )
	end if
	If strFilename <> "" Then CellWeb1.ReadHttpTabFile strFilename
	CellWeb1.SetShowPopupMenu false
	menu_init
End Sub

Public Sub mnuXMLFileWebOpen_click()
    language=7
	if language=8 then
	strFilename = InputBox( "Please input XML report file name of server", "open XML report file", "HTTP://" )
	else
	strFilename = InputBox( "请输入远程服务器上的XML超级报表文件名", "打开XML超级报表文件", "HTTP://" )
	end if
	If strFilename <> "" Then CellWeb1.ReadHttpXMLFile strFilename
	CellWeb1.SetShowPopupMenu false
	menu_init
End Sub

Public Sub mnuSaveDataAsString_click()
	With CellWeb1
		strValue = .SaveDataAsString()
		MsgBox strValue, vbExclamation
	End With
End Sub

'保存
Public Sub mnuFileSave_click()
    strFilename = CellWeb1.FilePathName
	If strFilename <> "" then
		CellWeb1.SaveFile strFilename
	else
		CellWeb1.OnFileSave
	end if
End Sub

'另存为
Public Sub mnuFileSaveAs_click()
	CellWeb1.OnFileSave
End Sub

Public Sub mnuFileSaveXMLFile_click()
	CellWeb1.OnSaveXMLFile
End Sub

'打印预览
Public Sub mnuFilePrintPreview_click()
	CellWeb1.OnFilePrintPreview
End Sub

'打印设置
Public Sub mnuFilePrintSetup_click()
	CellWeb1.OnPrintSetup
End Sub

'打印页设置
Public Sub mnuPrintPaperSet_click()
	CellWeb1.OnPrintPaperSet
End Sub

'打印
Public Sub mnuFilePrint_click()
	CellWeb1.OnFilePrint
End Sub

'退出
Public Sub mnuFileExit_click()
	If CellWeb1.IsModified() Then
	    language=7
	    if language=8 then
		rtn = MsgBox( "file changed，whether save?", vbExclamation or vbYesNoCancel)
		else
		rtn = MsgBox( "文档已被更改，是否保存？", vbExclamation or vbYesNoCancel)
		end if
		If rtn = vbYes Then
			mnuFileSave_click
		ElseIf rtn = vbCancel Then
			Exit Sub
		End If
	End If
	window.parent.close
End Sub

'**************************************************
'		编辑菜单
'**************************************************
'撤消操作
Public Sub mnuEditUndo_click()
	CellWeb1.Undo
End Sub

'重新操作
Public Sub mnuEditRedo_click()
	CellWeb1.Redo
End Sub

'剪切操作
Public Sub mnuEditCut_click()
 	CellWeb1.OnEditCut
End Sub

'复制操作
Public Sub mnuEditCopy_click()
 	CellWeb1.OnEditCopy
End Sub

'粘贴操作
Public Sub mnuEditPaste_click()
 	CellWeb1.OnEditPaste
End Sub

'查找
Public Sub mnuEditFind_click()
	CellWeb1.OnGoToCell
End Sub

'清除单元文字
Public Sub mnuClearCellText_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.ClearCellText StartRow,StartCol,EndRow,EndCol
	End With
End Sub

'选中区域升序排序
Public Sub mnuOnSortRowAsc_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SortCol .Col,StartRow,StartCol,EndRow,EndCol,true
	End With
End Sub

'选中区域降序排序
Public Sub mnuOnSortRowDec_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SortCol .Col,StartRow,StartCol,EndRow,EndCol,false
	End With
End Sub

'升序排序-整行交换
Public Sub mnuOnSortRowAscAll_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SortCol .Col,StartRow,1,EndRow,.GetMaxCol,true
	End With
End Sub

'降序排序-整行交换
Public Sub mnuOnSortRowAscAll_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SortCol .Col,StartRow,1,EndRow,.GetMaxCol,false
	End With
End Sub

'选中区域升序排序
Public Sub mnuOnSortColAsc_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SortRow .Row,StartRow,StartCol,EndRow,EndCol,true
	End With
End Sub

'选中区域降序排序
Public Sub mnuOnSortColDec_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SortRow .Row,StartRow,StartCol,EndRow,EndCol,false
	End With
End Sub

'升序排序-整列交换
Public Sub mnuOnSortColAscAll_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SortRow .Row,1,StartCol,.GetMaxRow,EndCol,true
	End With
End Sub

'降序排序-整列交换
Public Sub mnuOnSortColDecAll_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SortRow .Row,1,StartCol,.GetMaxRow,EndCol,false
	End With
End Sub

'超级链接
Public Sub mnuEditHyperlink_click()
    language=7
	if language=8 then
	strUrl = InputBox( "Please input URL:", "link", "HTTP://" )
	else
	strUrl = InputBox( "请输入超级链接地址：", "超级链接", "HTTP://" )
	end if
	CellWeb1.SetCellURLType CellWeb1.Row,CellWeb1.Col,strUrl
End Sub

'设置粗体
Public Sub cmdBold_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.Bold = not CellWeb1.Bold	
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next
End Sub

'设置斜体
Public Sub cmdItalic_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.Italic = not CellWeb1.Italic
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next
End Sub

'设置下划线
Public Sub cmdUnderline_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.Underline = not CellWeb1.Underline
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'设置背景色
Public Sub cmdBackColor_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.OnSetCellBkColor
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'设置前景色
Public Sub cmdForeColor_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.OnSetTextColor
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'自动折行
Public Sub cmdWordWrap_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	language=7
	if CellWeb1.AutoWrap then
		CellWeb1.AutoWrap false
		nMenuID = MenuOcx.GetMenuID("AutoWrap")
		MenuOcx.SetMenuChecked nMenuID,false
	    if language=8 then
		MsgBox "change over not line wrap.", vbExclamation
		else
		MsgBox "已经取消自动折行.", vbExclamation
		end if
	else
		CellWeb1.AutoWrap true
		nMenuID = MenuOcx.GetMenuID("AutoWrap")
		MenuOcx.SetMenuChecked nMenuID,true
		if language=8 then
		MsgBox "change over line wrap.", vbExclamation
		else
		MsgBox "设置为自动折行.", vbExclamation
		end if
	end if
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'居左对齐
Public Sub cmdAlignLeft_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.HorzTextAlign = 1
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'居中对齐
Public Sub cmdAlignCenter_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.HorzTextAlign = 2
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'居右对齐
Public Sub cmdAlignRight_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.HorzTextAlign = 3
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'居上对齐
Public Sub cmdAlignTop_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.VertTextAlign = 1
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'垂直居中对齐
Public Sub cmdAlignMiddle_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.VertTextAlign = 2
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'居下对齐
Public Sub cmdAlignBottom_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.VertTextAlign = 3
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'画边框线
Public Sub cmdDrawBorder_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.DrawCellBorder  StartRow, StartCol, EndRow, EndCol, BorderTypeSelect.value,BorderColor.value,DrawTypeSelect.value
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'抹框线
Public Sub cmdEraseBorder_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.ClearCellBorder  StartRow, StartCol, EndRow, EndCol,EraseTypeSelect.value
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next
End Sub

'货币符号
Public Sub cmdCurrency_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.SetCellDigitShowStyle StartRow, StartCol, EndRow, EndCol,2,2
	language=7
	if language=8 then
	MsgBox "show ￥", vbExclamation
	else
	MsgBox "人民币符号显示.", vbExclamation
	end if
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next
End Sub

'百分号
Public Sub cmdPercent_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.SetCellDigitShowStyle StartRow, StartCol, EndRow, EndCol,4,2
	language=7
	if language=8 then
	MsgBox "show %", vbExclamation
	else
	MsgBox "百分号显示.", vbExclamation
	end if
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next
End Sub

'千分位
Public Sub cmdThousand_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.SetCellDigitShowStyle StartRow, StartCol, EndRow, EndCol,5,2
	language=7
	if language=8 then
	MsgBox "show kilocharacter", vbExclamation
	else
	MsgBox "千分位显示.", vbExclamation
	end if
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next
End Sub

'关于超级报表插件
Public Sub cmdAbout_click()
	CellWeb1.AboutBox
End Sub

'插入列
Public Sub cmdInsertCol_click()
	CellWeb1.OnInsertBeforeCol
End Sub

'插入行
Public Sub cmdInsertRow_click()
	CellWeb1.OnInsertBeforeRow
End Sub

'插入单元
Public Sub cmdInsertCell_click()
	CellWeb1.OnInsertCell
End Sub

'删除单元
Public Sub cmdDeleteCell_click()
	CellWeb1.OnDeleteCell
End Sub

'删除列
Public Sub cmdDeleteCol_click()
	CellWeb1.OnDeleteCol
End Sub

'删除行
Public Sub cmdDeleteRow_click()
	CellWeb1.OnDeleteRow
End Sub

'设置表格行列数
Public Sub mnuMaxRowCol_click
	strValue = CellWeb1.GetMaxRow
	language=7
	if language=8 then
	strRow = InputBox( "Please input max line number", "set table line number", strValue )
	else
	strRow = InputBox( "请输入最大行数：", "设置表格行列数", strValue )
	end if
	if strRow ="" then strRow = strValue
	strValue = CellWeb1.GetMaxCol
	if language=8 then
	strRow = InputBox( "Please input max col number", "set table col number", strValue )
	else
	strCol = InputBox( "请输入最大列数：", "设置表格行列数", strValue )
	end if
	if strCol ="" then strCol = strValue
	lMaxRow = strRow
	lMaxCol = strCol
	CellWeb1.SetMaxRows lMaxRow
	CellWeb1.SetMaxCols lMaxCol
	CellWeb1.FormProtect = false
End Sub

'设置行高自动调整
public sub mnuSetRowAutoSize_click()
	with CellWeb1
		.SetRowAutoSize NOT .IsRowAutoSize
		nMenuID = MenuOcx.GetMenuID("SetRowAutoSize")
		MenuOcx.SetMenuChecked nMenuID,.IsRowAutoSize
	end with
end sub

'自动跳转到下一列
public sub mnuJumpNextCol_click()
	with CellWeb1
		.JumpNextCol
		nMenuID = MenuOcx.GetMenuID("JumpNextCol")
		MenuOcx.SetMenuChecked nMenuID,true
		nMenuID = MenuOcx.GetMenuID("JumpNextRow")
		MenuOcx.SetMenuChecked nMenuID,false
	end with
end sub

'自动跳转到下一行
public sub mnuJumpNextRow_click()
	with CellWeb1
		.JumpNextRow
		nMenuID = MenuOcx.GetMenuID("JumpNextCol")
		MenuOcx.SetMenuChecked nMenuID,false
		nMenuID = MenuOcx.GetMenuID("JumpNextRow")
		MenuOcx.SetMenuChecked nMenuID,true
	end with
end sub

'头尾单元自动换行和列
Public Sub mnuSetAutoJumpNextRowCol_click()
	With CellWeb1
		nFlag = not .IsAutoJumpNextRowCol
		.SetAutoJumpNextRowCol nFlag
		nMenuID = MenuOcx.GetMenuID("SetAutoJumpNextRowCol")
		MenuOcx.SetMenuChecked nMenuID,.IsAutoJumpNextRowCol
	End With
End Sub

'在按键时跳过该单元
Public Sub mnuSetCellKeyNotFocus_click()
	With CellWeb1
		.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		nFlag = not .IsCellKeyNotFocus(StartRow,StartCol)
		.SetCellKeyNotFocus StartRow, StartCol, EndRow, EndCol,nFlag
		nMenuID = MenuOcx.GetMenuID("SetCellKeyNotFocus")
		MenuOcx.SetMenuChecked nMenuID,.IsCellKeyNotFocus(StartRow,StartCol)
	End With
End Sub

'是否显示错误提示
Public Sub mnuShowErrorMsgBox_Click()
	CellWeb1.ShowErrorMsgBox = not CellWeb1.ShowErrorMsgBox
	nMenuID = MenuOcx.GetMenuID("ShowErrorMsgBox")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.ShowErrorMsgBox
End Sub

'设计模式
Public Sub mnuDesignMode_Click()
	CellWeb1.DesignMode = not CellWeb1.DesignMode
	nMenuID = MenuOcx.GetMenuID("DesignMode")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.DesignMode
End Sub

'显示表格线
Public Sub mnuShowGrid_Click()
	CellWeb1.ShowGrid = not CellWeb1.ShowGrid
	nMenuID = MenuOcx.GetMenuID("ShowGrid")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.ShowGrid
End Sub

'显示行列头
Public Sub mnuShowHeader_Click()
	CellWeb1.ShowHeader = not CellWeb1.ShowHeader
	nMenuID = MenuOcx.GetMenuID("ShowHeader")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.ShowHeader
End Sub

'报表只读
Public Sub mnuFormProtect_click()
	With CellWeb1
		.FormProtect = not .FormProtect
		nMenuID = MenuOcx.GetMenuID("FormProtect")
		MenuOcx.SetMenuChecked nMenuID,CellWeb1.FormProtect
		If .FormProtect Then
			language=7
	        if language=8 then
			MsgBox "Table protected", vbExclamation
			else
			MsgBox "报表已经整表保护.", vbExclamation
			end if
		Else
		    language=7
	        if language=8 then
			MsgBox "Table unprotected.", vbExclamation
			else
			MsgBox "报表已经取消整表保护.", vbExclamation
			end if
		End If
	End With
End Sub

'组合单元中的非主单元参于计算
Public Sub cmdSetCCInCells_click()
	With CellWeb1
		.SetCalculateCombinationInCells( not .IsCalculateCombinationInCells)
		If .IsCalculateCombinationInCells Then
			language=7
	        if language=8 then
			MsgBox "no-main cell of combined cell attend calculate", vbExclamation
			else
			MsgBox "组合单元中的非主单元参于计算", vbExclamation
			end if
		Else
		    language=7
	        if language=8 then
			MsgBox "no-main cell of combined cell don't attend calculate", vbExclamation
			else
			MsgBox "取消了组合单元中的非主单元参于计算.", vbExclamation
			end if
		End If
	End With
End Sub

'报表保护时是否出现光标
Public Sub mnuSetProtectFormShowCursor_Click()
	CellWeb1.SetProtectFormShowCursor not CellWeb1.GetProtectFormShowCursor
	nMenuID = MenuOcx.GetMenuID("SetProtectFormShowCursor")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.GetProtectFormShowCursor
End Sub

'是否显示弹出菜单
Public Sub mnuSetShowPopupMenu_Click()
	CellWeb1.SetShowPopupMenu not CellWeb1.GetShowPopupMenu
	nMenuID = MenuOcx.GetMenuID("SetShowPopupMenu")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.GetShowPopupMenu
End Sub

'是否允许鼠标对行高进行调整
Public Sub mnuSetAllowRowResizing_Click()
	CellWeb1.SetAllowRowResizing not CellWeb1.IsAllowRowResizing
	nMenuID = MenuOcx.GetMenuID("SetAllowRowResizing")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.IsAllowRowResizing
End Sub

'是否允许鼠标对列宽进行调整
Public Sub mnuSetAllowColResizing_Click()
	CellWeb1.SetAllowColResizing not CellWeb1.IsAllowColResizing
	nMenuID = MenuOcx.GetMenuID("SetAllowColResizing")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.IsAllowColResizing
End Sub

'是否允许双击表头进行排序
Public Sub mnuSetDClickLabelCanSort_Click()
	CellWeb1.SetDClickLabelCanSort not CellWeb1.GetDClickLabelCanSort
	nMenuID = MenuOcx.GetMenuID("SetDClickLabelCanSort")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.GetDClickLabelCanSort
End Sub

'单元格只读、隐藏
Public Sub mnuReadOnly_click()
	CellWeb1.OnSetCellHideProtect
End Sub

'单选框
Public Sub mnuSetCellCheckBoxType_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		for row = StartRow to EndRow
			for col = StartCol to EndCol
				.SetCellCheckBoxType row,col		
			next
		next
	End With
End Sub

'大文本
Public Sub mnuSetCellLargeTextType_click()
	With CellWeb1
		.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SetCellLargeTextType StartRow, EndRow, .Col
	End With
End Sub

'设置超级链接
Public Sub mnuSetCellUrlType_click()
    language=7
	if language=8 then
	strURL = InputBox( "Please input URL", "links", "HTTP://" )
	else
	strURL = InputBox( "请输入URL", "超级链接", "HTTP://" )
	end if
	If strURL <> "" Then
		With CellWeb1
			.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
			for row = StartRow to EndRow
				for col = StartCol to EndCol
					.SetCellURLType row,col,strURL		
				next
			next
		End With
	End If
End Sub

'设置数字输入控件
Public Sub mnuSetCellNumericType_click()
	With CellWeb1
		.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		for row = StartRow to EndRow
			for col = StartCol to EndCol
				.SetCellNumericType row,col		
			next
		next
	End With
End Sub


'设置复合单元
Public Sub mnuSetCellComplexType_click()
	With CellWeb1
		.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		.SetCellComplexType StartRow,StartCol,EndRow,EndCol
	End With
End Sub

'删除控件
Public Sub mnuSetCellNormalType_click()
	With CellWeb1
		.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		for row = StartRow to EndRow
			for col = StartCol to EndCol
				.SetCellNormalType row,col		
			next
		next
	End With
End Sub

'财务表头
Public Sub mnuFinanceHeader_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
			CellWeb1.SetCellFinanceHeadType i,j,i,j
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
		next
	next
End Sub

'财务表览
Public Sub mnuFinance_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
			CellWeb1.SetCellFinanceType i, j, i, j
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
		next
	next
End Sub

'财务大写
Public Sub mnuFinanceDaXie_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
			CellWeb1.SetCellDigitShowStyle i,j,i,j,7,2
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
		next
	next
End Sub

'设置/取消单元3维显示
Public Sub mnuShape3D_click()
	With CellWeb1
        .GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		if .IsCellShape3D(.Row,.Col) then
			.SetCellShape3D StartRow,StartCol,EndRow,EndCol,false
		else
			.SetCellShape3D StartRow,StartCol,EndRow,EndCol,true
		End if
	End With
End Sub

'设置行隐藏
Public Sub mnuSetRowHide_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.SetRowHide StartRow,EndRow,true
End Sub

'设置行取消隐藏
Public Sub mnuSetRowUnHide_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.SetRowHide StartRow,EndRow,false
End Sub

'设置最合适的行高
Public Sub mnuAutoSizeRow_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.AutoSizeRow StartRow,EndRow,true
End Sub

'自动调整高度太小的行高
Public Sub mnuAutoSizeRow1_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.AutoSizeRow StartRow,EndRow,false
End Sub

'设置列隐藏
Public Sub mnuSetColHide_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.SetColHide StartCol,EndCol,true
End Sub

'设置列取消隐藏
Public Sub mnuSetColUnHide_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.SetColHide StartCol,EndCol,false
End Sub

'设置最合适的列高
Public Sub mnuAutoSizeCol_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.AutoSizeCol StartCol,EndCol,true
End Sub

'自动调整高度太小的列高
Public Sub mnuAutoSizeCol1_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.AutoSizeCol StartCol,EndCol,false
End Sub

'导出自定义函数
Public Sub mnuExportUserFunctions_click()
    language=7
	if language=8 then
	strFilename = InputBox( "Please input export file path name:", "export user-defined function", "" )
	else
	strFilename = InputBox( "请输入导出的文件路径名:", "导出自定义函数", "" )
	end if
	If strFilename <> "" Then CellWeb1.ExportUserFunctions strFilename
End Sub

'导入自定义函数
Public Sub mnuImportUserFunctions_click()
    language=7
	if language=8 then
	strFilename = InputBox( "Please input import file path name:", "import user-defined function", "" )
	else
	strFilename = InputBox( "请输入导入的文件路径名:", "导入自定义函数", "" )
	end if
	If strFilename <> "" Then CellWeb1.ImportUserFunctions strFilename
End Sub

'插入图片
Public Sub mnuFormatInsertPic_click()
	CellWeb1.InsertImageFile false
End Sub

'插入单元图片
Public Sub mnuFormatInsertCellPic_click()
	CellWeb1.InsertImageFile true
End Sub

'设置单元格组合
Public Sub mnuFormatMergeCell_click()
	CellWeb1.OnCellCombiNation true
End Sub

'取消单元格组合
Public Sub mnuFormatUnMergeCell_click()
	CellWeb1.OnCellCombiNation false
End Sub

'函数列表
Public Sub mnuFunctionList_click
	With CellWeb1
		.OnFunctionList
	End With	
End Sub

'自定义函数向导
Public Sub mnuUserFunctionGuide_click()
	CellWeb1.UserFunctionGuide
End Sub

'水平求和
Public Sub cmdFormulaSumH_click()
	With CellWeb1
		StartCol = 0: StartRow = 0: EndCol = 0: EndRow = 0
		.GetSelectRegionWeb StartRow,StartCol,EndRow,EndCol
		.AutoSum StartRow,StartCol,EndRow,EndCol,2
	End With
End Sub

'垂直求和
Public Sub cmdFormulaSumV_click()
	With CellWeb1
		StartCol = 0: StartRow = 0: EndCol = 0: EndRow = 0
		.GetSelectRegionWeb StartRow,StartCol,EndRow,EndCol
		.AutoSum StartRow,StartCol,EndRow,EndCol,1
	End With
End Sub

'双向求和
Public Sub cmdFormulaSumHV_click()
	With CellWeb1
		StartCol = 0: StartRow = 0: EndCol = 0: EndRow = 0
		.GetSelectRegionWeb StartRow,StartCol,EndRow,EndCol
		.AutoSum StartRow,StartCol,EndRow,EndCol,3
	End With
End Sub


'重算全表
Public Sub mnuFormulaReCalc_click()
	CellWeb1.ReCalculate '重算全表
	language=7
	if language=8 then
	MsgBox "Calculate complete", vbExclamation
	else
	MsgBox "计算完毕", vbExclamation
	end if
End Sub

'图表向导
Public Sub mnuDataWzdChart_click()
	CellWeb1.OnChartWizard
End Sub

'设置图片为原始大小
Public Sub mnuSetCellImageOriginalSize_click()
	With CellWeb1
		.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		for row = StartRow to EndRow
			for col = StartCol to EndCol
				.SetCellImageSize row,col,true		
			next
		next
		.Refresh
	End With
End Sub

'设置图片为单元大小
Public Sub mnuSetCellImageCellSize_click()
	With CellWeb1
		.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
		for row = StartRow to EndRow
			for col = StartCol to EndCol
				.SetCellImageSize row,col,false		
			next
		next
		.Refresh
	End With
End Sub

'删除图片
Public Sub mnuDeleteCellImage_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.DeleteCellImage StartRow, StartCol, EndRow, EndCol
End Sub

'设置/取消行表头
Public Sub mnuRowLabel_click()
	with CellWeb1
		if .GetRowLabel >0 Then
			.SetRowLabel(0)
		else
			.SetRowLabel(.Row)
		End if
	End With
	nMenuID = MenuOcx.GetMenuID("SetRowLabel")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.GetRowLabel
End Sub

'设置/取消列表头
Public Sub mnuColLabel_click()
	with CellWeb1
		if .GetColLabel >0 Then
			.SetColLabel(0)
		else
			.SetColLabel(.Col)
		End if
	End With
	nMenuID = MenuOcx.GetMenuID("SetColLabel")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.GetColLabel
End Sub

'设置打印页前脚行数
Public Sub mnuSetPagePreFooterRows_click()
	nPagePreFooterRows = CellWeb1.GetPagePreFooterRows
	language=7
	if language=8 then
	nRow = InputBox( "Comments: Page PreFooter begin to worthwhile one from report form page footer, without the page footer, begin from the last line. For instance: Report form have 20 in all, page footer that set up competent to it counts to be 0, page that set up 2 the moment, belong to page the moment 19, 20, for instance: The report form has 20 lines in all, it is that 2 walks that page footer set up is counted competently, the page set up is that 2 is all right the moment, belong to lower margin 19, 20, belong to page the moment 17, 18.Please input set up for print page prefooter line number:", "set print page prefooter line number", nPagePreFooterRows )
	else
	nRow = InputBox( "说明：页前脚的行是从报表页脚前一行开始向上算起,如果没有页脚,则从最后一行开始。 如:报表共有20行,设置的页脚行数是0行,设置的页前脚是2行,则属于页前脚的是第19,20行，如:报表共有20行,设置的页脚行数是2行,设置的页前脚是2行,则属于页脚的是第19,20行,属于页前脚的是第17,18行。         请输入设置为打印页前脚行数：", "设置打印页前脚行数", nPagePreFooterRows )
	end if
	If nRow <> "" Then CellWeb1.SetPagePreFooterRows nRow
End Sub

'设置打印页脚行数
Public Sub mnuSetPageFooterRows_click()
	nPageFooterRows = CellWeb1.GetPageFooterRows()
	language=7
	if language=8 then
	nRow = InputBox( "Comments: Page Footer competent from the last of report form to worthwhile one.For instance: Report form have 20 in all, page footer that set up competent to it counts to be 2, belong to page the moment 19, 20.Please input set up for print page footer line number:", "set print page footer line number", nPageFooterRows )
	else
	nRow = InputBox( "说明：页脚的行从报表最后一行向上算起。   如:报表共有20行,设置页脚行数是2行,则属于页脚的是第19,20行。                 请输入设置为打印页脚行数：", "设置打印页脚行数", nPageFooterRows )
	end if
	If nRow <> "" Then CellWeb1.SetPageFooterRows nRow
End Sub

'设置每页打印的行数
Public Sub mnuSetOnePrintPageDetailZoneRows_click()
	nPageRows = CellWeb1.GetOnePrintPageDetailZoneRows()
	language=7
	if language=8 then
	nRow = InputBox( "Comments: When being print walk count whom page each reveal,ex table header and table footer and page prefooter line(if 0 lines, show and has not set up page each what printed walked and counting, the system carries on paging according to defaulting).Please input page each print line number:", "set page each print line number", nPageRows )
	else
	nRow = InputBox( "说明：打印时每页显示的行数,不包括表头和表尾页脚、页前脚的行数(如果为0行,则表示没有设置每页打印的行数,系统按缺省进行分页)。 请输入每页打印的行数：", "设置每页打印的行数", nPageRows )
	end if
	If nRow <> "" Then CellWeb1.SetOnePrintPageDetailZoneRows nRow
End Sub

'设置不打印单元格
Public Sub mnuSetCellCanPrint_click()
	bPrint = not CellWeb1.IsCellCanPrint(CellWeb1.Row,CellWeb1.Col)
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.SetCellCanPrint StartRow, StartCol, EndRow, EndCol,bPrint
	bPrint = CellWeb1.IsCellCanPrint(CellWeb1.Row,CellWeb1.Col)
	nMenuID = MenuOcx.GetMenuID("SetCellCanPrint")
	MenuOcx.SetMenuChecked nMenuID,bPrint
End Sub

'设置只打印单元格文字
Public Sub mnuSetCellOnlyPrintText_click()
	bPrint = not CellWeb1.IsCellOnlyPrintText(CellWeb1.Row,CellWeb1.Col)
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	CellWeb1.SetCellOnlyPrintText StartRow, StartCol, EndRow, EndCol,bPrint
	bPrint = CellWeb1.IsCellOnlyPrintText(CellWeb1.Row,CellWeb1.Col)
	nMenuID = MenuOcx.GetMenuID("SetCellOnlyPrintText")
	MenuOcx.SetMenuChecked nMenuID,bPrint
End Sub

'*****************************************************************
'**********      下拉列表框中的事件
'*****************************************************************
'设置字体
Public Sub changeFontName( ByVal value )
	lFontName = value
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.CellFontName = lFontName
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'设置字号
Public Sub changeFontSize( ByVal value )
	lFontSize = value
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.CellFontSize = lFontSize
	arrayprotect=Split(protectstr,",")
	num=0
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			if arrayprotect(num) then
				CellWeb1.SetCellProtect i,j,i,j,true
			end if
			num=num+1
		next
	next	
End Sub

'设置单元能够输入的最多字符数
Public Sub munSetCellEditMaxInputNumber_click()
	CellWeb1.GetSelectRegionWeb StartRow, StartCol, EndRow, EndCol
	protectstr=""
	for i=StartRow to EndRow
		for j=StartCol to EndCol
			isprotect=CellWeb1.IsCellProtect(i,j)
			if protectstr="" then 
				protectstr=isprotect
			else
				protectstr=protectstr&","&isprotect
			end if
			if isprotect then
				CellWeb1.SetCellProtect i,j,i,j,false
			end if
		next
	next
	CellWeb1.OnSetCellEditMaxInputNumber
End Sub

'菜单
Sub MenuOcx_MenuItemClick(name, nID)
	'   Call MsgBox(name)
	name = ucase(name)
	select case name
	case "ONFILENEW"
	   mnuFileNew_click
	case "ONFILEOPEN"
	   mnuFileOpen_click
	case "ONFILESAVE"
	   mnuFileSave_click
	case "ONFILESAVEAS"
	   mnuFileSaveAs_click
	case "ONFILESAVEASHTML"
	   CellWeb1.OnSaveAsHtmlFile
	case "ONFILEPRINT"
	   mnuFilePrint_click
	case "ONFILEPRINTPREVIEW"
	   mnuFilePrintPreview_click
	case "ONPROPERTY"
	   CellWeb1.OnProperty
	case "TESTSAVE"
		testsave()
    case "STYLECHECK"
        mnuStyleCheck_click

	'编辑菜单
	case "ONCOPY"
	   mnuEditCopy_click
	case "ONCUT"
	   mnuEditCut_click
	case "ONPASTE"
	   mnuEditPaste_click
	case "ONGOTOCELL"
	   CellWeb1.OnGoToCell
	case "ONINSERTBEFOREROW"
	   CellWeb1.OnInsertBeforeRow
	case "ONINSERTNEXTROW"
	   CellWeb1.OnInsertNextRow
	case "ONINSERTFORMATROWS"
	   CellWeb1.OnInsertFormatRows
	case "ONCOPYFORMATROW"
	   CellWeb1.OnCopyRowCellFormat
	case "ONINSERTBEFORECOL"
	   CellWeb1.OnInsertBeforeCol
	case "ONINSERTNEXTCOL"
	   CellWeb1.OnInsertNextCol
	case "ONINSERTFORMATCOLS"
	   CellWeb1.OnInsertFormatCols
	case "ONCOPYFORMATCOL"
	   CellWeb1.OnCopyColCellFormat
	case "ONINSERTCELL"
	   CellWeb1.OnInsertCell
	case "ONINSERTCELLDOWN"
	   CellWeb1.OnInsertCellDown
	case "ONINSERTCELLRIGHT"
	   CellWeb1.OnInsertCellRight
	case "ONCLEARCELLALL"
	   CellWeb1.OnClearCell
	case "ONCLEARCELLTEXT"
	   mnuClearCellText_click
	case "ONDELETEROW"
	   CellWeb1.OnDeleteRow
	case "ONDELETECOL"
	   CellWeb1.OnDeleteCol
	case "ONDELETECELL"
	   CellWeb1.OnDeleteCell
	case "ONDELETECELLUP"
	   CellWeb1.OnDeleteCellUp
	case "ONDELETECELLLEFT"
	   CellWeb1.OnDeleteCellLeft
	case "ONSORTROWASC"
	   mnuOnSortRowAsc_click
	case "ONSORTROWDEC"
	   mnuOnSortRowDec_click
	case "ONSORTROWASCALL"
	   mnuOnSortRowAscAll_click
	case "ONSORTROWDECALL"
	   mnuOnSortRowDecAll_click
	case "ONSORTCOLASC"
	   mnuOnSortCOLAsc_click
	case "ONSORTCOLDEC"
	   mnuOnSortColDec_click
	case "ONSORTCOLASCALL"
	   mnuOnSortCOLAscAll_click
	case "ONSORTCOLDECALL"
	   mnuOnSortColDecAll_click
	   
	'设置菜单
	case "ONSETMAXROWCOL"
	   mnuMaxRowCol_click
	case "ONSETPAPERCOLOR"
	   CellWeb1.OnSetPaperColor
	case "ONSETSYSGRIDLINE"
	   CellWeb1.OnSetSysGridLine
	case "ONSETCELLUSERVALUE"
	   CellWeb1.OnSetCellUserValue
	case "ONSETCELLUSERSTRINGVALUE"
	   CellWeb1.OnSetCellUserStringValue
	case "ONSETCELLVARNAME"
	   CellWeb1.OnSetCellVarName
	case "ONSETCELLHIDEPROTECT"
	   CellWeb1.OnSetCellHideProtect
	case "SETROWAUTOSIZE"
	   mnuSetRowAutoSize_click
	case "JUMPNEXTCOL"
	   mnuJumpNextCol_click
	case "JUMPNEXTROW"
	   mnuJumpNextRow_click
	case "SETAUTOJUMPNEXTROWCOL"
	   mnuSetAutoJumpNextRowCol_click
	case "SETCELLKEYNOTFOCUS"
	   mnuSetCellKeyNotFocus_click   
	case "SHOWERRORMSGBOX"
	   mnuShowErrorMsgBox_Click
	case "DESIGNMODE"
	   mnuDesignMode_Click
	case "SHOWGRID"
	   mnuShowGrid_Click
	case "SHOWHEADER"
	   mnuShowHeader_Click
	case "FORMPROTECT"
	   mnuFormProtect_click
	case "SETPROTECTFORMSHOWCURSOR"
	   mnuSetProtectFormShowCursor_Click
	case "SETSHOWPOPUPMENU"
	   mnuSetShowPopupMenu_Click
	case "SETALLOWROWRESIZING"
	   mnuSetAllowRowResizing_Click
	case "SETALLOWCOLRESIZING"
	   mnuSetAllowColResizing_Click
	case "SETDCLICKLABELCANSORT"
	   mnuSetDClickLabelCanSort_Click
	   
	'格式主菜单
	case "ONTEXTALIGN"
	   CellWeb1.OnTextAlign
	case "ONSETCELLTEXTSPAN"
	   CellWeb1.OnSetCellTextSpan
	case "ONSETCELLEXCELFORMAT"
	   CellWeb1.OnSetCellExcelFormat
	case "SETCELLCHECKBOXTYPE"
	   mnuSetCellCheckBoxType_click
	case "ONSETCELLCOMBOTYPE"
	   CellWeb1.OnSetCellComboType
	case "SETCELLLARGETEXTTYPE"
	   mnuSetCellLargeTextType_click
	case "ONSETCELLDATETIMETYPE"
	   CellWeb1.OnSetCellDateTimeType
	case "SETCELLURLTYPE"
	   mnuSetCellUrlType_click
	case "SETCELLNUMERICTYPE"
	   mnuSetCellNumericType_click
	case "SETCELLCOMPLEXTYPE"
	   mnuSetCellComplexType_click
	case "SETCELLNORMALTYPE"
	   mnuSetCellNormalType_click
	case "SETCELLFINANCEHEADTYPE"
	   mnuFinanceHeader_click
	case "SETCELLFINANCETYPE"
	   mnuFinance_click
	case "SETCELLFINANCEDAXIE"
	   mnuFinanceDaXie_click
	case "SETCELLSHAPE3D"
	   mnuShape3D_click
	case "AUTOWRAP"
	   cmdWordWrap_click
	case "ONSETLINESTYLE"
	   CellWeb1.OnSetLineStyle
	case "ONSETTEXTCOLOR"
	   CellWeb1.OnSetTextColor
	case "ONCHOOSEFONT"
	   CellWeb1.OnChooseFont
	case "ONSETCELLBKCOLOR"
	   CellWeb1.OnSetCellBkColor
	case "ONDATABINDCELLCOLOR"
	   CellWeb1.OnDataBindCellColor
	case "ONSETCELLSHOWSTYLE"
	   CellWeb1.OnSetCellShowStyle
	case "ONSETROWSIZE"
	   CellWeb1.OnSetRowSize
	case "SETROWHIDE"
	   mnuSetRowHide_click
	case "SETROWUNHIDE"
	   mnuSetRowUnHide_click
	case "AUTOSIZEROW"
	   mnuAutoSizeRow_click
	case "AUTOSIZEROW1"
	   mnuAutoSizeRow1_click
	case "ONSETCOLSIZE"
	   CellWeb1.OnSetColSize
	case "SETCOLHIDE"
	   mnuSetColHide_click
	case "SETCOLUNHIDE"
	   mnuSetColUnHide_click
	case "AUTOSIZECOL"
	   mnuAutoSizeCol_click
	case "AUTOSIZECOL1"
	   mnuAutoSizeCol1_click
	case "ONCELLCOMBINATION"
	   CellWeb1.OnCellCombiNation true
	case "ONCELLUNCOMBINATION"
	   CellWeb1.OnCellCombiNation false
	case "ONSLASHSET"
	   CellWeb1.OnSlashSet
	case "ONDEFAULTSET"
	   CellWeb1.OnDefaultSet
	   
	'公式脚本
	case "ONFUNCTIONLIST"
	   CellWeb1.OnFunctionList
	case "USERFUNCTIONGUIDE"
	   CellWeb1.UserFunctionGuide
	case "EXPORTUSERFUNCTIONS"
	   mnuExportUserFunctions_click
	case "IMPORTUSERFUNCTIONS"
	   mnuImportUserFunctions_click
	case "AUTOSUMVERT"
	   cmdFormulaSumV_click
	case "AUTOSUMHORZ"
	   cmdFormulaSumH_click
	case "AUTOSUMALL"
	   cmdFormulaSumHV_click
	case "ONSETFORMLOADSCRIPT"
	   CellWeb1.OnSetFormLoadScript
	case "ONRUNSCRIPT"
	   CellWeb1.OnRunScript
	case "RECALCULATE"
	   CellWeb1.ReCalculate
	   
	 '图形图表
	 case "ONCHARTWIZARD"
	    CellWeb1.OnChartWizard
	 case "ONDRAWLINE"
	    CellWeb1.OnDrawLine
	 case "ONDRAWRECT"
	    CellWeb1.OnDrawRect
	 case "ONDRAWROUNDRECT"
	    CellWeb1.OnDrawRoundRect
	 case "ONDRAWELLIPSE"
	    CellWeb1.OnDrawEllipse
	 case "ONOBJECTLINECOLOR"
	    CellWeb1.OnObjectLineColor
	 case "ONOBJECTFILLCOLOR"
	    CellWeb1.OnObjectFillColor
	 case "ONOBJECTMOVETOFRONT"
	    CellWeb1.OnObjectMoveToFront
	 case "ONOBJECTMOVETOBACK"
	    CellWeb1.OnObjectMoveToBack
	 case "ONOBJECTMOVEFORWARD"
	    CellWeb1.OnObjectMoveForward
	 case "ONOBJECTMOVEBACK"
	    CellWeb1.OnObjectMoveBack
	 case "REFRESHALLOBJECTDATA"
	    CellWeb1.RefreshAllObjectData
	    
	 '图片菜单
	 case "INSERTIMAGEFILE"
	    CellWeb1.InsertImageFile false
	 case "INSERTCELLIMAGE"
	    CellWeb1.InsertImageFile true
	 case "SETCELLIMAGEORIGINALSIZE"
	    mnuSetCellImageOriginalSize_click
	 case "SETCELLIMAGECELLSIZE"
	    mnuSetCellImageCellSize_click
	 case "DELETECELLIMAGE"
	    mnuDeleteCellImage_click
	 case "ONINSERTBACKGROUNDIMAGEORIGINALSIZE"
	    CellWeb1.OnInsertBackgroundImage true
	 case "ONINSERTBACKGROUNDIMAGEFORMSIZE"
	    CellWeb1.OnInsertBackgroundImage false
	 case "SETBACKGROUNDIMAGEORIGINALSIZE"
	    CellWeb1.SetBackgroundImageSize true
	 case "SETBACKGROUNDIMAGEFORMSIZE"
	    CellWeb1.SetBackgroundImageSize false
	 case "DELETEBACKGROUNDIMAGE"
	    CellWeb1.DeleteBackgroundImage
	    
	 '统计
	 case "ONSTATWEBWIZARD"
	    CellWeb1.OnStatWebWizard
	 
	 '打印设置
	 case "SETROWLABEL"
	    mnuRowLabel_click
	 case "SETCOLLABEL"
	    mnuColLabel_click
	 case "SETPAGEPREFOOTERROWS"
	    mnuSetPagePreFooterRows_click
	 case "SETPAGEFOOTERROWS"
	    mnuSetPageFooterRows_click
	 case "SETONEPRINTPAGEDETAILZONEROWS"
	    mnuSetOnePrintPageDetailZoneRows_click
	 case "ONPRINTPAPERSET"
	    CellWeb1.OnPrintPaperSet
	 case "ONPRINTSETUP"
	    CellWeb1.OnPrintSetup
	 case "SETCELLCANPRINT"
		mnuSetCellCanPrint_click
	 case "SETCELLONLYPRINTTEXT"
		mnuSetCellOnlyPrintText_click
	 case "SETPRINTFORMBACKGROUND"
	    CellWeb1.SetPrintFormBackground true
    	nMenuID = MenuOcx.GetMenuID("SetPrintFormBackground")
		MenuOcx.SetMenuChecked nMenuID,CellWeb1.IsPrintFormBackground()
    	nMenuID = MenuOcx.GetMenuID("SetNotPrintFormBackground")
		MenuOcx.SetMenuChecked nMenuID,not CellWeb1.IsPrintFormBackground()
	 case "SETNOTPRINTFORMBACKGROUND"
	    CellWeb1.SetPrintFormBackground false
    	nMenuID = MenuOcx.GetMenuID("SetPrintFormBackground")
		MenuOcx.SetMenuChecked nMenuID,CellWeb1.IsPrintFormBackground()
    	nMenuID = MenuOcx.GetMenuID("SetNotPrintFormBackground")
		MenuOcx.SetMenuChecked nMenuID,not CellWeb1.IsPrintFormBackground()

	 case "GETCURRENTVER"	
	    mnuCurrentVer_click
     case "GETSYSTEMVER"
	    mnuSystemVer_click
	 case "SHOWHELP"
	    mnuShowHelp_click   
	 case "CELLEDITMAXINPUTNUMBER"
	    munSetCellEditMaxInputNumber_click
   end select
End Sub

Sub CellWeb1_ShowCellChanged(Row, Col)
	bPrint = CellWeb1.IsCellCanPrint(CellWeb1.Row,CellWeb1.Col)
	nMenuID = MenuOcx.GetMenuID("SetCellCanPrint")
	MenuOcx.SetMenuChecked nMenuID,bPrint

	bPrint = CellWeb1.IsCellOnlyPrintText(CellWeb1.Row,CellWeb1.Col)
	nMenuID = MenuOcx.GetMenuID("SetCellOnlyPrintText")
	MenuOcx.SetMenuChecked nMenuID,bPrint

	nMenuID = MenuOcx.GetMenuID("AutoWrap")
	MenuOcx.SetMenuChecked nMenuID,CellWeb1.AutoWrap
	
	FontSizeSelect.Value = CellWeb1.CellFontSize
	FontNameSelect.value = CellWeb1.CellFontName
End Sub