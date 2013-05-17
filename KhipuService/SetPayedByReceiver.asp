<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

' Servicio KhipuServiceSetPayedByReceiver extiende de KhipuService
' Este servicio marca un pago como pagado
Class KhipuServiceSetPayedByReceiver
	
	Dim receiverId 
	Dim secret 
	Dim apiUrl  
	Dim data
	
	' Metodo para adjuntar el valor a uno de los elementos que
	' contempla el arreglo data.
	Public Function setParameter(name, value)
		me.data(name) = value
	End Function
	
	' Iniciamos el servicio
	public Function init(receiverId, secret) 
		me.receiverId = receiverId
		me.secret = secret 
		
		' Iniciamos la variable apiUrl con la url del servicio.
		Dim kh : Set kh = new Khipu
		me.apiUrl = kh.getUrlService("SetPayedByReceiver")

		' Iniciamos el arreglo data con los valores que requiere el servicio.  
		Set data = CreateObject("Scripting.Dictionary")
		data.add "receiver_id",me.receiverId
		data.add "payment_id",""	
		Set init = me
		
	end Function

	' Método que envia la solicitud
	Public Function setPayed() 
		Dim stringData : stringData = dataToString()
		
		Dim strData : strData = ""
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
		
		Dim httpRequest : Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")

		httpRequest.Open "POST", me.apiUrl, False
		httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		httpRequest.Send strData
		setPayed = httpRequest.ResponseText
	End Function
	
	Function dataToString() 
		Dim string : string = ""
		string = string & "receiver_id="     & me.receiverId
		string = string & "&payment_id="     & me.data("payment_id")
		string = string & "&secret="         & me.secret
		dataToString = trim(string)
	End Function
End Class
%>