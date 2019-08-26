
from net import Socket, new_socket

import settings_handler


type S = object
    running:bool

    body_maxlen:int
    forcefully_take_port:bool
    header_maxlen:int
    listen:int32
    no_new_connection_delay:int
    port:int
    send_file_chunk:int
    sock:Socket
    ssl:bool
    time_to_recive_body:int
    time_to_recive_header:int

proc body_maxlen*(s:var S):int= s.body_maxlen
proc forcefully_take_port*(s:var S):bool= s.forcefully_take_port
proc header_maxlen*(s:var S):int= s.header_maxlen
proc listen*(s:var S):int= s.listen
proc no_new_connection_delay*(s:var S):int= s.no_new_connection_delay
proc port*(s:var S):int= s.port
proc send_file_chunk*(s:var S):int= s.send_file_chunk
proc ssl*(s:var S):bool= s.ssl
proc time_to_recive_body*(s:var S):int= s.time_to_recive_body
proc time_to_recive_header*(s:var S):int= s.time_to_recive_header


proc `body_maxlen=`*(s:var S,new:int)=
    if new != s.body_maxlen:
        if new <= 0:
            echo "You cant set the 'body maxlen' to 0 or bellow"
            quit(1)
        s.body_maxlen= new
        w_int("body maxlen", new)
proc `forcefully_take_port=`*(s:var S, new:bool)=
    if new != s.forcefully_take_port:
        s.forcefully_take_port= new
        w_bool("forcefully take port", new)
proc `header_maxlen=`*(s:var S,new:int)=
    if new != s.header_maxlen:
        if new <= 0:
            echo "You cant set the 'header maxlen' to 0 or bellow"
            quit(1)
        s.header_maxlen= new
        w_int("header maxlen", new)
proc `listen=`*(s:var S, new:int32)=
    if new != s.listen:
        if new <= 0:
            echo "You cant reduce the 'listen' waitlist to 0 or less members"
            quit(1)
        s.listen= new
        w_int32("listen", new)
proc `no_new_connection_delay=`*(s:var S,new:int)=
    if new != s.no_new_connection_delay:
        s.no_new_connection_delay= new
        w_int("no new connection delay", new)
proc `port=`*(s:var S, new:int)=
    if new != s.port:
        s.port= new
        w_int("port",new)
proc `send_file_chunk=`*(s:var S, new:int)=
    if new != s.send_file_chunk:
        s.send_file_chunk= new
        w_int("send file chunk",new)
proc `ssl=`*(s:var S, new:bool)=
    if new != s.ssl:
        s.ssl= new
        w_bool("ssl",new)
proc `time_to_recive_body=`*(s:var S, new:int)=
    if new != s.time_to_recive_body:
        if new == 0:
            echo "0 milliseconds isnt enough time to recive a body"
            quit(1)
        s.time_to_recive_body= new
        w_int("time to recive body", new)
proc `time_to_recive_header=`*(s:var S, new:int)=
    if new != s.time_to_recive_header:
        if new == 0:
            echo "0 milliseconds isnt enough time to recive a header"
            quit(1)
        s.time_to_recive_header= new
        w_int("time to recive header", new)


proc new_server*:S=
    result= S()
    result.running= true
    
    result.body_maxlen= r_int("body maxlen")
    result.forcefully_take_port= r_bool("forcefully take port")
    result.header_maxlen= r_int("header maxlen")
    result.listen= r_int32("listen")
    result.no_new_connection_delay= r_int("no new connection delay")
    result.port= r_int("port")
    result.send_file_chunk= r_int("send file chunk")
    result.sock= new_socket()
    result.ssl= r_bool("ssl")
    result.time_to_recive_body= r_int("time to recive body")
    result.time_to_recive_header= r_int("time to recive header")



include user

include start_server_proc

