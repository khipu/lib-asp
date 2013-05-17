<!-- #include file = "hex_sha1_js.asp" -->
<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

' Este servicio consulta el estado de un pago

Class KhipuServicePaymentStatus
	Dim apiUrl
	Dim secret
	Dim receiverId
	Dim paymentId
	
	' Iniciamos el servicio
	Public Sub Class_Initialize
	' Iniciamos la variable apiUrl con la url del servicio.
		Dim khipu : Set khipu = new Khipu
		me.apiUrl = khipu.getUrlService("PaymentStatus")
	End Sub
	
	Public Sub setPaymentId(paymentId) 
		me.paymentId = paymentId
	End Sub
	
	Public Default Function init(receiverId, secret)
		me.receiverId = receiverId
		me.secret = secret
		Set init = me
	End Function
	
	Public Function dataToString
		Dim string : string = ""
		string = string & "receiver_id=" & me.receiverId
		string = string & "&payment_id=" & me.paymentId
		string = string & "&secret=" & me.secret
		dataToString = string
	End Function

	Public Function consult
		Dim httpRequest : Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		
		Dim stringData : stringData = dataToString()
		
		Dim data : data = "receiver_id=" & me.receiverId & "&payment_id=" & me.paymentId & "&hash=" & doHash(stringData)
		
		httpRequest.Open "POST", me.apiUrl, False
		httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		httpRequest.Send data
		
		consult = httpRequest.ResponseText
	End Function
End Class
%>