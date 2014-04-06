
<%include file="header.mako"/>

<div class="grid">
	<div class="row" style="display:flex;">
		<div class="span5">
			<div class="accordion" data-role="accordion">

			    <div class="accordion-frame">
			        <a href="#" class="heading">Completed Training</a>
			        <div class="content">
			        	<nav class="sidebar (light)">
				        	<ul id="users_completed_training" >						    
							</ul>
						</nav>
			        </div>
			    </div>

			    <div class="accordion-frame">
			        <a href="#" class="heading">Users Trained With</a>
			        <div class="content">
				        <nav class="sidebar (light)">
				        	<ul id="users_trained_with" >						    
							</ul>
				        </nav>
			        </div>
			    </div>

			    <div class="accordion-frame">
			        <a href="#" class="heading">Converted Voices</a>
			        <div class="content">
				        <nav class="sidebar (light)">
				        	<ul id="converted voices" >						    
							</ul>
						</nav>
			        </div>
			    </div>
			</div>
		</div>
		<span id="empty">     </span>
		<div id='text-display'>
			<div class="notice marker-on-left span10" id="notice-info-default">
				Please Choose a Paragraph. 
			</div>
		</div>
	</div>
</div>

<%include file="footer.mako"/>		

<script src="static/js/users.js"></script>

<script>

</script>

</body>
</html>