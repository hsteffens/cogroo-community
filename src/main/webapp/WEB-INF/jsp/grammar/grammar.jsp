		
		
		<h1>Analisador Gramatical.</h1>
		<p>Digite o texto em portugu�s para verificar sua an�lise:</p>
		<form action="<c:url value="/grammar"/>"  method="post" >
		    <textarea rows="4" cols="70" name="text">${text}</textarea>
		    <br/>
		    <input type="submit" value="Processar" id="go"/>
		</form>
		
		<c:if test="${not empty text}">
			<form id="formSendErrorText"  action="<c:url value="/reportNewErrorAddText"/>" method="post" >
			    <input type="hidden" name="text" value="${text}" />
			    <input type="submit" value="Reportar erro" id="sendErrorText"/>
			</form>
		</c:if>

<jsp:include page="/analysisdetails.jspf" />