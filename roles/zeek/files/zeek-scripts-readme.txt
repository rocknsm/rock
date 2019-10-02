
It is recommended to put zeek scripts in individual directories and use __load__.zeek files.

Example:
directory = scripts/something
script = scripts/something/something.zeek
loader = scripts/something/__load__.zeek

Then in your custom.local.zeek you can @load scripts/something
