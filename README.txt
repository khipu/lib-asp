# Khipu
Biblioteca PHP para utilizar los servicios de Khipu.com

Versión Biblioteca: 1.1.1

Versión API Khipu: 1.1
Las notificaciones ocupan la versión: 1.2

La documentación de Khipu.com se puede ver desde aquí: https://khipu.com/page/api

## Introducción

khipu cuenta con varios servicios, algunos de ellos:

1) Crear Cobros y enviarlos por Mail.
2) Crear Página de Pago.
3) Recibiendo y validando la notificación de un pago.
4) Verificar Estado de una cuenta khipu.
5) Marcar un cobro como pagado.
6) Marcar un cobro como expirado.
7) Marcar un cobro como Rechazado

Para utilizar estos servicios, simpre se debe incluir el archivo khipu.asp

## 1) Crear Cobros y enviarlos por Mail

Para crear cobros, necesitamos identificar al cobrador y a los destinatarios.
A continuación un ejemplo

<!-- #include file = "Khipu.asp" -->
<%
Dim kh : Set kh = new Khipu
kh.authenticate ID_DEL_COBRADOR, SECRET_DEL_COBRADOR

Dim createEmail :  Set createEmail = kh.loadService("CreateEmail")

createEmail.setParameter "subject", "Probando desde asp"
createEmail.setParameter "body", "cobro de prueba"
createEmail.addRecipient "John Doe", "john.doe@gmail.com", 100
createEmail.setParameter "expires_date", to_unix_timestamp(DateAdd("m", 2, Now))
response.write createEmail.send
%>

## 2) Crear Página de Pago

Crear una página de pago también se requiere identificarse, a continuación un
ejemplo:

<%
Dim kh : Set kh = new Khipu
kh.authenticate ID_DEL_COBRADOR, SECRET_DEL_COBRADOR

Dim createPayment :  Set createPayment = kh.loadService("CreatePaymentPage")

createPayment.setParameter "subject", "Probando desde asp"
createPayment.setParameter "body", "Cobro de prueba"
createPayment.setParameter "amount", 10
createPayment.setParameter "expires_date", to_unix_timestamp(DateAdd("m", 2, Now))

Response.Write("<p>" & createPayment.renderForm("") & "</p>")
%>

## 3) Recibiendo y validando la notificación de un pago

Este servicio debe ser utilizado en la página que recibirá el POST desde
khipu y no require identificar al cobrador.
A continuación un ejemplo:

<!-- #include file = "Khipu.asp" -->
<%
Dim kh : Set kh = new Khipu
kh.authenticate ID_DEL_COBRADOR, ""

Dim verifyPayment :  Set verifyPayment = kh.loadService("VerifyPaymentNotification")

verifyPayment.setParameter "api_version"            , "1.2"
verifyPayment.setParameter "receiver_id"            , ID_DEL_COBRADOR
verifyPayment.setParameter "notification_id"        , "jgbvyk2lskfh"
verifyPayment.setParameter "subject"                , "Khipu Tienda Demo - Orden # 100000325"
verifyPayment.setParameter "amount"                 , "6"
verifyPayment.setParameter "currency"               , "CLP"
verifyPayment.setParameter "transaction_id"         , "100000234"
verifyPayment.setParameter "payer_email"            , "demo@khipu.com"
verifyPayment.setParameter "custom"                 , ""
verifyPayment.setParameter "notification_signature" , "XxNqZKVtXRMcRsMuic7fOY07X7gGgUE0wshhL6lG2PP7N7Px8Z+H4XW7AnzYW/X2pqHmFdXaFqUuu8t+Yms8fHD11nFK0bfmMRhygo1BVl1jvRQDKDr1K9Y0Wxf9XNGZXeymLEWDekaeGiRDJPjgDlcCkpVv8IJ3SDZgrmOoAHZx3zNOPh7XX0RvvfpzhbI9GfFfuyRbokJKP4fzmnD/dxsJu3x4EEB44lk6Z5NmWBY5Ts5HDsXCEDYIhuEfH0yMeArszPUBAgeM8i3ca6s2HOYPXa1G+KATOlhj4tsDtTMsjXpZImmkdqD/dOeWcTGpTmDGmld9PGbSFqv0hQjmVg=="

response.write verifyPayment.verify
%>


## 4) Verificar Estado de una cuenta khipu

Este servicio permite consultar el estado de una cuenta khipu, la cual retorna
un json mencionando el ambiente en que se encuentra y si puede recibir pagos.
A continuación un ejemplo:

<!-- #include file = "Khipu.asp" -->
<%
Dim kh : Set kh = new Khipu
kh.authenticate ID_DEL_COBRADOR, SECRET_DEL_COBRADOR

Dim receiverStatus :  Set receiverStatus = kh.loadService("ReceiverStatus")

Response.Write("<p>" & receiverStatus.consult() & "</p>")
%>

## 5) Marcar un cobro como pagado.
Este servicio permite marcar un cobro como pagado y es util cuando el pago 
se realizó directamente al cobrador, sin pasar pot khipu
A continuación un ejemplo:

<!-- #include file = "Khipu.asp" -->
<%
Dim kh : Set kh = new Khipu
kh.authenticate ID_DEL_COBRADOR, SECRET_DEL_COBRADOR

Dim setPayedByReceiver :  Set setPayedByReceiver = kh.loadService("SetPayedByReceiver")	
setPayedByReceiver.setParameter "payment_id"     , "9fnsgglqi8ho"

response.write setPayedByReceiver.setPayed()
%>

## 6) Marcar un cobro como expirado.
Este servicio permite adelantar la expiración del cobro, que puede tener muchos pagos asociados.
Está pensado para ser ejecutado por el cobrador.
A continuación un ejemplo:

<!-- #include file = "Khipu.asp" -->
<%
Dim kh : Set kh = new Khipu
kh.authenticate ID_DEL_COBRADOR, SECRET_DEL_COBRADOR

Dim setBillExpired :  Set setBillExpired = kh.loadService("SetBillExpired")	
setBillExpired.setParameter "bill_id"     , "udmEe"
setBillExpired.setParameter "text"        , "Plazo vencido, se generó un nuevo cobre"

Response.Write("<p>" & setBillExpired.expire() & "</p>")
%>

## 7) Marcar un cobro como rechazado.
Este servicio permite rechazar pago con el fin de inhabilitarlo.
Está pensado para ser ejecutado por el pagador.
A continuación un ejemplo:

<!-- #include file = "Khipu.asp" -->
<%
Dim kh : Set kh = new Khipu
kh.authenticate ID_DEL_COBRADOR, SECRET_DEL_COBRADOR

Dim setRejectedByPayer :  Set setRejectedByPayer = kh.loadService("SetRejectedByPayer")	
setRejectedByPayer.setParameter "payment_id"     , "9fnsgglqi8ho"
setRejectedByPayer.setParameter "text"           , "Cobro incorrecto"  

response.write setRejectedByPayer.reject()
%>

