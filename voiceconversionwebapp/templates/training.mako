<%include file="header.mako"/>

<div class="grid">
	<div class="row" style="display:flex;">
		<div class="span4">
			<nav class="sidebar (light)">	
				<ul>
					<li class="unread">Paragraphs</li>						
				</ul>
				<ul id="paragraphs" >						    
				</ul>						  
			</nav>
		</div>
		<div id='text-display' class="span11">
			<div class="notice marker-on-left" id="notice-text-default">
				Please Choose a Paragraph. 
			</div>
		</div>
	</div>
</div>

<%include file="footer.mako"/>

<script>
$(document).ready(function() {

	var voiceConversion = new VC();
	voiceConversion.initializeParagraphs();

});

</script>

</body>
</html>