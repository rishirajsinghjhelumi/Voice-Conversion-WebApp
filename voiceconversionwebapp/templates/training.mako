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
		<div id='text-display'>
			<div class="notice marker-on-left span11" id="notice-text-default">
				Please Choose a Paragraph. 
			</div>
		</div>
	</div>
</div>

<%include file="footer.mako"/>
<script src="static/js/recorder.js"></script>
<script src="static/js/paragraph.js"></script>

<script>

</script>

</body>
</html>