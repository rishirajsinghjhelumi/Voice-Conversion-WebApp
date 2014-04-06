
<%include file="header.mako"/>

<div class="grid">
	<div class="row" style="display:flex;">
		<div class="span5">
			<div class="accordion" data-role="accordion">

			    <div class="accordion-frame">
			        <a href="#" class="heading">Completed Training</a>
			        <div class="content">
			        	<nav class="sidebar (light)">
				        	<ul id="users_completed_training" class="accordian-list" >						    
							</ul>
						</nav>
			        </div>
			    </div>

			    <div class="accordion-frame">
			        <a href="#" class="heading">Users Trained With</a>
			        <div class="content">
				        <nav class="sidebar (light)">
				        	<ul id="users_trained_with"  class="accordian-list">						    
							</ul>
				        </nav>
			        </div>
			    </div>

			    <div class="accordion-frame">
			        <a href="#" class="heading">Converted Voices</a>
			        <div class="content">
				        <nav class="sidebar (light)">
				        	<ul id="converted voices" class="accordian-list" >						    
							</ul>
						</nav>
			        </div>
			    </div>
			</div>
		</div>
		
		<div id='text-display' class="span11">
			<div class="notice marker-on-left span10" id="notice-info-default">
				Please Choose a Paragraph. 
			</div>
		</div>
	</div>
</div>

<%include file="footer.mako"/>

<script>
$(document).ready(function() {

	var voiceConversion = new VC();
	voiceConversion.initializeUsers();

});
</script>

</body>
</html>