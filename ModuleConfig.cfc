/**
 * I am a ColdBox module that adds a host header to the response to show the host of the server creating the response. This is very useful in cluster setups or docker swarms.
 */
component {

	this.name = "versionHeader";
	this.author = "Gavin Pickin";
	this.webUrl = "https://github.com/gpickin/versionHeader";

	function configure() {

	}

	/**
	 * This function is the core of the Version header module. This fires on onRequestCapture and adds the version of the app to the event headers with the key X-Server-Version
	 * @event
	 * @interceptData
	 * @buffer
	 * @rc
	 * @prc
	 */
	function onRequestCapture( event, interceptData, buffer, rc, prc ) {

		var appVersion = "";
		if( structKeyExists( server, "x_version" ) and len( server.x_version ) ){
			appVersion = server.x_version;
		}
		if( !len( appVersion ) ){
			try {
				appVersion = fileRead( '.version' );
			} catch ( any e ){
				var appVersionFileError = e.message;
			}
		}
		server.x_version = appVersion;

		if ( isCachedEvent( event ) ) {
			return;
		}

		event.setHTTPHeader( name = "x-server-version", value = appVersion );
	}

	private function isCachedEvent( event ) {
		return structKeyExists( event.getEventCacheableEntry(), "cacheKey" ) &&
			getController().getCache( "template" ).lookup( event.getEventCacheableEntry().cacheKey );
	}
}