<!-- #include file = "KhipuRecipients.asp" -->
<!-- #include file = "hex_sha1_js.asp" -->
<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

Class KhipuServiceCreateEmail
	
	Dim secret
	Dim apiUrl
	Dim recipientsJSON
	
	'  Arreglo de los datos que se enviarán al servicio
	Dim data 'protected
	
	' Metodo para adjuntar el valor a uno de los elementos que
	' contempla el arreglo $data. Esta funcion solo registrará los valores
	' que estan definidos en el arreglo.
	
	Public Function setParameter(name, value)
		me.data(name) = value
	End Function
	
	Dim recipients
	
	Public Sub Class_Initialize
		' Iniciamos la variable apiUrl con la url del servicio.
		Dim khipu : Set khipu = new Khipu

		me.apiUrl = khipu.getUrlService("CreateEmail")
		
		' Iniciamos el arreglo data con los valores que requiere el servicio.
		Set me.data = server.createObject("Scripting.Dictionary")
		me.data.add "subject" , ""
		me.data.add "body" , ""
		me.data.add "transaction_id" , ""
		me.data.add "custom" , ""
		me.data.add "notify_url" , ""
		me.data.add "return_url" , ""
		me.data.add "cancel_url" , ""
		me.data.add "pay_directly" , "true"
		me.data.add "send_emails" , "true"
		me.data.add "expires_date" , ""
		me.data.add "picture_url" , ""
	End Sub
	
	Public Default Function init(receiverId, secret) 
		Set me.recipients = new KhipuRecipients
		me.data.add "receiver_id", receiverId
		me.secret = secret
		Set init = me
	End Function
	
	' Este metodo se encarga de adjuntar un destinatario al objeto.
	' @param string $name    Nombre del pagador.
	' @param string $email   Correo electrónico del pagador.
	' @param int $amount     Monto que pagará el pagador.
	Public Sub addRecipient(name, email, amount)
		me.recipients.addRecipient name, email, amount
	End  Sub
		
	' Limpa los destinatarios.
	Public Function cleanRecipients
		me.recipients.cleanRecipients
	End Function
		
	' Método que asigna a formato JSON los detinatarios
	Private Function recipientsToJSON
		me.recipientsJSON = recipients.getJSON()
	End Function
		
	Private Function dataToString
		Dim string : string = ""

		string = string & "receiver_id="     & data("receiver_id")
		string = string & "&subject="        & data("subject")
		string = string & "&body="           & data("body")
		string = string & "&destinataries="  & me.recipientsJSON
		string = string & "&pay_directly="   & data("pay_directly")
		string = string & "&send_emails="    & data("send_emails")
		string = string & "&expires_date="   & data("expires_date")
		string = string & "&transaction_id=" & data("transaction_id")
		string = string & "&custom="         & data("custom")
		string = string & "&notify_url="     & data("notify_url")
		string = string & "&return_url="     & data("return_url")
		string = string & "&cancel_url="     & data("cancel_url")
		string = string & "&picture_url="    & data("picture_url")
		string = string & "&secret="         & me.secret
		dataToString = Trim(string)
	End Function
		
	' Metodo que envia la solicitud a Khipu para generar los cobros.
	Public Function send
		Dim stringData 

		recipientsToJSON

		stringData = dataToString()
			
		Dim httpRequest
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
		data = data & "&destinataries=" & recipientsJSON
		data = data & "&hash=" & doHash(stringData)
			
		Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		httpRequest.Open "POST", me.apiUrl, False
		httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		httpRequest.Send data
			
		send = httpRequest.ResponseText
	End Function
End Class
%>