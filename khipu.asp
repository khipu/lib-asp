<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

Option explicit
%>
<!-- #include file = "KhipuService/CreatePaymentPage.asp" -->
<!-- #include file = "KhipuService/CreateEmail.asp" -->
<!-- #include file = "KhipuService/ReceiverStatus.asp" -->
<!-- #include file = "KhipuService/VerifyPaymentNotification.asp" -->
<!-- #include file = "KhipuService/PaymentStatus.asp" -->
<!-- #include file = "KhipuService/SetRejectedByPayer.asp" -->
<!-- #include file = "KhipuService/SetBillExpired.asp" -->
<!-- #include file = "KhipuService/SetPayedByReceiver.asp" -->
<%

' Se define la ruta de khipu.
Dim KHIPU_ROOT : KHIPU_ROOT =  Request.ServerVariables("PATH_INFO") 

' URL de la API khipu
Dim KHIPU_API_URL : KHIPU_API_URL = "https://khipu.com/api/" 

' Version del servicio de khipu.
Const KHIPU_SERVICE_VERSION = "1.1"

' Version de la biblioteca
Const VERSION = "1.0"

' Obtencion de timestamp tipo Unix
Function to_unix_timestamp(d)
	to_unix_timestamp = DateDiff("s", "01/01/1970 00:00:00", d)
End Function

' Obtencion del Hash necesario para la autentificacion de mensajes
Function doHash(string) 
		doHash = hex_sha1(string)
End Function

Class Khipu
	' ID del cobrador.
	Dim receiverId

	' Llave del cobrador.
	Dim secret

	' Establece los valores necesarios para la autenticación en khipu
	Public Sub authenticate(receiverId, secret) 
		me.receiverId = receiverId
		me.secret = secret
	End Sub

	' Retorna el objeto correspondiente al servicio, en caso de error se invoca un excepcion.
	Public Function loadService(serviceName)
		' Se consulta por el servicio para realizar la carga correspondiente.
		Select Case serviceName
			Case "CreateEmail"
				If Not receiverId = "" Or Not secret = "" Then
					Set loadService = new KhipuServiceCreateEmail.init(me.receiverId, me.secret)
				Else 
					Err.raise 101, serviceName, "Es necesario autentificarse antes de usar el servicio " & serviceName
				End If
			Case "ReceiverStatus"
				If Not receiverId = "" Or Not secret = "" Then
					Set loadService = new KhipuServiceReceiverStatus.init(me.receiverId, me.secret)
				Else 
					Err.raise 102, serviceName, "Es necesario autentificarse antes de usar el servicio " & serviceName
				End If
			Case "CreatePaymentPage"	     
				If Not receiverId = "" Or Not secret = "" Then   
					Set loadService = new KhipuServiceCreatePaymentPage.init(me.receiverId, me.secret)
				Else 
					Err.raise 103, serviceName, "Es necesario autentificarse antes de usar el servicio " & serviceName
				End If
			Case "PaymentStatus"	     
				If Not receiverId = "" Or Not secret = "" Then   
					Set loadService = new KhipuServicePaymentStatus.init(me.receiverId, me.secret)
				Else 
					Err.raise 104, serviceName, "Es necesario autentificarse antes de usar el servicio " & serviceName
				End If
			Case "SetRejectedByPayer"	     
				If Not receiverId = "" Or Not secret = "" Then   
					Set loadService = new KhipuServiceSetRejectedByPayer.init(me.receiverId, me.secret)
				Else 
					Err.raise 105, serviceName, "Es necesario autentificarse antes de usar el servicio " & serviceName
				End If
			Case "VerifyPaymentNotification"
				If Not receiverId = "" Then
					Set loadService = new KhipuServiceVerifyPaymentNotification.init(me.receiverId)   
				Else 
					Err.raise 105, serviceName, "Es necesario usar receiverId antes de usar el servicio " & serviceName
				End If
			Case "SetBillExpired"
				If Not receiverId = "" Or Not secret = "" Then   
					Set loadService = new KhipuServiceSetBillExpired.init(me.receiverId, me.secret)
				Else 
					Err.raise 105, serviceName, "Es necesario autentificarse antes de usar el servicio " & serviceName
				End If
			Case "SetPayedByReceiver"
				If Not receiverId = "" Or Not secret = "" Then   
					Set loadService = new KhipuServiceSetPayedByReceiver.init(me.receiverId, me.secret)     
				Else 
					Err.raise 105, serviceName, "Es necesario autentificarse antes de usar el servicio " & serviceName
				End If
			Case Else
				Err.raise 105, serviceName, "El Servicio requerido no existe: " & serviceName
		End Select
	End Function

	'Funcion que retorna las URL de los servicios de khipu.  
	Public Function getUrlService(serviceName) 
		Dim urlKhipu : urlKhipu = KHIPU_API_URL & KHIPU_SERVICE_VERSION & "/"
		Select Case serviceName
			Case "CreateEmail"
				getUrlService = urlKhipu & "createEmail"
			Case "CreatePaymentPage"
				getUrlService = urlKhipu & "createPaymentPage"
			Case "VerifyPaymentNotification"
				getUrlService = urlKhipu & "verifyPaymentNotification"
			Case "ReceiverStatus"
				getUrlService = urlKhipu & "receiverStatus"
			Case "PaymentStatus"
				getUrlService = urlKhipu & "paymentStatus"
			Case "SetRejectedByPayer"
				getUrlService = urlKhipu & "setRejectedByPayer"
			Case "SetBillExpired"
				getUrlService = urlKhipu & "setBillExpired"
			Case "SetPayedByReceiver"
				getUrlService = urlKhipu & "setPayedByReceiver"
			Case Else
				getUrlService = False
		End Select
	End Function

	' Funcion que retorna la lista de botones que da a disposición Khipu.
	public Function getButtonsKhipu() 
		Dim url : url = "https://s3.amazonaws.com/static.khipu.com"
		
		Dim urlDictionary : Set urlDictionary = CreateObject("Scripting.Dictionary")

		urlDictionary.Add  "50x25"	, url & "/buttons/50x25.png"
		urlDictionary.Add  "100x25"	, url & "/buttons/100x25.png"
		urlDictionary.Add  "100x50"	, url & "/buttons/100x50.png"
		urlDictionary.Add  "150x25"	, url & "/buttons/150x25.png"
		urlDictionary.Add  "150x50"	, url & "/buttons/150x50.png"
		urlDictionary.Add  "150x75"	, url & "/buttons/150x75.png"
		urlDictionary.Add  "150x75-B"	, url & "/buttons/150x75-B.png"
		urlDictionary.Add  "200x50"	, url & "/buttons/200x50.png"
		urlDictionary.Add  "200x75"	, url & "/buttons/200x75.png"

		Set getButtonsKhipu = urlDictionary
	End Function 
End Class
%>
