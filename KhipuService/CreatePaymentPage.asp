<!-- #include file = "hex_sha1_js.asp" -->
<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

' Servicio CreatePaymentPage que extiende de KhipuService.
' Este servicio facilita la creación del boton de pago.



Class KhipuServiceCreatePaymentPage
	
	Dim receiverId 
	Dim secret 
	Dim apiUrl  
	'  Diccionario de los datos que se enviarán al servicio
	Dim data 'protected
	
	' Metodo para adjuntar el valor a uno de los elementos que
	' contempla el arreglo data. Esta funcion solo registrará los valores
	' que estan definidos en el arreglo.
	
	Public Function setParameter(name, value)
		me.data(name) = value
	End Function
	

	' Funcion que retorna la URL del servicio
	Public Function getApiUrl() 
		getApiUrl = me.apiUrl
	End Function  
	' Fin Común a los servicios  
	
	
	' Iniciamos el servicio
	Public Function init(receiverId, secret) 
		me.receiverId = receiverId
		me.secret = secret 

		Set data = CreateObject("Scripting.Dictionary")
		' Iniciamos la variable apiUrl con la url del servicio.
		Dim kh : Set kh = new Khipu

		me.apiUrl = kh.getUrlService("CreatePaymentPage")
		' Iniciamos el arreglo $data con los valores que requiere el servicio.
		
		me.data.Add   "receiver_id" , me.receiverId
		me.data.Add   "subject" , ""
		me.data.Add   "body" , ""
		me.data.Add   "amount" , 0
		me.data.Add   "custom" , ""
		me.data.Add   "notify_url" , ""
		me.data.Add   "return_url" , ""
		me.data.Add   "cancel_url" , ""
		me.data.Add   "transaction_id" , ""
		me.data.Add   "picture_url" , ""
		me.data.Add   "payer_email" , ""
		
		Set init = me
	End Function

	' Método que genera el formulario de pago en HTML
	' @param string buttonType dimensión del boton a mostrar
	Public Function renderForm(buttonType) 
		If buttonType="" then
			buttonType = "100x25"
		End If
		
		Dim kh : Set kh = new Khipu

		Dim button

		Dim buttons : Set buttons = kh.getButtonsKhipu()
		If buttons.count > 0 then
			button = buttons(buttonType)
		Else	
			button = buttons("100x50")
		End If
		
		Dim stringData
		stringData = dataToString()
		data.Add "hash", hex_sha1(stringData)
		
		Dim html
		html = "<form action=" & me.getApiUrl() & " method=""post"">" & vbcrlf &_
		"<input type=""hidden"" name=""receiver_id"" value=""" & me.data("receiver_id") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""subject"" value=""" & me.data("subject") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""body"" value=""" & me.data("body") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""amount"" value=""" & me.data("amount") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""notify_url"" value="""& me.data("notify_url") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""return_url"" value=""" & me.data("return_url") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""cancel_url"" value=""" & me.data("cancel_url") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""custom"" value=""" & me.data("custom") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""transaction_id""  value=""" & me.data("transaction_id") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""payer_email"" value=""" & me.data("payer_email") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""picture_url"" value=""" & me.data("picture_url") & """/>" & vbcrlf &_
		"<input type=""hidden"" name=""hash"" value=""" & me.data("hash") & """/>" & vbcrlf &_
		"<input type=""image"" name=""submit"" src="""& button & """/></form>"

		renderForm = html
	End Function

	' Método que retorna los datos requeridos para hacer el formulario
	' adjuntando el hash.
	Public Function getFormLabels() 

		' Pasamos los datos a string
		Dim stringData : stringData = dataToString()
		Dim values : Set values = CreateObject("Scripting.Dictionary")
		
		values.Add "hash", hex_sha1(stringData)
		
		Dim items : items = me.data.Items   
		Dim keys : keys = me.data.Keys

		Dim i
		For i = 0 To me.data.Count -1 
			values.add keys(i), items(i)
		Next

		Set getFormLabels = values
	End Function
	
	Function dataToString() 
		Dim string : string = ""
		string = string & "receiver_id=" & me.data("receiver_id")
		string = string & "&subject=" & me.data("subject")
		string = string & "&body=" & me.data("body")
		string = string & "&amount=" & me.data("amount")
		string = string & "&payer_email=" & me.data("payer_email")
		string = string & "&transaction_id=" & me.data("transaction_id")
		string = string & "&custom=" & me.data("custom")
		string = string & "&notify_url=" & me.data("notify_url")
		string = string & "&return_url=" & me.data("return_url")
		string = string & "&cancel_url=" & me.data("cancel_url")
		string = string & "&picture_url=" & me.data("picture_url")
		string = string & "&secret=" & me.secret 
		dataToString = string
	End Function
End Class
%>