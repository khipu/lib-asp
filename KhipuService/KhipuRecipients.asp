<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

Class KhipuRecipients
	Dim recipients(50, 2)
	Dim length
	
	Public Sub Class_Initialize
		length = 0
	End Sub 

	Public Sub addRecipient (name, email, amount) 
		If length < 50 then
			recipients(length, 0) = name
			recipients(length, 1) = email
			recipients(length, 2) = amount
			length = length + 1
		End If	
	End Sub
	
	Public Function getJSON
		Dim i
		Dim entry
		
		Dim json : json = "["
		For i = 0 to length - 1
			If i > 0 Then 
				json = json & ", "
			End If
			json = json & "{ ""name"": """ & recipients(i, 0) & """" & ", ""email"": """ & recipients(i, 1) & """" & ",""amount"": """ & recipients(i, 2) & """" & "}"
		Next 
		getJSON = json & "]"
	End Function
	
	Public Sub cleanRecipients
		length = 0
	End Sub
end class
%>