##! This script reconfigures some of the builtin Bro scripts to suit certain SecurityOnion uses.

redef Notice::emailed_types += { BPFConf::InvalidFilter };

