<%
' Copyright (c) 2013, khipu SpA
' All rights reserved.
' Released under BSD LICENSE, please refer to LICENSE.txt

' Servicio ReceiverStatus extiende de KhipuService
' Esta clase verifica el estado y algunas capacidades de una cuenta khipu

Class KhipuServiceReceiverStatus
	Dim receiverId 
	Dim secret 
	Dim apiUrl  

	' Diccionario de los datos que se enviarán al servicio
	Dim data 
	
	' Metodo para adjuntar el valor a uno de los elementos que
	' contempla el arreglo $data. Esta funcion solo registrará los valores
	' que estan definidos en el arreglo.
	Public Function setParameter(name, value)
		me.data(name) = value
	End Function
	
	' Método que retorna un arreglo con los nombres de las llaves del arreglo
	' data
	Public Function getParametersNames
		Set getParametersNames = me.data.keys
	End Function
	
	' Iniciamos el servicio
	Public Function init(receiverId, secret) 
		me.receiverId = receiverId
		me.secret = secret 
		Set data = CreateObject("Scripting.Dictionary")

		' Iniciamos la variable apiUrl con la url del servicio.
		Dim kh : Set kh = new Khipu
		me.apiUrl = kh.getUrlService("ReceiverStatus")
		' Iniciamos el arreglo $data con los valores que requiere el servicio.    
		me.data.Add   "receiver_id" , me.receiverId
		
		Set init = me
	End Function
	
	' Método que consulta por el estado
	Public Function consult()  
		Dim dataToSend : dataToSend = me.dataToString() & "&hash=" & doHash(me.dataToString() & "&secret="  & me.secret)
		
		Dim httpRequest : Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		httpRequest.Open "POST", me.apiUrl, False
		httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		httpRequest.Send dataToSend
		
		consult = httpRequest.ResponseText
	End Function
	
	Function dataToString() 
		Dim string: string = ""
		string = string & "receiver_id=" & me.receiverId
		dataToString = string
	End Function
End Class
%>