<!-- #include file = "hex_sha1_js.asp" -->
<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

' Este servicio marca un cobro como expirado

Class KhipuServiceSetBillExpired
	Dim apiUrl
	Dim secret
	Dim receiverId
	Dim data
	
	' Iniciamos el servicio
	Public Sub Class_Initialize
		' Iniciamos la variable apiUrl con la url del servicio.
		Dim khipu : Set khipu = new Khipu
		me.apiUrl = khipu.getUrlService("SetBillExpired")
		
		Set data = CreateObject("Scripting.Dictionary")
		' Iniciamos el arreglo $data con los valores que requiere el servicio.  
		data.add "receiver_id", ""
		data.add "bill_id",""
		data.add "text",""
	End Sub
	
	Public Sub setParameter(name, value) 
		me.data(name) = value
	End Sub
	
	Public Default Function init(receiverId, secret)
		me.receiverId = receiverId
		me.secret = secret
		me.setParameter "receiver_id", me.receiverId
		Set init = me
	End Function
	
	Function dataToString()
		Dim string : string = ""
		string = string & "receiver_id="     & me.receiverId
		string = string & "&bill_id="     & me.data("bill_id")
		string = string & "&text="           & me.data("text")
		string = string & "&secret="         & me.secret
		dataToString = string
	End Function
	
	public Function expire()
		Dim stringData : stringData = dataToString()
		
		Dim data : data = ""
		Dim index : index = 0
		Dim key
		
		For Each key In me.data.keys
			If index > 0 Then
				data = data & "&"
			End If
			data = data & key & "=" & Server.URLEncode(me.data(key))
			index = index + 1
		Next
		
		data = data & "&hash=" & doHash(stringData)
		
		Dim httpRequest : Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		httpRequest.Open "POST", me.apiUrl, False
		httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		httpRequest.Send data
		expire = httpRequest.ResponseText
	End Function
End Class
%>