##! Add country codes for the originator and responder to each connection in the conn log.

redef record Conn::Info += {
	orig_cc: string &log &optional;
	resp_cc: string &log &optional;
};

event connection_state_remove(c: connection)
	{
	local orig_loc = lookup_location(c$id$orig_h);
	if ( orig_loc?$country_code )
		c$conn$orig_cc = orig_loc$country_code;

	local resp_loc = lookup_location(c$id$resp_h);
	if ( resp_loc?$country_code )
		c$conn$resp_cc = resp_loc$country_code;
	}