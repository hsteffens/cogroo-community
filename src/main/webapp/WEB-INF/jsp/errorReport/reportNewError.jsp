<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script src="<c:url value='/js/jquery-fieldselection.js' />" type="text/javascript" ></script>

<script type="text/javascript" charset="utf-8">

$(document).ready(function() {
    
  var count=0;
  
  // Webkit bug: can't use select if textarea is readonly
  	if ($.browser.webkit) {
  		$("#selector").removeAttr( "readonly" )
	 }
  
  $('#addNewOmission').click(function() {
	count++;
	
	var input = $("#selector");
    
    var range = input.getSelection();
    
     if(range.end > 0 && range.start != range.end) {
    	var text = input.text();
        
        var selection = text.substr(range.start, range.end - range.start);
        var before = text.substr(0, range.start);
        var after = text.substr(range.end);
        
        
        
        var html = $('#toCopy').children('div').clone();
        // Formatando novo input
        $(html).find('div.#omission').html( before + '<span class="omission">' + selection + '</span>' + after);
        $(html).find('h3').text( 'Omissão ' + count + ':');
        $(html).find('select').attr('name','omissionClassification[' + count +']').
        	attr('ONCHANGE',"if( 'custom' == this.options[this.selectedIndex].value ) {on('customOmissionTextDiv_" + count + "');} else {off('customOmissionTextDiv_" + count + "');} ;");
        $(html).find('#customOmissionText').attr('name','customOmissionText[' + count +']');
        
        $(html).find('#omissionStart').attr('name','omissionStart[' + count +']');
        $(html).find('#omissionEnd').attr('name','omissionEnd[' + count +']');
        $(html).find('#omissionStart').attr('value',range.start);
        $(html).find('#omissionEnd').attr('value',range.end);
        $(html).find('#omissionComment').attr('name','omissionComment[' + count +']');
        $(html).find('#omissionReplaceBy').attr('name','omissionReplaceBy[' + count +']');
        $(html).find('#customOmissionTextDiv').attr('id','customOmissionTextDiv_' + count);
         
         $('#omissionList').append(html);
    } 
    
    
  });
  
$('#b').click(function() {     
  alert(getSelection());
});

});
</script>

<p>
	Bem-vindo ao formulário de avaliação do corretor gramatical CoGrOO. Obrigado por sua colaboração, que é importante para o aprimoramento da ferramenta.
</p>
<p>
	Ao submeter textos, sempre tome cuidado para não enviar conteúdo confidencial. Você deve concordar em licenciar o texto submetido sob os termos da <a target="_blank" href="http://www.gnu.org/licenses/lgpl-3.0-standalone.html">LGPL</a>, tornando o publico.
</p>

<br/>

<c:if test="${empty text}">
	<legend>Digite um texto para verificar o comportamento do CoGrOO:</legend>
	<form id="formSendErrorText"  action="<c:url value="/reportNewErrorAddText"/>" method="post" >
	    <textarea rows="4" cols="70" name="text">${text}</textarea>
	    <input type="submit" value="Enviar" id="sendErrorText"/>
	</form>
