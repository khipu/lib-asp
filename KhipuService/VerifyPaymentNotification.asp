<!-- #include file = "hex_sha1_js.asp" -->
<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

' Esta clase verifica la notificacion enviada por Khipu por un pago
Class KhipuServiceVerifyPaymentNotification 
	
	Dim data
	Dim receiverId
	Dim apiUrl
	
	' Iniciamos el servicio
	Public Sub Class_Initialize
		' Iniciamos la variable apiUrl con la url del servicio.
		Dim khipu : Set khipu = new Khipu
		me.apiUrl = khipu.getUrlService("VerifyPaymentNotification")
		
		' Iniciamos el arreglo data con los valores que requiere el servicio.
		Set me.data = server.createObject("Scripting.Dictionary")
		me.data.add "api_version", ""
		me.data.add "receiver_id", ""
		me.data.add "notification_id", ""
		me.data.add "subject", ""
		me.data.add "amount", ""
		me.data.add "currency", ""
		me.data.add "transaction_id", ""
		me.data.add "payer_email", ""
		me.data.add "custom", ""
		me.data.add "notification_signature", ""
	End Sub
	
	Public Default Function init(receiverId)
		me.receiverId = receiverId
		Set init = me
	End Function
	
	Public Function setParameter(name, value)
		me.data(name) = value
	End Function
	
	Public Function verify
		If Not me.receiverId = me.data("receiver_id") Then
			verify = "INVALID"
		Else 
			Dim httpRequest : Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
			httpRequest.Open "POST", me.apiUrl, False
			httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			httpRequest.Send me.dataToString()
			
			verify = httpRequest.ResponseText
		End IF
	End Function
	
	Public Function dataToString
		Dim string : string = ""
		string = string & "api_version="             & Server.URLEncode(me.data("api_version"))
		string = string & "&receiver_id="            & Server.URLEncode(me.data("receiver_id"))
		string = string & "&notification_id="        & Server.URLEncode(me.data("notification_id"))
		string = string & "&subject="                & Server.URLEncode(me.data("subject"))
		string = string & "&amount="                 & Server.URLEncode(me.data("amount"))
		string = string & "&currency="               & Server.URLEncode(me.data("currency"))
		string = string & "&transaction_id="         & Server.URLEncode(me.data("transaction_id"))
		string = string & "&payer_email="            & Server.URLEncode(me.data("payer_email"))
		string = string & "&custom="                 & Server.URLEncode(me.data("custom"))
		string = string & "&notification_signature=" & Server.URLEncode(me.data("notification_signature"))
		dataToString = string
	End Function
End Class
%>