<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

' Este servicio marca un pago como rechazado

Class KhipuServiceSetRejectedByPayer
	Dim receiver_id 
	Dim secret 
	Dim apiUrl  
	Dim data
	
	' Metodo para adjuntar el valor a uno de los elementos que
	' contempla el arreglo data.
	Public Function setParameter(name, value)
		me.data(name) = value
	End Function
	
	Public Function init(my_receiver_id, my_secret) 
		me.receiver_id = my_receiver_id
		me.secret = my_secret 
		
		Set data = CreateObject("Scripting.Dictionary")
		' Iniciamos la variable apiUrl con la url del servicio.
		Dim kh
		Set kh = new Khipu
		me.apiUrl = kh.getUrlService("SetRejectedByPayer")
		' Iniciamos el arreglo $data con los valores que requiere el servicio.  
		data.add "receiver_id",me.receiver_id
		data.add "payment_id",""
		data.add "text",""
		
		Set init = me
		
	End Function
	
	' Método que envia la solicitud
	' @return bool
	Public Function reject() 
		
		Dim stringData 
		stringData = dataToString()
		
		Dim strData
		strData = ""
		Dim index : index = 0
		Dim key
		For Each key in me.data.keys
			If index > 0 Then
				strData = strData & "&"
			End If
			strData = strData & key & "=" & Server.URLEncode(me.data(key))
			index = index + 1
		Next
		strData = strData & "&hash=" & doHash(stringData)
		
		Dim httpRequest
		Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		httpRequest.Open "POST", me.apiUrl, False
		httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		httpRequest.Send strData
		reject = httpRequest.ResponseText
	End Function
	
	Function dataToString() 
		Dim str : str = ""
		str = str & "receiver_id="     & me.receiver_id
		str = str & "&payment_id="     & me.data("payment_id")
		str = str & "&text="           & me.data("text")    
		str = str & "&secret="         & me.secret
		dataToString = trim(str)
	End Function
End Class
%>