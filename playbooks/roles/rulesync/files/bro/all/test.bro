@load base/frameworks/notice

export {
  redef enum Notice::Type += {
    Test
  };
}

event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count)
{
  local n: Notice::Info = Notice::Info(
    $note=Test,
    $msg="Hello, world!"
    );
  NOTICE(n);
}
