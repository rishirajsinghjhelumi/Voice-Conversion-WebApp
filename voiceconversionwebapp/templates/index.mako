<%include file="header.mako"/>

<div class="grid show-grid">
	<div class="row">
		
		<div class="span7">
			<div class="sign_in_form">
				<form action="/login" method="POST">
					<fieldset>
						<legend>Sign In</legend>
						<label>Your email</label>
						<div class="input-control text" data-role="input-control">
							<input type="text" placeholder="type your email" name="email">
							<button class="btn-clear" tabindex="-1" type="button"></button>
						</div>
						<label>Your Password</label>
						<div class="input-control password" data-role="input-control">
							<input type="password" placeholder="type password" autofocus="" name="password">
							<button class="btn-reveal" tabindex="-1" type="button"></button>
						</div>
						<input type="submit" value="Login" class="emerald-flat-button">
					</fieldset>
				</form>
			</div>
		</div>
		<div class="span7">
			<div class="sign_up_form">
				<form action="/register" method="POST">
					<fieldset>
						<legend>Sign Up</legend>
						<label>Your email</label>
						<div class="input-control text" data-role="input-control">
							<input type="text" placeholder="type your email" name="email">
							<button class="btn-clear" tabindex="-1" type="button"></button>
						</div>
						<label>Your username</label>
						<div class="input-control text" data-role="input-control">
							<input type="text" placeholder="type your username" name="name">
							<button class="btn-clear" tabindex="-1" type="button"></button>
						</div>
						<label>Your Password</label>
						<div class="input-control password" data-role="input-control">
							<input type="password" placeholder="type password" autofocus="" name="password">
							<button class="btn-reveal" tabindex="-1" type="button"></button>
						</div>
						<input type="submit" class="peter-river-flat-button" value="Sign Up">
					</fieldset>
				</form>
			</div>
		</div>
	</div>
</div>

<%include file="footer.mako"/>		


</body>
</html>