</c:if>
<c:if test="${not empty text}">
	<legend>Texto digitado:</legend>
	<div class="analise_text">
		<p><b>${annotatedText}</b></p>
	</div>
	
	<form id="report"  action="<c:url value="/reportNewError"/>" method="post" >
	
		<input type="hidden" id="userText" name="text" value="${text}"/>
	
		<h2>Intervenções indevidas</h2>
		
		<p>Algumas vezes o CoGrOO pode errar ao apontar um texto como errado, chamamos isto de intervenção indevida. Aqui você pode classificar uma intervenção do CoGrOO como:</p>
		
		<DL>
			<DT><STRONG>Falso erro</STRONG></DT>
				<DD>Não existe erro, o verificador apontou este erro inapropriadamente.</DD>
			<DT><STRONG>Classificação inapropriada</STRONG></DT>
				<DD>O erro existe, mas está classificado de forma errada.</DD>
			<DT><STRONG>Sugestão inapropriada</STRONG></DT>
				<DD>O erro existe e está classificado corretamente, mas nenhuma das sugestões indicadas está correta.</DD>
		</DL>
		
		<c:if test="${empty singleGrammarErrorList}">
			<p><strong>Não foram emcontrados erros no texto.</strong></p>
		</c:if>
		<c:if test="${not empty singleGrammarErrorList}">
			<c:forEach items="${singleGrammarErrorList}" var="singleGrammarError" varStatus="i">
				
				<h3>Intervenção ${ i.count }:</h3>
					<div class="analise_text">
						<p><b>${singleGrammarError.annotatedText}</b></p>
					</div>
					
					<DL>
						<DT><STRONG>Sugestões:</STRONG></DT>
							<DD>
								<c:forEach items="${singleGrammarError.mistake.suggestions}" var="suggestion">
									${suggestion};&nbsp;
								</c:forEach>
							</DD>
						<DT><STRONG>Mensagem curta:</STRONG></DT>
							<DD>${singleGrammarError.mistake.shortMessage}</DD>
						<DT><STRONG>Mensagem longa:</STRONG></DT>
							<DD>${singleGrammarError.mistake.longMessage}</DD>
					</DL>
					
					<legend>Classifique esta intervenção:</legend><br/>
					<select name="badint[${ i.count }]" 
						ONCHANGE="if( this.selectedIndex == 0 ) {off('comments_${ i.count }');} else {on('comments_${ i.count }');} ;">
						<option value="ok">Intervenção correta.</option>
						<option value="falseError">Falso erro, a frase está correta.</option>
						<option value="inappropriateDescription">Erro existe, mas sua descrição foi inapropriada.</option>
						<option value="inappropriateSuggestion">Erro existe, mas a sugestão é inapropriada.</option>
					</select>
	
					<div style="display: none;" id="comments_${ i.count }">
						Comentários:
						<br><textarea rows="4" cols="70" name="comments[${ i.count }]"></textarea>
					</div>
					<input type="hidden" id="badintStart" name="badintStart[${ i.count }]" value="${singleGrammarError.mistake.start}" />
					<input type="hidden" id="badintEnd" name="badintEnd[${ i.count }]" value="${singleGrammarError.mistake.end}" />
					<input type="hidden" id="badintRule" name="badintRule[${ i.count }]" value="${singleGrammarError.mistake.ruleIdentifier}" />
			</c:forEach>
		
		</c:if>
		<h2>Omissões</h2>
		<p>Aqui você pode indicar os erros gramaticais que foram ignorados pelo CoGrOO.</p>
		
		<div id="omissionList">
		</div>
		<fieldset>
		<legend>Nova omissão:</legend>
		<p>Para indicar uma nova omissão, selecione com o cursor o texto com erro e clique "Indicar nova omissão".</p>
		
		Selecione a omissão:<br/>
		<textarea rows="2" cols="70" readonly="readonly" id="selector" >${text}</textarea><br/>
		<!--  <a class="a_button" id="addNewOmission">Indicar nova omissão</a>-->
		<button type="button" id="addNewOmission" class="a_button">Indicar nova omissão</button>
		</fieldset>
		<div id="toCopy" style="display:none;">
		 	<div>
				<h3 id="omissionHeader">Omissão X:</h3>
				<div class="analise_text" id="omission">
					
				</div>
				Classifique esta omissão:<br/>
				<select name="dummyName"
					ONCHANGE="dummy">
					<c:forEach items="${omissionCategoriesList}" var="omissionCategories">
						<option value="${omissionCategories}">${omissionCategories}</option>
					</c:forEach>
					<option value="custom">Personalizada</option>
				</select><br/>
				<div style="display: none;" id="customOmissionTextDiv">
					Classificação personalizada:<br/>
			      	<input width="300" id="customOmissionText" name="dummyOmissionText"></input><br/>
		      	</div>
				Substituir por:<br/>
		      	<input width="300" id="omissionReplaceBy" name="dummyOmissionReplaceBy"></input><br/>
		      	Comentários:<br/>
		      	<textarea rows="1" cols="70" id="omissionComment" name="dummyOmissionComment"></textarea>
		      	<input type="hidden" id="omissionStart" name="dummyOmissionStart" value=""/>
		      	<input type="hidden" id="omissionEnd" name="dummyOmissionStart" value=""/>
		    </div>
		</div>
		
		<br/>
		<input type="submit" value="Enviar relatório" id="sendError"/>
	</form>
</c:if>