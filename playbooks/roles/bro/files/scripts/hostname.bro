module SecurityOnion;

@load base/frameworks/input

export {
    ## Event to capture when the hostname is discovered.
    global SecurityOnion::found_hostname: event(hostname: string);

    ## Hostname for this box.
    global hostname = "";

    type HostnameCmdLine: record { s: string; };
}

event SecurityOnion::hostname_line(description: Input::EventDescription, tpe: Input::Event, s: string)
    {
    hostname = s;
    event SecurityOnion::found_hostname(hostname);
    Input::remove(description$name);
    }   

event bro_init() &priority=5
    {
    Input::add_event([$source="hostname |",
                      $name="SO-hostname",
                      $reader=Input::READER_RAW,
                      $want_record=F,
                      $fields=HostnameCmdLine,
                      $ev=SecurityOnion::hostname_line]);
    }   