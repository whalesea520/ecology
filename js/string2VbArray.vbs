Function string2VbArray(str)
	Dim vbsArray
	
	string2VbArray = vbsArray
	if str <> "" then
		vbsArray = Split(str, "(~!@#$%^&*)") 
		string2VbArray = vbsArray
	end if
End Function